package controller.Authentication;

import dao.AccountDAO;
import model.User;
import service.EmailService;
import service.OTPGenerator;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Confirm password does not match!");
            request.getRequestDispatcher("account/register.jsp").forward(request, response);
            return;
        }

        try {
            AccountDAO userDAO = new AccountDAO();

            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("error", "Email already exists!");
                request.getRequestDispatcher("account/register.jsp").forward(request, response);
                return;
            }

            User newUser = new User();
            newUser.setEmail(email);
            newUser.setPasswordHash(password);
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
            String subject = "Activate Your Account - OTP";
            emailService.sendOTPEmail(email, otp, subject);

            response.sendRedirect("account/confirmOTP.jsp");

        } catch (Exception e) {
            throw new ServletException("Database error", e);
        }
    }
}
