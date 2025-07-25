<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đăng nhập - FIELD MASTER</title>
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

        .login-page {
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
            content: '⚽';
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
                transform: translateY(-15px) rotate(90deg); 
            }
            50% { 
                transform: translateY(-20px) rotate(180deg); 
            }
            75% { 
                transform: translateY(-10px) rotate(270deg); 
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
        }

        /* Header tabs */
        .header-tabs {
            display: flex;
            gap: 2.5rem;
            margin-bottom: 2rem;
            justify-content: center;
        }

        .tab {
            font-size: 1.25rem;
            font-weight: 600;
            text-decoration: none;
            color: #9ca3af;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            position: relative;
            padding: 0.5rem 0;
        }

        .tab.active {
            color: #1e3a8a;
        }

        .tab.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border-radius: 1px;
        }

        .tab:not(.active):hover {
            color: #3b82f6;
            transform: translateY(-1px);
        }

        /* Error message */
        .error-message {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #dc2626;
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }

        /* Form styling */
        form {
            margin-bottom: 2rem;
        }

        .form-grid {
            display: grid;
            gap: 1.5rem;
            margin-bottom: 1rem;
        }

        .input-group {
            position: relative;
        }

        .input-group input {
            width: 100%;
            padding: 1.2rem 1rem;
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

        .toggle-password {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: rgba(100, 116, 139, 0.7);
            cursor: pointer;
            padding: 0.5rem;
            transition: color 0.3s ease;
        }

        .toggle-password:hover {
            color: #3b82f6;
        }

        .form-options {
            text-align: right;
            margin-bottom: 2rem;
        }

        .forgot-link {
            color: #3b82f6;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .forgot-link:hover {
            color: #2563eb;
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

        /* Bottom links */
        .bottom-links {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
            gap: 1rem;
        }

        .link-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: rgba(100, 116, 139, 0.8);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: color 0.3s ease;
            flex: 1;
        }

        .link-btn:hover {
            color: #3b82f6;
        }

        .link-btn i {
            font-size: 1rem;
        }

        /* Quick login */
        .quick-login {
            position: relative;
        }

        .divider-text {
            display: block;
            text-align: center;
            color: rgba(100, 116, 139, 0.7);
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
            position: relative;
            background: rgba(255, 255, 255, 0.95);
            padding: 0 1rem;
            display: inline-block;
            width: 100%;
        }

        .divider-text::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: rgba(226, 232, 240, 0.8);
            z-index: -1;
        }

        .social-buttons {
            display: flex;
            gap: 1rem;
        }

        .social-btn {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 1rem;
            background: rgba(248, 250, 252, 0.9);
            border: 2px solid rgba(226, 232, 240, 0.8);
            border-radius: 12px;
            color: #1e293b;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .social-btn i {
            font-size: 1.2rem;
        }

        .google-btn:hover {
            border-color: #3b82f6;
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            transform: translateY(-2px);
        }

        .facebook-btn:hover {
            border-color: #1d4ed8;
            background: rgba(29, 78, 216, 0.1);
            color: #1d4ed8;
            transform: translateY(-2px);
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
            .login-page {
                padding: 1rem;
            }
            
            .container {
                padding: 2rem 1.5rem;
            }
            
            .header-tabs {
                gap: 2rem;
            }
            
            .tab {
                font-size: 1.1rem;
            }
            
            .bottom-links {
                flex-direction: column;
                gap: 1rem;
            }
            
            .social-buttons {
                flex-direction: column;
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
            
            .header-tabs {
                margin-bottom: 2rem;
            }
            
            .tab {
                font-size: 1rem;
            }
        }

        /* Focus states for accessibility */
        .main-btn:focus,
        .social-btn:focus,
        .forgot-link:focus,
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
    <div class="login-page">
        <!-- Background decorations -->
        <div class="bg-decoration"></div>
        
        <div class="container">
            <!-- Header tabs -->
            <div class="header-tabs">
                <span class="tab active">LOGIN</span>
                <a href="${pageContext.request.contextPath}/account/register.jsp" class="tab">SIGN UP</a>
            </div>

            <!-- Error Message -->
            <% 
                String errorMessage = (String) session.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <%= errorMessage %>
            </div>
            <%
                    session.removeAttribute("errorMessage");
                }
            %>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                <div class="form-grid">
                    <div class="input-group">
                        <input type="email" name="email" placeholder="Email address" required />
                    </div>

                    <div class="input-group">
                        <input type="password" name="password" placeholder="Mật khẩu" required />
                        <button type="button" class="toggle-password" onclick="togglePassword()">
                            <i class="fas fa-eye" id="toggleIcon"></i>
                        </button>
                    </div>
                </div>

                <div class="form-options">
                    <a href="${pageContext.request.contextPath}/account/forgotPassword.jsp" class="forgot-link">
                        Quên mật khẩu?
                    </a>
                </div>

                <button type="submit" class="main-btn">
                    ĐĂNG NHẬP
                </button>
            </form>

            <!-- Bottom Links -->
            <div class="bottom-links">
                <a href="${pageContext.request.contextPath}/account/register.jsp" class="link-btn">
                    <i class="fas fa-user-plus"></i>
                    Đăng ký tài khoản
                </a>
                
                <a href="${pageContext.request.contextPath}/home.jsp" class="link-btn">
                    <i class="fas fa-headset"></i>
                    Về trang chủ
                </a>
            </div>

            <!-- Quick Login -->
            <div class="quick-login">
                <span class="divider-text">Quick login</span>
                
                <div class="social-buttons">
                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/FootballManagement/login&response_type=code&client_id=525166296465-4q4lifsqbuqhg7ptinpu0g5bc5tcjkqk.apps.googleusercontent.com&approval_prompt=force" 
                       class="social-btn google-btn">
                        <i class="fab fa-google"></i>
                        Google
                    </a>
                    
                    <a href="https://www.facebook.com/v19.0/dialog/oauth?client_id=1238216694420452&redirect_uri=http://localhost:8080/FootballManagement/LoginFacebookServlet&scope=email" 
                       class="social-btn facebook-btn">
                        <i class="fab fa-facebook-f"></i>
                        Facebook
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle password visibility
        function togglePassword() {
            const passwordInput = document.querySelector('input[name="password"]');
            const toggleIcon = document.getElementById('toggleIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.className = 'fas fa-eye-slash';
            } else {
                passwordInput.type = 'password';
                toggleIcon.className = 'fas fa-eye';
            }
        }

        // Form submission
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const button = this.querySelector('.main-btn');
            const originalText = button.textContent;
            
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ĐANG ĐĂNG NHẬP...';
            button.disabled = true;
            
            setTimeout(() => {
                button.textContent = originalText;
                button.disabled = false;
            }, 5000);
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