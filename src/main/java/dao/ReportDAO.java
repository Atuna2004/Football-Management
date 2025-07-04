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
            Report report = new Report();
            report.setReportID(rs.getInt("ReportID"));
            report.setUserID(rs.getInt("UserID"));
            report.setRelatedBookingID((Integer) rs.getObject("RelatedBookingID"));
            report.setRelatedFoodOrderID((Integer) rs.getObject("RelatedFoodOrderID"));
            report.setTitle(rs.getString("Title"));
            report.setDescription(rs.getString("Description"));
            report.setSubmittedAt(rs.getTimestamp("SubmittedAt"));
            report.setStatus(rs.getString("Status"));
            report.setAdminResponse(rs.getString("AdminResponse"));
            report.setRespondedAt(rs.getTimestamp("RespondedAt"));

            // Gán thêm thông tin user
            report.setUserName(rs.getString("UserName"));
            report.setUserEmail(rs.getString("UserEmail"));

            // Gán tạm type và priority nếu chưa có cột trong DB
            report.setType("BUG");
            report.setPriority("MEDIUM");

            reports.add(report);
        }
    }
    return reports;
}


    public Report getReportById(int id) throws SQLException {
        String sql = "SELECT * FROM Report WHERE ReportID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Report report = new Report();
                    report.setReportID(rs.getInt("ReportID"));
                    report.setUserID(rs.getInt("UserID"));
                    report.setRelatedBookingID((Integer) rs.getObject("RelatedBookingID"));
                    report.setRelatedFoodOrderID((Integer) rs.getObject("RelatedFoodOrderID"));
                    report.setTitle(rs.getString("Title"));
                    report.setDescription(rs.getString("Description"));
                    report.setSubmittedAt(rs.getTimestamp("SubmittedAt"));
                    report.setStatus(rs.getString("Status"));
                    report.setAdminResponse(rs.getString("AdminResponse"));
                    report.setRespondedAt(rs.getTimestamp("RespondedAt"));
                    return report;
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

    public void createReport(Report report) throws SQLException {
        String sql = "INSERT INTO Report (UserID, RelatedBookingID, RelatedFoodOrderID, Title, Description, SubmittedAt, Status) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE(), ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, report.getUserID());
            if (report.getRelatedBookingID() != null) {
                ps.setInt(2, report.getRelatedBookingID());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            if (report.getRelatedFoodOrderID() != null) {
                ps.setInt(3, report.getRelatedFoodOrderID());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, report.getTitle());
            ps.setString(5, report.getDescription());
            ps.setString(6, report.getStatus());
            ps.executeUpdate();
        }
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
