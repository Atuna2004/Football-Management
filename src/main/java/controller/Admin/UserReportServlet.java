    package controller.admin;

    import dao.ReportDAO;
    import model.Report;
    import connect.DBConnection;

    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.*;
    import java.io.IOException;
    import java.sql.Connection;
    import java.util.List;

    @WebServlet("/admin/user-report")
    public class UserReportServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            try (Connection conn = DBConnection.getConnection()) {
                ReportDAO reportDAO = new ReportDAO(conn);
                List<Report> reports = reportDAO.getAllReports();

                request.setAttribute("reportList", reports);
                request.getRequestDispatcher("/admin/userReport.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(500, "Lỗi khi tải danh sách báo cáo.");
            }
        }

        // Xử lý tick trạng thái
        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
            int reportID = Integer.parseInt(request.getParameter("reportID"));
            String currentStatus = request.getParameter("currentStatus");
            String nextStatus = getNextStatus(currentStatus);

            try (Connection conn = DBConnection.getConnection()) {
                ReportDAO reportDAO = new ReportDAO(conn);
                reportDAO.updateReportStatus(reportID, nextStatus);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("user-report");
        }

        private static String getNextStatus(String current) {
            if ("pending".equalsIgnoreCase(current)) {
                return "processing";
            } else if ("processing".equalsIgnoreCase(current)) {
                return "resolved";
            } else if ("resolved".equalsIgnoreCase(current)) {
                return "closed";
            } else {
                return "closed";
            }
        }
    }
