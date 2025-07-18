package controller.FieldOwner;

import dao.OwnerRequestDAO;
import model.OwnerRequest;
import connect.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;


@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15    // 15MB
)

@WebServlet("/submit-owner-request")
public class SubmitOwnerRequestServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Connection connection = null;
        
        try {
            // Kiểm tra user đã đăng nhập chưa
            model.User currentUser = (model.User) session.getAttribute("currentUser");
            if (currentUser == null) {
                session.setAttribute("ownerRequestError", "Bạn cần đăng nhập để gửi yêu cầu.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // Kết nối database
            connection = DBConnection.getConnection();
            if (connection == null) {
                throw new Exception("Không thể kết nối database");
            }
            
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String message = request.getParameter("message");

            // Nhận file upload
            Part businessLicensePart = request.getPart("businessLicense");
            System.out.println("Tên file giấy phép kinh doanh: " + businessLicensePart);
            String businessLicense = "";

            if (businessLicensePart != null && businessLicensePart.getSize() > 0) {
                String fileName = Paths.get(businessLicensePart.getSubmittedFileName()).getFileName().toString();
                if (!fileName.toLowerCase().endsWith(".pdf")) {
                    session.setAttribute("ownerRequestError", "Chỉ chấp nhận file PDF.");
                    response.sendRedirect(request.getContextPath() + "/become-owner-request.jsp");
                    return;
                }
                // Lưu file vào thư mục uploads trên server
                String uploadPath = getServletContext().getRealPath("/uploads") + File.separator + fileName;
                File uploadDir = new File(getServletContext().getRealPath("/uploads"));
                if (!uploadDir.exists()) uploadDir.mkdirs();

                try (InputStream input = businessLicensePart.getInputStream()) {
                    Files.copy(input, Paths.get(uploadPath), StandardCopyOption.REPLACE_EXISTING);
                }
                businessLicense = fileName; // Lưu tên file vào thuộc tính
            }
            
            // Validate dữ liệu cơ bản
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty()) {
                session.setAttribute("ownerRequestError", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                response.sendRedirect(request.getContextPath() + "/become-owner-request.jsp");
                return;
            }
            
            // Tạo đối tượng yêu cầu
            OwnerRequest ownerRequest = new OwnerRequest();
            ownerRequest.setUserID(currentUser.getUserID());
            ownerRequest.setFullName(fullName.trim());
            ownerRequest.setEmail(email.trim());
            ownerRequest.setPhoneNumber(phone.trim());
            ownerRequest.setBusinessLicense(businessLicense != null ? businessLicense.trim() : "");
            ownerRequest.setMessage(message != null ? message.trim() : "");
            
            // Lưu vào DB
            OwnerRequestDAO dao = new OwnerRequestDAO(connection);
            boolean success = dao.saveRequest(ownerRequest);
            
            if (success) {
                session.setAttribute("ownerRequestSuccess", true);
                response.sendRedirect(request.getContextPath() + "/request-success.jsp");
            } else {
                session.setAttribute("ownerRequestError", "Không thể gửi yêu cầu. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/become-owner-request.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in SubmitOwnerRequestServlet: " + e.getMessage());
            session.setAttribute("ownerRequestError", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/become-owner-request.jsp");
            
        } finally {
            try {
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}