<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thành công</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    
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
            color: #1e293b;
        }

        .success-container {
            background: white;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.15);
            border: 1px solid rgba(59, 130, 246, 0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }

        .success-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #10b981, #059669);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }

        .success-title {
            font-size: 24px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 12px;
        }

        .success-message {
            font-size: 16px;
            color: #64748b;
            margin-bottom: 30px;
            line-height: 1.5;
        }

        .btn-home {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 15px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .btn-home:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
            color: white;
            text-decoration: none;
        }

        @media (max-width: 600px) {
            .success-container {
                padding: 30px 20px;
                margin: 20px;
            }

            .success-title {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check"></i>
        </div>
        
        <h1 class="success-title">Thành công</h1>
        <p class="success-message">
            Yêu cầu của bạn đã được gửi thành công! Thông tin sẽ được gửi đến admin để xét duyệt.
        </p>
        
        <a href="<%= request.getContextPath() %>/home.jsp" class="btn-home">
            <i class="fas fa-home"></i>
            <span>Về trang chủ</span>
        </a>
    </div>
</body>
</html>