package controller.FieldOwner;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

import dao.StadiumDAO;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import model.Stadium;
import model.User;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 10 * 1024 * 1024,   // 10MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)

@WebServlet("/stadium/config")
public class StadiumServlet extends HttpServlet {
    private final StadiumDAO stadiumDAO = new StadiumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
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
                deactivateStadium(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
                break;
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
    }

    // 🔥 FIXED: Enhanced createStadium method with coordinate handling
    private void createStadium(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Set encoding to handle UTF-8 properly
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            // Get basic form parameters
            String name = request.getParameter("name");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String phoneNumber = request.getParameter("phoneNumber");
            
            // 🔥 CRITICAL: Get latitude and longitude parameters
            String latitudeStr = request.getParameter("latitude");
            String longitudeStr = request.getParameter("longitude");
            
            // 🔥 DEBUG: Log all received parameters
            System.out.println("=== STADIUM CREATION DEBUG ===");
            System.out.println("Name: " + name);
            System.out.println("Location: " + location);
            System.out.println("Description: " + description);
            System.out.println("Status: " + status);
            System.out.println("Phone: " + phoneNumber);
            System.out.println("Latitude String: '" + latitudeStr + "'");
            System.out.println("Longitude String: '" + longitudeStr + "'");
            System.out.println("Current User: " + (currentUser != null ? currentUser.getUserID() : "NULL"));
            System.out.println("===============================");

            // Create stadium object
            Stadium stadium = new Stadium();
            stadium.setName(name);
            stadium.setLocation(location);
            stadium.setDescription(description);
            stadium.setStatus(status != null ? status : "active"); // Default to active if null
            stadium.setPhoneNumber(phoneNumber);
            stadium.setCreatedAt(new Timestamp(new Date().getTime()));
            
            // Set owner ID
            if (currentUser != null) {
                stadium.setOwnerID(currentUser.getUserID());
            } else {
                System.err.println("❌ WARNING: No current user found in session!");
                request.setAttribute("errorMessage", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
                request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
                return;
            }

            // 🔥 CRITICAL: Parse and set coordinates
            if (latitudeStr != null && !latitudeStr.trim().isEmpty() &&
                longitudeStr != null && !longitudeStr.trim().isEmpty()) {
                
                try {
                    Double latitude = Double.parseDouble(latitudeStr.trim());
                    Double longitude = Double.parseDouble(longitudeStr.trim());
                    
                    // Validate coordinate ranges (basic validation)
                    if (latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180) {
                        stadium.setLatitude(latitude);
                        stadium.setLongitude(longitude);
                        
                        System.out.println("✅ Coordinates set successfully:");
                        System.out.println("   Latitude: " + latitude);
                        System.out.println("   Longitude: " + longitude);
                    } else {
                        System.err.println("❌ Invalid coordinate ranges!");
                        System.err.println("   Latitude: " + latitude + " (should be -90 to 90)");
                        System.err.println("   Longitude: " + longitude + " (should be -180 to 180)");
                        
                        stadium.setLatitude(null);
                        stadium.setLongitude(null);
                    }
                    
                } catch (NumberFormatException e) {
                    System.err.println("❌ Error parsing coordinates: " + e.getMessage());
                    System.err.println("   Latitude string: '" + latitudeStr + "'");
                    System.err.println("   Longitude string: '" + longitudeStr + "'");
                    
                    stadium.setLatitude(null);
                    stadium.setLongitude(null);
                }
            } else {
                System.err.println("❌ No coordinates provided!");
                System.err.println("   Latitude param: '" + latitudeStr + "'");
                System.err.println("   Longitude param: '" + longitudeStr + "'");
                
                stadium.setLatitude(null);
                stadium.setLongitude(null);
            }

            // 🔥 DEBUG: Log final stadium object before saving
            System.out.println("=== FINAL STADIUM OBJECT ===");
            System.out.println("Stadium Name: " + stadium.getName());
            System.out.println("Stadium Location: " + stadium.getLocation());
            System.out.println("Stadium Latitude: " + stadium.getLatitude());
            System.out.println("Stadium Longitude: " + stadium.getLongitude());
            System.out.println("Stadium Owner ID: " + stadium.getOwnerID());
            System.out.println("Stadium Status: " + stadium.getStatus());
            System.out.println("============================");

            // Save to database
            boolean success = stadiumDAO.insertStadium(stadium);
            
            if (success) {
                System.out.println("✅ Stadium created successfully!");
                
                // Set success message
                session.setAttribute("successMessage", "Tạo sân thành công!" + 
                    (stadium.getLatitude() != null ? " (Đã lưu tọa độ)" : " (Chưa có tọa độ)"));
                
                response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
            } else {
                System.err.println("❌ Failed to create stadium in database");
                request.setAttribute("errorMessage", "Có lỗi khi thêm sân vào cơ sở dữ liệu.");
                request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Exception in createStadium: " + e.getMessage());
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int stadiumId = Integer.parseInt(request.getParameter("id"));
        Stadium stadium = stadiumDAO.getStadiumById(stadiumId);
        request.setAttribute("stadium", stadium);
        request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
    }

    // 🔥 ENHANCED: Also update the updateStadium method to handle coordinates
    private void updateStadium(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        try {
            Stadium stadium = new Stadium();
            stadium.setStadiumID(Integer.parseInt(request.getParameter("stadiumID")));
            stadium.setName(request.getParameter("name"));
            stadium.setLocation(request.getParameter("location"));
            stadium.setDescription(request.getParameter("description"));
            stadium.setStatus(request.getParameter("status"));
            stadium.setPhoneNumber(request.getParameter("phoneNumber"));

            // 🔥 ADDED: Handle coordinates in update as well
            String latitudeStr = request.getParameter("latitude");
            String longitudeStr = request.getParameter("longitude");
            
            if (latitudeStr != null && !latitudeStr.trim().isEmpty() &&
                longitudeStr != null && !longitudeStr.trim().isEmpty()) {
                
                try {
                    Double latitude = Double.parseDouble(latitudeStr.trim());
                    Double longitude = Double.parseDouble(longitudeStr.trim());
                    
                    if (latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180) {
                        stadium.setLatitude(latitude);
                        stadium.setLongitude(longitude);
                        System.out.println("✅ Updated coordinates: " + latitude + ", " + longitude);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("❌ Error parsing coordinates in update: " + e.getMessage());
                }
            }

            if (stadiumDAO.updateStadium(stadium)) {
                response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thất bại.");
                request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
        }
    }

    private void deactivateStadium(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
        if (stadiumDAO.deactivateStadium(stadiumId)) {
            request.getSession().setAttribute("successMessage", "Ngừng hoạt động sân thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Thao tác thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
    }
}