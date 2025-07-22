package controller.FieldOwner;


import dao.PaymentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/process-payment")
public class ProcessPaymentActionServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String paymentID = request.getParameter("paymentID");

        if ("confirm".equals(action)) {
            paymentDAO.updatePaymentStatusByPaymentID(paymentID, "Completed");
        } else if ("reject".equals(action)) {
            paymentDAO.updatePaymentStatusByPaymentID(paymentID, "Failed");
        }

        response.sendRedirect(request.getContextPath() + "/pending-payments");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");

        if ("Completed".equals(action)) {
            paymentDAO.updatePaymentStatusByPaymentID(id, "Completed");
        } else if ("Failed".equals(action)) {
            paymentDAO.updatePaymentStatusByPaymentID(id, "Failed");
        }

        response.sendRedirect(request.getContextPath() + "/pending-payments");
    }
}