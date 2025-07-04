package controller.Admin;

import connect.DBConnection;
import dao.ReportDAO;
import model.Report;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/reports/user")
public class UserReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            ReportDAO reportDAO = new ReportDAO(conn);
            List<Report> reports = reportDAO.getAllReports(); // Lấy toàn bộ báo cáo

            System.out.println("Tổng số báo cáo lấy được: " + reports.size()); // Debug

            request.setAttribute("reportList", reports); // Đặt tên đúng như JSP đang dùng
            request.getRequestDispatcher("/admin/userReport.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi khi tải danh sách báo cáo người dùng.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int reportID = Integer.parseInt(request.getParameter("reportID"));
            String currentStatus = request.getParameter("currentStatus");
            String nextStatus = getNextStatus(currentStatus);

            try (Connection conn = DBConnection.getConnection()) {
                ReportDAO reportDAO = new ReportDAO(conn);
                reportDAO.updateReportStatus(reportID, nextStatus);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/userReport.jsp");
    }

    private String getNextStatus(String current) {
        if (current == null) return "closed";
        current = current.toLowerCase();
        switch (current) {
            case "pending":
                return "processing";
            case "processing":
                return "resolved";
            case "resolved":
                return "closed";
            default:
                return "closed";
        }
    }
}

