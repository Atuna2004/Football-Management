<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Món Ăn</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stadiumList.css">
        <style>
            .status-available {
                background:#d4edda;
                color:#155724;
                padding:5px 10px;
                border-radius:20px
            }
            .status-out       {
                background:#f8d7da;
                color:#721c24;
                padding:5px 10px;
                border-radius:20px
            }
            .btn-orange       {
                background:#ff6600;
                color:#fff
            }
            .btn-orange:hover {
                background:#e65c00;
                color:#fff
            }
        </style>
    </head>
    <body>
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
            <%@ include file="FieldOwnerSB.jsp" %>

            <!-- ==================== MAIN ==================== -->
            <main class="main-content">
                <div class="container-fluid">
                    <!-- Header Section -->
                    <div class="row row-cols-1 row-cols-md-3 mb-4">
                        <!-- Tiêu đề -->
                        <div class="col mt-3">
                            <h3><i class="fas fa-utensils me-2"></i>Danh sách món ăn</h3>
                        </div>

                        <!-- Ô tìm kiếm -->
                        <div class="col mt-3">
                            <form action="${pageContext.request.contextPath}/food-search" method="get" class="input-group">
                                <input type="text" name="search" class="form-control" placeholder="Tìm kiếm món ăn…" value="${param.search}">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-search"></i>
                                </button>
                            </form>
                        </div>

                        <!-- Nút thêm mới -->
                        <div class="col mt-3 text-end">
                            <button class="btn btn-success text-white" data-bs-toggle="modal" data-bs-target="#addModal">
                                <i class="fas fa-plus me-2"></i> Thêm món mới
                            </button>
                        </div>
                    </div>


                    <!-- FoodItem Table -->
                    <div class="card">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-dark">
                                        <tr>    
                                            <th style="width:100px">Hình ảnh</th>
                                            <th>Tên món</th>
                                            <th>Sân</th>
                                            <th>Giá</th>
                                            <th>Trạng thái</th>
                                            <th style="width:120px">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${empty foodItems}">
                                            <tr>
                                                <td colspan="7" class="text-center py-5">
                                                    <div class="text-muted">
                                                        <i class="fas fa-building fa-3x mb-3"></i>
                                                        <p class="mb-0">Chưa có món ăn nào</p>
                                                        <small>Hãy thêm món ăn đầu tiên của bạn!</small>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>

                                        <c:forEach var="item" items="${foodItems}">
                                            <tr>
                                                <td>
                                                    <img src="${pageContext.request.contextPath}/${item.imageUrl}"
                                                         alt="food" width="100" height="80"
                                                         style="object-fit:cover;border-radius:10px">
                                                </td>
                                                <td>${item.name}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty item.stadiumName}">${item.stadiumName}</c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> VNĐ</td>
                                                <td>
                                                    <span class="${item.active ? 'status-available' : 'status-out'}">
                                                        ${item.active ? 'Còn hàng' : 'Hết hàng'}
                                                    </span>
                                                </td>
                                                <td>    
                                                    <div class="btn-group" role="group">
                                                        <!-- SỬA -->
                                                        <a href="${pageContext.request.contextPath}/edit-food?id=${item.foodItemID}"
                                                           class="btn btn-primary btn-sm btn-action" 
                                                           onclick="event.stopPropagation();">
                                                            <i class="fa-solid fa-pen-to-square"></i>
                                                        </a>

                                                        <!-- XÓA ẨN/HIỆN -->
                                                        <c:choose>
                                                            <c:when test="${item.active}">
                                                                <a href="${pageContext.request.contextPath}/delete-food?id=${item.foodItemID}&active=false"
                                                                   class="btn btn-danger btn-sm btn-action delete-btn" title="Ẩn"
                                                                   onclick="return confirm('Xóa món này?');">
                                                                    <i class="fa-solid fa-trash-can"></i>
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/delete-food?id=${item.foodItemID}&active=true"
                                                                   class="btn btn-danger btn-sm btn-action delete-btn" title="Hiển thị">
                                                                    <i class="fa-solid fa-trash-can"></i>
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div> 
                                                </td>
                                            </tr>
                                        </c:forEach>
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


                <!-- =================== MODAL ADD =================== -->
                <div class="modal fade" id="addModal" tabindex="-1">
                    <div class="modal-dialog">
                        <form action="${pageContext.request.contextPath}/add-food" method="post" enctype="multipart/form-data" class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Thêm Món Mới</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>

                            <div class="modal-body">
                                <!-- Tên -->
                                <div class="mb-3">
                                    <label class="form-label">Tên món ăn</label>
                                    <input type="text" name="nameFood" class="form-control" required>
                                </div>

                                <!-- Sân -->
                                <div class="mb-3">
                                    <label class="form-label">Sân</label>
                                    <select name="stadiumId" class="form-select" required>
                                        <c:forEach var="s" items="${stadiumList}">
                                            <option value="${s.stadiumID}">${s.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Giá -->
                                <div class="mb-3">
                                    <label class="form-label">Giá (VNĐ)</label>
                                    <input type="number" name="price" class="form-control" min="0" step="1000" required>
                                </div>

                                <!-- Mô tả -->
                                <div class="mb-3">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="description" class="form-control" rows="2"></textarea>
                                </div>

                                <!-- Số lượng -->
                                <div class="mb-3">
                                    <label class="form-label">Số lượng</label>
                                    <input type="number" name="stockQuantity" class="form-control" min="0" required>
                                </div>

                                <!-- Ảnh -->
                                <div class="mb-3">
                                    <label class="form-label">Hình ảnh</label>
                                    <input type="file" name="imageFood" accept="image/*" class="form-control" required>
                                </div>

                                <!-- Trạng thái -->
                                <div class="mb-3">
                                    <label class="form-label d-block">Trạng thái</label>
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
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                                <button type="submit" class="btn btn-orange">Thêm món</button>
                            </div>
                        </form>
                    </div>
                </div>



            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
