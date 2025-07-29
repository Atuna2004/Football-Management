<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa món ăn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container py-4">

<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:set var="open" value="true"/>
<div id="editFoodModal" class="modal show" tabindex="-1" aria-hidden="false" style="display:block;">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/edit-food" method="post" enctype="multipart/form-data" class="modal-content">
            <!-- Header -->
            <div class="modal-header">
                <h4 class="modal-title">Cập nhật món ăn</h4>
                <a class="btn-close" href="${pageContext.request.contextPath}/owner/food-items"></a>
            </div>

            <div class="modal-body">
                <input type="hidden" name="foodItemId" value="${foodItem.foodItemID}" />

                <label class="mt-2">Tên món ăn:</label>
                <input type="text" name="nameFood" class="form-control" value="${foodItem.name}" required />

                <label class="mt-2">Mô tả món ăn:</label>
                <input type="text" name="description" class="form-control" value="${foodItem.description}" />

                <label class="mt-2">Số lượng kho:</label>
                <input type="number" name="stockQuantity" class="form-control" min="0" value="${foodItem.stockQuantity}" required />

                <label class="mt-2">Giá tiền (VNĐ):</label>
                <input type="number" name="price" class="form-control" step="1000" min="0" value="${foodItem.price}" required />

                <label class="mt-2">Ảnh món ăn (chọn ảnh mới nếu muốn đổi):</label>
                <input type="file" name="imageFood" class="form-control" accept="image/*" />
                <small class="text-muted">Ảnh hiện tại:</small>
                <img src="${pageContext.request.contextPath}/${foodItem.imageUrl}" alt="current" width="70" height="70" style="object-fit:cover;border-radius:8px;" />

                <label class="mt-2">Chọn sân:</label>
                <select name="stadiumId" class="form-control" required>
                    <c:forEach var="s" items="${stadiumList}">
                        <option value="${s.stadiumID}" <c:if test="${s.stadiumID == foodItem.stadiumID}">selected</c:if>>
                            ${s.name}
                        </option>
                    </c:forEach>
                </select>

                <label class="mt-2 d-block">Trạng thái:</label>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="isActive" value="1" <c:if test="${foodItem.active}">checked</c:if> />
                    <label class="form-check-label">Còn hàng</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="isActive" value="0" <c:if test="${!foodItem.active}">checked</c:if> />
                    <label class="form-check-label">Hết hàng</label>
                </div>
            </div>

            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/owner/food-items" class="btn btn-secondary">Huỷ</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
