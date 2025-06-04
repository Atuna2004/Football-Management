package controller.Authentication;


import connect.DBConnection;
import java.io.IOException;
import dao.AccountDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

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
                User pendingUser = (User) request.getSession().getAttribute("pendingUser");
                if (pendingUser != null) {

                    pendingUser.setActive(true);
                    userDAO.addUser(pendingUser); // lưu vào DB
                    User user = userDAO.getUserByEmail(email);
                    
                    // login sau khi đăng kí
                    request.getSession().setAttribute("currentUser", user);
                    
                    request.getSession().removeAttribute("otp");
                    request.getSession().removeAttribute("otpMode");
                    request.getSession().removeAttribute("pendingUser");
                    response.sendRedirect(request.getContextPath() + "/home.jsp");
                }
            }
            else if ("reset".equals(otpMode)) {
                response.sendRedirect(request.getContextPath() + "/account/resetPassword.jsp");
            } else {
                // Không xác định mục đích
                clearOtpSession(request);
                response.sendRedirect(request.getContextPath() + "/home.jsp");
             }
            } catch (SQLException ex) {
            Logger.getLogger(OTPServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
   }
}

private void clearOtpSession(HttpServletRequest request) {
    request.getSession().removeAttribute("otp");
    request.getSession().removeAttribute("email");
    request.getSession().removeAttribute("otpMode");
}
}