<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sân nhỏ - Field Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/fieldList.css">
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
        <!-- Main Content -->
        <main class="main-content-full">
            <div class="container-fluid">
                <!-- Header Section -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h3><i class=""></i>Danh sách sân nhỏ - ${stadiumName}</h3>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="<%= request.getContextPath() %>/fieldOwner/createField.jsp?stadiumId=${stadiumId}" class="btn btn-success text-white">
                            <i class="fas fa-plus me-2"></i>Thêm sân mới
                        </a>
                    </div>
                </div>

                <!-- Fields Table -->
                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">Tên sân</th>
                                        <th scope="col">Loại sân</th>
                                        <th scope="col">Mô tả</th>
                                        <th scope="col">Trạng thái</th>
                                        <th scope="col">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty fields}">
                                            <tr>
                                                <td colspan="6" class="text-center py-5">
                                                    <div class="text-muted">
                                                        <i class="fas fa-futbol fa-3x mb-3"></i>
                                                        <p class="mb-0">Chưa có sân nhỏ nào</p>
                                                        <small>Hãy thêm sân nhỏ đầu tiên cho sân này!</small>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${fields}" var="field" varStatus="index">
                                                <tr class="field-row">
                                                    <td>${index.index + 1}</td>
                                                    <td>
                                                        <div class="field-name">${field.fieldName}</div>
                                                        <div class="field-type">
                                                            <i class="fas fa-tag me-1"></i>${field.type}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-primary">${field.type}</span>
                                                    </td>
                                                    <td>
                                                        <div class="field-description" title="${field.description}">
                                                            ${field.description}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${field.isActive}">
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
                                                            <a href="<%= request.getContextPath() %>/field/config?action=edit&id=${field.fieldID}" 
                                                                class="btn btn-primary btn-sm btn-action" 
                                                                onclick="event.stopPropagation();">
                                                                 <i class="fa-solid fa-pen-to-square"></i>
                                                             </a>
                                                            <button type="button" 
                                                                    class="btn btn-danger btn-sm btn-action delete-btn" 
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#deleteModal" 
                                                                    data-id="${field.fieldID}"
                                                                    data-name="${field.fieldName}"
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

                <!-- Back to Stadium List Button -->
                <div class="mt-4">
                    <a href="<%= request.getContextPath() %>/fieldOwner/FOSTD" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách sân
                    </a>
                </div>
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
                    <p>Bạn có chắc chắn muốn xóa sân nhỏ <strong id="fieldName"></strong> không?</p>
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
                        <input type="hidden" name="fieldId" id="deleteId">
                        <input type="hidden" name="stadiumId" value="${stadiumId}">
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
            // Handle field row click - navigate to field details or bookings
            const fieldRows = document.querySelectorAll('.field-row');
            fieldRows.forEach(row => {
                row.addEventListener('click', function() {
                    const fieldId = this.getAttribute('data-field-id');
                    // You can customize this URL based on your requirements
                    // For example, navigate to field bookings or field details
                    window.location.href = '<%= request.getContextPath() %>/field/bookings?id=' + fieldId;
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
            });

            // Handle delete modal
            const deleteButtons = document.querySelectorAll(".delete-btn");
            const deleteIdInput = document.getElementById("deleteId");
            const fieldNameSpan = document.getElementById("fieldName");
            const deleteForm = document.getElementById("deleteForm");

            deleteButtons.forEach(button => {
                button.addEventListener("click", function () {
                    const fieldId = this.getAttribute("data-id");
                    const fieldName = this.getAttribute("data-name");
                    
                    deleteIdInput.value = fieldId;
                    fieldNameSpan.textContent = fieldName;
                    deleteForm.action = '<%= request.getContextPath() %>/field/config';
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