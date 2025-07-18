package controller.Admin;

import dao.OwnerRequestDAO;
import model.OwnerRequest;
import connect.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/pending")
public class PendingFieldOwnerServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(PendingFieldOwnerServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            OwnerRequestDAO requestDAO = new OwnerRequestDAO(conn);
            List<OwnerRequest> allRequests = requestDAO.getAllRequests();

            logger.info("Tổng số yêu cầu: " + allRequests.size());
            for (OwnerRequest req : allRequests) {
                logger.info("Yêu cầu ID: " + req.getRequestID() + ", Trạng thái: " + req.getStatus());
            }

            request.setAttribute("requestList", allRequests);
            request.getRequestDispatcher("/admin/fieldOwnerApprove.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("Lỗi khi tải danh sách yêu cầu: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải danh sách chủ sân chờ duyệt.");
            request.getRequestDispatcher("/Error.jsp").forward(request, response);
        }
    }
}