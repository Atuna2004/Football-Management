<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - FIELD MASTER</title>
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

        .reset-password-page {
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
            content: '🔑';
            position: absolute;
            top: 15%;
            right: 10%;
            font-size: 4rem;
            opacity: 0.6;
            animation: rotate 4s ease-in-out infinite;
            filter: drop-shadow(0 0 20px rgba(59, 130, 246, 0.5));
        }

        @keyframes rotate {
            0%, 100% { 
                transform: rotate(0deg); 
            }
            25% { 
                transform: rotate(10deg); 
            }
            50% { 
                transform: rotate(-10deg); 
            }
            75% { 
                transform: rotate(5deg); 
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

        .page-header .icon-wrapper {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.1), rgba(37, 99, 235, 0.1));
            border-radius: 50%;
            margin-bottom: 1.5rem;
            border: 2px solid rgba(59, 130, 246, 0.2);
        }

        .page-header .icon-wrapper i {
            font-size: 2rem;
            color: #3b82f6;
        }

        .page-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 0.75rem;
            letter-spacing: -0.5px;
        }

        .page-header p {
            color: rgba(100, 116, 139, 0.8);
            font-size: 1rem;
            line-height: 1.5;
            max-width: 320px;
            margin: 0 auto;
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
            text-align: left;
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
            .reset-password-page {
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
            
            .page-header .icon-wrapper {
                width: 60px;
                height: 60px;
                margin-bottom: 1rem;
            }
            
            .page-header .icon-wrapper i {
                font-size: 1.5rem;
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
    <div class="reset-password-page">
        <!-- Background decorations -->
        <div class="bg-decoration"></div>
        
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="icon-wrapper">
                    <i class="fas fa-key"></i>
                </div>
                <h1>Đặt lại mật khẩu</h1>
                <p>Tạo mật khẩu mới an toàn cho tài khoản của bạn</p>
            </div>

            <!-- Error Message (hidden by default) -->
            <div class="error-message" id="errorMessage" style="display: none;">
                <i class="fas fa-exclamation-triangle"></i>
                <span id="errorText">Mật khẩu xác nhận không khớp.</span>
            </div>

            <!-- Success Message (hidden by default) -->
            <div class="success-message" id="successMessage" style="display: none;">
                <i class="fas fa-check-circle"></i>
                Mật khẩu đã được đặt lại thành công! Đang chuyển hướng...
            </div>

            <!-- Reset Password Form -->
            <form action="${pageContext.request.contextPath}/forgotPassword" method="post" id="resetPasswordForm">
                <div class="form-grid">
                    <div class="input-group">
                        <input type="password" name="password" placeholder="Nhập mật khẩu mới" required />
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" onclick="togglePassword('password')">
                            <i class="fas fa-eye" id="toggleIcon1"></i>
                        </button>
                    </div>

                    <div class="input-group">
                        <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required />
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
                    Xác nhận đặt lại
                </button>
            </form>

            <!-- Bottom Link -->
            <div class="bottom-link">
                <a href="${pageContext.request.contextPath}/account/login.jsp" class="link-btn">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại đăng nhập
                </a>
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
            const password = document.forms[0]["password"].value.trim();
            const confirmPassword = document.forms[0]["confirmPassword"].value.trim();

            if (!password || !confirmPassword) {
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

            return true;
        }

        function showError(message) {
            const errorMessage = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            errorText.textContent = message;
            errorMessage.style.display = 'flex';
            
            // Hide after 5 seconds
            setTimeout(() => {
                errorMessage.style.display = 'none';
            }, 5000);
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
        document.getElementById('resetPasswordForm').addEventListener('submit', function(e) {
            if (!validateForm(e)) return;

            const button = this.querySelector('.main-btn');
            const originalText = button.textContent;
            
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ĐANG XỬ LÝ...';
            button.disabled = true;
            
            // Simulate success after 2 seconds (remove in production)
            setTimeout(() => {
                // Show success message
                document.getElementById('successMessage').style.display = 'flex';
                
                // Hide form
                this.style.display = 'none';
                document.querySelector('.bottom-link').style.display = 'none';
                
                // Redirect after 3 seconds
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/account/login.jsp';
                }, 3000);
            }, 2000);
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