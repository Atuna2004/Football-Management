package controller.Authentication;

import config.ConfigAPIKey;
import connect.DBConnection;
import dao.AccountDAO;
import model.User;
import service.PasswordService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.util.logging.Logger;
import org.json.JSONObject;

public class LoginFacebookServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginFacebookServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        LOGGER.info("Received Facebook login request with code: " + code);

        if (code == null || code.isEmpty()) {
            response.sendRedirect("account/login.jsp?error=missing_code");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);

            String accessToken = getAccessToken(code);
            LOGGER.info("Access token received: " + (accessToken != null ? "OK" : "Failed"));

            if (accessToken == null) {
                response.sendRedirect("account/login.jsp?error=token_failed");
                return;
            }

            JSONObject userInfo = getUserInfo(accessToken);
            LOGGER.info("User info received: " + userInfo);

            if (userInfo == null) {
                response.sendRedirect("account/login.jsp?error=user_info_failed");
                return;
            }

            String facebookId = userInfo.getString("id");
            String name = userInfo.getString("name");
            String email = userInfo.optString("email", facebookId + "@facebook.com");
            String avatarUrl = userInfo.getJSONObject("picture").getJSONObject("data").getString("url");

            User user = accountDAO.getUserByFacebookID(facebookId);

            if (user == null) {
                user = accountDAO.getUserByEmail(email);
                if (user == null) {
                    user = new User();
                    user.setEmail(email);
                    user.setFullName(name);
                    user.setPasswordHash(PasswordService.hashPassword(generateRandomPassword(10)));
                    user.setActive(true);
                    user.setAvatarUrl(avatarUrl);
                    user.setFacebookID(facebookId);
                    accountDAO.addUser(user);
                    user = accountDAO.getUserByEmail(email);
                    LOGGER.info("New Facebook user created: " + email);
                } else {
                    accountDAO.updateFacebookID(user.getUserID(), facebookId);
                    LOGGER.info("Existing user updated with Facebook ID: " + facebookId);
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            LOGGER.info("Facebook login successful. Redirecting to home.jsp");
            response.sendRedirect(request.getContextPath() + "/home.jsp");

        } catch (Exception e) {
            LOGGER.severe("Exception during Facebook login: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("account/login.jsp?error=system_error");
        }
    }

    private String getAccessToken(String code) {
        try {
            String redirectUri = ConfigAPIKey.getProperty("facebook.redirect.uri");
            String encodedRedirectUri = URLEncoder.encode(redirectUri, StandardCharsets.UTF_8);

            String url = ConfigAPIKey.getProperty("facebook.token.url")
                    + "?client_id=" + ConfigAPIKey.getProperty("facebook.client.id")
                    + "&redirect_uri=" + encodedRedirectUri
                    + "&client_secret=" + ConfigAPIKey.getProperty("facebook.client.secret")
                    + "&code=" + code;

            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
            connection.setRequestMethod("GET");

            int responseCode = connection.getResponseCode();
            try (BufferedReader in = new BufferedReader(new InputStreamReader(
                    responseCode == 200 ? connection.getInputStream() : connection.getErrorStream()))) {

                StringBuilder response = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }

                LOGGER.info("Facebook token response (" + responseCode + "): " + response);
                if (responseCode == 200) {
                    JSONObject json = new JSONObject(response.toString());
                    return json.getString("access_token");
                }
            }
        } catch (Exception e) {
            LOGGER.severe("Exception when getting access token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private JSONObject getUserInfo(String accessToken) {
        try {
            String url = ConfigAPIKey.getProperty("facebook.userinfo.url") + accessToken;
            HttpURLConnection con = (HttpURLConnection) new URL(url).openConnection();
            con.setRequestMethod("GET");

            try (BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()))) {
                StringBuilder response = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                return new JSONObject(response.toString());
            }
        } catch (Exception e) {
            LOGGER.severe("Exception when getting user info: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        java.util.Random rnd = new java.util.Random();
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return password.toString();
    }
}