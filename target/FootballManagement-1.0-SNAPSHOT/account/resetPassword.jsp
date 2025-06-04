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
            <form action="${pageContext.request.contextPath}/reset-pass" method="post">
                <input type="password" name="password" placeholder="Nhập mật khẩu mới" required>
                <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới của bạn" required>
                <button type="submit">Xác nhận</button>
            </form>
        </div>
    </div>
</body>
</html>
