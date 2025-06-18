package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import model.User;

import service.OTPGenerator;
import service.EmailService;
import service.PasswordService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgotPassword"})
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
                request.setAttribute("error", "Email không tồn tại.");
                request.getRequestDispatcher("/account/forgotPassword.jsp").forward(request, response);
                return;
            }


            String otp = OTPGenerator.generateOTP();


            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("otp", otp);
            session.setAttribute("otpMode", "reset");


            new EmailService().sendOTPEmail(email, otp, "Mã OTP đặt lại mật khẩu");

            response.sendRedirect(request.getContextPath() + "/account/confirmOTP.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại.");
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
            request.setAttribute("error", "Phiên làm việc không hợp lệ. Vui lòng thực hiện lại từ đầu.");
            response.sendRedirect(request.getContextPath() + "/account/forgotPassword.jsp");
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/account/resetPassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);
            PasswordService passwordService = new PasswordService();

            // Hash mật khẩu trước khi cập nhật
            String hashedPassword = passwordService.hashPassword(newPassword);

            accountDAO.updatePassword(email, hashedPassword);


            session.removeAttribute("email");
            session.removeAttribute("otp");
            session.removeAttribute("otpMode");
            session.removeAttribute("action");

            session.setAttribute("successMessage", "Đã đặt lại mật khẩu thành công!");

            response.sendRedirect(request.getContextPath() + "/account/login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật mật khẩu.");
            request.getRequestDispatcher("/account/resetPassword.jsp").forward(request, response);
        }
    }
}
