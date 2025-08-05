
package dao;

import connect.DBConnection;
import model.OwnerTeamMember;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeamsMemberDAO {

    // Create
    public boolean addMember(OwnerTeamMember member) {
        String sql = "INSERT INTO TeamsMember (TeamsID, UserName, UserPhone) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, member.getOwnerTeamID());
            ps.setString(2, member.getUserName());
            ps.setString(3, member.getUserPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Read all
    public List<OwnerTeamMember> getAllMembers() {
        List<OwnerTeamMember> list = new ArrayList<>();
        String sql = "SELECT * FROM TeamsMember";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OwnerTeamMember member = new OwnerTeamMember();
                member.setId(rs.getInt("ID"));
                member.setOwnerTeamID(rs.getInt("TeamsID"));
                member.setUserName(rs.getString("UserName"));
                member.setUserPhone(rs.getString("UserPhone"));
                list.add(member);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Read by ID
    public OwnerTeamMember getMemberById(int id) {
        String sql = "SELECT * FROM TeamsMember WHERE ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OwnerTeamMember member = new OwnerTeamMember();
                    member.setId(rs.getInt("ID"));
                    member.setOwnerTeamID(rs.getInt("TeamsID"));
                    member.setUserName(rs.getString("UserName"));
                    member.setUserPhone(rs.getString("UserPhone"));
                    return member;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OwnerTeamMember> getMembersByTeamId(int teamId) {
        List<OwnerTeamMember> list = new ArrayList<>();
        String sql = "SELECT * FROM TeamsMember WHERE TeamsID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teamId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OwnerTeamMember member = new OwnerTeamMember();
                    member.setId(rs.getInt("ID"));
                    member.setOwnerTeamID(rs.getInt("TeamsID"));
                    member.setUserName(rs.getString("UserName"));
                    member.setUserPhone(rs.getString("UserPhone"));
                    list.add(member);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update
    public boolean updateMember(OwnerTeamMember member) {
        String sql = "UPDATE TeamsMember SET TeamsID=?, UserName=?, UserPhone=? WHERE ID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, member.getOwnerTeamID());
            ps.setString(2, member.getUserName());
            ps.setString(3, member.getUserPhone());
            ps.setInt(4, member.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete
    public boolean deleteMember(int id) {
        String sql = "DELETE FROM TeamsMember WHERE ID = ?";
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
