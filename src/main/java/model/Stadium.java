package model;

import java.util.Date;

public class Stadium {
    private int stadiumID;
    private String name;
    private String location;
    private String description;
    private String status;
    private Date createdAt;
    private String phoneNumber;
    private int OwnerID;
    private String imageURL; // Field for stadium image (from UI1.3)
    private Double latitude;   // Field for latitude (from main)
    private Double longitude;  // Field for longitude (from main)
    private Double distance;   // Field for distance (from main) - typically calculated, not stored directly

    // Default constructor
    public Stadium() {
    }

    // Constructor without imageURL, latitude, longitude, and distance
    public Stadium(int stadiumID, String name, String location, String description, String status, Date createdAt, String phoneNumber, int OwnerID) {
        this.stadiumID = stadiumID;
        this.name = name;
        this.location = location;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.phoneNumber = phoneNumber;
        this.OwnerID = OwnerID;
    }

    // Constructor with imageURL (from UI1.3)
    public Stadium(int stadiumID, String name, String location, String description, String status, Date createdAt, String phoneNumber, int OwnerID, String imageURL) {
        this(stadiumID, name, location, description, status, createdAt, phoneNumber, OwnerID); // Call existing constructor
        this.imageURL = imageURL;
    }

    // Constructor with latitude and longitude (useful for creating Stadium objects with geographical data)
    public Stadium(int stadiumID, String name, String location, String description, String status, Date createdAt, String phoneNumber, int OwnerID, Double latitude, Double longitude) {
        this(stadiumID, name, location, description, status, createdAt, phoneNumber, OwnerID); // Call existing constructor
        this.latitude = latitude;
        this.longitude = longitude;
    }
    
    // Full constructor including all fields (excluding calculated 'distance')
    public Stadium(int stadiumID, String name, String location, String description, String status, Date createdAt, String phoneNumber, int OwnerID, String imageURL, Double latitude, Double longitude) {
        this(stadiumID, name, location, description, status, createdAt, phoneNumber, OwnerID, imageURL); // Call constructor with imageURL
        this.latitude = latitude;
        this.longitude = longitude;
        // distance is typically calculated dynamically, not passed in constructor for storage
    }

    // --- Getters and Setters ---

    public int getStadiumID() {
        return stadiumID;
    }

    public void setStadiumID(int stadiumID) {
        this.stadiumID = stadiumID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public int getOwnerID() {
        return OwnerID;
    }

    public void setOwnerID(int OwnerID) {
        this.OwnerID = OwnerID;
    }

    // Getter and setter for imageURL (from UI1.3)
    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    // Getters and setters for latitude, longitude, and distance (from main)
    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }
}