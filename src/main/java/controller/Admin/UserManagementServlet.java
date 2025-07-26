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

            int page = 1;
            final int recordsPerPage = 5;

            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            String filter = request.getParameter("filter");
            List<User> userList;
            int totalRecords;


            if (filter != null && !filter.isEmpty()) {
                switch (filter.toLowerCase()) {
                    case "user":
                        totalRecords = accountDAO.getTotalUserCountByRole("user");
                        userList = accountDAO.getUsersByRoleWithPagination("user", page, recordsPerPage);
                        break;
                    case "owner":
                        totalRecords = accountDAO.getTotalUserCountByRole("owner");
                        userList = accountDAO.getUsersByRoleWithPagination("owner", page, recordsPerPage);
                        break;
                    case "admin":
                        totalRecords = accountDAO.getTotalUserCountByRole("admin");
                        userList = accountDAO.getUsersByRoleWithPagination("admin", page, recordsPerPage);
                        break;
                    default:
                        userList = accountDAO.getUsersByPageWithRoles(page, recordsPerPage);
                        totalRecords = accountDAO.getTotalUserCount();
                        break;
                }
            } else {
                userList = accountDAO.getUsersByPageWithRoles(page, recordsPerPage);
                totalRecords = accountDAO.getTotalUserCount();
            }

            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            if (totalPages == 0) totalPages = 1;

            if (page > totalPages) {
                page = totalPages;
                response.sendRedirect(buildRedirectUrl(request, "user-list"));
                return;
            }

            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);

            if (endPage - startPage < 4 && totalPages > 4) {
                if (startPage == 1) {
                    endPage = Math.min(totalPages, startPage + 4);
                } else if (endPage == totalPages) {
                    startPage = Math.max(1, endPage - 4);
                }
            }

            request.setAttribute("userList", userList);
            request.setAttribute("currentFilter", filter);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("hasPrevious", page > 1);
            request.setAttribute("hasNext", page < totalPages);
            request.setAttribute("startRecord", (page - 1) * recordsPerPage + 1);
            request.setAttribute("endRecord", Math.min(page * recordsPerPage, totalRecords));

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
            response.sendRedirect(buildRedirectUrl(request, "user-list"));
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
            dob = Date.valueOf(dobStr);
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

        response.sendRedirect(buildRedirectUrl(request, "user-list"));
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException, SQLException {
        request.setCharacterEncoding("UTF-8");

        int userID = Integer.parseInt(request.getParameter("userID"));
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        boolean isActive = request.getParameter("isActive") != null;
        String address = request.getParameter("address");
        String dobStr = request.getParameter("dateOfBirth");
        String password = request.getParameter("password");

        Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            dob = Date.valueOf(dobStr);
        }

        User user = accountDAO.getUserById(userID);
        if (user == null) {
            response.sendRedirect(buildRedirectUrl(request, "user-list"));
            return;
        }

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setActive(isActive);
        user.setAddress(address);
        user.setDateOfBirth(dob);

        if (password != null && !password.trim().isEmpty()) {
            user.setPasswordHash(hashPassword(password));
        }

        accountDAO.updateUser(user);

        response.sendRedirect(buildRedirectUrl(request, "user-list"));
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException, SQLException {
        int userID = Integer.parseInt(request.getParameter("id"));
        accountDAO.deleteUser(userID);
        response.sendRedirect(buildRedirectUrl(request, "user-list"));
    }

    private String buildRedirectUrl(HttpServletRequest request, String baseUrl) {
        StringBuilder url = new StringBuilder(baseUrl);
        String page = request.getParameter("page");
        String filter = request.getParameter("filter");

        boolean hasParams = false;

        if (page != null && !page.isEmpty()) {
            url.append("?page=").append(page);
            hasParams = true;
        }

        if (filter != null && !filter.isEmpty()) {
            url.append(hasParams ? "&" : "?").append("filter=").append(filter);
        }
        return url.toString();
    }

    private String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }
}