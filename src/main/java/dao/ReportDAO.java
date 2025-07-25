package dao;

import model.Report;
import model.User;
import connect.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReportDAO {
    private final Connection conn;
    private static final Logger LOGGER = Logger.getLogger(ReportDAO.class.getName());

    public ReportDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Report> getAllReports() throws SQLException {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT r.*, u.FullName AS UserName, u.Email AS UserEmail, s.Name AS StadiumName " +
                     "FROM Report r " +
                     "JOIN [User] u ON r.UserID = u.UserID " +
                     "LEFT JOIN Stadium s ON r.RelatedStadiumID = s.StadiumID " +
                     "ORDER BY r.SubmittedAt DESC";

        LOGGER.log(Level.INFO, "Executing getAllReports SQL: {0}", sql);

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                reports.add(extractReport(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAllReports: " + e.getMessage(), e);
            throw e;
        }
        return reports;
    }

    public List<Report> getReportsByOwnerId(int ownerID) throws SQLException {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT r.*, u.FullName AS UserName, u.Email AS UserEmail, s.Name AS StadiumName " +
                     "FROM Report r " +
                     "JOIN [User] u ON r.UserID = u.UserID " +
                     "JOIN Stadium s ON r.RelatedStadiumID = s.StadiumID " +
                     "WHERE s.OwnerID = ? " +
                     "ORDER BY r.SubmittedAt DESC";

        LOGGER.log(Level.INFO, "Executing getReportsByOwnerId for ownerID: {0}, SQL: {1}", new Object[]{ownerID, sql});

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reports.add(extractReport(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getReportsByOwnerId for owner ID " + ownerID + ": " + e.getMessage(), e);
            throw e;
        }
        return reports;
    }

    public Report getReportById(int id) throws SQLException {
        String sql = "SELECT r.*, u.FullName AS UserName, u.Email AS UserEmail, s.Name AS StadiumName " +
                     "FROM Report r " +
                     "JOIN [User] u ON r.UserID = u.UserID " +
                     "LEFT JOIN Stadium s ON r.RelatedStadiumID = s.StadiumID " +
                     "WHERE r.ReportID = ?";
        LOGGER.log(Level.INFO, "Executing getReportById for ReportID: {0}, SQL: {1}", new Object[]{id, sql});
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractReport(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getReportById for ID " + id + ": " + e.getMessage(), e);
            throw e;
        }
        return null;
    }

    public void updateReportStatus(int reportID, String newStatus) throws SQLException {
        String sql = "UPDATE Report SET Status = ?, RespondedAt = GETDATE() WHERE ReportID = ?";
        LOGGER.log(Level.INFO, "Executing updateReportStatus for ReportID: {0}, Status: {1}", new Object[]{reportID, newStatus});
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, reportID);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateReportStatus for ID " + reportID + ": " + e.getMessage(), e);
            throw e;
        }
    }

    public void respondToReport(int reportID, String response, String newStatus) throws SQLException {
        String sql = "UPDATE Report SET AdminResponse = ?, Status = ?, RespondedAt = GETDATE() WHERE ReportID = ?";
        LOGGER.log(Level.INFO, "Executing respondToReport for ReportID: {0}, Status: {1}", new Object[]{reportID, newStatus});
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, response);
            ps.setString(2, newStatus);
            ps.setInt(3, reportID);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in respondToReport for ID " + reportID + ": " + e.getMessage(), e);
            throw e;
        }
    }

    public boolean createReport(Report report) throws SQLException {
        String sql = "INSERT INTO Report (UserID, RelatedBookingID, RelatedFoodOrderID, RelatedStadiumID, Title, Description, Status, SubmittedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        LOGGER.log(Level.INFO, "Executing createReport for UserID: {0}, StadiumID: {1}, Title: {2}",
                   new Object[]{report.getUserID(), report.getRelatedStadiumID(), report.getTitle()});

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, report.getUserID());
            setNullableInt(ps, 2, report.getRelatedBookingID());
            setNullableInt(ps, 3, report.getRelatedFoodOrderID());
            setNullableInt(ps, 4, report.getRelatedStadiumID());
            ps.setString(5, report.getTitle());
            ps.setString(6, report.getDescription());
            ps.setString(7, report.getStatus());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.info("Report created successfully. Rows affected: " + rowsAffected);
            } else {
                LOGGER.warning("Report creation failed. No rows affected.");
            }
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating report: " + e.getMessage(), e);
            throw e;
        }
    }

    private void setNullableInt(PreparedStatement ps, int index, Integer value) throws SQLException {
        if (value != null) {
            ps.setInt(index, value);
        } else {
            ps.setNull(index, Types.INTEGER);
        }
    }

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
        } catch (SQLException ignored) { }
        try {
            report.setUserEmail(rs.getString("UserEmail"));
        } catch (SQLException ignored) { }
        try {
            report.setStadiumName(rs.getString("StadiumName"));
        } catch (SQLException ignored) { }

        report.setType("REPORT"); 
        report.setPriority("MEDIUM"); 

        return report;
    }

    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            ReportDAO dao = new ReportDAO(conn);

            System.out.println("--- All Reports (Admin View) ---");
            List<Report> allReports = dao.getAllReports();
            for (Report report : allReports) {
                System.out.println("ID: " + report.getReportID() + ", Title: " + report.getTitle() + ", User: " + report.getUserName() + ", Stadium: " + report.getStadiumName() + ", Status: " + report.getStatus());
            }

            int fieldOwnerUserID = 2;
            System.out.println("\n--- Reports for Field Owner (UserID: " + fieldOwnerUserID + ") ---");
            List<Report> ownerReports = dao.getReportsByOwnerId(fieldOwnerUserID);
            if (ownerReports.isEmpty()) {
                System.out.println("No reports found for this owner.");
            }
            for (Report report : ownerReports) {
                System.out.println("ID: " + report.getReportID() + ", Title: " + report.getTitle() + ", User: " + report.getUserName() + ", Stadium: " + report.getStadiumName() + ", Status: " + report.getStatus());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
