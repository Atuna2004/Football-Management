package dao;

import connect.DBConnection;
import model.FoodOrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodOrderItemDAO {

    private final Connection conn;

    public FoodOrderItemDAO() {
        this.conn = DBConnection.getConnection();
    }

    // Thêm một dòng FoodOrderItem
    public void insert(FoodOrderItem item) {
        String sql = "INSERT INTO FoodOrderItem (FoodOrderID, FoodItemID, Quantity, Price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getFoodOrderID());
            ps.setInt(2, item.getFoodItemID());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getPrice());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách món ăn của một đơn hàng
    public List<FoodOrderItem> getItemsByOrderId(int orderId) {
        List<FoodOrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM FoodOrderItem WHERE FoodOrderID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FoodOrderItem item = new FoodOrderItem();
                    item.setFoodOrderItemID(rs.getInt("FoodOrderItemID"));
                    item.setFoodOrderID(rs.getInt("FoodOrderID"));
                    item.setFoodItemID(rs.getInt("FoodItemID"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setPrice(rs.getDouble("Price"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // (Tùy chọn) Xoá theo orderId
    public void deleteByOrderId(int orderId) {
        String sql = "DELETE FROM FoodOrderItem WHERE FoodOrderID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
