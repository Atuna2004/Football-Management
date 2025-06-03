package dao;

import java.sql.*;
import java.util.*;
import model.User;

public class AccountDAO {

    private Connection conn;

    public AccountDAO(Connection conn) {
        this.conn = conn;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM [User]";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(extractUser(rs));
            }
        }
        return list;
    }

    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM [User] WHERE UserID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? extractUser(rs) : null;
            }
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM [User] WHERE Email = ? AND isActive = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? extractUser(rs) : null;
            }
        }
    }

    public boolean addUser(User user) throws SQLException {
        String sql = "INSERT INTO [User] (Email, PasswordHash, FullName, Phone, CreatedAt, IsActive, GoogleID, AvatarUrl, DateOfBirth, Address) VALUES (?, ?, ?, ?, GETDATE(), ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhone());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getGoogleID());
            stmt.setString(7, user.getAvatarUrl());

            if (user.getDateOfBirth() != null) {
                stmt.setDate(8, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                stmt.setNull(8, Types.DATE);
            }

            if (user.getAddress() != null && !user.getAddress().isEmpty()) {
                stmt.setString(9, user.getAddress());
            } else {
                stmt.setNull(9, Types.VARCHAR);
            }

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE [User] SET Email=?, PasswordHash=?, FullName=?, Phone=?, IsActive=?, GoogleID=?, AvatarUrl=?, DateOfBirth=?, Address=? WHERE UserID=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhone());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getGoogleID());
            stmt.setString(7, user.getAvatarUrl());

            if (user.getDateOfBirth() != null) {
                stmt.setDate(8, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                stmt.setNull(8, Types.DATE);
            }

            if (user.getAddress() != null && !user.getAddress().isEmpty()) {
                stmt.setString(9, user.getAddress());
            } else {
                stmt.setNull(9, Types.VARCHAR);
            }

            stmt.setInt(10, user.getUserID());

            return stmt.executeUpdate() > 0;
        }
    }

    private User extractUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserID(rs.getInt("UserID"));
        u.setEmail(rs.getString("Email"));
        u.setPasswordHash(rs.getString("PasswordHash"));
        u.setFullName(rs.getString("FullName"));
        u.setPhone(rs.getString("Phone"));
        u.setCreatedAt(rs.getTimestamp("CreatedAt"));
        u.setActive(rs.getBoolean("IsActive"));
        u.setGoogleID(rs.getString("GoogleID"));
        u.setAvatarUrl(rs.getString("AvatarUrl"));
        u.setDateOfBirth(rs.getObject("DateOfBirth", java.sql.Date.class));
        u.setAddress(rs.getString("Address"));
        return u;
    }

    public boolean activateUser(String email) throws SQLException {
        String sql = "UPDATE [User] SET isActive = 1 WHERE Email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            return stmt.executeUpdate() > 0;
        }
    }
}
