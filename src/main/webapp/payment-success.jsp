<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-blue: #0066ff;
            --light-blue: #e6f2ff;
            --blue-50: #f0f8ff;
            --gray-50: #fafbfc;
            --gray-600: #4b5563;
            --gray-900: #1a202c;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--gray-50);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }

        .success-container {
            max-width: 600px;
            width: 100%;
        }

        .success-box {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            padding: 3rem;
            text-align: center;
            border: 1px solid #e5e7eb;
        }

        .success-icon {
            width: 60px;
            height: 60px;
            background-color: var(--primary-blue);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 1.5rem;
        }

        .success-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--primary-blue);
        }

        .success-message {
            font-size: 1rem;
            color: var(--gray-600);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .payment-method-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--light-blue);
            color: var(--primary-blue);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .summary-card {
            background: var(--blue-50);
            border-radius: 12px;
            padding: 1.5rem;
            margin: 2rem 0;
            text-align: left;
        }

        .summary-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
        }

        .summary-item:not(:last-child) {
            border-bottom: 1px solid rgba(0, 102, 255, 0.1);
        }

        .summary-item:last-child {
            font-weight: 600;
            color: var(--primary-blue);
            padding-top: 1rem;
        }

        .summary-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gray-600);
            font-size: 0.95rem;
        }

        .summary-label i {
            color: var(--primary-blue);
            width: 16px;
        }

        .summary-value {
            font-weight: 500;
            color: var(--gray-900);
        }

        .home-button {
            background-color: var(--primary-blue);
            color: white;
            border: none;
            padding: 0.875rem 1.5rem;
            font-size: 1rem;
            font-weight: 500;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.2s ease;
        }

        .home-button:hover {
            background-color: #0052cc;
            color: white;
        }

        @media (max-width: 768px) {
            body {
                padding: 1rem 0.5rem;
            }

            .success-box {
                padding: 2rem 1.5rem;
            }

            .success-title {
                font-size: 1.75rem;
            }

            .summary-card {
                padding: 1.25rem;
            }
        }

        @media (max-width: 480px) {
            .success-box {
                padding: 1.5rem 1rem;
            }

            .success-title {
                font-size: 1.5rem;
            }

            .home-button {
                padding: 0.75rem 1.25rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-box">
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>

            <h1 class="success-title">Đặt sân thành công</h1>

            <c:choose>
                <c:when test="${fn:toLowerCase(paymentMethod) eq 'vnpay'}">
                    <div class="payment-method-badge">
                        <i class="fab fa-cc-visa"></i>
                        Thanh toán VNPay
                    </div>
                    <p class="success-message">
                        Cảm ơn bạn đã thanh toán thành công qua VNPay.<br>
                        Thông tin đặt sân đã được xác nhận.
                    </p>
                </c:when>
                <c:otherwise>
                    <div class="payment-method-badge">
                        <i class="fas fa-money-bill-wave"></i>
                        Thanh toán tại sân
                    </div>
                    <p class="success-message">
                        Cảm ơn bạn đã đặt sân thành công.<br>
                        Vui lòng thanh toán khi đến sân.
                    </p>
                </c:otherwise>
            </c:choose>

            <div class="summary-card">
                <div class="summary-title">
                    <i class="fas fa-receipt"></i>
                    Chi tiết thanh toán
                </div>

                <div class="summary-item">
                    <span class="summary-label">
                        <i class="fas fa-futbol"></i>
                        Giá thuê sân
                    </span>
                    <span class="summary-value">
                        <fmt:formatNumber value="${ticketPrice}" type="number" groupingUsed="true" /> đ
                    </span>
                </div>

                <div class="summary-item">
                    <span class="summary-label">
                        <i class="fas fa-utensils"></i>
                        Đồ ăn & thức uống
                    </span>
                    <span class="summary-value">
                        <fmt:formatNumber value="${foodPrice}" type="number" groupingUsed="true" /> đ
                    </span>
                </div>

                <div class="summary-item">
                    <span class="summary-label">
                        <i class="fas fa-calculator"></i>
                        Tổng thanh toán
                    </span>
                    <span class="summary-value">
                        <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true" /> đ
                    </span>
                </div>
            </div>

            <a href="home.jsp" class="home-button">
                <i class="fas fa-home"></i>
                Quay về trang chủ
            </a>
        </div>
    </div>
</body>
</html>