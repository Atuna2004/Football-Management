package controller.Authentication;

import dao.AccountDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/changePassword"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null
                || currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in all the required fields.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New password and confirm password do not match.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        try {
            AccountDAO accountDAO = new AccountDAO();

            User freshUser = accountDAO.getUserById(currentUser.getUserID());
            if (freshUser == null) {
                request.setAttribute("errorMessage", "User does not exist.");
                request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
                return;
            }

            if (!freshUser.getPasswordHash().equals(currentPassword)) {
                request.setAttribute("errorMessage", "Current password is incorrect.");
                request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
                return;
            }

            // TODO: hash the new password before saving
            freshUser.setPasswordHash(newPassword);

            boolean updated = accountDAO.updateUser(freshUser);
            if (updated) {
                session.setAttribute("currentUser", freshUser);
                request.setAttribute("successMessage", "Password changed successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to change password.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
        }

        request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
    }
}
