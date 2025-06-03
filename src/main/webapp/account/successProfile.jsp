<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Cập Nhật Thành Công</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f0fff4;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            .success-box {
                background-color: #d4f5dc;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 128, 0, 0.2);
                text-align: center;
                max-width: 400px;
            }
            .success-box h1 {
                color: #2e7d32;
            }
            .success-box p {
                font-size: 18px;
                margin-bottom: 20px;
            }
            .btn {
                display: inline-block;
                padding: 10px 20px;
                background-color: #4caf50;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                text-decoration: none;
                transition: background-color 0.3s;
                margin: 10px;
            }
            .btn:hover {
                background-color: #388e3c;
            }


            .btn-home {
                background-color: #6c757d;
            }
            .btn-home:hover {
                background-color: #5a6268;
            }
        </style>
    </head>
    <body>
        <div class="success-box">
            <h1>✅ Thành Công!</h1>
            <p>Thông tin của bạn đã được cập nhật thành công.</p>


            <a href="${pageContext.request.contextPath}/account/profile.jsp" class="btn">Quay lại hồ sơ</a>


            <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-home">🏠 Về Trang Chủ</a>
        </div>
    </body>
</html>