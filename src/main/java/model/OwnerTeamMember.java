
package model;

public class OwnerTeamMember {
    private int id;
    private int ownerTeamID;
    private String userName;
    private String userPhone;

    public OwnerTeamMember() {
    }

    public OwnerTeamMember(int id, int ownerTeamID, String userName, String userPhone) {
        this.id = id;
        this.ownerTeamID = ownerTeamID;
        this.userName = userName;
        this.userPhone = userPhone;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOwnerTeamID() {
        return ownerTeamID;
    }

    public void setOwnerTeamID(int ownerTeamID) {
        this.ownerTeamID = ownerTeamID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }
    
}
