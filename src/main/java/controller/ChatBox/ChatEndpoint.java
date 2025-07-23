package controller.ChatBox;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.MessageDAO;
import model.Message;
import connect.DBConnection;

import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.sql.Connection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/ws/chat/{userId}")
public class ChatEndpoint {

    private static final Map<String, Session> sessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session, @PathParam("userId") String userId) {
        sessions.put(userId, session);
        System.out.println("WebSocket Mở: UserID = " + userId);
    }

    @OnMessage
    public void onMessage(String message, @PathParam("userId") String fromUserId) throws IOException {
        System.out.println("Tin nhắn từ " + fromUserId + ": " + message);

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Parse tin nhắn JSON đến
            JsonObject jsonObject = gson.fromJson(message, JsonObject.class);
            String toUserId = jsonObject.get("toUserId").getAsString();
            String content = jsonObject.get("content").getAsString();

            // 2. Lưu tin nhắn vào DB
            MessageDAO messageDAO = new MessageDAO(conn);
            Message msgToSave = new Message(Integer.parseInt(fromUserId), Integer.parseInt(toUserId), content);
            messageDAO.saveMessage(msgToSave);

            // 3. Chuyển tiếp tin nhắn đến người nhận nếu họ online
            Session recipientSession = sessions.get(toUserId);
            if (recipientSession != null && recipientSession.isOpen()) {
                // Tạo JSON để gửi đi, chứa thông tin người gửi
                JsonObject forwardMessage = new JsonObject();
                forwardMessage.addProperty("fromUserId", fromUserId);
                // Bạn có thể thêm fromUserName ở đây nếu cần
                forwardMessage.addProperty("content", content);

                recipientSession.getBasicRemote().sendText(gson.toJson(forwardMessage));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(@PathParam("userId") String userId) {
        sessions.remove(userId);
        System.out.println("WebSocket Đóng: UserID = " + userId);
    }

    @OnError
    public void onError(Throwable throwable) {
        throwable.printStackTrace();
    }
}
