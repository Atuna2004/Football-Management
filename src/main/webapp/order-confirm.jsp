<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-blue: #2563eb;
            --light-blue: #3b82f6;
            --lighter-blue: #60a5fa;
            --blue-50: #eff6ff;
            --blue-100: #dbeafe;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-600: #4b5563;
            --gray-900: #111827;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--gray-50);
            color: var(--gray-900);
            line-height: 1.6;
            padding: 2rem 1rem;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .payment-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
            border: 1px solid #e5e7eb;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            text-align: center;
            margin-bottom: 2.5rem;
            color: var(--primary-blue);
        }

        .section-title {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--gray-900);
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--blue-100);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: var(--primary-blue);
        }

        .info-group {
            background: var(--blue-50);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 1px solid var(--blue-100);
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--blue-100);
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 500;
            color: var(--gray-600);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-label i {
            color: var(--primary-blue);
            width: 16px;
        }

        .info-value {
            font-weight: 500;
            color: var(--gray-900);
        }

        .price-value {
            font-weight: 600;
            color: var(--primary-blue);
            font-size: 1.125rem;
        }

        .payment-section {
            margin-top: 2rem;
        }

        .payment-button {
            width: 100%;
            padding: 1rem 1.5rem;
            font-size: 1rem;
            font-weight: 500;
            border-radius: 8px;
            border: none;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-cash {
            background-color: white;
            color: var(--primary-blue);
            border: 2px solid var(--primary-blue);
        }

        .btn-cash:hover {
            background-color: var(--primary-blue);
            color: white;
        }

        .btn-vnpay {
            background-color: var(--primary-blue);
            color: white;
        }

        .btn-vnpay:hover {
            background-color: var(--light-blue);
            color: white;
        }

        .map-container {
            margin-top: 1.5rem;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid var(--blue-100);
        }

        .map-wrapper iframe {
            width: 100%;
            height: 200px;
            border: none;
        }

        .contact-info {
            background: var(--blue-50);
            border: 1px solid var(--blue-100);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .contact-icon {
            width: 40px;
            height: 40px;
            background: var(--primary-blue);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .contact-text {
            flex: 1;
        }

        .contact-label {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 500;
        }

        .contact-value {
            font-weight: 600;
            color: var(--gray-900);
        }

        @media (max-width: 768px) {
            body {
                padding: 1rem 0.5rem;
            }

            .payment-card {
                padding: 2rem 1.5rem;
                border-radius: 12px;
            }

            .page-title {
                font-size: 1.75rem;
                margin-bottom: 2rem;
            }

            .row > div {
                margin-bottom: 2rem;
            }

            .info-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.25rem;
                padding: 1rem 0;
            }
        }

        @media (max-width: 480px) {
            .payment-card {
                padding: 1.5rem 1rem;
            }

            .page-title {
                font-size: 1.5rem;
            }

            .payment-button {
                padding: 0.875rem 1.25rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="payment-card">
            <h3 class="page-title">Xác nhận thanh toán</h3>

            <div class="row">
                <!-- LEFT COLUMN -->
                <div class="col-md-6">
                    <!-- PERSONAL DATA -->
                    <div class="section-title">
                        <i class="fas fa-user"></i>
                        Thông tin khách hàng
                    </div>
                    
                    <div class="info-group">
                        <div class="info-item">
                            <span class="info-label">
                                <i class="fas fa-id-card"></i>
                                Họ tên
                            </span>
                            <span class="info-value">${customerName}</span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">
                                <i class="fas fa-phone"></i>
                                SĐT
                            </span>
                            <span class="info-value">${customerPhone}</span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">
                                <i class="fas fa-envelope"></i>
                                Email
                            </span>
                            <span class="info-value">${customerEmail}</span>
                        </div>
                    </div>

                        
                    <!-- FORM NHẬP MÃ GIẢM GIÁ -->
<div class="section-title payment-section">
    <i class="fas fa-ticket-alt"></i>
    Nhập mã giảm giá
</div>

<form method="get" action="${pageContext.request.contextPath}/checkout">
    <input type="hidden" name="stadiumId" value="${stadiumId}" />
    <input type="hidden" name="bookingId" value="${bookingId}" />
    <div class="input-group mb-3">
        <input type="text" class="form-control" name="discountCode"
               placeholder="Nhập mã (nếu có)" value="${discountCode}" />
        <button class="btn btn-outline-primary" type="submit">Áp dụng</button>
    </div>
</form>

                        
                    <!-- PAYMENT INFO -->
                    <div class="section-title payment-section">
                        <i class="fas fa-credit-card"></i>
                        Phương thức thanh toán
                    </div>

                    <form action="${pageContext.request.contextPath}/checkout" method="post" onsubmit="return confirmCashPayment();">
                        <input type="hidden" name="stadiumId" value="${stadiumId}" />
                        <input type="hidden" name="bookingId" value="${bookingId}" />
                        <input type="hidden" name="method" value="offline" />
                        <input type="hidden" name="discountCode" value="${discountCode}" />
                        <input type="hidden" name="totalAmount" value="${discountedTotalAmount != null ? discountedTotalAmount : totalAmount}" />
                        <button type="submit" class="payment-button btn-cash">
                            <i class="fas fa-money-bill-wave"></i>
                            Thanh toán tại sân
                        </button>
                    </form>

                    <form action="${pageContext.request.contextPath}/payment" method="post" onsubmit="return confirmVNPayPayment();">
                        <input type="hidden" name="stadiumId" value="${stadiumId}" />
                        <input type="hidden" name="bookingId" value="${bookingId}" />
                        <input type="hidden" name="method" value="vnpay" />
                        <input type="hidden" name="discountCode" value="${discountCode}" />
                        <input type="hidden" name="totalAmount" value="${discountedTotalAmount != null ? discountedTotalAmount : totalAmount}" />
                        <button type="submit" class="payment-button btn-vnpay">
                            <i class="fab fa-cc-visa"></i>
                            Thanh toán qua VNPay
                        </button>
                    </form>
                </div>

                <!-- RIGHT COLUMN -->
                <div class="col-md-6">
                    <!-- BOOKING INFO -->
                    <div class="section-title">
                        <i class="fas fa-calendar-check"></i>
                        Thông tin đặt sân
                    </div>
                    
                    <div class="info-group">
                        <div class="info-item">
                            <span class="info-label">
                                <i class="fas fa-map-marker-alt"></i>
                                Khu
                            </span>
                            <span class="info-value">${subdivision}</span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">
                                <i class="fas fa-tags"></i>
                                Giá
                            </span>
                            <span class="price-value">
                                <fmt:formatNumber value="${discountedTotalAmount != null ? discountedTotalAmount : totalAmount}" type="number" groupingUsed="true"/> đ
                            </span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">
                                <i class="fas fa-calendar"></i>
                                Ngày
                            </span>
                            <span class="info-value">${bookingDate}</span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">
                                <i class="fas fa-clock"></i>
                                Thời gian
                            </span>
                            <span class="info-value">${bookingTime}</span>
                        </div>
                    </div>

                    <div class="map-container">
                        <div class="map-wrapper">
                            <iframe src="https://www.google.com/maps?q=Dan+Sport+Center+(B%C3%B3ng+%C4%90%C3%A1)&output=embed"></iframe>
                        </div>
                    </div>

                    <div class="contact-info">
                        <div class="contact-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="contact-text">
                            <div class="contact-label">Hotline hỗ trợ</div>
                            <div class="contact-value">0935414999</div>
                        </div>
                    </div>
                </div>
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