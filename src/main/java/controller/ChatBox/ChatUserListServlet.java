package controller.ChatBox;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dao.AccountDAO;
import dao.MessageDAO;
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
            MessageDAO messageDAO = new MessageDAO(conn);
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

            // Logic phân quyền dựa trên vai trò với kiểm tra lịch sử chat
            if (currentUser.isAdmin()) {
                // Admin có thể chat với tất cả Field Owner và User (có lịch sử chat)
                chatableUsers = filterUsersWithChatHistory(allUsers, currentUser, messageDAO, 
                    user -> user.isFieldOwner() || user.isUser(), "Admin");
                        
            } else if (currentUser.isFieldOwner()) {
                // Field Owner có thể chat với Admin và User (có lịch sử chat)
                chatableUsers = filterUsersWithChatHistory(allUsers, currentUser, messageDAO, 
                    user -> user.isAdmin() || user.isUser(), "FieldOwner");
                        
            } else if (currentUser.isUser()) {
                // User logic - có thể chat với Admin và Field Owner cụ thể (có lịch sử chat)
                String stadiumIdStr = request.getParameter("stadiumId");
                
                if (stadiumIdStr != null && !stadiumIdStr.trim().isEmpty()) {
                    // Stadium-specific chat: chỉ hiển thị Admin + chủ sân cụ thể (có lịch sử chat)
                    try {
                        int stadiumId = Integer.parseInt(stadiumIdStr);
                        
                        chatableUsers = filterUsersWithChatHistory(allUsers, currentUser, messageDAO, 
                            user -> user.isAdmin() || (user.isFieldOwner() && ownsStadium(accountDAO, user.getUserID(), stadiumId)), 
                            "User (stadium-specific)");
                                
                    } catch (NumberFormatException e) {
                        // Nếu stadiumId không hợp lệ, fallback về logic cũ
                        System.err.println("Invalid stadiumId parameter: " + stadiumIdStr);
                        chatableUsers = filterUsersWithChatHistory(allUsers, currentUser, messageDAO, 
                            user -> user.isAdmin() || user.isFieldOwner(), "User (fallback)");
                    }
                } else {
                    // Không có stadiumId: hiển thị tất cả Admin và Field Owner (có lịch sử chat)
                    chatableUsers = filterUsersWithChatHistory(allUsers, currentUser, messageDAO, 
                        user -> user.isAdmin() || user.isFieldOwner(), "User (general)");
                }
            }

            // Loại bỏ chính mình khỏi danh sách
            chatableUsers.removeIf(user -> user.getUserID() == currentUser.getUserID());

            System.out.println("Final chatable users count: " + chatableUsers.size());
            for (User u : chatableUsers) {
                System.out.println("- " + u.getFullName() + " (" + u.getRole() + ") ID:" + u.getUserID());
            }
            System.out.println("=== END ENHANCED DEBUG ===");

            // Create custom JSON response with proper role information
            JsonArray usersJsonArray = new JsonArray();
            for (User user : chatableUsers) {
                JsonObject userJson = createUserJsonObject(user);
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
     * Filter users based on role criteria and chat history
     */
    private List<User> filterUsersWithChatHistory(List<User> allUsers, User currentUser, 
            MessageDAO messageDAO, UserFilter filter, String context) throws SQLException {
        
        List<User> filteredUsers = new ArrayList<>();
        
        for (User user : allUsers) {
            // Check if user meets role criteria
            if (filter.test(user)) {
                // Check if there's chat history between current user and this user
                boolean hasChatHistory = messageDAO.hasChatHistory(currentUser.getUserID(), user.getUserID());
                
                System.out.println(context + " filtering - User: " + user.getFullName() + 
                                 " meetsCriteria: true" +
                                 " hasChatHistory: " + hasChatHistory);
                
                if (hasChatHistory) {
                    filteredUsers.add(user);
                }
            } else {
                System.out.println(context + " filtering - User: " + user.getFullName() + 
                                 " meetsCriteria: false");
            }
        }
        
        return filteredUsers;
    }

    /**
     * Create JSON object for user with proper role information
     */
    private JsonObject createUserJsonObject(User user) {
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
        
        return userJson;
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

    /**
     * Functional interface for user filtering
     */
    @FunctionalInterface
    private interface UserFilter {
        boolean test(User user);
    }
}