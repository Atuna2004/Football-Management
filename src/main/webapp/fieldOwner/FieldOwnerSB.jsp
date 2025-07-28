<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>

    <!-- Link CSS động với contextPath -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FieldOwnerSB.css">

    <!-- Các CSS khác nếu cần -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>

<!-- Left Navigation Sidebar -->
<nav class="navigation-sidebar">
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <i class="fas fa-chart-line"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/completed-payments" class="nav-link">
                <i class="fa-solid fa-clock"></i>
                <span>Lịch đặt sân</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/pending-payments" class="nav-link">
                <i class="fa-solid fa-pen-to-square"></i>
                <span>Đơn đặt sân</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/fieldOwner/FOSTD" class="nav-link">
                <i class="fas fa-warehouse"></i>
                <span>Quản lý sân</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/owner/food-items" class="nav-link">
                <i class="fas fa-hamburger"></i>
                <span>Quản lý Món ăn</span>
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/fieldOwner/booking-list.jsp" class="nav-link">
                <i class="fas fa-users"></i>
                <span>Khách hàng</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/owner/reports" class="nav-link">
                <i class="fas fa-chart-bar"></i>
                <span>Báo cáo</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/fieldOwner/revenueReport.jsp" class="nav-link">
                <i class="fas fa-dollar-sign"></i>
                <span>Doanh thu</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/fieldOwner/TimeSlotManagement.jsp" class="nav-link">
                <i class="fa-regular fa-calendar-days"></i>
                <span>Chỉnh sửa khung thời gian</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/tournament" class="nav-link">
                <i class="fas fa-trophy"></i>
                <span>Giải đấu</span>
            </a>
        </li>
        
        
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Đăng xuất</span>
                    </a>
                </li>
    </ul>

</nav>

<!-- JavaScript xử lý active menu -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const navLinks = document.querySelectorAll(".nav-menu .nav-link");

        navLinks.forEach(link => {
            link.addEventListener("click", function (e) {
                // Loại bỏ lớp 'active' khỏi tất cả
                navLinks.forEach(l => l.classList.remove("active"));

                // Thêm lớp 'active' cho phần tử được click
                this.classList.add("active");
            });
        });

        // Tự động đánh dấu trang hiện tại là active khi tải trang
        const currentUrl = window.location.href;
        navLinks.forEach(link => {
            if (link.href && currentUrl.includes(link.href)) {
                link.classList.add("active");
            }
        });
    });
</script>