<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
* {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated background particles */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
        }

        .particle {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        .particle:nth-child(1) { width: 80px; height: 80px; top: 20%; left: 10%; animation-delay: 0s; }
        .particle:nth-child(2) { width: 60px; height: 60px; top: 60%; left: 70%; animation-delay: 2s; }
        .particle:nth-child(3) { width: 100px; height: 100px; top: 40%; left: 40%; animation-delay: 4s; }
        .particle:nth-child(4) { width: 40px; height: 40px; top: 80%; left: 20%; animation-delay: 1s; }
        .particle:nth-child(5) { width: 70px; height: 70px; top: 10%; left: 80%; animation-delay: 3s; }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0.7; }
            50% { transform: translateY(-20px) rotate(180deg); opacity: 1; }
        }

        .confirm-container {
            position: relative;
            z-index: 10;
            max-width: 800px;
            margin: 0 auto;
        }

        .confirm-box {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 50px;
            border-radius: 24px;
            box-shadow: 
                0 20px 40px rgba(0, 0, 0, 0.1),
                0 0 0 1px rgba(255, 255, 255, 0.1) inset;
            animation: slideUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
        }

        .confirm-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 24px 24px 0 0;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .title-section {
            text-align: center;
            margin-bottom: 40px;
        }

        .main-title {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .credit-icon {
            font-size: 2rem;
            color: #4facfe;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .subtitle {
            color: #6c757d;
            font-size: 1.1rem;
            font-weight: 300;
        }

        .amount-summary {
            background: linear-gradient(135deg, #f8f9ff 0%, #e8f4f8 100%);
            border-radius: 16px;
            padding: 30px;
            margin: 30px 0;
            border: 1px solid rgba(79, 172, 254, 0.1);
            position: relative;
        }

        .amount-summary::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 16px 16px 0 0;
        }

        .amount-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .amount-item:last-child {
            border-bottom: none;
            font-weight: 600;
            font-size: 1.2rem;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .amount-item:hover {
            transform: translateX(5px);
        }

        .amount-label {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .amount-icon {
            font-size: 1.2rem;
            width: 30px;
            text-align: center;
        }

        .amount-value {
            font-weight: 600;
            color: #2d3748;
        }

        .payment-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 40px;
        }

        @media (max-width: 768px) {
            .payment-options {
                grid-template-columns: 1fr;
            }
        }

        .payment-form {
            position: relative;
        }

        .payment-btn {
            width: 100%;
            position: relative;
            padding: 20px 30px;
            border: none;
            border-radius: 16px;
            font-size: 1.1rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            min-height: 70px;
        }

        .payment-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: left 0.5s;
        }

        .payment-btn:hover::before {
            left: 100%;
        }

        .btn-cash {
            background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
            color: #2d3748;
            box-shadow: 0 8px 25px rgba(253, 203, 110, 0.3);
        }

        .btn-cash:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(253, 203, 110, 0.4);
            color: #2d3748;
        }

        .btn-vnpay {
            background: linear-gradient(135deg, #00b894 0%, #00a085 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(0, 184, 148, 0.3);
        }

        .btn-vnpay:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 184, 148, 0.4);
            color: white;
        }

        .btn-icon {
            font-size: 1.3rem;
            transition: transform 0.3s ease;
        }

        .payment-btn:hover .btn-icon {
            transform: scale(1.2);
        }

        /* Loading animation */
        .loading {
            pointer-events: none;
            opacity: 0.7;
        }

        .loading .btn-icon {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .confirm-box {
                padding: 30px 20px;
                margin: 20px;
            }
            
            .main-title {
                font-size: 2rem;
            }
            
            .amount-summary {
                padding: 20px;
            }
        }

        /* Ripple effect */
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: scale(0);
            animation: ripple-animation 0.6s linear;
            pointer-events: none;
        }

        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }

        /* Notification styles */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            transform: translateX(400px);
            transition: transform 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .notification.show {
            transform: translateX(0);
        }

        .notification.success {
            border-left: 4px solid #00b894;
        }

        .notification.info {
            border-left: 4px solid #4facfe;
        }
    </style>
