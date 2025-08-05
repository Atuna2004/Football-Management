<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giải đấu đã đăng ký</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
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
    </style>
</head>
<body>
<%@ include file="/includes/header.jsp" %>
<div class="container py-4">
    <div class="section-title">Các giải đấu bạn đã đăng ký</div>
    <c:if test="${empty registeredTeams}">
        <div class="alert alert-info mt-4 text-center">
            Bạn chưa đăng ký giải đấu nào.
        </div>
    </c:if>
    <c:if test="${not empty registeredTeams}">
        <div class="row row-cols-1 row-cols-md-3 g-4 mt-1">
            <c:forEach var="tt" items="${registeredTeams}" varStatus="loop">
                <c:set var="t" value="${tournaments[loop.index]}" />
                <div class="col">
                    <div class="card h-100">
                        <img src="${empty t.imageUrl ? 'images/default.jpg' : t.imageUrl}" class="card-img-top" alt="${t.name}">
                        <div class="card-body">
                            <h5 class="card-title text-danger fw-bold">${t.name}</h5>
                            <p class="card-text text-muted">
                                Từ <fmt:formatDate value="${t.startDate}" pattern="dd-MM-yyyy"/>
                                đến <fmt:formatDate value="${t.endDate}" pattern="dd-MM-yyyy"/>
                            </p>
                            <p>
                                <span class="badge bg-info text-dark">Giải thưởng: <fmt:formatNumber value="${t.award}" type="currency" currencySymbol="₫"/></span>
                            </p>
                            <p>
                                <span class="badge bg-secondary">Số đội hiện tại: ${t.quantityTeams}</span>
                                <span class="badge bg-dark ms-1">Tối đa: ${t.totalTeams}</span>
                            </p>
                            <p>
                                <strong>Trạng thái duyệt:</strong>
                                <c:choose>
                                    <c:when test="${!tt.status}">
                                        <button class="btn btn-secondary btn-sm" disabled>Đã hủy đăng ký</button>
                                    </c:when>
                                    <c:when test="${tt.isApproved}">
                                        <button class="btn btn-success btn-sm" disabled>Đã duyệt</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-warning btn-sm" disabled>Chờ duyệt</button>
                                        <button
                                            type="button"
                                            class="btn btn-outline-danger btn-sm ms-2"
                                            data-bs-toggle="modal"
                                            data-bs-target="#cancelModal"
                                            data-tournament-id="${tt.tournamentID}"
                                            data-tournament-name="${t.name}">
                                            Hủy đăng ký
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <p>
                                <strong>Đội đăng ký:</strong> ${tt.teamName}<br>
                                <strong>Đội trưởng:</strong> ${tt.captainName}<br>
                                <strong>Liên hệ:</strong> ${tt.contactPhone}
                            </p>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>
<!-- Modal xác nhận hủy đăng ký -->
<div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/tournamentTeam/cancel" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="cancelModalLabel">Xác nhận hủy đăng ký</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <div class="modal-body">
          Bạn có chắc chắn muốn hủy đăng ký giải <strong id="modalTournamentName"></strong> không?
          <input type="hidden" name="tournamentId" id="modalTournamentId" value="" />
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Không</button>
          <button type="submit" class="btn btn-danger">Hủy đăng ký</button>
        </div>
      </form>
    </div>
  </div>
</div>
<%@ include file="/includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var cancelModal = document.getElementById('cancelModal');
        cancelModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var tournamentId = button.getAttribute('data-tournament-id');
            var tournamentName = button.getAttribute('data-tournament-name');
            document.getElementById('modalTournamentId').value = tournamentId;
            document.getElementById('modalTournamentName').textContent = tournamentName;
        });
    });
</script>
</body>
</html>