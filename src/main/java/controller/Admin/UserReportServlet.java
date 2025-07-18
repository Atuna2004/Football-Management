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
            List<Report> reports = reportDAO.getAllReports();
            
            System.out.println("✅ Tổng số báo cáo lấy được: " + reports.size());
            
            // Debug: Log first few reports
            for (int i = 0; i < Math.min(3, reports.size()); i++) {
                Report r = reports.get(i);
                System.out.println("Report " + (i+1) + ": ID=" + r.getReportID() + 
                                 ", Title='" + r.getTitle() + "', Description='" + r.getDescription() + 
                                 "', Status='" + r.getStatus() + "'");
            }
            
            request.setAttribute("reportList", reports);
            request.getRequestDispatcher("/admin/userReport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi khi tải danh sách báo cáo người dùng: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            int reportID = Integer.parseInt(request.getParameter("reportID"));
            String newStatus = request.getParameter("newStatus");
            
            System.out.println("✅ Updating report ID " + reportID + " to status: " + newStatus);
            
            try (Connection conn = DBConnection.getConnection()) {
                ReportDAO reportDAO = new ReportDAO(conn);
                reportDAO.updateReportStatus(reportID, newStatus);
                System.out.println("✅ Report status updated successfully");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Error updating report status: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/reports/user");
    }
}