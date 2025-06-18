<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý người dùng</title>
        <link rel="stylesheet" href="assets/css/dashboard.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                font-family: 'Inter', sans-serif;
                box-sizing: border-box;
            }

            body {
                margin: 0;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
            }

            .main-container {
                display: flex;
            }

            .user-management {
                margin-left: 250px;
                padding: 40px;
                width: calc(100% - 250px);
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                min-height: 100vh;
                border-radius: 20px 0 0 0;
                box-shadow: -10px 0 30px rgba(0, 0, 0, 0.1);
            }

            .header-section {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 40px;
                padding-bottom: 20px;
                border-bottom: 2px solid #f0f0f0;
            }

            .header-section h2 {
                font-size: 32px;
                font-weight: 700;
                color: #2d3748;
                margin: 0;
                position: relative;
            }

            .header-section h2::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 0;
                width: 50px;
                height: 4px;
                background: linear-gradient(90deg, #667eea, #764ba2);
                border-radius: 2px;
            }

            .stats-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px;
                border-radius: 16px;
                text-align: center;
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
            }

            .stat-card .icon {
                font-size: 36px;
                margin-bottom: 10px;
                opacity: 0.9;
            }

            .stat-card .number {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 5px;
            }

            .stat-card .label {
                font-size: 14px;
                opacity: 0.9;
                font-weight: 500;
            }

            .add-btn {
                background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                color: white;
                padding: 14px 28px;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .add-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(72, 187, 120, 0.4);
            }

            .add-btn i {
                font-size: 18px;
            }

            .search-filter-section {
                display: flex;
                gap: 20px;
                margin-bottom: 30px;
                flex-wrap: wrap;
            }

            .search-box {
                flex: 1;
                min-width: 300px;
                position: relative;
            }

            .search-box input {
                width: 100%;
                padding: 14px 20px 14px 50px;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 16px;
                transition: border-color 0.3s ease;
                background: white;
            }

            .search-box input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .search-box i {
                position: absolute;
                left: 18px;
                top: 50%;
                transform: translateY(-50%);
                color: #a0aec0;
                font-size: 16px;
            }

            .filter-select {
                padding: 14px 20px;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 16px;
                background: white;
                cursor: pointer;
                transition: border-color 0.3s ease;
            }

            .filter-select:focus {
                outline: none;
                border-color: #667eea;
            }

            .table-container {
                background: white;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                border: 1px solid #f0f0f0;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 20px;
                text-align: left;
                font-size: 15px;
                border-bottom: 1px solid #f7fafc;
            }

            th {
                background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
                font-weight: 600;
                color: #4a5568;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-size: 13px;
            }

            tbody tr {
                transition: all 0.3s ease;
            }

            tbody tr:hover {
                background: linear-gradient(90deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
                transform: scale(1.01);
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea, #764ba2);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                font-size: 16px;
                margin-right: 12px;
                display: inline-flex;
            }

            .user-info {
                display: flex;
                align-items: center;
            }

            .user-details {
                display: flex;
                flex-direction: column;
            }

            .user-name {
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 2px;
            }

            .user-email {
                font-size: 13px;
                color: #718096;
            }

            .role-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                margin: 2px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .role-admin {
                background: linear-gradient(135deg, #e53e3e, #c53030);
                color: white;
            }

            .role-user {
                background: linear-gradient(135deg, #3182ce, #2c5282);
                color: white;
            }

            .role-manager {
                background: linear-gradient(135deg, #d69e2e, #b7791f);
                color: white;
            }

            .status-badge {
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .status-active {
                background: linear-gradient(135deg, #48bb78, #38a169);
                color: white;
            }

            .status-inactive {
                background: linear-gradient(135deg, #a0aec0, #718096);
                color: white;
            }

            .status-badge i {
                font-size: 10px;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
            }

            .action-btn {
                padding: 8px 16px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 600;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .edit-btn {
                background: linear-gradient(135deg, #ed8936, #dd6b20);
                color: white;
            }

            .edit-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(237, 137, 54, 0.3);
            }

            .delete-btn {
                background: linear-gradient(135deg, #e53e3e, #c53030);
                color: white;
            }

            .delete-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(229, 62, 62, 0.3);
            }

            .no-data {
                text-align: center;
                padding: 60px 20px;
                color: #718096;
                font-size: 18px;
            }

            .no-data i {
                font-size: 64px;
                margin-bottom: 20px;
                opacity: 0.5;
            }

            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
                margin-top: 30px;
            }

            .pagination button {
                padding: 10px 16px;
                border: 2px solid #e2e8f0;
                background: white;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .pagination button:hover {
                border-color: #667eea;
                background: #667eea;
                color: white;
            }

            .pagination button.active {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border-color: transparent;
            }

            @media (max-width: 768px) {
                .user-management {
                    margin-left: 0;
                    width: 100%;
                    padding: 20px;
                    border-radius: 0;
                }

                .header-section {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 20px;
                }

                .stats-cards {
                    grid-template-columns: 1fr;
                }

                .search-filter-section {
                    flex-direction: column;
                }

                .search-box {
                    min-width: auto;
                }

                .table-container {
                    overflow-x: auto;
                }

                table {
                    min-width: 600px;
                }
            }
        </style>
    </head>
    <body>

        <div class="main-container">
            <%@ include file="sidebar.jsp" %>

            <div class="user-management">
                <div class="header-section">
                    <h2><i class="fas fa-users"></i> Quản lý người dùng</h2>
                    <button class="add-btn" onclick="location.href = 'add-user.jsp'">
                        <i class="fas fa-plus"></i>
                        Thêm người dùng
                    </button>
                </div>

                <!-- Thống kê nhanh -->
                <div class="stats-cards">
                    <div class="stat-card">
                        <div class="icon"><i class="fas fa-users"></i></div>
                        <div class="number">${fn:length(userList)}</div>
                        <div class="label">Tổng người dùng</div>
                    </div>
                    <div class="stat-card">
                        <div class="icon"><i class="fas fa-user-check"></i></div>
                        <div class="number">
                            <c:set var="activeCount" value="0" />
                            <c:forEach var="user" items="${userList}">
                                <c:if test="${user.active}">
                                    <c:set var="activeCount" value="${activeCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${activeCount}
                        </div>
                        <div class="label">Đang hoạt động</div>
                    </div>
                    <div class="stat-card">
                        <div class="icon"><i class="fas fa-user-times"></i></div>
                        <div class="number">${fn:length(userList) - activeCount}</div>
                        <div class="label">Tạm khóa</div>
                    </div>
                </div>

                <!-- Tìm kiếm và lọc -->
                <div class="search-filter-section">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm theo tên hoặc email..." id="searchInput">
                    </div>
                    <select class="filter-select" id="roleFilter">
                        <option value="">Tất cả vai trò</option>
                        <option value="Admin">Admin</option>
                        <option value="User">User</option>
                        <option value="Manager">Manager</option>
                    </select>
                    <select class="filter-select" id="statusFilter">
                        <option value="">Tất cả trạng thái</option>
                        <option value="active">Hoạt động</option>
                        <option value="inactive">Tạm khóa</option>
                    </select>
                </div>

                <!-- Thông báo nếu không có dữ liệu -->
                <c:if test="${empty userList}">
                    <div class="table-container">
                        <div class="no-data">
                            <i class="fas fa-users-slash"></i>
                            <div>Không có người dùng nào trong hệ thống</div>
                            <div style="font-size: 14px; margin-top: 10px; opacity: 0.7;">
                                Hãy thêm người dùng đầu tiên để bắt đầu
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Bảng hiển thị người dùng -->
                <c:if test="${not empty userList}">
                    <div class="table-container">
                        <table id="userTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Người dùng</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${userList}" varStatus="loop">
                                    <tr class="user-row" data-name="${fn:toLowerCase(user.fullName)}" data-email="${fn:toLowerCase(user.email)}">
                                        <td>${user.userID}</td>
                                        <td>
                                            <div class="user-info">
                                                <div class="user-avatar">
                                                    ${fn:substring(user.fullName, 0, 1)}
                                                </div>
                                                <div class="user-details">
                                                    <div class="user-name">${user.fullName}</div>
                                                    <div class="user-email">${user.email}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:forEach var="role" items="${user.roles}" varStatus="roleLoop">
                                                <span class="role-badge role-${fn:toLowerCase(role.roleName)}">${role.roleName}</span>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'}">
                                                <i class="fas ${user.active ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                                                ${user.active ? 'Hoạt động' : 'Tạm khóa'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="action-btn edit-btn" onclick="location.href = 'edit-user.jsp?id=${user.userID}'">
                                                    <i class="fas fa-edit"></i>
                                                    Sửa
                                                </button>
                                                <button class="action-btn delete-btn" onclick="confirmDelete(${user.userID})">
                                                    <i class="fas fa-trash"></i>
                                                    Xóa
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Phân trang -->
                    <div class="pagination">
                        <button><i class="fas fa-chevron-left"></i></button>
                        <button class="active">1</button>
                        <button>2</button>
                        <button>3</button>
                        <button><i class="fas fa-chevron-right"></i></button>
                    </div>
                </c:if>
            </div>
        </div>

        <script>
            // Ripple effect
            document.addEventListener('DOMContentLoaded', function () {
                const buttons = document.querySelectorAll('button');
                buttons.forEach(btn => {
                    btn.style.position = 'relative';
                    btn.style.overflow = 'hidden';

                    btn.addEventListener('click', function (e) {
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

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', function () {
                const searchTerm = this.value.toLowerCase();
                const rows = document.querySelectorAll('.user-row');

                rows.forEach(row => {
                    const name = row.dataset.name;
                    const email = row.dataset.email;

                    if (name.includes(searchTerm) || email.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });

            // Confirm delete
            function confirmDelete(userId) {
                if (confirm('Bạn có chắc chắn muốn xóa người dùng này?')) {
                    location.href = 'delete-user?id=' + userId;
                }
            }

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