</head>
<body>

    <div class="confirm-container">
        <div class="confirm-box">
            <div class="title-section">
                <h1 class="main-title">
                    <i class="fas fa-credit-card credit-icon"></i>
                    Xác nhận thanh toán
                </h1>
                <p class="subtitle">Vui lòng kiểm tra thông tin và chọn phương thức thanh toán</p>
            </div>

            <div class="amount-summary">
                <!-- Giá vé sân (đã giảm nếu có) -->
                <c:choose>
                    <c:when test="${not empty discountedTicketPrice}">
                        <div class="amount-item">
                            <div class="amount-label">
                                <i class="fas fa-ticket-alt amount-icon" style="color: #0984e3;"></i>
                                <span>Giá vé sân (đã giảm)</span>
                            </div>
                            <div class="amount-value">
                                <fmt:formatNumber value="${discountedTicketPrice}" type="number" groupingUsed="true" /> đ
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="amount-item">
                            <div class="amount-label">
                                <i class="fas fa-ticket-alt amount-icon" style="color: #e17055;"></i>
                                <span>Giá vé sân</span>
                            </div>
                            <div class="amount-value">
                                <fmt:formatNumber value="${ticketPrice}" type="number" groupingUsed="true" /> đ
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Giá đồ ăn -->
                <!-- Giá đồ ăn (đã giảm nếu có) -->
                <c:choose>
                    <c:when test="${not empty discountedFoodPrice}">
                        <div class="amount-item">
                            <div class="amount-label">
                                <i class="fas fa-hamburger amount-icon" style="color: #fdcb6e;"></i>
                                <span>Giá đồ ăn (đã giảm)</span>
                            </div>
                            <div class="amount-value">
                                <fmt:formatNumber value="${discountedFoodPrice}" type="number" groupingUsed="true" /> đ
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="amount-item">
                            <div class="amount-label">
                                <i class="fas fa-hamburger amount-icon" style="color: #fdcb6e;"></i>
                                <span>Giá đồ ăn</span>
                            </div>
                            <div class="amount-value">
                                <fmt:formatNumber value="${foodPrice}" type="number" groupingUsed="true" /> đ
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Form áp dụng mã giảm giá -->
                <form action="${pageContext.request.contextPath}/apply-discount" method="post" class="mb-4">
                    <input type="hidden" name="bookingId" value="${bookingId}" />
                    <input type="hidden" name="stadiumId" value="${stadiumId}" />
                    <div class="input-group">
                        <input type="text" name="discountCode" class="form-control" placeholder="Nhập mã giảm giá..." required>
                        <button type="submit" class="btn btn-primary">Áp dụng</button>
                    </div>
                    <c:if test="${not empty discountMessage}">
                        <div class="mt-2 text-success">${discountMessage}</div>
                    </c:if>
                    <c:if test="${not empty discountError}">
                        <div class="mt-2 text-danger">${discountError}</div>
                    </c:if>
                </form>

                <!-- Tổng cộng -->
                <div class="amount-item">
                    <div class="amount-label">
                        <i class="fas fa-wallet amount-icon" style="color: #00b894;"></i>
                        <span>Tổng cộng</span>
                    </div>
                    <div class="amount-value">
                        <fmt:formatNumber value="${discountedTotalAmount != null ? discountedTotalAmount : totalAmount}" type="number" groupingUsed="true" /> đ
                    </div>
                </div>
            </div>

            <!-- Phương thức thanh toán -->
            <div class="payment-options">
                <!-- Thanh toán tại sân -->
                <div class="payment-form">
                    <form id="cashForm" action="${pageContext.request.contextPath}/checkout" method="get">
                        <input type="hidden" name="stadiumId" value="${stadiumId}" />
                        <input type="hidden" name="bookingId" value="${bookingId}" />
                        <input type="hidden" name="method" value="offline" />
                        <button type="submit" onclick="return confirmCashPayment()" class="payment-btn btn-cash">
                            <i class="fas fa-money-bill-wave btn-icon"></i>
                            <span>Thanh toán tại sân</span>
                        </button>
                    </form>
                </div>

                <!-- Thanh toán VNPay -->
                <div class="payment-form">
                    <form id="vnpayForm" action="${pageContext.request.contextPath}/payment" method="post">
                        <input type="hidden" name="stadiumId" value="${stadiumId}" />
                        <input type="hidden" name="bookingId" value="${bookingId}" />
                        <input type="hidden" name="totalAmount" value="${discountedTotalAmount != null ? discountedTotalAmount : totalAmount}" />
                        <input type="hidden" name="method" value="vnpay" />
                        <button type="submit" onclick="return confirmVNPayPayment()" class="payment-btn btn-vnpay">
                            <i class="fab fa-cc-visa btn-icon"></i>
                            <span>Thanh toán qua VNPay</span>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Xác nhận JS -->
    <script>
        function confirmCashPayment() {
            return confirm("💰 Bạn có chắc muốn thanh toán tại sân?\n\nBạn sẽ cần thanh toán trực tiếp khi đến sân.");
        }

        function confirmVNPayPayment() {
            return confirm("🏦 Bạn có chắc muốn thanh toán qua VNPay?\n\nBạn sẽ được chuyển đến cổng thanh toán.");
        }
    </script>
</body>
</html>  