package controller.ChatBox;

import com.google.gson.Gson;
import dao.MessageDAO;
import dao.StadiumDAO;
import model.Message;
import model.User;
import connect.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/api/stadium-chat-history")
public class StadiumChatHistoryServlet extends HttpServlet {
    private static final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        String stadiumIdStr = request.getParameter("stadiumId");
        
        if (currentUser == null || stadiumIdStr == null || stadiumIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Missing parameters\"}");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            int stadiumId = Integer.parseInt(stadiumIdStr);
            
            StadiumDAO stadiumDAO = new StadiumDAO();
            MessageDAO messageDAO = new MessageDAO(conn);
            
            // Get stadium owner - CORRECTED: Use getStadiumOwner() method
            User owner = stadiumDAO.getStadiumOwner(stadiumId);
            if (owner == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Stadium owner not found\"}");
                return;
            }
            
            // Get chat history
            List<Message> history = messageDAO.getStadiumChatHistory(
                currentUser.getUserID(), 
                owner.getUserID(), 
                stadiumId
            );
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(history));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid stadium ID\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Internal server error\"}");
            e.printStackTrace();
        }
    }
}