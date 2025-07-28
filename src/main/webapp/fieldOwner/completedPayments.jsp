<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="paymentDAO" class="dao.PaymentDAO"/>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Thanh Toán Hoàn Tất - Field Manager</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/completedPayment.css">

</head>
<body>

<div class="top-header">
    <div class="container-fluid d-flex justify-content-between align-items-center" style="padding-left: 0; padding-right: 0; max-width: 100%;">
        <div class="logo" style="padding-left: 40px;">
            <h3>
                <a class="item" href="<%= request.getContextPath() %>/home.jsp">
                    <i class="fas fa-futbol me-2"></i>
                </a>
                Field Manager Page
            </h3>
        </div>

        <%
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
        %>
            <div class="user-greeting" style="margin-right: 40px;">
                <i class="fas fa-user-circle"></i>
                Xin chào, <%= currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getEmail() %>
            </div>
        <%
            } else {
        %>
            <div class="account item">
                <a class="register me-2" href="<%= request.getContextPath() %>/account/register.jsp">Đăng ký</a>
                <a href="<%= request.getContextPath() %>/account/login.jsp">Đăng nhập</a>
            </div>
        <%
            }
        %>
    </div>
</div>

<div class="dashboard-container">
    <!-- Sidebar -->
    <%@ include file="FieldOwnerSB.jsp" %>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Title -->
        <h1 class="page-title fade-in">
            <i class="fas fa-credit-card"></i>
            Danh Sách Thanh Toán Hoàn Tất
        </h1>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card total-payments fade-in animate-delay-1">
                <div class="icon"><i class="fas fa-list"></i></div>
                <h4><c:out value="${payments != null ? payments.size() : 0}"/></h4>
                <p>Tổng giao dịch</p>
            </div>
            <div class="stat-card total-amount fade-in animate-delay-2">
                <div class="icon"><i class="fas fa-dollar-sign"></i></div>
                <h4>
                    <c:set var="totalAmount" value="0"/>
                    <c:forEach items="${payments}" var="p">
                        <c:set var="totalAmount" value="${totalAmount + p.amount}"/>
                    </c:forEach>
                    <fmt:formatNumber value="${totalAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/>
                </h4>
                <p>Tổng số tiền (₫)</p>
            </div>
            <div class="stat-card today-payments fade-in animate-delay-3">
                <div class="icon"><i class="fas fa-calendar-day"></i></div>
                <h4>
                    <c:set var="todayCount" value="0"/>
                    <jsp:useBean id="now" class="java.util.Date"/>
                    <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today"/>
                    <c:forEach items="${payments}" var="p">
                        <c:if test="${p.paymentDate.toString().startsWith(today)}">
                            <c:set var="todayCount" value="${todayCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${todayCount}
                </h4>
                <p>Giao dịch hôm nay</p>
            </div>
        </div>

        <!-- Payment Table -->
        <div class="card fade-in">
            <div class="card-header">
                <h5>
                    <i class="fas fa-table"></i>
                    Chi tiết thanh toán
                </h5>
                <span style="font-size: 14px; opacity: 0.9;">
                    ${payments != null ? payments.size() : 0} giao dịch
                </span>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${payments != null && not empty payments}">
                        <div class="table-responsive">
                            <table class="table mb-0">
                                <thead>
                                    <tr>
                                        <th>Mã Booking</th>
                                        <th>Tên Người Dùng</th>
                                        <th>Số Tiền</th>
                                        <th>Phương Thức</th>
                                        <th>Ngày Thanh Toán</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${payments}" var="p">
                                        <tr>
                                            <td>
                                                <span class="payment-id">#${p.bookingId}</span>
                                            </td>
                                            <td>
                                                <span class="user-name">${paymentDAO.getUserNameByBookingId(p.bookingId)}</span>
                                            </td>
                                            <td>
                                                <div class="amount">
                                                    <i class="fas fa-coins"></i>
                                                    <fmt:formatNumber value="${p.amount}" type="number" maxFractionDigits="0" groupingUsed="true"/> ₫
                                                </div>
                                            </td>
                                            <td>
                                                <span class="payment-method ${p.paymentMethod.toLowerCase()}">
                                                    <c:choose>
                                                        <c:when test="${p.paymentMethod.toLowerCase().contains('vnpay')}">
                                                            <i class="fas fa-credit-card"></i>
                                                        </c:when>
                                                        <c:when test="${p.paymentMethod.toLowerCase().contains('momo')}">
                                                            <i class="fas fa-mobile-alt"></i>
                                                        </c:when>
                                                        <c:when test="${p.paymentMethod.toLowerCase().contains('cash')}">
                                                            <i class="fas fa-money-bill"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-payment"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    ${p.paymentMethod}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="payment-date">
                                                    <i class="fas fa-calendar" style="color: #64748b; margin-right: 6px;"></i>
                                                    ${p.paymentDate}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-receipt"></i>
                            <h3>Chưa có giao dịch nào</h3>
                            <p>Các giao dịch thanh toán sẽ hiển thị tại đây</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Add fade-in animation to table rows
        const tableRows = document.querySelectorAll('tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
            row.classList.add('fade-in');
        });

        // Add loading effect for better UX
        const table = document.querySelector('.table');
        if (table) {
            table.style.opacity = '0';
            setTimeout(() => {
                table.style.transition = 'opacity 0.5s ease';
                table.style.opacity = '1';
            }, 300);
        }
    });
</script>

</body>
</html>