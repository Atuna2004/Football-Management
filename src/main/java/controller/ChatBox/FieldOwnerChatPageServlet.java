package controller.ChatBox;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/fieldOwner/fieldowner-chat")
public class FieldOwnerChatPageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("FieldOwnerChatPageServlet: Request received");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        System.out.println("Current user: " + (currentUser != null ? currentUser.getUserID() : "null"));
        
        if (currentUser == null || !currentUser.isFieldOwner()) {
            System.out.println("User not authorized, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/fieldOwner/login.jsp");
            return;
        }
        
        System.out.println("Forwarding to: /fieldOwner/chat.jsp");
        
        // Forward to the chat.jsp file
        request.getRequestDispatcher("/fieldOwner/chat.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}