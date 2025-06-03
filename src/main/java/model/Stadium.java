package model;

import java.util.Date;

public class Stadium {

    private int stadiumID;
    private String name;
    private String location;
    private String description;
    private String type;
    private String status;
    private Date createdAt;
    private String phoneNumber;

    public Stadium() {
    }


    public Stadium(int stadiumID, String name, String location, String description, String type, String status, Date createdAt, String phoneNumber) {
        this.stadiumID = stadiumID;
        this.name = name;
        this.location = location;
        this.description = description;
        this.type = type;
        this.status = status;
        this.createdAt = createdAt;
        this.phoneNumber = phoneNumber;
    }

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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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
}
