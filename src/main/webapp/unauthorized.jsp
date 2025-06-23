<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Truy cập bị từ chối</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #f2f2f2, #d3e0ea);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            max-width: 400px;
        }

        h1 {
            font-size: 48px;
            color: #e74c3c;
            margin-bottom: 10px;
        }

        p {
            font-size: 18px;
            color: #333;
            margin-bottom: 30px;
        }

        a {
            display: inline-block;
            padding: 12px 24px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }

        a:hover {
            background-color: #2980b9;
        }

        .icon {
            font-size: 64px;
            color: #e74c3c;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="icon">🚫</div>
    <h1>403</h1>
    <p>Bạn không có quyền truy cập trang này.</p>
    <a href="<%= request.getContextPath() %>/home.jsp">Quay lại trang chủ</a>
</div>
</body>
</html>
