package dao;

import connect.DBConnection;
import model.Comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    /**
     * Add a new comment to a stadium
     */
    public boolean addComment(Comment comment) {
        // FIXED SQL to include Rating and IsOwnerReply columns
        String sql = "INSERT INTO Comment (StadiumID, UserID, ParentCommentID, Content, Rating, IsActive, IsOwnerReply) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, comment.getStadiumID());
            ps.setInt(2, comment.getUserID());
            
            if (comment.getParentCommentID() != null) {
                ps.setInt(3, comment.getParentCommentID());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            
            ps.setString(4, comment.getContent());
            ps.setNull(5, Types.INTEGER); // Rating - set to NULL since we're not using it
            ps.setBoolean(6, comment.isActive());
            
            // Calculate IsOwnerReply
            boolean isOwnerReply = false;
            if (comment.getParentCommentID() != null) {
                // This is a reply, check if user is stadium owner
                isOwnerReply = isStadiumOwner(comment.getUserID(), comment.getStadiumID());
            }
            ps.setBoolean(7, isOwnerReply);
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                // Get the generated CommentID
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        comment.setCommentID(generatedKeys.getInt(1));
                    }
                }
                System.out.println("✅ Comment added successfully with ID: " + comment.getCommentID());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error adding comment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Add a reply to a comment (only stadium owner can reply)
     */
    public boolean addReply(Comment reply, int stadiumOwnerID) {
        // First validate that the user is the stadium owner
        if (!isStadiumOwner(stadiumOwnerID, reply.getStadiumID())) {
            System.err.println("❌ User " + stadiumOwnerID + " is not owner of stadium " + reply.getStadiumID());
            return false;
        }
        
        // Ensure this is marked as a reply
        if (reply.getParentCommentID() == null) {
            System.err.println("❌ Reply must have a parent comment ID");
            return false;
        }
        
        System.out.println("✅ Adding reply from stadium owner " + stadiumOwnerID);
        return addComment(reply);
    }

    /**
     * Get all comments for a stadium with user information
     * Returns only main comments (ParentCommentID is NULL)
     */
    public List<Comment> getCommentsByStadium(int stadiumID) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.FullName, u.AvatarUrl, s.Name as StadiumName " +
                    "FROM Comment c " +
                    "INNER JOIN [User] u ON c.UserID = u.UserID " +
                    "INNER JOIN Stadium s ON c.StadiumID = s.StadiumID " +
                    "WHERE c.StadiumID = ? AND c.ParentCommentID IS NULL AND c.IsActive = 1 " +
                    "ORDER BY c.CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, stadiumID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Comment comment = mapResultSetToComment(rs);
                comments.add(comment);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting comments by stadium: " + e.getMessage());
            e.printStackTrace();
        }
        return comments;
    }

    /**
     * Get all replies for a specific comment
     */
    public List<Comment> getRepliesByComment(int parentCommentID) {
        List<Comment> replies = new ArrayList<>();
        String sql = "SELECT c.*, u.FullName, u.AvatarUrl, s.Name as StadiumName " +
                    "FROM Comment c " +
                    "INNER JOIN [User] u ON c.UserID = u.UserID " +
                    "INNER JOIN Stadium s ON c.StadiumID = s.StadiumID " +
                    "WHERE c.ParentCommentID = ? AND c.IsActive = 1 " +
                    "ORDER BY c.CreatedAt ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, parentCommentID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                replies.add(mapResultSetToComment(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting replies: " + e.getMessage());
            e.printStackTrace();
        }
        return replies;
    }

    /**
     * Get all comments on stadiums owned by a specific owner
     */
    public List<Comment> getCommentsByOwner(int ownerID) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.FullName, u.AvatarUrl, s.Name as StadiumName " +
                    "FROM Comment c " +
                    "INNER JOIN [User] u ON c.UserID = u.UserID " +
                    "INNER JOIN Stadium s ON c.StadiumID = s.StadiumID " +
                    "WHERE s.OwnerID = ? AND c.IsActive = 1 " +
                    "ORDER BY c.CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ownerID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                comments.add(mapResultSetToComment(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting comments by owner: " + e.getMessage());
            e.printStackTrace();
        }
        return comments;
    }

    /**
     * Get unread comments count for stadium owner
     */
    public int getUnreadCommentsCount(int ownerID) {
        String sql = "SELECT COUNT(*) as UnreadCount " +
                    "FROM Comment c " +
                    "INNER JOIN Stadium s ON c.StadiumID = s.StadiumID " +
                    "WHERE s.OwnerID = ? AND c.IsActive = 1 " +
                    "AND c.ParentCommentID IS NULL " + // Only main comments
                    "AND c.UserID != ? " + // Exclude owner's own comments
                    "AND c.CreatedAt > DATEADD(DAY, -7, GETDATE())"; // Comments from last 7 days
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ownerID);
            ps.setInt(2, ownerID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("UnreadCount");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting unread comments count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Update a comment (only by the original author)
     */
    public boolean updateComment(Comment comment) {
        String sql = "UPDATE Comment SET Content = ?, UpdatedAt = GETDATE() " +
                    "WHERE CommentID = ? AND UserID = ? AND IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, comment.getContent());
            ps.setInt(2, comment.getCommentID());
            ps.setInt(3, comment.getUserID());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating comment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Soft delete a comment (set IsActive = 0)
     */
    public boolean deleteComment(int commentID, int userID) {
        String sql = "UPDATE Comment SET IsActive = 0, UpdatedAt = GETDATE() " +
                    "WHERE CommentID = ? AND UserID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, commentID);
            ps.setInt(2, userID);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error deleting comment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Stadium owner can hide/unhide comments on their stadium
     */
    public boolean moderateComment(int commentID, int stadiumOwnerID, boolean isActive) {
        String sql = "UPDATE Comment SET IsActive = ?, UpdatedAt = GETDATE() " +
                    "WHERE CommentID = ? AND StadiumID IN " +
                    "(SELECT StadiumID FROM Stadium WHERE OwnerID = ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, commentID);
            ps.setInt(3, stadiumOwnerID);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error moderating comment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get a single comment by ID with user info
     */
    public Comment getCommentById(int commentID) {
        String sql = "SELECT c.*, u.FullName, u.AvatarUrl, s.Name as StadiumName " +
                    "FROM Comment c " +
                    "INNER JOIN [User] u ON c.UserID = u.UserID " +
                    "INNER JOIN Stadium s ON c.StadiumID = s.StadiumID " +
                    "WHERE c.CommentID = ? AND c.IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, commentID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToComment(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting comment by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get comments with pagination
     */
    public List<Comment> getCommentsByStadiumWithPaging(int stadiumID, int page, int recordsPerPage) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.FullName, u.AvatarUrl, s.Name as StadiumName " +
                    "FROM Comment c " +
                    "INNER JOIN [User] u ON c.UserID = u.UserID " +
                    "INNER JOIN Stadium s ON c.StadiumID = s.StadiumID " +
                    "WHERE c.StadiumID = ? AND c.ParentCommentID IS NULL AND c.IsActive = 1 " +
                    "ORDER BY c.CreatedAt DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, stadiumID);
            ps.setInt(2, (page - 1) * recordsPerPage);
            ps.setInt(3, recordsPerPage);
            
            System.out.println("🔍 Executing query: Stadium " + stadiumID + ", Page " + page + ", Records " + recordsPerPage);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Comment comment = mapResultSetToComment(rs);
                comments.add(comment);
            }
            
            System.out.println("✅ Found " + comments.size() + " comments for stadium " + stadiumID);
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting comments with paging: " + e.getMessage());
            e.printStackTrace();
        }
        return comments;
    }

    /**
     * Get total comment count for a stadium (for pagination)
     */
    public int getTotalCommentsCount(int stadiumID) {
        String sql = "SELECT COUNT(*) as Total FROM Comment " +
                    "WHERE StadiumID = ? AND ParentCommentID IS NULL AND IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, stadiumID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int total = rs.getInt("Total");
                System.out.println("✅ Total main comments for stadium " + stadiumID + ": " + total);
                return total;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting total comments count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if user is the owner of the stadium
     */
    public boolean isStadiumOwner(int userID, int stadiumID) {
        String sql = "SELECT COUNT(*) FROM Stadium WHERE StadiumID = ? AND OwnerID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, stadiumID);
            ps.setInt(2, userID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                boolean isOwner = rs.getInt(1) > 0;
                System.out.println("🔍 User " + userID + " is owner of stadium " + stadiumID + ": " + isOwner);
                return isOwner;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error checking stadium owner: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Validate that a user can reply to a specific comment
     */
    public boolean canUserReplyToComment(int userID, int commentID) {
        String sql = "SELECT c.StadiumID FROM Comment c " +
                    "WHERE c.CommentID = ? AND c.IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, commentID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int stadiumID = rs.getInt("StadiumID");
                return isStadiumOwner(userID, stadiumID);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error checking reply permission: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get recent comments for stadium owner dashboard
     */
    public List<Comment> getRecentCommentsForOwner(int ownerID, int limit) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT TOP (?) c.*, u.FullName, u.AvatarUrl, s.Name as StadiumName " +
                    "FROM Comment c " +
                    "INNER JOIN [User] u ON c.UserID = u.UserID " +
                    "INNER JOIN Stadium s ON c.StadiumID = s.StadiumID " +
                    "WHERE s.OwnerID = ? AND c.IsActive = 1 AND c.ParentCommentID IS NULL " +
                    "ORDER BY c.CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ps.setInt(2, ownerID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                comments.add(mapResultSetToComment(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting recent comments for owner: " + e.getMessage());
            e.printStackTrace();
        }
        return comments;
    }

    /**
     * Search comments by content
     */
    public List<Comment> searchComments(String keyword, int stadiumID) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.FullName, u.AvatarUrl, s.Name as StadiumName " +
                    "FROM Comment c " +
                    "INNER JOIN [User] u ON c.UserID = u.UserID " +
                    "INNER JOIN Stadium s ON c.StadiumID = s.StadiumID " +
                    "WHERE c.StadiumID = ? AND c.Content LIKE ? AND c.IsActive = 1 " +
                    "ORDER BY c.CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, stadiumID);
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                comments.add(mapResultSetToComment(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error searching comments: " + e.getMessage());
            e.printStackTrace();
        }
        return comments;
    }

    /**
     * Get comment statistics for a stadium
     */
    public int getCommentCount(int stadiumID) {
        String sql = "SELECT COUNT(*) as Total FROM Comment " +
                    "WHERE StadiumID = ? AND IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, stadiumID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int total = rs.getInt("Total");
                System.out.println("✅ Total comments (including replies) for stadium " + stadiumID + ": " + total);
                return total;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting comment count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if user has already commented on a stadium
     */
    public boolean hasUserCommented(int userID, int stadiumID) {
        String sql = "SELECT COUNT(*) FROM Comment " +
                    "WHERE UserID = ? AND StadiumID = ? AND ParentCommentID IS NULL AND IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userID);
            ps.setInt(2, stadiumID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error checking if user commented: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map ResultSet to Comment object
     */
    private Comment mapResultSetToComment(ResultSet rs) throws SQLException {
        Comment comment = new Comment();
        
        comment.setCommentID(rs.getInt("CommentID"));
        comment.setStadiumID(rs.getInt("StadiumID"));
        comment.setUserID(rs.getInt("UserID"));
        
        // Handle ParentCommentID (can be NULL)
        Object parentCommentIDObj = rs.getObject("ParentCommentID");
        if (parentCommentIDObj != null) {
            comment.setParentCommentID((Integer) parentCommentIDObj);
        } else {
            comment.setParentCommentID(null);
        }
        
        comment.setContent(rs.getString("Content"));
        comment.setCreatedAt(rs.getTimestamp("CreatedAt"));
        comment.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        comment.setActive(rs.getBoolean("IsActive"));
        
        // Display fields from JOIN
        comment.setUserName(rs.getString("FullName"));
        comment.setUserAvatarUrl(rs.getString("AvatarUrl"));
        comment.setStadiumName(rs.getString("StadiumName"));
        
        // Set IsOwnerReply from database or calculate it
        try {
            comment.setOwnerReply(rs.getBoolean("IsOwnerReply"));
        } catch (SQLException e) {
            // If IsOwnerReply column doesn't exist in result, calculate it
            // This happens when we don't select it in some queries
            comment.setOwnerReply(false);
        }
        
        return comment;
    }
}