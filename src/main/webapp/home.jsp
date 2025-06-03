<%-- 
    Document   : home
    Created on : May 15, 2025, 7:44:36 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Football Field Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="./css/home.css"/>
    </head>
    <body>
        <%@ include file="/includes/header.jsp" %>
        <main>
            <div class="box">
                <div class="bg-home">
                    <img src="./images/bg-home.jpg" alt="background home"/>
                </div>
            </div>      
            
            <div class="container">
                <div class="row sub-intro">
                    <div class="col-sm-4 sub-content">
                        <img src="./images/sub-intro1.png" alt="alt"/>
                        <h3>Tìm kiếm vị trí sân</h3>
                        <p>Dữ liệu sân đấu dồi dào, liên tục cập nhật, giúp bạn dễ dàng tìm kiếm theo khu vực mong muốn</p>
                    </div>
                    <div class="col-sm-4 sub-content">
                        <img src="./images/sub-intro2.png" alt="alt"/>
                        <h3>Đặt lịch online</h3>
                        <p>Không cần đến trực tiếp, không cần gọi điện đặt lịch, bạn hoàn toàn có thể đặt sân ở bất kì đâu có internet</p>
                    </div>
                    <div class="col-sm-4 sub-content">
                        <img src="./images/sub-intro3.png" alt="alt"/>
                        <h3>Tìm đối, bắt cặp đấu</h3>
                        <p>Tìm kiếm, giao lưu các đội thi đấu thể thao, kết nối, xây dựng cộng đồng thể thao sôi nổi, mạnh mẽ</p>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="/includes/footer.jsp" %>
    </body>
</html>
