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

        // Check total price of previously ordered food
        FoodOrderDAO foodOrderDAO = new FoodOrderDAO();
        double existingFoodTotal = foodOrderDAO.getFoodOrderTotal(bookingId);

        // Insert new food order if the cart is not empty
        if (!cart.isEmpty()) {
            int foodOrderId = foodOrderDAO.createFoodOrder(userId, stadiumId, bookingId, cartFoodTotal);
            if (foodOrderId != -1) {
                foodOrderDAO.insertOrderItems(foodOrderId, cart);
                foodOrderDAO.reduceStock(cart);
            }
        }

        double totalAmount = ticketPrice + existingFoodTotal + cartFoodTotal;

        if ("offline".equalsIgnoreCase(method)) {
            PaymentDAO paymentDAO = new PaymentDAO();
            boolean success = paymentDAO.createPayment(
                bookingId, totalAmount, "CashOnArrival", "Pending", null
            );

            if (!success) {
                throw new RuntimeException("Failed to record payment");
            }

            // Update booking status to Confirmed
            bookingDAO.updateBookingStatus(bookingId, "Confirmed");

            // Send confirmation email
            try {
                String email = currentUser.getEmail();
                String subject = "Booking Confirmation #" + bookingId;

                String message = String.format(
                    "Hello %s,\n\n" +
                    "Your booking has been confirmed!\n\n" +
                    "➤ Booking ID: #%d\n" +
                    "➤ Field Ticket Price: %,.0f VND\n" +
                    "➤ Food Total: %,.0f VND\n" +
                    "➤ Total Payment: %,.0f VND\n\n" +
                    "Payment Method: Pay at the field (CashOnArrival)\n\n" +
                    "Thank you for using our service!",
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

            // Show success page
            request.setAttribute("ticketPrice", ticketPrice);
            request.setAttribute("foodPrice", existingFoodTotal + cartFoodTotal);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("bookingId", bookingId);
            request.setAttribute("stadiumId", stadiumId);
            request.setAttribute("paymentMethod", method);

            session.removeAttribute("cart");

            request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
            return;
        }

        // For VNPay or other methods, go to confirmation page
        request.setAttribute("ticketPrice", ticketPrice);
        request.setAttribute("foodPrice", existingFoodTotal + cartFoodTotal);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("stadiumId", stadiumId);
        request.setAttribute("paymentMethod", method);

        request.getRequestDispatcher("/order-confirm.jsp").forward(request, response);
    }
}
