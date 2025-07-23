package dao;

import connect.DBConnection;
import model.Stadium;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StadiumDAO {

    public List<Stadium> getAllStadiums() {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium WHERE Status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                stadiumList.add(mapResultSetToStadium(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }
    
    public List<Stadium> getAllStadiumsForFieldOwner() {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                stadiumList.add(mapResultSetToStadium(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }

    public Stadium getStadiumById(int id) {
        String sql = "SELECT * FROM Stadium WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToStadium(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertStadium(Stadium stadium) {
        String sql = "INSERT INTO Stadium(name, location, description, status, createdAt, phoneNumber, OwnerID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getStatus());
            ps.setTimestamp(5, new Timestamp(stadium.getCreatedAt().getTime()));
            ps.setString(6, stadium.getPhoneNumber());
            ps.setInt(7, stadium.getOwnerID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStadium(Stadium stadium) {
        String sql = "UPDATE Stadium SET name = ?, location = ?, description = ?, status = ?, phoneNumber = ? WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getStatus());
            ps.setString(5, stadium.getPhoneNumber());
            ps.setInt(6, stadium.getStadiumID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

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

    public List<Stadium> getStadiumsByPage(int page, int recordsPerPage) {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium ORDER BY stadiumID LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, recordsPerPage);
            ps.setInt(2, (page - 1) * recordsPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                stadiumList.add(mapResultSetToStadium(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }

    public int getTotalStadiumCount() {
        String sql = "SELECT COUNT(*) AS total FROM Stadium";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Stadium> getStadiumsByOwnerId(int ownerId) {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium WHERE OwnerID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                stadiumList.add(mapResultSetToStadium(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }

    public int getTotalStadiumCountByOwnerId(int ownerId) {
        String sql = "SELECT COUNT(*) AS total FROM Stadium WHERE OwnerID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Stadium> getStadiumsByOwnerIdAndPage(int ownerId, int page, int recordsPerPage) {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium WHERE OwnerID = ? ORDER BY StadiumID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setInt(2, (page - 1) * recordsPerPage);
            ps.setInt(3, recordsPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                stadiumList.add(mapResultSetToStadium(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }

    public List<Stadium> getStadiumsByLocation(String location) {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium WHERE location = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, location);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                stadiumList.add(mapResultSetToStadium(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }

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

    public List<String> getDistinctCities() {
        List<String> cities = new ArrayList<>();
        String sql = "SELECT DISTINCT location FROM Stadium";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String fullLocation = rs.getString("location");
                if (fullLocation != null && fullLocation.contains(",")) {
                    String[] parts = fullLocation.split(",");
                    String city = parts[parts.length - 1].trim();
                    if (!cities.contains(city)) {
                        cities.add(city);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cities;
    }

    public List<Stadium> getStadiumsByCity(String city) {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium WHERE location LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + city + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stadiumList.add(mapResultSetToStadium(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }

    // ✅ Hàm chung để tạo đối tượng Stadium từ ResultSet
    private Stadium mapResultSetToStadium(ResultSet rs) throws SQLException {
        return new Stadium(
                rs.getInt("stadiumID"),
                rs.getString("name"),
                rs.getString("location"),
                rs.getString("description"),
                rs.getString("status"),
                rs.getTimestamp("createdAt"),
                rs.getString("phoneNumber"),
                rs.getInt("OwnerID")
        );
    }
    
    public List<Stadium> getStadiumsByOwner(int ownerId) {
        List<Stadium> list = new ArrayList<>();
        String sql = "SELECT StadiumID, Name FROM Stadium WHERE OwnerID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Stadium stadium = new Stadium();
                stadium.setStadiumID(rs.getInt("StadiumID"));
                stadium.setName(rs.getString("Name"));
                list.add(stadium);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy sân theo OwnerID = " + ownerId);
            e.printStackTrace();
        }

        return list;
    }
}


