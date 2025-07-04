<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm món ăn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">

<!-- ===== Thông báo ===== -->
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

<!-- ===== Modal Thêm Món ===== -->
<c:set var="open" value="${showModal eq true}" />
<div id="addFoodModal"
     class="modal ${open ? 'show' : 'fade'}"
     tabindex="-1"
     aria-labelledby="addFoodLabel"
     aria-hidden="${open ? 'false' : 'true'}"
     style="${open ? 'display:block;' : ''}">

    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/add-food"
              method="post" enctype="multipart/form-data"
              class="modal-content">

            <!-- Header -->
            <div class="modal-header">
                <h4 class="modal-title" id="addFoodLabel">Thêm món ăn</h4>
                <a class="btn-close" href="${pageContext.request.contextPath}/food-items"></a>
            </div>

            <!-- Body -->
            <div class="modal-body">
                <!-- Tên -->
                <label class="mt-2">Tên món ăn:</label>
                <input type="text" name="nameFood" class="form-control" required>

                <!-- Mô tả -->
                <label class="mt-2">Mô tả món ăn:</label>
                <input type="text" name="description" class="form-control">

                <!-- Số lượng -->
                <label class="mt-2">Số lượng kho:</label>
                <input type="number" name="stockQuantity" class="form-control" min="0" required>

                <!-- Giá -->
                <label class="mt-2">Giá tiền (VNĐ):</label>
                <input type="number" name="price" class="form-control" step="1000" min="0" required>

                <!-- Ảnh -->
                <label class="mt-2">Ảnh món ăn:</label>
                <input type="file" name="imageFood" class="form-control" accept="image/*">

                <!-- Sân -->
                <label class="mt-2">Chọn sân:</label>
                <select name="stadiumId" class="form-control" required>
                    <c:choose>
                        <c:when test="${empty stadiumList}">
                            <option disabled>– Chưa có sân –</option>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="s" items="${stadiumList}">
                                <option value="${s.stadiumID}">
                                    ${s.name} (${s.location})
                                </option>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </select>

                <!-- Trạng thái mặc định: hiển thị -->
                <input type="hidden" name="isActive" value="1">
            </div>

            <!-- Footer -->
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Thêm</button>
                <a href="${pageContext.request.contextPath}/food-items"
                   class="btn btn-secondary">Huỷ</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
