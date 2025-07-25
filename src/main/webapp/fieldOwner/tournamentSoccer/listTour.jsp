<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sân bóng - Field Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stadiumList.css">
    
</head>
<body>
    <!-- Top Header -->
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
        <!-- Left Navigation Sidebar -->
        <%@ include file="../FieldOwnerSB.jsp" %>

        <main class="main-content">
            <div class="container-fluid">
                <!-- Header Section -->
                <div class="row row-cols-1 row-cols-md-3 mb-4">
                    <div class="col mt-3">
                        <h3><i class="fas fa-trophy me-2"></i>Danh sách giải đấu</h3>
                    </div>
                    <div class="col mt-3">
                        <form action="<%= request.getContextPath() %>/tournament-search" method="get">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Tìm kiếm giải đấu..." 
                                       name="searchT" aria-label="Search input" value="${param.searchT}">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                                
                    <!-- Nút thêm mới -->
                    <div class="col mt-3 text-end">
                        <button class="btn btn-success text-white" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="fas fa-plus me-2"></i> Thêm giải mới
                        </button>
                    </div>           
                </div>
                
                <!-- Tournament Table -->
                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th>STT</th>
                                        
                                        <th>Tên giải đấu</th>
                                        <th>Sân</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Ngày kết thúc</th>
                                        <th>Tạo vào</th>
                                        <th style="width:120px">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty list}">
                                            <tr>
                                                <td colspan="7" class="text-center py-5">
                                                    <div class="text-muted">
                                                        <i class="fas fa-trophy fa-3x mb-3"></i>
                                                        <p class="mb-0">Chưa có giải đấu nào</p>
                                                        <small>Hãy thêm giải đấu đầu tiên của bạn!</small>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when> 
                                            <c:otherwise>
                                                <c:forEach items="${list}" var="t" >
                                                    <tr class="tournament-row" data-tournament-id="${t.tournamentID}">
                                                        <td>${t.tournamentID}</td>
                                                        <td>${t.name}</td>
                                                        <td>${t.stadiumName}</td>
                                                        <td>${t.startDate}</td>
                                                        <td>${t.endDate}</td>
                                                        <td>${t.createdAt}</td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <a href="<%= request.getContextPath() %>/edit-tournament?id=${t.tournamentID}" 
                                                                   class="btn btn-primary btn-sm btn-action" 
                                                                   onclick="event.stopPropagation();">
                                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                                </a>
                                                                <a href="<%= request.getContextPath() %>/delete-tournament?id=${t.tournamentID}"
                                                                   class="btn btn-danger btn-sm btn-action"
                                                                   onclick="return confirm('Xóa giải đấu này sẽ ảnh hưởng tới các đội bóng');">
                                                                    <i class="fa-solid fa-trash-can"></i>
                                                                </a>
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
        <!-- Kiểm tra action và method -->
        <form action="${pageContext.request.contextPath}/add-tournament" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm Giải Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- Tên -->
                <div class="mb-3">
                    <label class="form-label">Tên giải đấu</label>
                    <!-- Kiểm tra name -->
                    <input type="text" name="nameTournament" class="form-control" required>
                </div>
                <!-- Sân -->
                <div class="mb-3">
                    <label class="form-label">Sân</label>
                    <!-- Kiểm tra name -->
                    <select name="stadiumId" class="form-select" required>
                        <c:forEach var="s" items="${stadiums}">
                            <option value="${s.stadiumID}">${s.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <!-- Mô tả (không bắt buộc) -->
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea name="description" class="form-control" rows="2"></textarea>
                </div>
                <!-- StartDate -->
                <div class="mb-3">
                    <label class="form-label">Ngày bắt đầu</label>
                    <!-- Kiểm tra name -->
                    <input type="date" name="startDate" class="form-control" required>
                </div>
                <!-- EndDate -->
                <div class="mb-3">
                    <label class="form-label">Ngày kết thúc</label>
                    <!-- Kiểm tra name -->
                    <input type="date" name="endDate" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                <button type="submit" class="btn btn-orange">Thêm giải</button> <!-- Đã sửa text -->
            </div>
        </form>
    </div>
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
                    <p>Bạn có chắc chắn muốn xóa giải đấu <strong id="tournamentName"></strong> không?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Việc xóa giải đấu sẽ ảnh hưởng đến các đội bóng!
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="tournamentID" id="deleteId">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-2"></i>Xóa
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>