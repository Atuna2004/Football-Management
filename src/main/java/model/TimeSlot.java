package model;

import java.time.LocalDate;
import java.time.LocalTime;

public class TimeSlot {
    private int timeSlotID;
    private int stadiumID;
    private int fieldID;            // ✅ NEW
    private String fieldName;       // ✅ NEW
    private LocalDate date;
    private LocalTime startTime;
    private LocalTime endTime;
    private double price;

    public TimeSlot() {
    }

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
}
