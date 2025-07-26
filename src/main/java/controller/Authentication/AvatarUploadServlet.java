package controller.Authentication;

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
import java.sql.SQLException;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
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

        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            System.out.println("[AvatarUploadServlet] File is not an image, contentType: " + contentType);
            request.setAttribute("error", "Only image files are allowed");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        if (filePart.getSize() > 1024 * 1024 * 10) {
            System.out.println("[AvatarUploadServlet] File size exceeds 10MB limit: " + filePart.getSize());
            request.setAttribute("error", "File size exceeds the 10MB limit");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        try (java.sql.Connection conn = connect.DBConnection.getConnection()) {
            AccountDAO dao = new AccountDAO(conn); // Truyền connection vào DAO
            System.out.println("[AvatarUploadServlet] Starting Cloudinary upload for userID: " + userID);

            String avatarUrl = CloudinaryUtils.uploadImage(filePart, userID);
            System.out.println("[AvatarUploadServlet] Cloudinary upload successful: " + avatarUrl);

            boolean updated = dao.updateAvatar(userID, avatarUrl);
            System.out.println("[AvatarUploadServlet] Avatar updated in DB: " + updated);

            // Cập nhật currentUser trong session
            User updatedUser = dao.getUserById(userID);
            System.out.println("[AvatarUploadServlet] Retrieved updated user: " + (updatedUser != null ? updatedUser.getEmail() : "null"));
            session.setAttribute("currentUser", updatedUser);
            session.setAttribute("success", "Ảnh đại diện đã được cập nhật thành công");

        } catch (IOException e) {
            System.out.println("[AvatarUploadServlet] IOException during upload/update: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình tải ảnh lên. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return; // Thêm return ở đây
        } catch (SQLException e) {
            System.out.println("[AvatarUploadServlet] SQLException during DB update: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật cơ sở dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return; // Thêm return ở đây
        }

        System.out.println("[AvatarUploadServlet] Redirecting to profile.jsp");
        response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
    }
}
