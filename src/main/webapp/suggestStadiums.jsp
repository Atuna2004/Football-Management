<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Stadium" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:choose>
    <c:when test="${not empty suggestedStadiums}">
        <ul class="list-group list-group-flush">
            <c:forEach var="stadium" items="${suggestedStadiums}">
                <li class="list-group-item small">
                    <strong>${stadium.name}</strong><br/>
                    <i class="fa-solid fa-location-dot text-danger"></i> ${stadium.location}<br/>
                    <i class="fa-solid fa-phone text-success"></i>
                    <a href="tel:${stadium.phoneNumber}">${stadium.phoneNumber}</a><br/>
                    <span class="text-muted">Cách bạn khoảng 
                        <strong><fmt:formatNumber value="${stadium.distance}" maxFractionDigits="2" /></strong> km
                    </span>
                </li>
            </c:forEach>
        </ul>
    </c:when>
    <c:otherwise>
        <div class="text-muted small">Không tìm thấy sân gần bạn.</div>
    </c:otherwise>
</c:choose>
