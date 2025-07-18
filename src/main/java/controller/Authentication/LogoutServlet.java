package controller.Authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // Invalidate the current session (remove user information)
        HttpSession session = request.getSession(false); // false: do not create a new session if one doesn't exist
        if (session != null) {
            session.invalidate();
        }

        // Redirect to the login page or home page
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
}
