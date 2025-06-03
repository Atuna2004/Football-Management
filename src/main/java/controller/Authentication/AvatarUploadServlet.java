package controller.Authentication;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import connect.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.PreparedStatement;

@WebServlet("/uploadAvatar")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,     // 2MB
                 maxFileSize = 1024 * 1024 * 10,          // 10MB
                 maxRequestSize = 1024 * 1024 * 50)       // 50MB
public class AvatarUploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "images/avatars";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username"); // Giả sử bạn lưu user trong session

        Part filePart = request.getPart("avatar");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        String appPath = request.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // Save relative path to DB (ví dụ: images/avatars/avatar1.png)
        String avatarPath = UPLOAD_DIR + "/" + fileName;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE Users SET avatar = ? WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, avatarPath);
            ps.setString(2, username);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("/account/profile.jsp"); // quay lại profile
    }
}
