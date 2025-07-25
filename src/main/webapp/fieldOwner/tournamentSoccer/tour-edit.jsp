<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa giải đấu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container py-4">

<!-- ===== Thông báo (nếu có) ===== -->
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

<!-- ===== Modal sửa giải đấu ===== -->
<div class="modal show" tabindex="-1" aria-hidden="false" style="display:block;">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/edit-tournament" method="post" class="modal-content">
            <!-- Header -->
            <div class="modal-header">
                <h4 class="modal-title">Cập nhật giải đấu</h4>
                <a class="btn-close" href="${pageContext.request.contextPath}/tournament"></a>
            </div>

            <!-- Body -->
            <div class="modal-body">
                <input type="hidden" name="tournamentId" value="${tournament.tournamentID}" />

                <!-- Tên giải -->
                <div class="mb-3">
                    <label class="form-label">Tên giải đấu</label>
                    <input type="text" name="nameTournament" class="form-control" value="${tournament.name}" required />
                </div>

                <!-- Mô tả -->
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <input type="text" name="description" class="form-control" value="${tournament.description}" />
                </div>

                <!-- Ngày bắt đầu -->
                <div class="mb-3">
                    <label class="form-label">Ngày bắt đầu</label>
                    <input type="date" name="startDate" class="form-control" value="${tournament.startDate}" required />
                </div>

                <!-- Ngày kết thúc -->
                <div class="mb-3">
                    <label class="form-label">Ngày kết thúc</label>
                    <input type="date" name="endDate" class="form-control" value="${tournament.endDate}" required />
                </div>

                <!-- Sân -->
                <div class="mb-3">
                    <label class="form-label">Chọn sân</label>
                    <select name="stadiumId" class="form-select" required>
                        <c:forEach var="s" items="${stadiumList}">
                            <option value="${s.stadiumID}" <c:if test="${s.stadiumID == tournament.stadiumID}">selected</c:if>>
                                ${s.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- Footer -->
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/tournament" class="btn btn-secondary">Huỷ</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
