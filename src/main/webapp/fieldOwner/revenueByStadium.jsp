<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.RevenueReport" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo doanh thu: ${stadiumName}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/revenueReport.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<!-- Top Header -->
<div class="top-header">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="logo">
            <h3>
                <a href="<%= request.getContextPath() %>/home.jsp">
                    <i class="fas fa-futbol me-2"></i>
                    Field Manager Page
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
    <div class="card">
        <div class="card-header">
            <h5>Báo cáo doanh thu: ${stadiumName}</h5>
        </div>
        <div class="card-body">

            <!-- Nút Quay lại -->
            <div class="mb-3">
                <a href="javascript:history.back()" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>

            <!-- Dropdown chọn kỳ -->
            <div class="mb-4">
                <label for="periodSelect">Chọn kỳ:</label>
                <select id="periodSelect" class="form-select w-auto">
                    <option value="day" ${selectedPeriod == 'day' ? 'selected' : ''}>Theo ngày (tháng này)</option>
                    <option value="month" ${selectedPeriod == 'month' ? 'selected' : ''}>Theo tháng (năm nay)</option>
                    <option value="year" ${selectedPeriod == 'year' ? 'selected' : ''}>Theo năm (5 năm gần nhất)</option>
                </select>
            </div>

            <!-- Biểu đồ -->
            <div class="card mb-4">
                <div class="card-body">
                    <canvas id="revenueChart" height="80"></canvas>
                </div>
            </div>

            <!-- Thông báo nếu không có dữ liệu -->
            <c:if test="${empty reports}">
                <div class="alert alert-info text-center">
                    <i class="fas fa-file-alt fa-3x mb-3"></i>
                    <p>Không có dữ liệu để hiển thị.</p>
                </div>
            </c:if>

        </div>
    </div>
</div>

<!-- Helper: Chuyển List<RevenueReport> thành JSON string -->
<%!
    public String revenueReportsToJson(List<RevenueReport> reports) {
        if (reports == null || reports.isEmpty()) {
            return "[]";
        }
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < reports.size(); i++) {
            RevenueReport r = reports.get(i);
            sb.append(String.format("{period:'%s',totalRevenue:%.2f}", r.getPeriod(), r.getTotalRevenue()));
            if (i < reports.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }
%>

<script>
    // Dữ liệu từ server
    const reports = <%= revenueReportsToJson((List<RevenueReport>) request.getAttribute("reports")) %>;
    const selectedPeriod = '${selectedPeriod}';
    const stadiumId = ${stadiumId};

    let chartInstance = null;

    function renderChart() {
        let labels = [];
        let data = [];

        if (selectedPeriod === 'day') {
            const today = new Date();
            const currentMonth = today.getMonth();
            const currentYear = today.getFullYear();
            const daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();
            labels = Array.from({ length: daysInMonth }, (_, i) => i + 1);

            const map = {};
            reports.forEach(r => {
                const day = parseInt(r.period.split('-')[2]);
                map[day] = (map[day] || 0) + r.totalRevenue;
            });
            data = labels.map(d => map[d] || 0);

        } else if (selectedPeriod === 'month') {
            labels = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                      'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];

            const map = {};
            reports.forEach(r => {
                const month = parseInt(r.period);
                map[month] = (map[month] || 0) + r.totalRevenue;
            });
            data = labels.map((_, i) => map[i + 1] || 0);

        } else if (selectedPeriod === 'year') {
            const currentYear = new Date().getFullYear();
            labels = Array.from({ length: 5 }, (_, i) => currentYear - 4 + i);

            const map = {};
            reports.forEach(r => {
                const year = parseInt(r.period);
                map[year] = (map[year] || 0) + r.totalRevenue;
            });
            data = labels.map(y => map[y] || 0);
        }

        if (chartInstance) chartInstance.destroy();
        const ctx = document.getElementById('revenueChart').getContext('2d');
        chartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: data,
                    backgroundColor: 'rgba(79, 172, 254, 0.6)',
                    borderColor: '#4facfe',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const value = context.parsed.y;
                                return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                if (value >= 1e6) return (value / 1e6).toFixed(1) + 'M';
                                if (value >= 1e3) return (value / 1e3).toFixed(0) + 'K';
                                return value;
                            }
                        }
                    }
                }
            }
        });
    }

    // Xử lý thay đổi Period
    document.getElementById('periodSelect').addEventListener('change', function () {
        const newPeriod = this.value;
        const url = `${pageContext.request.contextPath}/revenue-stadium?stadiumId=${stadiumId}&period=${newPeriod}`;
        window.location.href = url;
    });

    // Khởi tạo biểu đồ
    document.addEventListener("DOMContentLoaded", renderChart);
</script>

</body>
</html>