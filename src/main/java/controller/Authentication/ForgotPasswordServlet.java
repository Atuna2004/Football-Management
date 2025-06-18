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
        
        HttpSession session = request.getSession();
        String action = (String) session.getAttribute("action");
        
        if (action == null) {
            // Lần đầu tiên - gửi OTP
            handleForgotPassword(request, response);
        } else if ("reset".equals(action)) {
            // Sau khi xác thực OTP - reset password
            handleResetPassword(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    /**
     * Xử lý quên mật khẩu - gửi OTP
     * Được gọi khi action = null (lần đầu)
     */
    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
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
            // Chưa set action, để null
            
            // Gửi OTP qua email
            new EmailService().sendOTPEmail(email, otp, "Mã OTP đặt lại mật khẩu");
            
            // Chuyển hướng tới trang nhập OTP
            response.sendRedirect(request.getContextPath() + "/account/confirmOTP.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher("/account/forgotPassword.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý đặt lại mật khẩu mới
     * Được gọi khi action = "reset" (sau khi xác thực OTP)
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String otpMode = (String) session.getAttribute("otpMode");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Kiểm tra session có đúng mode reset không
        if (!"reset".equals(otpMode) || email == null) {
            request.setAttribute("error", "Phiên làm việc không hợp lệ. Vui lòng thực hiện lại từ đầu.");
            response.sendRedirect(request.getContextPath() + "/account/forgotPassword.jsp");
            return;
        }
        
        // Kiểm tra xác nhận mật khẩu
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/account/resetPassword.jsp").forward(request, response);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);
            
            // Cập nhật mật khẩu mới
            accountDAO.updatePassword(email, newPassword);
            
            // Xóa thông tin khỏi session
            session.removeAttribute("email");
            session.removeAttribute("otp");
            session.removeAttribute("otpMode");
            session.removeAttribute("action");
            
            // Thêm thông báo thành công
            session.setAttribute("successMessage", "Đã đặt lại mật khẩu thành công!");
            
            // Chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật mật khẩu.");
            request.getRequestDispatcher("/account/resetPassword.jsp").forward(request, response);
        }
    }
}