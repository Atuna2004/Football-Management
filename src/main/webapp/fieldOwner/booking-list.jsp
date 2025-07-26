<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="model.RecentBooking" %>
<%@ page import="dao.DashboardDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách khách hàng - Field Manager</title>
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

        /* Top Header */
        .top-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            padding: 20px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
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

        /* Card Styles */
        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            border: 1px solid rgba(59, 130, 246, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.12);
        }

        .card-header {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 32px 40px;
            border: none;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h5 {
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-body {
            padding: 0;
        }

        /* Table Styles */
        .table-responsive {
            border-radius: 0 0 24px 24px;
            overflow: hidden;
        }

        .table {
            background: transparent;
            border-collapse: collapse;
            width: 100%;
            margin: 0;
        }

        .table th {
            background: rgba(59, 130, 246, 0.05);
            color: #1e293b;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 24px 20px;
            border: none;
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .table td {
            padding: 24px 20px;
            border: none;
            border-bottom: 1px solid rgba(59, 130, 246, 0.05);
            vertical-align: middle;
        }

        .table tr {
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background: rgba(59, 130, 246, 0.03);
            transform: scale(1.005);
        }

        /* Customer Info Styling */
        .customer-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .customer-name {
            font-weight: 600;
            color: #1e293b;
            font-size: 16px;
        }

        .customer-contact {
            color: #64748b;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* Stadium Info Styling */
        .stadium-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .stadium-name {
            font-weight: 600;
            color: #1e293b;
            font-size: 16px;
        }

        .field-details {
            color: #64748b;
            font-size: 14px;
        }

        /* Booking ID Styling */
        .booking-id {
            font-weight: 700;
            color: #3b82f6;
            font-size: 16px;
        }

        /* Amount Styling */
        .amount {
            font-weight: 700;
            color: #059669;
            font-size: 16px;
        }

        /* Date and Time Styling */
        .date-time {
            color: #1e293b;
            font-weight: 500;
        }

        /* Food Orders */
        .food-orders {
            color: #64748b;
            font-style: italic;
        }

        /* Status Badge Styles */
        .badge {
            padding: 8px 16px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .badge.bg-success {
            background: rgba(16, 185, 129, 0.1) !important;
            color: #059669;
        }

        .badge.bg-warning {
            background: rgba(245, 158, 11, 0.1) !important;
            color: #d97706;
        }

        .badge.bg-danger {
            background: rgba(239, 68, 68, 0.1) !important;
            color: #dc2626;
        }

        .badge.bg-primary {
            background: rgba(59, 130, 246, 0.1) !important;
            color: #2563eb;
        }

        .badge.bg-secondary {
            background: rgba(100, 116, 139, 0.1) !important;
            color: #64748b;
        }

        /* Status Icons */
        .status-icon {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
        }

        .status-completed .status-icon { background: #059669; }
        .status-pending .status-icon { background: #d97706; }
        .status-cancelled .status-icon { background: #dc2626; }
        .status-confirmed .status-icon { background: #2563eb; }

        /* Created At Styling */
        .created-at {
            color: #64748b;
            font-size: 13px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
        }

        .empty-state i {
            font-size: 64px;
            color: #cbd5e1;
            margin-bottom: 24px;
        }

        .empty-state h3 {
            color: #64748b;
            margin-bottom: 12px;
            font-size: 20px;
            font-weight: 600;
        }

        .empty-state p {
            color: #94a3b8;
            font-size: 14px;
        }

        /* Error State */
        .error-state {
            text-align: center;
            padding: 80px 40px;
        }

        .error-state i {
            font-size: 64px;
            color: #fbbf24;
            margin-bottom: 24px;
        }

        .error-state h3 {
            color: #d97706;
            margin-bottom: 12px;
            font-size: 20px;
            font-weight: 600;
        }

        .error-state p {
            color: #92400e;
            font-size: 14px;
        }

        /* Action Buttons */
        .action-btn {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 500;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(59, 130, 246, 0.25);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 24px;
            }

            .page-title {
                font-size: 28px;
            }

            .card-header,
            .table th,
            .table td {
                padding: 16px;
            }

            .table-responsive {
                font-size: 14px;
            }

            .customer-info,
            .stadium-info {
                gap: 2px;
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

        /* Utility Classes */
        .d-flex { display: flex; }
        .justify-content-between { justify-content: space-between; }
        .align-items-center { align-items: center; }
    </style>
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="container-fluid">
            <div class="logo">
                <h3>
                    <a href="<%= request.getContextPath() %>/home.jsp">
                        <i class="fas fa-futbol"></i>
                    </a>
                    Field Manager
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

    <!-- Sidebar -->
    <%@ include file="FieldOwnerSB.jsp" %>

    <main class="main-content">
        <!-- Page Title -->
        <h1 class="page-title fade-in">
            <i class="fas fa-users"></i>
            Danh sách khách hàng
        </h1>

        <%
            List<RecentBooking> recentBookings = null;
            boolean hasError = false;
            String errorMessage = "";

            if (currentUser != null) {
                try {
                    DashboardDAO dashboardDAO = new DashboardDAO();
                    recentBookings = dashboardDAO.getAllBookings();
                } catch (Exception e) {
                    hasError = true;
                    errorMessage = "Lỗi khi tải dữ liệu: " + e.getMessage();
                    e.printStackTrace();
                }
            }
        %>

        <div class="card fade-in">
            <div class="card-header">
                <h5>
                    <i class="fas fa-list"></i>
                    Danh sách khách hàng đã đặt sân
                </h5>
                <span style="font-size: 14px; opacity: 0.9;">
                    <%= recentBookings != null ? recentBookings.size() : 0 %> booking
                </span>
            </div>
            <div class="card-body">
                <% if (recentBookings != null && !recentBookings.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Khách hàng</th>
                                <th>Sân</th>
                                <th>Ngày đặt</th>
                                <th>Thời gian</th>
                                <th>Món ăn</th>
                                <th>Số tiền</th>
                                <th>Trạng thái</th>
                                <th>Đặt lúc</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                                SimpleDateFormat datetimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                
                                for (RecentBooking booking : recentBookings) {
                            %>
                            <tr>
                                <td>
                                    <span class="booking-id">#<%= booking.getBookingID() %></span>
                                </td>
                                <td>
                                    <div class="customer-info">
                                        <div class="customer-name">
                                            <%= booking.getCustomerName() != null ? booking.getCustomerName() : "N/A" %>
                                        </div>
                                        <div class="customer-contact">
                                            <i class="fas fa-envelope" style="color: #64748b;"></i>
                                            <%= booking.getCustomerEmail() %>
                                        </div>
                                        <% if (booking.getCustomerPhone() != null) { %>
                                        <div class="customer-contact">
                                            <i class="fas fa-phone" style="color: #64748b;"></i>
                                            <%= booking.getCustomerPhone() %>
                                        </div>
                                        <% } %>
                                    </div>
                                </td>
                                <td>
                                    <div class="stadium-info">
                                        <div class="stadium-name"><%= booking.getStadiumName() %></div>
                                        <div class="field-details">
                                            <%= booking.getFieldName() %> (<%= booking.getFieldType() %>)
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="date-time"><%= dateFormat.format(booking.getBookingDate()) %></span>
                                </td>
                                <td>
                                    <span class="date-time">
                                        <%= timeFormat.format(booking.getStartTime()) %> - <%= timeFormat.format(booking.getEndTime()) %>
                                    </span>
                                </td>
                                <td>
                                    <span class="food-orders">
                                        <%= booking.getOrderedFoods() != null ? booking.getOrderedFoods() : "Không có" %>
                                    </span>
                                </td>
                                <td>
                                    <span class="amount"><%= currencyFormat.format(booking.getTotalAmount()) %></span>
                                </td>
                                <td>
                                    <%
                                        String statusClass = "";
                                        String statusText = booking.getStatus();
                                        String statusIcon = "";
                                        switch (booking.getStatus().toLowerCase()) {
                                            case "completed":
                                                statusClass = "badge bg-success status-completed";
                                                statusText = "Hoàn thành";
                                                statusIcon = "fas fa-check";
                                                break;
                                            case "pending":
                                                statusClass = "badge bg-warning status-pending";
                                                statusText = "Chờ xử lý";
                                                statusIcon = "fas fa-clock";
                                                break;
                                            case "cancelled":
                                                statusClass = "badge bg-danger status-cancelled";
                                                statusText = "Đã hủy";
                                                statusIcon = "fas fa-times";
                                                break;
                                            case "confirmed":
                                                statusClass = "badge bg-primary status-confirmed";
                                                statusText = "Đã xác nhận";
                                                statusIcon = "fas fa-check-circle";
                                                break;
                                            default:
                                                statusClass = "badge bg-secondary";
                                                statusIcon = "fas fa-question";
                                        }
                                    %>
                                    <span class="<%= statusClass %>">
                                        <i class="<%= statusIcon %>"></i>
                                        <%= statusText %>
                                    </span>
                                </td>
                                <td>
                                    <span class="created-at"><%= datetimeFormat.format(booking.getCreatedAt()) %></span>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else if (hasError) { %>
                <div class="error-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Không thể tải dữ liệu</h3>
                    <p><%= errorMessage %></p>
                    <small style="color: #64748b;">Vui lòng kiểm tra kết nối cơ sở dữ liệu</small>
                </div>
                <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-calendar-times"></i>
                    <h3>Chưa có khách hàng nào</h3>
                    <p>Các booking mới sẽ hiển thị tại đây</p>
                </div>
                <% } %>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Add fade-in animation to table rows
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.animationDelay = `${index * 0.05}s`;
                row.classList.add('fade-in');
            });

            // Add loading effect when hovering action buttons
            const actionBtns = document.querySelectorAll('.action-btn');
            actionBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                    this.disabled = true;
                    
                    // Re-enable after 2 seconds (for demo purposes)
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.disabled = false;
                    }, 2000);
                });
            });
        });
    </script>
</body>
</html>