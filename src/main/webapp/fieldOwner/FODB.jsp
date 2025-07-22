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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/FieldOwnerDB.css">
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
        <!-- Left Navigation Sidebar -->
        <%@ include file="FieldOwnerSB.jsp" %>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Stats Overview -->
            <section class="stats-overview">
                <h4 class="mb-4">Thống kê tổng quan</h4>
                <%
                    // Khởi tạo các biến mặc định
                    int todayBookings = 0;
                    double monthlyRevenue = 0.0;
                    int totalFields = 0;
                    int totalCustomers = 0;
                    String monthlyRevenueFormatted = "0";
                    List<RecentBooking> recentBookings = null;
                    Map<Integer, Double> monthlyRevenueMap = null;
                    boolean hasError = false;
                    String errorMessage = "";
                    
                    // Lấy dữ liệu thống kê từ database
                    if (currentUser != null) {
                        try {
                            DashboardDAO dashboardDAO = new DashboardDAO();
                            
                            // Lấy thống kê tổng quan
                            DashboardStats stats = dashboardDAO.getDashboardStats(currentUser.getUserID());
                            
                            if (stats != null) {
                                todayBookings = stats.getTodayBookings();
                                totalFields = stats.getTotalFields();
                                totalCustomers = stats.getTotalCustomers();
                            }
                            
                            // Lấy doanh thu tháng hiện tại từ hàm getMonthlyRevenueByOwner
                            monthlyRevenueMap = dashboardDAO.getMonthlyRevenueByOwner(currentUser.getUserID());
                            int currentMonth = Calendar.getInstance().get(Calendar.MONTH) + 1; // +1 vì Calendar.MONTH bắt đầu từ 0
                            if (monthlyRevenueMap != null && monthlyRevenueMap.containsKey(currentMonth)) {
                                monthlyRevenue = monthlyRevenueMap.get(currentMonth);
                            }
                            
                            // Lấy danh sách đặt sân gần đây (10 booking gần nhất)
                            recentBookings = dashboardDAO.getRecentBookings(currentUser.getUserID(), 10);
                            
                            // Format doanh thu
                            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                            if (monthlyRevenue >= 1000000) {
                                monthlyRevenueFormatted = String.format("%.1fM", monthlyRevenue / 1000000);
                            } else if (monthlyRevenue >= 1000) {
                                monthlyRevenueFormatted = String.format("%.0fK", monthlyRevenue / 1000);
                            } else {
                                monthlyRevenueFormatted = currencyFormat.format(monthlyRevenue);
                            }
                            
                        } catch (Exception e) {
                            hasError = true;
                            errorMessage = "Lỗi khi tải dữ liệu: " + e.getMessage();
                            System.err.println("Dashboard error: " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                %>

                <div class="stats-grid">
                    <div class="stat-card bookings">
                        <div class="icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-content">
                            <h4><%= todayBookings %></h4>
                            <p>Lượt đặt hôm nay</p>
                        </div>
                    </div>

                    <div class="stat-card revenue">
                        <div class="icon">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-content">
                            <h4><%= monthlyRevenueFormatted %></h4>
                            <p>Doanh thu tháng này</p>
                        </div>
                    </div>

                    <div class="stat-card fields">
                        <div class="icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="stat-content">
                            <h4><%= totalFields %></h4>
                            <p>Tổng số sân</p>
                        </div>
                    </div>

                    <div class="stat-card customers">
                        <div class="icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-content">
                            <h4><%= totalCustomers %></h4>
                            <p>Khách hàng</p>
                        </div>
                    </div>                    
                </div>
                
                <%-- Hiển thị thông báo lỗi nếu có --%>
                <% if (hasError) { %>
                    <div class="alert alert-warning mt-3">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Cảnh báo:</strong> <%= errorMessage %>
                    </div>
                <% } %>

                <%-- Hiển thị thông báo nếu không có dữ liệu --%>
                <% if (!hasError && todayBookings == 0 && monthlyRevenue == 0.0 && totalFields == 0 && totalCustomers == 0) { %>
                    <div class="alert alert-info mt-3">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Thông báo:</strong> Chưa có dữ liệu thống kê. Hãy bắt đầu bằng cách thêm sân và nhận booking đầu tiên!
                    </div>
                <% } %>
            </section>

            <!-- Quick Actions -->
            <div class="card">
                <div class="card-header">
                    <h5>Thao tác nhanh</h5>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <a href="createStadium.jsp" class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-plus"></i>
                                </div>
                                <span>Thêm sân mới</span>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="#" class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <span>Tạo lịch đặt</span>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="#" class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-file-alt"></i>
                                </div>
                                <span>Xuất báo cáo</span>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="#" class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-bell"></i>
                                </div>
                                <span>Gửi thông báo</span>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="#" class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <span>Xem thống kê</span>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="#" class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-users-cog"></i>
                                </div>
                                <span>Quản lý nhân viên</span>
                            </a>
                        </div>
                    </div>
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
                                            <td>
                                                <%= timeFormat.format(booking.getStartTime()) %> - 
                                                <%= timeFormat.format(booking.getEndTime()) %>
                                            </td>
                                            <td>
                                                <strong class="text-success">
                                                    <%= currencyFormat.format(booking.getTotalAmount()) %>
                                                </strong>
                                            </td>
                                            <td>
                                                <%
                                                    String statusClass = "";
                                                    String statusText = booking.getStatus();
                                                    switch (booking.getStatus().toLowerCase()) {
                                                        case "completed":
                                                            statusClass = "badge bg-success";
                                                            statusText = "Hoàn thành";
                                                            break;
                                                        case "pending":
                                                            statusClass = "badge bg-warning";
                                                            statusText = "Chờ xử lý";
                                                            break;
                                                        case "cancelled":
                                                            statusClass = "badge bg-danger";
                                                            statusText = "Đã hủy";
                                                            break;
                                                        case "confirmed":
                                                            statusClass = "badge bg-primary";
                                                            statusText = "Đã xác nhận";
                                                            break;
                                                        default:
                                                            statusClass = "badge bg-secondary";
                                                    }
                                                %>
                                                <span class="<%= statusClass %>"><%= statusText %></span>
                                            </td>
                                            <td>
                                                <small class="text-muted">
                                                    <%= datetimeFormat.format(booking.getCreatedAt()) %>
                                                </small>
                                            </td>
                                        </tr>
                                    <% 
                                        count ++;
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>