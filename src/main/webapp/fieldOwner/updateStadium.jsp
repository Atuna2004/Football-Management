<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chỉnh sửa sân bóng</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"  rel="stylesheet">

    <!-- Google Fonts - Roboto -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/crudStadium.css">
</head>    


<div class="container-fluid pt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-warning text-white">
                    <h4 class="mb-0">Cập nhật sân bóng</h4>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/stadium/config?action=update" method="post">
                        <input type="hidden" name="stadiumID" value="${stadium.stadiumID}" />
                        <div class="mb-3">
                            <label for="name" class="form-label">Tên sân</label>
                            <input type="text" name="name" id="name" class="form-control" value="${stadium.name}" required />
                        </div>
                        <div class="mb-3">
                            <label for="location" class="form-label">Địa điểm</label>
                            <input type="text" name="location" id="location" class="form-control" value="${stadium.location}" required />
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea name="description" id="description" class="form-control" rows="3">${stadium.description}</textarea>
                        </div>
                        <div class="mb-3">
                            <label for="status" class="form-label">Trạng thái</label>
                            <select name="status" id="status" class="form-select">
                                <option value="active" ${stadium.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="inactive" ${stadium.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="phoneNumber" class="form-label">Số điện thoại</label>
                            <input type="text" name="phoneNumber" id="phoneNumber" class="form-control" value="${stadium.phoneNumber}" />
                        </div>

                        <button type="submit" class="btn btn-success">Cập nhật</button>
                        <a href="${pageContext.request.contextPath}/fieldOwner/FOSTD" class="btn btn-secondary">Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

