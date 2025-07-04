<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #d4fc79 0%, #96e6a1 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .success-box {
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            text-align: center;
            max-width: 600px;
            width: 100%;
            position: relative;
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .success-box h1 {
            color: #2ecc71;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .lead {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 30px;
        }

        .summary {
            text-align: left;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #e0e0e0;
            box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.02);
        }

        .summary h5 {
            margin: 10px 0;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .summary h5 i {
            color: #2ecc71;
        }

        .btn-primary {
            background-color: #28a745;
            border-color: #28a745;
            font-weight: 600;
            padding: 12px 25px;
            font-size: 1rem;
            border-radius: 8px;
        }

        .btn-primary:hover {
            background-color: #218838;
            border-color: #1e7e34;
        }

    </style>
</head>
<body>

<div class="success-box">
    <h1><i class="fas fa-check-circle"></i> Đặt sân & món thành công!</h1>

    <c:choose>
        <c:when test="${fn:toLowerCase(paymentMethod) eq 'vnpay'}">
            <p class="lead">🏦 Bạn đã thanh toán thành công qua <strong>VNPay</strong>.</p>
        </c:when>
        <c:otherwise>
            <p class="lead">💵 Cảm ơn bạn. Vui lòng thanh toán trực tiếp khi đến sân.</p>
        </c:otherwise>
    </c:choose>

    <div class="summary mt-4">
        <h5><i class="fas fa-ticket-alt"></i> Giá vé sân: 
            <fmt:formatNumber value="${ticketPrice}" type="number" groupingUsed="true" /> đ
        </h5>
        <h5><i class="fas fa-hamburger"></i> Giá đồ ăn: 
            <fmt:formatNumber value="${foodPrice}" type="number" groupingUsed="true" /> đ
        </h5>
        <h5><i class="fas fa-wallet"></i> Tổng sau giảm giá: 
            <strong style="color: #28a745;">
                <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true" /> đ
            </strong>
        </h5>
    </div>

    <a href="home.jsp" class="btn btn-primary mt-4">
        <i class="fas fa-home me-2"></i>Quay về trang chủ
    </a>
</div>

</body>
</html>
