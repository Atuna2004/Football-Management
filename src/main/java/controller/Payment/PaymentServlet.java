package controller.Payment;

import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String method = request.getParameter("method");
            String stadiumId = request.getParameter("stadiumId");
            String bookingIdRaw = request.getParameter("bookingId");
            String totalAmountRaw = request.getParameter("totalAmount");

            if (bookingIdRaw == null || totalAmountRaw == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin thanh toán.");
                return;
            }

            int bookingId = Integer.parseInt(bookingIdRaw);
            double amount = Double.parseDouble(totalAmountRaw);

            // VNPay logic
            if ("vnpay".equalsIgnoreCase(method)) {
                String vnp_TxnRef = Config.getRandomNumber(8);
                String vnp_IpAddr = Config.getIpAddress(request);
                String orderType = "other";

                Map<String, String> vnp_Params = new HashMap<>();
                vnp_Params.put("vnp_Version", "2.1.0");
                vnp_Params.put("vnp_Command", "pay");
                vnp_Params.put("vnp_TmnCode", Config.vnp_TmnCode);
                vnp_Params.put("vnp_Amount", String.valueOf((long)(amount * 100)));
                vnp_Params.put("vnp_CurrCode", "VND");
                vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
                vnp_Params.put("vnp_OrderInfo", "BookingID:" + bookingId);
                vnp_Params.put("vnp_OrderType", orderType);
                vnp_Params.put("vnp_Locale", "vn");
                vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
                vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

                // Thời gian tạo + hết hạn
                Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                String createDate = sdf.format(calendar.getTime());
                vnp_Params.put("vnp_CreateDate", createDate);
                calendar.add(Calendar.MINUTE, 15);
                vnp_Params.put("vnp_ExpireDate", sdf.format(calendar.getTime()));

                // Hash + tạo URL
                List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
                Collections.sort(fieldNames);
                StringBuilder hashData = new StringBuilder();
                StringBuilder query = new StringBuilder();
                for (int i = 0; i < fieldNames.size(); i++) {
    String name = fieldNames.get(i);
    String value = vnp_Params.get(name);

    // ✅ BẢN TEST VNPay: hashData CŨNG ENCODE luôn!
    hashData.append(name).append('=').append(URLEncoder.encode(value, "UTF-8"));

    // ✅ query cũng ENCODE
    query.append(URLEncoder.encode(name, "UTF-8"))
         .append('=')
         .append(URLEncoder.encode(value, "UTF-8"));

    if (i < fieldNames.size() - 1) {
        hashData.append('&');
        query.append('&');
    }
}


                String secureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
                query.append("&vnp_SecureHash=").append(secureHash);
                String paymentUrl = Config.vnp_PayUrl + "?" + query;

                // Ghi DB
                boolean saved = new PaymentDAO().createPayment(bookingId, amount, "vnpay", "Pending", vnp_TxnRef);
                if (saved) {
                    response.sendRedirect(paymentUrl);
                } else {
                    response.getWriter().write("❌ Không thể ghi thanh toán vào cơ sở dữ liệu.");
                }
            } else {
                // Trường hợp khác (offline hoặc momo)
                response.getWriter().write("Phương thức chưa hỗ trợ.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "❌ Lỗi server: " + e.getMessage());
        }
    }
}
