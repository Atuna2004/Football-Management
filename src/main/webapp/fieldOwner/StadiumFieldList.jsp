<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sân nhỏ - Field Manager</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/stadiumList.css" rel="stylesheet">
</head>
<body>
<div class="dashboard-container">
    <main class="main-content" style="margin-left: 0; margin-top: 0; width: 100%;">
        <div class="container-fluid">
            <div class="header-section fade-in"
                 style="display: flex; justify-content: space-between; align-items: center;">
                <h1 class="page-title">
                    <i class="fas fa-football-ball"></i>
                    Danh sách sân nhỏ - <span class="text-primary">${stadiumName}</span>
                </h1>

                <a href="<%= request.getContextPath() %>/fieldOwner/createField.jsp?stadiumId=${stadiumId}"
                   class="add-btn">
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
                                        <td colspan="6" class="empty-state">
                                            <i class="fas fa-futbol"></i>
                                            <p>Chưa có sân nhỏ nào</p>
                                            <small>Hãy thêm sân nhỏ đầu tiên cho sân này!</small>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${fields}" var="field" varStatus="index">
                                        <tr class="field-row">
                                            <td><strong>${index.index + 1}</strong></td>
                                            <td>
                                                <div class="stadium-name">${field.fieldName}</div>
                                                <div class="stadium-location">
                                                    <i class="fas fa-tag"></i>${field.type}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">${field.type}</span>
                                            </td>
                                            <td>
                                                <div class="stadium-description" title="${field.description}">
                                                        ${field.description}
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${field.isActive}">
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
                                                    <a href="<%= request.getContextPath() %>/field/config?action=edit&id=${field.fieldID}"
                                                       class="btn-action btn-primary"
                                                       onclick="event.stopPropagation();">
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

            <div class="mt-4">
                <a href="<%= request.getContextPath() %>/fieldOwner/FOSTD"
                   class="btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách sân
                </a>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script>


    const actionButtons = document.querySelectorAll('.btn-action');
    actionButtons.forEach(button => {
        button.addEventListener('click', function () {
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
            this.disabled = true;

            setTimeout(() => {
                this.innerHTML = originalText;
                this.disabled = false;
            }, 3000);
        });


        let searchTimeout;
        const searchInput = document.querySelector('input[name="search"]');
        if (searchInput) {
            searchInput.addEventListener('input', function () {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                }, 500);
            });
        }
    });


</script>
</body>
</html>