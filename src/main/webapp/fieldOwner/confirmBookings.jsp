<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.BookingDAO" %>
<%@ page import="model.Booking" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách đặt sân đã confirm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css"  rel="stylesheet">
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
        <%@ include file="FieldOwnerSB.jsp" %>
        <!-- Main Content -->
        <main class="main-content">
            <div class="container-fluid">
                <!-- Header Section -->
                <div class="row row-cols-1 row-cols-md-2 mb-4">
                    <div class="col mt-3">
                        <h3><i class="fas fa-building me-2"></i>Danh sách đặt sân đã confirm</h3>
                    </div>
                    <div class="col mt-3 text-end">
                        <p>Tổng doanh thu: <strong>${totalRevenue} VND</strong></p>
                    </div>
                </div>
                <!-- Booking Table -->
                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th scope="col">#</th>   
                                        <th scope="col">Mã đặt sân</th>
                                        <th scope="col">Người đặt</th>
                                        <th scope="col">Thời gian đặt</th>
                                        <th scope="col">Số tiền</th>
                                        <th scope="col">Chi tiết</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty confirmedBookings}">
                                            <tr>
                                                <td colspan="6" class="text-center py-5">
                                                    <div class="text-muted">
                                                        <i class="fas fa-check-circle fa-3x mb-3"></i>
                                                        <p class="mb-0">Chưa có đặt sân nào được confirm</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${confirmedBookings}" var="detail" varStatus="index">
                                                <tr>
                                                    <td>${(currentPage - 1) * 10 + index.index + 1}</td>
                                                    <td>${detail.booking.bookingID}</td>
                                                    <td>
                                                        <div class="user-info">
                                                            <span>${detail.fullname}</span>
                                                        </div>
                                                    </td>
                                                    <td>${detail.booking.createdAt}</td>
                                                    <td>${detail.booking.totalAmount} VND</td>
                                                    <td>
                                                        <a href="<%= request.getContextPath() %>/booking/details?id=${detail.booking.bookingID}" class="btn btn-primary btn-sm">Chi tiết</a>
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
                                    <a class="page-link" href="?page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}">
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>   
</body>
</html>