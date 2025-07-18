package connect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final String DRIVER_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=FutBall;encrypt=true;trustServerCertificate=true";
    private static final String USER_NAME = "sa";
    private static final String PASSWORD = "123";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(DRIVER_NAME);
            conn = DriverManager.getConnection(DB_URL, USER_NAME, PASSWORD);
            System.out.println("✅ Connected to database.");
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "❌ Database connection failed!", ex);
        }
        return conn;
    }

    public static void closeConnection(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("🔒 Database connection closed.");
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "❌ Failed to close connection!", ex);
        }
    }

    public static void main(String[] args) {
        try (Connection testConn = getConnection()) {
            if (testConn != null) {
                System.out.println("🟢 Connection test successful.");
            } else {
                System.out.println("🔴 Connection test failed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
