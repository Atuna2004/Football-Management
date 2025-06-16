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

    // Get stadiums by location
    public List<Stadium> getStadiumsByLocation(String location) {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium WHERE location = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, location);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Stadium stadium = new Stadium(
                        rs.getInt("stadiumID"),
                        rs.getString("name"),
                        rs.getString("location"),
                        rs.getString("description"),
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

    // Get distinct locations
    public List<String> getDistinctLocations() {
        List<String> locations = new ArrayList<>();
        String sql = "SELECT DISTINCT location FROM Stadium WHERE location IS NOT NULL ORDER BY location";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                locations.add(rs.getString("location"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
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
        String sql = "INSERT INTO Stadium(name, location, description, status, createdAt, phoneNumber) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getStatus());
            ps.setTimestamp(5, new Timestamp(stadium.getCreatedAt().getTime()));
            ps.setString(6, stadium.getPhoneNumber());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update existing stadium
    public boolean updateStadium(Stadium stadium) {
        String sql = "UPDATE Stadium SET name = ?, location = ?, description = ?, status = ?, createdAt = ?, phoneNumber = ? WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getStatus());
            ps.setTimestamp(5, new Timestamp(stadium.getCreatedAt().getTime()));
            ps.setString(6, stadium.getPhoneNumber());
            ps.setInt(7, stadium.getStadiumID());

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
