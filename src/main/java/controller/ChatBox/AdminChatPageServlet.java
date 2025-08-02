package controller.ChatBox;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/chat")
public class AdminChatPageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            // Not logged in - redirect to login
            response.sendRedirect(request.getContextPath() + "/admin/loginAdmin.jsp");
            return;
        }
        
        if (!currentUser.isAdmin()) {
            // Not admin - redirect to appropriate dashboard or show error
            response.sendRedirect(request.getContextPath() + "/admin/loginAdmin.jsp");
            return;
        }
        
        // Admin is logged in - forward to chat page
        request.getRequestDispatcher("/admin/chat.jsp").forward(request, response);
    }
}