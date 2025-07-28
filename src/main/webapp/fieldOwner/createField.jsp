<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thêm sân mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/crudStadium.css">
</head>
<body>
    <div class="container-fluid py-5 background-container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-lg border-0">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fas fa-plus-circle me-2"></i>Thêm sân mới</h4>
                    </div>
                    <div class="card-body p-4">
                        <form id="createFieldForm" method="post" action="${pageContext.request.contextPath}/field/config" novalidate>
                            <input type="hidden" name="action" value="create">
                            <input type="hidden" name="stadiumId" value="${param.stadiumId}">

                            <div class="form-group mb-3">
                                <label for="fieldName" class="form-label">
                                    <i class="fas fa-signature me-2"></i>Tên sân
                                </label>
                                <input type="text" id="fieldName" name="fieldName" class="form-control" required
                                       placeholder="Nhập tên sân">
                                <div class="invalid-feedback">
                                    Tên sân không được chứa ký tự đặc biệt
                                </div>
                            </div>

                            <div class="form-group mb-3">
                                <label for="type" class="form-label">
                                    <i class="fas fa-users me-2"></i>Loại sân
                                </label>
                                <select id="type" name="type" class="form-select" required>
                                    <option value="" disabled selected>Chọn loại sân</option>
                                    <option value="5 người">Sân 5 người</option>
                                    <option value="7 người">Sân 7 người</option>
                                    <option value="11 người">Sân 11 người</option>
                                </select>
                            </div>

                            <div class="form-group mb-3">
                                <label for="description" class="form-label">
                                    <i class="fas fa-info-circle me-2"></i>Mô tả
                                </label>
                                <textarea id="description" name="description" class="form-control"
                                          rows="4" placeholder="Nhập mô tả về sân"></textarea>
                            </div>

                            <div class="form-check mb-3">
                                <input type="checkbox" id="isActive" name="isActive" class="form-check-input" checked>
                                <label class="form-check-label" for="isActive">
                                    <i class="fas fa-toggle-on me-2"></i>Hoạt động
                                </label>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/fieldOwner/StadiumFieldList?id=${param.stadiumId}"
                                   class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Hủy
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Lưu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('createFieldForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const fieldName = document.getElementById('fieldName');
            let isValid = true;

            // Validate field name
            if (!fieldName.value.match(/^[a-zA-Z0-9\sÀ-ỹ]+$/)) {
                fieldName.classList.add('is-invalid');
                isValid = false;
            } else {
                fieldName.classList.remove('is-invalid');
                fieldName.classList.add('is-valid');
            }

            if (isValid) {
                this.submit();
            }
        });

        // Real-time validation for field name
        document.getElementById('fieldName').addEventListener('input', function() {
            if (this.value && !this.value.match(/^[a-zA-Z0-9\sÀ-ỹ]+$/)) {
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else if (this.value) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            } else {
                this.classList.remove('is-invalid', 'is-valid');
            }
        });
    </script>
</body>
</html>
