package model;

import java.time.LocalDateTime;

public class Booking {
    private int bookingID;
    private int userID;
    private Integer discountCodeID; // Có thể null
    private String status;
    private LocalDateTime createdAt;
    private double originalAmount;
    private double totalAmount;

    public Booking() {
    }

    public Booking(int bookingID, int userID, Integer discountCodeID, String status,
                   LocalDateTime createdAt, double originalAmount, double totalAmount) {
        this.bookingID = bookingID;
        this.userID = userID;
        this.discountCodeID = discountCodeID;
        this.status = status;
        this.createdAt = createdAt;
        this.originalAmount = originalAmount;
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

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    // Nếu cần dùng lại getter setPrice/setPrice thì bạn có thể tạo alias như sau:
    public double getPrice() {
        return totalAmount;
    }

    public void setPrice(double price) {
        this.totalAmount = price;
    }
}
