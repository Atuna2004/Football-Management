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
    <title>Thực đơn Sân Bóng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .card-img-top {
            height: 280px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .banner {
            width: 100%;
            height: 400px;
            background: url('images-food/banner-food.jpg') no-repeat center center;
            background-size: cover;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 36px;
            font-weight: bold;
            text-shadow: 2px 2px 5px rgba(0,0,0,0.7);
        }

        .card {
            border: none;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background-color: #ffffff;
        }

        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.15);
        }

        .card-body {
            padding: 16px;
            background-color: #fdfdfd;
        }

        .card-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #222;
        }

        .card-text {
            font-size: 16px;
            font-weight: 600;
            color: #d84315;
            background-color: #fff7f2;
            padding: 6px 12px;
            border-radius: 6px;
            display: inline-block;
        }

        .btn-success {
            background: linear-gradient(135deg, #00c853, #18458B);
            color: white;
            font-weight: 600;
            padding: 10px 18px;
            border-radius: 30px;
            box-shadow: 0 5px 15px rgba(0, 200, 83, 0.25);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 200, 83, 0.4);
        }
    </style>
</head>
<body>
<!-- Banner -->
<div class="banner">
    🍽️ Thực đơn Đặt Sân 247
</div>

<!-- Nút xem giỏ hàng -->
<div class="container mt-3 text-end">
    <a href="stadium/cart.jsp?stadiumId=${stadiumId}&bookingId=${bookingId}" class="btn btn-warning">
        🛒 Xem giỏ hàng
    </a>
</div>

<!-- Danh sách món ăn -->
<div class="container mt-4">
    <div class="row g-4">
        <c:forEach var="item" items="${foodList}">
            <div class="col-md-4">
                <div class="card h-100">
                    <img src="images-food/default-food.jpg4" class="card-img-top" alt="${item.name}" />
                    <div class="card-body">
                        <h5 class="card-title">${item.name}</h5>
                        <p class="card-text">
                            Giá: <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true" /> đ
                        </p>
                        <form action="add-to-cart" method="post">
                            <input type="hidden" name="foodItemId" value="${item.foodItemID}" />
                            <input type="hidden" name="stadiumId" value="${stadiumId}" />
                            <input type="hidden" name="bookingId" value="${bookingId}" />
                            <input type="number" name="quantity" value="1" min="1" class="form-control mb-2" />
                            <button type="submit" class="btn btn-success">🛒 Thêm vào giỏ</button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Nút chỉ thanh toán tiền sân -->
    <div class="text-center mt-5">
        <form action="checkout" method="get">
            <input type="hidden" name="stadiumId" value="${stadiumId}" />
            <input type="hidden" name="bookingId" value="${bookingId}" />
            <button type="submit" class="btn btn-primary btn-lg">
                💳 Xác nhận thanh toán
            </button>
        </form>
    </div>
</div>

</body>
</html>
