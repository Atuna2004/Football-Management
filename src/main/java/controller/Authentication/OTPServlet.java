package controller.Authentication;

import java.io.IOException;
import dao.AccountDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OTPServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userOTP = request.getParameter("otp");
        String sessionOTP = (String) request.getSession().getAttribute("otp");
        String email = (String) request.getSession().getAttribute("email");
        String otpMode = (String) request.getSession().getAttribute("otpMode"); // "activate" or "reset"

        if (sessionOTP != null && sessionOTP.equals(userOTP)) {
            try {
                AccountDAO userDAO = new AccountDAO();

                if ("activate".equals(otpMode)) {
                    User pendingUser = (User) request.getSession().getAttribute("pendingUser");
                    if (pendingUser != null) {
                        pendingUser.setActive(true);
                        userDAO.addUser(pendingUser); // Save to DB
                        User user = userDAO.getUserByEmail(email);

                        request.getSession().setAttribute("currentUser", user);
                        clearOtpSession(request);
                        response.sendRedirect(request.getContextPath() + "/home.jsp");
                        return;
                    }
                } else if ("reset".equals(otpMode)) {
                    request.getSession().setAttribute("action", "reset");
                    clearOtpSession(request);
                    response.sendRedirect(request.getContextPath() + "/account/resetPassword.jsp");
                    return;
                } else {
                    clearOtpSession(request);
                    response.sendRedirect(request.getContextPath() + "/home.jsp");
                }
            } catch (Exception ex) {
                Logger.getLogger(OTPServlet.class.getName()).log(Level.SEVERE, null, ex);
                response.sendRedirect(request.getContextPath() + "/account/login.jsp?error=otp_fail");
            }
        } else {
            // Incorrect OTP
            request.getSession().setAttribute("errorMessage", "Incorrect OTP code.");
            response.sendRedirect(request.getContextPath() + "/account/otp.jsp");
        }
    }

    private void clearOtpSession(HttpServletRequest request) {
        request.getSession().removeAttribute("otp");
        request.getSession().removeAttribute("email");
        request.getSession().removeAttribute("otpMode");
    }
}
