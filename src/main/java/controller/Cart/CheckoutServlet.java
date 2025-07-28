package controller.Cart;

import dao.BookingDAO;
import dao.FoodOrderDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;
import model.CartItem;
import model.User;
import service.EmailService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();

        int userId = currentUser.getUserID();
        int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String method = request.getParameter("method");

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(bookingId);
        double ticketPrice = (booking != null) ? booking.getPrice() : 0;

        double cartFoodTotal = 0;
        for (CartItem item : cart) {
            cartFoodTotal += item.getFoodItem().getPrice() * item.getQuantity();
        }

        // Tổng món ăn đã đặt trước đó
        FoodOrderDAO foodOrderDAO = new FoodOrderDAO();
        double existingFoodTotal = foodOrderDAO.getFoodOrderTotal(bookingId);

        // Ghi đơn món mới nếu có
        if (!cart.isEmpty()) {
            int foodOrderId = foodOrderDAO.createFoodOrder(userId, stadiumId, bookingId, cartFoodTotal);
            if (foodOrderId != -1) {
                foodOrderDAO.insertOrderItems(foodOrderId, cart);
                foodOrderDAO.reduceStock(cart);
            }
        }

        double totalAmount = ticketPrice + existingFoodTotal + cartFoodTotal;

        // ✅ Truyền thông tin cho cả hai trường hợp VNPay và Cash
        request.setAttribute("ticketPrice", ticketPrice);
        request.setAttribute("foodPrice", existingFoodTotal + cartFoodTotal);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("stadiumId", stadiumId);
        request.setAttribute("paymentMethod", method);

        request.setAttribute("customerName", currentUser.getFullName());
        request.setAttribute("customerPhone", currentUser.getPhone());
        request.setAttribute("customerEmail", currentUser.getEmail());

        request.setAttribute("bookingDate", booking.getFormattedCreatedAt().split(" ")[0]); // "dd/MM/yyyy"
        request.setAttribute("bookingTime", booking.getTimeSlot());
        request.setAttribute("subdivision", booking.getStadiumName()); // Đặt tên sân/khu

        if (booking.getTotalAmount() < totalAmount) {
            request.setAttribute("discountedTotalAmount", booking.getTotalAmount());
        }

        if ("offline".equalsIgnoreCase(method)) {
            PaymentDAO paymentDAO = new PaymentDAO();
            boolean success = paymentDAO.createPayment(
                bookingId, totalAmount, "CashOnArrival", "Pending", null
            );

            if (!success) {
                throw new RuntimeException("Không thể ghi nhận thanh toán");
            }

            bookingDAO.updateBookingStatus(bookingId, "Confirmed");

            // Gửi email
            try {
                String email = currentUser.getEmail();
                String subject = "Xác nhận đơn đặt sân #" + bookingId;

                String message = String.format(
                    "Chào %s,\n\n" +
                    "Bạn đã đặt sân thành công!\n\n" +
                    "➤ Mã đặt sân: #%d\n" +
                    "➤ Giá vé sân: %,.0f đ\n" +
                    "➤ Tổng tiền đồ ăn: %,.0f đ\n" +
                    "➤ Tổng thanh toán: %,.0f đ\n\n" +
                    "Hình thức thanh toán: Thanh toán tại sân (CashOnArrival)\n\n" +
                    "Cảm ơn bạn đã sử dụng dịch vụ!",
                    currentUser.getFullName(),
                    bookingId,
                    ticketPrice,
                    existingFoodTotal + cartFoodTotal,
                    totalAmount
                );

                EmailService.sendEmail(email, subject, message);
            } catch (Exception e) {
                e.printStackTrace();
            }

            session.removeAttribute("cart");

            request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
            return;
        }

        // Nếu là VNPay
        request.getRequestDispatcher("/order-confirm.jsp").forward(request, response);
    }
}
