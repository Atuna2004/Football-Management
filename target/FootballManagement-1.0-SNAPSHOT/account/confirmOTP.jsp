<%-- 
    Document   : confirmOTP
    Created on : May 17, 2025, 11:57:55 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác minh OTP</title>
    <link rel="stylesheet" href="../css/confirmOTP.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h2>Xác minh OTP</h2>
            <p>Chúng tôi đã gửi mã xác minh đến email của bạn</p>
            <form action="${pageContext.request.contextPath}/otp" method="post">
                <input type="text" name="otp" placeholder="Nhập mã OTP" maxlength="6" required>
                <button type="submit">Xác nhận</button>
            </form>
        </div>
        <div class="overlay-container">
            <h2>Bảo mật tài khoản</h2>
            <p>Vui lòng nhập mã OTP để hoàn tất quá trình đăng ký</p>
        </div>
    </div>
</body>
</html>

