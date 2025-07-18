package controller.FieldOwner;


import dao.PaymentDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Payment;

@WebServlet("/completed-payments")
public class CompletedPaymentsServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Payment> payments = paymentDAO.getPaymentsByStatus("Completed");
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/fieldOwner/completedPayments.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách completed payments.", e);
        }
    }
}