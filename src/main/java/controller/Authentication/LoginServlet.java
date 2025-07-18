package controller.Authentication;

import dao.AccountDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Random;
import model.GoogleAccount;
import service.GoogleLogin;

public class LoginServlet extends HttpServlet {

    // Utility method to generate a random password
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%";
        StringBuilder password = new StringBuilder();
        Random rnd = new Random();
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return password.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            AccountDAO dao = new AccountDAO();
            User user = dao.getUserByEmail(email);

            if (user != null && user.getPasswordHash().equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                session.setAttribute("userID", user.getUserID());
                response.sendRedirect(request.getContextPath() + "/home.jsp");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Incorrect email or password.");
                response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "System error. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            response.sendRedirect("account/login.jsp?error=Missing code");
            return;
        }

        try {
            GoogleLogin gg = new GoogleLogin();
            String accessToken = gg.getToken(code);
            GoogleAccount acc = gg.getUserInfo(accessToken);

            if (acc == null || acc.getEmail() == null) {
                response.sendRedirect("account/login.jsp?error=Invalid token");
                return;
            }

            AccountDAO dao = new AccountDAO();
            User user = dao.getUserByEmail(acc.getEmail());

            // Register user if not exists
            if (user == null) {
                user = new User();
                user.setEmail(acc.getEmail());
                user.setFullName(acc.getName());
                user.setPasswordHash(generateRandomPassword(10));
                user.setPhone("");
                user.setActive(true);
                user.setGoogleID(acc.getId());
                user.setAvatarUrl(acc.getPicture());
                user.setCreatedAt(new java.util.Date());

                dao.addUser(user);
                user = dao.getUserByEmail(acc.getEmail());
            }

            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            session.setAttribute("userID", user.getUserID());
            response.sendRedirect(request.getContextPath() + "/home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Google login error. Please try again.");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
        }
    }
}
