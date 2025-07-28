<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Món Ăn - Field Manager</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/foodItem.css">
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
        <div class="user-greeting" style="margin-right: 40px;">
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

    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Title -->
        <h1 class="page-title fade-in">
            <i class="fas fa-utensils"></i>
            Quản lý món ăn
        </h1>

        <!-- Header Section -->
        <div class="actions-row fade-in">
            <div></div>
            <!-- Search Form -->
            <form action="${pageContext.request.contextPath}/food-search" method="get" class="search-form">
                <input type="text" name="search" class="search-input" placeholder="Tìm kiếm món ăn…"
                       value="${param.search}">
                <button type="submit" class="search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </form>

            <!-- Add Button -->
            <button class="add-btn" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus"></i> Thêm món mới
            </button>
        </div>

        <!-- Food Items Grid -->
        <div class="card fade-in">
            <div class="card-body">
                <c:if test="${empty foodItems}">
                    <div class="empty-state">
                        <i class="fas fa-utensils"></i>
                        <p>Chưa có món ăn nào</p>
                        <small>Hãy thêm món ăn đầu tiên của bạn!</small>
                    </div>
                </c:if>

                <c:if test="${not empty foodItems}">
                    <div class="food-grid">
                        <c:forEach var="item" items="${foodItems}">
                            <div class="food-card" onclick="editFood(${item.foodItemID})">
                                <div class="food-image-container">
                                    <img src="${pageContext.request.contextPath}/${item.imageUrl}"
                                         alt="food" class="food-card-image">
                                </div>
                                <div class="food-card-content">
                                    <h6 class="food-card-name">${item.name}</h6>
                                    <p class="food-card-stadium">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <c:choose>
                                            <c:when test="${not empty item.stadiumName}">${item.stadiumName}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="food-card-price">
                                        <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Add Food Modal -->
        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog">
                <form action="${pageContext.request.contextPath}/add-food" method="post" enctype="multipart/form-data"
                      class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-plus me-2"></i>
                            Thêm Món Mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <!-- Name -->
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-utensils me-2" style="color: #3b82f6;"></i>
                                Tên món ăn
                            </label>
                            <input type="text" name="nameFood" class="form-control" required>
                        </div>

                        <!-- Stadium -->
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-map-marker-alt me-2" style="color: #3b82f6;"></i>
                                Sân
                            </label>
                            <select name="stadiumId" class="form-select" required>
                                <c:forEach var="s" items="${stadiums}">
                                    <option value="${s.stadiumID}">${s.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Price -->
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-money-bill me-2" style="color: #10b981;"></i>
                                Giá (VNĐ)
                            </label>
                            <input type="number" name="price" class="form-control" min="0" step="1000" required>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-align-left me-2" style="color: #64748b;"></i>
                                Mô tả
                            </label>
                            <textarea name="description" class="form-control" rows="3"></textarea>
                        </div>

                        <!-- Stock Quantity -->
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-boxes me-2" style="color: #f59e0b;"></i>
                                Số lượng
                            </label>
                            <input type="number" name="stockQuantity" class="form-control" min="0" required>
                        </div>

                        <!-- Image -->
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-image me-2" style="color: #8b5cf6;"></i>
                                Hình ảnh
                            </label>
                            <input type="file" name="imageFood" accept="image/*" class="form-control" required>
                        </div>

                        <!-- Status -->
                        <div class="mb-3">
                            <label class="form-label d-block">
                                <i class="fas fa-toggle-on me-2" style="color: #10b981;"></i>
                                Trạng thái
                            </label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="isActive" value="1" checked>
                                <label class="form-check-label">Hiển thị</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="isActive" value="0">
                                <label class="form-check-label text-danger">Ẩn</label>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Huỷ
                        </button>
                        <button type="submit" class="btn-orange">
                            <i class="fas fa-plus me-2"></i>Thêm món
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editFood(foodId) {
        window.location.href = '${pageContext.request.contextPath}/edit-food?id=' + foodId;
    }

    document.addEventListener("DOMContentLoaded", function () {
        // Add fade-in animation to food cards
        const foodCards = document.querySelectorAll('.food-card');
        foodCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
            card.classList.add('fade-in');
        });

        // Enhanced modal animations
        const modal = document.getElementById('addModal');
        if (modal) {
            modal.addEventListener('show.bs.modal', function () {
                this.querySelector('.modal-content').style.transform = 'scale(0.8)';
                setTimeout(() => {
                    this.querySelector('.modal-content').style.transition = 'transform 0.3s ease';
                    this.querySelector('.modal-content').style.transform = 'scale(1)';
                }, 50);
            });
        }
    });
</script>
</body>
</html>