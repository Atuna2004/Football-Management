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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/userManagement.css"/>
</head>
<body>
<div class="main-container">
    <%@ include file="sidebar.jsp" %>

    <div class="main-content">
        <div class="header fade-in">
            <h2>
                <i class="fas fa-users"></i>
                Quản Lý Người Dùng
                <c:if test="${not empty currentFilter}">
                        <span class="filter-indicator">
                            <c:choose>
                                <c:when test="${currentFilter eq 'user'}">- Người Dùng</c:when>
                                <c:when test="${currentFilter eq 'owner'}">- Chủ Sân</c:when>
                                <c:when test="${currentFilter eq 'admin'}">- Quản Trị Viên</c:when>
                                <c:otherwise>- Tất Cả</c:otherwise>
                            </c:choose>
                        </span>
                </c:if>
            </h2>
        </div>

        <div class="search-container fade-in">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên hoặc email...">
            </div>

            <div class="filter-buttons">
                <a href="${pageContext.request.contextPath}/admin/user-list"
                   class="filter-btn ${empty currentFilter ? 'active' : ''}">
                    <i class="fas fa-users"></i> Tất Cả
                </a>
                <a href="${pageContext.request.contextPath}/admin/user-list?filter=user"
                   class="filter-btn ${currentFilter eq 'user' ? 'active' : ''}">
                    <i class="fas fa-user"></i> Người Dùng
                </a>
                <a href="${pageContext.request.contextPath}/admin/user-list?filter=owner"
                   class="filter-btn ${currentFilter eq 'owner' ? 'active' : ''}">
                    <i class="fas fa-user-tie"></i> Chủ Sân
                </a>
                <a href="${pageContext.request.contextPath}/admin/user-list?filter=admin"
                   class="filter-btn ${currentFilter eq 'admin' ? 'active' : ''}">
                    <i class="fas fa-user-shield"></i> Admin
                </a>
            </div>

            <button class="add-btn" onclick="openAddModal()">
                <i class="fas fa-plus"></i>
                Thêm người dùng
            </button>
        </div>

        <div class="card fade-in">
            <c:choose>
                <c:when test="${totalRecords eq 0}">
                    <div class="empty-state">
                        <i class="fas fa-users"></i>
                        <h3>
                            <c:choose>
                                <c:when test="${currentFilter eq 'user'}">Chưa có người dùng nào</c:when>
                                <c:when test="${currentFilter eq 'owner'}">Chưa có chủ sân nào</c:when>
                                <c:when test="${currentFilter eq 'admin'}">Chưa có quản trị viên nào</c:when>
                                <c:otherwise>Chưa có người dùng nào</c:otherwise>
                            </c:choose>
                        </h3>
                        <p>
                            <c:choose>
                                <c:when test="${currentFilter eq 'user'}">Không có người dùng thông thường nào trong hệ thống.</c:when>
                                <c:when test="${currentFilter eq 'owner'}">Không có chủ sân nào trong hệ thống.</c:when>
                                <c:when test="${currentFilter eq 'admin'}">Không có quản trị viên nào trong hệ thống.</c:when>
                                <c:otherwise>Hệ thống chưa có người dùng nào được đăng ký. Hãy thêm người dùng mới để bắt đầu.</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="pagination-info">
                            <span class="text-muted">
                                Hiển thị ${startRecord} đến ${endRecord} của ${totalRecords} bản ghi
                                <c:if test="${not empty currentFilter}">
                                    <span class="filter-tag">
                                        <c:choose>
                                            <c:when test="${currentFilter eq 'user'}">- Người Dùng</c:when>
                                            <c:when test="${currentFilter eq 'owner'}">- Chủ Sân</c:when>
                                            <c:when test="${currentFilter eq 'admin'}">- Admin</c:when>
                                        </c:choose>
                                    </span>
                                </c:if>
                            </span>
                    </div>

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
                                <tr class="user-row fade-in"
                                    data-name="${fn:toLowerCase(user.fullName)}"
                                    data-email="${fn:toLowerCase(user.email)}"
                                    style="animation-delay: ${loop.index * 0.1}s">
                                    <td><strong>#${user.userID}</strong></td>
                                    <td>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty user.avatarUrl}">
                                                        <img src="${user.avatarUrl}" alt="${user.fullName}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:substring(user.fullName, 0, 1)}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="user-name">${user.fullName}</div>
                                        </div>
                                    </td>
                                    <td>${user.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty user.phone}">
                                                ${user.phone}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa có</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty user.roles}">
                                                <c:forEach var="role" items="${user.roles}" varStatus="roleStatus">
                                                            <span class="role-badge
                                                                  ${fn:toLowerCase(role.roleName) eq 'admin' ? 'role-admin' :
                                                                    fn:toLowerCase(role.roleName) eq 'owner' ? 'role-owner' :
                                                                    'role-user'}">
                                                                      <c:choose>
                                                                          <c:when test="${fn:toLowerCase(role.roleName) eq 'owner'}">Chủ Sân</c:when>
                                                                          <c:when test="${fn:toLowerCase(role.roleName) eq 'admin'}">Admin</c:when>
                                                                          <c:otherwise>Người Dùng</c:otherwise>
                                                                      </c:choose>
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
                                            <form method="post" action="user-list" style="display:inline;"
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng này?')">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${user.userID}">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <c:if test="${not empty currentFilter}">
                                                    <input type="hidden" name="filter" value="${currentFilter}">
                                                </c:if>
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

                    <div class="pagination-container">

                        <nav aria-label="User list pagination" class="pagination-nav">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="user-list?page=1${not empty currentFilter ? '&filter='.concat(currentFilter) : ''}"
                                           title="Trang đầu">
                                            <i class="fas fa-angle-double-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <c:if test="${hasPrevious}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="user-list?page=${currentPage - 1}${not empty currentFilter ? '&filter='.concat(currentFilter) : ''}"
                                           title="Trang trước">
                                            <i class="fas fa-angle-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                        <c:choose>
                                            <c:when test="${pageNum == currentPage}">
                                                <span class="page-link current">${pageNum}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link"
                                                   href="user-list?page=${pageNum}${not empty currentFilter ? '&filter='.concat(currentFilter) : ''}"
                                                   title="Trang ${pageNum}">
                                                        ${pageNum}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:forEach>

                                <c:if test="${hasNext}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="user-list?page=${currentPage + 1}${not empty currentFilter ? '&filter='.concat(currentFilter) : ''}"
                                           title="Trang sau">
                                            <i class="fas fa-angle-right"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="user-list?page=${totalPages}${not empty currentFilter ? '&filter='.concat(currentFilter) : ''}"
                                           title="Trang cuối">
                                            <i class="fas fa-angle-double-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>

                        <c:if test="${totalPages > 10}">
                            <div class="quick-jump">
                                <span>Đến trang:</span>
                                <input type="number" id="jumpToPage" min="1" max="${totalPages}" value="${currentPage}"
                                       class="page-jump-input">
                                <button onclick="jumpToPage()" class="btn-jump">Đi</button>
                            </div>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="userModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modalTitle"><i class="fas fa-user-plus"></i> Thêm người dùng mới</h3>
                    <button class="close" onclick="closeModal()"><i class="fas fa-times"></i></button>
                </div>

                <form id="userForm" method="post" action="user-list">
                    <input type="hidden" name="action" id="modalAction" value="add">
                    <input type="hidden" name="userID" id="modalUserID">
                    <input type="hidden" name="page" value="${currentPage}">
                    <c:if test="${not empty currentFilter}">
                        <input type="hidden" name="filter" value="${currentFilter}">
                    </c:if>

                    <div class="modal-actions">
                        <button type="button" class="btn-cancel" onclick="closeModal()"><i class="fas fa-times"></i> Hủy
                            bỏ
                        </button>
                        <button type="submit" class="btn-save"><i class="fas fa-save"></i> Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<script>

    document.getElementById("userForm").addEventListener("submit", function (e) {
        const action = document.getElementById("modalAction").value;
        const fullName = document.getElementById("fullName").value.trim();
        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value;
        const phone = document.getElementById("phone").value.trim();


        if (fullName === "") {
            alert("Họ tên không được để trống.");
            e.preventDefault();
            return;
        }


        if (email === "") {
            alert("Email không được để trống.");
            e.preventDefault();
            return;
        }


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


        if (phone) {
            const phoneDigits = phone.replace(/\D/g, '');
            if (!phoneDigits.startsWith("0") || phoneDigits.length < 10) {
                alert("Số điện thoại phải bắt đầu bằng 0 và ít nhất 10 số.");
                e.preventDefault();
                return;
            }
        }
    });

    function jumpToPage() {
        const pageInput = document.getElementById('jumpToPage');
        const pageNum = parseInt(pageInput.value);
        const maxPages = ${totalPages};

        if (pageNum >= 1 && pageNum <= maxPages) {
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('page', pageNum);
            currentUrl.searchParams.delete('size');
            window.location.href = currentUrl.toString();
        } else {
            alert('Vui lòng nhập số trang hợp lệ (1-' + maxPages + ')');
            pageInput.value = ${currentPage};
        }
    }


    document.getElementById('jumpToPage')?.addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            jumpToPage();
        }
    });


    document.addEventListener('DOMContentLoaded', function () {

        const currentFilter = '${currentFilter}' || '';
        if (currentFilter) {

            const filterEvent = new CustomEvent('userFilterChanged', {
                detail: {filter: currentFilter}
            });
            window.dispatchEvent(filterEvent);
        }


        const buttons = document.querySelectorAll('.action-btn, .add-btn, .btn-save, .btn-cancel, .btn-jump');
        buttons.forEach(btn => {
            btn.style.position = 'relative';
            btn.style.overflow = 'hidden';
            btn.addEventListener('click', function (e) {
                if (this.classList.contains('filter-btn')) return;

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


        const paginationLinks = document.querySelectorAll('.page-link');
        paginationLinks.forEach(link => {
            link.addEventListener('click', function () {
                if (!this.classList.contains('current')) {
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                }
            });
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


    window.onclick = function (event) {
        const modal = document.getElementById("userModal");
        if (event.target === modal) {
            closeModal();
        }
    };


    document.getElementById("searchInput")?.addEventListener("input", function () {
        const searchTerm = this.value.toLowerCase();
        const rows = document.querySelectorAll(".user-row");
        let visibleCount = 0;

        rows.forEach(row => {
            const name = row.getAttribute("data-name");
            const email = row.getAttribute("data-email");

            if (name.includes(searchTerm) || email.includes(searchTerm)) {
                row.style.display = "";
                row.classList.add('fade-in');
                visibleCount++;
            } else {
                row.style.display = "none";
                row.classList.remove('fade-in');
            }
        });


        const tableBody = document.querySelector('#userTable tbody');
        let noResultsRow = document.getElementById('noSearchResults');

        if (visibleCount === 0 && searchTerm !== '') {
            if (!noResultsRow) {
                noResultsRow = document.createElement('tr');
                noResultsRow.id = 'noSearchResults';
                noResultsRow.innerHTML = `
                        <td colspan="7" style="text-align: center; padding: 40px; color: #64748b;">
                            <i class="fas fa-search" style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
                            Không tìm thấy kết quả phù hợp trên trang này.<br>
                            <small>Thử tìm kiếm trên các trang khác hoặc thay đổi từ khóa.</small>
                        </td>
                    `;
                tableBody.appendChild(noResultsRow);
            }
        } else if (noResultsRow) {
            noResultsRow.remove();
        }
    });


    document.addEventListener('keydown', function (e) {

        if (e.ctrlKey && e.key === 'n') {
            e.preventDefault();
            openAddModal();
        }

        if (e.key === 'Escape') {
            closeModal();
        }

        if (e.ctrlKey && e.key === 'ArrowLeft' && ${hasPrevious}) {
            window.location.href = 'user-list?page=${currentPage - 1}${not empty currentFilter ? "&filter=".concat(currentFilter) : ""}';
        }
        if (e.ctrlKey && e.key === 'ArrowRight' && ${hasNext}) {
            window.location.href = 'user-list?page=${currentPage + 1}${not empty currentFilter ? "&filter=".concat(currentFilter) : ""}';
        }
    });


    const style = document.createElement('style');
    style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(2);
                    opacity: 0;
                }
            }
            
            .readonly-field {
                background-color: #f8fafc !important;
                cursor: not-allowed;
            }
            
            .fade-in {
                animation: fadeIn 0.5s ease-in-out;
            }
            
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }
        `;
    document.head.appendChild(style);


    const showPaginationHelp = () => {
        console.log('%c⌨️ Pagination Shortcuts:', 'font-weight: bold; color: #3b82f6;');
        console.log('Ctrl + ← : Previous page');
        console.log('Ctrl + → : Next page');
        console.log('Ctrl + N : Add new user');
        console.log('ESC     : Close modal');
    };


    setTimeout(showPaginationHelp, 1000);

    console.log('User Management with Pagination initialized successfully!');
    console.log('Current page: ${currentPage}/${totalPages} | Records: ${totalRecords} | Per page: ${recordsPerPage}');
</script>
</body>
</html>
