package dao;

import connect.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PaymentDAO {

    /**
     * Ghi nhận một thanh toán mới.
     *
     * @param bookingId     Mã đặt sân
     * @param amount        Tổng số tiền thanh toán
     * @param method        Phương thức (Offline, VNPay, Momo, v.v.)
     * @param status        Trạng thái (Pending, Completed, Failed)
     * @param transactionId Mã giao dịch (nếu có, với cổng online)
     * @return true nếu thành công
     */
    public boolean createPayment(int bookingId, double amount, String method, String status, String transactionId) {
        String sql = "INSERT INTO Payment (BookingID, PaymentMethod, Amount, Status, TransactionID) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ps.setString(2, method);
            ps.setDouble(3, amount);
            ps.setString(4, status);

            if (transactionId != null) {
                ps.setString(5, transactionId);
            } else {
                ps.setNull(5, java.sql.Types.VARCHAR);
            }

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("Lỗi khi tạo payment: " + e.getMessage());
            return false;
        }
    }

    /**
     * Lấy BookingID dựa theo TransactionID (dùng khi return từ VNPay).
     */
    public int getBookingIdByTransactionId(String txnRef) {
        String sql = "SELECT BookingID FROM Payment WHERE TransactionID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, txnRef);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("BookingID");
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy BookingID từ TransactionID: " + e.getMessage());
        }
        return -1;
    }

    /**
     * Tính tổng giá vé sân theo BookingID.
     */
    public double getTicketPrice(int bookingId) {
        String sql =
            "SELECT SUM(ts.Price) AS Total " +
            "FROM BookingTimeSlot bts " +
            "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID " +
            "WHERE bts.BookingID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("Total");
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy ticket price: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tính tổng tiền đồ ăn đã đặt kèm theo booking.
     */
   
    
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
    
    public boolean updatePaymentStatusByTxnRef(String txnRef, String newStatus) {
        String sql = "UPDATE Payment SET Status = ? WHERE TransactionID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, txnRef);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi khi cập nhật payment: " + e.getMessage());
            return false;
        }
    }

    /**
 * Lấy tổng tiền đã giảm (áp dụng mã giảm giá) theo BookingID.
 * Ưu tiên từ bảng Booking nếu có DiscountPercent.
 */
    public double getBookingTotalAmount(int bookingId) {
    String sql = "SELECT " +
                 "  ISNULL((" +
                 "    SELECT SUM(ts.Price) " +
                 "    FROM BookingTimeSlot bts " +
                 "    JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID " +
                 "    WHERE bts.BookingID = ?" +
                 "  ), 0) AS TicketTotal, " +
                 "  ISNULL((" +
                 "    SELECT SUM(TotalAmount) FROM FoodOrder WHERE BookingID = ?" +
                 "  ), 0) AS FoodTotal, " +
                 "  ISNULL(dc.DiscountPercent, 0) AS DiscountPercent " +
                 "FROM Booking b " +
                 "LEFT JOIN DiscountCode dc ON b.DiscountCodeID = dc.DiscountCodeID " +
                 "WHERE b.BookingID = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, bookingId); // For TicketTotal
        ps.setInt(2, bookingId); // For FoodTotal
        ps.setInt(3, bookingId); // For Booking + join

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            double ticket = rs.getDouble("TicketTotal");
            double food = rs.getDouble("FoodTotal");
            int discount = rs.getInt("DiscountPercent");

            double total = ticket + food;
            if (discount > 0) {
                total = total - (total * discount / 100.0);
            }
            return total;
        }

    } catch (Exception e) {
        System.err.println("Lỗi khi tính tổng tiền sau giảm: " + e.getMessage());
    }

    return 0;
}




}
