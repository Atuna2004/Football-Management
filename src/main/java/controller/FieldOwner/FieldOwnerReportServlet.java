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

            // You can implement filtering here based on request parameters (search, status, type, priority)
            // For now, it fetches all reports for the owner.
            ownerReports = reportDAO.getReportsByOwnerId(ownerId);
            LOGGER.log(Level.INFO, "Successfully fetched {0} reports for owner ID: {1}", new Object[]{ownerReports.size(), ownerId});

            request.setAttribute("reports", ownerReports);

            // Forward to the JSP
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

    /**
     * Handles the HTTP POST method for updating report status.
     * This method now incorporates the logic previously intended for UpdateReportStatusServlet.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Authentication and Authorization Check (Crucial for security)
        if (session == null || (session.getAttribute("loggedInUser") == null && session.getAttribute("currentUser") == null)) {
            LOGGER.warning("Unauthorized POST attempt to update report status. Redirecting to login.");
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
            LOGGER.warning("User " + (currentUser != null ? currentUser.getEmail() : "N/A") + " attempted to update report status without owner role via POST. Access denied.");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to perform this action.");
            return;
        }

        // 2. Get parameters from the request
        String reportIDStr = request.getParameter("reportID");
        String newStatus = request.getParameter("status"); // Parameter name from JSP form

        if (reportIDStr == null || reportIDStr.isEmpty() || newStatus == null || newStatus.isEmpty()) {
            LOGGER.warning("Missing reportID or status parameter for update via POST. reportID: " + reportIDStr + ", status: " + newStatus);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters for report status update.");
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
            // 3. Get database connection and DAO
            conn = DBConnection.getConnection();
            ReportDAO reportDAO = new ReportDAO(conn);

            // 4. Update report status in the database
            reportDAO.updateReportStatus(reportID, newStatus);
            LOGGER.info("Report ID " + reportID + " status updated to: " + newStatus + " by owner: " + currentUser.getEmail() + " via POST.");

            // 5. Redirect back to the reports page with a success message
            response.sendRedirect(request.getContextPath() + "/owner/reports?statusUpdate=success&reportID=" + reportID + "&newStatus=" + newStatus);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating report status for ID: " + reportID + " via POST.", e);
            response.sendRedirect(request.getContextPath() + "/owner/reports?statusUpdate=error&reportID=" + reportID + "&errorMessage=" + e.getMessage());
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
        return "Servlet for Field Owner Report Management";
    }
}
