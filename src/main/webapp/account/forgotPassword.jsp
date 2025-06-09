<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="../css/register.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h2>Khôi phục mật khẩu</h2>
            <form action="${pageContext.request.contextPath}/forgotPassword" method="post">
                <input type="email" name="email" placeholder="Nhập email của bạn" required>
                <button type="submit">Gửi yêu cầu</button>
            </form>
        </div>
        <div class="overlay-container">
            <h2>Chào bạn!</h2>
            <p>Đã nhớ mật khẩu? Quay lại đăng nhập.</p>
            <button class="ghost" onclick="location.href='${pageContext.request.contextPath}/account/login.jsp'">Đăng nhập</button>
        </div>
    </div>
</body>
</html>
