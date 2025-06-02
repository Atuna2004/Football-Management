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

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("🟢 [POST] LoginServlet được gọi!");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("📩 [STEP 2] Email người dùng nhập: " + email);
        System.out.println("🔑 [STEP 3] Password người dùng nhập: " + password);

        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("🔌 [STEP 4] Kết nối DB thành công");

            AccountDAO dao = new AccountDAO(conn);
            User user = dao.getUserByEmail(email);

            if (user != null) {
                System.out.println("🧍 [STEP 5] User tìm thấy: " + user.getEmail());

                if (user.getPasswordHash().equals(password)) {
                    System.out.println("✅ [STEP 6] Mật khẩu đúng. Đăng nhập thành công");

                    HttpSession session = request.getSession();
                    session.setAttribute("currentUser", user);

                    System.out.println("➡️ [STEP 7] Redirect về trang home.jsp");
                    response.sendRedirect(request.getContextPath() + "/home.jsp");
                    return;

                } else {
                    System.out.println("❌ [ERROR] Mật khẩu sai");
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", "Sai email hoặc mật khẩu.");
                    response.sendRedirect(request.getContextPath() + "/account/login.jsp");
                    return;
                }

            } else {
                System.out.println("❌ [ERROR] Không tìm thấy user theo email");
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Sai email hoặc mật khẩu.");
                response.sendRedirect(request.getContextPath() + "/account/login.jsp");
                return;
            }

        } catch (Exception e) {
            System.out.println("❌ [ERROR] Lỗi khi truy vấn DB: " + e.getMessage());
            e.printStackTrace();

            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("➡️ [GET] Điều hướng tới login.jsp");
        request.getRequestDispatcher("account/login.jsp").forward(request, response);
    }
}
