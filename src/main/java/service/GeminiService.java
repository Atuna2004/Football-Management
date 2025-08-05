package service;

import config.ConfigAPIKey;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
import javax.net.ssl.HttpsURLConnection;

public class GeminiService {

    private final String apiUrl = ConfigAPIKey.getProperty("gemini.base.url");
    private final String apiKey = ConfigAPIKey.getProperty("gemini.api.key");

    public String improveTournamentDescription(String nameTournament, String description, String totalTeams, String award) throws IOException {
        String urlStr = apiUrl + "?key=" + apiKey;
        URL url = new URL(urlStr);
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        // Prompt cho Gemini
        String prompt = "Bạn là chủ sân bóng đá chuyên nghiệp. Hãy giúp tôi cải thiện tên giải đấu và mô tả cho một giải bóng đá để thu hút nhiều người biết tới và tham gia hơn. "
                + "Thông tin hiện tại: "
                + (nameTournament != null && !nameTournament.isEmpty() ? "Tên giải đấu: \"" + escapeJson(nameTournament) + "\". " : "")
                + (description != null && !description.isEmpty() ? "Mô tả: \"" + escapeJson(description) + "\". " : "")
                + (totalTeams != null && !totalTeams.isEmpty() ? "Tổng số đội: " + escapeJson(totalTeams) + ". " : "")
                + (award != null && !award.isEmpty() ? "Giải thưởng: " + escapeJson(award) + " VNĐ. " : "")
                + "Hãy trả về kết quả dưới dạng JSON với 2 trường: "
                + "'nameTournament' (tên giải đấu đã cải thiện, ngắn gọn, hấp dẫn, chuyên nghiệp) và "
                + "'improvedDescription' (mô tả đã cải thiện, súc tích, hấp dẫn, chuyên nghiệp, nhấn mạnh tính cộng đồng và giải thưởng).";

        String requestBody = "{"
                + "\"contents\":[{\"role\":\"user\",\"parts\":[{\"text\":\"" + escapeJson(prompt) + "\"}]}],"
                + "\"generationConfig\":{"
                + "\"response_mime_type\":\"application/json\","
                + "\"response_schema\":{"
                + "\"type\":\"object\","
                + "\"properties\":{"
                + "\"nameTournament\":{\"type\":\"string\",\"description\":\"Tên giải đấu đã cải thiện\"},"
                + "\"improvedDescription\":{\"type\":\"string\",\"description\":\"Mô tả đã cải thiện\"}"
                + "},"
                + "\"required\":[\"nameTournament\",\"improvedDescription\"]"
                + "}"
                + "}"
                + "}";

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int code = conn.getResponseCode();
        if (code != 200) {
            throw new IOException("Gemini API error: " + code);
        }

        StringBuilder response = new StringBuilder();
        try (Scanner scanner = new Scanner(conn.getInputStream(), StandardCharsets.UTF_8.name())) {
            while (scanner.hasNextLine()) {
                response.append(scanner.nextLine());
            }
        }

        // Trả về trực tiếp nội dung mô tả đã cải thiện
        return response.toString();
    }

    private String escapeJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
