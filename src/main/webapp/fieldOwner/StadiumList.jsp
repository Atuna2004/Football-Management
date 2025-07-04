<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sân bóng - Field Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stadiumList.css">
    
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <div class="logo">
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
                <div class="user-greeting">
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
        <!-- Left Navigation Sidebar -->
        <%@ include file="FieldOwnerSB.jsp" %>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container-fluid">
                <!-- Header Section -->
                <div class="row row-cols-1 row-cols-md-3 mb-4">
                    <div class="col mt-3">
                        <h3><i class="fas fa-building me-2"></i>Danh sách sân bóng</h3>
                    </div>
                    <div class="col mt-3">
                        <form action="<%= request.getContextPath() %>/stadium" method="get">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Tìm kiếm sân..." 
                                       name="search" aria-label="Search input" value="${param.search}">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                    <div class="col mt-3 text-end">
                        <a href="<%= request.getContextPath() %>/stadium/config?action=create" class="btn btn-success text-white">
                            <i class="fas fa-plus me-2"></i>Thêm sân mới
                        </a>
                    </div>
                </div>

                <!-- Stadium Table -->
                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
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
                                                <td colspan="7" class="text-center py-5">
                                                    <div class="text-muted">
                                                        <i class="fas fa-building fa-3x mb-3"></i>
                                                        <p class="mb-0">Chưa có sân bóng nào</p>
                                                        <small>Hãy thêm sân bóng đầu tiên của bạn!</small>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${stadiums}" var="stadium" varStatus="index">
                                                <tr class="stadium-row" data-stadium-id="${stadium.stadiumID}">
                                                    <td>${(currentPage - 1) * 10 + index.index + 1}</td>
                                                    
                                                    <td>
                                                        <div class="stadium-name">${stadium.name}</div>
                                                        <div class="stadium-location">
                                                            <i class="fas fa-map-marker-alt me-1"></i>${stadium.location}
                                                        </div>
                                                        <c:if test="${not empty stadium.phoneNumber}">
                                                            <div class="stadium-location">
                                                                <i class="fas fa-phone me-1"></i>${stadium.phoneNumber}
                                                            </div>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <div class="stadium-description" title="${stadium.description}">
                                                            ${stadium.description}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info text-dark">${stadium.location}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${stadium.status == 'active'}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-check-circle me-1"></i>Hoạt động
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">
                                                                    <i class="fas fa-times-circle me-1"></i>Không hoạt động
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="<%= request.getContextPath() %>/stadium/config?action=edit&id=${stadium.stadiumID}" 
                                                                class="btn btn-primary btn-sm btn-action" 
                                                                onclick="event.stopPropagation();">
                                                                 <i class="fa-solid fa-pen-to-square"></i>
                                                             </a>
                                                            <button type="button" 
                                                                    class="btn btn-danger btn-sm btn-action delete-btn" 
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#deleteModal" 
                                                                    data-id="${stadium.stadiumID}"
                                                                    data-name="${stadium.name}"
                                                                    onclick="event.stopPropagation();">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </button>
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

                <!-- Pagination -->
                <c:if test="${totalPages > 0}">
                    <nav class="mt-4">
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

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle text-warning me-2"></i>Xác nhận xóa
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa sân bóng <strong id="stadiumName"></strong> không?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Việc xóa sân sẽ ảnh hưởng đến tất cả các booking liên quan!
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="stadiumId" id="deleteId">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-2"></i>Xóa
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Handle stadium row click - navigate to stadium details
            const stadiumRows = document.querySelectorAll('.stadium-row');
            stadiumRows.forEach(row => {
                row.addEventListener('click', function() {
                    const stadiumId = this.getAttribute('data-stadium-id');
                    window.location.href = '<%= request.getContextPath() %>/fieldOwner/StadiumFieldList?id=' + stadiumId;
                });
            });

            // Handle delete modal
            const deleteButtons = document.querySelectorAll(".delete-btn");
            const deleteIdInput = document.getElementById("deleteId");
            const stadiumNameSpan = document.getElementById("stadiumName");
            const deleteForm = document.getElementById("deleteForm");

            deleteButtons.forEach(button => {
                button.addEventListener("click", function () {
                    const stadiumId = this.getAttribute("data-id");
                    const stadiumName = this.getAttribute("data-name");
                    
                    deleteIdInput.value = stadiumId;
                    stadiumNameSpan.textContent = stadiumName;
                    deleteForm.action = '<%= request.getContextPath() %>/stadium/config';
                });
            });

            // Add loading state for buttons
            const actionButtons = document.querySelectorAll('.btn-action');
            actionButtons.forEach(button => {
                button.addEventListener('click', function() {
                    if (!this.classList.contains('delete-btn')) {
                        const originalText = this.innerHTML;
                        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                        this.disabled = true;
                        
                        // Re-enable after 3 seconds as fallback
                        setTimeout(() => {
                            this.innerHTML = originalText;
                            this.disabled = false;
                        }, 3000);
                    }
                });
            });
        });

        // Add search functionality with debounce
        let searchTimeout;
        const searchInput = document.querySelector('input[name="search"]');
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    // Auto-submit search after 500ms of no typing
                    // this.form.submit();
                }, 500);
            });
        }
    </script>
</body>
</html>