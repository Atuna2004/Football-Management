package controller.ChatBox;

import com.google.gson.Gson;
import dao.MessageDAO;
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

@WebServlet("/api/chat-history")
public class ChatHistoryServlet extends HttpServlet {

    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        // Trong file controller/ChatBox/ChatHistoryServlet.java
        String withUserIdStr = request.getParameter("withUserId");

// Kiểm tra cả null và chuỗi rỗng
        if (currentUser == null || withUserIdStr == null || withUserIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            MessageDAO messageDAO = new MessageDAO(conn);
            int userId1 = currentUser.getUserID();
            int userId2 = Integer.parseInt(withUserIdStr);

            List<Message> history = messageDAO.getChatHistory(userId1, userId2);

            String jsonHistory = gson.toJson(history);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonHistory);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
        }
    }
}
