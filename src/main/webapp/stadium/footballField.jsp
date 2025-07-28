<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Stadium" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sân bóng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footballField.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<main>
    <div class="list-stadium">
        <div class="container">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-sm-3 box-search">
                    <div class="football-search">
                        <div class="football-content">
                            <div class="football-header">
                                <h3>Lọc theo vị trí</h3>
                            </div>
                            <ul class="cat-item">
                                <li>
                                    <a href="${pageContext.request.contextPath}/stadiums"
                                       class="${empty selectedLocation ? 'fw-bold text-primary' : ''}">Tất cả</a>
                                </li>
                                <c:forEach var="loc" items="${locations}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/stadiums?location=${loc}"
                                           class="${loc == selectedLocation ? 'fw-bold text-primary' : ''}">
                                            ${loc}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>

                        <!-- Gợi ý sân gần bạn -->
                        <div class="mt-4">
                            <h5 style="color: #18458b; font-size: 18px;"><i class="fa-solid fa-location-dot"></i> Sân gần bạn</h5>
                            <div id="suggested-stadiums">⏳ Đang xác định vị trí...</div>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-sm-9">
                    <div class="row main-title">
                        <div class="col-sm-12">
                            <div class="section-title">
                                <div class="section-title-separator">
                                    <span><i class="fa-regular fa-star"></i><i class="fa-regular fa-star"></i><i class="fa-regular fa-star"></i></span>
                                </div>
                                <h2>Danh sách sân bãi</h2>
                                <div class="section-separator"></div>
                            </div>
                        </div>
                    </div>

                    <!-- List Stadium -->
                    <c:choose>
                        <c:when test="${not empty stadiums}">
                            <div class="row list-stadium">
                                <c:forEach var="stadium" items="${stadiums}">
                                    <div class="stadium col-sm-4 mb-4">
                                        <div class="listing-item" style="min-height: 432px;">
                                            <div class="stadium-img">
                                                <a href="#"><img src="${pageContext.request.contextPath}/images/banner-client-placeholder.jpg" alt="Stadium Image" class="img-fluid"/></a>
                                            </div>
                                            <div class="title-stadium">
                                                <div class="stadium-content">
                                                    <h3><a href="#"><img src="${pageContext.request.contextPath}/images/success.png" alt="icon"/> ${stadium.name}</a></h3>
                                                </div>
                                                <div class="phone-stadium mt-2 style-a">
                                                    <div class="col-12 p-12">
                                                        <a href="tel:${stadium.phoneNumber}"><i class="fa-solid fa-phone"></i> ${stadium.phoneNumber}</a>
                                                    </div>
                                                </div>
                                                <div class="location-stadium style-a">
                                                    <div class="row">
                                                        <div class="col-12 p-12">
                                                            <a href="#"><i class="fa-solid fa-location-dot"></i> ${stadium.location}</a>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row detail">
                                                    <div class="col-12 p-12">
                                                        <a href="${pageContext.request.contextPath}/stadium-detail?stadiumId=${stadium.stadiumID}">
                                                            <button class="btn btn-primary btn-sm"><span>Chi tiết</span></button>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p>❌ Không có sân bóng để hiển thị.</p>
                        </c:otherwise>
                    </c:choose>

                    <!-- Pagination -->
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center mt-4">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <c:choose>
                                        <c:when test="${not empty selectedLocation}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/stadiums?page=${i}&location=${selectedLocation}">${i}</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="page-link" href="${pageContext.request.contextPath}/stadiums?page=${i}">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const suggestedBox = document.getElementById("suggested-stadiums");

    function fetchSuggestions(lat, lon) {
        console.log("📍 Gửi tọa độ:", lat, lon);

        const params = new URLSearchParams();
        params.append("latitude", lat);
        params.append("longitude", lon);

        fetch("${pageContext.request.contextPath}/suggest-stadiums", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: params.toString()
        })
        .then(response => {
            if (!response.ok) throw new Error("Không thể lấy gợi ý sân bóng");
            return response.text();
        })
        .then(html => {
            suggestedBox.innerHTML = html;
        })
        .catch(error => {
            console.error("❌ Lỗi khi fetch gợi ý sân:", error);
            suggestedBox.innerHTML = "<p class='text-danger'>Không thể gợi ý sân bóng.</p>";
        });
    }

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
                const lat = position.coords.latitude;
                const lon = position.coords.longitude;
                fetchSuggestions(lat, lon);
            },
            (error) => {
                console.warn("⚠️ Không lấy được tọa độ thật, dùng fake:", error.message);
                // Tọa độ fake tại Quảng Nam
                fetchSuggestions(15.978673, 108.262237);
            },
            {
                timeout: 5000
            }
        );
    } else {
        console.warn("⚠️ Trình duyệt không hỗ trợ geolocation, dùng tọa độ giả.");
        fetchSuggestions(15.978673, 108.262237); // fallback
    }
});
</script>



</body>
</html>