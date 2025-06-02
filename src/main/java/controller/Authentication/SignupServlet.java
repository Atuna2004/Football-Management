package controller.Authentication;


import connect.DBConnection;
import dao.AccountDAO;
import model.User;
import utils.EmailService;
import utils.OTPGenerator;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        // Kiểm tra xác nhận mật khẩu
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("account/register.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO userDAO = new AccountDAO(conn);

            // Kiểm tra xem email đã tồn tại chưa
            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("error", "Email đã tồn tại!");
                request.getRequestDispatcher("account/register.jsp").forward(request, response);
                return;
            }

            // Tạo user mới
            User newUser = new User();
            newUser.setEmail(email);
            newUser.setPasswordHash(password); 
            newUser.setFullName(fullName);
            newUser.setPhone(phone);
            newUser.setActive(false);
            newUser.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            newUser.setGoogleID(null);
            newUser.setAvatarUrl(null);

            boolean success = userDAO.addUser(newUser);

            if (success) {
                String otp = OTPGenerator.generateOTP();
                EmailService emailService = new EmailService();
                request.getSession().setAttribute("otp", otp);
                request.getSession().setAttribute("email", email);
                request.getSession().setAttribute("otpMode", "activate");
                String subject = "Activate account OTP";
                emailService.sendOTPEmail(email, otp, subject);
                response.sendRedirect("account/confirmOTP.jsp");
            } else {
                request.setAttribute("error", "Đăng ký thất bại, vui lòng thử lại!");
                request.getRequestDispatcher("account/register.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            throw new ServletException("Lỗi cơ sở dữ liệu", e);
        }
    }
}