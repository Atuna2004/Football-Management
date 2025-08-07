package dao;
import connect.DBConnection;
import model.Message;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    private final Connection conn;
    
    public MessageDAO(Connection conn) {
        this.conn = conn;
    }
    
    public boolean saveMessage(Message message) throws SQLException {
        String sql = "INSERT INTO Message (SenderID, ReceiverID, Content) VALUES (?, ?, ?)";
        try (PreparedStatement ps = this.conn.prepareStatement(sql)) {
            ps.setInt(1, message.getSenderId());
            ps.setInt(2, message.getRecipientId());
            ps.setString(3, message.getContent());
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<Message> getChatHistory(int userId1, int userId2) throws SQLException {
        List<Message> history = new ArrayList<>();
        String sql = "SELECT * FROM Message WHERE "
                + "(SenderID = ? AND ReceiverID = ?) OR "
                + "(SenderID = ? AND ReceiverID = ?) "
                + "ORDER BY SentAt ASC";
        try (PreparedStatement ps = this.conn.prepareStatement(sql)) {
            ps.setInt(1, userId1);
            ps.setInt(2, userId2);
            ps.setInt(3, userId2);
            ps.setInt(4, userId1);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message msg = new Message();
                    msg.setMessageId(rs.getInt("MessageID"));
                    msg.setSenderId(rs.getInt("SenderID"));
                    msg.setRecipientId(rs.getInt("ReceiverID"));
                    msg.setContent(rs.getString("Content"));
                    msg.setTimestamp(rs.getTimestamp("SentAt"));
                    msg.setRead(rs.getBoolean("IsRead"));
                    history.add(msg);
                }
            }
        }
        return history;
    } // ← This closing brace was missing!
    
    public List<Message> getStadiumChatHistory(int userId, int ownerId, int stadiumId) throws SQLException {
        List<Message> history = new ArrayList<>();
        
        // First verify that the owner actually owns this stadium
        String verifyOwnerSql = "SELECT COUNT(*) FROM Stadium WHERE StadiumID = ? AND OwnerID = ?";
        try (PreparedStatement verifyPs = this.conn.prepareStatement(verifyOwnerSql)) {
            verifyPs.setInt(1, stadiumId);
            verifyPs.setInt(2, ownerId);
            ResultSet verifyRs = verifyPs.executeQuery();
            
            if (!verifyRs.next() || verifyRs.getInt(1) == 0) {
                throw new SQLException("Owner does not own this stadium");
            }
        }
        
        // Get chat history between user and stadium owner
        String sql = "SELECT * FROM Message WHERE "
                + "(SenderID = ? AND ReceiverID = ?) OR "
                + "(SenderID = ? AND ReceiverID = ?) "
                + "ORDER BY SentAt ASC";
        
        try (PreparedStatement ps = this.conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, ownerId);
            ps.setInt(3, ownerId);
            ps.setInt(4, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message msg = new Message();
                    msg.setMessageId(rs.getInt("MessageID"));
                    msg.setSenderId(rs.getInt("SenderID"));
                    msg.setRecipientId(rs.getInt("ReceiverID"));
                    msg.setContent(rs.getString("Content"));
                    msg.setTimestamp(rs.getTimestamp("SentAt"));
                    msg.setRead(rs.getBoolean("IsRead"));
                    history.add(msg);
                }
            }
        }
        return history;
    }
  
public boolean hasChatHistory(int userId1, int userId2) throws SQLException {
    String sql = "SELECT COUNT(*) FROM Message WHERE " +
                 "(SenderID = ? AND ReceiverID = ?) OR " +
                 "(SenderID = ? AND ReceiverID = ?)";
    
    try (PreparedStatement ps = this.conn.prepareStatement(sql)) {
        ps.setInt(1, userId1);
        ps.setInt(2, userId2);
        ps.setInt(3, userId2);
        ps.setInt(4, userId1);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    }
    return false;
}
}