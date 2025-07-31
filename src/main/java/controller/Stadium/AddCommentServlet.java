package controller.Stadium;

import connect.DBConnection;
import dao.CommentDAO;
import model.Comment;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/add-comment")
public class AddCommentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("💬 [DEBUG] === AddCommentServlet Called ===");
        System.out.println("🔍 stadiumId param: '" + request.getParameter("stadiumId") + "'");
        System.out.println("🔍 content param: '" + request.getParameter("content") + "'");
        System.out.println("🔍 parentCommentId param: '" + request.getParameter("parentCommentId") + "'");
        
        Object sessionUserObj = request.getSession().getAttribute("currentUser");
        System.out.println("🔍 Session user object: " + sessionUserObj);

        // Set response configuration
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // Validate user session
            User currentUser = validateUserSession(request);
            if (currentUser == null) {
                System.out.println("❌ User validation failed");
                sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED,
                        "Please login to submit a comment.");
                return;
            }

            System.out.println("✅ User authenticated: " + currentUser.getFullName() + " (ID: " + currentUser.getUserID() + ")");

            // Extract and validate parameters
            CommentParameters params = extractParameters(request);
            if (params == null) {
                System.out.println("❌ Parameter validation failed");
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                        "Missing required comment information.");
                return;
            }

            System.out.println("✅ Parameters validated: Stadium ID " + params.stadiumId + ", Content length: " + params.content.length());

            // Create comment object
            Comment comment = createComment(currentUser, params);

            // Database operations
            CommentDAO commentDAO = new CommentDAO();
            boolean success;

            // Check if this is a reply (only stadium owners can reply)
            if (params.parentCommentId != null) {
                System.out.println("🔍 Processing reply to comment " + params.parentCommentId);
                if (!commentDAO.canUserReplyToComment(currentUser.getUserID(), params.parentCommentId)) {
                    System.out.println("❌ User not authorized to reply");
                    sendErrorResponse(response, HttpServletResponse.SC_FORBIDDEN,
                            "You are not authorized to reply to this comment.");
                    return;
                }
                success = commentDAO.addReply(comment, currentUser.getUserID());
                System.out.println("🔍 Reply result: " + success);
            } else {
                System.out.println("🔍 Processing main comment");
                success = commentDAO.addComment(comment);
                System.out.println("🔍 Add comment result: " + success);
            }

            if (success) {
                System.out.println("✅ Comment saved successfully with ID: " + comment.getCommentID());
                String message = params.parentCommentId != null ? 
                    "Reply submitted successfully!" : "Comment submitted successfully!";
                sendSuccessResponse(response, message);
            } else {
                System.out.println("❌ Failed to save comment to database");
                sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Failed to submit comment. Please try again.");
            }

        } catch (NumberFormatException e) {
            System.out.println("❌ Number format error: " + e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid number format in parameters.");
        } catch (IOException e) {
            System.out.println("❌ Unexpected error: " + e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unexpected error occurred: " + e.getMessage());
        }
    }

    private User validateUserSession(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                System.out.println("❌ No session found");
                return null;
            }

            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                System.out.println("❌ No user in session");
                return null;
            }

            System.out.println("✅ Session validation successful");
            return currentUser;
            
        } catch (Exception e) {
            System.out.println("❌ Error validating session: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private CommentParameters extractParameters(HttpServletRequest request) {
        try {
            String stadiumIdParam = request.getParameter("stadiumId");
            String content = request.getParameter("content");
            String parentCommentIdParam = request.getParameter("parentCommentId");

            System.out.println("📥 Raw parameters extracted");

            // Validate stadium ID
            if (stadiumIdParam == null || stadiumIdParam.trim().isEmpty()) {
                System.out.println("❌ Stadium ID missing or empty");
                return null;
            }

            int stadiumId;
            try {
                stadiumId = Integer.parseInt(stadiumIdParam.trim());
                System.out.println("✅ Stadium ID parsed: " + stadiumId);
            } catch (NumberFormatException e) {
                System.out.println("❌ Invalid stadium ID format: " + stadiumIdParam);
                return null;
            }

            // Validate content
            if (content == null || content.trim().isEmpty()) {
                System.out.println("❌ Comment content missing or empty");
                return null;
            }

            System.out.println("✅ Content validated, length: " + content.trim().length());

            // Optional parent comment ID (for replies)
            Integer parentCommentId = null;
            if (parentCommentIdParam != null && !parentCommentIdParam.trim().isEmpty()) {
                try {
                    parentCommentId = Integer.valueOf(parentCommentIdParam.trim());
                    System.out.println("✅ Parent comment ID parsed: " + parentCommentId);
                } catch (NumberFormatException e) {
                    System.out.println("❌ Invalid parent comment ID format: " + parentCommentIdParam);
                    return null;
                }
            } else {
                System.out.println("✅ No parent comment ID (main comment)");
            }

            return new CommentParameters(stadiumId, content.trim(), parentCommentId);
            
        } catch (Exception e) {
            System.out.println("❌ Error extracting parameters: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private Comment createComment(User user, CommentParameters params) {
        try {
            Comment comment = new Comment();
            comment.setUserID(user.getUserID());
            comment.setStadiumID(params.stadiumId);
            comment.setContent(params.content);
            comment.setParentCommentID(params.parentCommentId);

            System.out.println("📝 Comment object created successfully");
            return comment;
            
        } catch (Exception e) {
            System.out.println("❌ Error creating comment object: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private void sendSuccessResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        String jsonResponse = "{\"success\": true, \"message\": \"" + escapeJson(message) + "\"}";
        response.getWriter().write(jsonResponse);
        System.out.println("✅ Success response sent: " + message);
    }

    private void sendErrorResponse(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        String jsonResponse = "{\"success\": false, \"message\": \"" + escapeJson(message) + "\"}";
        response.getWriter().write(jsonResponse);
        System.out.println("❌ Error response sent (status " + statusCode + "): " + message);
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        sendErrorResponse(response, HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                "GET method not allowed. Use POST.");
    }

    // Inner class for parameters
    private static class CommentParameters {
        final int stadiumId;
        final String content;
        final Integer parentCommentId;

        CommentParameters(int stadiumId, String content, Integer parentCommentId) {
            this.stadiumId = stadiumId;
            this.content = content;
            this.parentCommentId = parentCommentId;
        }
    }
    private boolean validateWordCount(String content) {
    if (content == null || content.trim().isEmpty()) {
        return false;
    }
    
    // Split by whitespace and count words
    String[] words = content.trim().split("\\s+");
    int wordCount = words.length;
    
    System.out.println("🔍 Word count: " + wordCount + " words");
    
    return wordCount <= 360;
}
}