<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý người dùng</title>
        <link rel="stylesheet" href="assets/css/dashboard.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                font-family: 'Roboto', sans-serif;
                box-sizing: border-box;
            }

            body {
                margin: 0;
                background-color: #eef1f5;
            }

            .main-container {
                display: flex;
            }

            .user-management {
                margin-left: 250px;
                padding: 40px 60px;
                width: calc(100% - 250px);
                background-color: #f9fbfd;
                min-height: 100vh;
            }

            .user-management h2 {
                font-size: 28px;
                margin-bottom: 25px;
                color: #2c3e50;
            }

            .add-btn {
                background: linear-gradient(135deg, #48bb78, #2b6cb0);
                color: white;
                padding: 10px 18px;
                border: none;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 15px;
                transition: all 0.3s ease;
            }

            .add-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            th, td {
                padding: 16px 20px;
                border-bottom: 1px solid #ececec;
                text-align: left;
                font-size: 15px;
            }

            th {
                background-color: #f1f2f6;
                font-weight: 600;
                color: #34495e;
            }

            tr:hover {
                background-color: #f5f9fc;
            }

            .action-btn {
                padding: 6px 12px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .btn-edit {
                background: linear-gradient(135deg, #f39c12, #e67e22);
                color: white;
            }

            .btn-delete {
                background: linear-gradient(135deg, #e74c3c, #c0392b);
                color: white;
            }

            .status-active {
                color: #27ae60;
                font-weight: bold;
            }

            .status-inactive {
                color: #7f8c8d;
                font-style: italic;
            }

            /* Modal Styling */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.4);
            }

            .modal-content {
                background-color: #fff;
                margin: 5% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 50%;
                border-radius: 10px;
            }

            .close {
                color: #aaa;
                float: right;
                font-size: 24px;
                font-weight: bold;
                cursor: pointer;
            }

            .close:hover {
                color: black;
                text-decoration: none;
                cursor: pointer;
            }

            label {
                display: block;
                margin-top: 10px;
                font-weight: 600;
            }

            input[type="text"],
            input[type="email"],
            input[type="date"] {
                width: 100%;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>

        <div class="main-container">
            <%@ include file="sidebar.jsp" %>

            <div class="user-management">
                <h2>Quản lý người dùng</h2>
                <button class="add-btn" onclick="openAddModal()">
                    + Thêm người dùng
                </button>

                <!-- Thông báo nếu không có dữ liệu -->
                <c:if test="${empty userList}">
                    <p style="color: red; font-size: 16px;">Không có người dùng nào trong hệ thống.</p>
                </c:if>

                <!-- Bảng hiển thị người dùng -->
                <c:if test="${not empty userList}">
                    <div class="table-container">
                        <table id="userTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${userList}" varStatus="loop">
                                    <tr class="user-row" data-name="${fn:toLowerCase(user.fullName)}" data-email="${fn:toLowerCase(user.email)}">
                                        <td>${user.userID}</td>
                                        <td>${user.fullName}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <c:forEach var="role" items="${user.roles}" varStatus="roleLoop">
                                                ${role.roleName}${!roleLoop.last ? ', ' : ''}
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <span class="${user.active ? 'status-active' : 'status-inactive'}">
                                                ${user.active ? 'Hoạt động' : 'Tạm khóa'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="action-btn btn-edit"
                                                        onclick="openEditModal(${user.userID}, '${user.fullName}', '${user.email}', '${user.phone}', '${user.address}', '<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd'/>', ${user.active})">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </button>
                                                <form method="post" action="user-list" style="display:inline;" onsubmit="return confirm('Xác nhận xóa?')">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${user.userID}">
                                                    <button type="submit" class="action-btn btn-delete">
                                                        <i class="fas fa-trash"></i> Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Modal Thêm/Sửa Người Dùng -->
        <div id="userModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h3 id="modalTitle">Thêm người dùng mới</h3>
                <form id="userForm" method="post" action="user-list">
                    <input type="hidden" name="action" id="modalAction" value="add">
                    <input type="hidden" name="userID" id="modalUserID">

                    <label for="fullName">Họ tên:</label>
                    <input type="text" id="fullName" name="fullName" required><br/>

                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required><br/>

                    <label for="phone">Số điện thoại:</label>
                    <input type="text" id="phone" name="phone"><br/>

                    <label for="address">Địa chỉ:</label>
                    <input type="text" id="address" name="address"><br/>

                    <label for="dob">Ngày sinh:</label>
                    <input type="date" id="dob" name="dateOfBirth"><br/>

                    <label><input type="checkbox" id="isActive" name="isActive" checked> Hoạt động</label><br/><br/>

                    <button type="submit" class="action-btn btn-edit">Lưu</button>
                    <button type="button" class="action-btn btn-delete" onclick="closeModal()">Hủy</button>
                </form>
            </div>
        </div>

        <script>
            // Ripple animation
            document.addEventListener('DOMContentLoaded', function () {
                const buttons = document.querySelectorAll('.action-btn');
                buttons.forEach(btn => {
                    btn.style.position = 'relative';
                    btn.style.overflow = 'hidden';

                    btn.addEventListener('click', function (e) {
                        if (!this.classList.contains('no-ripple')) {
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

            // Tự tạo animation ripple
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

            // Hàm mở modal thêm người dùng
            function openAddModal() {
                document.getElementById("modalAction").value = "add";
                document.getElementById("modalTitle").innerText = "Thêm người dùng mới";
                document.getElementById("userForm").reset();
                document.getElementById("modalUserID").value = "";
                document.getElementById("userModal").style.display = "block";
            }

            // Hàm mở modal sửa người dùng
            function openEditModal(userID, fullName, email, phone, address, dob, isActive) {
                document.getElementById("modalAction").value = "update";
                document.getElementById("modalUserID").value = userID;
                document.getElementById("fullName").value = fullName;
                document.getElementById("email").value = email;
                document.getElementById("phone").value = phone;
                document.getElementById("address").value = address;
                document.getElementById("dob").value = dob;
                document.getElementById("isActive").checked = isActive;

                document.getElementById("modalTitle").innerText = "Cập nhật người dùng";
                document.getElementById("userModal").style.display = "block";
            }

            // Hàm đóng modal
            function closeModal() {
                document.getElementById("userModal").style.display = "none";
            }

            // Đóng modal khi click ra ngoài
            window.onclick = function (event) {
                const modal = document.getElementById("userModal");
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            };

            // Tìm kiếm người dùng
            document.getElementById("searchInput")?.addEventListener("input", function () {
                const searchTerm = this.value.toLowerCase();
                const rows = document.querySelectorAll(".user-row");

                rows.forEach(row => {
                    const name = row.getAttribute("data-name");
                    const email = row.getAttribute("data-email");
                    if (name.includes(searchTerm) || email.includes(searchTerm)) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            });
        </script>

    </body>
</html>