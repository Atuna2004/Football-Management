package controller.Cart;

import dao.BookingDAO;
import dao.FoodOrderDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;
import model.CartItem;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();

            int userId = 1; // TODO: Lấy từ session người dùng đăng nhập
            int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String method = request.getParameter("method");

            // Lấy giá vé sân
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingId);
            double ticketPrice = (booking != null) ? booking.getPrice() : 0;

            // Tính tổng giá đồ ăn
            double totalFood = 0;
            for (CartItem item : cart) {
                totalFood += item.getFoodItem().getPrice() * item.getQuantity();
            }

            double totalAmount = ticketPrice + totalFood;

            // Tạo đơn hàng đồ ăn nếu có món
            FoodOrderDAO foodOrderDAO = new FoodOrderDAO();
            if (!cart.isEmpty()) {
                int foodOrderId = foodOrderDAO.createFoodOrder(userId, stadiumId, bookingId, totalAmount);
                if (foodOrderId != -1) {
                    foodOrderDAO.insertOrderItems(foodOrderId, cart);
                    foodOrderDAO.reduceStock(cart);
                    session.removeAttribute("cart");
                }
            }

            // Nếu chọn thanh toán tại sân
            if ("offline".equalsIgnoreCase(method)) {
                PaymentDAO paymentDAO = new PaymentDAO();
                boolean success = paymentDAO.createPayment(
                        bookingId,
                        totalAmount,
                        "CashOnArrival",
                        "Pending",
                        null // Không có transactionId cho thanh toán tại sân
                );

                if (!success) {
                    throw new RuntimeException("Không thể ghi nhận thanh toán");
                }

                // Chuyển đến trang thành công
                request.setAttribute("ticketPrice", ticketPrice);
                request.setAttribute("foodPrice", totalFood);
                request.setAttribute("totalAmount", totalAmount);
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("stadiumId", stadiumId);

                request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
                return;
            }

            // Nếu chưa chọn phương thức, chuyển sang trang xác nhận để chọn
            request.setAttribute("ticketPrice", ticketPrice);
            request.setAttribute("foodPrice", totalFood);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("bookingId", bookingId);
            request.setAttribute("stadiumId", stadiumId);
            request.getRequestDispatcher("/order-confirm.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
