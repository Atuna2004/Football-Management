package controller.Payment;

import dao.BookingDAO;
import dao.FoodOrderDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;
import model.CartItem;
import model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/confirm-cash")
public class ConfirmCashServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        // ✅ Nhận giá đã giảm (nếu có)
        String totalRaw = request.getParameter("totalAmount");
        double totalAfterDiscount = (totalRaw != null) ? Double.parseDouble(totalRaw) : 0;

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(bookingId);
        double ticketPrice = (booking != null) ? booking.getPrice() : 0;

        double cartFoodTotal = 0;
        for (CartItem item : cart) {
            cartFoodTotal += item.getFoodItem().getPrice() * item.getQuantity();
        }

        // ✅ Ghi đơn món mới nếu có
        FoodOrderDAO foodOrderDAO = new FoodOrderDAO();
        if (!cart.isEmpty()) {
            int foodOrderId = foodOrderDAO.createFoodOrder(userId, stadiumId, bookingId, cartFoodTotal);
            if (foodOrderId != -1) {
                foodOrderDAO.insertOrderItems(foodOrderId, cart);
                foodOrderDAO.reduceStock(cart);
            }
        }

        // ✅ Cập nhật lại totalAmount vào bảng Booking (QUAN TRỌNG)
        bookingDAO.updateTotalAmount(bookingId, totalAfterDiscount);

        // ✅ Ghi thanh toán
        PaymentDAO paymentDAO = new PaymentDAO();
        boolean success = paymentDAO.createPayment(bookingId, totalAfterDiscount, "CashOnArrival", "Pending", null);

        if (!success) {
            throw new RuntimeException("Không thể ghi dữ liệu thanh toán");
        }

        // ✅ Xoá giỏ hàng
        session.removeAttribute("cart");

        // ✅ Trả dữ liệu sang payment-success.jsp
        request.setAttribute("ticketPrice", ticketPrice);
        request.setAttribute("foodPrice", cartFoodTotal);
        request.setAttribute("totalAmount", totalAfterDiscount);
        request.setAttribute("paymentMethod", "offline");

        request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
    }
}

