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
        <title>Đặt sân gần đây</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background: #f4f6fa;
                font-family: 'Segoe UI', sans-serif;
                color: #333;
            }

            .card {
                border: none;
                box-shadow: 0 4px 20px rgba(0,0,0,0.05);
                border-radius: 12px;
            }

            .card-header {
                background: linear-gradient(to right, #6a11cb, #2575fc);
                color: white;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
                padding: 1rem 1.5rem;
            }

            .table-hover tbody tr:hover {
                background-color: #f0f4ff;
            }

            .table th {
                color: #6a11cb;
                text-transform: uppercase;
                font-size: 0.875rem;
            }

            .text-success {
                color: #28a745 !important;
                font-weight: bold;
            }

            .badge {
                font-size: 0.75rem;
                padding: 0.5em 0.75em;
                border-radius: 50px;
            }

            .btn-gradient {
                background: linear-gradient(to right, #6a11cb, #2575fc);
                color: white;
                border: none;
                border-radius: 8px;
                padding: 0.5rem 1rem;
                font-weight: 500;
            }

            .btn-gradient:hover {
                opacity: 0.9;
            }

            .table td, .table th {
                vertical-align: middle;
            }

            .text-muted {
                font-size: 0.875rem;
                color: #888 !important;
            }
        </style>


    </head>
    <body>
        <div class="container mt-5">
            <%
                User currentUser = (User) session.getAttribute("currentUser");
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

            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5>Danh sách khách hàng đã đặt sân</h5>
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
                                    <td><strong>#<%= booking.getBookingID() %></strong></td>
                                    <td>
                                        <strong><%= booking.getCustomerName() != null ? booking.getCustomerName() : "N/A" %></strong><br>
                                        <small class="text-muted"><%= booking.getCustomerEmail() %></small>
                                        <% if (booking.getCustomerPhone() != null) { %>
                                        <br><small class="text-muted"><i class="fas fa-phone"></i> <%= booking.getCustomerPhone() %></small>
                                        <% } %>
                                    </td>
                                    <td>
                                        <strong><%= booking.getStadiumName() %></strong><br>
                                        <small class="text-muted"><%= booking.getFieldName() %> (<%= booking.getFieldType() %>)</small>
                                    </td>
                                    <td><%= dateFormat.format(booking.getBookingDate()) %></td>
                                    <td><%= timeFormat.format(booking.getStartTime()) %> - <%= timeFormat.format(booking.getEndTime()) %></td>
                                    <td><%= booking.getOrderedFoods() != null ? booking.getOrderedFoods() : "Không" %></td>
                                    <td><strong class="text-success"><%= currencyFormat.format(booking.getTotalAmount()) %></strong></td>
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
                                    <td><small class="text-muted"><%= datetimeFormat.format(booking.getCreatedAt()) %></small></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else if (hasError) { %>
                    <div class="text-center py-4 text-warning">
                        <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                        <p><%= errorMessage %></p>
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
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
