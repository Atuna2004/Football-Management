package controller.Admin;

import connect.DBConnection;
import dao.OwnerRequestDAO;
import dao.UserRoleDAO;
import model.OwnerRequest;
import service.EmailService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet(name = "ApproveRejectRequestServlet", urlPatterns = {"/admin/approve-request"})
public class ApproveRejectRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action"); // approve or reject
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String adminNote = request.getParameter("note");

        Connection connection = null;

        try {
            connection = DBConnection.getConnection();
            OwnerRequestDAO ownerRequestDAO = new OwnerRequestDAO(connection);
            OwnerRequest requestDetails = ownerRequestDAO.getRequestById(requestId);

            if (requestDetails == null) {
                request.setAttribute("error", "Không tìm thấy yêu cầu.");
                response.sendRedirect(request.getContextPath() + "/admin/pending");
                return;
            }

            if ("approve".equals(action)) {
                boolean updated = ownerRequestDAO.updateRequestStatus(requestId, "APPROVED", adminNote);
                if (updated && changeUserRoleToOwner(connection, requestDetails.getUserID())) {
                    request.setAttribute("success", "Phê duyệt thành công! Người dùng đã trở thành Chủ sân.");
                } else {
                    request.setAttribute("error", "Không thể cập nhật quyền người dùng.");
                }

            } else if ("reject".equals(action)) {
                boolean rejected = ownerRequestDAO.updateRequestStatus(requestId, "REJECTED", adminNote);
                if (rejected) {
                    sendRejectionEmail(requestDetails, adminNote);
                    request.setAttribute("success", "Yêu cầu đã bị từ chối và email đã được gửi.");
                } else {
                    request.setAttribute("error", "Không thể từ chối yêu cầu.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
        } finally {
            if (connection != null) {
                DBConnection.closeConnection(connection);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/pending");
    }

    // Dùng UserRoleDAO để thay đổi vai trò người dùng
    private boolean changeUserRoleToOwner(Connection conn, int userId) throws Exception {
        UserRoleDAO userRoleDAO = new UserRoleDAO(conn);
        return userRoleDAO.changeUserRoleToOwner(userId);
    }

    // Gửi email từ chối bằng EmailService
    private void sendRejectionEmail(OwnerRequest req, String reason) {
        String subject = "Yêu cầu làm chủ sân đã bị từ chối";
        String message = "<h1>Rất tiếc!</h1>" +
                       "<p>Xin chào " + req.getFullName() + ",</p>" +
                       "<p>Yêu cầu của bạn để trở thành chủ sân đã bị từ chối.</p>" +
                       "<p>Lý do: " + (reason != null ? reason : "Không có lý do được cung cấp") + "</p>" +
                       "<p>Bạn có thể gửi một yêu cầu mới sau khi chỉnh sửa thông tin cần thiết.</p>" +
                       "<p>Trân trọng,<br>Đội ngũ quản lý hệ thống đặt sân</p>";

        try {
            EmailService.sendEmail(req.getEmail(), subject, message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}