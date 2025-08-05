
package model;

public class OwnerTeam {
    private int id;
    private int ownerUserID;
    private String teamName;
    private String description;

    public OwnerTeam() {
    }

    public OwnerTeam(int id, int ownerUserID, String teamName, String description) {
        this.id = id;
        this.ownerUserID = ownerUserID;
        this.teamName = teamName;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOwnerUserID() {
        return ownerUserID;
    }

    public void setOwnerUserID(int ownerUserID) {
        this.ownerUserID = ownerUserID;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
