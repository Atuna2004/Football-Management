<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Nhận và gán stadiumId, bookingId từ URL --%>
<c:set var="stadiumId" value="${param.stadiumId}" />
<c:set var="bookingId" value="${param.bookingId}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng của bạn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #fafafa;
            color: #333;
            line-height: 1.6;
        }

        .cart-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 3rem 1rem;
        }

        .cart-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .cart-title {
            font-size: 2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .cart-subtitle {
            color: #666;
            font-size: 1rem;
        }

        .empty-cart {
            background: white;
            border-radius: 12px;
            padding: 3rem 2rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border: 1px solid #eee;
        }

        .empty-icon {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 1rem;
        }

        .empty-message {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 2rem;
        }

        .cart-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border: 1px solid #eee;
            margin-bottom: 2rem;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            font-weight: 600;
            color: #495057;
            padding: 1rem;
            font-size: 0.9rem;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f3f4;
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        .table tbody tr {
            transition: background-color 0.2s ease;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .item-number {
            width: 40px;
            height: 40px;
            background-color: #007bff;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .item-name {
            font-weight: 600;
            color: #333;
        }

        .item-price {
            font-weight: 500;
            color: #007bff;
        }

        .quantity-input {
            width: 80px;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 6px;
            text-align: center;
            font-weight: 500;
            transition: border-color 0.2s ease;
        }

        .quantity-input:focus {
            border-color: #007bff;
            outline: none;
        }

        .total-amount {
            font-weight: 600;
            color: #28a745;
        }

        .remove-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .remove-btn:hover {
            background-color: #c82333;
            transform: scale(1.1);
            color: white;
        }

        .cart-summary {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border: 1px solid #eee;
            margin-bottom: 2rem;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1.5rem;
            font-weight: 600;
            color: #333;
            padding: 1rem 0;
            border-top: 2px solid #f1f3f4;
        }

        .total-price {
            color: #28a745;
        }

        .cart-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            border: none;
        }

        .btn-back {
            background-color: #6c757d;
            color: white;
        }

        .btn-back:hover {
            background-color: #5a6268;
            color: white;
            transform: translateY(-1px);
        }

        .btn-update {
            background-color: #ffc107;
            color: #212529;
        }

        .btn-update:hover {
            background-color: #e0a800;
            color: #212529;
            transform: translateY(-1px);
        }

        .btn-checkout {
            background-color: #28a745;
            color: white;
        }

        .btn-checkout:hover {
            background-color: #218838;
            color: white;
            transform: translateY(-1px);
        }

        .action-group {
            display: flex;
            gap: 0.75rem;
        }

        /* Success animation for updates */
        .update-success {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #28a745;
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 6px;
            z-index: 1001;
            transform: translateX(400px);
            transition: transform 0.3s ease;
        }

        .update-success.show {
            transform: translateX(0);
        }

        @media (max-width: 768px) {
            .cart-container {
                padding: 2rem 1rem;
            }

            .cart-title {
                font-size: 1.5rem;
            }

            .cart-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .action-group {
                width: 100%;
                justify-content: center;
            }

            .table {
                font-size: 0.9rem;
            }

            .table thead th,
            .table tbody td {
                padding: 0.75rem 0.5rem;
            }

            .total-row {
                font-size: 1.25rem;
            }
        }

        @media (max-width: 480px) {
            .empty-cart {
                padding: 2rem 1rem;
            }

            .cart-summary {
                padding: 1.5rem;
            }

            .btn {
                padding: 0.6rem 1.2rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <!-- Success Animation -->
    <div class="update-success" id="updateSuccess">
        <i class="fas fa-check"></i> Cập nhật thành công
    </div>

    <div class="cart-container">
        <div class="cart-header">
            <h1 class="cart-title">Giỏ hàng</h1>
            <p class="cart-subtitle">Xem lại đơn hàng của bạn</p>
        </div>

        <c:if test="${empty sessionScope.cart}">
            <div class="empty-cart">
                <div class="empty-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="empty-message">
                    Giỏ hàng của bạn đang trống
                </div>
                <a href="${pageContext.request.contextPath}/food?stadiumId=${stadiumId}&bookingId=${bookingId}" 
                   class="btn btn-back">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại chọn món
                </a>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.cart}">
            <form action="${pageContext.request.contextPath}/update-cart?stadiumId=${stadiumId}&bookingId=${bookingId}" 
                  method="post" id="cartForm">
                
                <div class="cart-table">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tên món</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                                <th>Xóa</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="total" value="0" />
                            <c:forEach var="item" items="${sessionScope.cart}" varStatus="loop">
                                <tr>
                                    <td>
                                        <div class="item-number">${loop.index + 1}</div>
                                    </td>
                                    <td>
                                        <div class="item-name">${item.foodItem.name}</div>
                                    </td>
                                    <td>
                                        <div class="item-price">
                                            <fmt:formatNumber value="${item.foodItem.price}" type="number" groupingUsed="true"/> đ
                                        </div>
                                    </td>
                                    <td>
                                        <input type="number" name="quantities" value="${item.quantity}" 
                                               min="1" class="quantity-input" />
                                        <input type="hidden" name="foodItemIds" value="${item.foodItem.foodItemID}" />
                                    </td>
                                    <td>
                                        <div class="total-amount">
                                            <fmt:formatNumber value="${item.foodItem.price * item.quantity}" type="number" groupingUsed="true"/> đ
                                        </div>
                                        <c:set var="total" value="${total + (item.foodItem.price * item.quantity)}" />
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/remove-from-cart?foodItemId=${item.foodItem.foodItemID}&stadiumId=${stadiumId}&bookingId=${bookingId}" 
                                           class="remove-btn" onclick="return confirm('Xóa món này khỏi giỏ hàng?')">
                                            <i class="fas fa-times"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="cart-summary">
                    <div class="total-row">
                        <span>Tổng cộng:</span>
                        <span class="total-price">
                            <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> đ
                        </span>
                    </div>
                </div>

                <div class="cart-actions">
                    <a href="${pageContext.request.contextPath}/food?stadiumId=${stadiumId}&bookingId=${bookingId}" 
                       class="btn btn-back">
                        <i class="fas fa-arrow-left"></i>
                        Tiếp tục chọn món
                    </a>
                    
                    <div class="action-group">
                        <button type="submit" class="btn btn-update">
                            <i class="fas fa-sync-alt"></i>
                            Cập nhật
                        </button>
                        <a href="${pageContext.request.contextPath}/checkout?stadiumId=${stadiumId}&bookingId=${bookingId}" 
                           class="btn btn-checkout">
                            <i class="fas fa-credit-card"></i>
                            Thanh toán
                        </a>
                    </div>
                </div>
            </form>
        </c:if>
    </div>

    <script>
        // Add success animation for form submission
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('cartForm');
            const successToast = document.getElementById('updateSuccess');

            if (form) {
                form.addEventListener('submit', function(e) {
                    // Show success animation
                    successToast.classList.add('show');
                    
                    // Hide after 2 seconds
                    setTimeout(() => {
                        successToast.classList.remove('show');
                    }, 2000);
                });
            }
        });
    </script>
</body>
</html>