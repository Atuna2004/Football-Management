<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        session.invalidate(); // Hủy session
        response.sendRedirect("home.jsp");  // ← Chuyển về home.jsp thay vì login.jsp
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác nhận đăng xuất</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .modal {
            background: #fff;
            padding: 30px 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 400px;
            animation: fadeIn 0.4s ease;
        }

        .modal h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .modal-buttons {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-yes {
            background: #e74c3c;
            color: #fff;
        }

        .btn-yes:hover {
            background: #c0392b;
        }

        .btn-no {
            background: #bdc3c7;
            color: #333;
        }

        .btn-no:hover {
            background: #95a5a6;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

    <div class="modal" id="logoutConfirmBox">
        <h2>Bạn có chắc chắn muốn đăng xuất?</h2>
        <div class="modal-buttons">
            <form method="post" style="margin: 0;">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="btn btn-yes">Có</button>
            </form>
            <button class="btn btn-no" onclick="goBack()">Không</button>
        </div>
    </div>

    <script>
        function goBack() {
            window.location.href = "adminPage.jsp"; // Chuyển hướng về trang admin nếu chọn "Không"
        }
    </script>

</body>
</html>
