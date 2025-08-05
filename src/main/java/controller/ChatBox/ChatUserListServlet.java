package controller.ChatBox;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dao.AccountDAO;
import model.User;
import connect.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/api/chatusers")
public class ChatUserListServlet extends HttpServlet {
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response headers first
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\": \"Unauthorized\"}");
                out.flush();
            }
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            AccountDAO accountDAO = new AccountDAO(conn);
            List<User> allUsers = accountDAO.getAllUsers();
            List<User> chatableUsers = new ArrayList<>();

            // Enhanced debug logging
            System.out.println("=== ENHANCED CHAT DEBUG ===");
            System.out.println("Current user: " + currentUser.getFullName());
            System.out.println("Current user ID: " + currentUser.getUserID());
            System.out.println("Current user role: " + currentUser.getRole());
            System.out.println("Is Admin: " + currentUser.isAdmin());
            System.out.println("Is FieldOwner: " + currentUser.isFieldOwner());
            System.out.println("Is User: " + currentUser.isUser());
            System.out.println("Total users from DB: " + allUsers.size());
            
            // Debug all users and their roles
            System.out.println("All users in database:");
            for (User u : allUsers) {
                System.out.println("- ID:" + u.getUserID() + " Name:" + u.getFullName() + 
                                 " Role:" + u.getRole() + " isAdmin:" + u.isAdmin() + 
                                 " isFieldOwner:" + u.isFieldOwner() + " isUser:" + u.isUser());
            }

            // Logic phân quyền dựa trên vai trò
            if (currentUser.isAdmin()) {
                // Admin có thể chat với tất cả Field Owner và User
                chatableUsers = allUsers.stream()
                        .filter(u -> {
                            boolean canChat = u.isFieldOwner() || u.isUser();
                            System.out.println("Admin filtering - User: " + u.getFullName() + 
                                             " canChat: " + canChat + " (isFieldOwner: " + 
                                             u.isFieldOwner() + ", isUser: " + u.isUser() + ")");
                            return canChat;
                        })
                        .collect(Collectors.toList());
                        
            } else if (currentUser.isFieldOwner()) {
                // Field Owner có thể chat với Admin và User
                chatableUsers = allUsers.stream()
                        .filter(u -> {
                            boolean canChat = u.isAdmin() || u.isUser();
                            System.out.println("FieldOwner filtering - User: " + u.getFullName() + 
                                             " canChat: " + canChat + " (isAdmin: " + 
                                             u.isAdmin() + ", isUser: " + u.isUser() + ")");
                            return canChat;
                        })
                        .collect(Collectors.toList());
                        
            } else if (currentUser.isUser()) {
                // User logic - có thể chat với Admin và Field Owner cụ thể
                String stadiumIdStr = request.getParameter("stadiumId");
                
                if (stadiumIdStr != null && !stadiumIdStr.trim().isEmpty()) {
                    // Stadium-specific chat: chỉ hiển thị Admin + chủ sân cụ thể
                    try {
                        int stadiumId = Integer.parseInt(stadiumIdStr);
                        final int finalStadiumId = stadiumId;
                        
                        chatableUsers = allUsers.stream()
                                .filter(u -> {
                                    boolean canChat = u.isAdmin() || 
                                                   (u.isFieldOwner() && ownsStadium(accountDAO, u.getUserID(), finalStadiumId));
                                    System.out.println("User filtering (stadium-specific) - User: " + u.getFullName() + 
                                                     " canChat: " + canChat);
                                    return canChat;
                                })
                                .collect(Collectors.toList());
                                
                    } catch (NumberFormatException e) {
                        // Nếu stadiumId không hợp lệ, fallback về logic cũ
                        System.err.println("Invalid stadiumId parameter: " + stadiumIdStr);
                        chatableUsers = allUsers.stream()
                                .filter(u -> {
                                    boolean canChat = u.isAdmin() || u.isFieldOwner();
                                    System.out.println("User filtering (fallback) - User: " + u.getFullName() + 
                                                     " canChat: " + canChat);
                                    return canChat;
                                })
                                .collect(Collectors.toList());
                    }
                } else {
                    // Không có stadiumId: hiển thị tất cả Admin và Field Owner
                    chatableUsers = allUsers.stream()
                            .filter(u -> {
                                boolean canChat = u.isAdmin() || u.isFieldOwner();
                                System.out.println("User filtering (general) - User: " + u.getFullName() + 
                                                 " canChat: " + canChat + " (isAdmin: " + 
                                                 u.isAdmin() + ", isFieldOwner: " + u.isFieldOwner() + ")");
                                return canChat;
                            })
                            .collect(Collectors.toList());
                }
            }

            // Loại bỏ chính mình khỏi danh sách
            final int currentId = currentUser.getUserID();
            chatableUsers = chatableUsers.stream()
                    .filter(u -> {
                        boolean notSelf = u.getUserID() != currentId;
                        if (!notSelf) {
                            System.out.println("Filtering out self: " + u.getFullName());
                        }
                        return notSelf;
                    })
                    .collect(Collectors.toList());

            System.out.println("Final chatable users count: " + chatableUsers.size());
            for (User u : chatableUsers) {
                System.out.println("- " + u.getFullName() + " (" + u.getRole() + ") ID:" + u.getUserID());
            }
            System.out.println("=== END ENHANCED DEBUG ===");

            // Create custom JSON response with proper role information
            JsonArray usersJsonArray = new JsonArray();
            for (User user : chatableUsers) {
                JsonObject userJson = new JsonObject();
                userJson.addProperty("userID", user.getUserID());
                userJson.addProperty("fullName", user.getFullName());
                userJson.addProperty("email", user.getEmail());
                
                // Add role information in the format expected by the frontend
                JsonArray rolesArray = new JsonArray();
                JsonObject roleObject = new JsonObject();
                
                if (user.isAdmin()) {
                    roleObject.addProperty("roleName", "admin");
                } else if (user.isFieldOwner()) {
                    roleObject.addProperty("roleName", "owner");
                } else if (user.isUser()) {
                    roleObject.addProperty("roleName", "user");
                } else {
                    roleObject.addProperty("roleName", "unknown");
                }
                
                rolesArray.add(roleObject);
                userJson.add("roles", rolesArray);
                
                // Also add individual role flags for compatibility
                userJson.addProperty("isAdmin", user.isAdmin());
                userJson.addProperty("isFieldOwner", user.isFieldOwner());
                userJson.addProperty("isUser", user.isUser());
                
                usersJsonArray.add(userJson);
            }
            
            String jsonResponse = gson.toJson(usersJsonArray);
            
            // Write response
            try (PrintWriter out = response.getWriter()) {
                out.write(jsonResponse);
                out.flush();
            }

        } catch (Exception e) {
            System.err.println("Error in ChatUserListServlet: " + e.getMessage());
            e.printStackTrace();
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\": \"Internal server error: " + e.getMessage() + "\"}");
                out.flush();
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    /**
     * Kiểm tra xem Field Owner có sở hữu stadium cụ thể không
     */
    private boolean ownsStadium(AccountDAO accountDAO, int userId, int stadiumId) {
        try {
            boolean owns = accountDAO.ownsStadium(userId, stadiumId);
            System.out.println("Checking stadium ownership - UserID: " + userId + 
                             ", StadiumID: " + stadiumId + ", Owns: " + owns);
            return owns;
        } catch (SQLException e) {
            System.err.println("Error checking stadium ownership: " + e.getMessage());
            return false;
        }
    }
}