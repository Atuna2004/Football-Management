package controller.Admin;

import dao.AccountDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {

        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            System.out.println("[AdminDashboardServlet] Not logged in, redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        try {

            List<User> allUsers = accountDAO.getRecentUsers(10);

            if (allUsers.isEmpty()) {
                System.out.println("[AdminDashboardServlet] Recent users list is empty.");
            } else {
                System.out.println("[AdminDashboardServlet] Recent users list:");
                for (User u : allUsers) {
                    System.out.printf(" - UserID: %d, Name: %s, Email: %s, Phone: %s, IsActive: %b, CreatedAt: %s%n",
                            u.getUserID(), u.getFullName(), u.getEmail(), u.getPhone(),
                            u.isActive(), u.getCreatedAt());
                }
            }

            request.setAttribute("allUsers", allUsers);

            ServletContext app = getServletContext();
            Integer onlineUsers = (Integer) app.getAttribute("onlineUsers");
            if (onlineUsers == null) {
                onlineUsers = 0;
            }
            System.out.println("[AdminDashboardServlet] Number of online users: " + onlineUsers);
            request.setAttribute("onlineUsers", onlineUsers);

            System.out.println("[AdminDashboardServlet] Forwarding to /admin/adminPage.jsp");
            request.getRequestDispatcher("/admin/adminPage.jsp").forward(request, response);

        } catch (ServletException | IOException | SQLException e) {
            System.err.println("[AdminDashboardServlet] Error processing dashboard: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Dashboard error!");
        }
    }
}
