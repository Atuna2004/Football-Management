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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }

        /* Header Styles */
        .top-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            height: 80px;
        }

        .top-header .container-fluid {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
        }

        .logo h3 {
            margin: 0;
            font-weight: 600;
            font-size: 1.5rem;
        }

        .logo a {
            text-decoration: none !important;
            color: inherit;
        }

        .logo a:hover {
            text-decoration: none !important;
            color: inherit;
        }

        .user-greeting {
            color: white;
            font-size: 16px;
            font-weight: 500;
        }

        .user-greeting i {
            margin-right: 8px;
            color: rgba(255,255,255,0.8);
        }

        /* Sidebar Styles */
        .navigation-sidebar {
            position: fixed;
            top: 80px; /* Adjusted to be below the fixed header */
            bottom: 0;
            left: 0;
            width: 280px; /* Explicitly set width as per your CSS */
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            overflow-y: auto;
            z-index: 999;
        }

        .navigation-sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .navigation-sidebar li {
            margin-bottom: 10px;
        }

        .navigation-sidebar a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 15px;
            border-radius: 6px;
            text-decoration: none;
            color: #333;
            transition: background 0.3s ease;
        }

        .navigation-sidebar a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .navigation-sidebar a:hover {
            background: #f5f5f5;
            color: #333;
        }

        .navigation-sidebar a.active:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .navigation-sidebar i {
            font-size: 18px;
        }

        /* Main Content Styles */
        .main-content {
            margin-left: 280px; /* CRUCIAL: Offset by sidebar width */
            padding: 30px;
            background: #f8f9fa;
            min-height: calc(100vh - 80px); /* Account for fixed header */
            margin-top: 80px; /* Account for fixed header */
        }

        /* Page Title */
        .page-title {
            color: #333;
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .stat-card .icon {
            font-size: 3rem;
            margin-bottom: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-card.new-reports .icon { color: #667eea; }
        .stat-card.in-progress .icon { color: #ffc107; }
        .stat-card.resolved .icon { color: #28a745; }
        .stat-card.rejected .icon { color: #dc3545; }

        .stat-card h4 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }

        .stat-card p {
            color: #666;
            font-size: 1rem;
            font-weight: 500;
        }

        /* Filter Section */
        .report-form {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }

        .report-form input,
        .report-form select {
            padding: 12px 16px;
            font-size: 14px;
            border-radius: 8px;
            border: 2px solid #e9ecef;
            background: white;
            transition: border-color 0.3s ease;
            width: 100%;
        }

        .report-form input:focus,
        .report-form select:focus {
            outline: none;
            border-color: #667eea;
        }

        .report-form button {
            padding: 12px 20px;
            font-size: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
            white-space: nowrap;
        }

        .report-form button:hover {
            background: linear-gradient(135deg, #5a67d8 0%, #667eea 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        /* Reports List */
        .reports-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .report-item {
            padding: 25px;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.3s ease;
        }

        .report-item:last-child {
            border-bottom: none;
        }

        .report-item:hover {
            background: #f8f9fa;
        }

        .report-header {
            display: flex;
            justify-content: space-between; /* Changed from 'between' to 'space-between' for clarity */
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
            flex: 1;
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 1.2rem;
        }

        .user-details h5 {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .user-details .email {
            color: #666;
            font-size: 0.9rem;
        }

        /* Status Badge */
        .status-badge {
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-Pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-InProgress {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-Resolved {
            background: #d4edda;
            color: #155724;
        }

        .status-Rejected, .status-Closed {
            background: #f8d7da;
            color: #721c24;
        }

        /* Report Details */
        .report-content {
            margin-bottom: 20px;
        }

        .report-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .report-description {
            color: #666;
            margin-bottom: 15px;
            line-height: 1.6;
        }

        .report-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .meta-item {
            display: flex;
            flex-direction: column;
        }

        .meta-label {
            font-size: 0.8rem;
            color: #666;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .meta-value {
            color: #333;
            font-weight: 500;
        }

        /* Action Buttons */
        .report-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.9rem;
            font-weight: 500;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: #212529;
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        /* Empty State */
        .empty-data {
            text-align: center;
            padding: 60px 40px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        .empty-data i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-data h3 {
            color: #666;
            margin-bottom: 10px;
        }

        .empty-data p {
            color: #999;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .navigation-sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .main-content {
                margin-left: 0;
                padding: 20px;
            }

            .filter-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .report-header {
                flex-direction: column;
                gap: 15px;
            }

            .report-meta {
                grid-template-columns: 1fr;
            }

            .report-actions {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <!-- Logo và tên trang quản lý -->
            <div class="logo">
                <h3>
                    <a href="<%= request.getContextPath() %>/home.jsp">
                        <i class="fas fa-futbol me-2"></i>
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

    <!-- Sidebar -->
    <div class="navigation-sidebar">
        <%@ include file="FieldOwnerSB.jsp" %>
    </div>

    <!-- Main Content -->
    <main class="main-content">
        <h1 class="page-title">
            <i class="fas fa-exclamation-triangle"></i>
            Quản lý báo cáo
        </h1>

        <%-- Display status update messages --%>
        <c:if test="${not empty param.statusUpdate}">
            <div class="alert alert-${param.statusUpdate == 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                <c:if test="${param.statusUpdate == 'success'}">
                    <strong>Success!</strong> Report ID <c:out value="${param.reportID}"/> updated to <c:out value="${param.newStatus}"/> status.
                </c:if>
                <c:if test="${param.statusUpdate == 'error'}">
                    <strong>Error!</strong> Failed to update report ID <c:out value="${param.reportID}"/> status. <c:out value="${param.errorMessage}"/>
                </c:if>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <%-- Calculate counts for stat cards --%>
        <%
            List<Report> allReports = (List<Report>) request.getAttribute("reports");
            if (allReports == null) {
                allReports = new java.util.ArrayList<>();
            }
            long newReportsCount = allReports.stream().filter(r -> "Pending".equalsIgnoreCase(r.getStatus())).count();
            long inProgressReportsCount = allReports.stream().filter(r -> "InProgress".equalsIgnoreCase(r.getStatus())).count();
            long resolvedReportsCount = allReports.stream().filter(r -> "Resolved".equalsIgnoreCase(r.getStatus())).count();
            long rejectedReportsCount = allReports.stream().filter(r -> "Rejected".equalsIgnoreCase(r.getStatus()) || "Closed".equalsIgnoreCase(r.getStatus())).count();
        %>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card new-reports">
                <div class="icon"><i class="fas fa-bell"></i></div>
                <h4><%= newReportsCount %></h4>
                <p>Báo cáo mới</p>
            </div>
            <div class="stat-card in-progress">
                <div class="icon"><i class="fas fa-hourglass-half"></i></div>
                <h4><%= inProgressReportsCount %></h4>
                <p>Đang xử lý</p>
            </div>
            <div class="stat-card resolved">
                <div class="icon"><i class="fas fa-check-circle"></i></div>
                <h4><%= resolvedReportsCount %></h4>
                <p>Đã giải quyết</p>
            </div>
            <div class="stat-card rejected">
                <div class="icon"><i class="fas fa-times-circle"></i></div>
                <h4><%= rejectedReportsCount %></h4>
                <p>Đã từ chối</p>
            </div>
        </div>

        <!-- Filter Form -->
        <div class="report-form">
            <form action="${pageContext.request.contextPath}/owner/reports" method="get">
                <div class="filter-grid">
                    <input type="text" name="search" placeholder="Tìm kiếm theo người dùng hoặc tiêu đề..." value="${param.search != null ? param.search : ''}">
                    
                    <select name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Pending" ${"Pending" eq param.status ? 'selected' : ''}>Pending</option>
                        <option value="InProgress" ${"InProgress" eq param.status ? 'selected' : ''}>In Progress</option>
                        <option value="Resolved" ${"Resolved" eq param.status ? 'selected' : ''}>Resolved</option>
                        <option value="Rejected" ${"Rejected" eq param.status ? 'selected' : ''}>Rejected</option>
                        <option value="Closed" ${"Closed" eq param.status ? 'selected' : ''}>Closed</option>
                    </select>
                    
                    <select name="type">
                        <option value="">Tất cả loại</option>
                        <option value="REPORT" ${"REPORT" eq param.type ? 'selected' : ''}>Báo cáo sân</option>
                        <option value="BOOKING_ISSUE" ${"BOOKING_ISSUE" eq param.type ? 'selected' : ''}>Vấn đề đặt sân</option>
                        <option value="FOOD_ISSUE" ${"FOOD_ISSUE" eq param.type ? 'selected' : ''}>Vấn đề đồ ăn</option>
                    </select>
                    
                    <select name="priority">
                        <option value="">Tất cả độ ưu tiên</option>
                        <option value="HIGH" ${"HIGH" eq param.priority ? 'selected' : ''}>Cao</option>
                        <option value="MEDIUM" ${"MEDIUM" eq param.priority ? 'selected' : ''}>Trung bình</option>
                        <option value="LOW" ${"LOW" eq param.priority ? 'selected' : ''}>Thấp</option>
                    </select>
                    
                    <button type="submit">
                        <i class="fas fa-filter"></i> Lọc
                    </button>
                </div>
            </form>
        </div>

        <!-- Reports List -->
        <div class="reports-container">
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
                                    <span class="meta-label">Loại báo cáo</span>
                                    <span class="meta-value"><c:out value="${report.type != null ? report.type : 'N/A'}"/></span>
                                </div>
                                <div class="meta-item">
                                    <span class="meta-label">Độ ưu tiên</span>
                                    <span class="meta-value"><c:out value="${report.priority != null ? report.priority : 'N/A'}"/></span>
                                </div>
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
                                <div class="admin-response" style="background: #e8f4f8; padding: 15px; border-radius: 8px; margin-top: 15px;">
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
                            <a href="${pageContext.request.contextPath}/owner/report-details?reportID=${report.reportID}" class="btn btn-primary">
                                <i class="fas fa-info-circle"></i> Xem chi tiết
                            </a>
                            <c:if test="${'Pending' eq report.status || 'InProgress' eq report.status}">
                                <%-- Use separate forms for POST requests --%>
                                <form action="${pageContext.request.contextPath}/owner/reports" method="post" class="d-inline-block">
                                    <input type="hidden" name="reportID" value="${report.reportID}">
                                    <input type="hidden" name="status" value="InProgress">
                                    <button type="submit" class="btn btn-warning">
                                        <i class="fas fa-play-circle"></i> Đang xử lý
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/owner/reports" method="post" class="d-inline-block">
                                    <input type="hidden" name="reportID" value="${report.reportID}">
                                    <input type="hidden" name="status" value="Resolved">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-check-circle"></i> Đã giải quyết
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/owner/reports" method="post" class="d-inline-block">
                                    <input type="hidden" name="reportID" value="${report.reportID}">
                                    <input type="hidden" name="status" value="Rejected">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-times-circle"></i> Từ chối
                                    </button>
                                </form>
                            </c:if>
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
        });
    </script>
</body>
</html>
