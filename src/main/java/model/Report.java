package model;

import java.util.Date;

public class Report {

    private int reportID;
    private String type;
    private String description;
    private String reporterEmail;
    private Date reportedAt;
    private String status;

    public Report() {
    }

    public Report(int reportID, String type, String description, String reporterEmail, Date reportedAt, String status) {
        this.reportID = reportID;
        this.type = type;
        this.description = description;
        this.reporterEmail = reporterEmail;
        this.reportedAt = reportedAt;
        this.status = status;
    }

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getReporterEmail() {
        return reporterEmail;
    }

    public void setReporterEmail(String reporterEmail) {
        this.reporterEmail = reporterEmail;
    }

    public Date getReportedAt() {
        return reportedAt;
    }

    public void setReportedAt(Date reportedAt) {
        this.reportedAt = reportedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
