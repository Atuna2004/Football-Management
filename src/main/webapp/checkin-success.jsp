<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Booking" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>✅ Check-in thành công</title>
    <style>
        body { font-family: Arial; text-align: center; margin-top: 50px; }
        .success-box {
            display: inline-block;
            padding: 20px;
            border: 2px solid #4CAF50;
            background-color: #f6ffed;
            border-radius: 10px;
        }
        h2 { color: #4CAF50; }
    </style>
</head>
<body>
    <div class="success-box">
        <h2>✅ Check-in thành công!</h2>

        <c:if test="${not empty booking}">
            <p><strong>Mã đơn:</strong> ${booking.bookingID}</p>
            <p><strong>Trạng thái:</strong> ${booking.status}</p>
            <p><strong>Ngày đặt:</strong> ${booking.createdAt}</p>
            <p>Cảm ơn bạn đã đến sân!</p>
        </c:if>
    </div>
</body>
</html>
