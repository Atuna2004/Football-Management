package model;
// RecentBooking.java


import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class RecentBooking {
    private int bookingID;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String stadiumName;
    private String fieldName;
    private String fieldType;
    private Date bookingDate;
    private Time startTime;
    private Time endTime;
    private double totalAmount;
    private String status;
    private Timestamp createdAt;
    
    // Constructors
    public RecentBooking() {}
    
    public RecentBooking(int bookingID, String customerName, String customerEmail, 
                        String customerPhone, String stadiumName, String fieldName, 
                        String fieldType, Date bookingDate, Time startTime, Time endTime, 
                        double totalAmount, String status, Timestamp createdAt) {
        this.bookingID = bookingID;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
        this.stadiumName = stadiumName;
        this.fieldName = fieldName;
        this.fieldType = fieldType;
        this.bookingDate = bookingDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.totalAmount = totalAmount;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getBookingID() {
        return bookingID;
    }
    
    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerEmail() {
        return customerEmail;
    }
    
    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public String getStadiumName() {
        return stadiumName;
    }
    
    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }
    
    public String getFieldName() {
        return fieldName;
    }
    
    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }
    
    public String getFieldType() {
        return fieldType;
    }
    
    public void setFieldType(String fieldType) {
        this.fieldType = fieldType;
    }
    
    public Date getBookingDate() {
        return bookingDate;
    }
    
    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }
    
    public Time getStartTime() {
        return startTime;
    }
    
    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }
    
    public Time getEndTime() {
        return endTime;
    }
    
    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "RecentBooking{" +
                "bookingID=" + bookingID +
                ", customerName='" + customerName + '\'' +
                ", customerEmail='" + customerEmail + '\'' +
                ", customerPhone='" + customerPhone + '\'' +
                ", stadiumName='" + stadiumName + '\'' +
                ", fieldName='" + fieldName + '\'' +
                ", fieldType='" + fieldType + '\'' +
                ", bookingDate=" + bookingDate +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}