package controller.Booking;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;
import model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/booking-history")
public class BookingHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login.jsp");
            return;
        }

        // Lấy danh sách booking có kèm thông tin tiền sân + tiền đồ ăn
        List<Booking> bookings = new BookingDAO().getBookingsByUserId(user.getUserID());
        req.setAttribute("bookings", bookings);

        // Forward tới trang hiển thị
        req.getRequestDispatcher("/account/bookingHistory.jsp").forward(req, resp);
    }
}
