package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import connect.DBConnection;
import java.util.Calendar;
import model.DashboardStats;
import model.RecentBooking;

public class DashboardDAO {

    /**
     * Lấy thống kê tổng quan cho dashboard của chủ sân
     *
     * @param ownerID ID của chủ sân
     * @return DashboardStats object chứa các thống kê
     */
    public DashboardStats getDashboardStats(int ownerID) {
        DashboardStats stats = new DashboardStats();
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();

            // 1. Lấy số lượt đặt hôm nay
            String todayBookingsQuery
                    = "SELECT COUNT(DISTINCT b.BookingID) "
                    + "FROM Booking b "
                    + "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID "
                    + "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID "
                    + "JOIN Field f ON ts.FieldID = f.FieldID "
                    + "JOIN Stadium s ON f.StadiumID = s.StadiumID "
                    + "WHERE s.OwnerID = ? "
                    + "AND CAST(b.CreatedAt AS DATE) = CAST(GETDATE() AS DATE) "
                    + "AND b.Status != 'Cancelled'";

            try (PreparedStatement stmt = conn.prepareStatement(todayBookingsQuery)) {
                stmt.setInt(1, ownerID);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.setTodayBookings(rs.getInt(1));
                }
            }

            // 2. Lấy doanh thu tháng hiện tại
            String monthlyRevenueQuery
                    = "SELECT ISNULL(SUM(b.TotalAmount), 0) "
                    + "FROM Booking b "
                    + "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID "
                    + "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID "
                    + "JOIN Field f ON ts.FieldID = f.FieldID "
                    + "JOIN Stadium s ON f.StadiumID = s.StadiumID "
                    + "WHERE s.OwnerID = ? "
                    + "AND MONTH(b.CreatedAt) = MONTH(GETDATE()) "
                    + "AND YEAR(b.CreatedAt) = YEAR(GETDATE()) "
                    + "AND b.Status = 'Completed'";

