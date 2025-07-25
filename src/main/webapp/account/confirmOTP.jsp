<%-- 
    Document   : confirmOTP
    Created on : May 17, 2025, 11:57:55 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác minh OTP - FIELD MASTER</title>
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

        .otp-page {
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
            content: '📱';
            position: absolute;
            top: 15%;
            right: 10%;
            font-size: 4rem;
            opacity: 0.6;
            animation: pulse 2s ease-in-out infinite;
            filter: drop-shadow(0 0 20px rgba(59, 130, 246, 0.5));
        }

        @keyframes pulse {
            0%, 100% { 
                transform: scale(1);
                opacity: 0.6;
            }
            50% { 
                transform: scale(1.1);
                opacity: 0.8;
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

        /* OTP Input styling */
        .otp-section {
            margin-bottom: 2rem;
        }

        .otp-input-container {
            display: flex;
            justify-content: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .otp-digit {
            width: 50px;
            height: 50px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 600;
            border: 2px solid rgba(226, 232, 240, 0.8);
            border-radius: 12px;
            background: rgba(248, 250, 252, 0.9);
            color: #1e293b;
            transition: all 0.3s ease;
        }

        .otp-digit:focus {
            outline: none;
            border-color: #3b82f6;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            transform: scale(1.05);
        }

        .otp-digit.filled {
            border-color: #3b82f6;
            background: rgba(239, 246, 255, 1);
        }

        /* Hidden input for form submission */
        .hidden-otp-input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

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
            .otp-page {
                padding: 1rem;
            }
            
            .container {
                padding: 2rem 1.5rem;
            }
            
            .page-header h1 {
                font-size: 1.5rem;
            }
            
            .otp-digit {
                width: 45px;
                height: 45px;
                font-size: 1.25rem;
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
            
            .otp-digit {
                width: 40px;
                height: 40px;
                font-size: 1.1rem;
            }
            
            .otp-input-container {
                gap: 0.5rem;
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
    <div class="otp-page">
        <!-- Background decorations -->
        <div class="bg-decoration"></div>
        
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="icon-wrapper">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h1>Xác minh OTP</h1>
                <p>Chúng tôi đã gửi mã xác minh 6 chữ số đến số điện thoại/email của bạn</p>
            </div>

            <!-- Error Message (hidden by default) -->
            <div class="error-message" id="errorMessage" style="display: none;">
                <i class="fas fa-exclamation-triangle"></i>
                <span id="errorText">Mã OTP không đúng. Vui lòng thử lại.</span>
            </div>

            <!-- Success Message (hidden by default) -->
            <div class="success-message" id="successMessage" style="display: none;">
                <i class="fas fa-check-circle"></i>
                Xác minh thành công! Đang chuyển hướng...
            </div>

            <!-- OTP Form -->
            <form action="${pageContext.request.contextPath}/otp" method="post" id="otpForm">
                <div class="otp-section">
                    <div class="otp-input-container">
                        <input type="text" class="otp-digit" maxlength="1" data-index="0">
                        <input type="text" class="otp-digit" maxlength="1" data-index="1">
                        <input type="text" class="otp-digit" maxlength="1" data-index="2">
                        <input type="text" class="otp-digit" maxlength="1" data-index="3">
                        <input type="text" class="otp-digit" maxlength="1" data-index="4">
                        <input type="text" class="otp-digit" maxlength="1" data-index="5">
                    </div>
                    
                    <!-- Hidden input for form submission -->
                    <input type="hidden" name="otp" id="hiddenOtpInput" required>
                </div>

                <button type="submit" class="main-btn" id="verifyBtn" disabled>
                    Xác nhận OTP
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
        // OTP input handling
        const otpInputs = document.querySelectorAll('.otp-digit');
        const hiddenInput = document.getElementById('hiddenOtpInput');
        const verifyBtn = document.getElementById('verifyBtn');

        // OTP input logic
        otpInputs.forEach((input, index) => {
            input.addEventListener('input', function(e) {
                const value = e.target.value;
                
                // Only allow numbers
                if (!/^\d$/.test(value) && value !== '') {
                    e.target.value = '';
                    return;
                }
                
                if (value) {
                    input.classList.add('filled');
                    // Move to next input
                    if (index < otpInputs.length - 1) {
                        otpInputs[index + 1].focus();
                    }
                } else {
                    input.classList.remove('filled');
                }
                
                updateOTPValue();
            });
            
            input.addEventListener('keydown', function(e) {
                // Handle backspace
                if (e.key === 'Backspace' && !input.value && index > 0) {
                    otpInputs[index - 1].focus();
                    otpInputs[index - 1].value = '';
                    otpInputs[index - 1].classList.remove('filled');
                    updateOTPValue();
                }
                
                // Handle arrow keys
                if (e.key === 'ArrowLeft' && index > 0) {
                    otpInputs[index - 1].focus();
                }
                if (e.key === 'ArrowRight' && index < otpInputs.length - 1) {
                    otpInputs[index + 1].focus();
                }
            });
            
            input.addEventListener('paste', function(e) {
                e.preventDefault();
                const paste = (e.clipboardData || window.clipboardData).getData('text');
                const digits = paste.replace(/\D/g, '').slice(0, 6);
                
                digits.split('').forEach((digit, i) => {
                    if (i < otpInputs.length) {
                        otpInputs[i].value = digit;
                        otpInputs[i].classList.add('filled');
                    }
                });
                
                updateOTPValue();
                
                // Focus on the next empty input or the last one
                const nextEmpty = Math.min(digits.length, otpInputs.length - 1);
                otpInputs[nextEmpty].focus();
            });
        });

        function updateOTPValue() {
            const otp = Array.from(otpInputs).map(input => input.value).join('');
            hiddenInput.value = otp;
            verifyBtn.disabled = otp.length !== 6;
        }

        // Form submission
        document.getElementById('otpForm').addEventListener('submit', function(e) {
            const button = verifyBtn;
            const originalText = button.textContent;
            
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ĐANG XÁC MINH...';
            button.disabled = true;
            
            // Simulate verification process (remove in production)
            setTimeout(() => {
                // Show success message
                document.getElementById('successMessage').style.display = 'flex';
                
                // Hide form
                this.style.display = 'none';
                
                // Redirect after 2 seconds
                setTimeout(() => {
                    // window.location.href = '${pageContext.request.contextPath}/dashboard';
                }, 2000);
            }, 2000);
        });

        // Auto-focus first input on load
        window.addEventListener('load', () => {
            otpInputs[0].focus();
        });
    </script>
</body>
</html>