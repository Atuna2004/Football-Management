package dao;

import connect.DBConnection;
import model.Stadium;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StadiumDAO {

    // Get all stadiums
    public List<Stadium> getAllStadiums() {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Stadium stadium = new Stadium(
                        rs.getInt("stadiumID"),
                        rs.getString("name"),
                        rs.getString("location"),
                        rs.getString("description"),
                        rs.getString("type"),
                        rs.getString("status"),
                        rs.getTimestamp("createdAt"),
                        rs.getString("phoneNumber")
                );
                stadiumList.add(stadium);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }

    // Get stadium by ID
    public Stadium getStadiumById(int id) {
        String sql = "SELECT * FROM Stadium WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Stadium(
                        rs.getInt("stadiumID"),
                        rs.getString("name"),
                        rs.getString("location"),
                        rs.getString("description"),
                        rs.getString("type"),
                        rs.getString("status"),
                        rs.getTimestamp("createdAt"),
                        rs.getString("phoneNumber")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Insert new stadium
    public boolean insertStadium(Stadium stadium) {
        String sql = "INSERT INTO Stadium(name, location, description, type, status, createdAt, phoneNumber) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getType());
            ps.setString(5, stadium.getStatus());
            ps.setTimestamp(6, new Timestamp(stadium.getCreatedAt().getTime()));
            ps.setString(7, stadium.getPhoneNumber());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update existing stadium
    public boolean updateStadium(Stadium stadium) {
        String sql = "UPDATE Stadium SET name = ?, location = ?, description = ?, type = ?, status = ?, createdAt = ?, phoneNumber = ? WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getType());
            ps.setString(5, stadium.getStatus());
            ps.setTimestamp(6, new Timestamp(stadium.getCreatedAt().getTime()));
            ps.setString(7, stadium.getPhoneNumber());
            ps.setInt(8, stadium.getStadiumID());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete stadium by ID
    public boolean deleteStadium(int id) {
        String sql = "DELETE FROM Stadium WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
