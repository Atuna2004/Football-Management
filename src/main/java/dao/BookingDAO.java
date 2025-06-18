package dao;

import connect.DBConnection;
import model.Booking;

import java.sql.*;

public class BookingDAO {

    // Lấy thông tin booking theo ID
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM Booking WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setUserID(rs.getInt("UserID"));

                // Kiểm tra DiscountCodeID có thể null
                Object discountObj = rs.getObject("DiscountCodeID");
                if (discountObj != null) {
                    booking.setDiscountCodeID((Integer) discountObj);
                }

                booking.setStatus(rs.getString("Status"));
                booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                booking.setOriginalAmount(rs.getDouble("OriginalAmount"));
                booking.setTotalAmount(rs.getDouble("TotalAmount"));

                return booking;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Tạo một bản ghi Booking mới và trả về bookingId
    public int createBooking(int userId, double originalAmount, double totalAmount) {
        String sql = "INSERT INTO Booking (UserID, Status, OriginalAmount, TotalAmount) VALUES (?, 'Confirmed', ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setDouble(2, originalAmount);
            ps.setDouble(3, totalAmount);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // BookingID
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    // Gán TimeSlot vào Booking
    public void insertBookingTimeSlot(int bookingId, int timeSlotId) {
        String sql = "INSERT INTO BookingTimeSlot (BookingID, TimeSlotID) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ps.setInt(2, timeSlotId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