            try (PreparedStatement stmt = conn.prepareStatement(monthlyRevenueQuery)) {
                stmt.setInt(1, ownerID);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.setMonthlyRevenue(rs.getDouble(1));
                }
            }

            // 3. Lấy tổng số sân
            String totalFieldsQuery
                    = "SELECT COUNT(*) "
                    + "FROM Field f "
                    + "JOIN Stadium s ON f.StadiumID = s.StadiumID "
                    + "WHERE s.OwnerID = ?";

            try (PreparedStatement stmt = conn.prepareStatement(totalFieldsQuery)) {
                stmt.setInt(1, ownerID);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.setTotalFields(rs.getInt(1));
                }
            }

            // 4. Lấy số khách hàng đã đặt sân
            String totalCustomersQuery
                    = "SELECT COUNT(DISTINCT b.UserID) "
                    + "FROM Booking b "
                    + "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID "
                    + "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID "
                    + "JOIN Field f ON ts.FieldID = f.FieldID "
                    + "JOIN Stadium s ON f.StadiumID = s.StadiumID "
                    + "WHERE s.OwnerID = ? "
                    + "AND b.Status != 'Cancelled'";

            try (PreparedStatement stmt = conn.prepareStatement(totalCustomersQuery)) {
                stmt.setInt(1, ownerID);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.setTotalCustomers(rs.getInt(1));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting dashboard stats: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Lấy danh sách đặt sân gần đây
     *
     * @param ownerID ID của chủ sân
     * @param limit Số lượng booking muốn lấy
     * @return List các RecentBooking
     */
    public List<RecentBooking> getRecentBookings(int ownerID, int limit) {
        List<RecentBooking> bookings = new ArrayList<>();
        Connection conn = null;

        String query
                = "SELECT TOP (" + limit + ") "
                + "    b.BookingID, "
                + "    u.FullName as CustomerName, "
                + "    u.Email as CustomerEmail, "
                + "    u.Phone as CustomerPhone, "
                + "    s.Name as StadiumName, "
                + "    f.FieldName, "
                + "    f.Type as FieldType, "
                + "    MIN(ts.Date) as BookingDate, "
                + "    MIN(ts.StartTime) as StartTime, "
                + "    MAX(ts.EndTime) as EndTime, "
                + "    b.TotalAmount, "
                + "    b.Status, "
                + "    b.CreatedAt "
                + "FROM Booking b "
                + "JOIN [User] u ON b.UserID = u.UserID "
                + "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID "
                + "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID "
                + "JOIN Field f ON ts.FieldID = f.FieldID "
                + "JOIN Stadium s ON f.StadiumID = s.StadiumID "
                + "WHERE s.OwnerID = ? "
                + "GROUP BY b.BookingID, u.FullName, u.Email, u.Phone, s.Name, f.FieldName, f.Type, b.TotalAmount, b.Status, b.CreatedAt "
                + "ORDER BY b.CreatedAt DESC";

        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, ownerID);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                RecentBooking booking = new RecentBooking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setCustomerName(rs.getString("CustomerName"));
                booking.setCustomerEmail(rs.getString("CustomerEmail"));
                booking.setCustomerPhone(rs.getString("CustomerPhone"));
                booking.setStadiumName(rs.getString("StadiumName"));
                booking.setFieldName(rs.getString("FieldName"));
                booking.setFieldType(rs.getString("FieldType"));
                booking.setBookingDate(rs.getDate("BookingDate"));
                booking.setStartTime(rs.getTime("StartTime"));
                booking.setEndTime(rs.getTime("EndTime"));
                booking.setTotalAmount(rs.getDouble("TotalAmount"));
                booking.setStatus(rs.getString("Status"));
                booking.setCreatedAt(rs.getTimestamp("CreatedAt"));

                bookings.add(booking);
            }

        } catch (SQLException e) {
            System.err.println("Error getting recent bookings: " + e.getMessage());
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Lấy thống kê doanh thu theo tháng trong năm
     *
     * @param ownerID ID của chủ sân
     * @param year Năm cần thống kê
     * @return List array chứa doanh thu từ tháng 1-12
     */
    public Map<Integer, Double> getMonthlyRevenueByOwner(int ownerId) {
        Map<Integer, Double> revenueByMonth = new HashMap<>();
        // Initialize all months with 0 revenue
        for (int i = 1; i <= 12; i++) {
            revenueByMonth.put(i, 0.0);
        }

        String sql
                = "SELECT Month, SUM(Revenue) AS TotalRevenue "
                + "FROM ( "
                + "   SELECT MONTH(p.PaymentDate) AS Month, p.Amount AS Revenue "
                + "   FROM Payment p "
                + "   INNER JOIN ( "
                + "       SELECT DISTINCT b.BookingID "
                + "       FROM Booking b "
                + "       JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID "
                + "       JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID "
                + "       JOIN Field f ON ts.FieldID = f.FieldID "
                + "       JOIN Stadium s ON f.StadiumID = s.StadiumID "
                + "       WHERE s.OwnerID = ? "
                + "   ) AS valid_bookings ON p.BookingID = valid_bookings.BookingID "
                + "   WHERE p.Status = 'Completed' AND YEAR(p.PaymentDate) = YEAR(GETDATE()) "
                + "   UNION ALL "
                + "   SELECT MONTH(fo.CreatedAt) AS Month, fo.TotalAmount AS Revenue "
                + "   FROM FoodOrder fo "
                + "   INNER JOIN Stadium s ON fo.StadiumID = s.StadiumID "
                + "   WHERE fo.Status = 'Completed' "
                + "     AND YEAR(fo.CreatedAt) = YEAR(GETDATE()) "
                + "     AND s.OwnerID = ? "
                + ") AS CombinedRevenue "
                + "GROUP BY Month "
                + "ORDER BY Month;";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);  // For Payment section
            ps.setInt(2, ownerId);  // For FoodOrder section

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int month = rs.getInt("Month");
                    double revenue = rs.getDouble("TotalRevenue");
                    revenueByMonth.put(month, revenue);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error getting monthly revenue: " + e.getMessage());
        }

        return revenueByMonth;
    }

    public List<RecentBooking> getAllBookings() {
        List<RecentBooking> bookings = new ArrayList<>();

        String sql
                = "SELECT "
                + "    B.BookingID, "
                + "    U.FullName AS CustomerName, "
                + "    u.Email as CustomerEmail, "
                + "    u.Phone as CustomerPhone, "
                + "    S.Name AS StadiumName, "
                + "    f.FieldName, "
                + "    f.Type as FieldType, "
                + "    MIN(ts.Date) as BookingDate, "
                + "    MIN(ts.StartTime) as StartTime, "
                + "    MAX(ts.EndTime) as EndTime, "
                + "    ISNULL(STRING_AGG(FI.Name + ' (x' + CAST(FOI.Quantity AS NVARCHAR) + ')', ', '), N'Không') AS OrderedFoods, "
                + "    B.TotalAmount + ISNULL(FO.TotalAmount, 0) AS TotalAmount, "
                + "    B.Status, "
                + "    B.CreatedAt "
                + "FROM Booking B "
                + "JOIN [User] U ON B.UserID = U.UserID "
                + "JOIN BookingTimeSlot BTS ON B.BookingID = BTS.BookingID "
                + "JOIN TimeSlot TS ON BTS.TimeSlotID = TS.TimeSlotID "
                + "JOIN Field F ON TS.FieldID = F.FieldID "
                + "JOIN Stadium S ON F.StadiumID = S.StadiumID "
                + "LEFT JOIN FoodOrder FO ON FO.BookingID = B.BookingID "
                + "LEFT JOIN FoodOrderItem FOI ON FO.FoodOrderID = FOI.FoodOrderID "
                + "LEFT JOIN FoodItem FI ON FOI.FoodItemID = FI.FoodItemID "
                + "GROUP BY "
                + "    B.BookingID, U.FullName, u.Email, u.Phone, S.Name, f.FieldName, f.Type, "
                + "    B.TotalAmount, FO.TotalAmount, B.Status, B.CreatedAt "
                + "ORDER BY B.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RecentBooking b = new RecentBooking();
                b.setBookingID(rs.getInt("BookingID"));
                b.setCustomerName(rs.getString("CustomerName"));
                b.setCustomerEmail(rs.getString("CustomerEmail"));
                b.setCustomerPhone(rs.getString("CustomerPhone"));
                b.setStadiumName(rs.getString("StadiumName"));
                b.setFieldName(rs.getString("FieldName"));
                b.setFieldType(rs.getString("FieldType"));
                b.setBookingDate(rs.getDate("BookingDate"));
                b.setStartTime(rs.getTime("StartTime"));
                b.setEndTime(rs.getTime("EndTime"));
                b.setOrderedFoods(rs.getString("OrderedFoods"));
                b.setTotalAmount(rs.getDouble("TotalAmount"));
                b.setStatus(rs.getString("Status"));
                b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                bookings.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookings;
    }

