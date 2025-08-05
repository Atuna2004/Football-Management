<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Stadium" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Giải Đấu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footballField.css"/>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .section-title {
                background-color: #c00;
                color: white;
                padding: 8px 16px;
                border-radius: 4px 4px 0 0;
                font-weight: bold;
                margin-top: 40px;
            }
            .card {
                border: none;
                border-radius: 10px;
                transition: transform 0.2s;
            }
            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            }
            .card-img-top {
                height: 180px;
                object-fit: cover;
            }
            .btn-outline-danger {
                margin-right: 5px;
            }
        </style>
    </head>
    <body>
        <%@ include file="/includes/header.jsp" %>
        <div class="container py-4">
            <!-- TẤT CẢ GIẢI ĐẤU -->
            <div class="section-title">Tất cả các giải đấu</div>
            <%            
                String successMsg = (String) session.getAttribute("success");
                String errorMsg = (String) session.getAttribute("error");
                if (successMsg != null) {
            %>
            <div class="alert alert-success alert-dismissible fade show mt-3" role="alert" id="autoHideSuccess">
                <%= successMsg%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%
                    session.removeAttribute("success");
                }
                if (errorMsg != null) {
            %>
            <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert" id="autoHideError">
                <%= errorMsg%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%
                    session.removeAttribute("error");
                }
            %>
            <script>
                setTimeout(function () {
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
            <div class="row row-cols-1 row-cols-md-4 g-4 mt-1">
                <!-- Card -->
                <c:forEach var="t" items="${tournaments}">
                    <div class="col">
                        <div class="card h-100">
                            <img src="${empty t.imageUrl ? 'images/default.jpg' : t.imageUrl}" class="card-img-top" alt="${t.name}">
                            <div class="card-body text-center">
                                <h5 class="card-title text-danger fw-bold">${t.name}</h5>
                                <p class="card-text text-muted">Từ <fmt:formatDate value="${t.startDate}" pattern="dd-MM-yyyy"/> đến <fmt:formatDate value="${t.endDate}" pattern="dd-MM-yyyy"/></p>
                                <p class="mb-1">
                                    <span class="badge bg-info text-dark">Giải thưởng: <fmt:formatNumber value="${t.award}" type="currency" currencySymbol="₫"/></span>
                                </p>
                                <p class="mb-2">
                                    <span class="badge bg-secondary">Số đội hiện tại: ${t.quantityTeams}</span>
                                    <span class="badge bg-dark ms-1">Tối đa: ${t.totalTeams}</span>
                                </p>
                                <div class="d-flex justify-content-center align-items-center gap-2">
                                    <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                                    <c:set var="now" value="<%= new java.util.Date() %>" />
                                    <c:choose>
                                        <c:when test="${now.time > t.endDate.time}">
                                            <button class="btn btn-dark btn-sm" disabled>Đã kết thúc</button>
                                        </c:when>
                                        <c:when test="${now.time >= t.startDate.time && now.time <= t.endDate.time}">
                                            <button class="btn btn-warning btn-sm" disabled>Đang diễn ra</button>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="found" value="false" />
                                            <c:forEach var="tt" items="${registeredTeams}">
                                                <c:if test="${tt.tournamentID == t.tournamentID}">
                                                    <c:set var="found" value="true" />
                                                    <c:choose>
                                                        <c:when test="${!tt.status}">
                                                            <button class="btn btn-secondary btn-sm" disabled>Đã hủy đăng ký</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-success btn-sm" disabled>Đã đăng ký</button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${!found}">
                                                <form action="${pageContext.request.contextPath}/tournamentTeam/register" method="post" style="display:inline;">
                                                    <input type="hidden" name="tournamentId" value="${t.tournamentID}" />
                                                    <button type="submit" class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                                                </form>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>


                <!-- Repeat for more cards -->
            </div>

        </div>















        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <%@ include file="/includes/footer.jsp" %>
    </body>
</html>