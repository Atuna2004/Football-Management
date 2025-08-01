<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Xem báo cáo người dùng</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3b82f6;
            --primary-dark-color: #1d4ed8;
            --success-color: #10b981;
            --success-dark-color: #059669;
            --warning-color: #f59e0b;
            --warning-dark-color: #d97706;
            --danger-color: #ef4444;
            --danger-dark-color: #dc2626;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --border-light: rgba(59, 130, 246, 0.1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 50%, #dbeafe 100%);
            min-height: 100vh;
            color: var(--text-primary);
            line-height: 1.6;
        }

        .main-container {
            display: flex;
        }

        .main-content {
            margin-left: 280px; /* Adjust this to match your sidebar's width */
            padding: 40px;
            width: calc(100% - 280px);
            min-height: 100vh;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 24px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 24px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(59, 130, 246, 0.07);
            border: 1px solid var(--border-light);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 50px rgba(59, 130, 246, 0.12);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-info h3 {
            font-size: 36px;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1;
        }

        .stat-info p {
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 500;
            margin-top: 4px;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: white;
            flex-shrink: 0;
        }

        .stat-card.primary .stat-icon { background: linear-gradient(135deg, var(--primary-color), var(--primary-dark-color)); }
        .stat-card.success .stat-icon { background: linear-gradient(135deg, var(--success-color), var(--success-dark-color)); }
        .stat-card.danger  .stat-icon { background: linear-gradient(135deg, var(--danger-color), var(--danger-dark-color)); }
        
        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            border: 1px solid var(--border-light);
            margin-bottom: 24px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .card-header {
            padding: 24px 32px;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h2 {
            color: var(--text-primary);
            font-weight: 700;
            font-size: 24px;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .card-header h2 i {
             color: var(--primary-color);
        }
        
        .card-body {
            padding: 24px 32px;
        }
        
        .filter-controls {
            display: grid;
            grid-template-columns: 2fr 1fr; /* Set grid for search and status */
            gap: 16px;
            align-items: center;
        }
        
        .search-box input, .filter-select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #dbeafe;
            border-radius: 12px;
            font-size: 14px;
            background-color: #f8fafc;
            transition: all 0.3s;
            font-family: inherit;
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box input { padding-left: 44px; }
        .search-box i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }
        
        .search-box input:focus, .filter-select:focus {
            outline: none;
            border-color: var(--primary-color);
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }

        .reports-container {
            display: grid;
            gap: 24px;
            grid-template-columns: 1fr;
        }

        @media (min-width: 1200px) {
            .reports-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        .report-card.card {
            margin-bottom: 0; 
        }
        
        .report-card:hover {
             transform: translateY(-5px);
             box-shadow: 0 25px 60px rgba(59, 130, 246, 0.1);
        }

        .user-info { display: flex; align-items: center; gap: 16px; }

        .user-avatar {
            width: 44px; height: 44px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark-color));
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: 600; font-size: 16px; flex-shrink: 0;
        }

        .user-info strong { font-weight: 600; font-size: 15px; }
        .user-info small { color: var(--text-secondary); font-size: 13px; }
        
        .report-card h5 { font-size: 16px; font-weight: 600; margin-bottom: 12px; }
        
        .report-description {
            color: var(--text-secondary); font-size: 14px;
            margin-bottom: 20px; border-left: 3px solid var(--border-light);
            padding: 12px 16px; background-color: #f8fafc;
            border-radius: 0 8px 8px 0;
        }
        
        .report-meta {
            display: flex; flex-wrap: wrap; gap: 12px; align-items: center;
            padding-top: 16px; border-top: 1px solid var(--border-light);
        }
        
        .report-meta-item {
            display: flex; align-items: center; gap: 8px;
            font-size: 13px; color: var(--text-secondary);
        }
        .report-meta-item i { color: var(--text-secondary); }
        
        .badge {
            padding: 5px 12px; border-radius: 20px; font-size: 12px;
            font-weight: 500; display: inline-flex; align-items: center; gap: 6px;
        }
        .badge-pending { background: rgba(59, 130, 246, 0.1); color: #2563eb; }
        .badge-resolved { background: rgba(16, 185, 129, 0.1); color: #059669; }
        .badge-high, .badge-bug { background-color: rgba(239, 68, 68, 0.1); color: #dc2626; }
        .badge-medium, .badge-complaint { background-color: rgba(245, 158, 11, 0.1); color: #d97706; }
        .badge-low, .badge-feature { background-color: rgba(16, 185, 129, 0.1); color: #059669; }
        .badge-report { background-color: var(--bg-light); color: var(--primary-color); }
        .badge-other { background-color: rgba(100, 116, 139, 0.1); color: #64748b; }

        .no-data {
            text-align: center; padding: 60px 40px;
            color: var(--text-secondary);
        }
        .no-data i { font-size: 48px; margin-bottom: 20px; color: rgba(59, 130, 246, 0.2); }
        .no-data div { font-size: 18px; font-weight: 600; color: var(--text-primary); }

        @media (max-width: 1024px) {
            .main-content { margin-left: 0; width: 100%; padding: 24px; }
        }
        @media (max-width: 768px) {
            .stats-grid, .filter-controls, .reports-container { grid-template-columns: 1fr; }
            .card-body, .card-header { padding: 24px; }
        }

    </style>
</head>
<body>

<div class="main-container">
    <%@ include file="sidebar.jsp" %>

    <div class="main-content">
        <c:set var="pendingCount" value="0" />
        <c:set var="resolvedCount" value="0" />
        <c:set var="totalCount" value="0" />
        <c:forEach var="report" items="${reportList}">
            <c:set var="totalCount" value="${totalCount + 1}" />
            <c:if test="${report.status == 'Pending'}"><c:set var="pendingCount" value="${pendingCount + 1}" /></c:if>
            <c:if test="${report.status == 'Resolved'}"><c:set var="resolvedCount" value="${resolvedCount + 1}" /></c:if>
        </c:forEach>

        <div class="stats-grid">
            <div class="stat-card primary">
                <div class="stat-header">
                    <div class="stat-info">
                        <h3>${pendingCount}</h3>
                        <p>Báo cáo mới</p>
                    </div>
                    <div class="stat-icon"><i class="fas fa-inbox"></i></div>
                </div>
            </div>
            <div class="stat-card danger">
                <div class="stat-header">
                    <div class="stat-info">
                        <h3>${totalCount}</h3>
                        <p>Tổng báo cáo</p>
                    </div>
                    <div class="stat-icon"><i class="fas fa-chart-bar"></i></div>
                </div>
            </div>
        </div>

        <div class="card">
             <div class="card-header">
                <h2><i class="fas fa-eye"></i> Xem báo cáo từ người dùng</h2>
            </div>
            <div class="card-body">
                <div class="filter-controls">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm theo tên, email, hoặc tiêu đề..." id="searchInput">
                    </div>
                    <select class="filter-select" id="statusFilter">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Pending">Mới</option>
                        <option value="Resolved">Đã giải quyết</option>
                    </select>
                </div>
            </div>
        </div>
        
        <div class="reports-container" id="reportsContainer">
            <c:if test="${empty reportList}">
                <div class="card">
                    <div class="no-data">
                        <i class="fas fa-clipboard-list"></i>
                        <div>Không tìm thấy báo cáo nào</div>
                        <p>Hiện tại không có báo cáo nào từ người dùng.</p>
                    </div>
                </div>
            </c:if>

            <c:forEach var="report" items="${reportList}">
                <div class="card report-card"
                     data-status="${report.status}"
                     data-type="${report.type}"
                     data-priority="${report.priority}"
                     data-search="${fn:toLowerCase(report.userName)} ${fn:toLowerCase(report.userEmail)} ${fn:toLowerCase(report.title)}">

                    <div class="card-header">
                        <div class="user-info">
                            <div class="user-avatar">${fn:substring(report.userName, 0, 1)}</div>
                            <div>
                                <strong>${report.userName}</strong><br>
                                <small>${report.userEmail}</small>
                            </div>
                        </div>
                        <span class="badge badge-${fn:toLowerCase(fn:replace(report.status, ' ', '-'))}">
                            ${report.status}
                        </span>
                    </div>

                    <div class="card-body">
                        <h5>${report.title}</h5>
                        <p class="report-description">
                             <c:choose>
                                <c:when test="${fn:length(report.description) > 150}">${fn:substring(report.description, 0, 150)}...</c:when>
                                <c:otherwise>${report.description}</c:otherwise>
                            </c:choose>
                        </p>
                        <div class="report-meta">
                             <div class="report-meta-item">
                                <span class="badge badge-${fn:toLowerCase(report.type)}">
                                    <i class="fas fa-tag"></i> ${report.type}
                                </span>
                            </div>
                             <div class="report-meta-item">
                                <i class="fas fa-calendar-alt"></i>
                                <fmt:formatDate value="${report.submittedAt}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    const statusFilter = document.getElementById("statusFilter");
    const searchInput = document.getElementById("searchInput");

    function filterReports() {
        const status = statusFilter.value;
        const searchTerm = searchInput.value.toLowerCase();

        document.querySelectorAll(".report-card").forEach(card => {
            const cardStatus = card.getAttribute("data-status");
            const cardSearch = card.getAttribute("data-search");

            const show =
                (status === "" || cardStatus === status) &&
                (searchTerm === "" || cardSearch.includes(searchTerm));

            card.style.display = show ? "block" : "none";
        });
    }

    statusFilter.addEventListener("change", filterReports);

    let searchTimeout;
    searchInput.addEventListener("input", () => {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(filterReports, 300);
    });
</script>

</body>
</html>