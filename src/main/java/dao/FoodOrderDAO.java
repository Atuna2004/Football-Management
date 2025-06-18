package dao;

import connect.DBConnection;
import model.CartItem;

import java.sql.*;
import java.util.List;

public class FoodOrderDAO {

    private final Connection conn;

    public FoodOrderDAO() {
        conn = DBConnection.getConnection();
    }

    // Tạo đơn hàng món ăn, trả về ID đơn hàng
    public int createFoodOrder(int userId, int stadiumId, int bookingId, double totalAmount) {
        String sql = "INSERT INTO FoodOrder (UserID, StadiumID, BookingID, Status, TotalAmount, CreatedAt) " +
                     "VALUES (?, ?, ?, 'Pending', ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, stadiumId);
            ps.setInt(3, bookingId);
            ps.setDouble(4, totalAmount);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // FoodOrderID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Thêm từng món vào bảng FoodOrderItem
    public void insertOrderItems(int orderId, List<CartItem> items) {
        String sql = "INSERT INTO FoodOrderItem (FoodOrderID, FoodItemID, Quantity, Price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (CartItem item : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getFoodItem().getFoodItemID());
                ps.setInt(3, item.getQuantity());
                ps.setDouble(4, item.getFoodItem().getPrice());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // (Tùy chọn) Trừ số lượng kho
    public void reduceStock(List<CartItem> items) {
        String sql = "UPDATE FoodItem SET StockQuantity = StockQuantity - ? WHERE FoodItemID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (CartItem item : items) {
                ps.setInt(1, item.getQuantity());
                ps.setInt(2, item.getFoodItem().getFoodItemID());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
     public double getFoodOrderTotal(int bookingId) {
        String sql = "SELECT SUM(TotalAmount) AS Total FROM FoodOrder WHERE BookingID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("Total");
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy food total: " + e.getMessage());
        }
        return 0;
    }
}
