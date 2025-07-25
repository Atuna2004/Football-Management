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
    
    <!-- External CSS Links -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- User Management CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/userManagement.css" />
</head>
<body>
    <div class="main-container">
        <%@ include file="sidebar.jsp" %>
        
        <div class="main-content">
            <!-- Header Section -->
            <div class="header fade-in">
                <h2>
                    <i class="fas fa-users"></i> 
                    Quản Lý Người Dùng
                    <!-- Display current filter -->
                    <c:if test="${not empty param.filter}">
                        <span class="filter-indicator">
                            <c:choose>
                                <c:when test="${param.filter eq 'user'}">- Người Dùng</c:when>
                                <c:when test="${param.filter eq 'owner'}">- Chủ Sân</c:when>
                                <c:otherwise>- Tất Cả</c:otherwise>
                            </c:choose>
                        </span>
                    </c:if>
                </h2>
            </div>

            <!-- Search and Add Section -->
            <div class="search-container fade-in">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên hoặc email...">
                </div>
                
                <!-- Filter Buttons -->
                <div class="filter-buttons">
                    <a href="${pageContext.request.contextPath}/admin/user-list" 
                       class="filter-btn ${empty param.filter or param.filter eq 'all' ? 'active' : ''}">
                        <i class="fas fa-users"></i> Tất Cả
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/user-list?filter=user" 
                       class="filter-btn ${param.filter eq 'user' ? 'active' : ''}">
                        <i class="fas fa-user"></i> Người Dùng
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/user-list?filter=owner" 
                       class="filter-btn ${param.filter eq 'owner' ? 'active' : ''}">
                        <i class="fas fa-user-tie"></i> Chủ Sân
                    </a>
                </div>
                
                <button class="add-btn" onclick="openAddModal()">
                    <i class="fas fa-plus"></i>
                    Thêm người dùng
                </button>
            </div>

            <!-- Users Table Card -->
            <div class="card fade-in">
                <!-- Filter userList based on URL parameter -->
                <c:choose>
                    <c:when test="${param.filter eq 'user'}">
                        <c:set var="filteredUsers" value="${[]}"/>
                        <c:forEach var="user" items="${userList}">
                            <c:if test="${user.role eq 'user'}">
                                <c:set var="filteredUsers" value="${filteredUsers}"/>
                                <%-- Add user to filtered list --%>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:when test="${param.filter eq 'owner'}">
                        <c:set var="filteredUsers" value="${[]}"/>
                        <c:forEach var="user" items="${userList}">
                            <c:if test="${user.role eq 'owner'}">
                                <c:set var="filteredUsers" value="${filteredUsers}"/>
                                <%-- Add user to filtered list --%>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <c:set var="filteredUsers" value="${userList}"/>
                    </c:otherwise>
                </c:choose>

                <!-- Check if we have users to display based on current filter -->
                <c:set var="displayUsers" value="${[]}"/>
                <c:forEach var="user" items="${userList}">
                    <c:choose>
                        <c:when test="${param.filter eq 'user' and user.role eq 'user'}">
                            <c:set var="displayUsers" value="${displayUsers}${user};"/>
                        </c:when>
                        <c:when test="${param.filter eq 'owner' and user.role eq 'owner'}">
                            <c:set var="displayUsers" value="${displayUsers}${user};"/>
                        </c:when>
                        <c:when test="${empty param.filter or param.filter eq 'all'}">
                            <c:set var="displayUsers" value="${displayUsers}${user};"/>
                        </c:when>
                    </c:choose>
                </c:forEach>

                <!-- Backend filtering is now handled by servlet, so we show all users returned -->
                <c:set var="userCount" value="${fn:length(userList)}"/>

                <c:choose>
                    <c:when test="${userCount eq 0}">
                        <div class="empty-state">
                            <i class="fas fa-users"></i>
                            <h3>
                                <c:choose>
                                    <c:when test="${param.filter eq 'user'}">Chưa có người dùng nào</c:when>
                                    <c:when test="${param.filter eq 'owner'}">Chưa có chủ sân nào</c:when>
                                    <c:otherwise>Chưa có người dùng nào</c:otherwise>
                                </c:choose>
                            </h3>
                            <p>
                                <c:choose>
                                    <c:when test="${param.filter eq 'user'}">Không có người dùng thông thường nào trong hệ thống.</c:when>
                                    <c:when test="${param.filter eq 'owner'}">Không có chủ sân nào trong hệ thống.</c:when>
                                    <c:otherwise>Hệ thống chưa có người dùng nào được đăng ký. Hãy thêm người dùng mới để bắt đầu.</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-container">
                            <table id="userTable">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag"></i> ID</th>
                                        <th><i class="fas fa-user"></i> Người dùng</th>
                                        <th><i class="fas fa-envelope"></i> Email</th>
                                        <th><i class="fas fa-phone"></i> Số điện thoại</th>
                                        <th><i class="fas fa-user-tag"></i> Vai trò</th>
                                        <th><i class="fas fa-toggle-on"></i> Trạng thái</th>
                                        <th><i class="fas fa-cogs"></i> Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${userList}" varStatus="loop">
                                        <!-- Apply filter logic - now handled by backend filtering -->
                                        <c:set var="showUser" value="true"/>

                                        <c:if test="${showUser}">
                                            <tr class="user-row fade-in"
                                                data-name="${fn:toLowerCase(user.fullName)}"
                                                data-email="${fn:toLowerCase(user.email)}"
                                                data-role="${user.role}"
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
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty user.roles}">
                                                            <c:forEach var="role" items="${user.roles}" varStatus="roleStatus">
                                                                <span class="role-badge
                                                                      ${role.roleName eq 'admin' ? 'role-admin' :
                                                                        role.roleName eq 'owner' ? 'role-owner' :
                                                                        'role-user'}">
                                                                          ${role.roleName eq 'owner' ? 'Chủ Sân' : 
                                                                            role.roleName eq 'admin' ? 'Admin' : 'Người Dùng'}
                                                                      </span>
                                                                <c:if test="${not roleStatus.last}"> </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="role-badge role-user">Người Dùng</span>
                                                        </c:otherwise>
                                                    </c:choose>
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
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- User Modal -->
            <div id="userModal" class="modal">  
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 id="modalTitle">
                            <i class="fas fa-user-plus"></i> 
                            Thêm người dùng mới
                        </h3>
                        <button class="close" onclick="closeModal()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    
                    <form id="userForm" method="post" action="user-list">
                        <input type="hidden" name="action" id="modalAction" value="add">
                        <input type="hidden" name="userID" id="modalUserID">
                        
                        <div class="form-group">
                            <label for="fullName">
                                <i class="fas fa-user"></i> 
                                Họ tên
                            </label>
                            <input type="text" id="fullName" name="fullName" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i> 
                                Email
                            </label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        
                        <div class="form-group" id="passwordContainer">
                            <label for="password">
                                <i class="fas fa-lock"></i> 
                                Mật khẩu
                            </label>
                            <input type="password" id="password" name="passwordHash" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">
                                <i class="fas fa-phone"></i> 
                                Số điện thoại
                            </label>
                            <input type="text" id="phone" name="phone">
                        </div>
                        
                        <div class="form-group">
                            <label for="address">
                                <i class="fas fa-map-marker-alt"></i> 
                                Địa chỉ
                            </label>
                            <input type="text" id="address" name="address">
                        </div>
                        
                        <div class="form-group">
                            <label for="dob">
                                <i class="fas fa-birthday-cake"></i> 
                                Ngày sinh
                            </label>
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
        </div>
    </div>

    <!-- Add CSS for filter buttons -->
    <style>
        .filter-buttons {
            display: flex;
            gap: 10px;
            margin: 0 15px;
        }

        .filter-btn {
            padding: 10px 16px;
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(59, 130, 246, 0.2);
            border-radius: 8px;
            color: #475569;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-btn:hover {
            background: rgba(59, 130, 246, 0.1);
            color: #1d4ed8;
            border-color: rgba(59, 130, 246, 0.3);
            transform: translateY(-2px);
        }

        .filter-btn.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
        }

        .filter-indicator {
            font-size: 18px;
            color: #3b82f6;
            font-weight: 500;
        }

        .search-container {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        @media (max-width: 768px) {
            .search-container {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-buttons {
                margin: 10px 0;
                justify-content: center;
            }
        }
    </style>

    <!-- JavaScript -->
    <script>
        // Form validation
        document.getElementById("userForm").addEventListener("submit", function (e) {
            const action = document.getElementById("modalAction").value;
            const fullName = document.getElementById("fullName").value.trim();
            const email = document.getElementById("email").value.trim();
            const password = document.getElementById("password").value;
            const phone = document.getElementById("phone").value.trim();

            // Validate name
            if (fullName === "") {
                alert("Họ tên không được để trống.");
                e.preventDefault();
                return;
            }

            // Validate email
            if (email === "") {
                alert("Email không được để trống.");
                e.preventDefault();
                return;
            }

            // Validate password for new users or when updating password
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

            // Validate phone number
            if (phone) {
                const phoneDigits = phone.replace(/\D/g, '');
                if (!phoneDigits.startsWith("0") || phoneDigits.length < 10) {
                    alert("Số điện thoại phải bắt đầu bằng 0 và ít nhất 10 số.");
                    e.preventDefault();
                    return;
                }
            }
        });

        // Initialize page interactions
        document.addEventListener('DOMContentLoaded', function () {
            // Update sidebar active state based on current filter
            const currentFilter = new URLSearchParams(window.location.search).get('filter');
            if (currentFilter) {
                // Dispatch event to update sidebar
                const filterEvent = new CustomEvent('userFilterChanged', {
                    detail: { filter: currentFilter }
                });
                window.dispatchEvent(filterEvent);
            }

            // Button ripple effects
            const buttons = document.querySelectorAll('.action-btn, .add-btn, .btn-save, .btn-cancel, .filter-btn');
            buttons.forEach(btn => {
                btn.style.position = 'relative';
                btn.style.overflow = 'hidden';
                btn.addEventListener('click', function (e) {
                    if (this.classList.contains('filter-btn')) return; // Skip ripple for filter buttons
                    
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

            // Staggered animation for table rows
            const rows = document.querySelectorAll('.user-row');
            rows.forEach((row, index) => {
                row.style.animationDelay = `${index * 0.1}s`;
            });
        });

        // Modal functions
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

        // Enhanced search functionality with role filtering
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

        // Keyboard shortcuts
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

        // Add dynamic CSS for ripple animation
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

        console.log('User Management page initialized successfully!');
    </script>
</body>
</html>