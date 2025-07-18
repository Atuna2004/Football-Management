package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String userIdStr = request.getParameter("userId");
            if (userIdStr == null || userIdStr.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "User ID not found.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }

            int userId;
            try {
                userId = Integer.parseInt(userIdStr);
            } catch (NumberFormatException e) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Invalid user ID.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }

            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String birthdateStr = request.getParameter("birthdate");
            Date dateOfBirth = null;

            if (birthdateStr != null && !birthdateStr.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    dateOfBirth = sdf.parse(birthdateStr);
                } catch (ParseException e) {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", "Invalid birth date format.");
                    response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                    return;
                }
            }

            phone = phone.replaceAll("\\D+", "");
            if (phone.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Phone number cannot be empty.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }

            if (!phone.startsWith("0")) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Phone number must start with 0.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }

            if (phone.length() < 10) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Phone number must be at least 10 digits.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }

            AccountDAO accountDAO = new AccountDAO();
            User user = accountDAO.getUserById(userId);
            if (user == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "User does not exist.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }

            user.setFullName(fullName);
            user.setPhone(phone);
            user.setDateOfBirth(dateOfBirth);
            user.setAddress(address);

            HttpSession session = request.getSession();
            if (accountDAO.updateUser(user)) {
                session.setAttribute("currentUser", user);
                session.setAttribute("successMessage", "Profile updated successfully!");
                response.sendRedirect(request.getContextPath() + "/account/successProfile.jsp");
            } else {
                session.setAttribute("errorMessage", "Unable to update profile. Please try again.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            }

        } catch (SQLException e) {
            throw new ServletException("System error while updating profile: " + e.getMessage());
        }
    }
}
