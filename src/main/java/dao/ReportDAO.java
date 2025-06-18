package dao;

import model.Report;
import connect.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    private Connection conn;

    public ReportDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy danh sách tất cả báo cáo
    public List<Report> getAllReports() throws SQLException {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT * FROM UserReport";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Report report = new Report();
                report.setReportID(rs.getInt("ReportID"));
                report.setType(rs.getString("Type"));
                report.setDescription(rs.getString("Description"));
                report.setReporterEmail(rs.getString("ReporterEmail"));
                report.setReportedAt(rs.getTimestamp("ReportedAt"));
                report.setStatus(rs.getString("Status"));

                reports.add(report);
            }
        }
        return reports;
    }

    // Thêm mới một báo cáo
    public boolean addReport(Report report) throws SQLException {
        String sql = "INSERT INTO UserReport (Type, Description, ReporterEmail, Status) VALUES (?, ?, ?, 'pending')";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, report.getType());
            stmt.setString(2, report.getDescription());
            stmt.setString(3, report.getReporterEmail());

            return stmt.executeUpdate() > 0;
        }
    }

    // Cập nhật trạng thái báo cáo
    public boolean updateReportStatus(int reportID, String newStatus) throws SQLException {
        String sql = "UPDATE UserReport SET Status = ? WHERE ReportID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, reportID);
            return stmt.executeUpdate() > 0;
        }
    }
}
