package controller.Authentication;

import jakarta.servlet.ServletContext; // Thêm import
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashSet; // Thêm import

import model.User; // Thêm import

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {

            // === PHẦN CODE MỚI ĐỂ CẬP NHẬT SỐ NGƯỜI ONLINE ===
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
                ServletContext context = getServletContext();
                synchronized (context) {
                    HashSet<Integer> onlineUsers = (HashSet<Integer>) context.getAttribute("onlineUsers");
                    if (onlineUsers != null) {
                        onlineUsers.remove(currentUser.getUserID());
                        context.setAttribute("onlineUsers", onlineUsers);
                    }
                }
            }
            // ===============================================

            session.invalidate(); // Hủy session sau khi đã xử lý
        }

        // Chuyển hướng về trang đăng nhập hoặc trang chủ
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
}