package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import model.User;
import service.EmailService;
import service.OTPGenerator;
import service.PasswordService; // ✅ THÊM

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SignupServlet extends HttpServlet {

    private final PasswordService passwordService = new PasswordService(); // ✅ THÊM

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("account/register.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO userDAO = new AccountDAO(conn);

            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("error", "Email đã tồn tại!");
                request.getRequestDispatcher("account/register.jsp").forward(request, response);
                return;
            }

            User newUser = new User();
            newUser.setEmail(email);


            // ✅ THÊM HASH PASSWORD BÊN DƯỚI
            String hashedPassword = passwordService.hashPassword(password);
            newUser.setPasswordHash(hashedPassword);


            newUser.setFullName(fullName);
            newUser.setPhone(phone);
            newUser.setActive(false);
            newUser.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            newUser.setGoogleID(null);
            newUser.setAvatarUrl(null);

            request.getSession().setAttribute("pendingUser", newUser);

            String otp = OTPGenerator.generateOTP();
            EmailService emailService = new EmailService();
            request.getSession().setAttribute("otp", otp);
            request.getSession().setAttribute("email", email);
            request.getSession().setAttribute("otpMode", "activate");

            String subject = "Activate account OTP";
            emailService.sendOTPEmail(email, otp, subject);
            response.sendRedirect("account/confirmOTP.jsp");

        } catch (SQLException e) {
            throw new ServletException("Lỗi cơ sở dữ liệu", e);
        }
    }
}
