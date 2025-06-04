package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import model.User;
import utils.OTPGenerator;
import utils.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;

public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);

            // Kiểm tra email tồn tại
            User user = accountDAO.getUserByEmail(email);
            if (user == null) {
                request.setAttribute("error", "Email không tồn tại.");
                request.getRequestDispatcher("/account/forgotPassword.jsp").forward(request, response);
                return;
            }

            // Tạo OTP
            String otp = OTPGenerator.generateOTP();

            // Lưu vào session
            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("otp", otp);
            session.setAttribute("otpMode", "reset");

            // Gửi OTP qua email
            new EmailService().sendOTPEmail(email, otp, "Mã OTP đặt lại mật khẩu");

            // Chuyển hướng tới trang nhập OTP
            response.sendRedirect(request.getContextPath() + "account/confirmOTP.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher("/account/forgotPassword.jsp").forward(request, response);
        }
    }
}