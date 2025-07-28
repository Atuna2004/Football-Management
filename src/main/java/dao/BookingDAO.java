package dao;

import connect.DBConnection;
import model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT b.*, COALESCE(fo.TotalAmount, 0) AS FoodAmount " +
                     "FROM Booking b LEFT JOIN FoodOrder fo ON b.BookingID = fo.BookingID " +
                     "WHERE b.BookingID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setUserID(rs.getInt("UserID"));

                Object discountObj = rs.getObject("DiscountCodeID");
                if (discountObj != null) {
                    booking.setDiscountCodeID((Integer) discountObj);
                }

                booking.setStatus(rs.getString("Status"));
                booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                booking.setOriginalAmount(rs.getDouble("OriginalAmount"));
                booking.setFoodAmount(rs.getDouble("FoodAmount"));
                booking.setTotalAmount(booking.getOriginalAmount() + booking.getFoodAmount());

                return booking;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int createBooking(int userId, double originalAmount, double totalAmount) {
        String sql = "INSERT INTO Booking (UserID, Status, OriginalAmount, TotalAmount) " +
                     "VALUES (?, 'Pending', ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setDouble(2, originalAmount);
            ps.setDouble(3, totalAmount);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

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

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql =
            "SELECT b.*, " +
            "       COALESCE(fo.TotalAmount, 0) AS FoodAmount, " +
            "       COALESCE(p.Status, 'Pending') AS PaymentStatus " +
            "FROM Booking b " +
            "LEFT JOIN FoodOrder fo ON b.BookingID = fo.BookingID " +
            "LEFT JOIN Payment p ON b.BookingID = p.BookingID " +
            "WHERE b.UserID = ? " +
            "ORDER BY b.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setUserID(rs.getInt("UserID"));

                Object discountObj = rs.getObject("DiscountCodeID");
                if (discountObj != null) {
                    booking.setDiscountCodeID((Integer) discountObj);
                }

                booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                booking.setOriginalAmount(rs.getDouble("OriginalAmount"));
                booking.setFoodAmount(rs.getDouble("FoodAmount"));
                booking.setTotalAmount(booking.getOriginalAmount() + booking.getFoodAmount());
                booking.setStatus(rs.getString("PaymentStatus"));

                list.add(booking);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void deleteExpiredPendingBookings() {
        String deleteBookingTimeSlot =
            "DELETE FROM BookingTimeSlot " +
            "WHERE BookingID IN ( " +
            "    SELECT BookingID FROM Booking " +
            "    WHERE Status = 'Pending' AND DATEDIFF(MINUTE, CreatedAt, GETDATE()) > 5 " +
            ")";

        String deleteBooking =
            "DELETE FROM Booking " +
            "WHERE Status = 'Pending' AND DATEDIFF(MINUTE, CreatedAt, GETDATE()) > 5";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(deleteBookingTimeSlot);
                 PreparedStatement ps2 = conn.prepareStatement(deleteBooking)) {

                ps1.executeUpdate();
                ps2.executeUpdate();

                conn.commit();

            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Booking SET Status = ? WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Booking> getConfirmedBookings() {
        String sql = "SELECT * FROM Booking WHERE Status = 'Confirmed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            List<Booking> bookings = new ArrayList<>();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setUserID(rs.getInt("UserID"));

                Object discountObj = rs.getObject("DiscountCodeID");
                if (discountObj != null) {
                    booking.setDiscountCodeID((Integer) discountObj);
                }

                booking.setStatus(rs.getString("Status"));
                booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                booking.setOriginalAmount(rs.getDouble("OriginalAmount"));
                booking.setTotalAmount(rs.getDouble("TotalAmount"));

                bookings.add(booking);
            }

            return bookings;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Booking> getPendingBookings() {
        String sql = "SELECT * FROM Booking WHERE Status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            List<Booking> bookings = new ArrayList<>();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setUserID(rs.getInt("UserID"));

                Object discountObj = rs.getObject("DiscountCodeID");
                if (discountObj != null) {
                    booking.setDiscountCodeID((Integer) discountObj);
                }

                booking.setStatus(rs.getString("Status"));
                booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                booking.setOriginalAmount(rs.getDouble("OriginalAmount"));
                booking.setTotalAmount(rs.getDouble("TotalAmount"));

                bookings.add(booking);
            }

            return bookings;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean confirmBooking(int bookingId) {
        String sql = "UPDATE Booking SET Status = 'Completed' WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectBooking(int bookingId) {
        String sql = "UPDATE Booking SET Status = 'Rejected' WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean applyDiscountCode(int bookingId, int discountCodeId, double newTotal) {
        String sql = "UPDATE Booking SET DiscountCodeID = ?, TotalAmount = ? WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, discountCodeId);
            ps.setDouble(2, newTotal);
            ps.setInt(3, bookingId);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                try (PreparedStatement ps2 = conn.prepareStatement(
                        "UPDATE DiscountCode SET UsedCount = UsedCount + 1 WHERE DiscountCodeID = ?")) {
                    ps2.setInt(1, discountCodeId);
                    ps2.executeUpdate();
                }
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateCheckinToken(int bookingId, String token) {
        String sql = "UPDATE Booking SET CheckinToken = ? WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            ps.setInt(2, bookingId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Booking getBookingByCheckinToken(String token) {
        String sql = "SELECT * FROM Booking WHERE CheckinToken = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setUserID(rs.getInt("UserID"));

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

    public boolean hasUserBookedStadium(int userId, int stadiumId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Booking b " +
                     "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                     "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID " +
                     "WHERE b.UserID = ? AND ts.StadiumID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, stadiumId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
            }
        } catch (SQLException e) {
            throw e;
        }

        return false;
    }

    public boolean hasUserBookedStadiumConfirmed(int userId, int stadiumId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Booking b " +
                     "JOIN BookingTimeSlot bts ON b.BookingID = bts.BookingID " +
                     "JOIN TimeSlot ts ON bts.TimeSlotID = ts.TimeSlotID " +
                     "WHERE b.UserID = ? AND ts.StadiumID = ? AND b.Status = 'Confirmed'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, stadiumId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
            }
        } catch (SQLException e) {
            throw e;
        }

        return false;
    }
    
    public boolean updateTotalAmount(int bookingId, double newTotalAmount) {
        String sql = "UPDATE Booking SET TotalAmount = ? WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, newTotalAmount);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


}
