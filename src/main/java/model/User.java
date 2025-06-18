package model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class User {

    private int userID;
    private String email;
    private String passwordHash;
    private String fullName;
    private String phone;
    private Date createdAt;
    private boolean isActive;
    private String googleID;
    private String avatarUrl;
    private Date dateOfBirth;
    private String address;

    private List<Role> roles = new ArrayList<>();

    public User() {
    }

    public User(int userID, String email, String passwordHash, String fullName, String phone,
            Date createdAt, boolean isActive, String googleID, String avatarUrl,
            Date dateOfBirth, String address, List<Role> roles) {
        this.userID = userID;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.phone = phone;
        this.createdAt = createdAt;
        this.isActive = isActive;
        this.googleID = googleID;
        this.avatarUrl = avatarUrl;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.roles = roles != null ? roles : new ArrayList<>();
    }

    public User(int userID, String email, String passwordHash, String fullName, String phone,
            Date createdAt, boolean isActive, String googleID, String avatarUrl,
            Date dateOfBirth, String address) {
        this.userID = userID;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.phone = phone;
        this.createdAt = createdAt;
        this.isActive = isActive;
        this.googleID = googleID;
        this.avatarUrl = avatarUrl;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
    }

    public List<Role> getRoles() {
        return roles;
    }

    public void setRoles(List<Role> roles) {
        this.roles = roles != null ? roles : new ArrayList<>();
    }

    public boolean isAdmin() {
        if (roles == null || roles.isEmpty()) {
            return false;
        }
        return roles.stream().anyMatch(r -> "admin".equalsIgnoreCase(r.getRoleName()));
    }

    public boolean isFieldOwner() {
        if (roles == null || roles.isEmpty()) {
            return false;
        }
        return roles.stream().anyMatch(r -> "field_owner".equalsIgnoreCase(r.getRoleName()));
    }

    public boolean isUser() {
        if (roles == null || roles.isEmpty()) {
            return false;
        }
        return roles.stream().anyMatch(r -> "user".equalsIgnoreCase(r.getRoleName()));
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getGoogleID() {
        return googleID;
    }

    public void setGoogleID(String googleID) {
        this.googleID = googleID;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
