<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý người dùng</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/userManagement.css" />
    </head>
    <body>
        <div class="main-container">
            <%@ include file="sidebar.jsp" %>

            <div class="main-content">

                <div class="header fade-in">
                    <h2><i class="fas fa-users"></i> Quản Lý Người Dùng</h2>
                </div>


                <div class="search-container fade-in">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên hoặc email...">
                    </div>
                    <button class="add-btn" onclick="openAddModal()">
                        <i class="fas fa-plus"></i>
                        Thêm người dùng
                    </button>
                </div>


                <div class="card fade-in">
                    <c:if test="${empty userList}">
                        <div class="empty-state">
                            <i class="fas fa-users"></i>
                            <h3>Chưa có người dùng nào</h3>
                            <p>Hệ thống chưa có người dùng nào được đăng ký. Hãy thêm người dùng mới để bắt đầu.</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty userList}">
                        <div class="table-container">
                            <table id="userTable">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag"></i> ID</th>
                                        <th><i class="fas fa-user"></i> Người dùng</th>
                                        <th><i class="fas fa-envelope"></i> Email</th>
                                        <th><i class="fas fa-phone"></i> Số điện thoại</th>
                                        <th><i class="fas fa-map-marker-alt"></i> Địa chỉ</th>
                                        <th><i class="fas fa-birthday-cake"></i> Ngày sinh</th>
                                        <th><i class="fas fa-user-tag"></i> Vai trò</th>
                                        <th><i class="fas fa-toggle-on"></i> Trạng thái</th>
                                        <th><i class="fas fa-cogs"></i> Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${userList}" varStatus="loop">
                                        <tr class="user-row fade-in"
                                            data-name="${fn:toLowerCase(user.fullName)}"
                                            data-email="${fn:toLowerCase(user.email)}"
                                            style="animation-delay: ${loop.index * 0.1}s">
                                            <td><strong>#${user.userID}</strong></td>
                                            <td>
                                                <div class="user-info">
                                                    <div class="user-avatar">
                                                        ${fn:substring(user.fullName, 0, 1)}
                                                    </div>
                                                    <div class="user-name">${user.fullName}</div>
                                                </div>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>${user.phone}</td>
                                            <td>${user.address}</td>
                                            <td>
                                                <fmt:formatDate value="${user.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <span class="role-badge
                                                      ${user.role eq 'admin' ? 'role-admin' :
                                                        user.role eq 'owner' ? 'role-owner' :
                                                        'role-user'}">
                                                          ${user.role}
                                                      </span>
                                                </td>
                                                <td>
                                                    <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'} d-flex align-items-center">
                                                        <i class="fas ${user.active ? 'fa-check-circle' : 'fa-times-circle'} me-2"></i>
                                                        ${user.active ? 'Hoạt động' : 'Tạm khóa'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <button type="button" class="action-btn btn-edit"
                                                                data-userid="${user.userID}"
                                                                data-fullname="${fn:escapeXml(user.fullName)}"
                                                                data-email="${fn:escapeXml(user.email)}"
                                                                data-phone="${not empty user.phone ? fn:escapeXml(user.phone) : ''}"
                                                                data-address="${not empty user.address ? fn:escapeXml(user.address) : ''}"
                                                                data-dob="${not empty user.dateOfBirth ? user.dateOfBirth : ''}"
                                                                data-active="${user.active}"
                                                                onclick="handleEditClick(this)">
                                                            <i class="fas fa-edit"></i> Sửa
                                                        </button>
                                                        <form method="post" action="user-list" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng này?')">
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
            </div>


            <div id="userModal" class="modal">  
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 id="modalTitle"><i class="fas fa-user-plus"></i> Thêm người dùng mới</h3>
                        <button class="close" onclick="closeModal()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>

                    <form id="userForm" method="post" action="user-list">
                        <input type="hidden" name="action" id="modalAction" value="add">
                        <input type="hidden" name="userID" id="modalUserID">

                        <div class="form-group">
                            <label for="fullName"><i class="fas fa-user"></i> Họ tên</label>
                            <input type="text" id="fullName" name="fullName" required>
                        </div>

                        <div class="form-group">
                            <label for="email"><i class="fas fa-envelope"></i> Email</label>
                            <input type="email" id="email" name="email" required>
                        </div>

                        <div class="form-group" id="passwordContainer">
                            <label for="password"><i class="fas fa-lock"></i> Mật khẩu</label>
                            <input type="password" id="password" name="passwordHash" required>
                        </div>

                        <div class="form-group">
                            <label for="phone"><i class="fas fa-phone"></i> Số điện thoại</label>
                            <input type="text" id="phone" name="phone">
                        </div>

                        <div class="form-group">
                            <label for="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                            <input type="text" id="address" name="address">
                        </div>

                        <div class="form-group">
                            <label for="dob"><i class="fas fa-birthday-cake"></i> Ngày sinh</label>
                            <input type="date" id="dob" name="dateOfBirth">
                        </div>

                        <div class="checkbox-group">
                            <input type="checkbox" id="isActive" name="isActive" checked>
                            <label for="isActive">Tài khoản hoạt động</label>
                        </div>

                        <div class="modal-actions">
                            <button type="button" class="btn-cancel" onclick="closeModal()">
                                <i class="fas fa-times"></i> Hủy bỏ
                            </button>
                            <button type="submit" class="btn-save">
                                <i class="fas fa-save"></i> Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script>

                document.getElementById("userForm").addEventListener("submit", function (e) {
                    const action = document.getElementById("modalAction").value;
                    const fullName = document.getElementById("fullName").value.trim();
                    const email = document.getElementById("email").value.trim();
                    const password = document.getElementById("password").value;
                    const phone = document.getElementById("phone").value.trim();

                    // validate tên
                    if (fullName === "") {
                        alert("Họ tên không được để trống.");
                        e.preventDefault();
                        return;
                    }

                    // validate email
                    if (email === "") {
                        alert("Email không được để trống.");
                        e.preventDefault();
                        return;
                    }

                    // validate mật khẩu khi thêm mới hoặc nếu sửa mà người dùng nhập lại
                    if (action === "add" || (action === "update" && password.length > 0)) {
                        if (password === "") {
                            alert("Mật khẩu không được để trống.");
                            e.preventDefault();
                            return;
                        }
                        const passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/;
                        if (!passwordRegex.test(password)) {
                            alert("Mật khẩu ít nhất 8 ký tự, 1 hoa, 1 thường, 1 số.");
                            e.preventDefault();
                            return;
                        }
                    }

                    // validate số điện thoại
                    const phoneDigits = phone.replace(/\D/g, '');
                    if (!phoneDigits.startsWith("0") || phoneDigits.length < 10) {
                        alert("Số điện thoại phải bắt đầu bằng 0 và ít nhất 10 số.");
                        e.preventDefault();
                        return;
                    }
                });


                document.addEventListener('DOMContentLoaded', function () {
                    const buttons = document.querySelectorAll('.action-btn, .add-btn, .btn-save, .btn-cancel');
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


                    const rows = document.querySelectorAll('.user-row');
                    rows.forEach((row, index) => {
                        row.style.animationDelay = `${index * 0.1}s`;
                    });
                });


                function openAddModal() {
                    document.getElementById("modalAction").value = "add";
                    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-user-plus"></i> Thêm người dùng mới';
                    document.getElementById("userForm").reset();
                    const emailField = document.getElementById("email");
                    emailField.readOnly = false;
                    emailField.classList.remove("readonly-field");
                    document.getElementById("modalUserID").value = "";
                    document.getElementById("userModal").style.display = "block";
                    document.getElementById("passwordContainer").style.display = "block";
                    document.getElementById("password").required = true;
                    document.body.style.overflow = 'hidden';
                }

                function handleEditClick(button) {
                    document.getElementById("modalAction").value = "update";
                    document.getElementById("modalUserID").value = button.dataset.userid;
                    document.getElementById("fullName").value = button.dataset.fullname || "";
                    const emailField = document.getElementById("email");
                    emailField.value = button.dataset.email || "";
                    emailField.readOnly = true;
                    emailField.classList.add("readonly-field");
                    document.getElementById("phone").value = button.dataset.phone || "";
                    document.getElementById("address").value = button.dataset.address || "";
                    const dob = button.dataset.dob;
                    document.getElementById("dob").value = dob ? dob.substring(0, 10) : "";
                    const isActive = button.dataset.active === "true" || button.dataset.active === "1";
                    document.getElementById("isActive").checked = isActive;
                    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-user-edit"></i> Cập nhật người dùng';
                    document.getElementById("userModal").style.display = "block";
                    document.getElementById("passwordContainer").style.display = "block";
                    document.getElementById("password").required = false;
                    document.body.style.overflow = 'hidden';
                }

                function closeModal() {
                    document.getElementById("userModal").style.display = "none";
                    document.body.style.overflow = 'auto';
                }

                // Close modal when clicking outside
                window.onclick = function (event) {
                    const modal = document.getElementById("userModal");
                    if (event.target === modal) {
                        closeModal();
                    }
                };

                // Search functionality
                document.getElementById("searchInput")?.addEventListener("input", function () {
                    const searchTerm = this.value.toLowerCase();
                    const rows = document.querySelectorAll(".user-row");

                    rows.forEach(row => {
                        const name = row.getAttribute("data-name");
                        const email = row.getAttribute("data-email");
                        if (name.includes(searchTerm) || email.includes(searchTerm)) {
                            row.style.display = "";
                            row.classList.add('fade-in');
                        } else {
                            row.style.display = "none";
                            row.classList.remove('fade-in');
                        }
                    });
                });


                document.addEventListener('keydown', function (e) {
                    // Ctrl + N to add new user
                    if (e.ctrlKey && e.key === 'n') {
                        e.preventDefault();
                        openAddModal();
                    }
                    // Escape to close modal
                    if (e.key === 'Escape') {
                        closeModal();
                    }
                });
            </script>
        </body>
    </html>