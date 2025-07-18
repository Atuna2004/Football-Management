package dao;


import connect.DBConnection;
import java.sql.*;

public class UserRoleDAO {

    private Connection connection;

    public UserRoleDAO(Connection conn) {
        this.connection = conn;
    }

    // Hàm chuyển role người dùng sang "Owner"
    public boolean changeUserRoleToOwner(int userId) throws Exception {
        String sql = "UPDATE UserRole SET RoleID = (SELECT RoleID FROM Role WHERE RoleName = 'Owner') WHERE UserID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
}