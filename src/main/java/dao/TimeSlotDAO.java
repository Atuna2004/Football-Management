package dao;

import connect.DBConnection;
import model.TimeSlot;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class TimeSlotDAO {

    public List<TimeSlot> getTimeSlotsByStadiumAndWeek(int stadiumId, LocalDate startOfWeek) {
        List<TimeSlot> list = new ArrayList<>();

        String sql =
            "SELECT ts.*, f.fieldName " +
            "FROM TimeSlot ts " +
            "JOIN Field f ON ts.fieldID = f.fieldID " +
            "WHERE f.stadiumID = ? " +
            "AND ts.date BETWEEN ? AND ? " +
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
                ts.setFieldName(rs.getString("fieldName")); // ✅

                list.add(ts);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
