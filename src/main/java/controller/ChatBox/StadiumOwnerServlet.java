package controller.ChatBox;

import com.google.gson.Gson;
import dao.StadiumDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/stadium-owner")
public class StadiumOwnerServlet extends HttpServlet {
    private static final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"User not logged in\"}");
            return;
        }
        
        String stadiumIdStr = request.getParameter("stadiumId");
        
        if (stadiumIdStr == null || stadiumIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Stadium ID is required\"}");
            return;
        }
        
        try {
            int stadiumId = Integer.parseInt(stadiumIdStr);
            StadiumDAO stadiumDAO = new StadiumDAO();
            
            // Check if stadium exists
            if (stadiumDAO.getStadiumById(stadiumId) == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Stadium not found\"}");
                return;
            }
            
            // Get stadium owner - CORRECTED: Use getStadiumOwner() method
            User owner = stadiumDAO.getStadiumOwner(stadiumId);
            
            if (owner == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Stadium owner not found\"}");
                return;
            }
            
            // Return owner info (excluding sensitive data)
            OwnerInfo ownerInfo = new OwnerInfo(
                owner.getUserID(),
                owner.getFullName(),
                owner.getAvatarUrl()
            );
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(ownerInfo));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid stadium ID format\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Internal server error\"}");
            e.printStackTrace();
        }
    }
    
    // Inner class for response
    private static class OwnerInfo {
        private int userId;
        private String fullName;
        private String avatarUrl;
        
        public OwnerInfo(int userId, String fullName, String avatarUrl) {
            this.userId = userId;
            this.fullName = fullName;
            this.avatarUrl = avatarUrl;
        }
        
        // Getters for Gson
        public int getUserId() { return userId; }
        public String getFullName() { return fullName; }
        public String getAvatarUrl() { return avatarUrl; }
    }
}