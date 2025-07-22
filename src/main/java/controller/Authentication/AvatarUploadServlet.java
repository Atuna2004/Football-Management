package controller.Authentication;

import connect.DBConnection; // ✅ Import DBConnection
import config.CloudinaryUtils;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AvatarUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[AvatarUploadServlet] doPost called");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            System.out.println("[AvatarUploadServlet] No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        Integer userID = currentUser.getUserID();
        System.out.println("[AvatarUploadServlet] UserID: " + userID);

        Part filePart = request.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("[AvatarUploadServlet] No file selected");
            request.setAttribute("error", "Please select an image to upload");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        System.out.println("[AvatarUploadServlet] File name: " + filePart.getSubmittedFileName());
        System.out.println("[AvatarUploadServlet] File size: " + filePart.getSize() + " bytes");
        System.out.println("[AvatarUploadServlet] Content type: " + filePart.getContentType());

        // Kiểm tra loại file
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            System.out.println("[AvatarUploadServlet] File is not an image: " + contentType);
            request.setAttribute("error", "Only image files are allowed");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        // Kiểm tra kích thước file
        if (filePart.getSize() > 1024 * 1024 * 10) {
            System.out.println("[AvatarUploadServlet] File size exceeds 10MB: " + filePart.getSize());
            request.setAttribute("error", "File size exceeds the 10MB limit");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            // ✅ 1. Lấy kết nối từ DBConnection
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new SQLException("Failed to establish database connection.");
            }

            // ✅ 2. Truyền kết nối vào AccountDAO
            AccountDAO dao = new AccountDAO(conn);

            System.out.println("[AvatarUploadServlet] Starting Cloudinary upload for userID: " + userID);
            String avatarUrl = CloudinaryUtils.uploadImage(filePart, userID);
            System.out.println("[AvatarUploadServlet] Cloudinary upload successful: " + avatarUrl);

            // ✅ 3. Cập nhật avatar trong DB
            boolean updated = dao.updateAvatar(userID, avatarUrl);
            System.out.println("[AvatarUploadServlet] Avatar updated in DB: " + updated);

            if (!updated) {
                throw new SQLException("Failed to update avatar in database.");
            }

            // ✅ 4. Lấy lại thông tin người dùng mới
            User updatedUser = dao.getUserById(userID);
            if (updatedUser != null) {
                session.setAttribute("currentUser", updatedUser);
                session.setAttribute("avatar", avatarUrl);
                session.setAttribute("success", "Profile picture has been updated successfully");
                System.out.println("[AvatarUploadServlet] Session updated with new user data");
            } else {
                System.out.println("[AvatarUploadServlet] Warning: Updated user not found in DB");
            }

        } catch (SQLException e) {
            System.err.println("[AvatarUploadServlet] Database error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the database. Please try again later.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        } catch (IOException e) {
            System.err.println("[AvatarUploadServlet] Upload error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during image upload. Please try again later.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        } finally {
            // ✅ 5. Đóng kết nối
            if (conn != null) {
                try {
                    if (!conn.isClosed()) {
                        DBConnection.closeConnection(conn);
                    }
                } catch (SQLException ex) {
                    System.err.println("[AvatarUploadServlet] Failed to close connection: " + ex.getMessage());
                }
            }
        }

        System.out.println("[AvatarUploadServlet] Redirecting to profile.jsp");
        response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
    }
}