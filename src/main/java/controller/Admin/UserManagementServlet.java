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
            
            // Pagination parameters
            int page = 1;
            int recordsPerPage = 10; // Default records per page
            
            // Parse page parameter
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Parse records per page parameter
            String recordsPerPageStr = request.getParameter("size");
            if (recordsPerPageStr != null && !recordsPerPageStr.isEmpty()) {
                try {
                    recordsPerPage = Integer.parseInt(recordsPerPageStr);
                    if (recordsPerPage < 1) recordsPerPage = 10;
                    if (recordsPerPage > 100) recordsPerPage = 100; // Max limit
                } catch (NumberFormatException e) {
                    recordsPerPage = 10;
                }
            }
            
            // Get filter parameter from URL
            String filter = request.getParameter("filter");
            List<User> userList;
            int totalRecords;
            
            // Apply filtering based on the filter parameter with pagination
            if (filter != null && !filter.isEmpty()) {
                switch (filter.toLowerCase()) {
                    case "user":
                        try {
                            userList = accountDAO.getUsersByRoleWithPagination("user", page, recordsPerPage);
                            totalRecords = accountDAO.getTotalUserCountByRole("user");
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleWithPagination("User", page, recordsPerPage);
                                totalRecords = accountDAO.getTotalUserCountByRole("User");
                            }
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleIDWithPagination(3, page, recordsPerPage);
                                totalRecords = accountDAO.getTotalUserCountByRoleID(3);
                            }
                        } catch (SQLException e) {
                            userList = accountDAO.getUsersByRoleIDWithPagination(3, page, recordsPerPage);
                            totalRecords = accountDAO.getTotalUserCountByRoleID(3);
                        }
                        break;
                    case "owner":
                        try {
                            userList = accountDAO.getUsersByRoleWithPagination("owner", page, recordsPerPage);
                            totalRecords = accountDAO.getTotalUserCountByRole("owner");
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleWithPagination("Owner", page, recordsPerPage);
                                totalRecords = accountDAO.getTotalUserCountByRole("Owner");
                            }
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleIDWithPagination(2, page, recordsPerPage);
                                totalRecords = accountDAO.getTotalUserCountByRoleID(2);
                            }
                        } catch (SQLException e) {
                            userList = accountDAO.getUsersByRoleIDWithPagination(2, page, recordsPerPage);
                            totalRecords = accountDAO.getTotalUserCountByRoleID(2);
                        }
                        break;
                    case "admin":
                        try {
                            userList = accountDAO.getUsersByRoleWithPagination("admin", page, recordsPerPage);
                            totalRecords = accountDAO.getTotalUserCountByRole("admin");
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleWithPagination("Admin", page, recordsPerPage);
                                totalRecords = accountDAO.getTotalUserCountByRole("Admin");
                            }
                            if (userList.isEmpty()) {
                                userList = accountDAO.getUsersByRoleIDWithPagination(1, page, recordsPerPage);
                                totalRecords = accountDAO.getTotalUserCountByRoleID(1);
                            }
                        } catch (SQLException e) {
                            userList = accountDAO.getUsersByRoleIDWithPagination(1, page, recordsPerPage);
                            totalRecords = accountDAO.getTotalUserCountByRoleID(1);
                        }
                        break;
                    default:
                        userList = accountDAO.getUsersByPageWithRoles(page, recordsPerPage);
                        totalRecords = accountDAO.getTotalUserCount();
                        break;
                }
            } else {
                // No filter, get all users with pagination
                userList = accountDAO.getUsersByPageWithRoles(page, recordsPerPage);
                totalRecords = accountDAO.getTotalUserCount();
            }
            
            // Calculate pagination info
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            if (totalPages == 0) totalPages = 1; // At least 1 page
            
            // Ensure current page is within valid range
            if (page > totalPages) {
                page = totalPages;
                // Redirect to the last valid page
                StringBuilder redirectUrl = new StringBuilder("user-list?page=" + page);
                if (filter != null && !filter.isEmpty()) {
                    redirectUrl.append("&filter=").append(filter);
                }
                if (recordsPerPageStr != null && !recordsPerPageStr.isEmpty()) {
                    redirectUrl.append("&size=").append(recordsPerPage);
                }
                response.sendRedirect(redirectUrl.toString());
                return;
            }
            
            // Calculate pagination display range (show 5 pages at a time)
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);
            
            // If we're at the beginning, show more pages towards the end
            if (endPage - startPage < 4 && totalPages > 4) {
                if (startPage == 1) {
                    endPage = Math.min(totalPages, startPage + 4);
                } else if (endPage == totalPages) {
                    startPage = Math.max(1, endPage - 4);
                }
            }
            
            // Set attributes for JSP
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
            
            // For displaying record range
            int startRecord = (page - 1) * recordsPerPage + 1;
            int endRecord = Math.min(page * recordsPerPage, totalRecords);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);
            
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
            // Preserve pagination parameters when redirecting after error
            String redirectUrl = buildRedirectUrl(request, "user-list");
            response.sendRedirect(redirectUrl);
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
                String redirectUrl = buildRedirectUrl(request, "user-list");
                response.sendRedirect(redirectUrl);
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
        
        // Preserve pagination parameters when redirecting
        String redirectUrl = buildRedirectUrl(request, "user-list");
        response.sendRedirect(redirectUrl);
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
                    String redirectUrl = buildRedirectUrl(request, "user-list");
                    response.sendRedirect(redirectUrl);
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

            // If user enters new password, hash it
            if (password != null && !password.trim().isEmpty()) {
                user.setPasswordHash(hashPassword(password));
            } else {
                User existing = accountDAO.getUserById(userID);
                if (existing != null) {
                    user.setPasswordHash(existing.getPasswordHash());
                } else {
                    String redirectUrl = buildRedirectUrl(request, "user-list");
                    response.sendRedirect(redirectUrl);
                    return;
                }
            }

            accountDAO.updateUser(user);
            
            // Preserve pagination parameters when redirecting
            String redirectUrl = buildRedirectUrl(request, "user-list");
            response.sendRedirect(redirectUrl);
        } catch (NumberFormatException ex) {
            String redirectUrl = buildRedirectUrl(request, "user-list");
            response.sendRedirect(redirectUrl);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, AccountDAO accountDAO)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || !idStr.matches("\\d+")) {
            String redirectUrl = buildRedirectUrl(request, "user-list");
            response.sendRedirect(redirectUrl);
            return;
        }

        int userID = Integer.parseInt(idStr);
        try {
            accountDAO.deleteUser(userID);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Preserve pagination parameters when redirecting
        String redirectUrl = buildRedirectUrl(request, "user-list");
        response.sendRedirect(redirectUrl);
    }

    /**
     * Helper method to build redirect URL while preserving pagination parameters
     */
    private String buildRedirectUrl(HttpServletRequest request, String baseUrl) {
        StringBuilder url = new StringBuilder(baseUrl);
        String page = request.getParameter("page");
        String size = request.getParameter("size");
        String filter = request.getParameter("filter");
        
        boolean hasParams = false;
        
        if (page != null && !page.isEmpty()) {
            url.append("?page=").append(page);
            hasParams = true;
        }
        
        if (size != null && !size.isEmpty()) {
            url.append(hasParams ? "&" : "?").append("size=").append(size);
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