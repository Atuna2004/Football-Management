package dao;


import connect.DBConnection;
import model.OwnerRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OwnerRequestDAO {

    private Connection connection;

    public OwnerRequestDAO(Connection conn) {
        this.connection = conn;
    }

    // Lưu yêu cầu làm chủ sân
    public boolean saveRequest(OwnerRequest request) {
        String sql = "INSERT INTO OwnerRequest (UserID, FullName, Email, PhoneNumber, Message, BusinessLicense, Status) VALUES (?, ?, ?, ?, ?, ?, 'Pending')";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, request.getUserID());
            stmt.setString(2, request.getFullName());
            stmt.setString(3, request.getEmail());
            stmt.setString(4, request.getPhoneNumber());
            stmt.setString(5, request.getMessage());
            stmt.setString(6, request.getBusinessLicense()); // Thêm BusinessLicense

            int result = stmt.executeUpdate();
            System.out.println("Insert owner request result: " + result);
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Error saving owner request: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Trong OwnerRequestDAO.java
    public List<OwnerRequest> getAllRequests() {
        String sql = "SELECT * FROM OwnerRequest";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            List<OwnerRequest> requests = new ArrayList<>();
            while (rs.next()) {
                OwnerRequest req = new OwnerRequest();
                req.setRequestID(rs.getInt("RequestID"));
                req.setUserID(rs.getInt("UserID"));
                req.setFullName(rs.getString("FullName"));
                req.setEmail(rs.getString("Email"));
                req.setPhoneNumber(rs.getString("PhoneNumber"));
                req.setMessage(rs.getString("Message"));
                req.setSubmittedDate(rs.getTimestamp("SubmittedDate"));
                req.setStatus(rs.getString("Status"));
                req.setAdminNote(rs.getString("AdminNote"));
                req.setBusinessLicense(rs.getString("BusinessLicense")); // <- THÊM DÒNG NÀY
                requests.add(req);
            }
            return requests;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy tất cả các yêu cầu chờ duyệt
    public List<OwnerRequest> getPendingRequests() {
        List<OwnerRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM OwnerRequest WHERE Status = 'Pending'";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                OwnerRequest req = new OwnerRequest();
                req.setRequestID(rs.getInt("RequestID"));
                req.setUserID(rs.getInt("UserID"));
                req.setFullName(rs.getString("FullName"));
                req.setEmail(rs.getString("Email"));
                req.setPhoneNumber(rs.getString("PhoneNumber"));
                req.setMessage(rs.getString("Message"));
                req.setSubmittedDate(rs.getTimestamp("SubmittedDate"));
                req.setStatus(rs.getString("Status"));
                req.setAdminNote(rs.getString("AdminNote"));

                requests.add(req);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return requests;
    }

    // Cập nhật trạng thái yêu cầu
    public boolean updateRequestStatus(int requestId, String status, String adminNote) {
        String sql = "UPDATE OwnerRequest SET Status = ?, AdminNote = ? WHERE RequestID = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, adminNote);
            stmt.setInt(3, requestId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Add this method to retrieve a specific request by ID
    public OwnerRequest getRequestById(int requestId) {
        String sql = "SELECT * FROM OwnerRequest WHERE RequestID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, requestId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                OwnerRequest req = new OwnerRequest();
                req.setRequestID(rs.getInt("RequestID"));
                req.setUserID(rs.getInt("UserID"));
                req.setFullName(rs.getString("FullName"));
                req.setEmail(rs.getString("Email"));
                req.setPhoneNumber(rs.getString("PhoneNumber"));
                req.setMessage(rs.getString("Message"));
                req.setSubmittedDate(rs.getTimestamp("SubmittedDate"));
                req.setStatus(rs.getString("Status"));
                req.setAdminNote(rs.getString("AdminNote"));
                return req;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}