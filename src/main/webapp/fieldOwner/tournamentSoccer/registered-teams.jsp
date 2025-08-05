    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách đội đăng ký</title>
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
        <%@ include file="../FieldOwnerSB.jsp" %>

        <main class="main-content">
            <div class="container-fluid">

                <% 
                    String successMsg = (String) session.getAttribute("success");
                    String errorMsg = (String) session.getAttribute("error");
                    if (successMsg != null) {
                %>
                    <div class="alert alert-success alert-dismissible fade show mt-3" role="alert" id="autoHideSuccess">
                        <%= successMsg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <%
                        session.removeAttribute("success");
                    }
                    if (errorMsg != null) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert" id="autoHideError">
                        <%= errorMsg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <%
                        session.removeAttribute("error");
                    }
                %>

                <div class="row row-cols-1 row-cols-md-2 mb-4">
                    <div class="col mt-3">
                        <h3>
                            <i class="fas fa-users me-2"></i>
                            Danh sách giải: <span class="text-danger">${tournament.name}</span>
                        </h3>
                    </div>
                    <div class="col mt-3 text-end">
                        <a href="${pageContext.request.contextPath}/tournament" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách giải
                        </a>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th>STT</th>
                                        <th>Tên đội</th>
                                        <th>Đội trưởng</th>
                                        <th>Liên hệ</th>
                                        <th>Trạng thái</th>
                                        <th>Duyệt</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty teams}">
                                            <tr>
                                                <td colspan="6" class="text-center py-5">
                                                    <div class="text-muted">
                                                        <i class="fas fa-users fa-3x mb-3"></i>
                                                        <p class="mb-0">Chưa có đội nào đăng ký</p>
                                                        <small>Hãy chờ các đội đăng ký tham gia giải đấu này!</small>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="team" items="${teams}" varStatus="loop">
                                                <tr>
                                                    <td>${loop.index + 1}</td>
                                                    <td>${team.teamName}</td>
                                                    <td>${team.captainName}</td>
                                                    <td>${team.contactPhone}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${team.isApproved}">
                                                                <span class="badge bg-success">Đã duyệt</span>
                                                            </c:when>
                                                            <c:when test="${!team.status}">
                                                                <span class="badge bg-secondary">Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning text-dark">Chờ duyệt</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${!team.isApproved && team.status}">
                                                            <form action="${pageContext.request.contextPath}/tournament/registered-teams" method="post" style="display:inline;">
                                                                <input type="hidden" name="teamName" value="${team.teamName}" />
                                                                <input type="hidden" name="tournamentId" value="${tournament.tournamentID}" />
                                                                <button type="submit" class="btn btn-success btn-sm">
                                                                    <i class="fa-solid fa-check"></i> Duyệt
                                                                </button>
                                                            </form>
                                                        </c:if>
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
            </div>
        </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        setTimeout(function() {
            const success = document.getElementById('autoHideSuccess');
            if (success) {
                success.classList.remove('show');
                setTimeout(() => success.remove(), 500);
            }
            const error = document.getElementById('autoHideError');
            if (error) {
                error.classList.remove('show');
                setTimeout(() => error.remove(), 500);
            }
        }, 3000);
    </script>
</body>
</html>