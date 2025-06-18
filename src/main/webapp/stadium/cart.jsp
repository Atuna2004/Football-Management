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
    <title>Giỏ hàng của bạn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background-color: #f8f9fa; }
        .cart-container { padding: 40px 0; }
        .cart-title {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 30px;
            text-align: center;
        }
        .table th, .table td {
            vertical-align: middle !important;
        }
        .btn-remove {
            color: red;
            font-weight: bold;
        }
        .total-price {
            font-size: 24px;
            font-weight: 700;
            text-align: right;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container cart-container">
    <div class="cart-title">🛒 Giỏ hàng của bạn</div>

    <c:if test="${empty sessionScope.cart}">
        <div class="alert alert-info text-center">
            Bạn chưa chọn món nào.
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/food?stadiumId=${stadiumId}&bookingId=${bookingId}" class="btn btn-primary">
                    ⬅ Quay lại chọn món
                </a>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.cart}">
        <form action="${pageContext.request.contextPath}/update-cart?stadiumId=${stadiumId}&bookingId=${bookingId}" method="post">
            <table class="table table-bordered table-hover bg-white">
                <thead class="table-light">
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
                            <td>${loop.index + 1}</td>
                            <td>${item.foodItem.name}</td>
                            <td><fmt:formatNumber value="${item.foodItem.price}" type="number" groupingUsed="true"/> đ</td>
                            <td>
                                <input type="number" name="quantities" value="${item.quantity}" min="1" class="form-control" />
                                <input type="hidden" name="foodItemIds" value="${item.foodItem.foodItemID}" />
                            </td>
                            <td>
                                <fmt:formatNumber value="${item.foodItem.price * item.quantity}" type="number" groupingUsed="true"/> đ
                                <c:set var="total" value="${total + (item.foodItem.price * item.quantity)}" />
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/remove-from-cart?foodItemId=${item.foodItem.foodItemID}&stadiumId=${stadiumId}&bookingId=${bookingId}" class="btn btn-sm btn-outline-danger btn-remove">✖</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="total-price">
                Tổng cộng: <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> đ
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="${pageContext.request.contextPath}/food?stadiumId=${stadiumId}&bookingId=${bookingId}" class="btn btn-secondary">⬅ Tiếp tục chọn món</a>
                <div>
                    <button type="submit" class="btn btn-warning">🔄 Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/checkout?stadiumId=${stadiumId}&bookingId=${bookingId}" class="btn btn-success">✅ Thanh toán</a>
                </div>
            </div>
        </form>
    </c:if>
</div>

</body>
</html>
