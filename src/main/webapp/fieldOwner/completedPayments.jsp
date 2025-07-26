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

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 50%, #dbeafe 100%);
            min-height: 100vh;
            color: #1e293b;
            line-height: 1.6;
        }

        /* Top Header */
        .top-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            padding: 20px 0;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            height: 80px;
            box-shadow: 0 8px 32px rgba(59, 130, 246, 0.08);
        }

        .top-header .container-fluid {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .logo h3 {
            color: #1e293b;
            font-weight: 700;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
        }

        .logo h3 a.item {
            text-decoration: none;
            color: #3b82f6;
            transition: all 0.3s ease;
        }

        .logo h3 a.item:hover {
            transform: scale(1.1);
            text-decoration: none;
        }

        .user-greeting {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 12px 20px;
            border-radius: 12px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        /* Dashboard Container */
        .dashboard-container {
            display: flex;
            min-height: calc(100vh - 80px);
        }

        /* Main Content */
        .main-content {
            margin-left: 300px;
            padding: 40px;
            width: calc(100% - 300px);
            margin-top: 80px;
        }

        /* Page Title */
        .page-title {
            color: #1e293b;
            font-weight: 700;
            font-size: 32px;
            margin-bottom: 32px;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-title i {
            color: #3b82f6;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 32px;
            margin-bottom: 48px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 32px;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            border: 1px solid rgba(59, 130, 246, 0.1);
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            text-align: center;
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.15);
            border-color: rgba(59, 130, 246, 0.2);
        }

        .stat-card .icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            margin: 0 auto 24px;
        }

        .stat-card.total-payments .icon {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        }

        .stat-card.total-amount .icon {
            background: linear-gradient(135deg, #10b981, #059669);
        }

        .stat-card.today-payments .icon {
            background: linear-gradient(135deg, #f59e0b, #d97706);
        }

        .stat-card h4 {
            font-size: 48px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
            line-height: 1;
        }

        .stat-card p {
            font-size: 14px;
            color: #64748b;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin: 0;
        }

        /* Card Styles */
        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            border: 1px solid rgba(59, 130, 246, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.12);
        }

        .card-header {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 32px 40px;
            border: none;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h5 {
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-body {
            padding: 0;
        }

        /* Table Styles */
        .table-responsive {
            border-radius: 0 0 24px 24px;
            overflow: hidden;
        }

        .table {
            background: transparent;
            border-collapse: collapse;
            width: 100%;
            margin: 0;
        }

        .table th {
            background: rgba(59, 130, 246, 0.05);
            color: #1e293b;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 24px 20px;
            border: none;
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .table td {
            padding: 24px 20px;
            border: none;
            border-bottom: 1px solid rgba(59, 130, 246, 0.05);
            vertical-align: middle;
        }

        .table tr {
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background: rgba(59, 130, 246, 0.03);
            transform: scale(1.005);
        }

        /* Payment ID Styling */
        .payment-id {
            font-weight: 700;
            color: #3b82f6;
            font-size: 16px;
        }

        /* User Name Styling */
        .user-name {
            font-weight: 600;
            color: #1e293b;
            font-size: 16px;
        }

        /* Amount Styling */
        .amount {
            font-weight: 700;
            color: #059669;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .amount i {
            color: #10b981;
            font-size: 16px;
        }

        /* Payment Method Badge */
        .payment-method {
            background: rgba(59, 130, 246, 0.1);
            color: #2563eb;
            padding: 8px 16px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .payment-method.vnpay {
            background: rgba(220, 38, 127, 0.1);
            color: #be185d;
        }

        .payment-method.momo {
            background: rgba(168, 85, 247, 0.1);
            color: #7c3aed;
        }

        .payment-method.cash {
            background: rgba(34, 197, 94, 0.1);
            color: #059669;
        }

        /* Date Styling */
        .payment-date {
            color: #64748b;
            font-weight: 500;
            font-size: 14px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
        }

        .empty-state i {
            font-size: 64px;
            color: #cbd5e1;
            margin-bottom: 24px;
        }

        .empty-state h3 {
            color: #64748b;
            margin-bottom: 12px;
            font-size: 20px;
            font-weight: 600;
        }

        .empty-state p {
            color: #94a3b8;
            font-size: 14px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 24px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
                gap: 24px;
            }

            .page-title {
                font-size: 28px;
            }

            .card-header {
                padding: 24px;
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }

            .table th,
            .table td {
                padding: 16px 12px;
                font-size: 14px;
            }

            .top-header .container-fluid {
                padding: 0 24px;
                flex-direction: column;
                gap: 16px;
                align-items: flex-start !important;
            }

            .amount {
                font-size: 16px;
            }
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeInUp 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-delay-1 { animation-delay: 0.1s; animation-fill-mode: both; }
        .animate-delay-2 { animation-delay: 0.2s; animation-fill-mode: both; }
        .animate-delay-3 { animation-delay: 0.3s; animation-fill-mode: both; }

        /* Utility Classes */
        .d-flex { display: flex; }
        .justify-content-between { justify-content: space-between; }
        .align-items-center { align-items: center; }
        .me-2 { margin-right: 0.5rem; }
        .mb-4 { margin-bottom: 1.5rem; }
        .p-0 { padding: 0; }
        .mb-0 { margin-bottom: 0; }
        .text-start { text-align: start; }
    </style>
</head>
<body>

<!-- Top Header -->
<div class="top-header">
    <div class="container-fluid">
        <div class="logo">
            <h3>
                <a class="item" href="<%= request.getContextPath() %>/home.jsp">
                    <i class="fas fa-futbol"></i>
                </a>
                Field Manager
            </h3>
        </div>

        <%
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
        %>
            <div class="user-greeting">
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