package controller.FieldOwner;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/booking/action")
public class BookingActionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int bookingId = Integer.parseInt(request.getParameter("id"));

        BookingDAO bookingDAO = new BookingDAO();

        boolean success = false;

        switch (action.toLowerCase()) {
            case "confirm":
                success = bookingDAO.confirmBooking(bookingId);
                break;
            case "reject":
                success = bookingDAO.rejectBooking(bookingId);
                break;
            default:
                response.sendRedirect("/error.jsp");
                return;
        }

        if (success) {
            response.sendRedirect("/pendingBookings");
        } else {
            response.sendRedirect("/error.jsp");
        }
    }
}