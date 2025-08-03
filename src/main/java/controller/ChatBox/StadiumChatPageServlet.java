package controller.ChatBox;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/chat/stadium")
public class StadiumChatPageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Debug logging
        System.out.println("=== StadiumChatPageServlet Debug ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Query String: " + request.getQueryString());
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        System.out.println("Current User: " + (currentUser != null ? currentUser.getFullName() + " (ID: " + currentUser.getUserID() + ")" : "null"));
        
        if (currentUser == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check if stadiumId parameter exists
        String stadiumIdStr = request.getParameter("stadiumId");
        System.out.println("Stadium ID parameter: " + stadiumIdStr);
        
        if (stadiumIdStr == null || stadiumIdStr.trim().isEmpty()) {
            System.out.println("Stadium ID is null or empty, redirecting to stadiums");
            response.sendRedirect(request.getContextPath() + "/stadiums");
            return;
        }
        
        // Simply redirect to user-chat.jsp with stadiumId parameter
        try {
            int stadiumId = Integer.parseInt(stadiumIdStr.trim());
            System.out.println("Parsed Stadium ID: " + stadiumId);
            
            // Redirect to user-chat.jsp with stadiumId parameter
            String redirectUrl = request.getContextPath() + "/user-chat.jsp?stadiumId=" + stadiumId;
            System.out.println("Redirecting to: " + redirectUrl);
            
            response.sendRedirect(redirectUrl);
            
        } catch (NumberFormatException e) {
            System.out.println("Invalid stadium ID format: " + stadiumIdStr);
            response.sendRedirect(request.getContextPath() + "/stadiums");
            return;
        }
        
        System.out.println("=== End Debug ===");
    }
}