//        public static void main(String[] args) {
//            // Giả sử ID của chủ sân là 1 (thay bằng ID thực tế bạn cần test)
//            int ownerId = 1;
//
//            DashboardDAO dashboardDAO = new DashboardDAO();
//            Map<Integer, Double> revenueByMonth = dashboardDAO.getMonthlyRevenueByOwner(ownerId);
//
//            System.out.println("Doanh thu theo tháng trong năm hiện tại cho chủ sân có ID = " + ownerId + ":");
//            for (int month = 1; month <= 12; month++) {
//                System.out.printf("Tháng %02d: %.2f VND%n", month, revenueByMonth.get(month));
//            }
//        }
    
    /**
    * Lấy số lượng booking theo tháng trong năm hiện tại
    */
   public Map<Integer, Integer> getMonthlyBookingsByOwner(int ownerId) {
       Map<Integer, Integer> bookingsMap = new HashMap<>();
       // Khởi tạo tất cả các tháng với giá trị 0
       for (int i = 1; i <= 12; i++) {
           bookingsMap.put(i, 0);
       }

       String sql = 
           "SELECT MONTH(b.CreatedAt) AS month, COUNT(*) AS count " +
           "FROM Booking b " +
           "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
           "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID " +
           "JOIN Field f ON ts.FieldID = f.FieldID " +
           "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
           "WHERE s.OwnerID = ? " +
           "  AND YEAR(b.CreatedAt) = YEAR(GETDATE()) " +
           "  AND b.Status != 'Cancelled' " +
           "GROUP BY MONTH(b.CreatedAt)";

       try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
           ps.setInt(1, ownerId);
           try (ResultSet rs = ps.executeQuery()) {
               while (rs.next()) {
                   int month = rs.getInt("month");
                   int count = rs.getInt("count");
                   bookingsMap.put(month, count);
               }
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
       return bookingsMap;
   }

   /**
    * Lấy số lượng booking theo ngày trong tháng hiện tại
    */
   public Map<Integer, Integer> getDailyBookingsByOwner(int ownerId) {
    Map<Integer, Integer> bookingsMap = new HashMap<>();
    
    // Lấy số ngày của tháng hiện tại
    Calendar cal = Calendar.getInstance();
    int currentMonth = cal.get(Calendar.MONTH) + 1; // 1-12
    int currentYear = cal.get(Calendar.YEAR);
    int maxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH); // Tự động lấy 28, 29, 30, 31
    
    // Khởi tạo map với số ngày thực tế của tháng
    for (int i = 1; i <= maxDay; i++) {
        bookingsMap.put(i, 0);
    }

    String sql =
        "SELECT DAY(b.CreatedAt) AS day, COUNT(*) AS count " +
        "FROM Booking b " +
        "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
        "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID " +
        "JOIN Field f ON ts.FieldID = f.FieldID " +
        "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
        "WHERE s.OwnerID = ? " +
        "  AND MONTH(b.CreatedAt) = ? " +
        "  AND YEAR(b.CreatedAt) = ? " +
        "  AND b.Status != 'Cancelled' " +
        "GROUP BY DAY(b.CreatedAt)";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, ownerId);
        ps.setInt(2, currentMonth);
        ps.setInt(3, currentYear);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int day = rs.getInt("day");
                int count = rs.getInt("count");
                if (day >= 1 && day <= maxDay) { // Đảm bảo không vượt quá
                    bookingsMap.put(day, count);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return bookingsMap;
}
   
   /**
    * Lấy doanh thu theo ngày trong tháng hiện tại
    */
   public Map<Integer, Double> getDailyRevenueByOwner(int ownerId) {
       Map<Integer, Double> revenueMap = new HashMap<>();

       Calendar cal = Calendar.getInstance();
       int currentMonth = cal.get(Calendar.MONTH) + 1;
       int currentYear = cal.get(Calendar.YEAR);
       int maxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

       // Khởi tạo tất cả các ngày trong tháng = 0
       for (int i = 1; i <= maxDay; i++) {
           revenueMap.put(i, 0.0);
       }

       String sql = 
           "SELECT DAY(p.PaymentDate) AS day, SUM(p.Amount) AS revenue " +
           "FROM Payment p " +
           "JOIN Booking b ON p.BookingID = b.BookingID " +
           "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
           "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID " +
           "JOIN Field f ON ts.FieldID = f.FieldID " +
           "JOIN Stadium s ON f.StadiumID = s.StadiumID " +
           "WHERE s.OwnerID = ? " +
           "  AND MONTH(p.PaymentDate) = ? " +
           "  AND YEAR(p.PaymentDate) = ? " +
           "  AND p.Status = 'Completed' " +
           "GROUP BY DAY(p.PaymentDate)";

       try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

           ps.setInt(1, ownerId);
           ps.setInt(2, currentMonth);
           ps.setInt(3, currentYear);

           try (ResultSet rs = ps.executeQuery()) {
               while (rs.next()) {
                   int day = rs.getInt("day");
                   double revenue = rs.getDouble("revenue");
                   if (revenueMap.containsKey(day)) {
                       revenueMap.put(day, revenue);
                   }
               }
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
       return revenueMap;
   }

}