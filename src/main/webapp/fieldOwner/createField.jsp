<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/crudField.css">
<h3>Thêm sân nhỏ</h3>
<form method="post" action="${pageContext.request.contextPath}/field/config">
    <input type="hidden" name="action" value="create">
    <input type="hidden" name="stadiumId" value="${param.stadiumId}">

    <div class="form-group">
        <label>Tên sân</label>
        <input type="text" name="fieldName" class="form-control" required>
    </div>

    <div class="form-group">
        <label>Loại sân</label>
        <select name="type" class="form-control" required>
            <option value="5 người">5 người</option>
            <option value="7 người">7 người</option>
            <option value="11 người">11 người</option>
        </select>
    </div>

    <div class="form-group">
        <label>Mô tả</label>
        <textarea name="description" class="form-control"></textarea>
    </div>

    <div class="form-check">
        <input type="checkbox" name="isActive" class="form-check-input" checked>
        <label class="form-check-label">Hoạt động</label>
    </div>

    <button type="submit" class="btn btn-success mt-3">Lưu</button>
    <a href="${pageContext.request.contextPath}/fieldOwner/StadiumFieldList?id=${param.stadiumId}" class="btn btn-secondary mt-3">Hủy</a>
</form>
