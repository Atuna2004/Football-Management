package dao;

import connect.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Payment;
import model.RevenueReport;

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
    
    public String getUserNameByBookingId(int bookingId) throws SQLException {
    String sql = "SELECT u.FullName FROM Booking b JOIN [User] u ON b.UserID = u.UserID WHERE b.BookingID = ?";
    try (Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, bookingId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("FullName");
            }
        }
    }
    return null;
}
    public List<Payment> getPaymentsByStatus(String status) throws SQLException {
    List<Payment> list = new ArrayList<>();
    String sql = "SELECT * FROM Payment WHERE Status = ?";
    try (Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, status);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("PaymentID"));
                p.setBookingId(rs.getInt("BookingID"));
                p.setAmount(rs.getDouble("Amount"));
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                p.setStatus(rs.getString("Status"));
                p.setTransactionId(rs.getString("TransactionID"));
                p.setPaymentDate(rs.getTimestamp("PaymentDate"));
                list.add(p);
            }
        }
    }
    return list;
}
    
    public boolean updatePaymentStatusByPaymentID(String paymentID, String newStatus) {
        String sql = "UPDATE Payment SET Status = ? WHERE PaymentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, paymentID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi khi cập nhật payment: " + e.getMessage());
            return false;
        }
    }
    
    public List<RevenueReport> getRevenueByStadiumAndPeriod(String period) throws SQLException {
        List<RevenueReport> reports = new ArrayList<>();
        String sql = "";

        if ("day".equals(period)) {
            sql = "SELECT s.Name AS StadiumName, CAST(p.PaymentDate AS DATE) AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE p.Status = 'Completed' " +
                  "GROUP BY s.Name, CAST(p.PaymentDate AS DATE)";
        } else if ("month".equals(period)) {
            sql = "SELECT s.Name AS StadiumName, FORMAT(p.PaymentDate, 'yyyy-MM') AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE p.Status = 'Completed' " +
                  "GROUP BY s.Name, FORMAT(p.PaymentDate, 'yyyy-MM')";
        } else if ("year".equals(period)) {
            sql = "SELECT s.Name AS StadiumName, YEAR(p.PaymentDate) AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE p.Status = 'Completed' " +
                  "GROUP BY s.Name, YEAR(p.PaymentDate)";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RevenueReport report = new RevenueReport();
                report.setStadiumName(rs.getString("StadiumName"));
                report.setPeriod(rs.getString("Period"));
                report.setTotalRevenue(rs.getDouble("TotalRevenue"));
                reports.add(report);
            }
        }
        return reports;
    }

    public List<String> getAllStadiumNames() throws SQLException {
        List<String> stadiums = new ArrayList<>();
        String sql = "SELECT Name FROM Stadium";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stadiums.add(rs.getString("Name"));
            }
        }
        return stadiums;
    }
    
    /**
    * Tạo thanh toán thủ công cho booking đặt bởi chủ sân.
    *
    * @param bookingId Mã đặt sân
    * @param amount Tổng số tiền (bao gồm sân + đồ ăn)
    * @return true nếu thành công
    */
   public boolean createPaymentForManualBooking(int bookingId, double amount) {
       String sql = "INSERT INTO Payment (BookingID, PaymentMethod, Amount, Status, TransactionID, PaymentDate) " +
                    "VALUES (?, 'Offline', ?, 'Completed', 'MANUAL_BOOKING_' + CAST(? AS VARCHAR), GETDATE())";
       try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
           ps.setInt(1, bookingId);
           ps.setDouble(2, amount);
           ps.setInt(3, bookingId);
           return ps.executeUpdate() > 0;
       } catch (Exception e) {
           System.err.println("Lỗi khi tạo thanh toán thủ công: " + e.getMessage());
           return false;
       }
   }
}
