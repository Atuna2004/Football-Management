package model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

public class TimeSlot {
    private int timeSlotID;
    private int stadiumID;
    private int fieldID;
    private String fieldName;
    private LocalDate date;
    private LocalTime startTime;
    private LocalTime endTime;
    private double price;
    private boolean booked;

    // 🔥 THÊM:
    private String bookingStatus;           // "Pending", "Confirmed", v.v.
    private LocalDateTime bookingCreatedAt; // Dùng để kiểm tra giữ chỗ có quá hạn không

    public TimeSlot() {}

    public TimeSlot(int timeSlotID, int stadiumID, int fieldID, String fieldName,
                    LocalDate date, LocalTime startTime, LocalTime endTime, double price) {
        this.timeSlotID = timeSlotID;
        this.stadiumID = stadiumID;
        this.fieldID = fieldID;
        this.fieldName = fieldName;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.price = price;
    }

    // =================== Getter & Setter =====================

    public int getTimeSlotID() {
        return timeSlotID;
    }

    public void setTimeSlotID(int timeSlotID) {
        this.timeSlotID = timeSlotID;
    }

    public int getStadiumID() {
        return stadiumID;
    }

    public void setStadiumID(int stadiumID) {
        this.stadiumID = stadiumID;
    }

    public int getFieldID() {
        return fieldID;
    }

    public void setFieldID(int fieldID) {
        this.fieldID = fieldID;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public boolean isBooked() {
        return booked;
    }

    public void setBooked(boolean booked) {
        this.booked = booked;
    }

    // =================== THÊM MỚI =====================

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public LocalDateTime getBookingCreatedAt() {
        return bookingCreatedAt;
    }

    public void setBookingCreatedAt(LocalDateTime bookingCreatedAt) {
        this.bookingCreatedAt = bookingCreatedAt;
    }

    // =================== Logic kiểm tra đã đặt thực sự =====================

    /**
     * Trả về true nếu slot này thực sự đã được đặt (Confirmed) hoặc đang giữ chỗ nhưng chưa hết hạn (Pending < 15 phút).
     */
    public boolean isTrulyBooked() {
        if (!booked) return false;
        if ("Confirmed".equalsIgnoreCase(bookingStatus)) return true;

        // Nếu là giữ chỗ (Pending) nhưng quá 15 phút → không tính là đã đặt
        if ("Pending".equalsIgnoreCase(bookingStatus) && bookingCreatedAt != null) {
            LocalDateTime now = LocalDateTime.now();
            return bookingCreatedAt.plusMinutes(5).isAfter(now);
        }

        return false;
    }
}
