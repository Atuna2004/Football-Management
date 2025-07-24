package controller.ChatBot;

import connect.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.io.entity.StringEntity;
import org.apache.hc.core5.http.ClassicHttpResponse;
import org.apache.hc.core5.http.ContentType;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class ChatBotServlet extends HttpServlet {

    String baseSchemaPrompt
            = "Hãy đóng vai một trợ lý AI có quyền truy cập trực tiếp vào cơ sở dữ liệu quản lý đặt sân bóng, "
            + "và giả định rằng dữ liệu đã tồn tại trong hệ thống. "
            + "Khi tôi đặt câu hỏi, bạn chỉ cần trả về dữ liệu giả định hợp lý, "
            + "không trả về câu lệnh SQL. "
            + "Dữ liệu cần chính xác và hợp lý dựa trên cấu trúc bảng đã mô tả trước đó. "
            + "Nếu không có đủ thông tin, hãy tự tạo ra dữ liệu mẫu để minh họa, "
            + "nhưng không cần giải thích hay viết SQL, chỉ trả về dữ liệu mà thôi. "
            + "Nếu kết quả là danh sách, hãy trả về dạng bảng rõ ràng. "
            + "Nếu kết quả là một giá trị cụ thể, hãy trả về chính xác giá trị đó. "
            + "Nếu cần làm rõ thêm, hãy hỏi lại tôi.";

    private static final String API_KEY = "AIzaSyBoPtmjWGYHcT9IWpmKiwkWwP-gOzNuSHM";

    private static final String GEMINI_URL
            = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key="
            + API_KEY;

    @Override

    public void init() throws ServletException {
        ServletContext context = getServletContext();
        InputStream is = null;
        try {
            is = context.getResourceAsStream("/WEB-INF/schema.txt");
            if (is != null) {
                baseSchemaPrompt = new String(is.readAllBytes(), StandardCharsets.UTF_8);
            }
        } catch (IOException e) {
            throw new ServletException("Không đọc được schema.txt", e);
        } finally {
            if (is != null) try {
                is.close();
            } catch (IOException ignored) {
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String userMessage = request.getParameter("message");
        String botReply = "";

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

                // Ngăn chặn câu hỏi trái phép
                String[] forbiddenKeywords = {
                    "doanh thu", "lợi nhuận", "thu nhập",
                    "thống kê", "tài khoản người dùng",
                    "admin", "quản trị", "chủ sân",
                    "quản lý", "field owner",
                    "sql", "cấu trúc bảng", "bảng dữ liệu",
                    "hệ thống", "backend"
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
                    // gọi Gemini
                    ObjectMapper mapper = new ObjectMapper();
                    String jsonRequest = mapper.writeValueAsString(
                            new GeminiRequest(
                                    new Content[]{
                                        new Content(new Part[]{new Part(finalPrompt + "\n\nCâu hỏi: " + userMessage)})
                                    }
                            )
                    );

                    try (CloseableHttpClient client = HttpClients.createDefault()) {
                        HttpPost post = new HttpPost(GEMINI_URL);
                        post.setHeader("Content-Type", "application/json");
                        post.setEntity(new StringEntity(jsonRequest, ContentType.APPLICATION_JSON));

                        ClassicHttpResponse httpResponse = (ClassicHttpResponse) client.execute(post);

                        int status = httpResponse.getCode();
                        InputStream in = httpResponse.getEntity().getContent();
                        String body = new String(in.readAllBytes(), StandardCharsets.UTF_8);

                        if (status == 200) {
                            JsonNode root = mapper.readTree(body);
                            JsonNode textNode = root.at("/candidates/0/content/parts/0/text");
                            botReply = textNode.isMissingNode()
                                    ? "Xin lỗi, tôi không hiểu câu hỏi."
                                    : textNode.asText();
                        } else {
                            botReply = "Lỗi gọi Gemini (HTTP " + status + "): " + body;
                        }
                    }
                }
            } catch (Exception e) {
                botReply = "Lỗi hệ thống: " + e.getMessage();
            }
        }

        try (PrintWriter out = response.getWriter()) {
            out.print("{\"reply\":\"" + escapeJson(botReply) + "\"}");
        }
    }

    private String getStadiumList() {
        StringBuilder result = new StringBuilder();
        result.append("**Danh sách sân bóng hiện có:**\n\n");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("SELECT Name, Location, PhoneNumber FROM Stadium WHERE Status = 'Available'"); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                result.append("* **")
                        .append(rs.getString("Name"))
                        .append("** - ")
                        .append(rs.getString("Location"))
                        .append(" (")
                        .append(rs.getString("PhoneNumber"))
                        .append(")\n");
            }

        } catch (SQLException e) {
            result.append("Xin lỗi, không thể lấy danh sách sân bóng do lỗi hệ thống: ")
                    .append(e.getMessage());
        }
        return result.toString();
    }

    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "")
                .replace("\t", "\\t")
                .replace("\f", "\\f");
    }

    public static class GeminiRequest {

        public Content[] contents;

        public GeminiRequest(Content[] contents) {
            this.contents = contents;
        }
    }

    public static class Content {

        public Part[] parts;

        public Content(Part[] parts) {
            this.parts = parts;
        }
    }

    public static class Part {

        public String text;

        public Part(String text) {
            this.text = text;
        }
    }
}
