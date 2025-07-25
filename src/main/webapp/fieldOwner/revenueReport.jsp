<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Doanh Thu - Field Manager</title>
    
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

        .logo h3 a {
            text-decoration: none;
            color: #3b82f6;
            transition: all 0.3s ease;
        }

        .logo h3 a:hover {
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

        /* Main Content */
        .main-content {
            margin-left: 300px;
            padding: 40px;
            margin-top: 80px;
            min-height: calc(100vh - 80px);
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
            padding: 40px;
        }

        /* Controls Section */
        .controls-section {
            display: flex;
            gap: 20px;
            margin-bottom: 32px;
            align-items: end;
            flex-wrap: wrap;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-label {
            font-weight: 600;
            color: #1e293b;
            font-size: 14px;
        }

        .form-select {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(59, 130, 246, 0.1);
            border-radius: 12px;
            padding: 12px 16px;
            font-weight: 500;
            color: #1e293b;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
            min-width: 150px;
        }

        .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            outline: none;
        }

        /* Buttons */
        .btn {
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: 'Inter', sans-serif;
            white-space: nowrap;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(59, 130, 246, 0.25);
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(16, 185, 129, 0.25);
        }

        /* Report Table */
        .report-table-container {
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(59, 130, 246, 0.08);
        }

        .report-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
            background: white;
        }

        .report-table th {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 20px 16px;
            border: none;
            text-align: center;
        }

        .report-table th:first-child {
            text-align: left;
            min-width: 150px;
        }

        .report-table td {
            padding: 16px;
            border-bottom: 1px solid rgba(59, 130, 246, 0.05);
            text-align: center;
            font-weight: 500;
        }

        .report-table td:first-child {
            text-align: left;
            font-weight: 600;
            color: #1e293b;
            background: rgba(59, 130, 246, 0.02);
        }

        .report-table tbody tr:hover {
            background: rgba(59, 130, 246, 0.03);
        }

        /* Revenue Formatting */
        .revenue-amount {
            font-weight: 600;
            color: #059669;
        }

        .revenue-zero {
            color: #64748b;
            font-style: italic;
        }

        /* Empty State */
        .empty-data {
            text-align: center;
            padding: 80px 40px;
            color: #64748b;
        }

        .empty-data i {
            font-size: 64px;
            color: #cbd5e1;
            margin-bottom: 24px;
        }

        .empty-data h3 {
            color: #64748b;
            margin-bottom: 12px;
            font-size: 20px;
            font-weight: 600;
        }

        .empty-data p {
            color: #94a3b8;
            font-size: 14px;
        }

        /* Loading State */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .loading-overlay.show {
            opacity: 1;
            visibility: visible;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid rgba(59, 130, 246, 0.1);
            border-left: 4px solid #3b82f6;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 24px;
            }

            .page-title {
                font-size: 28px;
            }

            .card-header,
            .card-body {
                padding: 24px;
            }

            .controls-section {
                flex-direction: column;
                align-items: stretch;
                gap: 16px;
            }

            .report-table-container {
                overflow-x: auto;
            }

            .report-table th,
            .report-table td {
                padding: 12px 8px;
                font-size: 14px;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .top-header .container-fluid {
                padding: 0 24px;
                flex-direction: column;
                gap: 16px;
                align-items: flex-start !important;
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

        /* Utility Classes */
        .d-flex { display: flex; }
        .justify-content-between { justify-content: space-between; }
        .align-items-center { align-items: center; }
        .align-items-end { align-items: end; }
        .me-2 { margin-right: 0.5rem; }
        .mb-3 { margin-bottom: 1rem; }
        .gap-2 { gap: 0.5rem; }
        .flex-wrap { flex-wrap: wrap; }
        .table-bordered { border: 1px solid rgba(59, 130, 246, 0.1); }
    </style>
</head>
<body>

<!-- Top Header -->
<div class="top-header">
    <div class="container-fluid">
        <div class="logo">
            <h3>
                <a href="<%= request.getContextPath() %>/home.jsp">
                    <i class="fas fa-futbol"></i>
                    Field Manager
                </a>
            </h3>
        </div>
        <%
            Object userObj = session.getAttribute("currentUser");
            if (userObj != null) {
        %>
            <div class="user-greeting">
                <i class="fas fa-user-circle"></i>
                Xin chào, <%= ((model.User) userObj).getFullName() %>
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

<!-- Sidebar Navigation -->
<%@ include file="FieldOwnerSB.jsp" %>

<!-- Main Content -->
<div class="main-content">
    <!-- Page Title -->
    <h1 class="page-title fade-in">
        <i class="fas fa-chart-line"></i>
        Báo Cáo Doanh Thu
    </h1>

    <div class="card fade-in">
        <div class="card-header">
            <h5>
                <i class="fas fa-money-bill-trend-up"></i>
                Thống kê doanh thu theo thời gian
            </h5>
        </div>
        <div class="card-body">

            <!-- Controls Section -->
            <div class="controls-section">
                <div class="form-group">
                    <label for="period" class="form-label">
                        <i class="fas fa-calendar me-2" style="color: #3b82f6;"></i>
                        Chọn kỳ báo cáo
                    </label>
                    <select id="period" class="form-select">
                        <option value="day" ${param.period == 'day' ? 'selected' : ''}>Theo Ngày</option>
                        <option value="month" ${param.period == 'month' ? 'selected' : ''}>Theo Tháng</option>
                        <option value="year" ${param.period == 'year' ? 'selected' : ''}>Theo Năm</option>
                    </select>
                </div>

                <!-- Action Buttons -->
                <button type="button" class="btn btn-primary" onclick="viewReport()">
                    <i class="fas fa-chart-bar"></i> Xem Báo Cáo
                </button>

                <button type="button" class="btn btn-success" onclick="exportExcel()">
                    <i class="fas fa-file-excel"></i> Xuất Excel
                </button>
            </div>

            <!-- Report Table -->
            <c:if test="${not empty reports and not empty stadiums and not empty periodList}">
                <div class="report-table-container">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>Thời Gian</th>
                                <c:forEach items="${stadiums}" var="s">
                                    <th>${s}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${periodList}" var="p">
                                <tr>
                                    <td><strong>${p}</strong></td>
                                    <c:forEach items="${stadiums}" var="s">
                                        <c:set var="found" value="false"/>
                                        <c:forEach items="${reports}" var="r">
                                            <c:if test="${r.stadiumName == s && r.period == p}">
                                                <td>
                                                    <span class="revenue-amount">
                                                        <fmt:formatNumber value="${r.totalRevenue}" type="number" groupingUsed="true"/> ₫
                                                    </span>
                                                </td>
                                                <c:set var="found" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!found}">
                                            <td><span class="revenue-zero">0 ₫</span></td>
                                        </c:if>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <!-- Empty State -->
            <c:if test="${empty reports or empty stadiums}">
                <div class="empty-data">
                    <i class="fas fa-chart-line"></i>
                    <h3>Không có dữ liệu báo cáo</h3>
                    <p>Chọn kỳ báo cáo và nhấn "Xem Báo Cáo" để hiển thị dữ liệu</p>
                </div>
            </c:if>

        </div>
    </div>
</div>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="loading-spinner"></div>
</div>

<script>
    function showLoading() {
        document.getElementById('loadingOverlay').classList.add('show');
    }

    function hideLoading() {
        document.getElementById('loadingOverlay').classList.remove('show');
    }

    function viewReport() {
        showLoading();
        const period = document.getElementById('period').value;
        window.location.href = '${pageContext.request.contextPath}/revenue-reports?period=' + period;
    }

    function exportExcel() {
        showLoading();
        const period = document.getElementById('period').value;
        
        // Create a temporary link to download the file
        const link = document.createElement('a');
        link.href = '${pageContext.request.contextPath}/export-revenue-excel?period=' + period;
        link.download = 'revenue-report-' + period + '.xlsx';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        // Hide loading after a short delay
        setTimeout(() => {
            hideLoading();
        }, 1000);
    }

    document.addEventListener("DOMContentLoaded", function () {
        // Add fade-in animation to table rows
        const tableRows = document.querySelectorAll('.report-table tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
            row.classList.add('fade-in');
        });

        // Format revenue numbers with proper styling
        const revenueAmounts = document.querySelectorAll('.revenue-amount');
        revenueAmounts.forEach(amount => {
            const value = parseFloat(amount.textContent.replace(/[^\d]/g, ''));
            if (value > 0) {
                amount.style.color = '#059669';
                amount.style.fontWeight = '600';
            }
        });

        // Hide loading on page load
        hideLoading();
    });

    // Hide loading overlay when page is fully loaded
    window.addEventListener('load', function() {
        hideLoading();
    });
</script>

</body>
</html>