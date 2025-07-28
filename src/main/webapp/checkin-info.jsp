<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thông tin Check-in</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #fafafa;
            text-align: center; 
            margin-top: 50px; 
        }
        
        .info-box {
            display: inline-block;
            padding: 2rem;
            border: 1px solid #ddd;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            max-width: 400px;
        }
        
        h2 { 
            color: #333;
            margin-bottom: 1.5rem;
        }
        
        p {
            margin-bottom: 0.75rem;
            color: #555;
        }
        
        strong {
            color: #333;
        }
        
        em {
            color: #666;
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 4px;
            display: block;
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <div class="info-box">
        <h2><i class="fas fa-clipboard-check"></i> Thông tin đơn đặt sân</h2>
        <c:if test="${not empty booking}">
            <p><strong>Mã đơn:</strong> ${booking.bookingID}</p>
            <p><strong>Trạng thái:</strong> ${booking.status}</p>
            <p><strong>Ngày đặt:</strong> ${booking.createdAt}</p>
            <p><em>Vui lòng đưa mã này cho nhân viên để được check-in.</em></p>
        </c:if>
    </div>
</body>
</html>