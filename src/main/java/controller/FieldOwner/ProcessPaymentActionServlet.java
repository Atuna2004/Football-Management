package controller.FieldOwner;

import dao.BookingDAO;
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
    private BookingDAO bookingDAO = new BookingDAO(); // Thêm BookingDAO

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String paymentID = request.getParameter("paymentID");

        if ("confirm".equals(action)) {
            boolean updated = paymentDAO.updatePaymentStatusByPaymentID(paymentID, "Completed");
            if (updated) {
                // Lấy BookingID từ PaymentID
                int bookingId = paymentDAO.getBookingIdByPaymentId(paymentID);
                if (bookingId != -1) {
                    // Cập nhật trạng thái Booking thành Confirmed (hoặc Completed)
                    bookingDAO.confirmBooking(bookingId); // hoặc updateBookingStatus(bookingId, "Completed")
                }
            }
        } else if ("reject".equals(action)) {
            paymentDAO.updatePaymentStatusByPaymentID(paymentID, "Failed");
            // Tùy chọn: cập nhật booking thành Cancelled nếu cần
        }

        response.sendRedirect(request.getContextPath() + "/pending-payments");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id"); // id ở đây là PaymentID

        if ("Completed".equals(action)) {
            boolean updated = paymentDAO.updatePaymentStatusByPaymentID(id, "Completed");
            if (updated) {
                int bookingId = paymentDAO.getBookingIdByPaymentId(id);
                if (bookingId != -1) {
                    bookingDAO.confirmBooking(bookingId);
                }
            }
        } else if ("Failed".equals(action)) {
            paymentDAO.updatePaymentStatusByPaymentID(id, "Failed");
        }

        response.sendRedirect(request.getContextPath() + "/pending-payments");
    }
}