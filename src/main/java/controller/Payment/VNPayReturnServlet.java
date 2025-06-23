package controller.Payment;

import dao.BookingDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import service.EmailService;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;

@WebServlet("/vnpay_return")
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("===== VNPayReturnServlet START =====");

        // Bước 1: Lấy tham số từ VNPay & log ra
        Map<String, String> fields = new HashMap<>();
        req.getParameterMap().forEach((k, v) -> {
            System.out.println(k + " = " + v[0]);
            if (!"vnp_SecureHash".equals(k) && !"vnp_SecureHashType".equals(k)) {
                fields.put(k, v[0]);
            }
        });

        String vnpHash = req.getParameter("vnp_SecureHash");

        // Bước 2: Tạo lại hashData
        List<String> keys = new ArrayList<>(fields.keySet());
        Collections.sort(keys);
        StringBuilder hashData = new StringBuilder();
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            String value = URLEncoder.encode(fields.get(key), "UTF-8");
            hashData.append(key).append("=").append(value);
            if (i < keys.size() - 1) hashData.append("&");
        }

        // Bước 3: So sánh chữ ký
        String calculatedHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
        if (!calculatedHash.equalsIgnoreCase(vnpHash)) {
            req.setAttribute("message", "⚠️ Sai chữ ký!");
            forward(req, resp);
            return;
        }

        // Bước 4: Kiểm tra kết quả thanh toán từ VNPay
        if (!"00".equals(fields.get("vnp_ResponseCode"))) {
            req.setAttribute("message", "❌ Thanh toán thất bại!");
            forward(req, resp);
            return;
        }

        // Bước 5: Parse dữ liệu
        String orderInfo = fields.get("vnp_OrderInfo");
        int bookingId = Integer.parseInt(orderInfo.split(":")[1].trim());
        String txnRef = fields.get("vnp_TxnRef");

        // Bước 6: Cập nhật trạng thái thanh toán
        PaymentDAO dao = new PaymentDAO();
        dao.updatePaymentStatusByTxnRef(txnRef, "Completed");

        double ticketPrice = dao.getTicketPrice(bookingId);
        double foodPrice = dao.getFoodOrderTotal(bookingId);
        double totalAmount = ticketPrice + foodPrice;

        // ✅ Cập nhật trạng thái đơn đặt sân sang Confirmed
        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.updateBookingStatus(bookingId, "Confirmed");

        // ✅ Gửi email xác nhận sau thanh toán thành công
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user != null) {
            String email = user.getEmail();
            String fullName = user.getFullName();

            String subject = "✅ Xác nhận thanh toán VNPay thành công - Đơn #" + bookingId;
            String body = String.format(
                "Chào %s,\n\nBạn đã thanh toán thành công đơn đặt sân #%d.\n\n" +
                "➤ Giá vé sân: %,.0f đ\n" +
                "➤ Đồ ăn: %,.0f đ\n" +
                "➤ Tổng cộng: %,.0f đ\n\n" +
                "Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!",
                fullName, bookingId, ticketPrice, foodPrice, totalAmount
            );

            try {
                EmailService.sendEmail(email, subject, body);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // ✅ Truyền dữ liệu sang JSP hiển thị kết quả
        req.setAttribute("paymentMethod", "vnpay");
        req.setAttribute("ticketPrice", ticketPrice);
        req.setAttribute("foodPrice", foodPrice);
        req.setAttribute("totalAmount", totalAmount);
        req.setAttribute("message", "✅ Thanh toán thành công!");

        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/payment-success.jsp").forward(req, resp);
    }
}
