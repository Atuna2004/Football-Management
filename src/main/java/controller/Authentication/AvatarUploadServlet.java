//package controller.Authentication;
//
//import java.io.File;
//import java.io.IOException;
//import java.nio.file.Paths;
//import java.sql.Connection;
//import connect.DBConnection;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import jakarta.servlet.http.Part;
//import java.sql.PreparedStatement;
//import model.User;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//
//@WebServlet("/uploadAvatar")
//@MultipartConfig(
//    fileSizeThreshold = 1024 * 1024 * 2,     // 2MB
//    maxFileSize = 1024 * 1024 * 10,          // 10MB
//    maxRequestSize = 1024 * 1024 * 50        // 50MB
//)
//public class AvatarUploadServlet extends HttpServlet {
//
//    private static final String UPLOAD_DIR = "images/avatars";
//    private static final String[] ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg"};
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        HttpSession session = request.getSession();
//        User currentUser = (User) session.getAttribute("currentUser");
//
//        if (currentUser == null) {
//            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
//            return;
//        }
//
//        try {
//            Part filePart = request.getPart("avatar");
//            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
//
//            // Kiểm tra phần mở rộng có hợp lệ không
//            String fileExt = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
//            boolean isValidFile = false;
//            for (String ext : ALLOWED_EXTENSIONS) {
//                if (ext.equals(fileExt)) {
//                    isValidFile = true;
//                    break;
//                }
//            }
//
//            if (!isValidFile) {
//                session.setAttribute("errorMessage", "Chỉ hỗ trợ các định dạng: .png, .jpg, .jpeg");
//                response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
//                return;
//            }
//
//            // Tạo đường dẫn lưu trữ file
//            String appPath = request.getServletContext().getRealPath("");
//            String uploadPath = appPath + File.separator + UPLOAD_DIR;
//            File uploadDir = new File(uploadPath);
//            if (!uploadDir.exists()) {
//                uploadDir.mkdirs();
//            }
//
//            // Tên file duy nhất
//            String uniqueFileName = generateUniqueFileName(fileName);
//            String filePath = uploadPath + File.separator + uniqueFileName;
//
//            // Lưu file vào server
//            filePart.write(filePath);
//
//            // Cập nhật DB
//            String avatarUrl = "/" + UPLOAD_DIR + "/" + uniqueFileName;
//
//            try (Connection conn = DBConnection.getConnection()) {
//                String sql = "UPDATE [User] SET AvatarUrl = ? WHERE UserID = ?";
//                PreparedStatement ps = conn.prepareStatement(sql);
//                ps.setString(1, avatarUrl);
//                ps.setInt(2, currentUser.getUserID());
//                ps.executeUpdate();
//
//                // Cập nhật session
//                currentUser.setAvatarUrl(avatarUrl);
//                session.setAttribute("currentUser", currentUser);
//            }
//
//            session.setAttribute("successMessage", "Đã cập nhật avatar thành công!");
//            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            session.setAttribute("errorMessage", "Lỗi khi tải lên ảnh đại diện.");
//            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
//        }
//    }
//
//    // Hàm tạo tên file duy nhất
//    private String generateUniqueFileName(String originalName) {
//        String ext = originalName.substring(originalName.lastIndexOf("."));
//        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
//        return timestamp + ext;
//    }
//}