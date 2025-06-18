package controller.Payment;

import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;

@WebServlet("/vnpay_return")
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("===== VNPayReturnServlet START =====");

        // Bước 1: Lấy tham số & log ra
        Map<String, String> fields = new HashMap<>();
        req.getParameterMap().forEach((k, v) -> {
            System.out.println(k + " = " + v[0]);
            if (!"vnp_SecureHash".equals(k) && !"vnp_SecureHashType".equals(k)) {
                fields.put(k, v[0]);
            }
        });

        String vnpHash = req.getParameter("vnp_SecureHash");

        // Bước 2: Xây dựng lại hashData (đã encode giống PaymentServlet)
        List<String> keys = new ArrayList<>(fields.keySet());
        Collections.sort(keys);
        StringBuilder hashData = new StringBuilder();
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            String value = URLEncoder.encode(fields.get(key), "UTF-8"); // ✅ encode value
            hashData.append(key).append("=").append(value);
            if (i < keys.size() - 1) hashData.append("&");
        }

        // Bước 3: Tính lại hash và so sánh
        String calculatedHash = Config.hmacSHA512(Config.secretKey, hashData.toString());

        System.out.println("calculatedHash = " + calculatedHash);
        System.out.println("received vnpHash = " + vnpHash);

        if (!calculatedHash.equalsIgnoreCase(vnpHash)) {
            req.setAttribute("message", "⚠️ Sai chữ ký!");
            forward(req, resp);
            return;
        }

        // Bước 4: Kiểm tra mã phản hồi từ VNPay
        if (!"00".equals(fields.get("vnp_ResponseCode"))) {
            req.setAttribute("message", "❌ Thanh toán thất bại!");
            forward(req, resp);
            return;
        }

        // Bước 5: Parse dữ liệu
        String orderInfo = fields.get("vnp_OrderInfo");
        int bookingId = Integer.parseInt(orderInfo.split(":")[1].trim());
        String txnRef = fields.get("vnp_TxnRef");

        PaymentDAO dao = new PaymentDAO();
        dao.updatePaymentStatusByTxnRef(txnRef, "Completed");

        double ticketPrice = dao.getTicketPrice(bookingId);
        double foodPrice = dao.getFoodOrderTotal(bookingId);
        double totalAmount = ticketPrice + foodPrice;

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
