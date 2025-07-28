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
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    
    <style>
        /* Adjust the overall size of the stadium card */
        .listing-item {
            min-height: unset !important; /* Remove fixed min-height to allow it to shrink */
            height: auto; /* Allow height to adjust based on content */
            border: 1px solid #e0e0e0; /* Add a subtle border for better definition */
            border-radius: 8px; /* Slightly rounded corners */
            overflow: hidden; /* Ensure content stays within bounds */
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* Add a subtle shadow */
        }

        /* Make all stadium images small */
        .stadium-img {
            height: 120px; /* Reduced height for a smaller card */
            overflow: hidden;
        }
        
        .stadium-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Ensure the stadium name is the largest text */
        .title-stadium h3 {
            font-size: 1.5rem; /* Larger font size for the stadium name */
            margin-top: 10px; /* Add some spacing above the name */
            margin-bottom: 5px;
        }

        /* Adjust other text sizes to fit the smaller card */
        .phone-stadium,
        .location-stadium {
            font-size: 0.9rem; /* Smaller font size for phone and location */
            margin-bottom: 5px;
        }

        .detail .btn {
            font-size: 0.85rem; /* Smaller button text */
            padding: 5px 10px; /* Adjusted padding for the button */
        }

        /* NEW CSS: Reduce margin-top for the list of stadiums */
        .row.list-stadium {
            margin-top: 0; /* Remove default top margin */
            padding-top: 15px; /* Add a small padding-top if you want a little space */
        }
    </style>
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<main>
    <div class="list-stadium">
        <div class="container">
            <div class="row">
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
                    </div>
                </div>

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

                    <c:choose>
                        <c:when test="${not empty stadiums}">
                            <div class="row list-stadium"> <%-- This is the div we are targeting with the new CSS --%>
                                <c:forEach var="stadium" items="${stadiums}">
                                    <div class="stadium col-sm-4 mb-4">
                                        <div class="listing-item">
                                            <div class="stadium-img">
                                                <a href="#">
                                                    <c:choose>
                                                        <c:when test="${not empty stadium.imageURL}">
                                                            <img src="${stadium.imageURL}" alt="${stadium.name}" class="img-fluid"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/images/banner-client-placeholder.jpg" alt="Stadium Image" class="img-fluid"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </a>
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

                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center mt-4">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <c:choose>
                                        <c:when test="${not empty selectedLocation}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/stadiums?page=${i}&location=${selectedLocation}">${i}</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/stadiums?page=${i}">${i}</a>
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
</body>
</html>