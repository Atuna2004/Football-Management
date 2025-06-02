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
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String userOTP = request.getParameter("otp");
    String sessionOTP = (String) request.getSession().getAttribute("otp");
    String email = (String) request.getSession().getAttribute("email");
    String otpMode = (String) request.getSession().getAttribute("otpMode"); // "activate" hoặc "reset"

    if (sessionOTP != null && sessionOTP.equals(userOTP)) {
        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO userDAO = new AccountDAO(conn);

            if ("activate".equals(otpMode)) {
                userDAO.activateUser(email);
                clearOtpSession(request);
                response.sendRedirect(request.getContextPath() + "/home.jsp");

            } else if ("reset".equals(otpMode)) {
                //Chỉnh code reset Password ở đây
            } else {
                // Không xác định mục đích
                clearOtpSession(request);
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi khi xử lý OTP", e);
        }
    } else {
        request.getSession().setAttribute("otpError", "Mã OTP không hợp lệ. Vui lòng thử lại.");
        response.sendRedirect("confirmOTP.jsp");
    }
}

private void clearOtpSession(HttpServletRequest request) {
    request.getSession().removeAttribute("otp");
    request.getSession().removeAttribute("email");
    request.getSession().removeAttribute("otpMode");
}
}