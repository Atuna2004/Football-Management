<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử hoạt động</title>
    <link rel="stylesheet" href="assets/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', sans-serif;
            box-sizing: border-box;
        }
        body {
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            min-height: 100vh;
        }
        .main-container {
            display: flex;
        }
        .history-management {
            margin-left: 250px;
            padding: 40px;
            width: calc(100% - 250px);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            min-height: 100vh;
            border-radius: 20px 0 0 0;
            box-shadow: -10px 0 30px rgba(0, 0, 0, 0.1);
        }
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        .header-section h2 {
            font-size: 32px;
            font-weight: 700;
            color: #2d3748;
            margin: 0;
            position: relative;
        }
        .header-section h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 50px;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        /* Thống kê */
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 1px solid #f0f0f0;
            position: relative;
            overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
        }
        .stat-card.view::before { background: linear-gradient(90deg, #3182ce, #2b6cb0); }
        .stat-card.edit::before { background: linear-gradient(90deg, #f6ad55, #ed8936); }
        .stat-card.login::before { background: linear-gradient(90deg, #48bb78, #38a169); }
        .stat-card.logout::before { background: linear-gradient(90deg, #a0aec0, #718096); }

        .stat-card .icon {
            font-size: 36px;
            margin-bottom: 15px;
            color: #667eea;
        }
        .stat-card.view .icon { color: #3182ce; }
        .stat-card.edit .icon { color: #ed8936; }
        .stat-card.login .icon { color: #38a169; }
        .stat-card.logout .icon { color: #718096; }

        .stat-card .number {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
            color: #2d3748;
        }
        .stat-card .label {
            font-size: 14px;
            color: #718096;
            font-weight: 500;
        }

        /* Bộ lọc */
        .filter-section {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
            align-items: center;
        }
        .search-box {
            flex: 1;
            min-width: 300px;
            position: relative;
        }
        .search-box input {
            width: 100%;
            padding: 14px 20px 14px 50px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 16px;
            transition: border-color 0.3s ease;
            background: white;
        }
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .search-box i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 16px;
        }
        .filter-select {
            padding: 14px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 16px;
            background: white;
            cursor: pointer;
            transition: border-color 0.3s ease;
            min-width: 160px;
        }
        .filter-select:focus {
            outline: none;
            border-color: #667eea;
        }

        /* Danh sách hoạt động */
        .activities-container {
            display: grid;
            gap: 20px;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
        }
        .activity-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border: 1px solid #f0f0f0;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .activity-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.12);
        }
        .activity-user {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin-right: 12px;
        }
        .user-info h4 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
            color: #2d3748;
        }
        .user-info p {
            margin: 4px 0 0 0;
            color: #718096;
            font-size: 13px;
        }
        .activity-time {
            font-size: 12px;
            color: #a0aec0;
            margin-bottom: 15px;
        }
        .activity-description {
            font-size: 14px;
            color: #2d3748;
            line-height: 1.5;
        }
        .activity-type {
            display: inline-block;
            margin-top: 15px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .type-view { background: #bfdbfe; color: #1e40af; }
        .type-edit { background: #fed7aa; color: #9a3412; }
        .type-login { background: #bbf7d0; color: #166534; }
        .type-logout { background: #e2e8f0; color: #4a5568; }

        /* Modal chi tiết */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
        }
        .modal-content {
            background: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 16px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        .modal-header h3 {
            margin: 0;
            color: #2d3748;
            font-size: 20px;
            font-weight: 600;
        }
        .close {
            font-size: 24px;
            cursor: pointer;
            color: #a0aec0;
            transition: color 0.3s ease;
        }
        .close:hover {
            color: #e53e3e;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #4a5568;
        }
        .form-group textarea,
        .form-group input[type="text"],
        .form-group input[type="datetime-local"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .modal-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }
        .btn-secondary:hover {
            background: #cbd5e0;
        }

        /* Ripple animation */
        .btn {
            position: relative;
            overflow: hidden;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
        }

        @keyframes ripple {
            to {
                transform: scale(2);
                opacity: 0;
            }
        }
    </style>
</head>
<body>

<div class="main-container">
    <%@ include file="sidebar.jsp" %>

    <div class="history-management">
        <div class="header-section">
            <h2><i class="fas fa-history"></i> Lịch sử hoạt động</h2>
        </div>

        <!-- Thống kê -->
        <div class="stats-cards">
            <div class="stat-card view">
                <div class="icon"><i class="fas fa-eye"></i></div>
                <div class="number">
                    <c:set var="viewCount" value="0" />
                    <c:forEach var="act" items="${activityList}">
                        <c:if test="${act.type == 'VIEW'}">
                            <c:set var="viewCount" value="${viewCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${viewCount}
                </div>
                <div class="label">Xem thông tin</div>
            </div>
            <div class="stat-card edit">
                <div class="icon"><i class="fas fa-edit"></i></div>
                <div class="number">
                    <c:set var="editCount" value="0" />
                    <c:forEach var="act" items="${activityList}">
                        <c:if test="${act.type == 'EDIT'}">
                            <c:set var="editCount" value="${editCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${editCount}
                </div>
                <div class="label">Chỉnh sửa</div>
            </div>
            <div class="stat-card login">
                <div class="icon"><i class="fas fa-sign-in-alt"></i></div>
                <div class="number">
                    <c:set var="loginCount" value="0" />
                    <c:forEach var="act" items="${activityList}">
                        <c:if test="${act.type == 'LOGIN'}">
                            <c:set var="loginCount" value="${loginCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${loginCount}
                </div>
                <div class="label">Đăng nhập</div>
            </div>
            <div class="stat-card logout">
                <div class="icon"><i class="fas fa-sign-out-alt"></i></div>
                <div class="number">
                    <c:set var="logoutCount" value="0" />
                    <c:forEach var="act" items="${activityList}">
                        <c:if test="${act.type == 'LOGOUT'}">
                            <c:set var="logoutCount" value="${logoutCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${logoutCount}
                </div>
                <div class="label">Đăng xuất</div>
            </div>
        </div>

        <!-- Bộ lọc -->
        <div class="filter-section">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Tìm kiếm người dùng hoặc mô tả..." id="searchInput">
            </div>
            <select class="filter-select" id="typeFilter">
                <option value="">Tất cả loại</option>
                <option value="VIEW">Xem</option>
                <option value="EDIT">Sửa</option>
                <option value="LOGIN">Đăng nhập</option>
                <option value="LOGOUT">Đăng xuất</option>
            </select>
            <select class="filter-select" id="dateFilter">
                <option value="">Tất cả thời gian</option>
                <option value="today">Hôm nay</option>
                <option value="week">Tuần này</option>
                <option value="month">Tháng này</option>
            </select>
        </div>

        <!-- Danh sách hoạt động -->
        <c:if test="${empty activityList}">
            <div class="activities-container no-data">
                <div style="text-align: center; padding: 60px 20px;">
                    <i class="fas fa-history" style="font-size: 64px; opacity: 0.5;"></i>
                    <h3>Không có hoạt động nào</h3>
                    <p style="color: #718096;">Các hoạt động sẽ hiển thị tại đây</p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty activityList}">
            <div class="activities-container" id="activitiesContainer">
                <c:forEach var="act" items="${activityList}">
                    <div class="activity-card"
                         data-type="${act.type}"
                         data-user="${fn:toLowerCase(act.userName)}"
                         data-desc="${fn:toLowerCase(act.description)}">
                        <div class="activity-user">
                            <div class="user-avatar">${fn:substring(act.userName, 0, 1)}</div>
                            <div class="user-info">
                                <h4>${act.userName}</h4>
                                <p>${act.userEmail}</p>
                            </div>
                        </div>
                        <div class="activity-time">
                            <fmt:formatDate value="${act.timestamp}" pattern="dd/MM/yyyy HH:mm" />
                        </div>
                        <div class="activity-description">${act.description}</div>
                        <div class="activity-type type-${fn:toLowerCase(act.type)}">
                            <c:choose>
                                <c:when test="${act.type == 'VIEW'}">Xem</c:when>
                                <c:when test="${act.type == 'EDIT'}">Chỉnh sửa</c:when>
                                <c:when test="${act.type == 'LOGIN'}">Đăng nhập</c:when>
                                <c:when test="${act.type == 'LOGOUT'}">Đăng xuất</c:when>
                                <c:otherwise>Hành động khác</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<!-- JavaScript cho filter -->
<script>
    document.getElementById("searchInput").addEventListener("input", filterActivities);
    document.getElementById("typeFilter").addEventListener("change", filterActivities);

    function filterActivities() {
        const search = document.getElementById("searchInput").value.toLowerCase();
        const type = document.getElementById("typeFilter").value;

        document.querySelectorAll(".activity-card").forEach(card => {
            const user = card.getAttribute("data-user");
            const desc = card.getAttribute("data-desc");

            let show = true;

            if (type && card.getAttribute("data-type") !== type) show = false;
            if (search && !user.includes(search) && !desc.includes(search)) show = false;

            card.style.display = show ? "block" : "none";
        });
    }

    // Ripple animation
    document.addEventListener('DOMContentLoaded', function () {
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(btn => {
            btn.addEventListener('click', function (e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                ripple.style.cssText = `