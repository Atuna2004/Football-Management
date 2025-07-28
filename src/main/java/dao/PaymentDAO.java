package dao;

import connect.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Payment;
import model.RevenueReport;

public class PaymentDAO {

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

            ps.setInt(1, bookingId);
            ps.setInt(2, bookingId);
            ps.setInt(3, bookingId);

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
    
    // Thêm vào lớp PaymentDAO
    public int getBookingIdByPaymentId(String paymentID) {
        String sql = "SELECT BookingID FROM Payment WHERE PaymentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("BookingID");
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy BookingID từ PaymentID: " + e.getMessage());
        }
        return -1;
    }
    
    // Thêm hàm mới
    public List<RevenueReport> getRevenueByOwnerAndPeriod(int ownerId, String period, String stadiumName) throws SQLException {
        List<RevenueReport> reports = new ArrayList<>();
        String sql = "";

        // Lọc theo sân nếu có, nếu không thì lấy tất cả sân của owner
        String stadiumFilter = stadiumName != null && !stadiumName.isEmpty()
                ? "AND s.Name = ?" : "";

        if ("day".equals(period)) {
            sql = "SELECT s.Name AS StadiumName, CAST(p.PaymentDate AS DATE) AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE p.Status = 'Completed' AND s.OwnerID = ? " + stadiumFilter +
                  "GROUP BY s.Name, CAST(p.PaymentDate AS DATE) " +
                  "ORDER BY Period";
        } else if ("month".equals(period)) {
            sql = "SELECT s.Name AS StadiumName, FORMAT(p.PaymentDate, 'yyyy-MM') AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE p.Status = 'Completed' AND s.OwnerID = ? " + stadiumFilter +
                  "GROUP BY s.Name, FORMAT(p.PaymentDate, 'yyyy-MM') " +
                  "ORDER BY Period";
        } else if ("year".equals(period)) {
            sql = "SELECT s.Name AS StadiumName, CAST(YEAR(p.PaymentDate) AS VARCHAR) AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE p.Status = 'Completed' AND s.OwnerID = ? " + stadiumFilter +
                  "GROUP BY s.Name, YEAR(p.PaymentDate) " +
                  "ORDER BY Period";
        } else {
            throw new IllegalArgumentException("Period must be 'day', 'month', or 'year'");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);
            if (stadiumFilter.length() > 0) {
                ps.setString(2, stadiumName);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RevenueReport report = new RevenueReport();
                    report.setStadiumName(rs.getString("StadiumName"));
                    report.setPeriod(rs.getString("Period"));
                    report.setTotalRevenue(rs.getDouble("TotalRevenue"));
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    /**
     * Lấy doanh thu theo stadium và period (day/month/year)
     * @param stadiumId ID sân
     * @param period "day", "month", "year"
     * @return List<RevenueReport>
     */
    public List<RevenueReport> getRevenueByStadiumAndPeriod(int stadiumId, String period) throws SQLException {
        List<RevenueReport> reports = new ArrayList<>();
        String sql = "";

        if ("day".equals(period)) {
            sql = "SELECT CAST(p.PaymentDate AS DATE) AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE s.StadiumID = ? AND p.Status = 'Completed' " +
                  "AND MONTH(p.PaymentDate) = MONTH(GETDATE()) AND YEAR(p.PaymentDate) = YEAR(GETDATE()) " +
                  "GROUP BY CAST(p.PaymentDate AS DATE) " +
                  "ORDER BY Period";
        } else if ("month".equals(period)) {
            sql = "SELECT MONTH(p.PaymentDate) AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE s.StadiumID = ? AND p.Status = 'Completed' " +
                  "AND YEAR(p.PaymentDate) = YEAR(GETDATE()) " +
                  "GROUP BY MONTH(p.PaymentDate) " +
                  "ORDER BY Period";
        } else if ("year".equals(period)) {
            sql = "SELECT YEAR(p.PaymentDate) AS Period, SUM(p.Amount) AS TotalRevenue " +
                  "FROM Payment p " +
                  "JOIN Booking b ON p.BookingID = b.BookingID " +
                  "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                  "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                  "JOIN Field f ON t.FieldID = f.FieldID " +
                  "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                  "WHERE s.StadiumID = ? AND p.Status = 'Completed' " +
                  "AND YEAR(p.PaymentDate) >= YEAR(GETDATE()) - 4 " +
                  "GROUP BY YEAR(p.PaymentDate) " +
                  "ORDER BY Period";
        } else {
            throw new IllegalArgumentException("Period must be 'day', 'month', or 'year'");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stadiumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RevenueReport report = new RevenueReport();
                    report.setPeriod(rs.getString("Period")); // có thể là "2025-06-15", 6, 2025
                    report.setTotalRevenue(rs.getDouble("TotalRevenue"));
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    /**
     * Lấy doanh thu theo ngày trong tháng hiện tại cho một sân cụ thể
     * @param stadiumId ID của sân
     * @return Map<Integer, Double>: key = ngày (1-31), value = doanh thu
     */
    public Map<Integer, Double> getDailyRevenueByStadium(int stadiumId) {
        Map<Integer, Double> revenueMap = new HashMap<>();
        
        // Lấy số ngày của tháng hiện tại
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1; // 1-12
        int currentYear = cal.get(Calendar.YEAR);
        int maxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

        // Khởi tạo tất cả các ngày = 0
        for (int i = 1; i <= maxDay; i++) {
            revenueMap.put(i, 0.0);
        }

        String sql = "SELECT DAY(p.PaymentDate) AS day, SUM(p.Amount) AS revenue " +
                     "FROM Payment p " +
                     "JOIN Booking b ON p.BookingID = b.BookingID " +
                     "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                     "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                     "JOIN Field f ON t.FieldID = f.FieldID " +
                     "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                     "WHERE s.StadiumID = ? " +
                     "AND p.Status = 'Completed' " +
                     "AND MONTH(p.PaymentDate) = ? " +
                     "AND YEAR(p.PaymentDate) = ? " +
                     "GROUP BY DAY(p.PaymentDate)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stadiumId);
            ps.setInt(2, currentMonth);
            ps.setInt(3, currentYear);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int day = rs.getInt("day");
                    double revenue = rs.getDouble("revenue");
                    revenueMap.put(day, revenue);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return revenueMap;
    }

    /**
     * Lấy doanh thu theo tháng trong năm hiện tại cho một sân cụ thể
     * @param stadiumId ID của sân
     * @return Map<Integer, Double>: key = tháng (1-12), value = doanh thu
     */
    public Map<Integer, Double> getMonthlyRevenueByStadium(int stadiumId) {
        Map<Integer, Double> revenueMap = new HashMap<>();

        // Khởi tạo 12 tháng = 0
        for (int i = 1; i <= 12; i++) {
            revenueMap.put(i, 0.0);
        }

        String sql = "SELECT MONTH(p.PaymentDate) AS month, SUM(p.Amount) AS revenue " +
                     "FROM Payment p " +
                     "JOIN Booking b ON p.BookingID = b.BookingID " +
                     "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                     "JOIN TimeSlot t ON bts.TimeSlotID = t.TimeSlotID " +
                     "JOIN Field f ON t.FieldID = f.FieldID " +
                     "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
                     "WHERE s.StadiumID = ? " +
                     "AND p.Status = 'Completed' " +
                     "AND YEAR(p.PaymentDate) = YEAR(GETDATE()) " +
                     "GROUP BY MONTH(p.PaymentDate)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stadiumId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int month = rs.getInt("month");
                    double revenue = rs.getDouble("revenue");
                    revenueMap.put(month, revenue);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return revenueMap;
    }

}
