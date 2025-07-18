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
        PaymentDAO paymentDAO = new PaymentDAO();

        try {
            List<String> stadiums = paymentDAO.getAllStadiumNames();
            List<RevenueReport> reports = paymentDAO.getRevenueByStadiumAndPeriod(period);
            request.setAttribute("stadiums", stadiums);
            request.setAttribute("reports", reports);

            request.getRequestDispatcher("/fieldOwner/revenueReport.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(500, "Lỗi khi xử lý báo cáo doanh thu.");
        }
    }
}