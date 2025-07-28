package controller.Stadium;

import config.CloudinaryUtils;
import dao.StadiumDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Stadium;

import java.io.IOException;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class StadiumImageServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("[StadiumImageServlet] Processing stadium image upload");
        
        try {
            // Get stadium ID
            String stadiumIdStr = request.getParameter("stadiumId");
            if (stadiumIdStr == null || stadiumIdStr.trim().isEmpty()) {
                System.out.println("[StadiumImageServlet] Stadium ID is missing");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Stadium ID is required");
                return;
            }
            
            int stadiumId = Integer.parseInt(stadiumIdStr);
            System.out.println("[StadiumImageServlet] Stadium ID: " + stadiumId);
            
            // Get the uploaded image
            Part imagePart = request.getPart("stadiumImage");
            if (imagePart == null || imagePart.getSize() == 0) {
                System.out.println("[StadiumImageServlet] No image file uploaded");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No image file uploaded");
                return;
            }
            
            // Validate image type
            String contentType = imagePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                System.out.println("[StadiumImageServlet] Invalid file type: " + contentType);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Only image files are allowed");
                return;
            }
            
            // Check if stadium exists
            StadiumDAO stadiumDAO = new StadiumDAO();
            Stadium stadium = stadiumDAO.getStadiumById(stadiumId);
            if (stadium == null) {
                System.out.println("[StadiumImageServlet] Stadium not found with ID: " + stadiumId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Stadium not found");
                return;
            }
            
            System.out.println("[StadiumImageServlet] Stadium found: " + stadium.getName());
            
            // Upload image to Cloudinary using your existing utility
            String imageURL = CloudinaryUtils.uploadImage(imagePart, stadiumId);
            System.out.println("[StadiumImageServlet] Image uploaded to Cloudinary: " + imageURL);
            
            // Update stadium with new image URL
            boolean updated = stadiumDAO.updateStadiumImage(stadiumId, imageURL);
            
            if (updated) {
                System.out.println("[StadiumImageServlet] Stadium image updated successfully");
                
                // Return JSON response for AJAX calls
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"imageURL\": \"" + imageURL + "\", \"message\": \"Image uploaded successfully\"}");
                
            } else {
                System.out.println("[StadiumImageServlet] Failed to update stadium image in database");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update stadium image\"}");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("[StadiumImageServlet] Invalid stadium ID format: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid stadium ID");
            
        } catch (Exception e) {
            System.out.println("[StadiumImageServlet] Error uploading stadium image: " + e.getMessage());
            e.printStackTrace();
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error uploading image: " + e.getMessage() + "\"}");
        }
    }
}