<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="paymentDAO" class="dao.PaymentDAO"/>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Chờ Xác Nhận - Field Manager</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/pendingPayment.css">

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
    <%@ include file="FieldOwnerSB.jsp" %>

    <main class="main-content">
        <h1 class="page-title fade-in">
            <i class="fas fa-hourglass-half"></i>
            Thanh Toán Chờ Xác Nhận
        </h1>

        <div class="stats-grid">
            <div class="stat-card pending-count fade-in animate-delay-1">
                <div class="icon"><i class="fas fa-clock"></i></div>
                <h4><c:out value="${payments != null ? payments.size() : 0}"/></h4>
                <p>Đang chờ xác nhận</p>
            </div>
            <div class="stat-card pending-amount fade-in animate-delay-2">
                <div class="icon"><i class="fas fa-exclamation-triangle"></i></div>
                <h4>
                    <c:set var="totalPendingAmount" value="0"/>
                    <c:forEach items="${payments}" var="p">
                        <c:set var="totalPendingAmount" value="${totalPendingAmount + p.amount}"/>
                    </c:forEach>
                    <fmt:formatNumber value="${totalPendingAmount}" type="number" maxFractionDigits="0"
                                      groupingUsed="true"/>
                </h4>
                <p>Tổng giá trị chờ (₫)</p>
            </div>
            <div class="stat-card urgent-pending fade-in animate-delay-3">
                <div class="icon"><i class="fas fa-bolt"></i></div>
                <h4>
                    <c:set var="urgentCount" value="0"/>
                    <jsp:useBean id="now" class="java.util.Date"/>
                    <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today"/>
                    <c:forEach items="${payments}" var="p">
                        <c:if test="${p.paymentDate.toString().startsWith(today)}">
                            <c:set var="urgentCount" value="${urgentCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${urgentCount}
                </h4>
                <p>Cần xử lý ngay</p>
            </div>
        </div>

        <div class="card fade-in">
            <div class="card-header">
                <h5>
                    <i class="fas fa-list-check"></i>
                    Danh sách thanh toán chờ xác nhận
                </h5>
                <div class="pending-indicator">
                    <i class="fas fa-circle"></i>
                    ${payments != null ? payments.size() : 0} yêu cầu
                </div>
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
                                    <th>Ngày Tạo Yêu Cầu</th>
                                    <th>Hành Động</th>
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
                                                <i class="fas fa-clock"></i>
                                                <fmt:formatNumber value="${p.amount}" type="number"
                                                                  maxFractionDigits="0" groupingUsed="true"/> ₫
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
                                                    <i class="fas fa-calendar"
                                                       style="color: #64748b; margin-right: 6px;"></i>
                                                    ${p.paymentDate}
                                                </span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="process-payment?action=Completed&id=${p.paymentId}"
                                                   class="btn btn-success btn-sm"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xác nhận thanh toán này?')">
                                                    <i class="fas fa-check"></i> Xác Nhận
                                                </a>
                                                <a href="process-payment?action=Failed&id=${p.paymentId}"
                                                   class="btn btn-danger btn-sm"
                                                   onclick="return confirm('Bạn có chắc chắn muốn hủy thanh toán này?')">
                                                    <i class="fas fa-times"></i> Hủy
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h3>Không có thanh toán chờ xác nhận</h3>
                            <p>Tất cả thanh toán đã được xử lý</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const tableRows = document.querySelectorAll('tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
            row.classList.add('fade-in');
        });

        const actionBtns = document.querySelectorAll('.btn');
        actionBtns.forEach(btn => {
            btn.addEventListener('click', function (e) {
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                this.style.pointerEvents = 'none';
                this.style.opacity = '0.7';

                setTimeout(() => {
                }, 500);
            });
        });

        const today = new Date().toISOString().split('T')[0];
        const rows = document.querySelectorAll('tbody tr');
        rows.forEach(row => {
            const dateCell = row.querySelector('.payment-date');
            if (dateCell && dateCell.textContent.includes(today)) {
                row.style.background = 'rgba(59, 130, 246, 0.05)';
                row.style.borderLeft = '4px solid #3b82f6';
            }
        });
    });
</script>

</body>
</html>