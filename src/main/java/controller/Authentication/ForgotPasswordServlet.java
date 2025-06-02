/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import service.EmailService;
import service.OTPGenerator;

/**
 *
 * @author banba
 */
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO userDAO = new AccountDAO(conn);

            // Kiểm tra xem email đã tồn tại chưa
            if (userDAO.getUserByEmail(email) == null) {
                request.setAttribute("error", "Email không tồn tại!");
                request.getRequestDispatcher("account/register.jsp").forward(request, response);
                return;
            }
            else{
                String otp = OTPGenerator.generateOTP();
                EmailService emailService = new EmailService();
                
                request.getSession().setAttribute("otp", otp);
                request.getSession().setAttribute("email", email);
                String subjet = "Forgotpassword OTP request";
                emailService.sendOTPEmail(email, otp, subjet);
                response.sendRedirect("account/confirmOTP.jsp");
            }
}       catch (SQLException ex) {
            Logger.getLogger(ForgotPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
}
}
