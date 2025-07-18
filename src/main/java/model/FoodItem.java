package model;

public class FoodItem {
    private int foodItemID;
    private String name;
    private String description;
    private double price;
    private int stockQuantity;
    private boolean isActive;
    private String imageUrl;

    private int stadiumID;       // dùng khi thêm/sửa
    private String stadiumName;  // dùng khi hiển thị

    public FoodItem() {
    }

    public FoodItem(int foodItemID, int stadiumID, String name, String description, double price, int stockQuantity, boolean isActive) {
        this.foodItemID = foodItemID;
        this.stadiumID = stadiumID;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.isActive = isActive;
    }
    // ======= Getter/Setter =======

    public int getFoodItemID() {
        return foodItemID;
    }

    public void setFoodItemID(int foodItemID) {
        this.foodItemID = foodItemID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getStadiumID() {
        return stadiumID;
    }

    public void setStadiumID(int stadiumID) {
        this.stadiumID = stadiumID;
    }

    public String getStadiumName() {
        return stadiumName;
    }

    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }
}

