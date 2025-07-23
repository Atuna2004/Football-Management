package model;

import java.util.Date;

public class Message {

    private int messageId;
    private int senderId;
    private int recipientId;
    private String content;
    private Date timestamp;
    private boolean isRead;

    // Constructors
    public Message() {
    }

    public Message(int senderId, int recipientId, String content) {
        this.senderId = senderId;
        this.recipientId = recipientId;
        this.content = content;
    }

    // Getters and Setters
    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public int getRecipientId() {
        return recipientId;
    }

    public void setRecipientId(int recipientId) {
        this.recipientId = recipientId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }
}
