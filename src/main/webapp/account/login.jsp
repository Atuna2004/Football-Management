<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đăng nhập</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h2>Đăng nhập</h2>

            <% 
                String errorMessage = (String) session.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                <div class="error-message" style="color: red; margin-bottom: 15px;">
                    <%= errorMessage %>
                </div>
            <%
                    session.removeAttribute("errorMessage"); // Xóa lỗi sau khi hiển thị
                }
            %>

            <div class="social-icons">
                <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/FootballManagement/login&response_type=code&client_id=525166296465-4q4lifsqbuqhg7ptinpu0g5bc5tcjkqk.apps.googleusercontent.com&approval_prompt=force"><img src="https://img.icons8.com/ios-glyphs/30/google-logo.png"/></a>
                <a href="#"><img src="https://img.icons8.com/ios-glyphs/30/facebook-new.png"/></a>
                <a href="#"><img src="https://img.icons8.com/ios-glyphs/30/github.png"/></a>
                <a href="#"><img src="https://img.icons8.com/ios-glyphs/30/linkedin.png"/></a>
            </div>
            <p>hoặc sử dụng email của bạn</p>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="email" name="email" placeholder="Email" required />
                <input type="password" name="password" placeholder="Password" required />

                <button type="submit">Đăng nhập</button>
                <div style="text-align: right; margin-bottom: 10px;">
                    <a href="${pageContext.request.contextPath}/account/forgotPassword.jsp" style="color: #5E3CF3; text-decoration: none; font-size: 14px;">Quên mật khẩu?</a>
                </div>
            </form>
        </div>
        <div class="overlay-container">
            <div class="overlay-background"></div>
            <div class="overlay-content">
                <h2>Xin chào, bạn!</h2>
                <p>Hãy đăng ký với thông tin cá nhân của bạn để sử dụng đầy đủ các tính năng của trang web.</p>
                <button class="ghost" onclick="location.href='${pageContext.request.contextPath}/account/register.jsp'">Đăng kí</button>
            </div>
        </div>
    </div>
</body>
</html>
