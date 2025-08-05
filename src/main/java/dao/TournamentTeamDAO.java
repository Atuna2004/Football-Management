
package dao;

import connect.DBConnection;
import model.TournamentTeam;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TournamentTeamDAO {

    // Create
    public boolean addTournamentTeam(TournamentTeam team) {
        String sql = "INSERT INTO TournamentTeam (TournamentID, TeamName, CaptainName, ContactPhone, Status, IsApproved) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, team.getTournamentID());
            ps.setString(2, team.getTeamName());
            ps.setString(3, team.getCaptainName());
            ps.setString(4, team.getContactPhone());
            ps.setBoolean(5, team.isStatus());
            ps.setBoolean(6, team.isIsApproved());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Read all
    public List<TournamentTeam> getAllTournamentTeams() {
        List<TournamentTeam> list = new ArrayList<>();
        String sql = "SELECT * FROM TournamentTeam";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TournamentTeam team = new TournamentTeam();
                team.setTeamID(rs.getInt("TeamID"));
                team.setTournamentID(rs.getInt("TournamentID"));
                team.setTeamName(rs.getString("TeamName"));
                team.setCaptainName(rs.getString("CaptainName"));
                team.setContactPhone(rs.getString("ContactPhone"));
                team.setStatus(rs.getBoolean("Status"));
                team.setIsApproved(rs.getBoolean("IsApproved"));
                list.add(team);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<TournamentTeam> getTeamsByTournamentId(int tournamentId) {
        List<TournamentTeam> list = new ArrayList<>();
        String sql = "SELECT * FROM TournamentTeam WHERE TournamentID = ?";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tournamentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TournamentTeam tt = new TournamentTeam();
                tt.setTeamID(rs.getInt("TeamID"));
                tt.setTournamentID(rs.getInt("TournamentID"));
                tt.setTeamName(rs.getString("TeamName"));
                tt.setCaptainName(rs.getString("CaptainName"));
                tt.setContactPhone(rs.getString("ContactPhone"));
                tt.setStatus(rs.getBoolean("Status"));
                tt.setIsApproved(rs.getBoolean("IsApproved"));
                list.add(tt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
}

    // Read by ID
    public TournamentTeam getTournamentTeamById(int teamID) {
        String sql = "SELECT * FROM TournamentTeam WHERE TeamID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TournamentTeam team = new TournamentTeam();
                    team.setTeamID(rs.getInt("TeamID"));
                    team.setTournamentID(rs.getInt("TournamentID"));
                    team.setTeamName(rs.getString("TeamName"));
                    team.setCaptainName(rs.getString("CaptainName"));
                    team.setContactPhone(rs.getString("ContactPhone"));
                    team.setStatus(rs.getBoolean("Status"));
                    team.setIsApproved(rs.getBoolean("IsApproved"));
                    return team;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update
    public boolean updateTournamentTeam(TournamentTeam team) {
        String sql = "UPDATE TournamentTeam SET TournamentID=?, TeamName=?, CaptainName=?, ContactPhone=?, Status=?, IsApproved=? WHERE TeamID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, team.getTournamentID());
            ps.setString(2, team.getTeamName());
            ps.setString(3, team.getCaptainName());
            ps.setString(4, team.getContactPhone());
            ps.setBoolean(5, team.isStatus());
            ps.setBoolean(6, team.isIsApproved());
            ps.setInt(7, team.getTeamID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean cancelUnapprovedRegistration(String teamName, int tournamentId) {
        String sql = "UPDATE TournamentTeam SET Status = 0 WHERE TeamName = ? AND TournamentID = ? AND IsApproved = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teamName);
            ps.setInt(2, tournamentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean approveTeam(String teamName, int tournamentId) {
        String sql = "UPDATE TournamentTeam SET IsApproved = 1 WHERE TeamName = ? AND TournamentID = ?";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teamName);
            ps.setInt(2, tournamentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete
    public boolean deleteTournamentTeam(int teamID) {
        String sql = "DELETE FROM TournamentTeam WHERE TeamID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
