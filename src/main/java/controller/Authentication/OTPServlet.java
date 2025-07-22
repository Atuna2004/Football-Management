package controller.Authentication;

import connect.DBConnection; // ✅ Import DBConnection
import dao.AccountDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
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
        String otpMode = (String) request.getSession().getAttribute("otpMode"); // "activate" or "reset"

        if (sessionOTP != null && sessionOTP.equals(userOTP)) {
            Connection conn = null;
            try {
                // ✅ 1. Lấy kết nối từ DBConnection
                conn = DBConnection.getConnection();
                if (conn == null) {
                    throw new SQLException("Failed to establish database connection.");
                }

                // ✅ 2. Truyền kết nối vào AccountDAO
                AccountDAO userDAO = new AccountDAO(conn);

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
            } catch (SQLException ex) {
                Logger.getLogger(OTPServlet.class.getName()).log(Level.SEVERE, "Database error", ex);
                response.sendRedirect(request.getContextPath() + "/account/login.jsp?error=db_error");
            } catch (Exception ex) {
                Logger.getLogger(OTPServlet.class.getName()).log(Level.SEVERE, "Unexpected error", ex);
                response.sendRedirect(request.getContextPath() + "/account/login.jsp?error=otp_fail");
            } finally {
                // ✅ 3. Đóng kết nối
                if (conn != null) {
                    try {
                        if (!conn.isClosed()) {
                            DBConnection.closeConnection(conn);
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(OTPServlet.class.getName()).log(Level.SEVERE, "Failed to close connection", ex);
                    }
                }
            }
        } else {
            // Sai OTP
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