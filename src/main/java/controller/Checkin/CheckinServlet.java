package controller.Checkin;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;
import model.User;

import java.io.IOException;

@WebServlet("/checkin")
public class CheckinServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");

        // 1. Kiểm tra token null hoặc rỗng
        if (token == null || token.isEmpty()) {
            req.setAttribute("message", "❌ Mã check-in không hợp lệ.");
            req.getRequestDispatcher("/checkin-failed.jsp").forward(req, resp);
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingByCheckinToken(token);

        // 2. Không tìm thấy đơn
        if (booking == null) {
            req.setAttribute("message", "❌ Không tìm thấy đơn đặt với mã này hoặc mã đã hết hạn.");
            req.getRequestDispatcher("/checkin-failed.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra role người dùng
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user != null) {
            // Dùng hàm kiểm tra role trong User model
            if (user.isAdmin() || user.isFieldOwner()) {
                // → Admin hoặc Owner → chuyển đến trang xác nhận checkin
                resp.sendRedirect(req.getContextPath() + "/admincheck?token=" + token);
                return;
            }
        }

        // 4. Người dùng thường → chỉ xem thông tin
        req.setAttribute("booking", booking);
        req.getRequestDispatcher("/checkin-info.jsp").forward(req, resp);
    }
}
