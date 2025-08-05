
package model;

public class TournamentTeam {
    private int teamID;
    private int tournamentID;
    private String teamName;
    private String captainName;
    private String contactPhone;
    private boolean status;
    private boolean isApproved;

    public TournamentTeam() {
    }

    public TournamentTeam(int teamID, int tournamentID, String teamName, String captainName, String contactPhone, boolean status, boolean isApproved) {
        this.teamID = teamID;
        this.tournamentID = tournamentID;
        this.teamName = teamName;
        this.captainName = captainName;
        this.contactPhone = contactPhone;
        this.status = status;
        this.isApproved = isApproved;
    }

    public int getTeamID() {
        return teamID;
    }

    public void setTeamID(int teamID) {
        this.teamID = teamID;
    }

    public int getTournamentID() {
        return tournamentID;
    }

    public void setTournamentID(int tournamentID) {
        this.tournamentID = tournamentID;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getCaptainName() {
        return captainName;
    }

    public void setCaptainName(String captainName) {
        this.captainName = captainName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public boolean isIsApproved() {
        return isApproved;
    }

    public void setIsApproved(boolean isApproved) {
        this.isApproved = isApproved;
    }
    
}
