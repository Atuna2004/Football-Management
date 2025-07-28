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
            --success-green: #16a34a;
            --success-green-hover: #15803d;
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
        }

        .header {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--light-blue) 100%);
            padding: 4rem 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="20" cy="20" r="1" fill="white" opacity="0.1"/><circle cx="80" cy="40" r="0.5" fill="white" opacity="0.1"/><circle cx="40" cy="80" r="1.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            pointer-events: none;
        }

        .title {
            font-size: 2.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 1;
        }

        .subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }

        .nav-bar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1.25rem 0;
            border-bottom: 1px solid rgba(229, 231, 235, 0.5);
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .cart-btn {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--light-blue) 100%);
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
            position: relative;
            overflow: hidden;
        }

        .cart-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }

        .cart-btn:hover::before {
            left: 100%;
        }

        .cart-btn:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.4);
            color: white;
        }

        .menu-container {
            padding: 4rem 0;
            position: relative;
        }

        .menu-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(37, 99, 235, 0.03) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(96, 165, 250, 0.03) 0%, transparent 50%),
                radial-gradient(circle at 40% 80%, rgba(37, 99, 235, 0.02) 0%, transparent 50%);
            pointer-events: none;
        }

        .food-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(229, 231, 235, 0.6);
            overflow: hidden;
            height: 100%;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .food-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-blue), var(--lighter-blue), var(--primary-blue));
            background-size: 200% 100%;
            animation: shimmer 3s infinite;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }

        .food-card:hover::before {
            opacity: 1;
        }

        .food-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
        }

        .food-image {
            width: 100%;
            height: 220px;
            object-fit: cover;
            transition: all 0.4s ease;
        }

        .food-card:hover .food-image {
            transform: scale(1.1);
        }

        .food-content {
            padding: 2rem;
            position: relative;
        }

        .food-name {
            font-size: 1.375rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--gray-900);
            line-height: 1.3;
        }

        .food-price {
            background: linear-gradient(135deg, var(--blue-50) 0%, rgba(96, 165, 250, 0.1) 100%);
            color: var(--primary-blue);
            font-weight: 700;
            padding: 0.75rem 1.25rem;
            border-radius: 50px;
            display: inline-block;
            margin-bottom: 1.5rem;
            border: 2px solid var(--blue-100);
            font-size: 1.125rem;
            position: relative;
            overflow: hidden;
        }

        .food-price::before {
            content: '₫';
            position: absolute;
            left: -20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 0.875rem;
            opacity: 0.6;
        }

        .quantity-input {
            border: 2px solid var(--blue-100);
            border-radius: 50px;
            padding: 1rem;
            width: 90px;
            text-align: center;
            margin-bottom: 1.5rem;
            font-weight: 600;
            color: var(--gray-900);
            transition: all 0.3s ease;
            background: rgba(239, 246, 255, 0.5);
        }

        .quantity-input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
            background: white;
        }

        .add-btn {
            background: linear-gradient(135deg, var(--success-green) 0%, #059669 100%);
            color: white;
            border: none;
            padding: 1rem 1.5rem;
            border-radius: 50px;
            width: 100%;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(22, 163, 74, 0.3);
        }

        .add-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }

        .add-btn:hover::before {
            left: 100%;
        }

        .add-btn:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(22, 163, 74, 0.4);
        }

        .add-btn:active {
            transform: translateY(0) scale(0.98);
        }

        .checkout-section {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 4rem 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .checkout-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.03) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .checkout-content {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 24px;
            padding: 3rem;
            max-width: 600px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }

        .checkout-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.75rem;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--lighter-blue) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .checkout-subtitle {
            color: var(--gray-600);
            margin-bottom: 2.5rem;
            font-weight: 500;
            font-size: 1.1rem;
        }

        .checkout-btn {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--light-blue) 100%);
            color: white;
            border: none;
            padding: 1.25rem 3rem;
            border-radius: 50px;
            font-size: 1.125rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 8px 30px rgba(37, 99, 235, 0.3);
            position: relative;
            overflow: hidden;
        }

        .checkout-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s ease;
        }

        .checkout-btn:hover::before {
            left: 100%;
        }

        .checkout-btn:hover {
            transform: translateY(-4px) scale(1.05);
            color: white;
            box-shadow: 0 15px 40px rgba(37, 99, 235, 0.4);
        }

        .checkout-btn:active {
            transform: translateY(-2px) scale(1.02);
        }

        .success-toast {
            position: fixed;
            top: 30px;
            right: 30px;
            background: linear-gradient(135deg, var(--success-green) 0%, #059669 100%);
            color: white;
            padding: 1.25rem 2rem;
            border-radius: 50px;
            z-index: 1001;
            transform: translateX(400px);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 10px 30px rgba(22, 163, 74, 0.3);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 600;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .success-toast.show {
            transform: translateX(0) scale(1.05);
            animation: toast-bounce 0.6s ease;
        }

        @keyframes toast-bounce {
            0% { transform: translateX(400px) scale(1); }
            50% { transform: translateX(-10px) scale(1.05); }
            100% { transform: translateX(0) scale(1.05); }
        }

        .success-toast i {
            font-size: 1.25rem;
            animation: check-pulse 2s infinite;
        }

        @keyframes check-pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        @media (max-width: 768px) {
            .title {
                font-size: 1.75rem;
            }
            
            .menu-container {
                padding: 2rem 0;
            }
            
            .food-content {
                padding: 1.25rem;
            }

            .checkout-content {
                padding: 1.5rem;
                margin: 0 1rem;
            }

            .checkout-title {
                font-size: 1.25rem;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 2rem 0;
            }

            .title {
                font-size: 1.5rem;
            }

            .food-content {
                padding: 1rem;
            }

            .checkout-content {
                padding: 1.25rem;
            }

            .checkout-btn {
                padding: 0.875rem 1.5rem;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Success Toast -->
    <div class="success-toast" id="successToast">
        <i class="fas fa-check-circle"></i> 
        Đã thêm vào giỏ hàng
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
                            <c:set var="defaultImage" value="${pageContext.request.contextPath}/images-food/default-food.jpg" />
                            <img src="${empty item.imageUrl ? defaultImage : item.imageUrl}"
                                 class="food-image"
                                 alt="${item.name}" />
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
                                        <i class="fas fa-plus"></i>
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
            <div class="checkout-content">
                <h3 class="checkout-title">Sẵn sàng thanh toán?</h3>
                <p class="checkout-subtitle">Xác nhận đơn hàng và tiến hành thanh toán</p>
                
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