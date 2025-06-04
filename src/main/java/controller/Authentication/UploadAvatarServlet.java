//package controller.Authentication;
//
//import connect.DBConnection;
//import dao.AccountDAO;
//import model.User;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import jakarta.servlet.http.Part;
//
//import java.io.File;
//import java.io.IOException;
//import java.sql.Connection;
//import java.sql.SQLException;
//import java.util.UUID;
//
//@WebServlet("/uploadAvatar")
//@MultipartConfig(
//    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
//    maxFileSize = 1024 * 1024 * 10,      // 10MB
//    maxRequestSize = 1024 * 1024 * 50    // 50MB
//)
//public class UploadAvatarServlet extends HttpServlet {
//
//    private static final String AVATAR_UPLOAD_DIR = "assets/avatars";
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        // Lấy user hiện tại từ session
//        HttpSession session = request.getSession(false);
//        if (session == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
//        User currentUser = (User) session.getAttribute("currentUser");
//        if (currentUser == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
//
//        // Tạo thư mục lưu file nếu chưa tồn tại
//        String uploadPath = getServletContext().getRealPath("") + File.separator + AVATAR_UPLOAD_DIR;
//        File uploadDir = new File(uploadPath);
//        if (!uploadDir.exists()) uploadDir.mkdirs();
//
//        try {
//            // Lấy file từ form
//            Part filePart = request.getPart("avatar");
//            if (filePart == null || filePart.getSize() == 0) {
//                response.sendRedirect(request.getContextPath() + "/account/profile.jsp?error=No file selected");
//                return;
//            }
//
//            // Đặt tên file mới để tránh trùng lặp
//            String fileName = UUID.randomUUID().toString() + "_" + extractFileName(filePart);
//            String filePath = uploadPath + File.separator + fileName;
//
//            // Ghi file lên server
//            filePart.write(filePath);
//
//            // Tạo đường dẫn để lưu vào DB
//            String avatarUrl = AVATAR_UPLOAD_DIR + "/" + fileName;
//
//            // Cập nhật DB
//            try (Connection conn = DBConnection.getConnection()) {
//                AccountDAO dao = new AccountDAO(conn);
//                boolean updated = dao.updateAvatar(currentUser.getUserID(), avatarUrl);
//                if (updated) {
//                    currentUser.setAvatarUrl(avatarUrl);
//                    session.setAttribute("currentUser", currentUser);
//                    response.sendRedirect(request.getContextPath() + "/account/profile.jsp?success=Avatar updated successfully");
//                } else {
//                    response.sendRedirect(request.getContextPath() + "/account/profile.jsp?error=Update failed");
//                }
//            } catch (SQLException e) {
//                throw new ServletException("Database error", e);
//            }
//        } catch (IllegalStateException e) {
//            // File quá lớn
//            response.sendRedirect(request.getContextPath() + "/account/profile.jsp?error=File too large");
//        }
//    }
//
//    private String extractFileName(Part part) {
//        String contentDisp = part.getHeader("content-disposition");
//        if (contentDisp == null) return "avatar.png";
//
//        for (String token : contentDisp.split(";")) {
//            if (token.trim().startsWith("filename")) {
//                String fileName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
//                // Đảm bảo lấy tên file không có đường dẫn (Windows fix)
//                return new File(fileName).getName();
//            }
//        }
//        return "avatar.png";
//    }
//}
