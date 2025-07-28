<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sân bóng - Field Manager</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * 
        {
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
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: 20px;
            align-items: center;
            margin-bottom: 40px;
        }

        .page-title {
            color: #1e293b;
            font-weight: 700;
            font-size: 32px;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
        }

        .page-title i {
            color: #3b82f6;
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
            text-decoration: none;
            white-space: nowrap;
        }

        .add-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(16, 185, 129, 0.25);
            color: white;
            text-decoration: none;
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
            margin-bottom: 32px;
        }

        .card:hover {
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.12);
        }

        .card-body {
            padding: 0;
        }

        /* Table Styles */
        .table-responsive {
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid rgba(59, 130, 246, 0.1);
        }

        .table {
            background: white;
            border-collapse: collapse;
            width: 100%;
            margin: 0;
        }

        .table th {
            background: #f8fafc;
            color: #374151;
            font-weight: 600;
            font-size: 14px;
            padding: 16px;
            border-bottom: 2px solid rgba(59, 130, 246, 0.1);
            text-align: left;
        }

        .table th:nth-child(1) { width: 50px; }
        .table th:nth-child(2) { width: 25%; }
        .table th:nth-child(3) { width: 30%; }
        .table th:nth-child(4) { width: 20%; }
        .table th:nth-child(5) { width: 12%; }
        .table th:nth-child(6) { width: 13%; }

        .table td {
            padding: 16px;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: middle;
        }

        .table tr:hover {
            background: #f9fafb;
        }

        .stadium-row {
            cursor: pointer;
        }

        /* Stadium Content Styling */
        .stadium-name {
            font-weight: 600;
            color: #1e293b;
            font-size: 18px;
            margin-bottom: 6px;
        }

        .stadium-location {
            color: #64748b;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 2px;
        }

        .stadium-location i {
            color: #3b82f6;
            width: 12px;
        }

        .stadium-description {
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: #64748b;
            font-size: 14px;
        }

        /* Badge Styles */
        .badge {
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

        .badge.bg-info {
            background: rgba(59, 130, 246, 0.1) !important;
            color: #2563eb;
        }

        .badge.bg-success {
            background: rgba(16, 185, 129, 0.1) !important;
            color: #059669;
        }

        .badge.bg-danger {
            background: rgba(239, 68, 68, 0.1) !important;
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

        /* Pagination */
        .pagination {
            margin-top: 32px;
        }

        .page-item .page-link {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            padding: 12px 16px;
            margin: 0 4px;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .page-item .page-link:hover {
            background: rgba(59, 130, 246, 0.1);
            border-color: #3b82f6;
            transform: translateY(-1px);
        }

        .page-item.active .page-link {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border-color: #3b82f6;
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.25);
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
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1055;
            display: none;
            width: 100%;
            height: 100%;
            overflow-x: hidden;
            overflow-y: auto;
            outline: 0;
        }

        .modal.show {
            display: block;
        }

        .modal.fade {
            transition: opacity 0.15s linear;
        }

        .modal.fade:not(.show) {
            opacity: 0;
        }

        .modal.show {
            opacity: 1;
        }

        .modal::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }

        .modal-dialog {
            position: relative;
            width: auto;
            margin: 1.75rem;
            pointer-events: none;
            z-index: 1056;
        }

        .modal-dialog-centered {
            display: flex;
            align-items: center;
            min-height: calc(100% - 3.5rem);
        }

        @media (min-width: 576px) {
            .modal-dialog {
                max-width: 500px;
                margin: 1.75rem auto;
            }
        }

        .modal-content {
            position: relative;
            display: flex;
            flex-direction: column;
            width: 100%;
            pointer-events: auto;
            background-color: #fff;
            background-clip: padding-box;
            border-radius: 24px;
            border: none;
            box-shadow: 0 32px 80px rgba(59, 130, 246, 0.15);
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, #64748b, #475569);
            color: white;
            padding: 24px 32px;
            border: none;
            display: flex;
            flex-shrink: 0;
            align-items: center;
            justify-content: space-between;
        }

        .modal-title {
            font-weight: 700;
            font-size: 20px;
            margin: 0;
            line-height: 1.5;
        }

        .btn-close {
            box-sizing: content-box;
            width: 1em;
            height: 1em;
            padding: 0.25em 0.25em;
            color: #000;
            background: transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='m.235.747 15.027 15.027a.75.75 0 1 1-1.061 1.061L.174 1.808A.75.75 0 1 1 .235.747Z'/%3e%3c/svg%3e") center/1em auto no-repeat;
            border: 0;
            border-radius: 0.375rem;
            opacity: 0.5;
            filter: invert(1);
            cursor: pointer;
        }

        .btn-close:hover {
            opacity: 0.75;
        }

        .modal-body {
            position: relative;
            flex: 1 1 auto;
            padding: 32px;
        }

        .modal-footer {
            display: flex;
            flex-wrap: wrap;
            flex-shrink: 0;
            align-items: center;
            justify-content: flex-end;
            padding: 24px 32px;
            border: none;
            background: rgba(59, 130, 246, 0.02);
            gap: 12px;
        }

        /* Alert in Modal */
        .alert {
            border: none;
            border-radius: 12px;
            padding: 16px 20px;
            font-weight: 500;
        }

        .alert-warning {
            background: rgba(245, 158, 11, 0.1);
            color: #d97706;
            border: 1px solid rgba(245, 158, 11, 0.2);
        }

        /* Button Styles */
        .btn-secondary {
            background: #64748b;
            color: white;
            border: none;
            border-radius: 12px;
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-secondary:hover {
            background: #475569;
            color: white;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 24px;
            }

            .header-section {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .page-title {
                font-size: 28px;
            }

            .search-form {
                max-width: 100%;
            }

            .table th,
            .table td {
                padding: 16px 12px;
                font-size: 14px;
            }

            .stadium-description {
                max-width: 150px;
            }

            .btn-group {
                flex-direction: column;
                gap: 6px;
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

            .pagination {
                justify-content: center;
            }

            .page-item .page-link {
                padding: 8px 12px;
                margin: 0 2px;
            }
        }
             .current-image {
            max-width: 100%;
            max-height: 200px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        .image-preview {
            max-width: 100%;
            max-height: 200px;
            object-fit: cover;
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 10px;
        }
        .image-upload-area {
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            background-color: #f8f9fa;
            transition: all 0.3s ease;
        }
        .image-upload-area:hover {
            border-color: #ffc107;
            background-color: #fff8e1;
        }
        .image-upload-area.dragover {
            border-color: #ffc107;
            background-color: #fff8e1;
        }
        .current-image-container {
            position: relative;
            display: inline-block;
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
        .justify-content-center { justify-content: center; }
        .align-items-center { align-items: center; }
        .me-2 { margin-right: 0.5rem; }
        .me-1 { margin-right: 0.25rem; }
        .mb-0 { margin-bottom: 0; }
        .mb-3 { margin-bottom: 1rem; }
        .mt-3 { margin-top: 1rem; }
        .mt-4 { margin-top: 1.5rem; }
        .p-0 { padding: 0; }
        .text-center { text-align: center; }
        .text-end { text-align: end; }
        .text-muted { color: #64748b; }
        .text-dark { color: #1e293b; }
        .text-warning { color: #d97706; }
        .py-5 { padding: 3rem 0; }
        .btn-sm { padding: 6px 10px; font-size: 12px; }
        .row { display: flex; flex-wrap: wrap; }
        .row-cols-1 { grid-template-columns: 1fr; }
        .row-cols-md-3 { grid-template-columns: repeat(3, 1fr); }
        .col { flex: 1; }
    </style>
</head>
<body>
    <!-- Top Header -->
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
        <!-- Left Navigation Sidebar -->
        <%@ include file="FieldOwnerSB.jsp" %>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container-fluid">
                <!-- Header Section -->
                <div class="header-section fade-in">
                    <h1 class="page-title">
                        <i class="fas fa-building"></i>
                        Danh sách sân bóng
                    </h1>
                    
                    <form id="searchForm" action="<%= request.getContextPath() %>/fieldOwner/FOSTD" method="get" class="search-form">
                        <input type="text" 
                               class="search-input" 
                               placeholder="Tìm kiếm sân..." 
                               name="search" 
                               id="searchInput"
                               aria-label="Search input" 
                               value="${param.search}">
                        <button class="search-btn" type="submit">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                    </form>
                    
                    <a href="<%= request.getContextPath() %>/stadium/config?action=create" class="add-btn">
                        <i class="fas fa-plus"></i>Thêm sân mới
                    </a>
                </div>

                <!-- Stadium Table -->
                <div class="card fade-in">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table mb-0">
                                <thead>
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">Tên sân</th>
                                        <th scope="col">Mô tả</th>
                                        <th scope="col">Vị trí</th>
                                        <th scope="col">Trạng thái</th>
                                        <th scope="col">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty stadiums}">
                                            <tr>
                                                <td colspan="6" class="empty-state">
                                                    <i class="fas fa-building"></i>
                                                    <p>Chưa có sân bóng nào</p>
                                                    <small>Hãy thêm sân bóng đầu tiên của bạn!</small>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${stadiums}" var="stadium" varStatus="index">
                                                <tr class="stadium-row" data-stadium-id="${stadium.stadiumID}">
                                                    <td><strong>${(currentPage - 1) * 10 + index.index + 1}</strong></td>
                                                    
                                                    <td>
                                                        <div class="stadium-name">${stadium.name}</div>
                                                        <div class="stadium-location">
                                                            <i class="fas fa-map-marker-alt"></i>${stadium.location}
                                                        </div>
                                                        <c:if test="${not empty stadium.phoneNumber}">
                                                            <div class="stadium-location">
                                                                <i class="fas fa-phone"></i>${stadium.phoneNumber}
                                                            </div>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <div class="stadium-description" title="${stadium.description}">
                                                            ${stadium.description}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info">${stadium.location}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${stadium.status == 'active'}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-check-circle"></i>Hoạt động
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">
                                                                    <i class="fas fa-times-circle"></i>Không hoạt động
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="<%= request.getContextPath() %>/stadium/config?action=edit&id=${stadium.stadiumID}" 
                                                                class="btn-action btn-primary" 
                                                                onclick="event.stopPropagation();"
                                                                title="Chỉnh sửa">
                                                                 <i class="fa-solid fa-pen-to-square"></i>
                                                             </a>
                                                            <button type="button" 
                                                                    class="btn-action btn-danger delete-btn" 
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#deleteModal" 
                                                                    data-id="${stadium.stadiumID}"
                                                                    data-name="${stadium.name}"
                                                                    onclick="event.stopPropagation();"
                                                                    title="Xóa">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 0}">
                    <nav class="fade-in">
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
        </main>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle text-warning me-2"></i>Xác nhận xóa
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa sân bóng <strong id="stadiumName"></strong> không?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Việc xóa sân sẽ ảnh hưởng đến tất cả các booking liên quan!
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i>Hủy
                    </button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="stadiumId" id="deleteId">
                        <button type="submit" class="btn-danger">
                            <i class="fas fa-trash"></i>Xóa
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.addEventListener("DOMContentLoaded", function () {
        const searchInput = document.getElementById("searchInput");
        const searchForm = document.getElementById("searchForm");
        let searchTimeout;

        // 🔹 LIVE SEARCH: debounce 500ms
        searchInput.addEventListener("input", function () {
            // Xóa tham số page khi bắt đầu tìm kiếm mới
            const url = new URL(window.location.href);
            url.searchParams.delete("page");
            window.history.replaceState({}, '', url);

            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                searchForm.submit(); // Gửi form sau 400ms khi ngừng gõ
            }, 400);
        });

        // 🔹 Click vào dòng sân → chuyển đến danh sách sân con
        const stadiumRows = document.querySelectorAll('.stadium-row');
        stadiumRows.forEach(row => {
            row.addEventListener('click', function() {
                const stadiumId = this.getAttribute('data-stadium-id');
                window.location.href = '<%= request.getContextPath() %>/fieldOwner/StadiumFieldList?id=' + stadiumId;
            });
        });

        // 🔹 Modal xóa sân
        const deleteButtons = document.querySelectorAll(".delete-btn");
        const deleteIdInput = document.getElementById("deleteId");
        const stadiumNameSpan = document.getElementById("stadiumName");
        const deleteForm = document.getElementById("deleteForm");

        deleteButtons.forEach(button => {
            button.addEventListener("click", function () {
                const stadiumId = this.getAttribute("data-id");
                const stadiumName = this.getAttribute("data-name");
                deleteIdInput.value = stadiumId;
                stadiumNameSpan.textContent = stadiumName;
                deleteForm.action = '<%= request.getContextPath() %>/stadium/config';
            });
        });

        // 🔹 Hiệu ứng loading cho nút (tùy chọn)
        const actionButtons = document.querySelectorAll('.btn-action');
        actionButtons.forEach(button => {
            button.addEventListener('click', function() {
                if (!this.classList.contains('delete-btn')) {
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                    this.disabled = true;
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.disabled = false;
                    }, 3000);
                }
            });
        });

        // Add fade-in animation to table rows
        const tableRows = document.querySelectorAll('tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
            row.classList.add('fade-in');
        });
    });
    </script>
</body>
</html>