package controller.Admin;

import connect.DBConnection;  // Import DBConnection để lấy kết nối
import dao.AccountDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            System.out.println("[AdminDashboardServlet] Not logged in, redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        Connection conn = null;
        AccountDAO accountDAO = null;

        try {
            // 2. Lấy kết nối từ DBConnection
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }

            // 3. Truyền kết nối vào AccountDAO qua constructor
            accountDAO = new AccountDAO(conn);

            // 4. Lấy danh sách 10 người dùng mới nhất
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

            // 5. Số người dùng đang online
            ServletContext app = getServletContext();
            Integer onlineUsers = (Integer) app.getAttribute("onlineUsers");
            if (onlineUsers == null) {
                onlineUsers = 0;
            }
            System.out.println("[AdminDashboardServlet] Number of online users: " + onlineUsers);
            request.setAttribute("onlineUsers", onlineUsers);

            // 6. Chuyển tiếp đến trang JSP
            System.out.println("[AdminDashboardServlet] Forwarding to /admin/adminPage.jsp");
            request.getRequestDispatcher("/admin/adminPage.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("[AdminDashboardServlet] Database error: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu!");
        } catch (Exception e) {
            System.err.println("[AdminDashboardServlet] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống!");
        } finally {
            // 7. Luôn đóng kết nối trong block finally
            if (conn != null) {
                try {
                    if (!conn.isClosed()) {
                        DBConnection.closeConnection(conn);
                    }
                } catch (SQLException ex) {
                    System.err.println("[AdminDashboardServlet] Failed to close connection: " + ex.getMessage());
                }
            }
        }
    }
}
