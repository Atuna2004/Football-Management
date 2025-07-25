package connect;

import config.ConfigAPIKey;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    // Xóa bỏ các hằng số chứa thông tin nhạy cảm

    public static Connection getConnection() {
        try {
            // Đọc thông tin từ file config
            Class.forName(ConfigAPIKey.getProperty("db.driver"));
            Connection conn = DriverManager.getConnection(
                    ConfigAPIKey.getProperty("db.url"),
                    ConfigAPIKey.getProperty("db.user"),
                    ConfigAPIKey.getProperty("db.password")
            );
            System.out.println("✅ Connected to database.");
            return conn;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "❌ Database connection failed!", ex);
            return null;
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("🔒 Database connection closed.");
            } catch (SQLException ex) {
                Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "❌ Failed to close connection!", ex);
            }
        }
    }

    public static void main(String[] args) {
        Connection testConn = getConnection();
        if (testConn != null) {
            System.out.println("🟢 Connection test successful.");
            closeConnection(testConn);
        } else {
            System.out.println("🔴 Connection test failed.");
        }
    }
}