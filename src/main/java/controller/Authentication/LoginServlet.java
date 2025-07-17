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
import java.util.Random;

import model.GoogleAccount;
import service.GoogleLogin;
import service.PasswordService;

@WebServlet("/user-login")
public class LoginServlet extends HttpServlet {

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

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO dao = new AccountDAO(conn);
            User user = dao.getUserByEmail(email);

            if (user != null) {
                if (PasswordService.checkPassword(password, user.getPasswordHash())) {
                    HttpSession session = request.getSession();
                    session.setAttribute("currentUser", user);
                    response.sendRedirect(request.getContextPath() + "/home.jsp");
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", "Sai email hoặc mật khẩu.");
                    response.sendRedirect(request.getContextPath() + "/account/login.jsp");
                }
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Sai email hoặc mật khẩu.");
                response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            }

        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
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

        try (Connection conn = DBConnection.getConnection()) {
            GoogleLogin gg = new GoogleLogin();
            String accessToken = gg.getToken(code);
            GoogleAccount acc = gg.getUserInfo(accessToken);

            if (acc == null || acc.getEmail() == null) {
                response.sendRedirect("account/login.jsp?error=Invalid token");
                return;
            }

            AccountDAO dao = new AccountDAO(conn);
            User user = dao.getUserByEmail(acc.getEmail());

            if (user == null) {
                user = new User();
                user.setEmail(acc.getEmail());
                user.setFullName(acc.getName());
                user.setPasswordHash(PasswordService.hashPassword(generateRandomPassword(10))); // hashed
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
            response.sendRedirect(request.getContextPath() + "/home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi đăng nhập bằng Google. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
        }
    }
}