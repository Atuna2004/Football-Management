<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Quản Trị</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
            }
            
            .main-content {
                margin-left: 280px;
                padding: 30px;
                min-height: 100vh;
            }
            
            .header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 20px 30px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
            }
            
            .header h2 {
                color: #333;
                font-weight: 700;
                font-size: 32px;
            }
            
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 25px;
                margin-bottom: 40px;
            }
            
            .stat-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 30px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                position: relative;
                overflow: hidden;
                transition: all 0.3s ease;
            }
            
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            }
            
            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #667eea, #764ba2);
            }
            
            .stat-card.primary::before {
                background: linear-gradient(90deg, #667eea, #764ba2);
            }
            
            .stat-card.success::before {
                background: linear-gradient(90deg, #56ab2f, #a8e6cf);
            }
            
            .stat-card.warning::before {
                background: linear-gradient(90deg, #f093fb, #f5576c);
            }
            
            .stat-card.danger::before {
                background: linear-gradient(90deg, #4facfe, #00f2fe);
            }

            .stat-icon {
                width: 60px;
                height: 60px;
                border-radius: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                color: white;
                margin-bottom: 20px;
            }
            
            .stat-card.primary .stat-icon {
                background: linear-gradient(135deg, #667eea, #764ba2);
            }
            
            .stat-card.success .stat-icon {
                background: linear-gradient(135deg, #56ab2f, #a8e6cf);
            }
            
            .stat-card.warning .stat-icon {
                background: linear-gradient(135deg, #f093fb, #f5576c);
            }
            
            .stat-card.danger .stat-icon {
                background: linear-gradient(135deg, #4facfe, #00f2fe);
            }

            .stat-title {
                font-size: 14px;
                color: #666;
                margin-bottom: 10px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .stat-value {
                font-size: 32px;
                font-weight: 700;
                color: #333;
                margin-bottom: 10px;
            }
            
            .stat-change {
                font-size: 12px;
                color: #28a745;
                font-weight: 600;
            }

            .card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
                overflow: hidden;
            }
            
            .card-header {
                padding: 25px 30px;
                border-bottom: 1px solid rgba(0, 0, 0, 0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .card-header h5 {
                font-size: 20px;
                font-weight: 700;
                color: #333;
            }
            
            .card-body {
                padding: 30px;
            }
            
            .table {
                width: 100%;
                border-collapse: collapse;
                background: transparent;
            }
            
            .table th,
            .table td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            }
            
            .table th {
                background: rgba(102, 126, 234, 0.1);
                font-weight: 600;
                color: #333;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .table tr:hover {
                background: rgba(102, 126, 234, 0.05);
            }
            
            .badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .badge.success {
                background: linear-gradient(135deg, #56ab2f, #a8e6cf);
                color: white;
            }
            
            .badge.pending {
                background: linear-gradient(135deg, #f093fb, #f5576c);
                color: white;
            }
            
            .btn {
                padding: 8px 16px;
                border: none;
                border-radius: 8px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }
            
            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }
            
            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            
            .btn-info {
                background: linear-gradient(135deg, #4facfe, #00f2fe);
                color: white;
            }
            
            .btn-success {
                background: linear-gradient(135deg, #56ab2f, #a8e6cf);
                color: white;
            }
            
            .btn-danger {
                background: linear-gradient(135deg, #f093fb, #f5576c);
                color: white;
            }
            
            .btn-outline {
                background: transparent;
                border: 2px solid #667eea;
                color: #667eea;
            }
            
            .btn-outline:hover {
                background: #667eea;
                color: white;
            }
            
            .progress-container {
                background: rgba(0, 0, 0, 0.1);
                border-radius: 15px;
                height: 30px;
                overflow: hidden;
                margin-top: 20px;
            }
            
            .progress-bar {
                height: 100%;
                background: linear-gradient(90deg, #667eea, #764ba2);
                border-radius: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                transition: width 0.3s ease;
            }
            
            .chart-placeholder {
                height: 200px;
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
                border-radius: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #666;
                font-style: italic;
                margin-bottom: 20px;
            }
            
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                    padding: 20px;
                }
                
                .stats-grid {
                    grid-template-columns: 1fr;
                }
                
                .card-header {
                    flex-direction: column;
                    gap: 15px;
                    align-items: flex-start;
                }
                
                .table-responsive {
                    overflow-x: auto;
                }
            }
            
            .fade-in {
                animation: fadeIn 0.6s ease-in;
            }
            
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>

        <!-- Include Sidebar -->
        <%@ include file="sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header fade-in">
                <h2><i class="fas fa-tachometer-alt"></i> Thống Kê Tổng Quan</h2>
            </div>

            <!-- Thống kê -->
            <div class="stats-grid fade-in">
                <div class="stat-card primary">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-title">Tổng Người Dùng</div>
                    <div class="stat-value">1,200</div>
                    <div class="stat-change">↗ +12% so với tháng trước</div>
                </div>
                <div class="stat-card success">
                    <div class="stat-icon">
                        <i class="fas fa-futbol"></i>
                    </div>
                    <div class="stat-title">Sân Vận Động</div>
                    <div class="stat-value">45</div>
                    <div class="stat-change">↗ +3 sân mới</div>
                </div>
                <div class="stat-card warning">
                    <div class="stat-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-title">Doanh Thu Hôm Nay</div>
                    <div class="stat-value">₫2.5M</div>
                    <div class="stat-change">↗ +25% so với hôm qua</div>
                </div>
                <div class="stat-card danger">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-plus"></i>
                    </div>
                    <div class="stat-title">Đơn Mới Nhất</div>
                    <div class="stat-value">12</div>
                    <div class="stat-change">↗ +4 đơn trong giờ qua</div>
                </div>
            </div>

            <!-- Đơn đặt sân gần đây -->
            <div class="card fade-in">
                <div class="card-header">
                    <h5><i class="fas fa-calendar-check"></i> Đơn Đặt Sân Mới Nhất</h5>
                    <a href="#" class="btn btn-outline">Xem tất cả</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Khách Hàng</th>
                                    <th>Sân</th>
                                    <th>Thời Gian</th>
                                    <th>Trạng Thái</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>#1001</strong></td>
                                    <td>
                                        <div><strong>Nguyễn Văn A</strong><br><small>a@example.com</small></div>
                                    </td>
                                    <td>Sân Cầu Lông ABC</td>
                                    <td>15:00 - 17:00<br><small>10/10/2024</small></td>
                                    <td><span class="badge success">Hoàn Tất</span></td>
                                    <td>
                                        <button class="btn btn-info">Chi tiết</button>
                                        <button class="btn btn-danger">Hủy</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>#1002</strong></td>
                                    <td>
                                        <div><strong>Lê Thị B</strong><br><small>b@example.com</small></div>
                                    </td>
                                    <td>Sân Bóng Nguyễn Huệ</td>
                                    <td>18:00 - 20:00<br><small>10/10/2024</small></td>
                                    <td><span class="badge pending">Chờ Xác Nhận</span></td>
                                    <td>
                                        <button class="btn btn-info">Chi tiết</button>
                                        <button class="btn btn-success">Duyệt</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ doanh thu -->
            <div class="card fade-in">
                <div class="card-header">
                    <h5><i class="fas fa-chart-line"></i> Thống Kê Doanh Thu Tuần Này</h5>
                </div>
                <div class="card-body">
                    <div class="chart-placeholder">
                        <i class="fas fa-chart-area fa-3x" style="opacity: 0.3;"></i>
                        <div style="margin-left: 20px;">
                            <div>Biểu đồ doanh thu sẽ được hiển thị tại đây</div>
                            <small>Tích hợp Chart.js hoặc D3.js để hiển thị dữ liệu</small>
                        </div>
                    </div>
                    <div class="progress-container">
                        <div class="progress-bar" style="width: 75%">
                            Đạt 75% mục tiêu tuần
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tài khoản đăng ký gần đây -->
            <div class="card fade-in">
                <div class="card-header">
                    <h5><i class="fas fa-user-plus"></i> Tài Khoản Đăng Ký Gần Đây</h5>
                    <a href="#" class="btn btn-outline">Quản Lý Người Dùng</a>
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
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; margin-right: 12px;">N</div>
                                            <strong>Nguyễn Văn A</strong>
                                        </div>
                                    </td>
                                    <td>a@example.com</td>
                                    <td><span class="badge success">User</span></td>
                                    <td>2024-10-05</td>
                                    <td><i class="fas fa-circle" style="color: #28a745; font-size: 8px;"></i> Hoạt động</td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div style="width: 40px; height: 40px; background: linear-gradient(135deg, #56ab2f, #a8e6cf); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; margin-right: 12px;">L</div>
                                            <strong>Lê Thị B</strong>
                                        </div>
                                    </td>
                                    <td>b@example.com</td>
                                    <td><span class="badge pending">Field Owner</span></td>
                                    <td>2024-10-04</td>
                                    <td><i class="fas fa-circle" style="color: #28a745; font-size: 8px;"></i> Hoạt động</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS Ripple Animation -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Ripple effect on button click
                const buttons = document.querySelectorAll('.btn');
                buttons.forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        if (!this.classList.contains('btn-outline')) {
                            e.preventDefault();
                        }
                        const ripple = document.createElement('span');
                        const rect = this.getBoundingClientRect();
                        const size = Math.max(rect.width, rect.height);
                        ripple.style.cssText = `
                            position: absolute;
                            width: ${size}px;
                            height: ${size}px;
                            background: rgba(255, 255, 255, 0.6);
                            border-radius: 50%;
                            left: ${e.clientX - rect.left - size / 2}px;
                            top: ${e.clientY - rect.top - size / 2}px;
                            transform: scale(0);
                            animation: ripple 0.6s ease-out;
                            pointer-events: none;
                        `;
                        this.appendChild(ripple);

                        setTimeout(() => ripple.remove(), 600);
                    });
                });
            });

            // Animation keyframes
            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    to {
                        transform: scale(2);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        </script>
    </body>
</html>