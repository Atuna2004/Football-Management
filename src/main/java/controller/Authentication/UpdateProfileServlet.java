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
                session.setAttribute("errorMessage", "Không tìm thấy ID người dùng.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }
            int userId;
            try {
                userId = Integer.parseInt(userIdStr);
            } catch (NumberFormatException e) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "ID người dùng không hợp lệ.");
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
                    session.setAttribute("errorMessage", "Định dạng ngày sinh không đúng.");
                    response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                    return;
                }
            }
            phone = phone.replaceAll("\\D+", ""); // Chỉ giữ lại số
            if (phone.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Số điện thoại không thể để trống.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }
            if (!phone.startsWith("0")) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Số điện thoại phải bắt đầu bằng số 0.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }
            if (phone.length() < 10) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Số điện thoại phải có ít nhất 10 chữ số.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }
            Connection conn = DBConnection.getConnection();
            AccountDAO accountDAO = new AccountDAO(conn);
            User user = accountDAO.getUserById(userId);
            if (user == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Người dùng không tồn tại.");
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
                session.setAttribute("successMessage", "Cập nhật hồ sơ thành công!");
                response.sendRedirect(request.getContextPath() + "/account/successProfile.jsp");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật hồ sơ. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi hệ thống khi cập nhật hồ sơ: " + e.getMessage());
        }
    }
}
