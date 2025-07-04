<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Booking" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Times New Roman', Times, serif;
            color: #2c3e50;
            line-height: 1.6;
        }

        .main-container {
            background: #ffffff;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            margin: 3rem auto;
            padding: 3rem;
            max-width: 1200px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            padding-bottom: 1.5rem;
            border-bottom: 3px solid #1e3a8a;
        }

        .page-title {
            color: #1e3a8a;
            font-weight: 700;
            font-size: 2.2rem;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .page-subtitle {
            color: #64748b;
            font-size: 1rem;
            font-style: italic;
            margin: 0;
        }

        .summary-section {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 2rem;
            margin-bottom: 2.5rem;
        }

        .summary-title {
            color: #1e3a8a;
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .summary-stats {
            display: flex;
            justify-content: space-around;
            text-align: center;
        }

        .stat-item {
            flex: 1;
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1e3a8a;
            display: block;
        }

        .stat-label {
            color: #64748b;
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        .table-section {
            background: #ffffff;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            overflow: hidden;
        }

        .table-header {
            background: #1e3a8a;
            color: white;
            padding: 1rem;
            text-align: center;
        }

        .table-header h4 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .table {
            margin: 0;
            border: none;
            font-size: 0.95rem;
        }

        .table thead {
            background: #f1f5f9;
            border-bottom: 2px solid #1e3a8a;
        }

        .table thead th {
            color: #1e3a8a;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            border: none;
            padding: 1rem 0.75rem;
            text-align: center;
            border-right: 1px solid #e2e8f0;
        }

        .table thead th:last-child {
            border-right: none;
        }

        .table tbody tr {
            border-bottom: 1px solid #e2e8f0;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
        }

        .table tbody tr:last-child {
            border-bottom: none;
        }

        .table tbody td {
            padding: 1rem 0.75rem;
            border: none;
            text-align: center;
            vertical-align: middle;
            border-right: 1px solid #f1f5f9;
        }

        .table tbody td:last-child {
            border-right: none;
        }

        .row-number {
            background: #1e3a8a;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 4px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .status-badge {
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border: 1px solid;
        }

        .status-completed {
            background: #dcfce7;
            color: #166534;
            border-color: #bbf7d0;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
            border-color: #fde68a;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
            border-color: #fecaca;
        }

        .currency {
            font-weight: 600;
            color: #059669;
            font-family: 'Courier New', monospace;
        }

        .total-amount {
            font-weight: 700;
            font-size: 1.05rem;
            color: #1e3a8a;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: #ffffff;
            border: 2px dashed #cbd5e1;
            border-radius: 8px;
            margin: 2rem 0;
        }

        .empty-state h4 {
            color: #64748b;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .empty-state p {
            color: #94a3b8;
            margin: 0;
            font-style: italic;
        }

        .table-footer {
            background: #f8fafc;
            padding: 1rem;
            text-align: center;
            border-top: 1px solid #e2e8f0;
            color: #64748b;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .main-container {
                margin: 1rem;
                padding: 2rem 1rem;
            }

            .page-title {
                font-size: 1.8rem;
            }

            .summary-stats {
                flex-direction: column;
                gap: 1rem;
            }

            .table-responsive {
                border: 1px solid #d1d5db;
                border-radius: 6px;
            }

            .table {
                min-width: 600px;
            }
        }

        /* Print styles */
        @media print {
            body {
                background: white;
            }
            
            .main-container {
                box-shadow: none;
                border: 1px solid #000;
            }
            
            .page-header {
                border-bottom: 2px solid #000;
            }
        }
    </style>
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<div class="container-fluid">
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Lịch sử thanh toán</h1>
            <p class="page-subtitle">Thông tin chi tiết các giao dịch đã thực hiện</p>
        </div>

        <c:if test="${not empty bookings}">
            <!-- Summary Section -->
            <div class="summary-section">
                <h3 class="summary-title">Tổng quan giao dịch</h3>
                <div class="summary-stats">
                    <div class="stat-item">
                        <span class="stat-number">${bookings.size()}</span>
                        <div class="stat-label">Tổng số giao dịch</div>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">
                            <c:set var="completedCount" value="0"/>
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status == 'Hoàn thành' || b.status == 'Completed'}">
                                    <c:set var="completedCount" value="${completedCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${completedCount}
                        </span>
                        <div class="stat-label">Đã hoàn thành</div>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">
                            <c:set var="totalSpent" value="0"/>
                            <c:forEach var="b" items="${bookings}">
                                <c:set var="totalSpent" value="${totalSpent + b.totalAmount}"/>
                            </c:forEach>
                            <fmt:formatNumber value="${totalSpent}" type="number" maxFractionDigits="0"/>đ
                        </span>
                        <div class="stat-label">Tổng chi tiêu</div>
                    </div>
                </div>
            </div>

            <!-- Payment History Table -->
            <div class="table-section">
                <div class="table-header">
                    <h4>Chi tiết giao dịch</h4>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Ngày giao dịch</th>
                                <th>Trạng thái</th>
                                <th>Phí sân bóng</th>
                                <th>Phí dịch vụ ăn uống</th>
                                <th>Tổng thanh toán</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}" varStatus="loop">
                                <tr>
                                    <td>
                                        <span class="row-number">${loop.index + 1}</span>
                                    </td>
                                    <td>${b.formattedCreatedAt}</td>
                                    <td>
                                        <span class="status-badge 
                                            <c:choose>
                                                <c:when test="${b.status == 'Hoàn thành' || b.status == 'Completed'}">status-completed</c:when>
                                                <c:when test="${b.status == 'Đang xử lý' || b.status == 'Pending'}">status-pending</c:when>
                                                <c:otherwise>status-cancelled</c:otherwise>
                                            </c:choose>">
                                            ${b.status}
                                        </span>
                                    </td>
                                    <td class="currency">
                                        <fmt:formatNumber value="${b.originalAmount}" type="number" maxFractionDigits="0"/>đ
                                    </td>
                                    <td class="currency">
                                        <fmt:formatNumber value="${b.foodAmount}" type="number" maxFractionDigits="0"/>đ
                                    </td>
                                    <td class="currency total-amount">
                                        <fmt:formatNumber value="${b.totalAmount}" type="number" maxFractionDigits="0"/>đ
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="table-footer">
                    <em>Tất cả các giao dịch được sắp xếp theo thời gian mới nhất</em>
                </div>
            </div>
        </c:if>

        <c:if test="${empty bookings}">
            <div class="empty-state">
                <h4>Chưa có giao dịch nào</h4>
                <p>Hiện tại chưa có lịch sử thanh toán. Vui lòng thực hiện đặt sân để xem thông tin giao dịch tại đây.</p>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>