package controller.FieldOwner;

import dao.BookingDAO;
import dao.PaymentDAO;
import dao.TimeSlotDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.TimeSlot;
import model.User;

import java.io.IOException;

@WebServlet("/UpdateTimeSlotServlet")
public class UpdateTimeSlotServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");
        int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        TimeSlotDAO timeSlotDAO = new TimeSlotDAO();
        BookingDAO bookingDAO = new BookingDAO();
        PaymentDAO paymentDAO = new PaymentDAO(); // Thêm đối tượng PaymentDAO

        if ("book".equals(action)) {
            String[] selectedTimeSlotIds = request.getParameterValues("timeSlotIds");
            if (selectedTimeSlotIds == null || selectedTimeSlotIds.length == 0) {
                response.getWriter().write("Vui lòng chọn ít nhất một khung giờ.");
                return;
            }

            // Tính tổng giá vé sân
            double ticketPrice = 0;
            for (String timeSlotIdStr : selectedTimeSlotIds) {
                int timeSlotId = Integer.parseInt(timeSlotIdStr);
                TimeSlot ts = timeSlotDAO.getTimeSlotById(timeSlotId);
                if (ts != null && ts.isActive()) {
                    ticketPrice += ts.getPrice();
                }
            }

            double totalAmount = ticketPrice;

            // Tạo Booking mới
            int userId = currentUser.getUserID();
            int bookingId = bookingDAO.createBooking(userId, ticketPrice, totalAmount);
            if (bookingId == -1) {
                response.getWriter().write("Lỗi tạo đơn đặt sân.");
                return;
            }

            // Gán các TimeSlot vào Booking
            for (String timeSlotIdStr : selectedTimeSlotIds) {
                int timeSlotId = Integer.parseInt(timeSlotIdStr);
                bookingDAO.insertBookingTimeSlot(bookingId, timeSlotId);
                timeSlotDAO.updateTimeSlotStatus(timeSlotId, true); // booked = true
            }

            // Cập nhật trạng thái Booking thành "Completed"
            bookingDAO.updateBookingStatus(bookingId, "Completed");

            // Tạo Payment
            String paymentMethod = "Offline"; // Phương thức thanh toán
            String status = "Completed"; // Trạng thái thanh toán
            String transactionId = "MANUAL_BOOKING_" + bookingId; // ID giao dịch tùy chỉnh
            boolean isPaymentCreated = paymentDAO.createPayment(bookingId, totalAmount, paymentMethod, status, transactionId);

            if (!isPaymentCreated) {
                response.getWriter().write("Lỗi tạo thanh toán.");
                return;
            }

            // Truyền dữ liệu sang JSP
            request.setAttribute("ticketPrice", ticketPrice);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("message", "✅ Đặt thủ công thành công!");

            request.getRequestDispatcher("/payment-success.jsp").forward(request, response);

        } else if ("toggleActive".equals(action)) {
            String[] selectedTimeSlotIds = request.getParameterValues("timeSlotIds");
            if (selectedTimeSlotIds == null || selectedTimeSlotIds.length == 0) {
                response.getWriter().write("Vui lòng chọn ít nhất một khung giờ.");
                return;
            }

            // Lấy trạng thái hiện tại của TimeSlot đầu tiên để toggle
            int exampleId = Integer.parseInt(selectedTimeSlotIds[0]);
            TimeSlot exampleTS = timeSlotDAO.getTimeSlotById(exampleId);
            boolean targetStatus = !exampleTS.isActive(); // Toggle trạng thái

            // Áp dụng cho tất cả TimeSlot được chọn
            for (String timeSlotIdStr : selectedTimeSlotIds) {
                int timeSlotId = Integer.parseInt(timeSlotIdStr);
                timeSlotDAO.updateTimeSlotStatus(timeSlotId, targetStatus);
            }

            // Chuyển hướng lại trang để load lại dữ liệu
            String redirectURL = request.getContextPath() + "/LoadTimeSlotsServlet?stadiumId=" + stadiumId + "&week=current";
            response.sendRedirect(redirectURL);
        }
    }
}