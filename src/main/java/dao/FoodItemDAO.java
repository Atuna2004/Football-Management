package dao;

import model.FoodItem;
import connect.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodItemDAO {

    // Lấy danh sách món ăn theo sân, chỉ lấy món đang hoạt động
    public List<FoodItem> getFoodItemsByStadium(int stadiumId) {
        List<FoodItem> list = new ArrayList<>();
        String sql = "SELECT * FROM FoodItem WHERE StadiumID = ? AND IsActive = 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stadiumId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                FoodItem item = new FoodItem();
                item.setFoodItemID(rs.getInt("FoodItemID"));
                item.setStadiumID(rs.getInt("StadiumID"));
                item.setName(rs.getString("Name"));
                item.setDescription(rs.getString("Description"));
                item.setPrice(rs.getDouble("Price"));
                item.setStockQuantity(rs.getInt("StockQuantity"));
                item.setActive(rs.getBoolean("IsActive"));

                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<FoodItem> getFoodItemsByOwner(int ownerId) {
        List<FoodItem> list = new ArrayList<>();

        String sql
                = "SELECT "
                + "    FI.FoodItemID, FI.Name AS FoodName, FI.Description, "
                + "    FI.Price, FI.StockQuantity, FI.IsActive, FI.ImageUrl, "
                + "    S.StadiumID, S.Name AS StadiumName "
                + "FROM FoodItem FI "
                + "JOIN Stadium S ON FI.StadiumID = S.StadiumID "
                + "WHERE S.OwnerID = ? "
                + "ORDER BY S.StadiumID, FI.Name";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                FoodItem item = new FoodItem();
                item.setFoodItemID(rs.getInt("FoodItemID"));
                item.setName(rs.getString("FoodName"));
                item.setDescription(rs.getString("Description"));
                item.setPrice(rs.getDouble("Price"));
                item.setStockQuantity(rs.getInt("StockQuantity"));
                item.setActive(rs.getBoolean("IsActive"));
                item.setImageUrl(rs.getString("ImageUrl"));
                item.setStadiumName(rs.getString("StadiumName"));
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy món ăn theo ID
    public FoodItem getFoodItemById(int id) {
        String sql = "SELECT * FROM FoodItem WHERE FoodItemID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new FoodItem(
                        rs.getInt("FoodItemID"),
                        rs.getInt("StadiumID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("Price"),
                        rs.getInt("StockQuantity"),
                        rs.getBoolean("IsActive")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Trừ số lượng món sau khi đặt
    public void reduceStock(int foodItemId, int quantity) {
        String sql = "UPDATE FoodItem SET StockQuantity = StockQuantity - ? WHERE FoodItemID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, foodItemId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private FoodItem mapFoodItem(ResultSet rs, boolean includeStadium) throws SQLException {
        FoodItem item = new FoodItem();
        item.setFoodItemID(rs.getInt("FoodItemID"));
        item.setStadiumID(rs.getInt("StadiumID"));
        item.setName(rs.getString("Name"));
        item.setDescription(rs.getString("Description"));
        item.setPrice(rs.getDouble("Price"));
        item.setStockQuantity(rs.getInt("StockQuantity"));
        item.setActive(rs.getBoolean("IsActive"));
        item.setImageUrl(rs.getString("ImageUrl"));
        if (includeStadium) {
            item.setStadiumName(rs.getString("StadiumName"));
        }
        return item;
    }

    public int addFoodItem(FoodItem item) {
        final String sql = "INSERT INTO FoodItem (StadiumID, Name, Description, Price, StockQuantity, IsActive, ImageUrl) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, item.getStadiumID());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setDouble(4, item.getPrice());
            ps.setInt(5, item.getStockQuantity());
            ps.setBoolean(6, item.isActive());
            ps.setString(7, item.getImageUrl());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean updateFoodItem(FoodItem item) {
        final String sql = "UPDATE FoodItem "
                + "SET StadiumID = ?, Name = ?, Description = ?, Price = ?, StockQuantity = ?, "
                + "    IsActive = ?, ImageUrl = ? "
                + "WHERE FoodItemID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getStadiumID());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setDouble(4, item.getPrice());
            ps.setInt(5, item.getStockQuantity());
            ps.setBoolean(6, item.isActive());
            ps.setString(7, item.getImageUrl());
            ps.setInt(8, item.getFoodItemID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteFoodItem(int foodItemId) {
        return toggleActive(foodItemId, false);
    }

    public boolean toggleActive(int foodItemId, boolean active) {
        final String sql = "UPDATE FoodItem SET IsActive = ? WHERE FoodItemID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, active);
            ps.setInt(2, foodItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hardDeleteFoodItem(int foodItemId) {
        final String sql = "DELETE FROM FoodItem WHERE FoodItemID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, foodItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<FoodItem> searchFoodItems(int ownerId, String keyword, Integer stadiumId, Boolean active) {
        List<FoodItem> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT FI.*, S.Name AS StadiumName FROM FoodItem FI ")
                .append("JOIN Stadium S ON FI.StadiumID = S.StadiumID ")
                .append("WHERE S.OwnerID = ? ");

        if (keyword != null && !keyword.isBlank()) {
            sb.append("AND FI.Name LIKE ? ");
        }
        if (stadiumId != null) {
            sb.append("AND S.StadiumID = ? ");
        }
        if (active != null) {
            sb.append("AND FI.IsActive = ? ");
        }
        sb.append("ORDER BY S.StadiumID, FI.Name");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            int idx = 1;
            ps.setInt(idx++, ownerId);
            if (keyword != null && !keyword.isBlank()) {
                ps.setString(idx++, "%" + keyword + "%");
            }
            if (stadiumId != null) {
                ps.setInt(idx++, stadiumId);
            }
            if (active != null) {
                ps.setBoolean(idx++, active);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapFoodItem(rs, true));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<FoodItem> searchByName(String keyword) {
        List<FoodItem> list = new ArrayList<>();

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT FoodItemID, StadiumID, Name, Description, Price, ")
           .append("StockQuantity, IsActive, ImageUrl ")
           .append("FROM FoodItem ");

        if (hasKeyword) {
            sql.append("WHERE Name COLLATE Latin1_General_CI_AI LIKE ? ");
        }
        sql.append("ORDER BY Name");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (hasKeyword) {
                ps.setString(1, "%" + keyword.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // mapFoodItem không cần StadiumName ➜ includeStadium = false
                    list.add(mapFoodItem(rs, false));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    
}
