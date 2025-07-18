package controller.FieldOwner;

import dao.BookingDAO;
import dao.FoodOrderDAO;
import dao.PaymentDAO;
import dao.TimeSlotDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.TimeSlot;
import model.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;

@WebServlet("/UpdateTimeSlotServlet")
public class UpdateTimeSlotServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = request.getParameter("action");
        int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
        String week = request.getParameter("week");

        if ("book".equals(action)) {
            String[] selectedTimeSlotIds = request.getParameterValues("timeSlotIds");
            if (selectedTimeSlotIds == null || selectedTimeSlotIds.length == 0) {
                response.getWriter().write("Vui lòng chọn ít nhất một khung giờ.");
                return;
            }

            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/account/login.jsp");
                return;
            }

            int userId = currentUser.getUserID();
            double ticketPrice = 0;

            TimeSlotDAO timeSlotDAO = new TimeSlotDAO();
            BookingDAO bookingDAO = new BookingDAO();
            PaymentDAO paymentDAO = new PaymentDAO();
            FoodOrderDAO foodOrderDAO = new FoodOrderDAO();

            // Lấy giỏ hàng (nếu có)
            @SuppressWarnings("unchecked")
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();

            // Tính tổng giá từ TimeSlot
            for (String timeSlotIdStr : selectedTimeSlotIds) {
                int timeSlotId = Integer.parseInt(timeSlotIdStr);
                TimeSlot ts = timeSlotDAO.getTimeSlotById(timeSlotId);
                if (ts != null && ts.isActive()) {
                    ticketPrice += ts.getPrice();
                }
            }

            // Tính tổng giá đồ ăn từ giỏ hàng
            double totalFood = 0;
            for (CartItem item : cart) {
                totalFood += item.getFoodItem().getPrice() * item.getQuantity();
            }

            double totalAmount = ticketPrice + totalFood;

            // Tạo Booking mới
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

            // Thêm món ăn nếu có
            if (!cart.isEmpty()) {
                int foodOrderId = foodOrderDAO.createFoodOrder(userId, stadiumId, bookingId, totalFood);
                if (foodOrderId != -1) {
                    foodOrderDAO.insertOrderItems(foodOrderId, cart);
                    foodOrderDAO.reduceStock(cart);
                }
            }

            // Cập nhật trạng thái Booking thành "Confirmed"
            bookingDAO.updateBookingStatus(bookingId, "Confirmed");

            // Tạo Payment với trạng thái "Completed"
            boolean paymentSuccess = paymentDAO.createPaymentForManualBooking(bookingId, ticketPrice + totalFood);
            if (!paymentSuccess) {
                response.getWriter().write("Lỗi tạo giao dịch thanh toán.");
                return;
            }

            // Xóa giỏ hàng nếu có
            session.removeAttribute("cart");

            // Chuyển hướng về lại trang quản lý TimeSlot
            request.setAttribute("ticketPrice", ticketPrice);
            request.setAttribute("foodPrice", totalFood);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("message", "✅ Đặt thủ công thành công!");
            request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
        }
    }
}