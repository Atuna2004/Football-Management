package controller.FieldOwner;

import dao.ReportDAO;
import model.Report;
import model.User;
import connect.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "FieldOwnerReportServlet", urlPatterns = {"/owner/reports"})
public class FieldOwnerReportServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(FieldOwnerReportServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || (session.getAttribute("loggedInUser") == null && session.getAttribute("currentUser") == null)) {
            LOGGER.warning("Unauthorized access attempt to /owner/reports. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            currentUser = (User) session.getAttribute("loggedInUser");
            if (currentUser != null) {
                session.setAttribute("currentUser", currentUser);
                session.removeAttribute("loggedInUser");
                LOGGER.info("Migrated 'loggedInUser' to 'currentUser' in session.");
            }
        }

        if (currentUser == null || !currentUser.isFieldOwner()) {
            LOGGER.warning("User " + (currentUser != null ? currentUser.getEmail() : "N/A") + " attempted to access owner reports without owner role. Access denied.");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to view this page.");
            return;
        }

        int ownerId = currentUser.getUserID();
        List<Report> ownerReports = null;
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            ReportDAO reportDAO = new ReportDAO(conn);

            ownerReports = reportDAO.getReportsByOwnerId(ownerId);
            LOGGER.log(Level.INFO, "Successfully fetched {0} reports for owner ID: {1}", new Object[]{ownerReports.size(), ownerId});

            request.setAttribute("reports", ownerReports);

            request.getRequestDispatcher("/fieldOwner/FieldOwnerReport.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching owner reports for ID: " + ownerId, e);
            request.setAttribute("errorMessage", "An error occurred while retrieving reports. Please try again later.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing database connection.", e);
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || (session.getAttribute("loggedInUser") == null && session.getAttribute("currentUser") == null)) {
            LOGGER.warning("Unauthorized POST attempt to update report. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            currentUser = (User) session.getAttribute("loggedInUser");
            if (currentUser != null) {
                session.setAttribute("currentUser", currentUser);
                session.removeAttribute("loggedInUser");
            }
        }

        if (currentUser == null || !currentUser.isFieldOwner()) {
            LOGGER.warning("User " + (currentUser != null ? currentUser.getEmail() : "N/A") + " attempted to update report without owner role via POST. Access denied.");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to perform this action.");
            return;
        }

        String reportIDStr = request.getParameter("reportID");
        String action = request.getParameter("action");
        String newStatus = request.getParameter("newStatus");

        if (reportIDStr == null || reportIDStr.trim().isEmpty()) {
            LOGGER.warning("Missing reportID parameter for POST request");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required reportID parameter.");
            return;
        }

        int reportID;
        try {
            reportID = Integer.parseInt(reportIDStr);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid reportID format via POST: " + reportIDStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Report ID format.");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ReportDAO reportDAO = new ReportDAO(conn);

            if ("delete".equals(action)) {
                LOGGER.info("Processing delete request for Report ID: " + reportID + " by owner: " + currentUser.getEmail());
                boolean deleted = reportDAO.deleteReport(reportID);
                
                if (deleted) {
                    LOGGER.info("Report ID " + reportID + " deleted successfully by owner: " + currentUser.getEmail());
                    session.setAttribute("successMessage", "Báo cáo đã được xóa thành công!");
                } else {
                    LOGGER.warning("Report deletion failed - report not found. Report ID: " + reportID);
                    session.setAttribute("errorMessage", "Không tìm thấy báo cáo để xóa!");
                }
                
            } else if (newStatus != null && !newStatus.trim().isEmpty()) {
                LOGGER.info("Processing status update for Report ID: " + reportID + " to status: " + newStatus + " by owner: " + currentUser.getEmail());
                reportDAO.updateReportStatus(reportID, newStatus);
                LOGGER.info("Report ID " + reportID + " status updated to: " + newStatus + " by owner: " + currentUser.getEmail());
                
                session.setAttribute("successMessage", "Trạng thái báo cáo đã được cập nhật thành công!");
                
            } else {
                LOGGER.warning("No valid action or newStatus provided for POST request. Action: " + action + ", NewStatus: " + newStatus);
                session.setAttribute("errorMessage", "Hành động không hợp lệ!");
            }

            response.sendRedirect(request.getContextPath() + "/owner/reports");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error processing request for Report ID: " + reportID, e);
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi xử lý yêu cầu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/owner/reports");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing database connection.", e);
                }
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for Field Owner Report Management with Delete Functionality";
    }
}