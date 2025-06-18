package controller.Payment;

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

@WebServlet("/confirm-cash")
public class ConfirmCashServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();

            int userId = 1; // sau này lấy từ session
            int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));

            // Lấy giá vé
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingId);
            double ticketPrice = (booking != null) ? booking.getPrice() : 0;

            // Tính tiền đồ ăn
            double totalFood = 0;
            for (CartItem item : cart) {
                totalFood += item.getFoodItem().getPrice() * item.getQuantity();
            }

            double totalAmount = ticketPrice + totalFood;

            // Lưu đơn đặt món nếu có
            FoodOrderDAO foodOrderDAO = new FoodOrderDAO();
            if (!cart.isEmpty()) {
                int foodOrderId = foodOrderDAO.createFoodOrder(userId, stadiumId, bookingId, totalAmount);
                if (foodOrderId != -1) {
                    foodOrderDAO.insertOrderItems(foodOrderId, cart);
                    foodOrderDAO.reduceStock(cart);
                }
            }

            session.removeAttribute("cart");

            // Tạo bản ghi Payment
            PaymentDAO paymentDAO = new PaymentDAO();
            boolean success = paymentDAO.createPayment(
                    bookingId,
                    totalAmount,
                    "CashOnArrival",
                    "Pending",
                    null // Không có transaction ID
            );

            if (!success) {
                throw new RuntimeException("Không thể ghi dữ liệu thanh toán");
            }

            request.setAttribute("ticketPrice", ticketPrice);
            request.setAttribute("foodPrice", totalFood);
            request.setAttribute("totalAmount", totalAmount);
            request.getRequestDispatcher("/payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
