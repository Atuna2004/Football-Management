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
            String reportIDStr = request.getParameter("reportID");
            String action = request.getParameter("action");
            String newStatus = request.getParameter("newStatus");
            
            if (reportIDStr == null || reportIDStr.trim().isEmpty()) {
                System.out.println("❌ Error: reportID is null or empty");
                response.sendRedirect(request.getContextPath() + "/admin/reports/user");
                return;
            }
            
            int reportID = Integer.parseInt(reportIDStr);
            
            try (Connection conn = DBConnection.getConnection()) {
                ReportDAO reportDAO = new ReportDAO(conn);
                
                // Check if this is a delete action
                if ("delete".equals(action)) {
                    System.out.println("✅ Deleting report ID: " + reportID);
                    boolean deleted = reportDAO.deleteReport(reportID);
                    
                    if (deleted) {
                        System.out.println("✅ Report deleted successfully");
                        // Set success message in session
                        HttpSession session = request.getSession();
                        session.setAttribute("successMessage", "Báo cáo đã được xóa thành công!");
                    } else {
                        System.out.println("❌ Report deletion failed - report not found");
                        // Set error message in session
                        HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", "Không tìm thấy báo cáo để xóa!");
                    }
                    
                } else if (newStatus != null && !newStatus.trim().isEmpty()) {
                    // This is a status update action
                    System.out.println("✅ Updating report ID " + reportID + " to status: " + newStatus);
                    reportDAO.updateReportStatus(reportID, newStatus);
                    System.out.println("✅ Report status updated successfully");
                    
                    // Set success message in session
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Trạng thái báo cáo đã được cập nhật thành công!");
                    
                } else {
                    System.out.println("❌ Error: No valid action or newStatus provided");
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", "Hành động không hợp lệ!");
                }
            }
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Error: Invalid reportID format - " + e.getMessage());
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "ID báo cáo không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Error processing request: " + e.getMessage());
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi xử lý yêu cầu: " + e.getMessage());
        }
        
        // Redirect back to the reports page
        response.sendRedirect(request.getContextPath() + "/admin/reports/user");
    }
}