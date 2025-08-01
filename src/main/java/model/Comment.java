package model;

import java.sql.Timestamp;


public class Comment {
    private int commentID;
    private int stadiumID;
    private int userID;
    private Integer parentCommentID; // NULL for main comments, CommentID for replies
    private String content;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isActive;
    
    // Additional fields for display purposes (not in database)
    private String userName;
    private String userAvatarUrl;
    private String stadiumName;
    private boolean isOwnerReply; // Calculated field - true if sender is stadium owner
    
    // Constructors
    public Comment() {
        this.isActive = true;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }
    
    public Comment(int stadiumID, int userID, String content) {
        this();
        this.stadiumID = stadiumID;
        this.userID = userID;
        this.content = content;
        this.parentCommentID = null; // Main comment
    }
    
    public Comment(int stadiumID, int userID, String content, int parentCommentID) {
        this();
        this.stadiumID = stadiumID;
        this.userID = userID;
        this.content = content;
        this.parentCommentID = parentCommentID; // Reply comment
    }
    
    // Getters and Setters
    public int getCommentID() {
        return commentID;
    }
    
    public void setCommentID(int commentID) {
        this.commentID = commentID;
    }
    
    public int getStadiumID() {
        return stadiumID;
    }
    
    public void setStadiumID(int stadiumID) {
        this.stadiumID = stadiumID;
    }
    
    public int getUserID() {
        return userID;
    }
    
    public void setUserID(int userID) {
        this.userID = userID;
    }
    
    public Integer getParentCommentID() {
        return parentCommentID;
    }
    
    public void setParentCommentID(Integer parentCommentID) {
        this.parentCommentID = parentCommentID;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    // Display fields getters and setters
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getUserAvatarUrl() {
        return userAvatarUrl;
    }
    
    public void setUserAvatarUrl(String userAvatarUrl) {
        this.userAvatarUrl = userAvatarUrl;
    }
    
    public String getStadiumName() {
        return stadiumName;
    }
    
    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }
    
    public boolean isOwnerReply() {
        return isOwnerReply;
    }
    
    public void setOwnerReply(boolean ownerReply) {
        isOwnerReply = ownerReply;
    }
    
    // Utility methods
    public boolean isMainComment() {
        return parentCommentID == null;
    }
    
    public boolean isReply() {
        return parentCommentID != null;
    }
    
    public boolean hasContent() {
        return content != null && !content.trim().isEmpty();
    }
    
    /**
     * Get formatted time ago string (e.g., "2 hours ago")
     * You can implement this based on your date formatting preferences
     */
    public String getTimeAgo() {
        if (createdAt == null) return "";
        
        long diff = System.currentTimeMillis() - createdAt.getTime();
        long seconds = diff / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;
        
        if (days > 0) {
            return days + " day" + (days > 1 ? "s" : "") + " ago";
        } else if (hours > 0) {
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else if (minutes > 0) {
            return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        } else {
            return "Just now";
        }
    }
    
    @Override
    public String toString() {
        return "Comment{" +
                "commentID=" + commentID +
                ", stadiumID=" + stadiumID +
                ", userID=" + userID +
                ", parentCommentID=" + parentCommentID +
                ", content='" + content + '\'' +
                ", createdAt=" + createdAt +
                ", isActive=" + isActive +
                ", isOwnerReply=" + isOwnerReply +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Comment comment = (Comment) obj;
        return commentID == comment.commentID;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(commentID);
    }
}