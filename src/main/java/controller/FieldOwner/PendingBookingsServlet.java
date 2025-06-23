package controller.FieldOwner;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Booking;


@WebServlet("/pendingBookings")
public class PendingBookingsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        int currentPage = 1;
        int pageSize = 10;

        // Get current page from query parameter
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

        // Get pending bookings with pagination
        List<Booking> pendingBookings = bookingDAO.getPendingBookings();
        int totalBookings = pendingBookings.size();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);

        // Calculate start and end indices for pagination
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalBookings);

        // Set attributes for JSP
        request.setAttribute("pendingBookings", pendingBookings.subList(startIndex, endIndex));
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);

        // Forward to JSP
        request.getRequestDispatcher("/fieldOwner/pendingBookings.jsp").forward(request, response);
    }
}