<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Stadium" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <!-- GIẢI ĐẤU NỔI BẬT -->
    <div class="section-title">Giải đấu nổi bật</div>
    <div class="row row-cols-1 row-cols-md-4 g-4 mt-1">
        <!-- Card -->
        <div class="col">
            <div class="card h-100">
                <img src="images-food/bac-xiu.jpg" class="card-img-top" alt="AMATA">
                <div class="card-body text-center">
                    <h5 class="card-title text-danger fw-bold">GIẢI BÓNG ĐÁ KCN AMATA CITY HẠ LONG 2025</h5>
                    <p class="card-text text-muted">Từ 10-07-2025 đến 25-07-2025</p>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                        <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col">
            <div class="card h-100">
                <img src="images/default.jpg" class="card-img-top" alt="AMATA">
                <div class="card-body text-center">
                    <h5 class="card-title text-danger fw-bold">GIẢI BÓNG ĐÁ CÁC CLB PHƯỜNG BÃI CHÁY 2025</h5>
                    <p class="card-text text-muted">Từ 10-07-2025 đến 25-07-2025</p>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                        <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col">
            <div class="card h-100">
                <img src="images/default.jpg" class="card-img-top" alt="AMATA">
                <div class="card-body text-center">
                    <h5 class="card-title text-danger fw-bold">CLB SUPER CUP – GIẢI LIÊN QUÂN ĐÀ NẴNG 2025</h5>
                    <p class="card-text text-muted">Từ 10-07-2025 đến 25-07-2025</p>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                        <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col">
            <div class="card h-100">
                <img src="images/default.jpg" class="card-img-top" alt="Học đường">
                <div class="card-body text-center">
                    <h5 class="card-title text-danger fw-bold">GIẢI HỮU NGHỊ CLB THANH KHÊ – MÙA HÈ 2025</h5>
                    <p class="card-text text-muted">Từ 28-05-2025 đến 15-06-2025</p>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                        <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Repeat for more cards -->
    </div>

    <!-- GIẢI NHIỀU NGƯỜI XEM -->
    <div class="section-title">Giải nhiều người xem</div>
    <div class="row row-cols-1 row-cols-md-4 g-4 mt-1">
        <!-- Card -->
        <div class="col">
            <div class="card h-100">
                <img src="images/default.jpg" class="card-img-top" alt="Học đường">
                <div class="card-body text-center">
                    <h5 class="card-title text-danger fw-bold">U13 CHAMPIONSHIP S3 - 2025 CUP TH SPORT</h5>
                    <p class="card-text text-muted">Từ 28-05-2025 đến 15-06-2025</p>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                        <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col">
            <div class="card h-100">
                <img src="images/default.jpg" class="card-img-top" alt="Học đường">
                <div class="card-body text-center">
                    <h5 class="card-title text-danger fw-bold">VIETBALL CHAMPIONS LEAGUE 2025</h5>
                    <p class="card-text text-muted">Từ 28-05-2025 đến 15-06-2025</p>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                        <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col">
            <div class="card h-100">
                <img src="images/default.jpg" class="card-img-top" alt="Học đường">
                <div class="card-body text-center">
                    <h5 class="card-title text-danger fw-bold">NEXTGEN CUP – BÓNG ĐÁ TRẺ TÀI NĂNG 2025</h5>
                    <p class="card-text text-muted">Từ 28-05-2025 đến 15-06-2025</p>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                        <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col">
            <div class="card h-100">
                <img src="images/default.jpg" class="card-img-top" alt="Học đường">
                <div class="card-body text-center">
                    <h5 class="card-title text-danger fw-bold">NATIONAL FUTSAL PRO CUP – SEASON 2025</h5>
                    <p class="card-text text-muted">Từ 28-05-2025 đến 15-06-2025</p>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                        <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Repeat for more cards -->
    </div>

    <!-- TẤT CẢ GIẢI ĐẤU -->
    <div class="section-title">Tất cả các giải đấu</div>
    <div class="row row-cols-1 row-cols-md-4 g-4 mt-1">
        <!-- Card -->
        <c:forEach var="t" items="${tournaments}">
            <div class="col">
                <div class="card h-100">
                    <img src="images/default.jpg" class="card-img-top" alt="${t.name}">
                    <div class="card-body text-center">
                        <h5 class="card-title text-danger fw-bold">${t.name}</h5>
                        <p class="card-text text-muted">Từ ${t.startDate} đến ${t.endDate}</p>
                        <div class="d-flex justify-content-center">
                            <button class="btn btn-outline-danger btn-sm">Theo dõi</button>
                            <button class="btn btn-outline-primary btn-sm">Đăng ký giải</button>
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