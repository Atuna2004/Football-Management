package controller.Payment;

import dao.BookingDAO;
import dao.DiscountDAO;
import dao.FoodOrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;
import model.CartItem;
import model.Discount;

import java.io.IOException;
import java.util.List;

@WebServlet("/apply-discount")
public class ApplyDiscountServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
            String discountCode = request.getParameter("discountCode").trim();

            HttpSession session = request.getSession(false);
            BookingDAO bookingDAO = new BookingDAO();
            DiscountDAO discountDAO = new DiscountDAO();
            FoodOrderDAO foodOrderDAO = new FoodOrderDAO();

            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking == null) {
                request.setAttribute("discountError", "Không tìm thấy đặt sân.");
                forwardToPage(request, response, stadiumId, bookingId, 0);
                return;
            }

            // Tính tiền đồ ăn (ưu tiên lấy từ cart)
            double foodPrice = 0;
            List<CartItem> cart = (session != null) ? (List<CartItem>) session.getAttribute("cart") : null;
            if (cart != null && !cart.isEmpty()) {
                for (CartItem item : cart) {
                    foodPrice += item.getFoodItem().getPrice() * item.getQuantity();
                }
            } else {
                foodPrice = foodOrderDAO.getFoodOrderTotal(bookingId);
            }

            Discount discount = discountDAO.getDiscountByCode(discountCode);
            if (discount == null) {
                request.setAttribute("discountError", "Mã giảm giá không hợp lệ hoặc đã hết hạn.");
                forwardToPage(request, response, stadiumId, bookingId, foodPrice);
                return;
            }

            double discountPercent = discount.getPercentage() / 100.0;
            double ticketPrice = booking.getOriginalAmount();

            double discountedTicketPrice = ticketPrice * (1 - discountPercent);
            double discountedFoodPrice = foodPrice * (1 - discountPercent);
            double totalAfterDiscount = discountedTicketPrice + discountedFoodPrice;

            boolean success = bookingDAO.applyDiscountCode(bookingId, discount.getDiscountCodeID(), totalAfterDiscount);
            if (success) {
                request.setAttribute("discountMessage", "Áp dụng mã thành công (-" + discount.getPercentage() + "% toàn bộ)");
                request.setAttribute("discountedTicketPrice", discountedTicketPrice);
                request.setAttribute("discountedFoodPrice", discountedFoodPrice);
                request.setAttribute("discountedTotalAmount", totalAfterDiscount);
            } else {
                request.setAttribute("discountError", "Không thể áp dụng mã giảm giá.");
                request.setAttribute("ticketPrice", ticketPrice);
                request.setAttribute("foodPrice", foodPrice);
                request.setAttribute("totalAmount", ticketPrice + foodPrice);
            }

            forwardToPage(request, response, stadiumId, bookingId, foodPrice);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("discountError", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/order-confirm.jsp").forward(request, response);
        }
    }

    private void forwardToPage(HttpServletRequest request, HttpServletResponse response,
                               int stadiumId, int bookingId, double originalFoodPrice)
            throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(bookingId);

        if (booking != null) {
            double ticketPrice = booking.getOriginalAmount();
            request.setAttribute("ticketPrice", ticketPrice);

            // Nếu chưa có giá giảm thì dùng giá gốc
            if (request.getAttribute("discountedTicketPrice") == null) {
                request.setAttribute("discountedTicketPrice", ticketPrice);
            }
            if (request.getAttribute("discountedFoodPrice") == null) {
                request.setAttribute("discountedFoodPrice", originalFoodPrice);
            }
            if (request.getAttribute("discountedTotalAmount") == null) {
                request.setAttribute("totalAmount", booking.getTotalAmount());
            }
        }

        request.setAttribute("stadiumId", stadiumId);
        request.setAttribute("bookingId", bookingId);
        request.getRequestDispatcher("/order-confirm.jsp").forward(request, response);
    }
}
