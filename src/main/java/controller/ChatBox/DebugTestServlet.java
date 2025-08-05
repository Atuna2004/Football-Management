package controller.ChatBox;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/fieldOwner/test-debug")
public class DebugTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Debug Test</title></head><body>");
        out.println("<h1>Debug Information</h1>");
        
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null) {
            out.println("<p><strong>NO SESSION FOUND</strong></p>");
            out.println("<p>Please log in first</p>");
        } else {
            out.println("<p>Session ID: " + session.getId() + "</p>");
            
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                out.println("<p><strong>NO USER IN SESSION</strong></p>");
                out.println("<p>Please log in as a field owner</p>");
            } else {
                out.println("<p>User ID: " + currentUser.getUserID() + "</p>");
                out.println("<p>User Name: " + currentUser.getFullName() + "</p>");
                out.println("<p>Is Field Owner: " + currentUser.isFieldOwner() + "</p>");
                out.println("<p>Roles: " + currentUser.getRoles() + "</p>");
                
                if (currentUser.isFieldOwner()) {
                    out.println("<p><strong style='color: green;'>✓ USER IS AUTHORIZED FOR CHAT</strong></p>");
                    out.println("<p><a href='" + request.getContextPath() + "/fieldOwner/fieldowner-chat'>Try Chat Page</a></p>");
                } else {
                    out.println("<p><strong style='color: red;'>✗ USER IS NOT A FIELD OWNER</strong></p>");
                }
            }
        }
        
        out.println("<p>Context Path: " + request.getContextPath() + "</p>");
        out.println("<p>Request URL: " + request.getRequestURL() + "</p>");
        
        out.println("</body></html>");
    }
}