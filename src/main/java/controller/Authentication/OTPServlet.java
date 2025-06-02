package controller.Authentication;

import connect.DBConnection;
import java.io.IOException;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;



public class OTPServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String userOTP = request.getParameter("otp");
        String sessionOTP = (String) request.getSession().getAttribute("otp");
        String email = (String) request.getSession().getAttribute("email");

        if (sessionOTP != null && sessionOTP.equals(userOTP)) {
            try(Connection conn = DBConnection.getConnection()){
                AccountDAO userDAO = new AccountDAO(conn);
                userDAO.ActivateUser(email); //chuyen email sang active
                
                request.getSession().removeAttribute("email");
                request.getSession().removeAttribute("otp");
                
                response.sendRedirect(request.getContextPath() + "/home.jsp");

            } catch (Exception e) {
            throw new ServletException("Lỗi khi xác minh tài khoản", e);
            }
            
        } else {
            // OTP sai
            request.getSession().setAttribute("otpError", "Mã OTP không hợp lệ. Vui lòng thử lại.");
            response.sendRedirect("confirmOTP.jsp");
        }
    }
}
