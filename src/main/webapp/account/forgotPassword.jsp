<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - FIELD MASTER</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 50%, #90caf9 100%);
            color: #1e3a8a;
            min-height: 100vh;
            overflow: hidden;
        }

        .forgot-password-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            padding: 2rem;
        }

        /* Background decorations */
        .bg-decoration {
            position: fixed;
            top: 0;
            right: 0;
            width: 50%;
            height: 100%;
            background: radial-gradient(ellipse at center, rgba(59, 130, 246, 0.3) 0%, transparent 50%),
                        radial-gradient(ellipse at 80% 20%, rgba(37, 99, 235, 0.4) 0%, transparent 40%),
                        radial-gradient(ellipse at 60% 80%, rgba(96, 165, 250, 0.2) 0%, transparent 60%);
            z-index: -1;
            opacity: 0.8;
        }

        .bg-decoration::after {
            content: '🔐';
            position: absolute;
            top: 15%;
            right: 10%;
            font-size: 4rem;
            opacity: 0.6;
            animation: float 3s ease-in-out infinite;
            filter: drop-shadow(0 0 20px rgba(59, 130, 246, 0.5));
        }

        @keyframes float {
            0%, 100% { 
                transform: translateY(0px) rotate(0deg); 
            }
            25% { 
                transform: translateY(-15px) rotate(5deg); 
            }
            50% { 
                transform: translateY(-20px) rotate(-5deg); 
            }
            75% { 
                transform: translateY(-10px) rotate(3deg); 
            }
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2.5rem;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 25px 50px rgba(59, 130, 246, 0.2);
            border: 1px solid rgba(59, 130, 246, 0.2);
            text-align: center;
        }

        /* Header */
        .page-header {
            margin-bottom: 2.5rem;
        }

        .page-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 0.5rem;
            letter-spacing: -0.5px;
        }

        .page-header p {
            color: rgba(100, 116, 139, 0.8);
            font-size: 1rem;
            line-height: 1.5;
        }

        /* Form styling */
        form {
            margin-bottom: 2rem;
        }

        .input-group {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(59, 130, 246, 0.7);
            font-size: 1rem;
            z-index: 2;
            transition: all 0.3s ease;
        }

        .input-group.focused .input-icon {
            color: #3b82f6;
        }

        .input-group input {
            width: 100%;
            padding: 1.2rem 1rem 1.2rem 3rem;
            background: rgba(248, 250, 252, 0.9);
            border: 2px solid rgba(226, 232, 240, 0.8);
            border-radius: 12px;
            color: #1e293b;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .input-group input::placeholder {
            color: rgba(100, 116, 139, 0.7);
        }

        .input-group input:focus {
            outline: none;
            border-color: #3b82f6;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .input-group.focused input {
            border-color: #3b82f6;
            background: rgba(255, 255, 255, 1);
        }

        /* Main button */
        .main-btn {
            width: 100%;
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 1.2rem;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2rem;
        }

        .main-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.4);
        }

        .main-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        /* Back to login section */
        .back-to-login {
            background: rgba(239, 246, 255, 0.8);
            border: 1px solid rgba(59, 130, 246, 0.2);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 1.5rem;
        }

        .back-to-login h3 {
            color: #1e3a8a;
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
        }

        .back-to-login p {
            color: rgba(100, 116, 139, 0.8);
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 1.5rem;
        }

        .secondary-btn {
            background: transparent;
            color: #3b82f6;
            border: 2px solid #3b82f6;
            border-radius: 12px;
            padding: 0.875rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .secondary-btn:hover {
            background: #3b82f6;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
        }

        /* Bottom link */
        .bottom-link {
            text-align: center;
        }

        .link-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: rgba(100, 116, 139, 0.8);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .link-btn:hover {
            color: #3b82f6;
        }

        .link-btn i {
            font-size: 1rem;
        }

        /* Success message */
        .success-message {
            background: rgba(34, 197, 94, 0.1);
            border: 1px solid rgba(34, 197, 94, 0.3);
            color: #16a34a;
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }

        /* Loading spinner */
        .fa-spin {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Mobile responsive */
        @media (max-width: 768px) {
            .forgot-password-page {
                padding: 1rem;
            }
            
            .container {
                padding: 2rem 1.5rem;
            }
            
            .page-header h1 {
                font-size: 1.5rem;
            }
            
            .bg-decoration {
                width: 70%;
            }
            
            .bg-decoration::after {
                font-size: 3rem;
                right: 5%;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1.5rem 1rem;
            }
            
            .page-header h1 {
                font-size: 1.25rem;
            }
            
            .back-to-login {
                padding: 1.5rem;
            }
            
            .input-group input {
                padding: 1rem 0.75rem 1rem 2.5rem;
            }
            
            .input-icon {
                left: 0.75rem;
            }
        }

        /* Focus states for accessibility */
        .main-btn:focus,
        .secondary-btn:focus,
        .link-btn:focus {
            outline: 2px solid #3b82f6;
            outline-offset: 2px;
        }

        /* Smooth scrolling */
        html {
            scroll-behavior: smooth;
        }
    </style>
</head>
<body>
    <div class="forgot-password-page">
        <!-- Background decorations -->
        <div class="bg-decoration"></div>
        
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>Quên mật khẩu?</h1>
                <p>Nhập email của bạn và chúng tôi sẽ gửi liên kết đặt lại mật khẩu</p>
            </div>

            <!-- Success Message (hidden by default) -->
            <div class="success-message" id="successMessage" style="display: none;">
                <i class="fas fa-check-circle"></i>
                Email khôi phục đã được gửi! Vui lòng kiểm tra hộp thư của bạn.
            </div>

            <!-- Forgot Password Form -->
            <form action="${pageContext.request.contextPath}/forgotPassword" method="post" id="forgotPasswordForm">
                <div class="input-group">
                    <input type="email" name="email" placeholder="Nhập địa chỉ email của bạn" required />
                    <i class="fas fa-envelope input-icon"></i>
                </div>

                <button type="submit" class="main-btn">
                    Gửi liên kết khôi phục
                </button>
            </form>

            <!-- Back to Login Section -->
            <div class="back-to-login">
                <h3>Đã nhớ mật khẩu?</h3>
                <p>Quay lại trang đăng nhập để tiếp tục sử dụng dịch vụ của chúng tôi.</p>
                <a href="${pageContext.request.contextPath}/account/login.jsp" class="secondary-btn">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại đăng nhập
                </a>
            </div>

            <!-- Bottom Link -->
            <div class="bottom-link">
                <a href="${pageContext.request.contextPath}/home.jsp" class="link-btn">
                    <i class="fas fa-home"></i>
                    Về trang chủ
                </a>
            </div>
        </div>
    </div>

    <script>
        // Form submission
        document.getElementById('forgotPasswordForm').addEventListener('submit', function(e) {
            const button = this.querySelector('.main-btn');
            const originalText = button.textContent;
            
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ĐANG GỬI...';
            button.disabled = true;
            
            // Simulate success after 2 seconds (you can remove this in production)
            setTimeout(() => {
                button.textContent = originalText;
                button.disabled = false;
                
                // Show success message
                document.getElementById('successMessage').style.display = 'flex';
                
                // Scroll to top to show success message
                document.querySelector('.container').scrollTop = 0;
            }, 2000);
        });

        // Input focus effects
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });
            
            input.addEventListener('blur', function() {
                if (!this.value) {
                    this.parentElement.classList.remove('focused');
                }
            });
        });
    </script>
</body>
</html>