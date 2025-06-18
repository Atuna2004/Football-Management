package dao;

import connect.DBConnection;
import model.Report;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {


    private final Connection conn;


    public ReportDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy danh sách tất cả báo cáo
    public List<Report> getAllReports() throws SQLException {
        List<Report> reports = new ArrayList<>();

        String sql = "SELECT * FROM Report";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Report report = new Report();
                report.setReportID(rs.getInt("ReportID"));
                report.setUserID(rs.getInt("UserID"));
                report.setRelatedBookingID(rs.getInt("RelatedBookingID"));
                report.setRelatedFoodOrderID(rs.getInt("RelatedFoodOrderID"));
                report.setTitle(rs.getString("Title"));
                report.setDescription(rs.getString("Description"));
                report.setSubmittedAt(rs.getTimestamp("SubmittedAt"));
                report.setStatus(rs.getString("Status"));
                report.setAdminResponse(rs.getString("AdminResponse"));
                report.setRespondedAt(rs.getTimestamp("RespondedAt"));


                reports.add(report);
            }
        }
        return reports;
    }

    
     public static void main(String[] args) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            ReportDAO dao = new ReportDAO(conn);

            System.out.println("==== GET ALL REPORTS ====");
            List<Report> reports = dao.getAllReports();
            for (Report r : reports) {
                System.out.println("ID: " + r.getReportID() + " | Title: " + r.getTitle() + " | Status: " + r.getStatus());
            }
        }
     }

    // Thêm báo cáo mới
    // Thêm báo cáo mới
    public boolean addReport(Report report) throws SQLException {
        String sql = "INSERT INTO Report (UserID, RelatedBookingID, RelatedFoodOrderID, Title, Description, Status) " +
                     "VALUES (?, ?, ?, ?, ?, 'Pending')";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, report.getUserID());
            if (report.getRelatedBookingID() != null) {
                stmt.setInt(2, report.getRelatedBookingID());
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            if (report.getRelatedFoodOrderID() != null) {
                stmt.setInt(3, report.getRelatedFoodOrderID());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            stmt.setString(4, report.getTitle());
            stmt.setString(5, report.getDescription());


            return stmt.executeUpdate() > 0;
        }
    }

    // Cập nhật trạng thái và phản hồi của admin
   public boolean updateReportStatus(int reportID, String newStatus) throws SQLException {
    String sql = "UPDATE Report SET Status = ? WHERE ReportID = ?";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, newStatus);
        stmt.setInt(2, reportID);
        return stmt.executeUpdate() > 0;
    }
}
}
