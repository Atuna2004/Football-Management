<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="model.DashboardStats" %>
<%@ page import="model.RecentBooking" %>
<%@ page import="dao.DashboardDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Quản lý sân bóng</title>
    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href=" https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css " rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/FieldOwnerDB.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js "></script>
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <div class="logo">
                <h3>
                    <a class="item" href="<%= request.getContextPath() %>/home.jsp">
                        <i class="fas fa-futbol me-2"></i>
                    </a>
                    Field Manager Page
                </h3>
            </div>
            <%
                User currentUser = (User) session.getAttribute("currentUser");
                if (currentUser != null) {
            %>
                <div class="user-greeting">
                    <i class="fas fa-user-circle"></i>
                    Xin chào, <%= currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getEmail() %>
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

    <div class="dashboard-container">
        <!-- Sidebar -->
        <%@ include file="FieldOwnerSB.jsp" %>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Stats Overview -->
            <section class="stats-overview">
                <h4 class="mb-4">Thống kê tổng quan</h4>
                <%
                    int todayBookings = 0;
                    double monthlyRevenue = 0.0;
                    int totalFields = 0;
                    int totalCustomers = 0;
                    String monthlyRevenueFormatted = "0";
                    List<RecentBooking> recentBookings = null;
                    Map<Integer, Double> monthlyRevenueMap = null;
                    boolean hasError = false;
                    String errorMessage = "";
                    DashboardDAO dashboardDAO = null;
                    Map<Integer, Integer> monthlyBookingMap = null;
                    Map<Integer, Integer> dailyBookingMap = null;
                    if (currentUser != null) {
                        try {
                            dashboardDAO = new DashboardDAO();
                            DashboardStats stats = dashboardDAO.getDashboardStats(currentUser.getUserID());
                            if (stats != null) {
                                todayBookings = stats.getTodayBookings();
                                totalFields = stats.getTotalFields();
                                totalCustomers = stats.getTotalCustomers();
                            }

                            monthlyRevenueMap = dashboardDAO.getMonthlyRevenueByOwner(currentUser.getUserID());
                            int currentMonth = Calendar.getInstance().get(Calendar.MONTH) + 1;
                            if (monthlyRevenueMap != null && monthlyRevenueMap.containsKey(currentMonth)) {
                                monthlyRevenue = monthlyRevenueMap.get(currentMonth);
                            }

                            recentBookings = dashboardDAO.getRecentBookings(currentUser.getUserID(), 10);

                            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                            if (monthlyRevenue >= 1000000) {
                                monthlyRevenueFormatted = String.format("%.1fM", monthlyRevenue / 1000000);
                            } else if (monthlyRevenue >= 1000) {
                                monthlyRevenueFormatted = String.format("%.0fK", monthlyRevenue / 1000);
                            } else {
                                monthlyRevenueFormatted = currencyFormat.format(monthlyRevenue);
                            }

                            if (dashboardDAO != null) {
                                monthlyBookingMap = dashboardDAO.getMonthlyBookingsByOwner(currentUser.getUserID());
                                dailyBookingMap = dashboardDAO.getDailyBookingsByOwner(currentUser.getUserID());
                            }
                        } catch (Exception e) {
                            hasError = true;
                            errorMessage = "Lỗi khi tải dữ liệu: " + e.getMessage();
                            e.printStackTrace();
                        }
                    }
                %>

                <div class="stats-grid">
                    <div class="stat-card bookings">
                        <div class="icon"><i class="fas fa-calendar-check"></i></div>
                        <div class="stat-content">
                            <h4><%= todayBookings %></h4>
                            <p>Lượt đặt hôm nay</p>
                        </div>
                    </div>
                    <div class="stat-card revenue">
                        <div class="icon"><i class="fas fa-dollar-sign"></i></div>
                        <div class="stat-content">
                            <h4><%= monthlyRevenueFormatted %></h4>
                            <p>Doanh thu tháng này</p>
                        </div>
                    </div>
                    <div class="stat-card fields">
                        <div class="icon"><i class="fas fa-map-marker-alt"></i></div>
                        <div class="stat-content">
                            <h4><%= totalFields %></h4>
                            <p>Tổng số sân</p>
                        </div>
                    </div>
                    <div class="stat-card customers">
                        <div class="icon"><i class="fas fa-users"></i></div>
                        <div class="stat-content">
                            <h4><%= totalCustomers %></h4>
                            <p>Khách hàng</p>
                        </div>
                    </div>
                </div>

                <% if (hasError) { %>
                    <div class="alert alert-warning mt-3">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Cảnh báo:</strong> <%= errorMessage %>
                    </div>
                <% } %>
                <% if (!hasError && todayBookings == 0 && monthlyRevenue == 0 && totalFields == 0 && totalCustomers == 0) { %>
                    <div class="alert alert-info mt-3">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Thông báo:</strong> Chưa có dữ liệu thống kê. Hãy bắt đầu bằng cách thêm sân!
                    </div>
                <% } %>
            </section>

            <!-- Chart Section -->
            <div class="card">
                <div class="card-header">
                    <h5>Biểu đồ thống kê</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex mb-3 flex-wrap gap-2">
                        <select id="chartType" class="form-select w-auto">
                            <option value="revenue">Doanh thu</option>
                            <option value="bookings" selected>Lượt đặt sân</option>
                        </select>
                        <select id="timeRange" class="form-select w-auto">
                            <option value="daily">Theo ngày (tháng này)</option>
                            <option value="monthly">Theo tháng (năm nay)</option>
                        </select>
                    </div>
                    <canvas id="dashboardChart" height="80"></canvas>
                </div>
            </div>

            <!-- Recent Bookings -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5>Đặt sân gần đây</h5>
                    <small class="text-muted">
                        <% if (recentBookings != null && !recentBookings.isEmpty()) { %>
                            5 booking gần nhất
                        <% } else { %>
                            Chưa có dữ liệu
                        <% } %>
                    </small>
                </div>
                <div class="card-body">
                    <% if (recentBookings != null && !recentBookings.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Khách hàng</th>
                                        <th>Sân</th>
                                        <th>Ngày đặt</th>
                                        <th>Thời gian</th>
                                        <th>Số tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Đặt lúc</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int count = 0;
                                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                                        SimpleDateFormat datetimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                        for (RecentBooking booking : recentBookings) {
                                            if (count >= 5) break;
                                    %>
                                        <tr>
                                            <td><strong>#<%= booking.getBookingID() %></strong></td>
                                            <td>
                                                <div>
                                                    <strong><%= booking.getCustomerName() != null ? booking.getCustomerName() : "N/A" %></strong><br>
                                                    <small class="text-muted"><%= booking.getCustomerEmail() %></small>
                                                    <% if (booking.getCustomerPhone() != null) { %>
                                                        <br><small class="text-muted"><i class="fas fa-phone"></i> <%= booking.getCustomerPhone() %></small>
                                                    <% } %>
                                                </div>
                                            </td>
                                            <td>
                                                <div>
                                                    <strong><%= booking.getStadiumName() %></strong><br>
                                                    <small class="text-muted"><%= booking.getFieldName() %> (<%= booking.getFieldType() %>)</small>
                                                </div>
                                            </td>
                                            <td><%= dateFormat.format(booking.getBookingDate()) %></td>
                                            <td><%= timeFormat.format(booking.getStartTime()) %> - <%= timeFormat.format(booking.getEndTime()) %></td>
                                            <td><strong class="text-success"><%= currencyFormat.format(booking.getTotalAmount()) %></strong></td>
                                            <td>
                                                <%
                                                    String statusClass = "badge bg-secondary";
                                                    String statusText = booking.getStatus();
                                                    switch (booking.getStatus().toLowerCase()) {
                                                        case "completed": statusClass = "badge bg-success"; statusText = "Hoàn thành"; break;
                                                        case "pending": statusClass = "badge bg-warning"; statusText = "Chờ xử lý"; break;
                                                        case "cancelled": statusClass = "badge bg-danger"; statusText = "Đã hủy"; break;
                                                        case "confirmed": statusClass = "badge bg-primary"; statusText = "Đã xác nhận"; break;
                                                    }
                                                %>
                                                <span class="<%= statusClass %>"><%= statusText %></span>
                                            </td>
                                            <td><small class="text-muted"><%= datetimeFormat.format(booking.getCreatedAt()) %></small></td>
                                        </tr>
                                    <% 
                                        count++;
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    <% } else if (hasError) { %>
                        <div class="text-center py-4 text-warning">
                            <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                            <p>Không thể tải danh sách đặt sân</p>
                            <small>Vui lòng kiểm tra kết nối cơ sở dữ liệu</small>
                        </div>
                    <% } else { %>
                        <div class="text-center py-4 text-muted">
                            <i class="fas fa-calendar-times fa-3x mb-3"></i>
                            <p>Chưa có lượt đặt sân nào</p>
                            <small>Các booking mới sẽ hiển thị tại đây</small>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>

    <!-- Helper: Convert Java Map to JSON -->
    <%!
        public String mapToJson(Map<Integer, Double> map) {
            StringBuilder sb = new StringBuilder("{");
            if (map != null) {
                boolean first = true;
                for (Map.Entry<Integer, Double> entry : map.entrySet()) {
                    if (!first) sb.append(",");
                    sb.append(entry.getKey()).append(":").append(entry.getValue());
                    first = false;
                }
            }
            sb.append("}");
            return sb.toString();
        }
        public String intMapToJson(Map<Integer, Integer> map) {
            StringBuilder sb = new StringBuilder("{");
            if (map != null) {
                boolean first = true;
                for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
                    if (!first) sb.append(",");
                    sb.append(entry.getKey()).append(":").append(entry.getValue());
                    first = false;
                }
            }
            sb.append("}");
            return sb.toString();
        }
    %>

    <!-- Chart Script -->
    <script>
        const monthlyRevenueData = <%= monthlyRevenueMap != null ? mapToJson(monthlyRevenueMap) : "{}" %>;
        const monthlyBookingData = <%= monthlyBookingMap != null ? intMapToJson(monthlyBookingMap) : "{}" %>;
        const dailyBookingData = <%= dailyBookingMap != null ? intMapToJson(dailyBookingMap) : "{}" %>;

        console.log("Dữ liệu biểu đồ:", { dailyBookingData, monthlyBookingData});

        let chartInstance = null;

        function renderChart(type, range) {
            let labels = [];
            let data = [];
            let label = '';
            let borderColor = '#667eea';
            let backgroundColor = 'rgba(102, 126, 234, 0.2)';

            if (range === 'daily') {
                const today = new Date();
                const currentMonth = today.getMonth(); // 0-11
                const currentYear = today.getFullYear();
                const daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate(); // 28, 29, 30, 31

                const allDays = Array.from({ length: daysInMonth }, (_, i) => i + 1);

                const daysWithData = Object.keys(dailyBookingData)
                    .map(Number)
                    .filter(day => day >= 1 && day <= daysInMonth)
                    .sort((a, b) => a - b);

                if (daysWithData.length === 0) {
                    // Nếu không có dữ liệu, hiển thị tất cả ngày trong tháng (chỉ số)
                    labels = allDays.map(day => day);
                    data = allDays.map(day => dailyBookingData[day] || 0);
                } else {
                    // Chỉ hiển thị các ngày có booking (chỉ số)
                    labels = daysWithData.map(day => day);
                    data = daysWithData.map(day => dailyBookingData[day] || 0);
                }
                label = 'Lượt đặt sân';
                borderColor = '#4facfe';
                backgroundColor = 'rgba(79, 172, 254, 0.2)';
            }else if (range === 'monthly') {
                labels = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                          'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
                data = labels.map((_, i) => type === 'revenue' 
                    ? parseFloat(monthlyRevenueData[i + 1] || 0)
                    : parseInt(monthlyBookingData[i + 1] || 0));
                label = type === 'revenue' ? 'Doanh thu (đ)' : 'Lượt đặt sân';
            }

            if (chartInstance) chartInstance.destroy();

            const ctx = document.getElementById('dashboardChart').getContext('2d');
            chartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: label,
                        data: data,
                        borderColor: borderColor,
                        backgroundColor: backgroundColor,
                        borderWidth: 2,
                        tension: 0.3,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const value = context.parsed.y;
                                    return type === 'revenue'
                                        ? new Intl.NumberFormat('vi-VN').format(value) + ' đ'
                                        : value + ' lượt';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                source: 'data',
                                autoSkip: false,
                                maxRotation: 0
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    if (type === 'revenue') {
                                        if (value >= 1e6) return (value / 1e6).toFixed(1) + 'M';
                                        if (value >= 1e3) return (value / 1e3).toFixed(0) + 'K';
                                        return value;
                                    }
                                    return value;
                                }
                            }
                        }
                    }
                }
            });
        }

        // Khởi tạo khi tải trang
        document.addEventListener("DOMContentLoaded", function () {
            renderChart('bookings', 'daily'); // Mặc định: Lượt đặt sân theo ngày
        });

        // Sự kiện thay đổi
        document.getElementById('chartType').addEventListener('change', function () {
            renderChart(this.value, document.getElementById('timeRange').value);
        });
        document.getElementById('timeRange').addEventListener('change', function () {
            renderChart(document.getElementById('chartType').value, this.value);
        });
    </script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap @5.3.6/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>