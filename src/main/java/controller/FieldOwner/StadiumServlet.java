package controller.FieldOwner;

import config.CloudinaryUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

import dao.StadiumDAO;
import jakarta.servlet.annotation.WebServlet;
import model.Stadium;
import model.User;

@WebServlet("/stadium/config")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class StadiumServlet extends HttpServlet {
    private StadiumDAO stadiumDAO = new StadiumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
            return;
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStadium(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "create":
                createStadium(request, response);
                break;
            case "update":
                updateStadium(request, response);
                break;
            case "delete":
                deleteStadium(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
                break;
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
    }

    private void createStadium(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("=== CREATE STADIUM DEBUG ===");
        System.out.println("Content-Type: " + request.getContentType());
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String phoneNumber = request.getParameter("phoneNumber");
        Timestamp createdAt = new Timestamp(new Date().getTime());
        User currentUser = (User) session.getAttribute("currentUser");
        int OwnerID = currentUser.getUserID();
        
        System.out.println("Stadium name: " + name);
        System.out.println("Owner ID: " + OwnerID);
        
        Stadium stadium = new Stadium();
        stadium.setName(name);
        stadium.setLocation(location);
        stadium.setDescription(description);
        stadium.setStatus(status);
        stadium.setPhoneNumber(phoneNumber);
        stadium.setCreatedAt(createdAt);
        stadium.setOwnerID(OwnerID);

        String imageURL = null;
        try {
            Part imagePart = request.getPart("stadiumImage");
            System.out.println("Image part: " + (imagePart != null ? "Found" : "NULL"));
            if (imagePart != null) {
                System.out.println("Image size: " + imagePart.getSize() + " bytes");
                System.out.println("Image content type: " + imagePart.getContentType());
            }
            
            if (imagePart != null && imagePart.getSize() > 0) {
                System.out.println("Uploading image to Cloudinary...");
                imageURL = CloudinaryUtils.uploadImage(imagePart, OwnerID);
                stadium.setImageURL(imageURL);
                System.out.println("✅ Image uploaded successfully: " + imageURL);
            } else {
                System.out.println("⚠️ No image to upload");
            }
        } catch (Exception e) {
            System.out.println("❌ Error with image upload: " + e.getMessage());
            e.printStackTrace();
        }

        boolean success;
        if (stadium.getImageURL() != null && !stadium.getImageURL().trim().isEmpty()) {
            System.out.println("✅ Calling insertStadiumWithImage() - Image URL: " + stadium.getImageURL());
            success = stadiumDAO.insertStadiumWithImage(stadium);
        } else {
            System.out.println("⚠️ Calling insertStadium() - No image URL");
            success = stadiumDAO.insertStadium(stadium);
        }

        System.out.println("Insert result: " + success);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
        } else {
            request.setAttribute("errorMessage", "Có lỗi khi thêm sân.");
            request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int stadiumId = Integer.parseInt(request.getParameter("id"));
        Stadium stadium = stadiumDAO.getStadiumById(stadiumId);
        
        System.out.println("=== SHOW EDIT FORM DEBUG ===");
        System.out.println("Stadium ID: " + stadiumId);
        System.out.println("Stadium found: " + (stadium != null ? stadium.getName() : "NULL"));
        if (stadium != null) {
            System.out.println("Current image URL: " + stadium.getImageURL());
        }
        
        request.setAttribute("stadium", stadium);
        request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
    }

    private void updateStadium(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("===== UPDATE STADIUM DEBUG =====");
        System.out.println("Content-Type: " + request.getContentType());
        
        request.setCharacterEncoding("UTF-8");

        int stadiumID = Integer.parseInt(request.getParameter("stadiumID"));
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String phoneNumber = request.getParameter("phoneNumber");

        System.out.println("Stadium ID: " + stadiumID);
        System.out.println("Stadium name: " + name);

        Stadium stadium = new Stadium();
        stadium.setStadiumID(stadiumID);
        stadium.setName(name);
        stadium.setLocation(location);
        stadium.setDescription(description);
        stadium.setStatus(status);
        stadium.setPhoneNumber(phoneNumber);

        String imageURL = null;
        try {
            Part imagePart = request.getPart("stadiumImage");
            System.out.println("Image part found: " + (imagePart != null));
            if (imagePart != null) {
                System.out.println("Image size: " + imagePart.getSize() + " bytes");
                System.out.println("Image content type: " + imagePart.getContentType());
                System.out.println("Image name: " + imagePart.getSubmittedFileName());
            }
            
            if (imagePart != null && imagePart.getSize() > 0) {
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("currentUser");
                int OwnerID = currentUser.getUserID();
                System.out.println("🔄 Uploading new image to Cloudinary...");
                imageURL = CloudinaryUtils.uploadImage(imagePart, OwnerID);
                stadium.setImageURL(imageURL);
                System.out.println("✅ New image uploaded successfully: " + imageURL);
            } else {
                System.out.println("⚠️ No new image to upload");
            }
        } catch (Exception e) {
            System.out.println("❌ Error with image processing: " + e.getMessage());
            e.printStackTrace();
        }

        // CRITICAL: Check which DAO method to call
        boolean success;
        if (stadium.getImageURL() != null && !stadium.getImageURL().trim().isEmpty()) {
            System.out.println("✅ Calling updateStadiumWithImage() - Image URL: " + stadium.getImageURL());
            success = stadiumDAO.updateStadiumWithImage(stadium);
        } else {
            System.out.println("⚠️ Calling updateStadium() - No image URL to save");
            success = stadiumDAO.updateStadium(stadium);
        }

        System.out.println("📊 Database update result: " + success);

        if (success) {
            System.out.println("🎉 Update successful, redirecting...");
            response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
        } else {
            System.out.println("💥 Update failed!");
            request.setAttribute("errorMessage", "Cập nhật thất bại.");
            request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
        }
    }

    private void deleteStadium(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
        if (stadiumDAO.deleteStadium(stadiumId)) {
            request.getSession().setAttribute("successMessage", "Xóa sân thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Xóa sân thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
    }
}