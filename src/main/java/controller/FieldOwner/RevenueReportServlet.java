package controller.FieldOwner;

import dao.PaymentDAO;
import model.RevenueReport;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/revenue-reports")
public class RevenueReportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "month"; // Giá trị mặc định
        }

        PaymentDAO paymentDAO = new PaymentDAO();

        // Trong RevenueReportServlet.java, trong phương thức doGet()
        try {
            List<String> stadiums = paymentDAO.getAllStadiumNames();
            List<RevenueReport> reports = paymentDAO.getRevenueByStadiumAndPeriod(period);

            // ✅ Thêm đoạn này: Tạo danh sách period không trùng
            java.util.Set<String> periodSet = new java.util.LinkedHashSet<>();
            for (RevenueReport r : reports) {
                periodSet.add(r.getPeriod()); // Ví dụ: "2025-07", "2025-08"
            }
            List<String> periodList = new java.util.ArrayList<>(periodSet);

            // ✅ Gửi dữ liệu sang JSP
            request.setAttribute("stadiums", stadiums);
            request.setAttribute("reports", reports);
            request.setAttribute("periodList", periodList); // ← Đây là cái mới

            request.getRequestDispatcher("/fieldOwner/revenueReport.jsp").forward(request, response);

        } catch (Exception e) {
            // In lỗi chi tiết
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h3>Lỗi server: " + e.getMessage() + "</h3>");
            response.getWriter().println("<pre>");
            e.printStackTrace(response.getWriter());
            response.getWriter().println("</pre>");
        }
    }
}