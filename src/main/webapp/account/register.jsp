<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - FIELD MASTER</title>
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

        .register-page {
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
            max-width: 520px;
            box-shadow: 0 25px 50px rgba(59, 130, 246, 0.2);
            border: 1px solid rgba(59, 130, 246, 0.2);
            max-height: 90vh;
            overflow-y: auto;
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

        /* Password requirements */
        .password-requirements {
            background: rgba(239, 246, 255, 0.8);
            border: 1px solid rgba(59, 130, 246, 0.2);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            display: none;
        }

        .requirement {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            color: rgba(100, 116, 139, 0.8);
        }

        .requirement:last-child {
            margin-bottom: 0;
        }

        .requirement i {
            color: #dc2626;
            font-size: 0.8rem;
            width: 12px;
        }

        .requirement.valid i {
            color: #16a34a;
        }

        .requirement.valid {
            color: #16a34a;
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

        /* Error popup */
        .error-popup {
            position: fixed;
            top: 2rem;
            right: 2rem;
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.95), rgba(220, 38, 38, 0.95));
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.4);
            z-index: 1000;
            animation: slideInRight 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            max-width: 300px;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(100%);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
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
            .register-page {
                padding: 1rem;
            }
            
            .container {
                padding: 2rem 1.5rem;
                max-width: 100%;
                max-height: 95vh;
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

            .error-popup {
                right: 1rem;
                top: 1rem;
                max-width: calc(100% - 2rem);
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
            
            .input-group input {
                padding: 1rem 0.75rem 1rem 2.5rem;
            }
            
            .input-icon {
                left: 0.75rem;
            }
            
            .toggle-password {
                right: 0.75rem;
            }
        }

        /* Focus states for accessibility */
        .main-btn:focus,
        .social-btn:focus,
        .link-btn:focus {
            outline: 2px solid #3b82f6;
            outline-offset: 2px;
        }

        /* Custom scrollbar for container */
        .container::-webkit-scrollbar {
            width: 6px;
        }

        .container::-webkit-scrollbar-track {
            background: rgba(226, 232, 240, 0.3);
            border-radius: 3px;
        }

        .container::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border-radius: 3px;
        }

        .container::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #2563eb, #1e40af);
        }

        /* Smooth scrolling */
        html {
            scroll-behavior: smooth;
        }
    </style>
