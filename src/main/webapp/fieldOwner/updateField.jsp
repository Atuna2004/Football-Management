<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/crudField.css">
<h3>Sửa thông tin sân nhỏ</h3>
<form method="post" action="${pageContext.request.contextPath}/field/config">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="fieldId" value="${field.fieldID}">
    <input type="hidden" name="stadiumId" value="${field.stadiumID}">

    <div class="form-group">
        <label>Tên sân</label>
        <input type="text" name="fieldName" class="form-control" value="${field.fieldName}" required>
    </div>

    <div class="form-group">
        <label>Loại sân</label>
        <select name="type" class="form-control" required>
            <option value="5 người" ${field.type == '5 người' ? 'selected' : ''}>5 người</option>
            <option value="7 người" ${field.type == '7 người' ? 'selected' : ''}>7 người</option>
            <option value="11 người" ${field.type == '11 người' ? 'selected' : ''}>11 người</option>
        </select>
    </div>

    <div class="form-group">
        <label>Mô tả</label>
        <textarea name="description" class="form-control">${field.description}</textarea>
    </div>

    <div class="form-check">
        <input type="checkbox" name="isActive" class="form-check-input" ${field.getIsActive() ? 'checked' : ''}>
        <label class="form-check-label">Hoạt động</label>
    </div>

    <button type="submit" class="btn btn-primary mt-3">Cập nhật</button>
    <a href="${pageContext.request.contextPath}/fieldOwner/StadiumFieldList?id=${field.stadiumID}" class="btn btn-secondary mt-3">Hủy</a>
</form>
