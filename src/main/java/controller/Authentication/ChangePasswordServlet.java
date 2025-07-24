package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import model.User;
import service.PasswordService; 

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

        // Lấy session, kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        // Lấy dữ liệu từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra rỗng
        if (currentPassword == null || newPassword == null || confirmPassword == null
                || currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);

            // Lấy lại thông tin người dùng từ CSDL để đảm bảo dữ liệu mới nhất
            User freshUser = accountDAO.getUserById(currentUser.getUserID());
            if (freshUser == null) {
                request.setAttribute("errorMessage", "Người dùng không tồn tại.");
                request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
                return;
            }

            // ✅ Kiểm tra mật khẩu hiện tại bằng BCrypt
            if (!PasswordService.checkPassword(currentPassword, freshUser.getPasswordHash())) {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
                return;
            }

            // ✅ Hash mật khẩu mới trước khi lưu
            String hashedNewPassword = PasswordService.hashPassword(newPassword);
            freshUser.setPasswordHash(hashedNewPassword);

            // Cập nhật vào CSDL
            boolean updated = accountDAO.updatePassword(freshUser.getEmail(), newPassword);

            if (updated) {
                // Cập nhật lại session để đảm bảo mật khẩu mới được đồng bộ
                session.setAttribute("currentUser", freshUser);
                request.setAttribute("successMessage", "Đổi mật khẩu thành công.");
            } else {
                request.setAttribute("errorMessage", "Đổi mật khẩu thất bại. Vui lòng thử lại.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
    }
}