<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sân bóng - Field Manager</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/stadiumList.css" rel="stylesheet">
</head>
<body>
<div class="top-header">
    <div class="container-fluid d-flex justify-content-between align-items-center" style="padding-left: 0; padding-right: 0; max-width: 100%;">
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
        <div class="user-greeting" style="margin-right: 40px">
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

<div class="dashboard-container">
    <%@ include file="FieldOwnerSB.jsp" %>

    <main class="main-content">
        <div class="container-fluid">
            <div class="header-section fade-in">
                <h1 class="page-title">
                    <i class="fas fa-building"></i>
                    Danh sách sân bóng
                </h1>

                <form id="searchForm" action="<%= request.getContextPath() %>/fieldOwner/FOSTD" method="get"
                      class="search-form">
                    <input type="text"
                           class="search-input"
                           placeholder="Tìm kiếm sân..."
                           name="search"
                           id="searchInput"
                           aria-label="Search input"
                           value="${param.search}">
                    <button class="search-btn" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </form>

                <a href="<%= request.getContextPath() %>/stadium/config?action=create" class="add-btn">
                    <i class="fas fa-plus"></i>Thêm sân mới
                </a>
            </div>

            <div class="card fade-in">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table mb-0">
                            <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Tên sân</th>
                                <th scope="col">Mô tả</th>
                                <th scope="col">Vị trí</th>
                                <th scope="col">Trạng thái</th>
                                <th scope="col">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty stadiums}">
                                    <tr>
                                        <td colspan="6" class="empty-state">
                                            <i class="fas fa-building"></i>
                                            <p>Chưa có sân bóng nào</p>
                                            <small>Hãy thêm sân bóng đầu tiên của bạn!</small>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${stadiums}" var="stadium" varStatus="index">
                                        <tr class="stadium-row" data-stadium-id="${stadium.stadiumID}">
                                            <td><strong>${(currentPage - 1) * 10 + index.index + 1}</strong></td>

                                            <td>
                                                <div class="stadium-name">${stadium.name}</div>
                                                <div class="stadium-location">
                                                    <i class="fas fa-map-marker-alt"></i>${stadium.location}
                                                </div>
                                                <c:if test="${not empty stadium.phoneNumber}">
                                                    <div class="stadium-location">
                                                        <i class="fas fa-phone"></i>${stadium.phoneNumber}
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div class="stadium-description" title="${stadium.description}">
                                                        ${stadium.description}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">${stadium.location}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${stadium.status == 'active'}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-check-circle"></i>Hoạt động
                                                                </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                                <span class="badge bg-danger">
                                                                    <i class="fas fa-times-circle"></i>Không hoạt động
                                                                </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="<%= request.getContextPath() %>/stadium/config?action=edit&id=${stadium.stadiumID}"
                                                       class="btn-action btn-primary"
                                                       onclick="event.stopPropagation();"
                                                       title="Chỉnh sửa">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <c:if test="${totalPages > 0}">
                <nav class="fade-in">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}">
                                    <i class="fas fa-chevron-left"></i> Trước
                                </a>
                            </li>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&search=${param.search}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}">
                                    Sau <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </main>
</div>

<!-- Xóa toàn bộ phần modal từ đây -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const searchInput = document.getElementById("searchInput");
        const searchForm = document.getElementById("searchForm");
        let searchTimeout;

        searchInput.addEventListener("input", function () {
            const url = new URL(window.location.href);
            url.searchParams.delete("page");
            window.history.replaceState({}, '', url);

            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                searchForm.submit();
            }, 400);
        });

        const stadiumRows = document.querySelectorAll('.stadium-row');
        stadiumRows.forEach(row => {
            row.addEventListener('click', function () {
                const stadiumId = this.getAttribute('data-stadium-id');
                window.location.href = '<%= request.getContextPath() %>/fieldOwner/StadiumFieldList?id=' + stadiumId;
            });
        });

        const actionButtons = document.querySelectorAll('.btn-action');
        actionButtons.forEach(button => {
            button.addEventListener('click', function () {
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                this.disabled = true;
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.disabled = false;
                }, 6000);
            });
        });

        const tableRows = document.querySelectorAll('tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
            row.classList.add('fade-in');
        });
    });
</script>
</body>
</html>