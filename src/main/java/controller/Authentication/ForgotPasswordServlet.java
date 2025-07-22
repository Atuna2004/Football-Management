package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import model.User;
import service.OTPGenerator;
import service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = (String) session.getAttribute("action");

        if (action == null) {
            handleForgotPassword(request, response);
        } else if ("reset".equals(action)) {
            handleResetPassword(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);

            User user = accountDAO.getUserByEmail(email);
            if (user == null) {
                request.setAttribute("error", "Email does not exist.");
                request.getRequestDispatcher("/account/forgotPassword.jsp").forward(request, response);
                return;
            }

            String otp = OTPGenerator.generateOTP();

            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("otp", otp);
            session.setAttribute("otpMode", "reset");

            new EmailService().sendOTPEmail(email, otp, "OTP code for password reset");

            response.sendRedirect(request.getContextPath() + "/account/confirmOTP.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "System error. Please try again.");
            request.getRequestDispatcher("/account/forgotPassword.jsp").forward(request, response);
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String otpMode = (String) session.getAttribute("otpMode");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!"reset".equals(otpMode) || email == null) {
            session.setAttribute("error", "Invalid session. Please start the process again.");
            response.sendRedirect(request.getContextPath() + "/account/forgotPassword.jsp");
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/account/resetPassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);

            // Mã hóa mật khẩu bằng BCrypt
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            accountDAO.updatePassword(email, hashedPassword);

            session.removeAttribute("email");
            session.removeAttribute("otp");
            session.removeAttribute("otpMode");
            session.removeAttribute("action");

            session.setAttribute("successMessage", "Password has been successfully reset!");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error occurred while updating the password.");
            request.getRequestDispatcher("/account/resetPassword.jsp").forward(request, response);
        }
    }
}
