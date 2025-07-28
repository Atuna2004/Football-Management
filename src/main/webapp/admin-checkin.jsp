<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Booking" %>
<html>
<head>
    <title>Quản lý Check-in</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #fafafa;
            color: #333;
            line-height: 1.6;
            padding: 2rem 1rem;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .search-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid #eee;
        }

        .search-form {
            display: flex;
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            flex: 1;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #555;
        }

        .form-label i {
            color: #007bff;
            margin-right: 0.5rem;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.2s;
        }

        .form-input:focus {
            border-color: #007bff;
            outline: none;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
            text-decoration: none;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            transform: translateY(-1px);
        }

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .btn-success:hover {
            background-color: #218838;
            transform: translateY(-1px);
        }

        .alert {
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .booking-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 2rem;
            border: 1px solid #eee;
            margin-bottom: 2rem;
        }

        .booking-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .booking-info {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #666;
            font-weight: 500;
        }

        .info-label i {
            color: #007bff;
            width: 16px;
        }

        .info-value {
            font-weight: 600;
            color: #333;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-confirmed {
            background: #d4edda;
            color: #155724;
        }

        .status-checkedin {
            background: #cce5ff;
            color: #004085;
        }

        .checkin-section {
            text-align: center;
        }

        .already-checkedin {
            background: #e6f3ff;
            border: 1px solid #b3d9ff;
            color: #004085;
            padding: 1rem;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        @media (max-width: 768px) {
            body {
                padding: 1rem 0.5rem;
            }

            .search-form {
                flex-direction: column;
                align-items: stretch;
            }

            .info-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.25rem;
            }

            .booking-card {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2 class="page-title">
                <i class="fas fa-user-check"></i>
                Xác nhận Check-in
            </h2>
        </div>

        <div class="search-card">
            <form method="get" action="admincheck" class="search-form">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-search"></i>
                        Mã check-in (token)
                    </label>
                    <input type="text" name="token" class="form-input" required placeholder="Nhập mã token..." />
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i>
                    Tìm đơn
                </button>
            </form>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <%
            Booking booking = (Booking) request.getAttribute("booking");
            if (booking != null) {
        %>
            <div class="booking-card">
                <h3 class="booking-title">
                    <i class="fas fa-receipt"></i>
                    Thông tin đơn đặt sân
                </h3>
                
                <div class="booking-info">
                    <div class="info-item">
                        <span class="info-label">
                            <i class="fas fa-hashtag"></i>
                            Mã đơn
                        </span>
                        <span class="info-value"><%= booking.getBookingID() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">
                            <i class="fas fa-info-circle"></i>
                            Trạng thái
                        </span>
                        <span class="info-value">
                            <% if ("CheckedIn".equalsIgnoreCase(booking.getStatus())) { %>
                                <span class="status-badge status-checkedin"><%= booking.getStatus() %></span>
                            <% } else { %>
                                <span class="status-badge status-confirmed"><%= booking.getStatus() %></span>
                            <% } %>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">
                            <i class="fas fa-calendar-alt"></i>
                            Thời gian tạo
                        </span>
                        <span class="info-value"><%= booking.getCreatedAt() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">
                            <i class="fas fa-money-bill-wave"></i>
                            Tổng tiền
                        </span>
                        <span class="info-value"><%= booking.getTotalAmount() %> đ</span>
                    </div>
                </div>

                <div class="checkin-section">
                    <% if (!"CheckedIn".equalsIgnoreCase(booking.getStatus())) { %>
                        <form method="post" action="admincheck">
                            <input type="hidden" name="bookingId" value="<%= booking.getBookingID() %>" />
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check"></i>
                                Xác nhận Check-in
                            </button>
                        </form>
                    <% } else { %>
                        <div class="already-checkedin">
                            <i class="fas fa-check-circle"></i>
                            Khách đã check-in thành công
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>