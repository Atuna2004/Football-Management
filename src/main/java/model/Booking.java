package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class Booking {
    private int bookingID;
    private int userID;
    private Integer discountCodeID;
    private String status;
    private LocalDateTime createdAt;
    private double originalAmount;
    private double foodAmount;
    private double totalAmount;
    private String stadiumName;
    private String timeSlot;
    private String userEmail;


    public Booking() {
        this.status = "Pending"; // ✅ Mặc định khi khởi tạo
    }

    public Booking(int bookingID, int userID, Integer discountCodeID, String status,
                   LocalDateTime createdAt, double originalAmount, double foodAmount, double totalAmount) {
        this.bookingID = bookingID;
        this.userID = userID;
        this.discountCodeID = discountCodeID;
        this.status = status;
        this.createdAt = createdAt;
        this.originalAmount = originalAmount;
        this.foodAmount = foodAmount;
        this.totalAmount = totalAmount;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Integer getDiscountCodeID() {
        return discountCodeID;
    }

    public void setDiscountCodeID(Integer discountCodeID) {
        this.discountCodeID = discountCodeID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public double getOriginalAmount() {
        return originalAmount;
    }

    public void setOriginalAmount(double originalAmount) {
        this.originalAmount = originalAmount;
    }

    public double getFoodAmount() {
        return foodAmount;
    }

    public void setFoodAmount(double foodAmount) {
        this.foodAmount = foodAmount;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getPrice() {
        return totalAmount;
    }

    public void setPrice(double price) {
        this.totalAmount = price;
    }

    public String getStadiumName() {
        return stadiumName;
    }

    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public Date getCreatedAtDate() {
        return java.sql.Timestamp.valueOf(createdAt);
    }

    public String getFormattedCreatedAt() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return createdAt.format(formatter);
    }

    public String getFormattedTotalAmount() {
        return String.format("%,.0f", totalAmount);
    }

    // ✅ Kiểm tra trạng thái
    public boolean isPending() {
        return "Pending".equalsIgnoreCase(status);
    }

    public boolean isConfirmed() {
        return "Confirmed".equalsIgnoreCase(status);
    }

    public boolean isCancelled() {
        return "Cancelled".equalsIgnoreCase(status);
    }

    // ✅ Kiểm tra quá 15 phút chưa thanh toán
    public boolean isExpired() {
        return isPending() && createdAt.plusMinutes(15).isBefore(LocalDateTime.now());
    }
    
    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
}
