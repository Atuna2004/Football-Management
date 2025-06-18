//package dao;
//
//import model.SystemSetting;
//import connect.DBConnection;
//import java.sql.*;
//
//public class SystemSettingDAO {
//
//    private Connection conn;
//
//    public SystemSettingDAO(Connection conn) {
//        this.conn = conn;
//    }
//
//    public SystemSetting loadGeneralSettings() throws SQLException {
//        String sql = "SELECT * FROM SystemSetting WHERE ID = 1";
//        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
//
//            if (rs.next()) {
//                SystemSetting setting = new SystemSetting();
//                setting.setSiteName(rs.getString("SiteName"));
//                setting.setSupportEmail(rs.getString("SupportEmail"));
//                setting.setDefaultRole(rs.getString("DefaultRole"));
//                setting.setEmailNotificationsEnabled(rs.getBoolean("EmailNotifications"));
//                setting.setSmsEnabled(rs.getBoolean("SMSNotifications"));
//                setting.setLanguage(rs.getString("Language"));
//                setting.setTimeZone(rs.getString("TimeZone"));
//
//                return setting;
//            }
//        }
//        return new SystemSetting(); // Trả về mặc định nếu chưa có trong DB
//    }
//
//    // Cập nhật cài đặt
//    public boolean save(SystemSetting setting) throws SQLException {
//        String sql = "UPDATE SystemSetting SET SiteName=?, SupportEmail=?, DefaultRole=?, EmailNotifications=?, SMSNotifications=?, Language=?, TimeZone=? WHERE ID=1";
//        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setString(1, setting.getSiteName());
//            stmt.setString(2, setting.getSupportEmail());
//            stmt.setString(3, setting.getDefaultRole());
//            stmt.setBoolean(4, setting.isEmailNotificationsEnabled());
//            stmt.setBoolean(5, setting.isSmsEnabled());
//            stmt.setString(6, setting.getLanguage());
//            stmt.setString(7, setting.getTimeZone());
//
//            return stmt.executeUpdate() > 0;
//        }
//    }
//
//    // Tạo bản ghi mặc định nếu chưa tồn tại
//    public boolean createDefaultSettingIfNotExists() throws SQLException {
//        String checkSql = "IF NOT EXISTS (SELECT 1 FROM SystemSetting WHERE ID = 1) INSERT INTO SystemSetting (ID, SiteName, SupportEmail, DefaultRole, EmailNotifications, SMSNotifications, Language, TimeZone) VALUES (1, 'Football Management System', 'support@example.com', 'user', 1, 1, 'en', 'UTC+7');
//        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
//            return stmt.executeUpdate() > 0;
//        }
//    }
//}
