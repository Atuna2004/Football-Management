package controller.Admin;

import dao.AccountDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import model.User;
import connect.DBConnection;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet("/admin/user-list")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = DBConnection.getConnection();
            AccountDAO accountDAO = new AccountDAO(conn);
            List<User> userList = accountDAO.getAllUsers();

            // Set attribute để truyền sang JSP
            request.setAttribute("userList", userList);

            // Forward sang userManagement.jsp
            request.getRequestDispatcher("/admin/userManagement.jsp").forward(request, response);

        } catch (ServletException | IOException | SQLException e) {
            throw new ServletException("Lỗi tải danh sách người dùng", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            request.setAttribute("error", "Hành động không được cung cấp");
            doGet(request, response); // Tải lại trang nếu lỗi
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            AccountDAO accountDAO = new AccountDAO(conn);

            switch (action) {
                case "add":
                    addUser(request, response, accountDAO);
                    break;
                case "update":
                    updateUser(request, response, accountDAO);
                    break;
                case "delete":
                    deleteUser(request, response, accountDAO);
                    break;
                default:
                    request.setAttribute("error", "Hành động không hợp lệ: " + action);
                    doGet(request, response);
            }

        } catch (ServletException | IOException | SQLException e) {
            request.setAttribute("error", "Lỗi xử lý hành động: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException, ServletException, SQLException {
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String passwordHash = request.getParameter("passwordHash");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        boolean isActive = "on".equals(request.getParameter("isActive"));
        String address = request.getParameter("address");
        String dobStr = request.getParameter("dateOfBirth");

        Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                dob = Date.valueOf(dobStr);
            } catch (IllegalArgumentException ex) {
                request.setAttribute("error", "Ngày sinh không hợp lệ: " + dobStr);
                doGet(request, response);
                return;
            }
        }

        User user = new User();
        user.setEmail(email);
        user.setPasswordHash(passwordHash);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setActive(isActive);
        user.setAddress(address);
        user.setDateOfBirth(dob);

        System.out.println("Đang thêm người dùng: " + email);
        boolean success = accountDAO.addUser(user);

        if (success) {
            response.sendRedirect("user-list");
        } else {
            request.setAttribute("error", "Không thể thêm người dùng mới");
            doGet(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException, ServletException, SQLException {
        request.setCharacterEncoding("UTF-8");

        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            boolean isActive = request.getParameter("isActive") != null;
            String address = request.getParameter("address");
            String dobStr = request.getParameter("dateOfBirth");

            // Các trường thêm vào
            String googleID = request.getParameter("googleID");
            String avatarUrl = request.getParameter("avatarUrl");
            String passwordHash = request.getParameter("passwordHash");

            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    dob = Date.valueOf(dobStr);
                } catch (IllegalArgumentException e) {
                    request.setAttribute("error", "Ngày sinh không hợp lệ.");
                    doGet(request, response);
                    return;
                }
            }

            User user = new User();
            user.setUserID(userID);
            user.setEmail(email);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setActive(isActive);
            user.setAddress((address != null && !address.isEmpty()) ? address : null);
            user.setDateOfBirth(dob);
            user.setGoogleID((googleID != null && !googleID.isEmpty()) ? googleID : null);
            user.setAvatarUrl((avatarUrl != null && !avatarUrl.isEmpty()) ? avatarUrl : null);

            user.setPasswordHash((passwordHash != null && !passwordHash.isEmpty()) ? passwordHash : "");

            boolean success = accountDAO.updateUser(user);

            if (success) {
                response.sendRedirect("user-list");
            } else {
                request.setAttribute("error", "Không thể cập nhật người dùng");
                doGet(request, response);
            }
        } catch (ServletException | IOException | NumberFormatException | SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Lỗi cập nhật người dùng: " + ex.getMessage());
            doGet(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException, ServletException {
        String idStr = request.getParameter("id");
        if (idStr == null || !idStr.matches("\\d+")) {
            request.setAttribute("error", "ID người dùng không hợp lệ");
            doGet(request, response);
            return;
        }

        int userID = Integer.parseInt(idStr);
        boolean success = false;
        try {
            success = accountDAO.deleteUser(userID);
        } catch (SQLException e) {
        }

        if (success) {
            response.sendRedirect("user-list");
        } else {
            request.setAttribute("error", "Không thể xóa người dùng");
            doGet(request, response);
        }
    }
}
