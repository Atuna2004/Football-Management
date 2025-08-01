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
import service.EmailService;
import service.QRGenerator;

import java.io.File;
import java.io.IOException;
import java.util.*;

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

        // ✅ Tổng tiền sau giảm giá
        double totalAfterDiscount;
        try {
            totalAfterDiscount = Double.parseDouble(request.getParameter("totalAmount"));
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid totalAmount format", e);
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) throw new ServletException("Không tìm thấy booking ID: " + bookingId);

        double originalTicketPrice = booking.getOriginalAmount();

        // ✅ Tính tiền đồ ăn
        double foodPrice = 0;
        for (CartItem item : cart) {
            foodPrice += item.getFoodItem().getPrice() * item.getQuantity();
        }

        // ✅ Ghi đơn đồ ăn
        FoodOrderDAO foodOrderDAO = new FoodOrderDAO();
        if (!cart.isEmpty()) {
            int foodOrderId = foodOrderDAO.createFoodOrder(userId, stadiumId, bookingId, foodPrice);
            if (foodOrderId == -1) throw new ServletException("Lỗi tạo đơn đồ ăn");
            foodOrderDAO.insertOrderItems(foodOrderId, cart);
            foodOrderDAO.reduceStock(cart);
        }

        // ✅ Cập nhật Booking.TotalAmount
        boolean updated = bookingDAO.updateTotalAmount(bookingId, totalAfterDiscount);
        if (!updated) throw new ServletException("Lỗi cập nhật tổng tiền booking");

        // ✅ Ghi thanh toán vào Payment
        PaymentDAO paymentDAO = new PaymentDAO();
        boolean paid = paymentDAO.createPayment(bookingId, totalAfterDiscount, "CashOnArrival", "Pending", null);
        if (!paid) throw new ServletException("Lỗi ghi thanh toán");

        // ✅ Xoá giỏ hàng
        session.removeAttribute("cart");

        // ✅ Gửi email xác nhận + QR
        try {
            String fullName = currentUser.getFullName();
            String email = currentUser.getEmail();

            String subject = "✅ Xác nhận đặt sân - Thanh toán tại sân - #" + bookingId;
            String body = String.format(
                "Chào %s,\n\nBạn đã đặt sân thành công với hình thức thanh toán tại sân.\n\n" +
                "➤ Giá vé sân: %,.0f đ\n" +
                "➤ Đồ ăn: %,.0f đ\n" +
                "➤ Tổng cộng: %,.0f đ\n\n" +
                "Vui lòng thanh toán tại sân và sử dụng mã QR để check-in.",
                fullName, totalAfterDiscount - foodPrice, foodPrice, totalAfterDiscount
            );

            // QR checkin
            String checkinToken = UUID.randomUUID().toString();
            bookingDAO.updateCheckinToken(bookingId, checkinToken);

            String baseUrl = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
            String checkinUrl = baseUrl + "/checkin?token=" + checkinToken;

            String qrPath = getServletContext().getRealPath("/") + "qr_checkin_" + bookingId + ".png";
            File qrFile = QRGenerator.generateQRCodeImage(checkinUrl, qrPath);

            EmailService.sendEmail(email, subject, body);
            new EmailService().sendCheckinQRCodeEmail(email, fullName, bookingId, qrFile, checkinUrl);

        } catch (Exception e) {
            System.err.println("❌ Lỗi gửi email xác nhận/QR:");
            e.printStackTrace();
        }

        // ✅ Chuyển đến trang thành công
        request.setAttribute("originalTicketPrice", originalTicketPrice);
        request.setAttribute("ticketPrice", totalAfterDiscount - foodPrice);
        request.setAttribute("foodPrice", foodPrice);
        request.setAttribute("totalAmount", totalAfterDiscount);
        request.setAttribute("paymentMethod", "offline");

        request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
    }
}
