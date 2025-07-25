package model;

import java.time.LocalDate;

public class Discount {
    private int discountCodeID;
    private String code;
    private int percentage;
    private LocalDate expiryDate;
    private int quantity;

    public int getDiscountCodeID() {
        return discountCodeID;
    }

    public void setDiscountCodeID(int discountCodeID) {
        this.discountCodeID = discountCodeID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getPercentage() {
        return percentage;
    }

    public void setPercentage(int percentage) {
        this.percentage = percentage;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