</head>
<body>
    <div class="register-page">
        <!-- Background decorations -->
        <div class="bg-decoration"></div>
        
        <div class="container">
            <!-- Header tabs -->
            <div class="header-tabs">
                <a href="${pageContext.request.contextPath}/account/login.jsp" class="tab">LOGIN</a>
                <span class="tab active">SIGN UP</span>
            </div>

            <!-- Register Form -->
            <form action="${pageContext.request.contextPath}/signup" method="post" id="registerForm">
                <div class="form-grid">
                    <div class="input-group">
                        <input type="text" name="fullName" placeholder="Họ và tên" required />
                        <i class="fas fa-user input-icon"></i>
                    </div>

                    <div class="input-group">
                        <input type="email" name="email" placeholder="Email" required />
                        <i class="fas fa-envelope input-icon"></i>
                    </div>

                    <div class="input-group">
                        <input type="tel" name="phone" placeholder="Số điện thoại" required />
                        <i class="fas fa-phone input-icon"></i>
                    </div>

                    <div class="input-group">
                        <input type="password" name="password" placeholder="Mật khẩu" required />
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" onclick="togglePassword('password')">
                            <i class="fas fa-eye" id="toggleIcon1"></i>
                        </button>
                    </div>

                    <div class="input-group">
                        <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required />
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword')">
                            <i class="fas fa-eye" id="toggleIcon2"></i>
                        </button>
                    </div>
                </div>

                <div class="password-requirements" id="passwordHints">
                    <div class="requirement" id="length">
                        <i class="fas fa-times"></i>
                        <span>Ít nhất 8 ký tự</span>
                    </div>
                    <div class="requirement" id="uppercase">
                        <i class="fas fa-times"></i>
                        <span>1 chữ hoa</span>
                    </div>
                    <div class="requirement" id="lowercase">
                        <i class="fas fa-times"></i>
                        <span>1 chữ thường</span>
                    </div>
                    <div class="requirement" id="number">
                        <i class="fas fa-times"></i>
                        <span>1 số</span>
                    </div>
                </div>

                <button type="submit" class="main-btn">
                    TẠO TÀI KHOẢN
                </button>
            </form>

            <!-- Bottom Links -->
            <div class="bottom-links">
                <a href="${pageContext.request.contextPath}/account/login.jsp" class="link-btn">
                    <i class="fas fa-sign-in-alt"></i>
                    Đã có tài khoản? Đăng nhập
                </a>
                
                <a href="${pageContext.request.contextPath}/home.jsp" class="link-btn">
                    <i class="fas fa-home"></i>
                    Về trang chủ
                </a>
            </div>

            <!-- Quick Login -->
            <div class="quick-login">
                <span class="divider-text">Quick signup</span>
                
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
        function togglePassword(fieldName) {
            const passwordInput = document.querySelector(`input[name="${fieldName}"]`);
            const toggleIcon = fieldName === 'password' ? document.getElementById('toggleIcon1') : document.getElementById('toggleIcon2');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.className = 'fas fa-eye-slash';
            } else {
                passwordInput.type = 'password';
                toggleIcon.className = 'fas fa-eye';
            }
        }

        // Password validation
        function validateForm(event) {
            const email = document.forms[0]["email"].value.trim();
            const password = document.forms[0]["password"].value.trim();
            const confirmPassword = document.forms[0]["confirmPassword"].value.trim();
            const fullName = document.forms[0]["fullName"].value.trim();
            const phone = document.forms[0]["phone"].value.trim();

            if (!email || !password || !confirmPassword || !fullName || !phone) {
                showError("Vui lòng điền đầy đủ thông tin vào tất cả các trường.");
                event.preventDefault();
                return false;
            }

            if (password !== confirmPassword) {
                showError("Mật khẩu xác nhận không khớp.");
                event.preventDefault();
                return false;
            }

            if (password.length < 8) {
                showError("Mật khẩu phải có ít nhất 8 ký tự.");
                event.preventDefault();
                return false;
            }

            const passwordPattern = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/;
            if (!passwordPattern.test(password)) {
                showError("Mật khẩu phải có ít nhất 8 ký tự, bao gồm 1 chữ hoa, 1 chữ thường và 1 số.");
                event.preventDefault();
                return false;
            }

            const phonePattern = /^\d{10}$/;
            if (!phonePattern.test(phone)) {
                showError("Số điện thoại phải gồm 10 chữ số.");
                event.preventDefault();
                return false;
            }

            return true;
        }

        function showError(message) {
            // Create error popup
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-popup';
            errorDiv.innerHTML = `
                <i class="fas fa-exclamation-triangle"></i>
                ${message}
            `;
            document.body.appendChild(errorDiv);

            setTimeout(() => {
                errorDiv.remove();
            }, 4000);
        }

        // Real-time password validation
        function checkPasswordRequirements(password) {
            const length = document.getElementById('length');
            const uppercase = document.getElementById('uppercase');
            const lowercase = document.getElementById('lowercase');
            const number = document.getElementById('number');

            // Length check
            if (password.length >= 8) {
                length.classList.add('valid');
                length.querySelector('i').className = 'fas fa-check';
            } else {
                length.classList.remove('valid');
                length.querySelector('i').className = 'fas fa-times';
            }

            // Uppercase check
            if (/[A-Z]/.test(password)) {
                uppercase.classList.add('valid');
                uppercase.querySelector('i').className = 'fas fa-check';
            } else {
                uppercase.classList.remove('valid');
                uppercase.querySelector('i').className = 'fas fa-times';
            }

            // Lowercase check
            if (/[a-z]/.test(password)) {
                lowercase.classList.add('valid');
                lowercase.querySelector('i').className = 'fas fa-check';
            } else {
                lowercase.classList.remove('valid');
                lowercase.querySelector('i').className = 'fas fa-times';
            }

            // Number check
            if (/\d/.test(password)) {
                number.classList.add('valid');
                number.querySelector('i').className = 'fas fa-check';
            } else {
                number.classList.remove('valid');
                number.querySelector('i').className = 'fas fa-times';
            }
        }

        // Form submission
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            if (!validateForm(e)) return;

            const button = this.querySelector('.main-btn');
            const originalText = button.textContent;
            
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ĐANG TẠO TÀI KHOẢN...';
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
                
                // Show password hints when focusing on password field
                if (this.name === 'password') {
                    document.getElementById('passwordHints').style.display = 'block';
                }
            });
            
            input.addEventListener('blur', function() {
                if (!this.value) {
                    this.parentElement.classList.remove('focused');
                }
                
                // Hide password hints when leaving password field
                if (this.name === 'password' && !this.value) {
                    document.getElementById('passwordHints').style.display = 'none';
                }
            });

            // Real-time password validation
            if (input.name === 'password') {
                input.addEventListener('input', function() {
                    checkPasswordRequirements(this.value);
                });
            }
        });
    </script>
</body>
</html>