<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chỉnh sửa sân bóng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/crudStadium.css">
</head>

<div class="container-fluid py-5 background-container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0"><i class="fas fa-edit me-2"></i>Cập nhật sân bóng</h4>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/stadium/config?action=update" method="post"
                          id="updateStadiumForm" novalidate>
                        <input type="hidden" name="stadiumID" value="${stadium.stadiumID}"/>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="name" class="form-label">
                                        <i class="fas fa-signature me-2"></i>Tên sân
                                    </label>
                                    <input type="text" name="name" id="name" class="form-control"
                                           value="${stadium.name}" required
                                           pattern="^[a-zA-Z0-9\sÀ-ỹ]+$"
                                           placeholder="Nhập tên sân bóng"/>
                                    <div class="invalid-feedback">
                                        Tên sân không được chứa ký tự đặc biệt
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="location" class="form-label">
                                        <i class="fas fa-map-marker-alt me-2"></i>Địa điểm
                                    </label>
                                    <input type="text" name="location" id="location" class="form-control"
                                           value="${stadium.location}" required
                                           pattern="^.+,\s*.+,\s*.+$"
                                           placeholder="Ví dụ: 123 Đường ABC, Phường XYZ, Thành phố DEF"/>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập đầy đủ địa chỉ (Đường, Phường/Xã, Thành phố)
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">
                                <i class="fas fa-info-circle me-2"></i>Mô tả
                            </label>
                            <textarea name="description" id="description" class="form-control"
                                      rows="4"
                                      placeholder="Nhập mô tả chi tiết về sân bóng">${stadium.description}</textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="status" class="form-label">
                                        <i class="fas fa-toggle-on me-2"></i>Trạng thái
                                    </label>
                                    <select name="status" id="status" class="form-select">
                                        <option value="active" ${stadium.status == 'active' ? 'selected' : ''}>
                                            <i class="fas fa-check-circle me-2"></i>Hoạt động
                                        </option>
                                        <option value="inactive" ${stadium.status == 'inactive' ? 'selected' : ''}>
                                            <i class="fas fa-times-circle me-2"></i>Không hoạt động
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="phoneNumber" class="form-label">
                                        <i class="fas fa-phone me-2"></i>Số điện thoại
                                    </label>
                                    <input type="tel" name="phoneNumber" id="phoneNumber" class="form-control"
                                           value="${stadium.phoneNumber}"
                                           pattern="^0\d{9}$"
                                           placeholder="Nhập số điện thoại liên hệ"/>
                                    <div class="invalid-feedback">
                                        Số điện thoại phải bắt đầu bằng số 0 và có đủ 10 số
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end mt-4">
                            <a href="${pageContext.request.contextPath}/fieldOwner/FOSTD"
                               class="btn btn-secondary me-2">
                                <i class="fas fa-times me-2"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save me-2"></i>Cập nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('updateStadiumForm').addEventListener('submit', function (event) {
        event.preventDefault();

        const name = document.getElementById('name');
        const location = document.getElementById('location');
        const phoneNumber = document.getElementById('phoneNumber');
        let isValid = true;

        if (!name.value.match(/^[a-zA-Z0-9\sÀ-ỹ]+$/)) {
            name.classList.add('is-invalid');
            isValid = false;
        } else {
            name.classList.remove('is-invalid');
            name.classList.add('is-valid');
        }

        if (!location.value.match(/^.+,\s*.+,\s*.+$/)) {
            location.classList.add('is-invalid');
            isValid = false;
        } else {
            location.classList.remove('is-invalid');
            location.classList.add('is-valid');
        }

        if (!phoneNumber.value.match(/^0\d{9}$/)) {
            phoneNumber.classList.add('is-invalid');
            isValid = false;
        } else {
            phoneNumber.classList.remove('is-invalid');
            phoneNumber.classList.add('is-valid');
        }

        if (isValid) {
            this.submit();
        }
    });

    const inputs = [
        {id: 'name', pattern: /^[a-zA-Z0-9\sÀ-ỹ]+$/},
        {id: 'location', pattern: /^.+,\s*.+,\s*.+$/},
        {id: 'phoneNumber', pattern: /^0\d{9}$/}
    ];

    inputs.forEach(input => {
        document.getElementById(input.id).addEventListener('input', function () {
            if (this.value && !this.value.match(input.pattern)) {
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else if (this.value) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            } else {
                this.classList.remove('is-invalid', 'is-valid');
            }
        });
    });
</script>
