package model;

import java.util.Date;

public class Report {
    private int reportID;
    private int userID;
    private Integer relatedBookingID;
    private Integer relatedFoodOrderID;
    private Integer relatedStadiumID;
    private String title;
    private String description;
    private Date submittedAt;
    private String status;
    private String adminResponse;
    private Date respondedAt;
    
   
    private String userName;
    private String userEmail;
    private String type;
    private String priority;
    private String stadiumName; 
 
    public Report() {
    }
    
    public Report(int userID, Integer relatedStadiumID, String title, String description) {
        this.userID = userID;
        this.relatedStadiumID = relatedStadiumID;
        this.title = title;
        this.description = description;
        this.status = "Pending";
        this.submittedAt = new Date();
    }
    
    // Getters and Setters
    public int getReportID() {
        return reportID;
    }
    
    public void setReportID(int reportID) {
        this.reportID = reportID;
    }
    
    public int getUserID() {
        return userID;
    }
    
    public void setUserID(int userID) {
        this.userID = userID;
    }
    
    public Integer getRelatedBookingID() {
        return relatedBookingID;
    }
    
    public void setRelatedBookingID(Integer relatedBookingID) {
        this.relatedBookingID = relatedBookingID;
    }
    
    public Integer getRelatedFoodOrderID() {
        return relatedFoodOrderID;
    }
    
    public void setRelatedFoodOrderID(Integer relatedFoodOrderID) {
        this.relatedFoodOrderID = relatedFoodOrderID;
    }
    
    public Integer getRelatedStadiumID() {
        return relatedStadiumID;
    }
    
    public void setRelatedStadiumID(Integer relatedStadiumID) {
        this.relatedStadiumID = relatedStadiumID;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Date getSubmittedAt() {
        return submittedAt;
    }
    
    public void setSubmittedAt(Date submittedAt) {
        this.submittedAt = submittedAt;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getAdminResponse() {
        return adminResponse;
    }
    
    public void setAdminResponse(String adminResponse) {
        this.adminResponse = adminResponse;
    }
    
    public Date getRespondedAt() {
        return respondedAt;
    }
    
    public void setRespondedAt(Date respondedAt) {
        this.respondedAt = respondedAt;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public String getPriority() {
        return priority;
    }
    
    public void setPriority(String priority) {
        this.priority = priority;
    }

    // ✅ Added the missing getter and setter for stadiumName
    public String getStadiumName() {
        return stadiumName;
    }

    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }
    
    // ✅ Added utility methods
    @Override
    public String toString() {
        return "Report{" +
                "reportID=" + reportID +
                ", userID=" + userID +
                ", relatedStadiumID=" + relatedStadiumID +
                ", title='" + title + '\'' +
                ", status='" + status + '\'' +
                ", submittedAt=" + submittedAt +
                ", stadiumName='" + stadiumName + '\'' + // Include in toString for debugging
                '}';
    }
}
