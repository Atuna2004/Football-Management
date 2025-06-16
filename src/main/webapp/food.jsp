<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thực đơn Sân Bóng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style>
            .card-img-top {
                height: 180px;
                object-fit: cover;
                border-radius: 10px 10px 0 0;
            }
            .banner {
                width: 100%;
                height: 400px;
                background: url('images-food/banner-food.jpg') no-repeat center center;
                background-size: cover;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 36px;
                font-weight: bold;
                text-shadow: 2px 2px 5px rgba(0,0,0,0.7);
            }
            .card {
                border: none;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                background-color: #ffffff;
            }

            .card:hover {
                transform: translateY(-6px);
                box-shadow: 0 12px 32px rgba(0, 0, 0, 0.15);
            }

            .card-body {
                padding: 16px;
                background-color: #fdfdfd;
            }

            .card-title {
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 8px;
                color: #222;
                letter-spacing: 0.3px;
            }

            .card-text {
                font-size: 16px;
                font-weight: 600;
                color: #d84315;
                background-color: #fff7f2;
                padding: 6px 12px;
                border-radius: 6px;
                display: inline-block;
            }

            .card-img-top {
                height: 280px;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .card:hover .card-img-top {
                transform: scale(1.05);
            }

            .btn-success {
                background: linear-gradient(135deg, #00c853, #18458B);
                color: white;
                font-weight: 600;
                padding: 10px 18px;
                border-radius: 30px;
                box-shadow: 0 5px 15px rgba(0, 200, 83, 0.25);
                border: none;
                transition: all 0.3s ease;
            }

            .btn-success:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0, 200, 83, 0.4);
            }

        </style>
    </head>
    <body>

        <!-- Banner đơn giản -->
        <div class="banner">
            🍽️ Thực đơn Đặt Sân 247
        </div>

        <div class="container mt-4">
            <div class="row g-4">
                <!-- Danh sách 15 món - không phân loại -->
                <c:set var="monAn" value="${[
                                            {'img':'com-rang-bo.jpg', 'ten':'Cơm rang dưa bò', 'gia':'45.000đ'},
                                            {'img':'my-quang.jpg', 'ten':'Mì Quảng', 'gia':'40.000đ'},
                                            {'img':'bun-cha.jpg', 'ten':'Bún chả Hà Nội', 'gia':'35.000đ'},
                                            {'img':'pho-bo.jpg', 'ten':'Phở bò', 'gia':'40.000đ'},
                                            {'img':'com-tam.jpg', 'ten':'Cơm tấm sườn bì', 'gia':'45.000đ'},

                                            {'img':'banh-mi.jpg', 'ten':'Bánh mì xá xíu', 'gia':'25.000đ'},
                                            {'img':'xuc-xich.jpg', 'ten':'Xúc xích Đức', 'gia':'20.000đ'},
                                            {'img':'khoai-tay.jpg', 'ten':'Khoai tây chiên', 'gia':'18.000đ'},
                                            {'img':'mi-cay.jpg', 'ten':'Mì cay Hàn Quốc', 'gia':'30.000đ'},
                                            {'img':'banh-bao.png', 'ten':'Bánh bao nhân thịt', 'gia':'15.000đ'},

                                            {'img':'tra-sua.png', 'ten':'Trà sữa', 'gia':'30.000đ'},
                                            {'img':'coca.png', 'ten':'Coca cola', 'gia':'15.000đ'},
                                            {'img':'nuoc-khoang.jpg', 'ten':'Nước khoáng', 'gia':'12.000đ'},
                                            {'img':'bac-xiu.jpg', 'ten':'Bạc xỉu', 'gia':'18.000đ'},
                                            {'img':'matcha.jpg', 'ten':'Matcha latte', 'gia':'25.000đ'}
                                            ]}" />

                <c:forEach var="mon" items="${monAn}">
                    <div class="col-md-4">
                        <div class="card h-100">
                            <img src="images-food/${mon.img}" class="card-img-top" alt="${mon.ten}" />
                            <div class="card-body">
                                <h5 class="card-title">${mon.ten}</h5>
                                <p class="card-text">Giá: ${mon.gia}</p>
                                <button class="btn btn-success">🛒 Thêm vào giỏ</button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

    </body>
</html>
