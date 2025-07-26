<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Update Successful - FIELD MASTER</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 2rem;
            }

            .success-container {
                background: white;
                padding: 3rem 2.5rem;
                border-radius: 16px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                text-align: center;
                max-width: 480px;
                width: 100%;
                animation: fadeInUp 0.6s ease-out;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .success-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 2rem;
                animation: checkmark 0.8s ease-out 0.3s both;
            }

            .success-icon i {
                font-size: 2rem;
                color: white;
            }

            @keyframes checkmark {
                0% {
                    transform: scale(0);
                    opacity: 0;
                }
                50% {
                    transform: scale(1.2);
                }
                100% {
                    transform: scale(1);
                    opacity: 1;
                }
            }

            h1 {
                font-size: 1.75rem;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 1rem;
                letter-spacing: -0.025em;
            }

            p {
                font-size: 1rem;
                color: #64748b;
                margin-bottom: 2.5rem;
                line-height: 1.6;
            }

            .button-group {
                display: flex;
                gap: 1rem;
                justify-content: center;
                flex-wrap: wrap;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.875rem 1.75rem;
                border: none;
                border-radius: 8px;
                font-size: 0.875rem;
                font-weight: 500;
                text-decoration: none;
                cursor: pointer;
                transition: all 0.2s ease;
                min-width: 140px;
                justify-content: center;
            }

            .btn-primary {
                background: #3b82f6;
                color: white;
            }

            .btn-primary:hover {
                background: #2563eb;
                transform: translateY(-1px);
            }

            .btn-secondary {
                background: #f8fafc;
                color: #64748b;
                border: 1px solid #e2e8f0;
            }

            .btn-secondary:hover {
                background: #f1f5f9;
                color: #475569;
                transform: translateY(-1px);
            }

            /* Mobile responsive */
            @media (max-width: 480px) {
                body {
                    padding: 1rem;
                }
                
                .success-container {
                    padding: 2rem 1.5rem;
                }
                
                h1 {
                    font-size: 1.5rem;
                }
                
                .button-group {
                    flex-direction: column;
                }
                
                .btn {
                    min-width: auto;
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="success-container">
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>
            
            <h1>Update Successful</h1>
            <p>Your information has been updated successfully.</p>
            
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/account/profile.jsp" class="btn btn-primary">
                    <i class="fas fa-user"></i>
                    Back to Profile
                </a>
                <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-secondary">
                    <i class="fas fa-home"></i>
                    Home
                </a>
            </div>
        </div>
    </body>
</html>