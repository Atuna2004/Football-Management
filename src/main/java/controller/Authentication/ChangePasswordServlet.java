package controller.Authentication;

import connect.DBConnection;
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

        // Lấy session, check user đã login chưa
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

        if (currentPassword == null || newPassword == null || confirmPassword == null
                || currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/account//profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/account//profile.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);

            // Kiểm tra mật khẩu hiện tại có đúng không
            User freshUser = accountDAO.getUserById(currentUser.getUserID());
            if (freshUser == null) {
                request.setAttribute("errorMessage", "Người dùng không tồn tại.");
                request.getRequestDispatcher("/account//profile.jsp").forward(request, response);
                return;
            }

            // So sánh mật khẩu hiện tại (giả sử lưu mật khẩu mã hóa)
            // Ở đây tạm so sánh chuỗi trực tiếp (bạn có thể bổ sung hash password)
            if (!freshUser.getPasswordHash().equals(currentPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/account//profile.jsp").forward(request, response);
                return;
            }

            // Cập nhật mật khẩu mới
            freshUser.setPasswordHash(newPassword);  // Bạn nên hash mật khẩu trước khi lưu
            boolean updated = accountDAO.updateUser(freshUser);

            if (updated) {
                // Cập nhật session nếu cần
                session.setAttribute("currentUser", freshUser);
                request.setAttribute("successMessage", "Đổi mật khẩu thành công.");
            } else {
                request.setAttribute("errorMessage", "Đổi mật khẩu thất bại.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        request.getRequestDispatcher("/account//profile.jsp").forward(request, response);
    }
}
