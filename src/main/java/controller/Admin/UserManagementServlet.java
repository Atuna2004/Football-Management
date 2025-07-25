package controller.Admin;

import dao.AccountDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import connect.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/admin/user-list")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);
            
            // Get filter parameter from URL
            String filter = request.getParameter("filter");
            List<User> userList;
            
            // Apply filtering based on the filter parameter
            if (filter != null && !filter.isEmpty()) {
                switch (filter.toLowerCase()) {
                    case "user":
                        // Try with different possible role names
                        try {
                            userList = accountDAO.getUsersByRole("user");
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRole("User");
                            }
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleID(3); // RoleID 3 for regular users
                            }
                        } catch (SQLException e) {
                            userList = accountDAO.getUsersByRoleID(3);
                        }
                        break;
                    case "owner":
                        // Try with different possible role names
                        try {
                            userList = accountDAO.getUsersByRole("owner");
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRole("Owner");
                            }
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleID(2); // RoleID 2 for field owners
                            }
                        } catch (SQLException e) {
                            userList = accountDAO.getUsersByRoleID(2);
                        }
                        break;
                    case "admin":
                        // Try with different possible role names
                        try {
                            userList = accountDAO.getUsersByRole("admin");
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRole("Admin");
                            }
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleID(1); // RoleID 1 for admin
                            }
                        } catch (SQLException e) {
                            userList = accountDAO.getUsersByRoleID(1);
                        }
                        break;
                    default:
                        userList = accountDAO.getAllUsers();
                        break;
                }
            } else {
                // No filter, get all users
                userList = accountDAO.getAllUsers();
            }
            
            request.setAttribute("userList", userList);
            request.setAttribute("currentFilter", filter);
            request.getRequestDispatcher("/admin/userManagement.jsp").forward(request, response);
        } catch (SQLException e) {
            Logger.getLogger(UserManagementServlet.class.getName()).log(Level.SEVERE, null, e);
            throw new ServletException("Error loading user list", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect("user-list");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
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
            response.sendRedirect("user-list");
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException, SQLException {
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
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
        user.setPasswordHash(hashPassword(password));
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setActive(isActive);
        user.setAddress(address);
        user.setDateOfBirth(dob);

        accountDAO.addUser(user);
        response.sendRedirect("user-list");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException, SQLException {
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
            String password = request.getParameter("password");

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

            // Nếu người dùng nhập mật khẩu mới, hash lại
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

            accountDAO.updateUser(user);
            response.sendRedirect("user-list");
        } catch (NumberFormatException ex) {
            response.sendRedirect("user-list");
        }
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
            accountDAO.deleteUser(userID);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("user-list");
    }

    private String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }
}