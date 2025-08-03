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
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/api/admin-list")
public class UserAdminChatServlet extends HttpServlet {
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response headers first
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            // Not logged in - return unauthorized
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\": \"Unauthorized - Please login first\"}");
                out.flush();
            }
            return;
        }
        
        if (!currentUser.isUser()) {
            // Not a regular user - return forbidden
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\": \"Access denied - Only regular users can chat with admins\"}");
                out.flush();
            }
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            AccountDAO accountDAO = new AccountDAO(conn);
            
            // Get all users and filter only admins
            List<User> allUsers = accountDAO.getAllUsers();
            List<User> adminUsers = allUsers.stream()
                    .filter(User::isAdmin)
                    .collect(Collectors.toList());

            if (adminUsers.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                try (PrintWriter out = response.getWriter()) {
                    out.write("{\"error\": \"No admin users found\"}");
                    out.flush();
                }
                return;
            }

            // Create JSON response with admin information
            JsonArray adminsJsonArray = new JsonArray();
            for (User admin : adminUsers) {
                JsonObject adminJson = new JsonObject();
                adminJson.addProperty("userID", admin.getUserID());
                adminJson.addProperty("fullName", admin.getFullName());
                adminJson.addProperty("email", admin.getEmail());
                
                // Add role information in the format expected by the frontend
                JsonArray rolesArray = new JsonArray();
                JsonObject roleObject = new JsonObject();
                roleObject.addProperty("roleName", "admin");
                rolesArray.add(roleObject);
                adminJson.add("roles", rolesArray);
                
                // Also add individual role flags for compatibility
                adminJson.addProperty("isAdmin", true);
                adminJson.addProperty("isFieldOwner", false);
                adminJson.addProperty("isUser", false);
                
                adminsJsonArray.add(adminJson);
            }
            
            String jsonResponse = gson.toJson(adminsJsonArray);
            
            // Write response
            try (PrintWriter out = response.getWriter()) {
                out.write(jsonResponse);
                out.flush();
            }

        } catch (Exception e) {
            System.err.println("Error in UserAdminChatServlet: " + e.getMessage());
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
}