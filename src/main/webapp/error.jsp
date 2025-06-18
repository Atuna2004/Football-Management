<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông báo lỗi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <style>
        .error-card {
            max-width: 500px;
            margin: auto;
            margin-top: 100px;
        }
    </style>
</head>
<body class="bg-light">
<div class="card error-card shadow p-4 text-center">
    <h2 class="text-danger">❌ Có lỗi xảy ra</h2>
    <p class="mt-3">
        <c:out value="${errorMessage != null ? errorMessage : 'Đã xảy ra lỗi không xác định.'}" />
    </p>

    <c:choose>
        <c:when test="${not empty stadiumId}">
            <a href="timeslot?stadiumId=${stadiumId}" class="btn btn-primary mt-3">⬅ Quay lại chọn khung giờ</a>
        </c:when>
        <c:otherwise>
            <a href="home" class="btn btn-secondary mt-3">🏠 Về trang chủ</a>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
