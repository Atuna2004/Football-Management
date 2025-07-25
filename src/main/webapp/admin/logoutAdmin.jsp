<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        session.invalidate(); // Hủy session
        response.sendRedirect(request.getContextPath() + "/home.jsp");  // Redirect to home.jsp
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận đăng xuất - Admin Dashboard</title>
    
    <!-- External CSS Links -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .logout-container {
            background: white;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.15);
            border: 1px solid rgba(59, 130, 246, 0.1);
            text-align: center;
            max-width: 400px;
            width: 90%;
        }

        .logout-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }

        .logout-title {
            font-size: 24px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 12px;
        }

        .logout-message {
            font-size: 16px;
            color: #64748b;
            margin-bottom: 30px;
            line-height: 1.5;
        }

        .button-container {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 15px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            min-width: 120px;
            justify-content: center;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-logout {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .btn-logout:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
        }

        .btn-cancel {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }

        .btn-cancel:hover {
            background: #e2e8f0;
        }

        @media (max-width: 600px) {
            .logout-container {
                padding: 30px 20px;
                margin: 20px;
            }

            .logout-title {
                font-size: 20px;
            }

            .button-container {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <div class="logout-icon">
            <i class="fas fa-sign-out-alt"></i>
        </div>
        
        <h1 class="logout-title">Xác nhận đăng xuất</h1>
        <p class="logout-message">
            Bạn có chắc chắn muốn đăng xuất khỏi hệ thống quản trị?
        </p>
        
        <div class="button-container">
            <form method="post" style="margin: 0;">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="btn btn-logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Đăng xuất</span>
                </button>
            </form>
            
            <button class="btn btn-cancel" onclick="goBack()">
                <i class="fas fa-arrow-left"></i>
                <span>Quay lại</span>
            </button>
        </div>
    </div>

    <script>
        function goBack() {
            window.location.href = "${pageContext.request.contextPath}/adminDashboard";
        }
    </script>
</body>
</html>