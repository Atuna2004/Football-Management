<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="model.User" %>
<%@ page import="model.Report" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Field Owner Reports</title>
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
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
            min-height: calc(100vh - 80px);
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

        .stat-card.new-reports .icon {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        }

        .stat-card.resolved .icon {
            background: linear-gradient(135deg, #10b981, #059669);
        }

        .stat-card.total .icon {
            background: linear-gradient(135deg, #64748b, #475569);
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

        /* Filter Form */
        .report-form {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            border: 1px solid rgba(59, 130, 246, 0.1);
            padding: 32px 40px;
            margin-bottom: 40px;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: 2fr 1fr auto;
            gap: 20px;
            align-items: end;
        }

        .report-form input,
        .report-form select {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(59, 130, 246, 0.1);
            border-radius: 12px;
            padding: 12px 16px;
            font-weight: 500;
            color: #1e293b;
            transition: all 0.3s ease;
            width: 100%;
            font-family: 'Inter', sans-serif;
        }

        .report-form input:focus,
        .report-form select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            outline: none;
        }

        .report-form button {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            white-space: nowrap;
            display: flex;
            align-items: center;
            gap: 8px;
            font-family: 'Inter', sans-serif;
        }

        .report-form button:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(59, 130, 246, 0.25);
        }

        /* Reports Container */
        .reports-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            border: 1px solid rgba(59, 130, 246, 0.1);
            overflow: hidden;
        }

        .report-item {
            padding: 32px 40px;
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            transition: all 0.3s ease;
        }

        .report-item:last-child {
            border-bottom: none;
        }

        .report-item:hover {
            background: rgba(59, 130, 246, 0.03);
        }

        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 24px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 16px;
            flex: 1;
        }

        .user-avatar {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 20px;
        }

        .user-details h5 {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 4px;
            font-size: 16px;
        }

        .user-details .email {
            color: #64748b;
            font-size: 14px;
        }

        /* Status Badge */
        .status-badge {
            padding: 8px 16px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-Pending {
            background: rgba(245, 158, 11, 0.1);
            color: #d97706;
        }

        .status-Resolved {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
        }

        /* Report Content */
        .report-title {
            font-size: 20px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 12px;
        }

        .report-description {
            color: #64748b;
            margin-bottom: 24px;
            line-height: 1.6;
        }

        .report-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            background: rgba(59, 130, 246, 0.03);
            padding: 20px;
            border-radius: 16px;
            margin-bottom: 24px;
        }

        .meta-item {
            display: flex;
            flex-direction: column;
        }

        .meta-label {
            font-size: 12px;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .meta-value {
            color: #1e293b;
            font-weight: 500;
        }

        /* Admin Response */
        .admin-response {
            background: rgba(6, 182, 212, 0.05);
            border: 1px solid rgba(6, 182, 212, 0.1);
            padding: 20px;
            border-radius: 16px;
            margin-top: 20px;
        }

        /* Action Buttons */
        .report-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: 'Inter', sans-serif;
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(16, 185, 129, 0.25);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(239, 68, 68, 0.25);
        }

        /* Empty State */
        .empty-data {
            text-align: center;
            padding: 80px 40px;
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

        /* Alert Styles */
        .alert {
            border: none;
            border-radius: 16px;
            padding: 20px 24px;
            font-weight: 500;
            backdrop-filter: blur(10px);
            margin-bottom: 32px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Form Styling */
        .d-inline-block {
            display: inline-block;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 24px;
            }

            .filter-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
                gap: 24px;
            }

            .report-header {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }

            .report-meta {
                grid-template-columns: 1fr;
            }

            .report-actions {
                justify-content: flex-start;
            }

            .page-title {
                font-size: 28px;
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

        .animate-delay-1 { animation-delay: 0.1s; animation-fill-mode: both; }
        .animate-delay-2 { animation-delay: 0.2s; animation-fill-mode: both; }
        .animate-delay-3 { animation-delay: 0.3s; animation-fill-mode: both; }
    </style>
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="container-fluid">
            <!-- Logo và tên trang quản lý -->
            <div class="logo">
                <h3>
                    <a href="<%= request.getContextPath() %>/home.jsp">
                        <i class="fas fa-futbol"></i>
                    </a>
                    Field Manager
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

    <!-- Sidebar -->
    <%@ include file="FieldOwnerSB.jsp" %>

    <!-- Main Content -->
    <main class="main-content">
        <h1 class="page-title fade-in">
            <i class="fas fa-exclamation-triangle"></i>
            Quản lý báo cáo
        </h1>

        <%-- Display status update messages --%>
        <c:if test="${not empty param.statusUpdate}">
            <div class="alert alert-${param.statusUpdate == 'success' ? 'success' : 'danger'} fade-in">
                <c:if test="${param.statusUpdate == 'success'}">
                    <i class="fas fa-check-circle"></i>
                    <div>
                        <strong>Thành công!</strong> Báo cáo ID <c:out value="${param.reportID}"/> đã được cập nhật thành trạng thái <c:out value="${param.newStatus}"/>.
                    </div>
                </c:if>
                <c:if test="${param.statusUpdate == 'error'}">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>
                        <strong>Lỗi!</strong> Không thể cập nhật báo cáo ID <c:out value="${param.reportID}"/>. <c:out value="${param.errorMessage}"/>
                    </div>
                </c:if>
            </div>
        </c:if>

        <%-- Calculate counts for stat cards --%>
        <%
            List<Report> allReports = (List<Report>) request.getAttribute("reports");
            if (allReports == null) {
                allReports = new java.util.ArrayList<>();
            }
            long newReportsCount = allReports.stream().filter(r -> "Pending".equalsIgnoreCase(r.getStatus())).count();
            long resolvedReportsCount = allReports.stream().filter(r -> "Resolved".equalsIgnoreCase(r.getStatus())).count();
            long totalReportsCount = allReports.size();
        %>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card new-reports fade-in animate-delay-1">
                <div class="icon"><i class="fas fa-bell"></i></div>
                <h4><%= newReportsCount %></h4>
                <p>Báo cáo mới</p>
            </div>
            <div class="stat-card resolved fade-in animate-delay-2">
                <div class="icon"><i class="fas fa-check-circle"></i></div>
                <h4><%= resolvedReportsCount %></h4>
                <p>Đã giải quyết</p>
            </div>
            <div class="stat-card total fade-in animate-delay-3">
                <div class="icon"><i class="fas fa-chart-bar"></i></div>
                <h4><%= totalReportsCount %></h4>
                <p>Tổng báo cáo</p>
            </div>
        </div>

        <!-- Filter Form -->
        <div class="report-form fade-in">
            <form action="${pageContext.request.contextPath}/owner/reports" method="get">
                <div class="filter-grid">
                    <input type="text" name="search" placeholder="Tìm kiếm theo người dùng hoặc tiêu đề..." value="${param.search != null ? param.search : ''}">
                    
                    <select name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Pending" ${"Pending" eq param.status ? 'selected' : ''}>Pending</option>
                        <option value="Resolved" ${"Resolved" eq param.status ? 'selected' : ''}>Resolved</option>
                    </select>
                    
                    <button type="submit">
                        <i class="fas fa-filter"></i> Lọc
                    </button>
                </div>
            </form>
        </div>

        <!-- Reports List -->
        <div class="reports-container fade-in">
            <c:if test="${empty reports}">
                <div class="empty-data">
                    <i class="fas fa-inbox"></i>
                    <h3>Không có báo cáo nào</h3>
                    <p>Không có báo cáo nào phù hợp với các tiêu chí tìm kiếm.</p>
                </div>
            </c:if>
            
            <c:if test="${not empty reports}">
                <c:forEach var="report" items="${reports}">
                    <div class="report-item">
                        <div class="report-header">
                            <div class="user-info">
                                <div class="user-avatar">
                                    <%-- Display first letter of full name or email --%>
                                    <c:choose>
                                        <c:when test="${not empty report.userName}">
                                            <c:out value="${fn:substring(report.userName, 0, 1).toUpperCase()}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${fn:substring(report.userEmail, 0, 1).toUpperCase()}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="user-details">
                                    <h5><c:out value="${report.userName != null ? report.userName : 'N/A'}"/></h5>
                                    <div class="email"><c:out value="${report.userEmail}"/></div>
                                </div>
                            </div>
                            <span class="status-badge status-<c:out value="${report.status}"/>">
                                <c:out value="${report.status}"/>
                            </span>
                        </div>
                        
                        <div class="report-content">
                            <h3 class="report-title"><c:out value="${report.title}"/></h3>
                            <p class="report-description"><c:out value="${report.description}"/></p>
                            
                            <div class="report-meta">
                                <div class="meta-item">
                                    <span class="meta-label">Ngày tạo</span>
                                    <span class="meta-value"><fmt:formatDate value="${report.submittedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                </div>
                                <div class="meta-item">
                                    <span class="meta-label">Sân liên quan</span>
                                    <span class="meta-value"><c:out value="${report.stadiumName != null ? report.stadiumName : 'N/A'}"/> (ID: <c:out value="${report.relatedStadiumID != null ? report.relatedStadiumID : 'N/A'}"/>)</span>
                                </div>
                            </div>
                            
                            <c:if test="${not empty report.adminResponse}">
                                <div class="admin-response">
                                    <div class="meta-item">
                                        <span class="meta-label">Phản hồi Admin</span>
                                        <span class="meta-value"><c:out value="${report.adminResponse}"/></span>
                                    </div>
                                    <div class="meta-item" style="margin-top: 10px;">
                                        <span class="meta-label">Phản hồi lúc</span>
                                        <span class="meta-value"><fmt:formatDate value="${report.respondedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="report-actions">
                            <c:if test="${'Pending' eq report.status}">
                                <%-- Use separate forms for POST requests --%>
                                <form action="${pageContext.request.contextPath}/owner/reports" method="post" class="d-inline-block">
                                    <input type="hidden" name="reportID" value="${report.reportID}">
                                    <input type="hidden" name="newStatus" value="Resolved">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-check"></i> Giải quyết
                                    </button>
                                </form>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/owner/reports" method="post" class="d-inline-block">
                                <input type="hidden" name="reportID" value="${report.reportID}">
                                <input type="hidden" name="action" value="delete">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa báo cáo này không? Hành động này không thể hoàn tác.')">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>
    </main>

    <script>
        // JavaScript for active menu item in sidebar
        document.addEventListener("DOMContentLoaded", function () {
            const navLinks = document.querySelectorAll(".navigation-sidebar .nav-link");
            const currentPath = window.location.pathname + window.location.search;

            navLinks.forEach(link => {
                const linkHref = link.getAttribute('href');
                if (linkHref) {
                    if (currentPath === linkHref || currentPath.startsWith(linkHref + "?") || currentPath.startsWith(linkHref + "/")) {
                        link.classList.add("active");
                    }
                }
            });

            // Add fade-in animation to report items
            const reportItems = document.querySelectorAll('.report-item');
            reportItems.forEach((item, index) => {
                item.style.animationDelay = `${index * 0.1}s`;
                item.classList.add('fade-in');
            });
        });
    </script>
</body>
</html>