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
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/admin/user-list")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = DBConnection.getConnection();
            AccountDAO accountDAO = new AccountDAO(conn);
            List<User> userList = accountDAO.getAllUsers();

            request.setAttribute("userList", userList);
            request.getRequestDispatcher("/admin/userManagement.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Lỗi tải danh sách người dùng", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            // Chuyển hướng lại servlet thay vì gọi doGet
            response.sendRedirect("user-list");
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
                    response.sendRedirect("user-list");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user-list"); // Chuyển hướng khi có lỗi
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
                response.sendRedirect("user-list");
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

        boolean success = accountDAO.addUser(user);

        if (success) {
            response.sendRedirect("user-list");
        } else {
            response.sendRedirect("user-list");
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

            String googleID = request.getParameter("googleID");
            String avatarUrl = request.getParameter("avatarUrl");
            String password = request.getParameter("passwordHash");

            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    dob = Date.valueOf(dobStr);
                } catch (IllegalArgumentException e) {
                    response.sendRedirect("user-list");
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

            if (password != null && !password.trim().isEmpty()) {
                user.setPasswordHash(hashPassword(password));
            } else {

               User existing = accountDAO.getUserById(userID);
                if (existing != null) {
                    user.setPasswordHash(existing.getPasswordHash());
                } else {
                    response.sendRedirect("user-list");
                    return;
                }
            }
            boolean success = accountDAO.updateUser(user);

            if (success) {
                response.sendRedirect("user-list");
            } else {
                response.sendRedirect("user-list");
            }
        } catch (IOException | NumberFormatException | SQLException ex) {
            response.sendRedirect("user-list");
        }
    }

    private String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || !idStr.matches("\\d+")) {
            response.sendRedirect("user-list");
            return;
        }

        int userID = Integer.parseInt(idStr);
        try {
            boolean success = accountDAO.deleteUser(userID);
            response.sendRedirect("user-list");
        } catch (SQLException e) {
            response.sendRedirect("user-list");
        }
    }
}
