package model;

import java.util.Date;

public class Report {
    private int reportID;
    private int userID;
    private Integer relatedBookingID;       // Nullable
    private Integer relatedFoodOrderID;     // Nullable
    private String title;
    private String description;
    private Date submittedAt;
    private String status;
    private String adminResponse;
    private Date respondedAt;

    public Report() {}

    public Report(int reportID, int userID, Integer relatedBookingID, Integer relatedFoodOrderID, String title,
                  String description, Date submittedAt, String status, String adminResponse, Date respondedAt) {
        this.reportID = reportID;
        this.userID = userID;
        this.relatedBookingID = relatedBookingID;
        this.relatedFoodOrderID = relatedFoodOrderID;
        this.title = title;
        this.description = description;
        this.submittedAt = submittedAt;
        this.status = status;
        this.adminResponse = adminResponse;
        this.respondedAt = respondedAt;
    }

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
}
