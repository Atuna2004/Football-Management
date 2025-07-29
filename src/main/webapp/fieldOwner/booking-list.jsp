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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bookingList.css">
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
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
        %>
        <div class="user-greeting" style="margin-right: 40px;">
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

<%@ include file="FieldOwnerSB.jsp" %>

<main class="main-content">
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
                                <div class="stadium-name"><%= booking.getStadiumName() %>
                                </div>
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
                <p><%= errorMessage %>
                </p>
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
        const tableRows = document.querySelectorAll('tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
            row.classList.add('fade-in');
        });

        const actionBtns = document.querySelectorAll('.action-btn');
        actionBtns.forEach(btn => {
            btn.addEventListener('click', function () {
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                this.disabled = true;

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