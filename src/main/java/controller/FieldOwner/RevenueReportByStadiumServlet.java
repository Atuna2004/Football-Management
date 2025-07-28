package controller.FieldOwner;

import connect.DBConnection;
import dao.PaymentDAO;
import dao.StadiumDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import model.RevenueReport;
import model.User;


@WebServlet("/revenue-stadium")
public class RevenueReportByStadiumServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();
    private StadiumDAO stadiumDAO = new StadiumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số
        String stadiumIdParam = request.getParameter("stadiumId");
        String period = request.getParameter("period");

        if (stadiumIdParam == null || stadiumIdParam.isEmpty()) {
            request.setAttribute("error", "Thiếu thông tin sân.");
            request.getRequestDispatcher("/account/login.jsp").forward(request, response);
            return;
        }

        int stadiumId = Integer.parseInt(stadiumIdParam);
        if (period == null || period.isEmpty()) {
            period = "month"; // mặc định
        }

        try {

            List<RevenueReport> reports = paymentDAO.getRevenueByStadiumAndPeriod(stadiumId, period);
            String stadiumName = stadiumDAO.getStadiumNameById(stadiumId);

            request.setAttribute("stadiumId", stadiumId);
            request.setAttribute("stadiumName", stadiumName);
            request.setAttribute("reports", reports);
            request.setAttribute("selectedPeriod", period);

            request.getRequestDispatcher("/fieldOwner/revenueByStadium.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi truy vấn cơ sở dữ liệu.");
            request.getRequestDispatcher("/fieldOwner/FODB.jsp").forward(request, response);
        }
    }

}