<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Nhận tham số từ URL --%>
<c:set var="stadiumId" value="${param.stadiumId}" />
<c:set var="bookingId" value="${param.bookingId}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thực đơn Sân Bóng</title>
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

        .header {
            background: white;
            padding: 2rem 0;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        .title {
            font-size: 2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: #666;
            font-size: 1rem;
        }

        .nav-bar {
            background: white;
            padding: 1rem 0;
            border-bottom: 1px solid #eee;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .cart-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.2s;
        }

        .cart-btn:hover {
            background-color: #0056b3;
            color: white;
        }

        .menu-container {
            padding: 3rem 0;
        }

        .food-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
            height: 100%;
            transition: transform 0.2s;
        }

        .food-card:hover {
            transform: translateY(-2px);
        }

        .food-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .food-content {
            padding: 1.5rem;
        }

        .food-name {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .food-price {
            background-color: #f8f9fa;
            color: #007bff;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .quantity-input {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 0.5rem;
            width: 80px;
            text-align: center;
            margin-bottom: 1rem;
        }

        .add-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 0.75rem 1rem;
            border-radius: 4px;
            width: 100%;
            font-weight: 500;
            transition: background-color 0.2s;
        }

        .add-btn:hover {
            background-color: #218838;
        }

        .checkout-section {
            background-color: #f8f9fa;
            padding: 3rem 0;
            text-align: center;
        }

        .checkout-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 6px;
            font-size: 1.1rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.2s;
        }

        .checkout-btn:hover {
            background-color: #0056b3;
            color: white;
        }

        .success-toast {
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

        .success-toast.show {
            transform: translateX(0);
        }

        @media (max-width: 768px) {
            .title {
                font-size: 1.5rem;
            }
            
            .menu-container {
                padding: 2rem 0;
            }
            
            .food-content {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Success Toast -->
    <div class="success-toast" id="successToast">
        <i class="fas fa-check"></i> Đã thêm vào giỏ hàng
    </div>

    <!-- Header -->
    <div class="header">
        <div class="container">
            <h1 class="title">Thực đơn</h1>
            <p class="subtitle">Chọn món ăn yêu thích của bạn</p>
        </div>
    </div>

    <!-- Navigation -->
    <div class="nav-bar">
        <div class="container text-end">
            <a href="stadium/cart.jsp?stadiumId=${stadiumId}&bookingId=${bookingId}" class="cart-btn">
                <i class="fas fa-shopping-cart"></i>
                Giỏ hàng
            </a>
        </div>
    </div>

    <!-- Menu -->
    <div class="menu-container">
        <div class="container">
            <div class="row g-4">
                <c:forEach var="item" items="${foodList}">
                    <div class="col-lg-4 col-md-6">
                        <div class="food-card">
                            <img src="images-food/default-food.jpg4" class="food-image" alt="${item.name}" />
                            <div class="food-content">
                                <h5 class="food-name">${item.name}</h5>
                                
                                <div class="food-price">
                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true" /> đ
                                </div>

                                <form class="add-form" action="add-to-cart" method="post">
                                    <input type="hidden" name="foodItemId" value="${item.foodItemID}" />
                                    <input type="hidden" name="stadiumId" value="${stadiumId}" />
                                    <input type="hidden" name="bookingId" value="${bookingId}" />
                                    
                                    <input type="number" name="quantity" value="1" min="1" class="quantity-input" />
                                    <button type="submit" class="add-btn">
                                        Thêm vào giỏ
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Checkout -->
    <div class="checkout-section">
        <div class="container">
            <h3 style="margin-bottom: 1rem;">Sẵn sàng thanh toán?</h3>
            <p style="color: #666; margin-bottom: 2rem;">Xác nhận đơn hàng và tiến hành thanh toán</p>
            
            <form action="checkout" method="get" style="display: inline;">
                <input type="hidden" name="stadiumId" value="${stadiumId}" />
                <input type="hidden" name="bookingId" value="${bookingId}" />
                <button type="submit" class="checkout-btn">
                    <i class="fas fa-credit-card"></i>
                    Thanh toán
                </button>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const forms = document.querySelectorAll('.add-form');
            const toast = document.getElementById('successToast');

            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    toast.classList.add('show');
                    setTimeout(() => {
                        toast.classList.remove('show');
                    }, 2000);
                });
            });
        });
    </script>
</body>
</html>