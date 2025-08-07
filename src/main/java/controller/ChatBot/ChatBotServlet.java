package controller.ChatBot;

import config.ConfigAPIKey;
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

    private String baseSchemaPrompt = "";

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

        String finalPrompt = "Bạn là một trợ lý ảo của nền tảng SmartPitch... Dưới đây là thông tin về cơ sở dữ liệu của website."
                + baseSchemaPrompt + "\n Hãy giới thiệu dịch vụ của chúng tôi cho khách hàng với câu hỏi của họ là:";
        if (userMessage == null || userMessage.trim().isEmpty()) {
            botReply = "Xin vui lòng nhập tin nhắn.";
        } else {
            try {
                String lowerMsg = userMessage.toLowerCase();


                String[] forbiddenKeywords = {
                        "doanh thu", "lợi nhuận", "thống kê", "tài khoản người dùng", "người dùng",
                        "admin", "quản trị", "chủ sân", "quản lý", "field owner", "liệt kê",
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
                    botReply = "Xin lỗi, tôi không thể cung cấp thông tin về người dùng hoặc các dữ liệu nội bộ khác.";
                } else if (lowerMsg.contains("danh sách sân") || lowerMsg.contains("sân nào")) {
                    botReply = getStadiumList();
                } else {
                    String apiKey = ConfigAPIKey.getProperty("gemini.api.key");
                    String geminiUrl = ConfigAPIKey.getProperty("gemini.base.url") + "?key=" + apiKey;

                    ObjectMapper mapper = new ObjectMapper();
                    String jsonRequest = mapper.writeValueAsString(
                            new GeminiRequest(new Content[]{new Content(new Part[]{new Part(finalPrompt + "\n\nCâu hỏi: " + userMessage)})})
                    );

                    try (CloseableHttpClient client = HttpClients.createDefault()) {
                        HttpPost post = new HttpPost(geminiUrl);
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
                    } catch (Exception e) {
                        botReply = "Lỗi hệ thống: " + e.getMessage();
                        e.printStackTrace();
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
        result.append("<p><b>Danh sách sân bóng hiện có:</b></p><ul>");

        // === THAY ĐỔI 2: SỬA LẠI TRẠNG THÁI TÌM KIẾM ===
        String sql = "SELECT Name, Location, PhoneNumber FROM Stadium WHERE Status = 'active'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (!rs.isBeforeFirst()) {
                return "Xin lỗi, hiện tại không có sân bóng nào đang hoạt động.";
            }

            while (rs.next()) {
                result.append("<li>")
                        .append("<b>").append(rs.getString("Name")).append("</b> - ")
                        .append(rs.getString("Location"))
                        .append(" (SĐT: ").append(rs.getString("PhoneNumber")).append(")")
                        .append("</li>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "Xin lỗi, không thể lấy danh sách sân bóng do lỗi hệ thống.";
        }

        result.append("</ul>");
        return result.toString();
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
//                .replace("\n", "<br>")
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