package controller.Stadium;

import dao.CommentDAO;
import model.Comment;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/load-comments")
public class LoadCommentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("📄 [LoadCommentsServlet] Loading comments");

        // Set response configuration
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Get parameters
            String stadiumIdParam = request.getParameter("stadiumId");
            String pageParam = request.getParameter("page");

            if (stadiumIdParam == null || stadiumIdParam.trim().isEmpty()) {
                sendErrorResponse(response, "Stadium ID is required.");
                return;
            }

            int stadiumId;
            try {
                stadiumId = Integer.parseInt(stadiumIdParam.trim());
            } catch (NumberFormatException e) {
                sendErrorResponse(response, "Invalid stadium ID format.");
                return;
            }

            // Parse page parameter (default to 1)
            int page = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam.trim());
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int recordsPerPage = 5; // CHANGED FROM 10 TO 5 Comments per page

            System.out.println("✅ Loading comments for stadium " + stadiumId + ", page " + page);

            // Load comments
            CommentDAO commentDAO = new CommentDAO();
            List<Comment> comments = commentDAO.getCommentsByStadiumWithPaging(stadiumId, page, recordsPerPage);
            int totalComments = commentDAO.getTotalCommentsCount(stadiumId);
            int totalPages = (int) Math.ceil((double) totalComments / recordsPerPage);

            // Build JSON response
            StringBuilder jsonResponse = new StringBuilder();
            jsonResponse.append("{");
            jsonResponse.append("\"success\": true,");
            jsonResponse.append("\"comments\": [");

            for (int i = 0; i < comments.size(); i++) {
                Comment comment = comments.get(i);
                
                if (i > 0) jsonResponse.append(",");
                
                jsonResponse.append("{");
                jsonResponse.append("\"commentId\": ").append(comment.getCommentID()).append(",");
                jsonResponse.append("\"content\": \"").append(escapeJson(comment.getContent())).append("\",");
                jsonResponse.append("\"userName\": \"").append(escapeJson(comment.getUserName() != null ? comment.getUserName() : "Anonymous")).append("\",");
                jsonResponse.append("\"userAvatar\": \"").append(escapeJson(comment.getUserAvatarUrl() != null ? comment.getUserAvatarUrl() : "")).append("\",");
                jsonResponse.append("\"createdAt\": \"").append(comment.getCreatedAt() != null ? comment.getCreatedAt().toString() : "").append("\",");
                jsonResponse.append("\"timeAgo\": \"").append(escapeJson(comment.getTimeAgo())).append("\",");
                jsonResponse.append("\"isOwnerReply\": ").append(comment.isOwnerReply()).append(",");
                jsonResponse.append("\"isMainComment\": ").append(comment.isMainComment());
                
                // Load replies for this comment
                List<Comment> replies = commentDAO.getRepliesByComment(comment.getCommentID());
                jsonResponse.append(",\"replies\": [");
                
                for (int j = 0; j < replies.size(); j++) {
                    Comment reply = replies.get(j);
                    
                    if (j > 0) jsonResponse.append(",");
                    
                    jsonResponse.append("{");
                    jsonResponse.append("\"commentId\": ").append(reply.getCommentID()).append(",");
                    jsonResponse.append("\"content\": \"").append(escapeJson(reply.getContent())).append("\",");
                    jsonResponse.append("\"userName\": \"").append(escapeJson(reply.getUserName() != null ? reply.getUserName() : "Anonymous")).append("\",");
                    jsonResponse.append("\"userAvatar\": \"").append(escapeJson(reply.getUserAvatarUrl() != null ? reply.getUserAvatarUrl() : "")).append("\",");
                    jsonResponse.append("\"createdAt\": \"").append(reply.getCreatedAt() != null ? reply.getCreatedAt().toString() : "").append("\",");
                    jsonResponse.append("\"timeAgo\": \"").append(escapeJson(reply.getTimeAgo())).append("\",");
                    jsonResponse.append("\"isOwnerReply\": ").append(reply.isOwnerReply());
                    jsonResponse.append("}");
                }
                
                jsonResponse.append("]");
                jsonResponse.append("}");
            }

            jsonResponse.append("],");
            jsonResponse.append("\"pagination\": {");
            jsonResponse.append("\"currentPage\": ").append(page).append(",");
            jsonResponse.append("\"totalPages\": ").append(totalPages).append(",");
            jsonResponse.append("\"totalComments\": ").append(totalComments).append(",");
            jsonResponse.append("\"recordsPerPage\": ").append(recordsPerPage);
            jsonResponse.append("}");
            jsonResponse.append("}");

            System.out.println("✅ Loaded " + comments.size() + " comments for stadium " + stadiumId);

            // Send response
            PrintWriter out = response.getWriter();
            out.write(jsonResponse.toString());

        } catch (NumberFormatException e) {
            System.out.println("❌ Parameter parsing error: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Invalid parameter format.");
        } catch (Exception e) {
            System.out.println("❌ System error: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "System error occurred. Please try again.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Also support POST method for AJAX requests
        doGet(request, response);
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        String jsonResponse = "{\"success\": false, \"message\": \"" + escapeJson(message) + "\"}";
        response.getWriter().write(jsonResponse);
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}