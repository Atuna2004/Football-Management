/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ADMIN
 */
import java.sql.*;
import java.util.*;
import model.User;

public class AccountDAO {
    private Connection conn;

    public AccountDAO(Connection conn) {
        this.conn = conn;
    }

    // Get all users
    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM [User]";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(extractUser(rs));
            }
        }
        return list;
    }

    // Get user by ID
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM [User] WHERE UserID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? extractUser(rs) : null;
            }
        }
    }

    // Get user by email
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM [User] WHERE Email = ? AND isActive = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? extractUser(rs) : null;
            }
        }
    }

    // Add new user
    public boolean addUser(User user) throws SQLException {
        String sql = "INSERT INTO [User] (Email, PasswordHash, FullName, Phone, CreatedAt, IsActive, GoogleID, AvatarUrl) VALUES (?, ?, ?, ?, GETDATE(), ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhone());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getGoogleID());
            stmt.setString(7, user.getAvatarUrl());

            return stmt.executeUpdate() > 0;
        }
    }

    // Update user
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE [User] SET Email=?, PasswordHash=?, FullName=?, Phone=?, IsActive=?, GoogleID=?, AvatarUrl=? WHERE UserID=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhone());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getGoogleID());
            stmt.setString(7, user.getAvatarUrl());
            stmt.setInt(8, user.getUserID());

            return stmt.executeUpdate() > 0;
        }
    }

    // Delete user
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM [User] WHERE UserID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Utility to extract User from ResultSet
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
        return u;
    }
    

    public boolean activateUser(String email) throws SQLException {
        String sql = "UPDATE [User] SET isActive = 1 WHERE Email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            return stmt.executeUpdate() > 0;
        }
    }

    
    //update password when forgot
    public boolean updatePassword(String email, String pass) throws SQLException{
        String sql = "UPDATE [User] Set PasswordHash = ? WHERE Email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)){
            stmt.setString(1, pass);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
    }
}

}
