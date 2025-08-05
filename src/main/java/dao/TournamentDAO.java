package dao;

import connect.DBConnection;      // lớp bạn đã có
import model.Tournament;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TournamentDAO {
    public List<Tournament> getAll() {
        List<Tournament> list = new ArrayList<>();
        String sql = "SELECT "
                + "Tournament.TournamentID, "
                + "Tournament.Name, "
                + "Tournament.Description, "
                + "Tournament.StartDate, "
                + "Tournament.EndDate, "
                + "Tournament.CreatedBy, "
                + "Tournament.CreatedAt, "
                + "Tournament.StadiumID, "
                + "Tournament.ImageUrl, "
                + "Tournament.TotalTeams, "
                + "Tournament.Award, "
                + "Tournament.QuantityTeams, "
                + "Stadium.Name AS StadiumName "
                + "FROM Tournament "
                + "JOIN Stadium ON Tournament.StadiumID = Stadium.StadiumID "
                + "ORDER BY Tournament.TournamentID DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Tournament t = new Tournament();
                t.setTournamentID(rs.getInt("TournamentID"));
                t.setName(rs.getString("Name"));
                t.setDescription(rs.getString("Description"));
                t.setStartDate(rs.getDate("StartDate"));
                t.setEndDate(rs.getDate("EndDate"));
                t.setCreatedBy(rs.getInt("CreatedBy"));
                t.setCreatedAt(rs.getTimestamp("CreatedAt"));
                t.setStadiumID(rs.getInt("StadiumID"));
                t.setImageUrl(rs.getString("ImageUrl"));
                t.setTotalTeams(rs.getInt("TotalTeams"));
                t.setAward(rs.getDouble("Award"));
                t.setQuantityTeams(rs.getInt("QuantityTeams"));
                // Thêm tên sân vào đối tượng Tournament
                t.setStadiumName(rs.getString("StadiumName"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Tournament> getTournamentsByOwner(int ownerId) {
        List<Tournament> list = new ArrayList<>();

        String sql
                = "SELECT "
                + "    t.TournamentID, t.TournamentName, FI.Description, "
                + "    u.FullName AS  CreatedBy, "
                + "    t.StartDate, t.EndDate, "
                + "    S.StadiumID, S.Name AS StadiumName "
                + "FROM FoodItem FI "
                + "JOIN Stadium S ON FI.StadiumID = S.StadiumID "
                + "WHERE S.OwnerID = ? "
                + "ORDER BY S.StadiumID, FI.Name";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Tournament t = new Tournament();
                t.setTournamentID(rs.getInt("TournamentID"));
                t.setStadiumID(rs.getInt("StadiumID"));
                t.setName(rs.getString("Name"));
                t.setDescription(rs.getString("Description"));
                t.setStartDate(rs.getDate("StartDate"));
                t.setEndDate(rs.getDate("EndDate"));
                t.setCreatedBy(rs.getInt("CreatedBy"));
                t.setCreatedAt(rs.getDate("CreatedAt"));
                list.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    
    public List<Tournament> getTournamentByStadium(int stadiumId) {
        List<Tournament> list = new ArrayList<>();
        String sql = "SELECT * FROM Tournament WHERE StadiumID = ? AND IsActive = 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stadiumId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Tournament tour = new Tournament();
                tour.setTournamentID(rs.getInt("TournamentID"));
                tour.setName(rs.getString("Name"));
                tour.setDescription(rs.getString("Description"));
                tour.setStartDate(rs.getDate("StartDate"));
                tour.setEndDate(rs.getDate("EndDate"));
                tour.setCreatedBy(rs.getInt("CreatedBy"));
                tour.setCreatedAt(rs.getDate("CreatedAt"));
               
                list.add(tour);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<Tournament> getTournamentByOwner(int ownerId) {
        List<Tournament> list = new ArrayList<>();

        String sql
                = "SELECT "
                + "    FI.TournamentID, FI.Name AS TournamentName, FI.Description, "
                + "    FI.StartDate, FI.EndDate, FI.CreatedBy, FI.CreatedAt, "
                + "    S.StadiumID, S.Name AS StadiumName "
                + "FROM Tournament FI "
                + "JOIN Stadium S ON FI.StadiumID = S.StadiumID "
                + "WHERE S.OwnerID = ? "
                + "ORDER BY S.StadiumID, FI.Name";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Tournament tour = new Tournament();
                tour.setTournamentID(rs.getInt("TournamentID"));
                tour.setName(rs.getString("TournamentName"));
                tour.setDescription(rs.getString("Description"));
                tour.setStartDate(rs.getDate("StartDate"));
                tour.setEndDate(rs.getDate("EndDate"));
                tour.setCreatedBy(rs.getInt("CreatedBy"));
                tour.setCreatedAt(rs.getDate("CreatedAt"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public int addTournament(Tournament t) {
        final String sql = "INSERT INTO Tournament (StadiumID, Name, Description, StartDate, EndDate, CreatedBy, CreatedAt, ImageUrl, TotalTeams, Award, QuantityTeams) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) { // Thêm PreparedStatement.RETURN_GENERATED_KEYS
            ps.setInt(1, t.getStadiumID());
            ps.setString(2, t.getName());
            ps.setString(3, t.getDescription());
            ps.setDate(4, new java.sql.Date(t.getStartDate().getTime()));
            ps.setDate(5, new java.sql.Date(t.getEndDate().getTime()));
            ps.setInt(6, t.getCreatedBy());
            ps.setString(7, t.getImageUrl());
            ps.setInt(8, t.getTotalTeams());
            ps.setDouble(9, t.getAward());
            ps.setInt(10, t.getQuantityTeams());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // Trả về TournamentID vừa生成
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
        return -1; // Nếu không có kết quả
    }

    public Tournament getById(int id) {
        String sql = "SELECT * FROM Tournament WHERE TournamentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Tournament t = new Tournament();
                t.setTournamentID(rs.getInt("TournamentID"));
                t.setStadiumID(rs.getInt("StadiumID"));
                t.setName(rs.getString("Name"));
                t.setDescription(rs.getString("Description"));
                t.setStartDate(rs.getDate("StartDate"));
                t.setEndDate(rs.getDate("EndDate"));
                t.setCreatedBy(rs.getInt("CreatedBy"));
                t.setCreatedAt(rs.getTimestamp("CreatedAt"));
                t.setImageUrl(rs.getString("ImageUrl"));
                t.setTotalTeams(rs.getInt("TotalTeams"));
                t.setAward(rs.getDouble("Award"));
                t.setQuantityTeams(rs.getInt("QuantityTeams"));
                return t;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTournament(Tournament t) {
        String sql = "UPDATE Tournament SET StadiumID=?, Name=?, Description=?, StartDate=?, EndDate=?, ImageUrl=?, TotalTeams=?, Award=?, QuantityTeams=? WHERE TournamentID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getStadiumID());
            ps.setString(2, t.getName());
            ps.setString(3, t.getDescription());
            ps.setDate(4, new java.sql.Date(t.getStartDate().getTime()));
            ps.setDate(5, new java.sql.Date(t.getEndDate().getTime()));
            ps.setString(6, t.getImageUrl());
            ps.setInt(7, t.getTotalTeams());
            ps.setDouble(8, t.getAward());
            ps.setInt(9, t.getQuantityTeams());
            ps.setInt(10, t.getTournamentID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean hardDeleteTournament(int tournamentId) {
        final String sql = "DELETE FROM Tournament WHERE TournamentID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tournamentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
//    public List<Tournament> searchTournamentByName(String keyword, int ownerId) {
//        List<Tournament> list = new ArrayList<>();
//
//        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
//
//        StringBuilder sql = new StringBuilder();
//        sql.append("SELECT t.TournamentID, t.StadiumID, t.Name, t.Description, ")
//                .append("t.StartDate, t.EndDate, t.CreatedBy, t.CreatedAt, ")
//                .append("s.Name AS StadiumName ")
//                .append("FROM Tournament t ")
//                .append("JOIN Stadium s ON t.StadiumID = s.StadiumID ") 
//                .append("WHERE s.OwnerID = ? ");
//
//        if (hasKeyword) {
//            sql.append("AND t.Name COLLATE Latin1_General_CI_AI LIKE ? ");
//        }
//
//        sql.append("ORDER BY t.Name");
//
//        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
//
//            ps.setInt(1, ownerId);
//
//            if (hasKeyword) {
//                ps.setString(2, "%" + keyword.trim() + "%");
//            }
//
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    
//                    // mapFoodItem có StadiumName 
//                    list.add(mapTournament(rs, true));// đổi từ false ➜ true
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
    
    public List<Tournament> searchTournamentsByName(String keyword, int ownerId) {
        List<Tournament> list = new ArrayList<>();

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT t.TournamentID, t.StadiumID, t.Name, t.Description, ")
                .append("t.StartDate, t.EndDate, t.CreatedBy, t.CreatedAt, ")
                .append("t.ImageUrl, t.TotalTeams, t.Award, t.QuantityTeams, ")
                .append("s.Name AS StadiumName ")
                .append("FROM Tournament t ")
                .append("JOIN Stadium s ON t.StadiumID = s.StadiumID ") 
                .append("WHERE t.CreatedBy = ? ");

        if (hasKeyword) {
            sql.append("AND t.Name COLLATE Latin1_General_CI_AI LIKE ? ");
        }

        sql.append("ORDER BY t.CreatedAt DESC");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, ownerId);

            if (hasKeyword) {
                ps.setString(2, "%" + keyword.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    
                    // mapFoodItem có StadiumName 
                    list.add(mapTournament(rs, true));// đổi từ false ➜ true
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    private Tournament mapTournament(ResultSet rs, boolean includeStadium) throws SQLException {
        Tournament t = new Tournament();
        t.setTournamentID(rs.getInt("TournamentID"));
        t.setStadiumID(rs.getInt("StadiumID"));
        t.setName(rs.getString("Name"));
        t.setDescription(rs.getString("Description"));
        t.setStartDate(rs.getDate("StartDate"));
        t.setEndDate(rs.getDate("EndDate"));
        t.setCreatedBy(rs.getInt("CreatedBy"));
        Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
        t.setCreatedAt(rs.getDate("CreatedAt"));
        t.setImageUrl(rs.getString("ImageUrl"));
        t.setTotalTeams(rs.getInt("TotalTeams"));
        t.setAward(rs.getDouble("Award"));
        t.setQuantityTeams(rs.getInt("QuantityTeams"));
        if (includeStadium) {
            t.setStadiumName(rs.getString("StadiumName"));
        }
        return t;
    }
    
    
}
