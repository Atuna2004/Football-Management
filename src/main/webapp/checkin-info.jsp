<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thông tin Check-in</title>
    <style>
        body { font-family: Arial; text-align: center; margin-top: 50px; }
        .info-box {
            display: inline-block;
            padding: 20px;
            border: 2px solid #2196F3;
            background-color: #f0f8ff;
            border-radius: 10px;
        }
        h2 { color: #2196F3; }
    </style>
</head>
<body>
    <div class="info-box">
        <h2>📋 Thông tin đơn đặt sân</h2>
        <c:if test="${not empty booking}">
            <p><strong>Mã đơn:</strong> ${booking.bookingID}</p>
            <p><strong>Trạng thái:</strong> ${booking.status}</p>
            <p><strong>Ngày đặt:</strong> ${booking.createdAt}</p>
            <p><em>Vui lòng đưa mã này cho nhân viên để được check-in.</em></p>
        </c:if>
    </div>
</body>
</html>
