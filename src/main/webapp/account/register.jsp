<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/register.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
        <script>
            function validateForm(event) {
                const email = document.forms[0]["email"].value.trim();
                const password = document.forms[0]["password"].value.trim();
                const confirmPassword = document.forms[0]["confirmPassword"].value.trim();
                const fullName = document.forms[0]["fullName"].value.trim();
                const phone = document.forms[0]["phone"].value.trim();
                if (!email || !password || !confirmPassword || !fullName || !phone) {
                    alert("Vui lòng điền đầy đủ thông tin vào tất cả các trường.");
                    event.preventDefault();
                    return false;
                }
                if (password !== confirmPassword) {
                    alert("Mật khẩu xác nhận không khớp.");
                    event.preventDefault();
                    return false;
                }
                if (password.length < 8) {
                    alert("Mật khẩu phải có ít nhất 8 ký tự.");
                    event.preventDefault();
                    return false;
                }
                const passwordPattern = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/;
                if (!passwordPattern.test(password)) {
                    alert("Mật khẩu phải có ít nhất 8 ký tự, bao gồm 1 chữ hoa, 1 chữ thường và 1 số.");
                    event.preventDefault();
                    return false;
                }
                const phonePattern = /^\d{10}$/;
                if (!phonePattern.test(phone)) {
                    alert("Số điện thoại phải gồm 10 chữ số.");
                    event.preventDefault();
                    return false;
                }
                return true;
            }
            window.onload = function () {
                document.querySelector("form").addEventListener("submit", validateForm);
            };
        </script>
    </head>
    <body>
        <div class="container">
            <div class="form-container">
                <h2>Đăng ký tài khoản</h2>
                <form action="${pageContext.request.contextPath}/signup" method="post">
                    <input type="text" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Mật khẩu" required>
                    <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                    <input type="text" name="fullName" placeholder="Họ và tên" required>
                    <input type="tel" name="phone" placeholder="Số điện thoại" required>
                    <button type="submit">Đăng ký</button>
                </form>
            </div>
            <div class="overlay-container">
                <h2>Chào mừng!</h2>
                <p>Đã có tài khoản? Hãy đăng nhập ngay.</p>
                <button class="ghost" onclick="location.href = '${pageContext.request.contextPath}/account/login.jsp'">Đăng nhập</button>
            </div>
        </div>
    </body>
</html>