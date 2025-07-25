<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: #f5f6fa;
            font-family: Arial, sans-serif;
            padding: 40px 20px;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 15px;
            text-transform: uppercase;
            color: #2c3e50;
            border-bottom: 1px solid #ccc;
            padding-bottom: 5px;
        }

        .info-label {
            font-weight: 500;
        }

        .payment-button {
            width: 100%;
            padding: 15px;
            font-size: 1.1rem;
            border-radius: 8px;
            border: none;
            margin-bottom: 15px;
        }

        .btn-cash {
            background-color: #fdcb6e;
            color: #2d3436;
        }

        .btn-cash:hover {
            background-color: #e1b165;
        }

        .btn-vnpay {
            background-color: #00b894;
            color: white;
        }

        .btn-vnpay:hover {
            background-color: #019670;
        }

        .map-wrapper iframe {
            width: 100%;
            border-radius: 8px;
            height: 200px;
            border: none;
        }

        @media (max-width: 768px) {
            .row > div {
                margin-bottom: 30px;
            }
        }
    </style>
</head>
<body>

<div class="container bg-white p-4 rounded shadow">
    <h3 class="text-center mb-4">Xác nhận thanh toán</h3>

    <div class="row">
        <!-- LEFT COLUMN -->
        <div class="col-md-6">
            <!-- PERSONAL DATA -->
            <div class="section-title">Thông tin khách hàng</div>
            <p><span class="info-label">Họ tên:</span> ${customerName}</p>
            <p><span class="info-label">SĐT:</span> ${customerPhone}</p>
            <p><span class="info-label">Email:</span> ${customerEmail}</p>

            <!-- PAYMENT INFO -->
            <div class="section-title">Phương thức thanh toán</div>

            <form action="${pageContext.request.contextPath}/checkout" method="get" onsubmit="return confirmCashPayment();">
                <input type="hidden" name="stadiumId" value="${stadiumId}" />
                <input type="hidden" name="bookingId" value="${bookingId}" />
                <input type="hidden" name="method" value="offline" />
                <button type="submit" class="payment-button btn-cash">
                    <i class="fas fa-money-bill-wave me-2"></i> Thanh toán tại sân
                </button>
            </form>

            <form action="${pageContext.request.contextPath}/payment" method="post" onsubmit="return confirmVNPayPayment();">
                <input type="hidden" name="stadiumId" value="${stadiumId}" />
                <input type="hidden" name="bookingId" value="${bookingId}" />
                <input type="hidden" name="method" value="vnpay" />
                <input type="hidden" name="totalAmount" value="${discountedTotalAmount != null ? discountedTotalAmount : totalAmount}" />
                <button type="submit" class="payment-button btn-vnpay">
                    <i class="fab fa-cc-visa me-2"></i> Thanh toán qua VNPay
                </button>
            </form>
        </div>

        <!-- RIGHT COLUMN -->
        <div class="col-md-6">
            <!-- BOOKING INFO -->
            <div class="section-title">Thông tin đặt sân</div>
            <p><span class="info-label">Khu:</span> ${subdivision}</p>
            <p><span class="info-label">Giá:</span>
                <fmt:formatNumber value="${discountedTotalAmount != null ? discountedTotalAmount : totalAmount}" type="number" groupingUsed="true"/> đ
            </p>
            <p><span class="info-label">Ngày:</span> ${bookingDate}</p>
            <p><span class="info-label">Thời gian:</span> ${bookingTime}</p>

            <div class="map-wrapper mt-3">
                <!-- Google Map iframe nếu cần -->
                <iframe src="https://www.google.com/maps?q=Dan+Sport+Center+(B%C3%B3ng+%C4%90%C3%A1)&output=embed"></iframe>
            </div>

            <p class="mt-2"><span class="info-label">Điện thoại:</span> 0935414999</p>
        </div>
    </div>
</div>

<script>
    function confirmCashPayment() {
        return confirm("💰 Bạn chắc chắn muốn thanh toán tại sân?");
    }

    function confirmVNPayPayment() {
        return confirm("🏦 Bạn chắc chắn muốn thanh toán qua VNPay?");
    }
</script>

</body>
</html>
