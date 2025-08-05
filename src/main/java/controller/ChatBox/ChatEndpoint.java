package controller.ChatBox;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import dao.MessageDAO;
import model.Message;
import connect.DBConnection;
import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/ws/chat/{userId}")
public class ChatEndpoint {
    private static final Map<String, Session> sessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();
    
    @OnOpen
    public void onOpen(Session session, @PathParam("userId") String userId) {
        sessions.put(userId, session);
        System.out.println("=== WebSocket OPENED ===");
        System.out.println("UserID: " + userId);
        System.out.println("Session ID: " + session.getId());
        System.out.println("Total active sessions: " + sessions.size());
        System.out.println("Active users: " + sessions.keySet());
        System.out.println("========================");
    }
    
    @OnMessage
    public void onMessage(String message, @PathParam("userId") String fromUserId, Session session) {
        System.out.println("=== MESSAGE RECEIVED ===");
        System.out.println("From UserID: " + fromUserId);
        System.out.println("Raw message: " + message);
        System.out.println("Session ID: " + session.getId());
        
        Connection conn = null;
        try {
            // 1. Parse tin nhắn JSON đến
            JsonObject jsonObject;
            try {
                jsonObject = gson.fromJson(message, JsonObject.class);
            } catch (JsonSyntaxException e) {
                System.err.println("Invalid JSON format: " + e.getMessage());
                sendErrorMessage(session, "Invalid message format");
                return;
            }
            
            // Validate required fields
            if (!jsonObject.has("toUserId") || !jsonObject.has("content")) {
                System.err.println("Missing required fields in message");
                sendErrorMessage(session, "Missing required fields");
                return;
            }
            
            String toUserId = jsonObject.get("toUserId").getAsString();
            String content = jsonObject.get("content").getAsString().trim();
            
            // Validate content
            if (content.isEmpty()) {
                System.err.println("Message content is empty");
                sendErrorMessage(session, "Message content cannot be empty");
                return;
            }
            
            System.out.println("To UserID: " + toUserId);
            System.out.println("Content: " + content);
            
            // 2. Lưu tin nhắn vào DB
            conn = DBConnection.getConnection();
            MessageDAO messageDAO = new MessageDAO(conn);
            Message msgToSave = new Message(Integer.parseInt(fromUserId), Integer.parseInt(toUserId), content);
            
            boolean saved = messageDAO.saveMessage(msgToSave);
            if (!saved) {
                System.err.println("Failed to save message to database");
                sendErrorMessage(session, "Failed to save message");
                return;
            }
            
            System.out.println("Message saved to database successfully");
            
            // 3. Tìm session của người nhận
            Session recipientSession = sessions.get(toUserId);
            System.out.println("Looking for recipient session for UserID: " + toUserId);
            System.out.println("Recipient session found: " + (recipientSession != null));
            
            if (recipientSession != null) {
                System.out.println("Recipient session is open: " + recipientSession.isOpen());
                System.out.println("Recipient session ID: " + recipientSession.getId());
            }
            
            // 4. Gửi tin nhắn cho người nhận nếu họ online
            if (recipientSession != null && recipientSession.isOpen()) {
                try {
                    // Tạo JSON để gửi đi
                    JsonObject forwardMessage = new JsonObject();
                    forwardMessage.addProperty("fromUserId", fromUserId);
                    forwardMessage.addProperty("content", content);
                    forwardMessage.addProperty("timestamp", System.currentTimeMillis());
                    
                    String messageToSend = gson.toJson(forwardMessage);
                    System.out.println("Sending to recipient: " + messageToSend);
                    
                    recipientSession.getBasicRemote().sendText(messageToSend);
                    System.out.println("Message sent successfully to recipient");
                } catch (IOException e) {
                    System.err.println("Failed to send message to recipient: " + e.getMessage());
                    // Remove broken session
                    sessions.remove(toUserId);
                }
            } else {
                System.out.println("Recipient is offline or session is closed");
            }
            
            // 5. Send confirmation back to sender
            try {
                JsonObject confirmMessage = new JsonObject();
                confirmMessage.addProperty("type", "confirmation");
                confirmMessage.addProperty("status", "sent");
                confirmMessage.addProperty("toUserId", toUserId);
                
                session.getBasicRemote().sendText(gson.toJson(confirmMessage));
                System.out.println("Confirmation sent to sender");
            } catch (IOException e) {
                System.err.println("Failed to send confirmation to sender: " + e.getMessage());
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid user ID format: " + e.getMessage());
            sendErrorMessage(session, "Invalid user ID");
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            e.printStackTrace();
            sendErrorMessage(session, "Database error occurred");
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            sendErrorMessage(session, "An unexpected error occurred");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing database connection: " + e.getMessage());
                }
            }
        }
        System.out.println("=== MESSAGE PROCESSING COMPLETE ===");
    }
    
    @OnClose
    public void onClose(@PathParam("userId") String userId, CloseReason reason) {
        sessions.remove(userId);
        System.out.println("=== WebSocket CLOSED ===");
        System.out.println("UserID: " + userId);
        System.out.println("Reason: " + reason.getReasonPhrase());
        System.out.println("Code: " + reason.getCloseCode());
        System.out.println("Remaining active sessions: " + sessions.size());
        System.out.println("========================");
    }
    
    @OnError
    public void onError(Throwable throwable, @PathParam("userId") String userId) {
        System.err.println("=== WebSocket ERROR ===");
        System.err.println("UserID: " + userId);
        System.err.println("Error: " + throwable.getMessage());
        throwable.printStackTrace();
        System.err.println("=======================");
        
        // Clean up broken session
        sessions.remove(userId);
    }
    
    private void sendErrorMessage(Session session, String errorMessage) {
        try {
            JsonObject error = new JsonObject();
            error.addProperty("type", "error");
            error.addProperty("message", errorMessage);
            session.getBasicRemote().sendText(gson.toJson(error));
        } catch (IOException e) {
            System.err.println("Failed to send error message: " + e.getMessage());
        }
    }
}