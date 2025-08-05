package dao;

import connect.DBConnection;
import model.OwnerTeam;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeamsDAO {

    // Create
    public boolean addTeam(OwnerTeam team) {
        String sql = "INSERT INTO Teams (OwnerUserID, TeamName, Description) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, team.getOwnerUserID());
            ps.setString(2, team.getTeamName());
            ps.setString(3, team.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Read all
    public List<OwnerTeam> getAllTeams() {
        List<OwnerTeam> list = new ArrayList<>();
        String sql = "SELECT * FROM Teams";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OwnerTeam team = new OwnerTeam();
                team.setId(rs.getInt("ID"));
                team.setOwnerUserID(rs.getInt("OwnerUserID"));
                team.setTeamName(rs.getString("TeamName"));
                team.setDescription(rs.getString("Description"));
                list.add(team);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Read by ID
    public OwnerTeam getTeamById(int id) {
        String sql = "SELECT * FROM Teams WHERE ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OwnerTeam team = new OwnerTeam();
                    team.setId(rs.getInt("ID"));
                    team.setOwnerUserID(rs.getInt("OwnerUserID"));
                    team.setTeamName(rs.getString("TeamName"));
                    team.setDescription(rs.getString("Description"));
                    return team;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public OwnerTeam getTeamByOwnerUserId(int ownerUserID) {
        String sql = "SELECT * FROM Teams WHERE OwnerUserID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerUserID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OwnerTeam team = new OwnerTeam();
                    team.setId(rs.getInt("ID"));
                    team.setOwnerUserID(rs.getInt("OwnerUserID"));
                    team.setTeamName(rs.getString("TeamName"));
                    team.setDescription(rs.getString("Description"));
                    return team;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update
    public boolean updateTeam(OwnerTeam team) {
        String sql = "UPDATE Teams SET OwnerUserID=?, TeamName=?, Description=? WHERE ID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, team.getOwnerUserID());
            ps.setString(2, team.getTeamName());
            ps.setString(3, team.getDescription());
            ps.setInt(4, team.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete
    public boolean deleteTeam(int id) {
        String sql = "DELETE FROM Teams WHERE ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}