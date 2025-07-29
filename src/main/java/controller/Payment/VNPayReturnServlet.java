package controller.Payment;

import dao.BookingDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import service.EmailService;
import service.QRGenerator;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;

@WebServlet("/vnpay_return")
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("===== VNPayReturnServlet START =====");

        // 1. Lấy tham số từ VNPay
        Map<String, String> fields = new HashMap<>();
        req.getParameterMap().forEach((k, v) -> {
            if (!"vnp_SecureHash".equals(k) && !"vnp_SecureHashType".equals(k)) {
                fields.put(k, v[0]);
            }
            System.out.println(k + " = " + v[0]);
        });

        String vnpHash = req.getParameter("vnp_SecureHash");

        // 2. Kiểm tra chữ ký hợp lệ
        List<String> keys = new ArrayList<>(fields.keySet());
        Collections.sort(keys);
        StringBuilder hashData = new StringBuilder();
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            String value = URLEncoder.encode(fields.get(key), "UTF-8");
            hashData.append(key).append("=").append(value);
            if (i < keys.size() - 1) hashData.append("&");
        }

        String calculatedHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
        if (!calculatedHash.equalsIgnoreCase(vnpHash)) {
            req.setAttribute("message", "⚠️ Sai chữ ký!");
            forward(req, resp);
            return;
        }

        // 3. Kiểm tra trạng thái giao dịch
        if (!"00".equals(fields.get("vnp_ResponseCode"))) {
            req.setAttribute("message", "❌ Thanh toán thất bại!");
            forward(req, resp);
            return;
        }

        // 4. Parse thông tin đơn hàng
        String orderInfo = fields.get("vnp_OrderInfo"); // ví dụ: BookingID:123
        int bookingId = Integer.parseInt(orderInfo.split(":")[1].trim());
        String txnRef = fields.get("vnp_TxnRef");

        // 5. Cập nhật trạng thái thanh toán & đơn đặt
        PaymentDAO paymentDAO = new PaymentDAO();
        paymentDAO.updatePaymentStatusByTxnRef(txnRef, "Completed");

        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.updateBookingStatus(bookingId, "Confirmed");

        // 6. Lấy chi tiết thanh toán
        double totalAmount = paymentDAO.getConfirmedBookingAmount(bookingId); // đã bao gồm giảm giá
        double foodAmount = paymentDAO.getFoodOrderTotal(bookingId);          // nguyên giá món ăn
        double ticketOriginal = paymentDAO.getTicketPrice(bookingId);         // giá sân gốc (chưa giảm)

        // 7. Gửi email xác nhận nếu có user
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
                "➤ Tổng sau giảm giá: %,.0f đ\n\n" +
                "Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!",
                fullName, bookingId, ticketOriginal, foodAmount, totalAmount
            );

            try {
                // Gửi email xác nhận
                EmailService.sendEmail(email, subject, body);

                // Tạo mã QR check-in
                String checkinToken = UUID.randomUUID().toString();
                bookingDAO.updateCheckinToken(bookingId, checkinToken);
                System.out.println("BookingID = " + bookingId + ", Token = " + checkinToken);

                String baseUrl = req.getRequestURL().toString().replace(req.getRequestURI(), req.getContextPath());
                String checkinUrl = baseUrl + "/checkin?token=" + checkinToken;

                // Tạo và gửi QR đính kèm
                String qrPath = getServletContext().getRealPath("/") + "qr_checkin_" + bookingId + ".png";
                File qrFile = QRGenerator.generateQRCodeImage(checkinUrl, qrPath);
                EmailService emailService = new EmailService();
                emailService.sendCheckinQRCodeEmail(email, fullName, bookingId, qrFile, checkinUrl);

            } catch (Exception e) {
                System.err.println("❌ Lỗi gửi email xác nhận/QR:");
                e.printStackTrace();
            }
        }

        // 8. Hiển thị thông tin ra JSP
        req.setAttribute("paymentMethod", "vnpay");
        req.setAttribute("ticketPrice", ticketOriginal);    // ✅ luôn là giá gốc
        req.setAttribute("foodPrice", foodAmount);          // ✅
        req.setAttribute("totalAmount", totalAmount);       // ✅ đã giảm
        req.setAttribute("message", "✅ Thanh toán thành công!");

        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/payment-success.jsp").forward(req, resp);
    }
}
