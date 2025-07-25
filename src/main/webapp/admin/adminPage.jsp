<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    model.User currentUser = (model.User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String fullName = currentUser.getFullName();


    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer onlineUsers = (Integer) request.getAttribute("onlineUsers");
    Integer pendingApprovals = (Integer) request.getAttribute("pendingApprovals");


    Double userGrowthPercent = (Double) request.getAttribute("userGrowthPercent");
    Integer onlineUserGrowth = (Integer) request.getAttribute("onlineUserGrowth");
    Integer pendingIncrease = (Integer) request.getAttribute("pendingIncrease");


    Integer yearlyUserTarget = (Integer) request.getAttribute("yearlyUserTarget");
    Double onlineActivityRate = (Double) request.getAttribute("onlineActivityRate");
    Double pendingProcessRate = (Double) request.getAttribute("pendingProcessRate");
    Double systemActivityRate = (Double) request.getAttribute("systemActivityRate");


    List<Integer> monthlyRegistrations = (List<Integer>) request.getAttribute("monthlyRegistrations");
    List<Integer> monthlyOnlineActivity = (List<Integer>) request.getAttribute("monthlyOnlineActivity");
    List<Integer> weeklyPendingData = (List<Integer>) request.getAttribute("weeklyPendingData");
    List<Integer> hourlyOnlineData = (List<Integer>) request.getAttribute("hourlyOnlineData");


    if (totalUsers == null) totalUsers = 0;
    if (onlineUsers == null) onlineUsers = 0;
    if (pendingApprovals == null) pendingApprovals = 0;
    if (userGrowthPercent == null) userGrowthPercent = 0.0;
    if (onlineUserGrowth == null) onlineUserGrowth = 0;
    if (pendingIncrease == null) pendingIncrease = 0;
    if (yearlyUserTarget == null) yearlyUserTarget = 1500;
    if (onlineActivityRate == null) onlineActivityRate = 80.0;
    if (pendingProcessRate == null) pendingProcessRate = 0.0;
    if (systemActivityRate == null) systemActivityRate = 0.0;


    double userProgress = yearlyUserTarget > 0 ? (totalUsers * 100.0 / yearlyUserTarget) : 0;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Quản Trị</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminPage.css">
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="main-content">
    <div class="header fade-in">
        <div>
            <h2><i class="fas fa-chart-line"></i> Thống Kê Tổng Quan</h2>
            <div class="greeting">
                <i class="fas fa-hand-wave" style="color: #f59e0b;"></i>
                Xin chào, <strong><%= fullName %>
            </strong>!
            </div>
        </div>
    </div>

    <div class="stats-grid">

        <div class="stat-card primary fade-in animate-delay-1">
            <div class="stat-header">
                <div class="stat-info">
                    <h3><%= String.format("%,d", totalUsers) %>
                    </h3>
                    <p>Tổng Người Dùng</p>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
            </div>
            <div class="stat-trend">
                    <span class="trend-indicator <%= userGrowthPercent >= 0 ? "trend-up" : "trend-down" %>">
                        <i class="fas fa-arrow-<%= userGrowthPercent >= 0 ? "up" : "down" %>"></i>
                        <%= userGrowthPercent >= 0 ? "+" : "" %><%= String.format("%.1f", userGrowthPercent) %>%
                    </span>
                <span style="color: #64748b; font-size: 12px;">so với tháng trước</span>
            </div>
            <div class="mini-chart">
                <%
                    if (monthlyRegistrations != null && !monthlyRegistrations.isEmpty()) {
                        for (int i = 0; i < Math.min(9, monthlyRegistrations.size()); i++) {
                            int height = Math.min(90, Math.max(20, monthlyRegistrations.get(i) * 5));
                %>
                <div class="chart-bar" style="height: <%= height %>%;"></div>
                <%
                    }
                } else {
                    int[] defaultHeights = {60, 45, 70, 55, 80, 65, 90, 75, 85};
                    for (int height : defaultHeights) {
                %>
                <div class="chart-bar" style="height: <%= height %>%;"></div>
                <%
                        }
                    }
                %>
            </div>
            <div class="progress-container">
                <div class="progress-bar" style="width: <%= Math.min(100, userProgress) %>%;"></div>
            </div>
            <div class="progress-label">
                <span>Mục tiêu năm (<%= String.format("%,d", yearlyUserTarget) %>)</span>
                <span><%= String.format("%.0f", userProgress) %>%</span>
            </div>
        </div>

        <div class="stat-card info fade-in animate-delay-2">
            <div class="stat-header">
                <div class="stat-info">
                    <h3><%= onlineUsers %>
                    </h3>
                    <p>Người Dùng Online</p>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-wifi"></i>
                </div>
            </div>
            <div class="stat-trend">
                    <span class="trend-indicator trend-live">
                        <i class="fas fa-circle" style="color: #10b981; animation: pulse 2s infinite;"></i>
                        Live
                    </span>
                <span style="color: #64748b; font-size: 12px;">đang hoạt động</span>
            </div>
            <div class="mini-chart">
                <%
                    if (hourlyOnlineData != null && !hourlyOnlineData.isEmpty()) {
                        for (int i = 0; i < Math.min(9, hourlyOnlineData.size()); i++) {
                            int height = Math.min(90, Math.max(20, hourlyOnlineData.get(i) * 8));
                %>
                <div class="chart-bar" style="height: <%= height %>%;"></div>
                <%
                    }
                } else {
                    int baseHeight = Math.max(20, onlineUsers * 8);
                    int[] variations = {-10, 5, -5, 15, 0, 10, -5, 20, 5};
                    for (int variation : variations) {
                        int height = Math.min(90, Math.max(20, baseHeight + variation));
                %>
                <div class="chart-bar" style="height: <%= height %>%;"></div>
                <%
                        }
                    }
                %>
            </div>
            <div class="progress-container">
                <div class="progress-bar" style="width: <%= onlineActivityRate %>%;"></div>
            </div>
            <div class="progress-label">
                <span>Mức độ hoạt động</span>
                <span><%= String.format("%.0f", onlineActivityRate) %>%</span>
            </div>
        </div>


        <div class="stat-card warning fade-in animate-delay-3">
            <div class="stat-header">
                <div class="stat-info">
                    <h3><%= pendingApprovals %>
                    </h3>
                    <p>Đơn Chờ Duyệt</p>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
            </div>
            <div class="stat-trend">
                    <span class="trend-indicator <%= pendingIncrease >= 0 ? "trend-up" : "trend-down" %>">
                        <i class="fas fa-arrow-<%= pendingIncrease >= 0 ? "up" : "down" %>"></i>
                        <%= pendingIncrease >= 0 ? "+" : "" %><%= pendingIncrease %>
                    </span>
                <span style="color: #64748b; font-size: 12px;">so với hôm qua</span>
            </div>
            <div class="mini-chart">
                <%
                    if (weeklyPendingData != null && !weeklyPendingData.isEmpty()) {
                        for (int i = 0; i < Math.min(9, weeklyPendingData.size()); i++) {
                            int height = Math.min(90, Math.max(20, weeklyPendingData.get(i) * 10));
                %>
                <div class="chart-bar" style="height: <%= height %>%;"></div>
                <%
                    }
                } else {

                    int[] defaultHeights = {30, 25, 40, 35, 50, 45, 60, 70, Math.max(20, pendingApprovals * 3)};
                    for (int height : defaultHeights) {
                %>
                <div class="chart-bar" style="height: <%= Math.min(90, height) %>%;"></div>
                <%
                        }
                    }
                %>
            </div>
            <div class="progress-container">
                <div class="progress-bar" style="width: <%= pendingProcessRate %>%;"></div>
            </div>
            <div class="progress-label">
                <span>Tiến độ xử lý</span>
                <span><%= String.format("%.0f", pendingProcessRate) %>%</span>
            </div>
        </div>
    </div>

    <div class="card fade-in animate-delay-4">
        <div class="card-header">
            <h5><i class="fas fa-user-plus"></i> Tài Khoản Đăng Ký Gần Đây</h5>
            <a href="${pageContext.request.contextPath}/admin/user-list" class="btn btn-outline">
                <i class="fas fa-users-cog"></i> Quản Lý Người Dùng
            </a>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Họ Tên</th>
                        <th>Email</th>
                        <th>Vai Trò</th>
                        <th>Ngày Đăng Ký</th>
                        <th>Trạng Thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty recentUsers}">
                            <c:forEach var="user" items="${recentUsers}">
                                <tr>
                                    <td>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty user.avatarUrl}">

                                                        <img src="${user.avatarUrl}" alt="Avatar"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:if test="${not empty user.fullName}">${fn:substring(user.fullName, 0, 1)}</c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <strong>${user.fullName}</strong>
                                        </div>
                                    </td>
                                    <td style="color: #64748b;">${user.email}</td>
                                    <td>
                                        <c:forEach var="role" items="${user.roles}">
                                                    <span class="badge
                                                          ${fn:toLowerCase(role.roleName) eq 'admin' ? 'badge-admin' : ''}
                                                          ${fn:toLowerCase(role.roleName) eq 'owner' ? 'badge-owner' : ''}
                                                          ${fn:toLowerCase(role.roleName) eq 'user' ? 'badge-user' : ''}">
                                                            ${role.roleName}
                                                    </span>
                                        </c:forEach>
                                    </td>
                                    <td style="color: #64748b;">
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                    </td>
                                    <td>
                                        <div class="status-indicator">
                                            <div class="status-dot ${user.active ? 'status-active' : 'status-inactive'}"></div>
                                                ${user.active ? 'Hoạt động' : 'Đã khóa'}
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" style="text-align: center; color: #64748b; padding: 40px;">
                                    <i class="fas fa-users"
                                       style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
                                    <div>Không có tài khoản nào được đăng ký gần đây.</div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<script>
    document.addEventListener('DOMContentLoaded', function () {

        setTimeout(() => {
            const chartBars = document.querySelectorAll('.chart-bar');
            chartBars.forEach((bar, index) => {
                bar.style.animationDelay = `${index * 0.1}s`;
                bar.style.animation = 'slideUp 0.8s ease-out forwards';
            });
        }, 500);


        setTimeout(() => {
            const progressBars = document.querySelectorAll('.progress-bar');
            progressBars.forEach(bar => {
                const width = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.width = width;
                }, 100);
            });
        }, 800);


        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(btn => {
            btn.addEventListener('click', function (e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                ripple.style.cssText = `
                        position: absolute;
                        width: ${size}px;
                        height: ${size}px;
                        background: rgba(255,255,255,0.6);
                        border-radius: 50%;
                        left: ${e.clientX - rect.left - size/2}px;
                        top: ${e.clientY - rect.top - size/2}px;
                        transform: scale(0);
                        animation: ripple 0.6s ease-out;
                        pointer-events: none;
                        z-index: 1;
                    `;
                this.style.position = 'relative';
                this.appendChild(ripple);
                setTimeout(() => ripple.remove(), 600);
            });
        });


        const style = document.createElement('style');
        style.textContent = `
                @keyframes slideUp {
                    from {
                        height: 8px;
                        opacity: 0;
                    }
                    to {
                        opacity: 1;
                    }
                }

                @keyframes ripple {
                    to {
                        transform: scale(2);
                        opacity: 0;
                    }
                }

                .chart-bar {
                    opacity: 0;
                }
            `;
        document.head.appendChild(style);


        setInterval(() => {

            console.log('Auto-refresh online users - implement AJAX call here');
        }, 30000);


        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    });
</script>
</body>
</html>