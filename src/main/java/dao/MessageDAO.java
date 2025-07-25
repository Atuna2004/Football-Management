package dao;

import connect.DBConnection;
import model.Message;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    private Connection conn;

    public MessageDAO(Connection conn) {
        this.conn = conn;
    }

    public boolean saveMessage(Message message) throws SQLException {
        String sql = "INSERT INTO Messages (SenderID, RecipientID, Content) VALUES (?, ?, ?)";
        try (PreparedStatement ps = this.conn.prepareStatement(sql)) {
            ps.setInt(1, message.getSenderId());
            ps.setInt(2, message.getRecipientId());
            ps.setString(3, message.getContent());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Message> getChatHistory(int userId1, int userId2) throws SQLException {
        List<Message> history = new ArrayList<>();
        String sql = "SELECT * FROM Messages WHERE "
                + "(SenderID = ? AND RecipientID = ?) OR "
                + "(SenderID = ? AND RecipientID = ?) "
                + "ORDER BY Timestamp ASC";

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
                    msg.setRecipientId(rs.getInt("RecipientID"));
                    msg.setContent(rs.getString("Content"));
                    msg.setTimestamp(rs.getTimestamp("Timestamp"));
                    msg.setRead(rs.getBoolean("IsRead"));
                    history.add(msg);
                }
            }
        }
        return history;
    }
}
