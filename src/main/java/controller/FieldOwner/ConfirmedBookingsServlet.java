package controller.FieldOwner;

import connect.DBConnection;
import dao.BookingDAO;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Booking;
import model.User;

@WebServlet("/confirmedBookings")
public class ConfirmedBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = DBConnection.getConnection(); // Get connection from DBConnection

        BookingDAO bookingDAO = new BookingDAO();  // BookingDAO no longer uses conn
        AccountDAO accountDAO = new AccountDAO();  // AccountDAO no longer uses conn

        int currentPage = 1;
        int pageSize = 10;

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

        List<Booking> allConfirmedBookings = bookingDAO.getConfirmedBookings();

        double totalRevenue = 0;
        for (Booking booking : allConfirmedBookings) {
            totalRevenue += booking.getTotalAmount();
        }

        List<Map<String, Object>> bookingDetails = new ArrayList<>();
        for (Booking booking : allConfirmedBookings) {
            Map<String, Object> detail = new HashMap<>();
            detail.put("booking", booking);

            try {
                User user = accountDAO.getUserById(booking.getUserID());
                detail.put("fullname", user != null ? user.getFullName() : "Unknown");
            } catch (SQLException ex) {
                Logger.getLogger(ConfirmedBookingsServlet.class.getName()).log(Level.SEVERE, null, ex);
                detail.put("fullname", "Unknown");
            }

            bookingDetails.add(detail);
        }

        int totalBookings = bookingDetails.size();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalBookings);
        List<Map<String, Object>> paginatedBookings = bookingDetails.subList(startIndex, endIndex);

        request.setAttribute("confirmedBookings", paginatedBookings);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("/fieldOwner/confirmBookings.jsp").forward(request, response);
    }
}
