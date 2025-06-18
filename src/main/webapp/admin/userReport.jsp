<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý báo cáo người dùng</title>
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

            .report-management {
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

            .stat-card.new::before {
                background: linear-gradient(90deg, #3182ce, #2b6cb0);
            }

            .stat-card.in-progress::before {
                background: linear-gradient(90deg, #f6ad55, #ed8936);
            }

            .stat-card.resolved::before {
                background: linear-gradient(90deg, #48bb78, #38a169);
            }

            .stat-card.closed::before {
                background: linear-gradient(90deg, #a0aec0, #718096);
            }

            .stat-card .icon {
                font-size: 36px;
                margin-bottom: 15px;
                color: #667eea;
            }

            .stat-card.new .icon {
                color: #3182ce;
            }

            .stat-card.in-progress .icon {
                color: #ed8936;
            }

            .stat-card.resolved .icon {
                color: #38a169;
            }

            .stat-card.closed .icon {
                color: #718096;
            }

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

            .reports-container {
                display: grid;
                gap: 20px;
                grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            }

            .report-card {
                background: white;
                border-radius: 16px;
                padding: 25px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
                border: 1px solid #f0f0f0;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .report-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(0, 0, 0, 0.12);
            }

            .report-status {
                position: absolute;
                top: 20px;
                right: 20px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-new {
                background: linear-gradient(135deg, #bfdbfe, #93c5fd);
                color: #1e40af;
            }

            .status-in-progress {
                background: linear-gradient(135deg, #fed7aa, #fdba74);
                color: #9a3412;
            }

            .status-resolved {
                background: linear-gradient(135deg, #bbf7d0, #86efac);
                color: #166534;
            }

            .status-closed {
                background: linear-gradient(135deg, #e2e8f0, #cbd5e0);
                color: #4a5568;
            }

            .report-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }

            .user-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea, #764ba2);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                font-size: 18px;
                margin-right: 15px;
            }

            .user-info h4 {
                margin: 0;
                font-size: 18px;
                font-weight: 600;
                color: #2d3748;
            }

            .user-info p {
                margin: 5px 0 0 0;
                color: #718096;
                font-size: 14px;
            }

            .report-details {
                margin-bottom: 20px;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                padding: 8px 0;
                border-bottom: 1px solid #f7fafc;
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .detail-label {
                font-weight: 500;
                color: #4a5568;
                font-size: 14px;
            }

            .detail-value {
                color: #2d3748;
                font-weight: 600;
                font-size: 14px;
            }

            .report-type {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
            }

            .type-bug {
                background: #fef2f2;
                color: #dc2626;
            }

            .type-feature {
                background: #f0f9ff;
                color: #0284c7;
            }

            .type-complaint {
                background: #fff7ed;
                color: #ea580c;
            }

            .type-other {
                background: #f7fafc;
                color: #4a5568;
            }

            .priority-level {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
            }

            .priority-high {
                background: #fef2f2;
                color: #dc2626;
            }

            .priority-medium {
                background: #fff7ed;
                color: #ea580c;
            }

            .priority-low {
                background: #f0fdf4;
                color: #16a34a;
            }

            .report-content {
                background: #f8fafc;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                border-left: 4px solid #667eea;
            }

            .report-content h5 {
                margin: 0 0 8px 0;
                font-size: 14px;
                font-weight: 600;
                color: #4a5568;
            }

            .report-content p {
                margin: 0;
                color: #2d3748;
                font-size: 14px;
                line-height: 1.5;
            }

            .attachments-section {
                margin-bottom: 20px;
            }

            .attachments-title {
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 10px;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .attachment-list {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
            }

            .attachment-item {
                background: #f7fafc;
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 12px;
                color: #4a5568;
                display: flex;
                align-items: center;
                gap: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .attachment-item:hover {
                background: #edf2f7;
            }

            .action-buttons {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }

            .btn {
                flex: 1;
                padding: 12px 20px;
                border: none;
                border-radius: 10px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-view {
                background: linear-gradient(135deg, #3182ce, #2c5282);
                color: white;
            }

            .btn-view:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(49, 130, 206, 0.3);
            }

            .btn-resolve {
                background: linear-gradient(135deg, #48bb78, #38a169);
                color: white;
            }

            .btn-resolve:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(72, 187, 120, 0.3);
            }

            .btn-progress {
                background: linear-gradient(135deg, #f6ad55, #ed8936);
                color: white;
            }

            .btn-progress:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(246, 173, 85, 0.3);
            }

            .btn-close {
                background: linear-gradient(135deg, #a0aec0, #718096);
                color: white;
            }

            .btn-close:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(160, 174, 192, 0.3);
            }

            .btn-disabled {
                background: #e2e8f0;
                color: #a0aec0;
                cursor: not-allowed;
            }

            .no-data {
                text-align: center;
                padding: 60px 20px;
                color: #718096;
                font-size: 18px;
                grid-column: 1 / -1;
            }

            .no-data i {
                font-size: 64px;
                margin-bottom: 20px;
                opacity: 0.5;
            }

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

            .form-group textarea, .form-group select {
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

            .form-group textarea:focus, .form-group select:focus {
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

            @media (max-width: 768px) {
                .report-management {
                    margin-left: 0;
                    width: 100%;
                    padding: 20px;
                    border-radius: 0;
                }

                .header-section {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 20px;
                }

                .stats-cards {
                    grid-template-columns: 1fr;
                }

                .filter-section {
                    flex-direction: column;
                }

                .search-box {
                    min-width: auto;
                }

                .reports-container {
                    grid-template-columns: 1fr;
                }

                .modal-content {
                    width: 95%;
                    margin: 10% auto;
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>

        <div class="main-container">
            <%@ include file="sidebar.jsp" %>

            <div class="report-management">
                <div class="header-section">
                    <h2><i class="fas fa-exclamation-triangle"></i> Quản lý báo cáo</h2>
                </div>

                <!-- Thống kê -->
                <div class="stats-cards">
                    <div class="stat-card new">
                        <div class="icon"><i class="fas fa-bell"></i></div>
                        <div class="number">
                            <c:set var="newCount" value="0" />
                            <c:forEach var="report" items="${reportList}">
                                <c:if test="${report.status == 'NEW'}">
                                    <c:set var="newCount" value="${newCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${newCount}
                        </div>
                        <div class="label">Báo cáo mới</div>
                    </div>
                    <div class="stat-card in-progress">
                        <div class="icon"><i class="fas fa-cog"></i></div>
                        <div class="number">
                            <c:set var="progressCount" value="0" />
                            <c:forEach var="report" items="${reportList}">
                                <c:if test="${report.status == 'IN_PROGRESS'}">
                                    <c:set var="progressCount" value="${progressCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${progressCount}
                        </div>
                        <div class="label">Đang xử lý</div>
                    </div>
                    <div class="stat-card resolved">
                        <div class="icon"><i class="fas fa-check-circle"></i></div>
                        <div class="number">
                            <c:set var="resolvedCount" value="0" />
                            <c:forEach var="report" items="${reportList}">
                                <c:if test="${report.status == 'RESOLVED'}">
                                    <c:set var="resolvedCount" value="${resolvedCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${resolvedCount}
                        </div>
                        <div class="label">Đã giải quyết</div>
                    </div>
                    <div class="stat-card closed">
                        <div class="icon"><i class="fas fa-archive"></i></div>
                        <div class="number">${fn:length(reportList) - newCount - progressCount - resolvedCount}</div>
                        <div class="label">Đã đóng</div>
                    </div>
                </div>

                <!-- Bộ lọc -->
                <div class="filter-section">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm theo tên người dùng hoặc tiêu đề..." id="searchInput">
                    </div>
                    <select class="filter-select" id="statusFilter">
                        <option value="">Tất cả trạng thái</option>
                        <option value="NEW">Báo cáo mới</option>
                        <option value="IN_PROGRESS">Đang xử lý</option>
                        <option value="RESOLVED">Đã giải quyết</option>
                        <option value="CLOSED">Đã đóng</option>
                    </select>
                    <select class="filter-select" id="typeFilter">
                        <option value="">Tất cả loại</option>
                        <option value="BUG">Lỗi hệ thống</option>
                        <option value="FEATURE">Yêu cầu tính năng</option>
                        <option value="COMPLAINT">Khiếu nại</option>
                        <option value="OTHER">Khác</option>
                    </select>
                    <select class="filter-select" id="priorityFilter">
                        <option value="">Tất cả độ ưu tiên</option>
                        <option value="HIGH">Cao</option>
                        <option value="MEDIUM">Trung bình</option>
                        <option value="LOW">Thấp</option>
                    </select>
                </div>

                <!-- Danh sách báo cáo -->
                <c:if test="${empty reportList}">
                    <div class="reports-container">
                        <div class="no-data">
                            <i class="fas fa-clipboard-list"></i>
                            <div>Chưa có báo cáo nào từ người dùng</div>
                            <div style="font-size: 14px; margin-top: 10px; opacity: 0.7;">
                                Các báo cáo từ người dùng sẽ hiển thị tại đây
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty reportList}">
                    <div class="reports-container" id="reportsContainer">
                        <c:forEach var="report" items="${reportList}">
                            <div class="report-card" data-status="${report.status}" data-type="${report.type}" data-priority="${report.priority}" data-search="${fn:toLowerCase(report.userName)} ${fn:toLowerCase(report.title)}">
                                <div class="report-status status-${fn:toLowerCase(fn:replace(report.status, '_', '-'))}">
                                    <c:choose>
                                        <c:when test="${report.status == 'NEW'}">Mới</c:when>
                                        <c:when test="${report.status == 'IN_PROGRESS'}">Đang xử lý</c:when>
                                        <c:when test="${report.status == 'RESOLVED'}">Đã giải quyết</c:when>
                                        <c:otherwise>Đã đóng</c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="report-header">
                                    <div class="user-avatar">
                                        ${fn:substring(report.userName, 0, 1)}
                                    </div>
                                    <div class="user-info">
                                        <h4>${report.userName}</h4>
                                        <p>${report.userEmail}</p>
                                    </div>
                                </div>

                                <div class="report-details">
                                    <div class="detail-row">
                                        <span class="detail-label">Tiêu đề:</span>
                                        <span class="detail-value">${report.title}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Loại báo cáo:</span>
                                        <span class="detail-value">
                                            <span class="report-type type-${fn:toLowerCase(report.type)}">
                                                <c:choose>
                                                    <c:when test="${report.type == 'BUG'}">
                                                        <i class="fas fa-bug"></i> Lỗi hệ thống
                                                    </c:when>
                                                    <c:when test="${report.type == 'FEATURE'}">
                                                        <i class="fas fa-lightbulb"></i> Yêu cầu tính năng
                                                    </c:when>
                                                    <c:when test="${report.type == 'COMPLAINT'}">
                                                        <i class="fas fa-exclamation-circle"></i> Khiếu nại
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle"></i> Khác
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Độ ưu tiên:</span>
                                        <span class="detail-value">
                                            <span class="priority-level priority-${fn:toLowerCase(report.priority)}">
                                                <c:choose>
                                                    <c:when test="${report.priority == 'HIGH'}">
                                                        <i class="fas fa-exclamation-triangle"></i> Cao
                                                    </c:when>
                                                    <c:when test="${report.priority == 'MEDIUM'}">
                                                        <i class="fas fa-minus"></i> Trung bình
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-arrow-down"></i> Thấp
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Ngày tạo:</span>
                                        <span class="detail-value">
                                            <fmt:formatDate value="${report.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </span>
                                    </div>
                                </div>

                                <!-- Nội dung báo cáo -->
                                <div class="report-content">
                                    <h5><i class="fas fa-file-alt"></i> Nội dung báo cáo:</h5>
                                    <p>${fn:length(report.description) > 150 ? fn:substring(report.description, 0, 150).concat('...') : report.description}</p>
                                </div>

                                <!-- File đính kèm -->
                                <c:if test="${not empty report.attachments}">
                                    <div class="attachments-section">
                                        <div class="attachments-title">
                                            <i class="fas fa-paperclip"></i>
                                            File đính kèm
                                        </div>
                                        <div class="attachment-list">
                                            <c:forEach var="attachment" items="${report.attachments}">
                                                <div class="attachment-item" onclick="viewAttachment('${attachment.fileName}')">
                                                    <i class="fas fa-file"></i>
                                                    ${attachment.fileName}
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Nút hành động -->
                                <div class="action-buttons">
                                    <button class="btn btn-view" onclick="viewReportDetails(${report.id})">
                                        <i class="fas fa-eye"></i>
                                        Xem chi tiết
                                    </button>
                                    <c:choose>
                                        <c:when test="${report.status == 'NEW'}">
                                                                                       <button class="btn btn-progress" onclick="updateReportStatus(${report.id}, 'IN_PROGRESS')">
                                                <i class="fas fa-cog"></i>
                                                Đang xử lý
                                            </button>
                                            <button class="btn btn-resolve" onclick="updateReportStatus(${report.id}, 'RESOLVED')">
                                                <i class="fas fa-check"></i>
                                                Giải quyết
                                            </button>
                                            <button class="btn btn-close" onclick="updateReportStatus(${report.id}, 'CLOSED')">
                                                <i class="fas fa-archive"></i>
                                                Đóng
                                            </button>
                                        </c:when>
                                        <c:when test="${report.status == 'IN_PROGRESS'}">
                                            <button class="btn btn-resolve" onclick="updateReportStatus(${report.id}, 'RESOLVED')">
                                                <i class="fas fa-check"></i>
                                                Giải quyết
                                            </button>
                                            <button class="btn btn-close" onclick="updateReportStatus(${report.id}, 'CLOSED')">
                                                <i class="fas fa-archive"></i>
                                                Đóng
                                            </button>
                                        </c:when>
                                        <c:when test="${report.status == 'RESOLVED'}">
                                            <button class="btn btn-close" onclick="updateReportStatus(${report.id}, 'CLOSED')">
                                                <i class="fas fa-archive"></i>
                                                Đóng
                                            </button>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Modal Chi tiết Báo cáo -->
        <div id="reportModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-exclamation-triangle"></i> Chi tiết báo cáo</h3>
                    <span class="close" onclick="closeModal()">&times;</span>
                </div>
                <div class="form-group">
                    <label for="reportTitle">Tiêu đề</label>
                    <input type="text" id="reportTitle" class="filter-select" disabled />
                </div>
                <div class="form-group">
                    <label for="reportDescription">Nội dung</label>
                    <textarea id="reportDescription" disabled></textarea>
                </div>
                <div class="form-group">
                    <label for="reportUser">Người gửi</label>
                    <input type="text" id="reportUser" class="filter-select" disabled />
                </div>
                <div class="form-group">
                    <label for="reportDate">Ngày tạo</label>
                    <input type="text" id="reportDate" class="filter-select" disabled />
                </div>
                <div class="form-group">
                    <label for="reportType">Loại báo cáo</label>
                    <input type="text" id="reportType" class="filter-select" disabled />
                </div>
                <div class="form-group">
                    <label for="reportPriority">Độ ưu tiên</label>
                    <input type="text" id="reportPriority" class="filter-select" disabled />
                </div>
                <div class="attachments-section">
                    <div class="attachments-title">
                        <i class="fas fa-paperclip"></i>
                        File đính kèm
                    </div>
                    <div id="modalAttachments" class="attachment-list"></div>
                </div>
                <div class="modal-actions">
                    <button class="btn-secondary" onclick="closeModal()">Đóng</button>
                </div>
            </div>
        </div>

        <!-- JavaScript xử lý Filter, Search, Modal -->
        <script>
            function viewReportDetails(reportId) {
                // Dùng fetch hoặc gọi API để lấy dữ liệu chi tiết
                // Trong ví dụ này mình giả lập bằng JS object
                const reports = [
                    <c:forEach var="report" items="${reportList}" varStatus="loop">
                        {
                            id: ${report.id},
                            title: "${report.title}",
                            description: "${report.description}",
                            userName: "${report.userName}",
                            userEmail: "${report.userEmail}",
                            createdDate: "<fmt:formatDate value='${report.createdDate}' pattern='dd/MM/yyyy HH:mm' />",
                            type: "${report.type}",
                            priority: "${report.priority}",
                            attachments: [
                                <c:forEach var="att" items="${report.attachments}" varStatus="attLoop">
                                    { fileName: "${att.fileName}" }<c:if test="${!attLoop.last}">,</c:if>
                                </c:forEach>
                            ]
                        }<c:if test="${!loop.last}">,</c:if>
                    </c:forEach>
                ];

                const report = reports.find(r => r.id === reportId);
                if (!report) return;

                document.getElementById("reportTitle").value = report.title;
                document.getElementById("reportDescription").value = report.description;
                document.getElementById("reportUser").value = report.userName + " (${report.userEmail})";
                document.getElementById("reportDate").value = report.createdDate;
                document.getElementById("reportType").value = formatType(report.type);
                document.getElementById("reportPriority").value = formatPriority(report.priority);

                const attContainer = document.getElementById("modalAttachments");
                attContainer.innerHTML = "";

                if (report.attachments.length > 0) {
                    report.attachments.forEach(att => {
                        const div = document.createElement("div");
                        div.className = "attachment-item";
                        div.innerHTML = `<i class="fas fa-file"></i> ${att.fileName}`;
                        attContainer.appendChild(div);
                    });
                } else {
                    attContainer.innerHTML = "<p>Không có file đính kèm</p>";
                }

                document.getElementById("reportModal").style.display = "block";
            }

            function closeModal() {
                document.getElementById("reportModal").style.display = "none";
            }

            function formatType(type) {
                switch(type) {
                    case "BUG": return "Lỗi hệ thống";
                    case "FEATURE": return "Yêu cầu tính năng";
                    case "COMPLAINT": return "Khiếu nại";
                    default: return "Khác";
                }
            }

            function formatPriority(priority) {
                switch(priority) {
                    case "HIGH": return "Cao";
                    case "MEDIUM": return "Trung bình";
                    case "LOW": return "Thấp";
                    default: return "";
                }
            }

            // Cập nhật trạng thái báo cáo
            function updateReportStatus(reportId, newStatus) {
                if (confirm("Bạn có chắc muốn cập nhật trạng thái?")) {
                    window.location.href = "update-report-status?id=" + reportId + "&status=" + newStatus;
                }
            }

            // Lọc báo cáo theo trạng thái
            document.getElementById("statusFilter").addEventListener("change", filterReports);
            document.getElementById("typeFilter").addEventListener("change", filterReports);
            document.getElementById("priorityFilter").addEventListener("change", filterReports);
            document.getElementById("searchInput").addEventListener("input", filterReports);

            function filterReports() {
                const status = document.getElementById("statusFilter").value;
                const type = document.getElementById("typeFilter").value;
                const priority = document.getElementById("priorityFilter").value;
                const searchTerm = document.getElementById("searchInput").value.toLowerCase();

                document.querySelectorAll(".report-card").forEach(card => {
                    const cardStatus = card.getAttribute("data-status");
                    const cardType = card.getAttribute("data-type");
                    const cardPriority = card.getAttribute("data-priority");
                    const cardSearch = card.getAttribute("data-search");

                    let show = true;

                    if (status && cardStatus !== status) show = false;
                    if (type && cardType !== type) show = false;
                    if (priority && cardPriority !== priority) show = false;
                    if (searchTerm && !cardSearch.includes(searchTerm)) show = false;

                    card.style.display = show ? "block" : "none";
                });
            }

            // Ripple animation (nếu bạn giữ nguyên phần này)
            document.addEventListener('DOMContentLoaded', function () {
                const buttons = document.querySelectorAll('.btn');
                buttons.forEach(btn => {
                    btn.style.position = 'relative';
                    btn.style.overflow = 'hidden';

                    btn.addEventListener('click', function (e) {
                        if (!this.classList.contains('btn-disabled')) {
                            e.preventDefault();
                        }
                        const ripple = document.createElement('span');
                        const rect = this.getBoundingClientRect();
                        const size = Math.max(rect.width, rect.height);
                        ripple.style.cssText = `
                            position: absolute;
                            width: ${size}px;
                            height: ${size}px;
                            background: rgba(255, 255, 255, 0.6);
                            border-radius: 50%;
                            left: ${e.clientX - rect.left - size / 2}px;
                            top: ${e.clientY - rect.top - size / 2}px;
                            transform: scale(0);
                            animation: ripple 0.6s ease-out;
                            pointer-events: none;
                        `;
                        this.appendChild(ripple);
                        setTimeout(() => ripple.remove(), 600);
                    });
                });
            });

            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    to {
                        transform: scale(2);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        </script>
    </body>
</html>
                                                