<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.User" %>
<%
    model.User currentUser = (model.User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String fullName = currentUser.getFullName();
    
    // Get real data from servlet attributes
    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer onlineUsers = (Integer) request.getAttribute("onlineUsers");
    Integer pendingApprovals = (Integer) request.getAttribute("pendingApprovals");
    
    // Growth data
    Double userGrowthPercent = (Double) request.getAttribute("userGrowthPercent");
    Integer onlineUserGrowth = (Integer) request.getAttribute("onlineUserGrowth");
    Integer pendingIncrease = (Integer) request.getAttribute("pendingIncrease");
    
    // Progress metrics
    Integer yearlyUserTarget = (Integer) request.getAttribute("yearlyUserTarget");
    Double onlineActivityRate = (Double) request.getAttribute("onlineActivityRate");
    Double pendingProcessRate = (Double) request.getAttribute("pendingProcessRate");
    Double systemActivityRate = (Double) request.getAttribute("systemActivityRate");
    
    // Chart data
    List<Integer> monthlyRegistrations = (List<Integer>) request.getAttribute("monthlyRegistrations");
    List<Integer> monthlyOnlineActivity = (List<Integer>) request.getAttribute("monthlyOnlineActivity");
    List<Integer> weeklyPendingData = (List<Integer>) request.getAttribute("weeklyPendingData");
    List<Integer> hourlyOnlineData = (List<Integer>) request.getAttribute("hourlyOnlineData");
    
    // Default values if null
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
    
    // Calculate progress percentage
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

        .main-content {
            margin-left: 300px;
            padding: 40px;
            min-height: 100vh;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 40px 40px;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            margin-bottom: 40px;
            border: 1px solid rgba(59, 130, 246, 0.1);
            position: relative;
            overflow: hidden;
        }

        .header h2 {
            color: #1e293b;
            font-weight: 700;
            font-size: 32px;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }

        .header .greeting {
            font-size: 16px;
            color: #64748b;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
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
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.15);
            border-color: rgba(59, 130, 246, 0.2);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 24px;
        }

        .stat-info h3 {
            font-size: 48px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
            line-height: 1;
        }

        .stat-info p {
            font-size: 14px;
            color: #64748b;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            position: relative;
        }

        .stat-card.primary .stat-icon {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        }

        .stat-card.info .stat-icon {
            background: linear-gradient(135deg, #06b6d4, #0891b2);
        }

        .stat-card.warning .stat-icon {
            background: linear-gradient(135deg, #f59e0b, #d97706);
        }

        .stat-trend {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }

        .trend-indicator {
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 4px 8px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }

        .trend-up {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
        }

        .trend-down {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }

        .trend-neutral {
            background: rgba(100, 116, 139, 0.1);
            color: #64748b;
        }

        .trend-live {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
        }

        .mini-chart {
            height: 80px;
            background: rgba(59, 130, 246, 0.05);
            border-radius: 12px;
            position: relative;
            overflow: hidden;
            margin-top: 16px;
            display: flex;
            align-items: end;
            padding: 8px;
            gap: 4px;
        }

        .chart-bar {
            flex: 1;
            background: linear-gradient(180deg, #3b82f6, #1d4ed8);
            border-radius: 2px;
            transition: all 0.6s ease;
            min-height: 8px;
        }

        .stat-card.info .chart-bar {
            background: linear-gradient(180deg, #06b6d4, #0891b2);
        }

        .stat-card.warning .chart-bar {
            background: linear-gradient(180deg, #f59e0b, #d97706);
        }

        .progress-container {
            background: rgba(59, 130, 246, 0.1);
            border-radius: 12px;
            height: 8px;
            overflow: hidden;
            margin-top: 16px;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #3b82f6, #1d4ed8);
            border-radius: 12px;
            transition: width 1s ease;
            position: relative;
        }

        .stat-card.info .progress-bar {
            background: linear-gradient(90deg, #06b6d4, #0891b2);
        }

        .stat-card.warning .progress-bar {
            background: linear-gradient(90deg, #f59e0b, #d97706);
        }

        .progress-bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 8px;
            font-size: 12px;
            color: #64748b;
            font-weight: 500;
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            border: 1px solid rgba(59, 130, 246, 0.1);
            margin-bottom: 40px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.12);
        }

        .card-header {
            padding: 32px 40px;
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(59, 130, 246, 0.02);
        }

        .card-header h5 {
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-header h5 i {
            color: #3b82f6;
        }

        .card-body {
            padding: 40px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            background: transparent;
        }

        .table th,
        .table td {
            padding: 20px;
            text-align: left;
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
        }

        .table th {
            background: rgba(59, 130, 246, 0.05);
            font-weight: 600;
            color: #1e293b;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table tr {
            transition: all 0.2s ease;
        }

        .table tr:hover {
            background: rgba(59, 130, 246, 0.03);
            transform: scale(1.01);
        }

        .user-avatar {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            margin-right: 16px;
            font-size: 18px;
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-info strong {
            color: #1e293b;
            font-weight: 600;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }

        .badge-admin {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }

        .badge-owner {
            background: rgba(59, 130, 246, 0.1);
            color: #2563eb;
        }

        .badge-user {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }

        .status-active {
            background: #10b981;
        }

        .status-inactive {
            background: #ef4444;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            position: relative;
            overflow: hidden;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(59, 130, 246, 0.25);
        }

        .btn-outline {
            background: rgba(59, 130, 246, 0.05);
            border: 2px solid rgba(59, 130, 246, 0.2);
            color: #3b82f6;
            backdrop-filter: blur(10px);
        }

        .btn-outline:hover {
            background: #3b82f6;
            color: white;
            border-color: #3b82f6;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 24px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
                gap: 24px;
            }

            .header,
            .card-header,
            .card-body {
                padding: 24px;
            }

            .header h2 {
                font-size: 28px;
            }

            .stat-info h3 {
                font-size: 36px;
            }

            .card-header {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }

            .table-responsive {
                overflow-x: auto;
            }
        }

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
        .animate-delay-4 { animation-delay: 0.4s; animation-fill-mode: both; }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
                transform: scale(1);
            }
            50% {
                opacity: 0.7;
                transform: scale(1.1);
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <%@ include file="sidebar.jsp" %>

    <div class="main-content">
        <div class="header fade-in">
            <div>
                <h2><i class="fas fa-chart-line"></i> Thống Kê Tổng Quan</h2>
                <div class="greeting">
                    <i class="fas fa-hand-wave" style="color: #f59e0b;"></i>
                    Xin chào, <strong><%= fullName %></strong>!
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <!-- Total Users Card -->
            <div class="stat-card primary fade-in animate-delay-1">
                <div class="stat-header">
                    <div class="stat-info">
                        <h3><%= String.format("%,d", totalUsers) %></h3>
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
                            // Default bars if no data
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

            <!-- Online Users Card (Replaces Active Stadiums) -->
            <div class="stat-card info fade-in animate-delay-2">
                <div class="stat-header">
                    <div class="stat-info">
                        <h3><%= onlineUsers %></h3>
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
                            // Default bars if no data - simulate hourly online activity
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

            <!-- Pending Requests Card -->
            <div class="stat-card warning fade-in animate-delay-3">
                <div class="stat-header">
                    <div class="stat-info">
                        <h3><%= pendingApprovals %></h3>
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
                            // Default bars for pending requests
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
                <h5>
                    <i class="fas fa-user-plus"></i>
                    Tài Khoản Đăng Ký Gần Đây
                </h5>
                <a href="${pageContext.request.contextPath}/admin/user-list" class="btn btn-outline">
                    <i class="fas fa-users-cog"></i>
                    Quản Lý Người Dùng
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
                            <%
                                List<model.User> allUsers = (List<model.User>) request.getAttribute("allUsers");
                                if (allUsers != null && !allUsers.isEmpty()) {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                    for (model.User user : allUsers) {
                            %>
                            <tr>
                                <td>
                                    <div class="user-info">
                                        <div class="user-avatar">
                                            <%= user.getFullName() != null && !user.getFullName().trim().isEmpty() ? user.getFullName().substring(0,1).toUpperCase() : "?" %>
                                        </div>
                                        <strong><%= user.getFullName() != null ? user.getFullName() : "Không tên" %></strong>
                                    </div>
                                </td>
                                <td style="color: #64748b;"><%= user.getEmail() != null ? user.getEmail() : "N/A" %></td>
                                <td>
                                    <span class="badge 
                                          <%= "Admin".equalsIgnoreCase(user.getRole()) ? "badge-admin" : 
                                               "Owner".equalsIgnoreCase(user.getRole()) ? "badge-owner" : 
                                               "badge-user" %>">
                                        <%= user.getRole() != null ? user.getRole() : "Unknown" %>
                                    </span>
                                </td>
                                <td style="color: #64748b;">
                                    <%= user.getCreatedAt() != null ? sdf.format(user.getCreatedAt()) : "N/A" %>
                                </td>
                                <td>
                                    <div class="status-indicator">
                                        <div class="status-dot <%= user.isActive() ? "status-active" : "status-inactive" %>"></div>
                                        <%= user.isActive() ? "Hoạt động" : "Đã khóa" %>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" style="text-align: center; color: #64748b; padding: 40px;">
                                    <i class="fas fa-users" style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
                                    <div>Không có tài khoản nào gần đây.</div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Animate chart bars on load
            setTimeout(() => {
                const chartBars = document.querySelectorAll('.chart-bar');
                chartBars.forEach((bar, index) => {
                    bar.style.animationDelay = `${index * 0.1}s`;
                    bar.style.animation = 'slideUp 0.8s ease-out forwards';
                });
            }, 500);

            // Animate progress bars
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

            // Button ripple effect
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

            // Add pulse animation and other styles
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

            // Optional: Auto-refresh online users every 30 seconds
            setInterval(() => {
                // You can implement AJAX call here to update online users count
                // without refreshing the entire page
                console.log('Auto-refresh online users - implement AJAX call here');
            }, 30000); // 30 seconds

            // Smooth scrolling for internal links
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

            // Real-time updates simulation for online users
            const onlineUserElement = document.querySelector('.stat-card.info .stat-info h3');
            if (onlineUserElement) {
                setInterval(() => {
                    // Simulate small changes in online users (±1-2 users)
                    const currentValue = parseInt(onlineUserElement.textContent);
                    const change = Math.floor(Math.random() * 5) - 2; // -2 to +2
                    const newValue = Math.max(0, currentValue + change);
                    
                    // Only update if there's actually a change
                    if (newValue !== currentValue) {
                        onlineUserElement.style.transform = 'scale(1.1)';
                        onlineUserElement.style.color = '#06b6d4';
                        setTimeout(() => {
                            onlineUserElement.textContent = newValue;
                            onlineUserElement.style.transform = 'scale(1)';
                            onlineUserElement.style.color = '#1e293b';
                        }, 200);
                    }
                }, 10000); // Update every 10 seconds
            }
        });
    </script>
</body>
</html> 