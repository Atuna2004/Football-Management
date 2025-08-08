package dao;

import connect.DBConnection;
import model.Stadium;
import model.User;

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

    // 🔥 FIXED: Added Latitude and Longitude to insertStadium
    public boolean insertStadium(Stadium stadium) {
        String sql = "INSERT INTO Stadium(name, location, description, status, createdAt, phoneNumber, OwnerID, Latitude, Longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getStatus());
            ps.setTimestamp(5, new Timestamp(stadium.getCreatedAt().getTime()));
            ps.setString(6, stadium.getPhoneNumber());
            ps.setInt(7, stadium.getOwnerID());

            // 🔥 CRITICAL: Handle coordinates
            if (stadium.getLatitude() != null) {
                ps.setDouble(8, stadium.getLatitude());
                System.out.println("✅ Setting latitude: " + stadium.getLatitude());
            } else {
                ps.setNull(8, java.sql.Types.DOUBLE);
                System.out.println("⚠️ Latitude is null");
            }
            
            if (stadium.getLongitude() != null) {
                ps.setDouble(9, stadium.getLongitude());
                System.out.println("✅ Setting longitude: " + stadium.getLongitude());
            } else {
                ps.setNull(9, java.sql.Types.DOUBLE);
                System.out.println("⚠️ Longitude is null");
            }

            System.out.println("🔍 Executing SQL: " + sql);
            System.out.println("📊 Stadium: " + stadium.getName());
            System.out.println("📍 Coordinates: " + stadium.getLatitude() + ", " + stadium.getLongitude());

            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("🎉 Stadium successfully saved with coordinates!");
            } else {
                System.err.println("❌ Failed to insert stadium");
            }

            return result > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in insertStadium: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // 🔥 FIXED: Added Latitude and Longitude to updateStadium
    public boolean updateStadium(Stadium stadium) {
        String sql = "UPDATE Stadium SET name = ?, location = ?, description = ?, status = ?, phoneNumber = ?, Latitude = ?, Longitude = ? WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getStatus());
            ps.setString(5, stadium.getPhoneNumber());

            // Handle coordinates
            if (stadium.getLatitude() != null) {
                ps.setDouble(6, stadium.getLatitude());
                System.out.println("✅ Updating latitude: " + stadium.getLatitude());
            } else {
                ps.setNull(6, java.sql.Types.DOUBLE);
                System.out.println("⚠️ Setting latitude to null");
            }
            
            if (stadium.getLongitude() != null) {
                ps.setDouble(7, stadium.getLongitude());
                System.out.println("✅ Updating longitude: " + stadium.getLongitude());
            } else {
                ps.setNull(7, java.sql.Types.DOUBLE);
                System.out.println("⚠️ Setting longitude to null");
            }

            ps.setInt(8, stadium.getStadiumID());

            System.out.println("🔍 Executing UPDATE for Stadium ID: " + stadium.getStadiumID());
            System.out.println("📍 New coordinates: " + stadium.getLatitude() + ", " + stadium.getLongitude());

            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("✅ Stadium updated successfully with coordinates");
            } else {
                System.err.println("❌ Failed to update stadium");
            }

            return result > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in updateStadium: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deactivateStadium(int id) {
        String sql = "UPDATE Stadium SET Status = 'inactive' WHERE stadiumID = ?";
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

    public boolean updateStadiumImage(int stadiumId, String imageURL) {
        String sql = "UPDATE Stadium SET ImageURL = ? WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, imageURL);
            ps.setInt(2, stadiumId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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

    private Stadium mapResultSetToStadium(ResultSet rs) throws SQLException {
        Stadium stadium = new Stadium(
                rs.getInt("stadiumID"),
                rs.getString("name"),
                rs.getString("location"),
                rs.getString("description"),
                rs.getString("status"),
                rs.getTimestamp("createdAt"),
                rs.getString("phoneNumber"),
                rs.getInt("OwnerID")
        );

        // ✅ LẤY TỌA ĐỘ
        try {
            stadium.setLatitude(rs.getObject("Latitude", Double.class));
            stadium.setLongitude(rs.getObject("Longitude", Double.class));
        } catch (SQLException e) {
            stadium.setLatitude(null);
            stadium.setLongitude(null);
        }

        // Optional
        try {
            stadium.setImageURL(rs.getString("ImageURL"));
        } catch (SQLException e) {
            stadium.setImageURL(null);
        }

        return stadium;
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

    public List<Stadium> searchStadiumsByOwner(int ownerId, String keyword, int page, int recordsPerPage) {
        List<Stadium> stadiumList = new ArrayList<>();
        String sql = "SELECT * FROM Stadium " +
                "WHERE OwnerID = ? AND (name LIKE ? OR location LIKE ?) " +
                "ORDER BY stadiumID " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setInt(4, (page - 1) * recordsPerPage);
            ps.setInt(5, recordsPerPage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stadiumList.add(mapResultSetToStadium(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stadiumList;
    }

    public int getTotalSearchCountByOwner(int ownerId, String keyword) {
        String sql = "SELECT COUNT(*) AS total FROM Stadium " +
                "WHERE OwnerID = ? AND (name LIKE ? OR location LIKE ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔥 FIXED: Added Latitude and Longitude to insertStadiumWithImage
    public boolean insertStadiumWithImage(Stadium stadium) {
        String sql = "INSERT INTO Stadium(name, location, description, status, createdAt, phoneNumber, OwnerID, ImageURL, Latitude, Longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getStatus());
            ps.setTimestamp(5, new Timestamp(stadium.getCreatedAt().getTime()));
            ps.setString(6, stadium.getPhoneNumber());
            ps.setInt(7, stadium.getOwnerID());
            ps.setString(8, stadium.getImageURL());

            // Handle coordinates
            if (stadium.getLatitude() != null) {
                ps.setDouble(9, stadium.getLatitude());
            } else {
                ps.setNull(9, java.sql.Types.DOUBLE);
            }
            
            if (stadium.getLongitude() != null) {
                ps.setDouble(10, stadium.getLongitude());
            } else {
                ps.setNull(10, java.sql.Types.DOUBLE);
            }

            System.out.println("🔍 Inserting stadium with image and coordinates");
            System.out.println("📊 Stadium: " + stadium.getName());
            System.out.println("🖼️ Image: " + stadium.getImageURL());
            System.out.println("📍 Coordinates: " + stadium.getLatitude() + ", " + stadium.getLongitude());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in insertStadiumWithImage: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // 🔥 FIXED: Added Latitude and Longitude to updateStadiumWithImage
    public boolean updateStadiumWithImage(Stadium stadium) {
        String sql = "UPDATE Stadium SET name = ?, location = ?, description = ?, status = ?, phoneNumber = ?, ImageURL = ?, Latitude = ?, Longitude = ? WHERE stadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, stadium.getName());
            ps.setString(2, stadium.getLocation());
            ps.setString(3, stadium.getDescription());
            ps.setString(4, stadium.getStatus());
            ps.setString(5, stadium.getPhoneNumber());
            ps.setString(6, stadium.getImageURL());

            // Handle coordinates
            if (stadium.getLatitude() != null) {
                ps.setDouble(7, stadium.getLatitude());
            } else {
                ps.setNull(7, java.sql.Types.DOUBLE);
            }
            
            if (stadium.getLongitude() != null) {
                ps.setDouble(8, stadium.getLongitude());
            } else {
                ps.setNull(8, java.sql.Types.DOUBLE);
            }

            ps.setInt(9, stadium.getStadiumID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in updateStadiumWithImage: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
  
    public String getStadiumNameById(int stadiumId) throws SQLException {
        String sql = "SELECT Name FROM Stadium WHERE StadiumID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stadiumId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Name");
                }
            }
        }
        return "Sân không xác định";
    }

    public boolean isStadiumBelongsToOwner(int stadiumId, int ownerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Stadium WHERE StadiumID = ? AND OwnerID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stadiumId);
            ps.setInt(2, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // NEW METHOD: Get stadium owner for chat functionality
    public User getStadiumOwner(int stadiumId) throws SQLException {
        String sql = "SELECT u.UserID, u.Email, u.FullName, u.Phone, u.AvatarUrl " +
                    "FROM [User] u " +
                    "INNER JOIN Stadium s ON u.UserID = s.OwnerID " +
                    "WHERE s.StadiumID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stadiumId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                User owner = new User();
                owner.setUserID(rs.getInt("UserID"));
                owner.setEmail(rs.getString("Email"));
                owner.setFullName(rs.getString("FullName"));
                owner.setPhone(rs.getString("Phone"));
                owner.setAvatarUrl(rs.getString("AvatarUrl"));
                return owner;
            }
        }
        return null;
    }
}