<!-- become-owner-request.jsp - UPDATED -->
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Làm Chủ Sân - FIELD MASTER</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
            color: #1e293b;
            line-height: 1.6;
            min-height: 100vh;
            padding: 2rem 0;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        /* Header */
        .header {
            text-align: center;
            margin-bottom: 3rem;
            padding: 2.5rem 0;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
        }

        .header-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            color: white;
            font-size: 1.5rem;
        }

        .header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .header p {
            color: #64748b;
            font-size: 1rem;
            max-width: 500px;
            margin: 0 auto;
        }

        /* Form Container */
        .form-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            padding: 2.5rem;
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            font-size: 0.875rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-danger {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .alert-success {
            background: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
        }

        /* Form Elements */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #374151;
            font-size: 0.875rem;
        }

        .required {
            color: #dc2626;
        }

        input, textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            background: white;
            font-size: 0.875rem;
            color: #1f2937;
            transition: all 0.2s ease;
            font-family: inherit;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .file-input-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px dashed #d1d5db;
            border-radius: 8px;
            background: #f9fafb;
            text-align: center;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .file-input:hover {
            border-color: #3b82f6;
            background: #f0f9ff;
        }

        .file-input.has-file {
            border-color: #10b981;
            background: #ecfdf5;
            color: #047857;
        }

        .file-help-text {
            font-size: 0.75rem;
            color: #6b7280;
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        /* Buttons */
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #f1f5f9;
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
            font-family: inherit;
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

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 1rem 0;
            }
            
            .container {
                padding: 0 1rem;
            }
            
            .header {
                padding: 2rem 1rem;
            }
            
            .header h1 {
                font-size: 1.5rem;
            }
            
            .form-container {
                padding: 2rem 1.5rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-icon">
                <i class="fas fa-store"></i>
            </div>
            <h1>Đăng Ký Làm Chủ Sân</h1>
            <p>Gửi đơn đăng ký để trở thành chủ sân và bắt đầu quản lý cơ sở thể thao của bạn</p>
        </div>
        
        <div class="form-container">
            <!-- Display error if exists -->
            <% if (session.getAttribute("ownerRequestError") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= session.getAttribute("ownerRequestError") %>
                </div>
                <% session.removeAttribute("ownerRequestError"); %>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/submit-owner-request" method="post" enctype="multipart/form-data">
                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">Họ và Tên <span class="required">*</span></label>
                        <input type="text" id="fullName" name="fullName"
                               value="${currentUser != null ? currentUser.fullName : ''}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Địa Chỉ Email <span class="required">*</span></label>
                        <input type="email" id="email" name="email"
                               value="${currentUser != null ? currentUser.email : ''}" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="phone">Số Điện Thoại <span class="required">*</span></label>
                    <input type="tel" id="phone" name="phone" required placeholder="Nhập số điện thoại của bạn">
                </div>
                
                <div class="form-group">
                    <label for="businessLicense">Giấy Phép Kinh Doanh (PDF)</label>
                    <div class="file-input-wrapper">
                        <input type="file" id="businessLicense" name="businessLicense"
                               accept="application/pdf" class="file-input" 
                               onchange="updateFileInput(this)">
                    </div>
                    <div class="file-help-text">
                        <i class="fas fa-info-circle"></i>
                        Tải lên giấy phép kinh doanh định dạng PDF (không bắt buộc)
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="message">Lời Nhắn / Lý Do Đăng Ký</label>
                    <textarea id="message" name="message" rows="4" 
                              placeholder="Chia sẻ kinh nghiệm, kế hoạch kinh doanh hoặc lý do bạn muốn trở thành chủ sân..."></textarea>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i>
                        Gửi Đơn Đăng Ký
                    </button>
                    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Hủy Bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        function updateFileInput(input) {
            if (input.files && input.files[0]) {
                input.classList.add('has-file');
                const fileName = input.files[0].name;
                input.setAttribute('data-file', fileName);
                
                // Create a visual indicator
                let indicator = input.parentNode.querySelector('.file-indicator');
                if (!indicator) {
                    indicator = document.createElement('div');
                    indicator.className = 'file-indicator';
                    indicator.style.cssText = `
                        margin-top: 0.5rem;
                        padding: 0.5rem;
                        background: #ecfdf5;
                        border: 1px solid #10b981;
                        border-radius: 6px;
                        font-size: 0.75rem;
                        color: #047857;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    `;
                    input.parentNode.appendChild(indicator);
                }
                indicator.innerHTML = `<i class="fas fa-file-pdf"></i> ${fileName}`;
            } else {
                input.classList.remove('has-file');
                const indicator = input.parentNode.querySelector('.file-indicator');
                if (indicator) {
                    indicator.remove();
                }
            }
        }
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const phone = document.getElementById('phone').value.trim();
            
            if (phone && !/^\d{10,}$/.test(phone.replace(/[\s\-\(\)]/g, ''))) {
                e.preventDefault();
                alert('Vui lòng nhập số điện thoại hợp lệ (ít nhất 10 chữ số)');
                return false;
            }
        });
    </script>
</body>
</html>