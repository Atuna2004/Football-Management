package dao;

import model.Report;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {
    private final Connection conn;

    public ReportDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Report> getAllReports() throws SQLException {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT r.*, u.FullName AS UserName, u.Email AS UserEmail " +
                     "FROM Report r " +
                     "JOIN [User] u ON r.UserID = u.UserID " +
                     "ORDER BY r.SubmittedAt DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                reports.add(extractReport(rs));
            }
        }
        return reports;
    }

    public Report getReportById(int id) throws SQLException {
        String sql = "SELECT r.*, u.FullName AS UserName, u.Email AS UserEmail " +
                     "FROM Report r " +
                     "JOIN [User] u ON r.UserID = u.UserID " +
                     "WHERE r.ReportID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractReport(rs);
                }
            }
        }
        return null;
    }

    public void updateReportStatus(int reportID, String newStatus) throws SQLException {
        String sql = "UPDATE Report SET Status = ?, RespondedAt = GETDATE() WHERE ReportID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, reportID);
            ps.executeUpdate();
        }
    }

    public void respondToReport(int reportID, String response, String newStatus) throws SQLException {
        String sql = "UPDATE Report SET AdminResponse = ?, Status = ?, RespondedAt = GETDATE() WHERE ReportID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, response);
            ps.setString(2, newStatus);
            ps.setInt(3, reportID);
            ps.executeUpdate();
        }
    }

    // ✅ ONE UNIFIED METHOD for all report types
    public boolean createReport(Report report) throws SQLException {
        String sql = "INSERT INTO Report (UserID, RelatedBookingID, RelatedFoodOrderID, RelatedStadiumID, Title, Description, Status, SubmittedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, report.getUserID());
            setNullableInt(ps, 2, report.getRelatedBookingID());
            setNullableInt(ps, 3, report.getRelatedFoodOrderID());
            setNullableInt(ps, 4, report.getRelatedStadiumID());
            ps.setString(5, report.getTitle());
            ps.setString(6, report.getDescription());
            ps.setString(7, report.getStatus());
            
            int rowsAffected = ps.executeUpdate();
            
            System.out.println("✅ Report created successfully. Rows affected: " + rowsAffected);
            System.out.println("✅ Report details: UserID=" + report.getUserID() + 
                             ", StadiumID=" + report.getRelatedStadiumID() + 
                             ", Title=" + report.getTitle());
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error creating report: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Helper method for nullable integers
    private void setNullableInt(PreparedStatement ps, int index, Integer value) throws SQLException {
        if (value != null) {
            ps.setInt(index, value);
        } else {
            ps.setNull(index, Types.INTEGER);
        }
    }

    // ✅ Helper method to extract report from ResultSet
    private Report extractReport(ResultSet rs) throws SQLException {
        Report report = new Report();
        report.setReportID(rs.getInt("ReportID"));
        report.setUserID(rs.getInt("UserID"));
        report.setRelatedBookingID((Integer) rs.getObject("RelatedBookingID"));
        report.setRelatedFoodOrderID((Integer) rs.getObject("RelatedFoodOrderID"));
        report.setRelatedStadiumID((Integer) rs.getObject("RelatedStadiumID"));
        report.setTitle(rs.getString("Title"));
        report.setDescription(rs.getString("Description"));
        report.setSubmittedAt(rs.getTimestamp("SubmittedAt"));
        report.setStatus(rs.getString("Status"));
        report.setAdminResponse(rs.getString("AdminResponse"));
        report.setRespondedAt(rs.getTimestamp("RespondedAt"));

        try {
            report.setUserName(rs.getString("UserName"));
            report.setUserEmail(rs.getString("UserEmail"));
        } catch (SQLException ignored) {}

        report.setType("REPORT");
        report.setPriority("MEDIUM");

        return report;
    }

    public static void main(String[] args) {
        try (Connection conn = connect.DBConnection.getConnection()) {
            dao.ReportDAO dao = new dao.ReportDAO(conn);
            List<model.Report> reports = dao.getAllReports();
            for (model.Report report : reports) {
                System.out.println(report.getReportID() + " - " + report.getTitle());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}