<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="paymentDAO" class="dao.PaymentDAO"/>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Thanh Toán Chờ Xác Nhận</title>

    <!-- Bootstrap + Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css"  rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"  rel="stylesheet">

    <!-- CSS riêng -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FOPayment.css">
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
    <!-- Sidebar -->
    <%@ include file="FieldOwnerSB.jsp" %>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container-fluid">
            <h2 class="mb-4">Danh Sách Thanh Toán Chờ Xác Nhận</h2>
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>Mã Booking</th>
                                    <th>Tên Người Dùng</th>
                                    <th>Số Tiền</th>
                                    <th>Phương Thức</th>
                                    <th>Ngày Tạo Yêu Cầu</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${payments}" var="p">
                                    <tr>
                                        <td>${p.bookingId}</td>
                                        <td>${paymentDAO.getUserNameByBookingId(p.bookingId)}</td>
                                        <td class="text-start">
                                            <fmt:formatNumber value="${p.amount}" type="number" maxFractionDigits="0" groupingUsed="true"/> ₫
                                        </td>
                                        <td>${p.paymentMethod}</td>
                                        <td>${p.paymentDate}</td>
                                        <td>
                                            <a href="process-payment?action=Completed&id=${p.paymentId}" class="btn btn-success btn-sm">
                                                <i class="fa-solid fa-check"></i> Xác Nhận
                                            </a>
                                            <a href="process-payment?action=Failed&id=${p.paymentId}" class="btn btn-danger btn-sm">
                                                <i class="fa-solid fa-trash-can"></i> Hủy
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script> 

</body>
</html>