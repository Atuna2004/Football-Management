package controller.Authentication;

import connect.DBConnection; // ✅ Import DBConnection
import dao.AccountDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/changePassword"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null
                || currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in all the required fields.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New password and confirm password do not match.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            // ✅ 1. Lấy kết nối từ DBConnection
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new SQLException("Cannot establish database connection.");
            }

            // ✅ 2. Truyền kết nối vào AccountDAO qua constructor
            AccountDAO accountDAO = new AccountDAO(conn);

            User freshUser = accountDAO.getUserById(currentUser.getUserID());
            if (freshUser == null) {
                request.setAttribute("errorMessage", "User does not exist.");
                request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
                return;
            }

            // Giả sử bạn đang so sánh mật khẩu chưa hash (sẽ cải thiện sau)
            if (!freshUser.getPasswordHash().equals(currentPassword)) {
                request.setAttribute("errorMessage", "Current password is incorrect.");
                request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
                return;
            }

            // TODO: hash newPassword trước khi lưu
            freshUser.setPasswordHash(newPassword);

            boolean updated = accountDAO.updateUser(freshUser);
            if (updated) {
                session.setAttribute("currentUser", freshUser);
                request.setAttribute("successMessage", "Password changed successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to change password.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
        } finally {
            // ✅ 3. Đóng kết nối
            if (conn != null) {
                try {
                    if (!conn.isClosed()) {
                        DBConnection.closeConnection(conn);
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }

        request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
    }
}