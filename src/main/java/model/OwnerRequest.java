package model;


import java.util.Date;

public class OwnerRequest {
    private int requestID;
    private int userID;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String message;
    private Date submittedDate;
    private String status;
    private String adminNote;
    private String businessLicense;



    public OwnerRequest() {}

    // Constructor đầy đủ
    public OwnerRequest(int requestID, int userID, String fullName, String email,
                        String phoneNumber, String message, Date submittedDate,
                        String status, String adminNote) {
        this.requestID = requestID;
        this.userID = userID;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.message = message;
        this.submittedDate = submittedDate;
        this.status = status;
        this.adminNote = adminNote;
    }

    // Getters & Setters
    public int getRequestID() { return requestID; }
    public void setRequestID(int requestID) { this.requestID = requestID; }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Date getSubmittedDate() { return submittedDate; }
    public void setSubmittedDate(Date submittedDate) { this.submittedDate = submittedDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminNote() { return adminNote; }
    public void setAdminNote(String adminNote) { this.adminNote = adminNote; }
    
    public String getBusinessLicense() {
    return businessLicense;
}

    public void setBusinessLicense(String businessLicense) {
        this.businessLicense = businessLicense;
    }
}