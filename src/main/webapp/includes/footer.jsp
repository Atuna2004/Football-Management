<%-- 
    Document   : footer
    Created on : May 15, 2025, 7:45:34 PM
    Author     : ADMIN
--%>

<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/footer.css">
    </head>
    <body>
        <footer class="footer-row">
            <div class="container">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="introduce box-footer">
                            <h3 class="title">Giới thiệu</h3>
                            <div class="introduce-detail">
                                <p>Nền tảng đặt sân này cung cấp các tiện ích thông minh giúp cho bạn tìm sân bãi và đặt sân một
                                cách hiệu quả nhất.
                                </p>
                                <div class="fl-wrap">
                                    <ul class="fl">
                                        <li><a href="url">Chính sách bảo mật</a></li>
                                        <li><a href="url">Chính sách hủy</a></li>
                                        <li><a href="url">Chính sách kiểm hàng</a></li>
                                        <li><a href="url">Chính sách thanh toán</a></li>
                                    </ul>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="football-contact box-footer">
                            <h3>Thông tin</h3>
                            <div class="fl-wrap">
                                <ul>
                                    <li>
                                        <span><i></i></span> 
                                        <a href="url">Công ty Cổ phần Booking Atuna</a>
                                    </li>
                                    <li>
                                        <span>MST <i></i></span> 
                                        <a href="url">0345643121</a>
                                    </li>
                                    <li>
                                        <span>Mail :<i></i></span> 
                                        <a href="url">contact@atuna.com</a>
                                    </li>
                                    <li>
                                        <span>Địa chỉ :<i></i></span> 
                                        <a href="url">Số 3 ngõ 612/34/15 Đường La Thành, Phường Giảng Võ, Quận Ba Đình, Thành phố Hà Nội, Việt Nam</a>
                                    </li>
                                    <li>
                                        <span>Điện thoại :<i></i></span> 
                                        <a href="url">0247.303.0247</a>
                                    </li>
                                    <li>
                                        <span><i></i></span> 
                                        <a href="url">Giấy phép ĐKKD số 0110175404 do Sở Kế hoạch và Đầu tư thành phố Đà Nẵng Cấp ngày 12/5/2025</a>
                                    </li>
                                </ul>

                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="footer-contact2  box-footer">
                            <h3>Liên hệ</h3>
                            <div class="support">
                                <h4>Chăm sóc khách hàng</h4>
                                <a class="tel" href="url">0345.643.121</a>
                                <a href="url">Gọi ngay</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </body>
</html>
