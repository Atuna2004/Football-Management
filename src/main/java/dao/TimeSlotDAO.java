package dao;

import connect.DBConnection;
import model.TimeSlot;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public class TimeSlotDAO {
        private static final Logger logger = Logger.getLogger(TimeSlotDAO.class.getName());


    public List<TimeSlot> getTimeSlotsByStadiumAndWeek(int stadiumId, LocalDate startOfWeek) {
        List<TimeSlot> list = new ArrayList<>();

       String sql =
        "SELECT ts.*, f.fieldName, " +
        "       b.Status AS bookingStatus, b.CreatedAt AS bookingCreatedAt " +
        "FROM TimeSlot ts " +
        "JOIN Field f ON ts.fieldID = f.fieldID " +
        "LEFT JOIN BookingTimeSlot bts ON ts.TimeSlotID = bts.TimeSlotID " +
        "LEFT JOIN Booking b ON bts.BookingID = b.BookingID " +
        "WHERE f.stadiumID = ? " +
        "  AND f.isActive = 1 " +           // <-- FIX: Thêm điều kiện Field active
        "  AND ts.isActive = 1 " +
        "  AND ts.date BETWEEN ? AND ? " +
        "ORDER BY ts.date, ts.startTime";
       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stadiumId);
            ps.setDate(2, Date.valueOf(startOfWeek));
            ps.setDate(3, Date.valueOf(startOfWeek.plusDays(6)));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TimeSlot ts = new TimeSlot();
                ts.setTimeSlotID(rs.getInt("timeSlotID"));
                ts.setFieldID(rs.getInt("fieldID"));
                ts.setDate(rs.getDate("date").toLocalDate());
                ts.setStartTime(rs.getTime("startTime").toLocalTime());
                ts.setEndTime(rs.getTime("endTime").toLocalTime());
                ts.setPrice(rs.getDouble("price"));
                ts.setFieldName(rs.getString("fieldName"));
                ts.setActive(rs.getBoolean("isActive"));

                String bookingStatus = rs.getString("bookingStatus");
                Timestamp createdAt = rs.getTimestamp("bookingCreatedAt");

                if (bookingStatus != null && createdAt != null) {
                    ts.setBooked(true);
                    ts.setBookingStatus(bookingStatus);
                    ts.setBookingCreatedAt(createdAt.toLocalDateTime());
                } else {
                    ts.setBooked(false);
                }

                list.add(ts);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<TimeSlot> getTimeSlotsByStadiumAndWeekForFieldOwner(int stadiumId, LocalDate startOfWeek) {
        List<TimeSlot> list = new ArrayList<>();

        String sql =
            "SELECT ts.*, f.fieldName, " +
            "       b.Status AS bookingStatus, b.CreatedAt AS bookingCreatedAt " +
            "FROM TimeSlot ts " +
            "JOIN Field f ON ts.fieldID = f.fieldID " +
            "LEFT JOIN BookingTimeSlot bts ON ts.TimeSlotID = bts.TimeSlotID " +
            "LEFT JOIN Booking b ON bts.BookingID = b.BookingID " +
            "WHERE f.stadiumID = ? AND ts.date BETWEEN ? AND ? " +
            "ORDER BY ts.date, ts.startTime";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stadiumId);
            ps.setDate(2, Date.valueOf(startOfWeek));
            ps.setDate(3, Date.valueOf(startOfWeek.plusDays(6)));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TimeSlot ts = new TimeSlot();
                ts.setTimeSlotID(rs.getInt("timeSlotID"));
                ts.setFieldID(rs.getInt("fieldID"));
                ts.setDate(rs.getDate("date").toLocalDate());
                ts.setStartTime(rs.getTime("startTime").toLocalTime());
                ts.setEndTime(rs.getTime("endTime").toLocalTime());
                ts.setPrice(rs.getDouble("price"));
                ts.setFieldName(rs.getString("fieldName"));
                ts.setActive(rs.getBoolean("isActive"));

                String bookingStatus = rs.getString("bookingStatus");
                Timestamp createdAt = rs.getTimestamp("bookingCreatedAt");

                if (bookingStatus != null && createdAt != null) {
                    ts.setBooked(true);
                    ts.setBookingStatus(bookingStatus);
                    ts.setBookingCreatedAt(createdAt.toLocalDateTime());
                } else {
                    ts.setBooked(false);
                }

                list.add(ts);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ Hàm tiện ích: Lấy giá theo TimeSlotID
    public double getPriceByTimeSlotId(int timeSlotId) {
        String sql = "SELECT price FROM TimeSlot WHERE timeSlotID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, timeSlotId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("price");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    public boolean updateTimeSlotStatus(int timeSlotID, boolean isActive) {
        String sql = "UPDATE TimeSlot SET isActive = ? WHERE TimeSlotID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isActive);
            ps.setInt(2, timeSlotID);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

     public int getBookingIdByTimeSlotId(int timeSlotId) {
        String sql = "SELECT BookingID FROM BookingTimeSlot WHERE TimeSlotID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, timeSlotId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("BookingID");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
     
     // Hàm phụ trợ để lấy TimeSlot theo ID
    public TimeSlot getTimeSlotById(int timeSlotId) {
        String sql = "SELECT * FROM TimeSlot WHERE TimeSlotID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, timeSlotId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TimeSlot ts = new TimeSlot();
                ts.setTimeSlotID(rs.getInt("TimeSlotID"));
                ts.setFieldID(rs.getInt("FieldID"));

                // Chuyển đổi Date
                java.sql.Date sqlDate = rs.getDate("Date");
                LocalDate date = sqlDate.toLocalDate();
                ts.setDate(date);

                // Chuyển đổi StartTime và EndTime
                java.sql.Time sqlStartTime = rs.getTime("StartTime");
                LocalTime startTime = sqlStartTime.toLocalTime();
                ts.setStartTime(startTime);

                java.sql.Time sqlEndTime = rs.getTime("EndTime");
                LocalTime endTime = sqlEndTime.toLocalTime();
                ts.setEndTime(endTime);

                // Đọc Price
                double price = rs.getDouble("Price");
                logger.info("Giá vé từ ResultSet: " + price);
                ts.setPrice(price);

                // Đọc isActive
                boolean isActive = rs.getBoolean("isActive");
                ts.setActive(isActive);

                return ts;
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy TimeSlot: " + e.getMessage());
        }
        return null;
    }

    // Hàm đặt thủ công
    public boolean bookTimeSlotManually(int timeSlotId) {
        String insertBooking = "INSERT INTO Booking (UserID, Status, OriginalAmount, TotalAmount) VALUES (1, 'Confirmed', 0, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertBooking, Statement.RETURN_GENERATED_KEYS)) {
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int bookingId = rs.getInt(1);
                String insertBookingTimeSlot = "INSERT INTO BookingTimeSlot (BookingID, TimeSlotID) VALUES (?, ?)";
                try (PreparedStatement ps2 = conn.prepareStatement(insertBookingTimeSlot)) {
                    ps2.setInt(1, bookingId);
                    ps2.setInt(2, timeSlotId);
                    return ps2.executeUpdate() > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return false;
    }
    
    private boolean isBooked(int timeSlotID) {
        String sql = "SELECT COUNT(*) FROM BookingTimeSlot WHERE TimeSlotID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, timeSlotID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Map<Integer, List<TimeSlot>> groupByFieldID(List<TimeSlot> list) {
        Map<Integer, List<TimeSlot>> result = new HashMap<>();
        for (TimeSlot ts : list) {
            result.computeIfAbsent(ts.getFieldID(), k -> new ArrayList<>()).add(ts);
        }
        return result;
    }
    
}
