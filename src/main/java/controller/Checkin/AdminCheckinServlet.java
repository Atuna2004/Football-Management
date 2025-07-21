package controller.Checkin;

import dao.BookingDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admincheck")
public class AdminCheckinServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");

        if (token == null || token.isEmpty()) {
            req.setAttribute("error", "⚠️ Token không hợp lệ!");
            req.getRequestDispatcher("/admin-checkin.jsp").forward(req, resp);
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingByCheckinToken(token);

        if (booking == null) {
            req.setAttribute("error", "❌ Không tìm thấy đơn với mã check-in này!");
        } else {
            req.setAttribute("booking", booking);
        }

        req.getRequestDispatcher("/admin-checkin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        BookingDAO bookingDAO = new BookingDAO();

        boolean success = bookingDAO.updateBookingStatus(bookingId, "CheckedIn");

        if (success) {
            req.setAttribute("message", "✅ Check-in thành công cho đơn #" + bookingId);
        } else {
            req.setAttribute("error", "❌ Check-in thất bại!");
        }

        Booking booking = bookingDAO.getBookingById(bookingId);
        req.setAttribute("booking", booking);

        req.getRequestDispatcher("/admin-checkin.jsp").forward(req, resp);
    }
}
