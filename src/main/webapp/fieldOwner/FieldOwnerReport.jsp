<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/fieldOwnerReport.css">
</head>
<body>
<div class="top-header">
    <div class="container-fluid d-flex justify-content-between align-items-center"
         style="padding-left: 0; padding-right: 0; max-width: 100%;">
        <div class="logo" style="padding-left: 40px;">
            <h3>
                <a class="item" href="<%= request.getContextPath() %>/home.jsp">
                    <i class="fas fa-futbol me-2"></i>
                </a>
                Field Manager Page
            </h3>
        </div>
        <%
            Object userObj = session.getAttribute("currentUser");
            if (userObj != null) {
        %>
        <div class="user-greeting" style="margin-right: 40px;">
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
                    <strong>Thành công!</strong> Báo cáo ID <c:out value="${param.reportID}"/> đã được cập nhật thành
                    trạng thái <c:out value="${param.newStatus}"/>.
                </div>
            </c:if>
            <c:if test="${param.statusUpdate == 'error'}">
                <i class="fas fa-exclamation-circle"></i>
                <div>
                    <strong>Lỗi!</strong> Không thể cập nhật báo cáo ID <c:out value="${param.reportID}"/>. <c:out
                        value="${param.errorMessage}"/>
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
            <h4><%= newReportsCount %>
            </h4>
            <p>Báo cáo mới</p>
        </div>
        <div class="stat-card resolved fade-in animate-delay-2">
            <div class="icon"><i class="fas fa-check-circle"></i></div>
            <h4><%= resolvedReportsCount %>
            </h4>
            <p>Đã giải quyết</p>
        </div>
        <div class="stat-card total fade-in animate-delay-3">
            <div class="icon"><i class="fas fa-chart-bar"></i></div>
            <h4><%= totalReportsCount %>
            </h4>
            <p>Tổng báo cáo</p>
        </div>
    </div>

    <!-- Filter Form -->
    <div class="report-form fade-in">
        <form action="${pageContext.request.contextPath}/owner/reports" method="get">
            <div class="filter-grid">
                <input type="text" name="search" placeholder="Tìm kiếm theo người dùng hoặc tiêu đề..."
                       value="${param.search != null ? param.search : ''}">

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
                                <span class="meta-value"><fmt:formatDate value="${report.submittedAt}"
                                                                         pattern="dd/MM/yyyy HH:mm"/></span>
                            </div>
                            <div class="meta-item">
                                <span class="meta-label">Sân liên quan</span>
                                <span class="meta-value"><c:out
                                        value="${report.stadiumName != null ? report.stadiumName : 'N/A'}"/> (ID: <c:out
                                        value="${report.relatedStadiumID != null ? report.relatedStadiumID : 'N/A'}"/>)</span>
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
                                    <span class="meta-value"><fmt:formatDate value="${report.respondedAt}"
                                                                             pattern="dd/MM/yyyy HH:mm"/></span>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <div class="report-actions">
                        <c:if test="${'Pending' eq report.status}">
                            <%-- Use separate forms for POST requests --%>
                            <form action="${pageContext.request.contextPath}/owner/reports" method="post"
                                  class="d-inline-block">
                                <input type="hidden" name="reportID" value="${report.reportID}">
                                <input type="hidden" name="newStatus" value="Resolved">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-check"></i> Giải quyết
                                </button>
                            </form>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/owner/reports" method="post"
                              class="d-inline-block">
                            <input type="hidden" name="reportID" value="${report.reportID}">
                            <input type="hidden" name="action" value="delete">
                            <button type="submit" class="btn btn-danger"
                                    onclick="return confirm('Bạn có chắc chắn muốn xóa báo cáo này không? Hành động này không thể hoàn tác.')">
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