package model;

import java.util.Date;

public class Tournament {

    private int tournamentID;
    private String name;
    private String description;
    private Date startDate;
    private Date endDate;
    private int createdBy;      // OwnerID
    private Date createdAt;
    
    private int stadiumID;
    private String stadiumName;

    private String imageUrl;
    private int totalTeams;
    private double award;
    private int quantityTeams;

    public Tournament() {
    }

    public Tournament(int tournamentID, int stadiumID, String name, String description, Date startDate, Date endDate, int createdBy, Date createdAt) {
        this.tournamentID = tournamentID;
        this.stadiumID = stadiumID;
        this.name = name;
        this.description = description;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }
    

    public int getTournamentID() {
        return tournamentID;
    }

    public void setTournamentID(int tournamentID) {
        this.tournamentID = tournamentID;
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

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getTotalTeams() {
        return totalTeams;
    }

    public void setTotalTeams(int totalTeams) {
        this.totalTeams = totalTeams;
    }

    public double getAward() {
        return award;
    }

    public void setAward(double award) {
        this.award = award;
    }

    public int getQuantityTeams() {
        return quantityTeams;
    }

    public void setQuantityTeams(int quantityTeams) {
        this.quantityTeams = quantityTeams;
    }

    

    
}
