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
    private String imageURL; // New field for stadium image
    
    // Default constructor
    public Stadium() {
    }
    
    // Original constructor (keeping for backward compatibility)
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
    
    // New constructor with image field
    public Stadium(int stadiumID, String name, String location, String description, String status, Date createdAt, String phoneNumber, int OwnerID, String imageURL) {
        this.stadiumID = stadiumID;
        this.name = name;
        this.location = location;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.phoneNumber = phoneNumber;
        this.OwnerID = OwnerID;
        this.imageURL = imageURL;
    }
    
    // All existing getters and setters remain unchanged
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
    
    // New getter and setter for image URL
    public String getImageURL() {
        return imageURL;
    }
    
    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }
}