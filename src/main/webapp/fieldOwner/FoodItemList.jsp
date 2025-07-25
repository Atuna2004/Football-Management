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
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 50%, #dbeafe 100%);
            min-height: 100vh;
            color: #1e293b;
            line-height: 1.6;
        }

        /* Top Header */
        .top-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            padding: 20px 0;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            height: 80px;
            box-shadow: 0 8px 32px rgba(59, 130, 246, 0.08);
        }

        .top-header .container-fluid {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .logo h3 {
            color: #1e293b;
            font-weight: 700;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
        }

        .logo h3 a.item {
            text-decoration: none;
            color: #3b82f6;
            transition: all 0.3s ease;
        }

        .logo h3 a.item:hover {
            transform: scale(1.1);
            text-decoration: none;
        }

        .user-greeting {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 12px 20px;
            border-radius: 12px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        /* Dashboard Container */
        .dashboard-container {
            display: flex;
            min-height: calc(100vh - 80px);
        }

        /* Main Content */
        .main-content {
            margin-left: 300px;
            padding: 40px;
            width: calc(100% - 300px);
            margin-top: 80px;
        }

        /* Header Section */
        .header-section {
            margin-bottom: 40px;
        }

        .page-title {
            color: #1e293b;
            font-weight: 700;
            font-size: 32px;
            margin-bottom: 32px;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-title i {
            color: #3b82f6;
        }

        .actions-row {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: 20px;
            align-items: center;
            margin-bottom: 32px;
        }

        /* Search Form */
        .search-form {
            display: flex;
            gap: 0;
            max-width: 400px;
        }

        .search-input {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(59, 130, 246, 0.1);
            border-right: none;
            border-radius: 12px 0 0 12px;
            padding: 12px 16px;
            font-weight: 500;
            color: #1e293b;
            transition: all 0.3s ease;
            width: 100%;
            font-family: 'Inter', sans-serif;
        }

        .search-input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            outline: none;
        }

        .search-btn {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border: 2px solid #3b82f6;
            border-left: none;
            border-radius: 0 12px 12px 0;
            padding: 12px 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.25);
        }

        /* Add Button */
        .add-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-family: 'Inter', sans-serif;
            white-space: nowrap;
        }

        .add-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(16, 185, 129, 0.25);
        }

        /* Card Styles */
        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(59, 130, 246, 0.08);
            border: 1px solid rgba(59, 130, 246, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.12);
        }

        .card-body {
            padding: 0;
        }

        /* Food Grid Layout */
        .food-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            padding: 8px;
        }

        .food-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 16px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(59, 130, 246, 0.1);
            box-shadow: 0 4px 16px rgba(59, 130, 246, 0.08);
        }

        .food-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(59, 130, 246, 0.15);
            border-color: rgba(59, 130, 246, 0.2);
        }

        .food-image-container {
            width: 100%;
            height: 160px;
            margin-bottom: 16px;
            border-radius: 12px;
            overflow: hidden;
        }

        .food-card-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .food-card-content {
            text-align: left;
        }

        .food-card-name {
            font-weight: 600;
            color: #1e293b;
            font-size: 18px;
            margin-bottom: 8px;
        }

        .food-card-stadium {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .food-card-stadium i {
            color: #3b82f6;
            font-size: 12px;
        }

        .food-card-price {
            font-weight: 700;
            color: #059669;
            font-size: 18px;
        }

        /* Status Badges */
        .status-badge {
            padding: 8px 16px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-available {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
        }

        .status-out {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }

        /* Action Buttons */
        .btn-group {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.25);
            color: white;
            text-decoration: none;
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .btn-danger:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
            color: white;
            text-decoration: none;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
        }

        .empty-state i {
            font-size: 64px;
            color: #cbd5e1;
            margin-bottom: 24px;
        }

        .empty-state p {
            color: #64748b;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .empty-state small {
            color: #94a3b8;
            font-size: 14px;
        }

        /* Modal Styles */
        .modal-content {
            border-radius: 24px;
            border: none;
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.15);
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 24px 32px;
            border: none;
        }

        .modal-title {
            font-weight: 700;
            font-size: 20px;
        }

        .btn-close {
            filter: invert(1);
            opacity: 0.8;
        }

        .btn-close:hover {
            opacity: 1;
        }

        .modal-body {
            padding: 32px;
        }

        .modal-footer {
            padding: 24px 32px;
            border: none;
            background: rgba(59, 130, 246, 0.02);
        }

        /* Form Styles */
        .form-label {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .form-control,
        .form-select {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(59, 130, 246, 0.1);
            border-radius: 12px;
            padding: 12px 16px;
            font-weight: 500;
            color: #1e293b;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            outline: none;
        }

        .form-check-input {
            width: 1.2em;
            height: 1.2em;
        }

        .form-check-input:checked {
            background-color: #3b82f6;
            border-color: #3b82f6;
        }

        .form-check-label {
            font-weight: 500;
            margin-left: 8px;
        }

        /* Button Styles */
        .btn-secondary {
            background: #64748b;
            color: white;
            border: none;
            border-radius: 12px;
            padding: 10px 20px;
            font-weight: 500;
        }

        .btn-secondary:hover {
            background: #475569;
            color: white;
        }

        .btn-orange {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-orange:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.25);
            color: white;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 24px;
            }

            .actions-row {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .search-form {
                max-width: 100%;
            }

            .page-title {
                font-size: 28px;
            }

            .food-grid {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                gap: 16px;
            }

            .food-card {
                padding: 16px;
            }

            .food-image-container {
                height: 140px;
            }

            .top-header .container-fluid {
                padding: 0 24px;
                flex-direction: column;
                gap: 16px;
                align-items: flex-start !important;
            }

            .modal-body,
            .modal-header,
            .modal-footer {
                padding: 20px;
            }
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeInUp 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Utility Classes */
        .d-flex { display: flex; }
        .justify-content-between { justify-content: space-between; }
        .align-items-center { align-items: center; }
        .me-2 { margin-right: 0.5rem; }
        .mb-3 { margin-bottom: 1rem; }
        .mb-0 { margin-bottom: 0; }
        .p-0 { padding: 0; }
        .text-center { text-align: center; }
        .text-end { text-align: end; }
        .text-muted { color: #64748b; }
        .text-danger { color: #dc2626; }
        .py-5 { padding: 3rem 0; }
        .btn-sm { padding: 6px 10px; font-size: 12px; }
    </style>
</head>
<body>
    <div class="top-header">
        <div class="container-fluid">
            <div class="logo">
                <h3>
                    <a class="item" href="<%= request.getContextPath() %>/home.jsp">
                        <i class="fas fa-futbol"></i>
                    </a>
                    Field Manager
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
                    <input type="text" name="search" class="search-input" placeholder="Tìm kiếm món ăn…" value="${param.search}">
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
                    <form action="${pageContext.request.contextPath}/add-food" method="post" enctype="multipart/form-data" class="modal-content">
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