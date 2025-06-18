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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // Lấy món ăn theo ID
    public FoodItem getFoodItemById(int id) {
        String sql = "SELECT * FROM FoodItem WHERE FoodItemID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, foodItemId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
