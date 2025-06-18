package dao;

import model.ActivityLog;
import connect.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO {

    private Connection conn;

    public ActivityLogDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy toàn bộ lịch sử hành động
    public List<ActivityLog> getAllLogs() throws SQLException {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM ActivityLog ORDER BY Timestamp DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogID(rs.getInt("LogID"));
                log.setAction(rs.getString("Action"));
                log.setPerformedBy(rs.getString("PerformedBy"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                log.setDetails(rs.getString("Details"));

                logs.add(log);
            }
        }
        return logs;
    }

    // Ghi lại một hành động
    public boolean logAction(String action, String performedBy, String details) throws SQLException {
        String sql = "INSERT INTO ActivityLog (Action, PerformedBy, Details) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, action);
            stmt.setString(2, performedBy);
            stmt.setString(3, details);
            return stmt.executeUpdate() > 0;
        }
    }
}
