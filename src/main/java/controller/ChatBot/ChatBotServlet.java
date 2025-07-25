package controller.ChatBot;

import config.ConfigAPIKey; // Thêm import lớp Config
import connect.DBConnection;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ClassicHttpResponse;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.io.entity.StringEntity;

public class ChatBotServlet extends HttpServlet {

    private String baseSchemaPrompt = "Hãy đóng vai một trợ lý AI..."; // Default prompt

    // === ĐÃ XÓA CÁC HẰNG SỐ API_KEY VÀ GEMINI_URL HARD-CODE ===

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        try (InputStream is = context.getResourceAsStream("/WEB-INF/schema.txt")) {
            if (is != null) {
                baseSchemaPrompt = new String(is.readAllBytes(), StandardCharsets.UTF_8);
            }
        } catch (IOException e) {
            throw new ServletException("Không đọc được schema.txt", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String userMessage = request.getParameter("message");
        String botReply;

        String finalPrompt
                = "Bạn là một trợ lý ảo của nền tảng SmartPitch, chuyên hỗ trợ người dùng là **khách hàng (Customer)** trong việc:\n"
                + "- Tìm kiếm và đặt sân bóng\n"
                + "- Xem khung giờ trống\n"
                + "- Hỏi về chương trình khuyến mãi\n"
                + "- Hỏi về đồ ăn (**chỉ khi đã đặt sân**)\n"
                + "- Hỏi về thông tin giải đấu\n\n"
                + "⚠️ **Không được trả lời bất kỳ câu hỏi nào** liên quan đến:\n"
                + "- Doanh thu, thống kê, hệ thống nội bộ\n"
                + "- Thông tin tài khoản người khác, thông tin quản trị\n"
                + "- Quyền quản lý của Admin hoặc Chủ sân\n"
                + "- Cấu trúc dữ liệu, bảng, SQL, hệ thống backend\n\n"
                + "Nếu người dùng hỏi về đồ ăn mà chưa đặt sân, hãy trả lời: "
                + "\"Để xem thực đơn đồ ăn, bạn cần đặt sân trước vì mỗi sân có thực đơn riêng.\"\n\n"
                + "Luôn thân thiện, lịch sự, ngắn gọn, và chỉ trả lời trong phạm vi dịch vụ của khách hàng.\n\n"
                + "Dưới đây là dữ liệu cơ sở dữ liệu tham khảo:\n\n"
                + baseSchemaPrompt;

        if (userMessage == null || userMessage.trim().isEmpty()) {
            botReply = "Xin vui lòng nhập tin nhắn.";
        } else {
            try {
                String lowerMsg = userMessage.toLowerCase();
                String[] forbiddenKeywords = {
                        "doanh thu", "lợi nhuận", "thống kê", "tài khoản người dùng",
                        "admin", "quản trị", "chủ sân", "quản lý", "field owner",
                        "sql", "cấu trúc bảng", "bảng dữ liệu", "hệ thống", "backend"
                };

                boolean isForbidden = false;
                for (String keyword : forbiddenKeywords) {
                    if (lowerMsg.contains(keyword)) {
                        isForbidden = true;
                        break;
                    }
                }

                if (isForbidden) {
                    botReply = "Bạn không có thẩm quyền để hỏi những câu hỏi này.";
                } else if (lowerMsg.contains("danh sách sân") || lowerMsg.contains("sân nào") || lowerMsg.contains("liệt kê sân")) {
                    botReply = getStadiumList();
                } else {
                    // === ĐỌC API KEY TỪ FILE CONFIG ===
                    String apiKey = ConfigAPIKey.getProperty("gemini.api.key");
                    String geminiUrl = ConfigAPIKey.getProperty("gemini.base.url") + apiKey;
                    // ===================================

                    ObjectMapper mapper = new ObjectMapper();
                    String jsonRequest = mapper.writeValueAsString(
                            new GeminiRequest(new Content[]{new Content(new Part[]{new Part(finalPrompt + "\n\nCâu hỏi: " + userMessage)})})
                    );

                    try (CloseableHttpClient client = HttpClients.createDefault()) {
                        HttpPost post = new HttpPost(geminiUrl); // Sử dụng URL mới
                        post.setHeader("Content-Type", "application/json");
                        post.setEntity(new StringEntity(jsonRequest, ContentType.APPLICATION_JSON));

                        ClassicHttpResponse httpResponse = (ClassicHttpResponse) client.execute(post);
                        int status = httpResponse.getCode();
                        String body = new String(httpResponse.getEntity().getContent().readAllBytes(), StandardCharsets.UTF_8);

                        if (status == 200) {
                            JsonNode root = mapper.readTree(body);
                            JsonNode textNode = root.at("/candidates/0/content/parts/0/text");
                            botReply = textNode.isMissingNode() ? "Xin lỗi, tôi không hiểu câu hỏi." : textNode.asText();
                        } else {
                            botReply = "Lỗi gọi Gemini (HTTP " + status + "): " + body;
                        }
                    }
                }
            } catch (Exception e) {
                botReply = "Lỗi hệ thống: " + e.getMessage();
                e.printStackTrace();
            }
        }

        try (PrintWriter out = response.getWriter()) {
            out.print("{\"reply\":\"" + escapeJson(botReply) + "\"}");
        }
    }

    private String getStadiumList() {
        StringBuilder result = new StringBuilder();
        result.append("**Danh sách sân bóng hiện có:**\n\n");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT Name, Location, PhoneNumber FROM Stadium WHERE Status = 'Available'");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                result.append("* **").append(rs.getString("Name")).append("** - ")
                        .append(rs.getString("Location")).append(" (")
                        .append(rs.getString("PhoneNumber")).append(")\n");
            }

        } catch (SQLException e) {
            result.append("Xin lỗi, không thể lấy danh sách sân bóng do lỗi hệ thống.");
            e.printStackTrace();
        }
        return result.toString();
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "")
                .replace("\t", "\\t")
                .replace("\f", "\\f");
    }

    // Các lớp con để tạo JSON request cho Gemini
    public static class GeminiRequest {
        public Content[] contents;
        public GeminiRequest(Content[] contents) { this.contents = contents; }
    }
    public static class Content {
        public Part[] parts;
        public Content(Part[] parts) { this.parts = parts; }
    }
    public static class Part {
        public String text;
        public Part(String text) { this.text = text; }
    }
}