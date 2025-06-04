package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;

public class ResetNewPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/account/resetPassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);
            accountDAO.updatePassword(email, newPassword); 

            session.removeAttribute("email");
            session.removeAttribute("otp");
            session.removeAttribute("otpMode");

            response.sendRedirect(request.getContextPath() + "/account/login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật mật khẩu.");
            request.getRequestDispatcher("/account/resetPassword.jsp").forward(request, response);
        }
    }
}
