<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/account/login.jsp");
        return;
    }
    String avatarUrl = null;
    if (currentUser.getAvatarUrl() != null && !currentUser.getAvatarUrl().isEmpty()) {
        String avatar = currentUser.getAvatarUrl();
        boolean isFullUrl = avatar.startsWith("http://") || avatar.startsWith("https://");
        avatarUrl = isFullUrl ? avatar : (request.getContextPath() + "/" + avatar);
    }
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    String error = (String) session.getAttribute("error");
    String success = (String) session.getAttribute("success");
    if (error != null) { errorMessage = error; session.removeAttribute("error"); }
    if (success != null) { successMessage = success; session.removeAttribute("success"); }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Hồ Sơ - FIELD MASTER</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/country-select-js @2.0.0/build/css/countrySelect.min.css" />
        
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
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem;
            }

            /* Header */
            .header {
                text-align: center;
                margin-bottom: 3rem;
                padding: 2.5rem 0;
                background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
                color: white;
                border-radius: 16px;
                position: relative;
                overflow: hidden;
            }

            .header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                opacity: 0.6;
            }

            .header h1 {
                font-size: 2.5rem;
                font-weight: 700;
                letter-spacing: -0.025em;
                position: relative;
                z-index: 1;
            }

            .header .subtitle {
                font-size: 1.125rem;
                opacity: 0.9;
                margin-top: 0.5rem;
                font-weight: 400;
                position: relative;
                z-index: 1;
            }

            /* Profile Layout */
            .profile-container {
                display: grid;
                grid-template-columns: 320px 1fr;
                gap: 2rem;
                margin-bottom: 2rem;
            }

            .profile-sidebar {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                height: fit-content;
                overflow: hidden;
            }

            .profile-avatar {
                text-align: center;
                padding: 2rem 1.5rem 1.5rem;
                background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
                border-bottom: 1px solid #e2e8f0;
            }

            .avatar-circle {
                width: 100px;
                height: 100px;
                background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
                border-radius: 50%;
                margin: 0 auto 1rem;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.5rem;
                color: white;
                position: relative;
                overflow: hidden;
                transition: transform 0.2s ease;
            }

            .avatar-circle:hover {
                transform: scale(1.05);
            }

            .upload-btn {
                background: #3b82f6;
                color: white;
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 6px;
                font-size: 0.875rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
                margin-top: 0.75rem;
            }

            .upload-btn:hover {
                background: #2563eb;
                transform: translateY(-1px);
            }

            input[type="file"] {
                font-size: 0.75rem;
                margin-bottom: 0.5rem;
                padding: 0.25rem;
                border: 1px dashed #cbd5e1;
                border-radius: 4px;
                background: #f8fafc;
            }

            /* Navigation */
            .nav-menu {
                list-style: none;
                padding: 0;
            }

            .nav-link {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 1rem 1.5rem;
                color: #64748b;
                font-size: 0.875rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
                border: none;
                background: none;
                width: 100%;
                text-align: left;
                border-bottom: 1px solid #f1f5f9;
            }

            .nav-link:hover {
                background: #f8fafc;
                color: #3b82f6;
            }

            .nav-link.active {
                background: #eff6ff;
                color: #3b82f6;
                border-right: 3px solid #3b82f6;
            }

            .nav-link i {
                width: 16px;
                text-align: center;
                font-size: 0.875rem;
            }

            /* Main Content */
            .main-content {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                min-height: 600px;
            }

            .section {
                display: none;
                padding: 2rem;
            }

            .section.active {
                display: block;
            }

            .section h2 {
                font-size: 1.5rem;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 1.5rem;
                padding-bottom: 0.75rem;
                border-bottom: 2px solid #f1f5f9;
            }

            .section h3, .section h4 {
                color: #374151;
                font-weight: 600;
                margin: 1.5rem 0 1rem 0;
                font-size: 1.125rem;
            }

            /* Forms */
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

            input, select, textarea {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                background: white;
                font-size: 0.875rem;
                color: #1f2937;
                transition: all 0.2s ease;
            }

            input:focus, select:focus, textarea:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            input[readonly] {
                background: #f9fafb;
                color: #6b7280;
            }

            textarea {
                resize: vertical;
                min-height: 80px;
            }

            small {
                color: #6b7280;
                font-size: 0.75rem;
                margin-top: 0.25rem;
                display: block;
            }

            /* Password input groups */
            .password-group {
                position: relative;
            }

            .password-group input {
                padding-right: 3rem;
            }

            .toggle-password {
                position: absolute;
                right: 0.75rem;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: rgba(100, 116, 139, 0.7);
                cursor: pointer;
                padding: 0.5rem;
                transition: color 0.3s ease;
                z-index: 3;
            }

            .toggle-password:hover {
                color: #3b82f6;
            }

            .toggle-password:focus {
                outline: 2px solid #3b82f6;
                outline-offset: 2px;
                border-radius: 4px;
            }

            /* Buttons */
            .btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 6px;
                font-size: 0.875rem;
                font-weight: 500;
                text-decoration: none;
                cursor: pointer;
                transition: all 0.2s ease;
                margin-right: 0.75rem;
                margin-bottom: 0.5rem;
            }

            .btn-primary {
                background: #3b82f6;
                color: white;
            }

            .btn-primary:hover {
                background: #2563eb;
                transform: translateY(-1px);
            }

            .btn-success {
                background: #10b981;
                color: white;
            }

            .btn-success:hover {
                background: #059669;
                transform: translateY(-1px);
            }

            .btn-warning {
                background: #f59e0b;
                color: white;
            }

            .btn-warning:hover {
                background: #d97706;
                transform: translateY(-1px);
            }

            .btn-danger {
                background: #ef4444;
                color: white;
            }

            .btn-danger:hover {
                background: #dc2626;
                transform: translateY(-1px);
            }

            /* Notifications */
            .notification {
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 1.5rem;
                font-size: 0.875rem;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .notification.success {
                background: #ecfdf5;
                color: #047857;
                border: 1px solid #a7f3d0;
            }

            .notification.error {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fecaca;
            }

            .error-message {
                color: #dc2626;
                font-size: 0.75rem;
                margin-top: 0.25rem;
            }

            /* Form Actions */
            .form-actions {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                flex-wrap: wrap;
                margin-top: 2rem;
                padding-top: 1.5rem;
                border-top: 1px solid #f1f5f9;
            }

            /* Checkboxes */
            input[type="checkbox"] {
                width: auto;
                margin-right: 0.5rem;
                accent-color: #3b82f6;
            }

            /* Country selector */
            .country-select {
                position: relative;
                z-index: 999;
            }

            .country-list {
                z-index: 10000 !important;
                position: absolute !important;
                background: white;
                max-height: 200px;
                overflow-y: auto;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                width: 100%;
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            }

            /* Responsive */
            @media (max-width: 1024px) {
                .profile-container {
                    grid-template-columns: 1fr;
                    gap: 1.5rem;
                }
                
                .container {
                    padding: 1rem;
                }
            }

            @media (max-width: 768px) {
                .header h1 {
                    font-size: 2rem;
                }
                
                .form-row {
                    grid-template-columns: 1fr;
                }
                
                .form-actions {
                    flex-direction: column;
                    align-items: stretch;
                }
                
                .btn {
                    margin: 0 0 0.5rem 0;
                    justify-content: center;
                }
                
                .section {
                    padding: 1.5rem;
                }
            }

            /* Subtle animations */
            .profile-sidebar, .main-content {
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

            /* Accent colors for vibrancy */
            .accent-blue { color: #3b82f6; }
            .accent-green { color: #10b981; }
            .accent-orange { color: #f59e0b; }
            .accent-red { color: #ef4444; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Quản Lý Hồ Sơ</h1>
                <p class="subtitle">Quản lý cài đặt tài khoản và tùy chọn của bạn</p>
            </div>
            
            <div class="profile-container">
                <div class="profile-sidebar">
                    <div class="profile-avatar">
                        <% if (avatarUrl != null) { %>
                        <div class="avatar-circle" style="background-image: url('<%= avatarUrl %>'); background-size: cover; background-position: center;"></div>
                        <% } else { %>
                        <div class="avatar-circle">
                            <i class="fas fa-user"></i>
                        </div>
                        <% } %>
                        <form action="<%= request.getContextPath() %>/uploadAvatar" method="post" enctype="multipart/form-data">
                            <input type="file" name="avatar" accept="image/*" required />
                            <button type="submit" class="upload-btn">Tải Ảnh Đại Diện</button>
                        </form>
                    </div>
                    <ul class="nav-menu">
                        <li><button class="nav-link active" onclick="showSection('personal-info')"><i class="fas fa-user"></i> Thông Tin Cá Nhân</button></li>
                        <li><button class="nav-link" onclick="showSection('security')"><i class="fas fa-shield-alt"></i> Bảo Mật</button></li>
                        <li><button class="nav-link" onclick="showSection('preferences')"><i class="fas fa-cog"></i> Tùy Chọn</button></li>
                    </ul>
                </div>
                
                <div class="main-content">
                    <% if (errorMessage != null) { %>
                    <div class="notification error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= errorMessage %>
                    </div>
                    <% } else if (successMessage != null) { %>
                    <div class="notification success">
                        <i class="fas fa-check-circle"></i>
                        <%= successMessage %>
                    </div>
                    <% } %>
                    
                    <div id="personal-info" class="section active">
                        <h2>Thông Tin Cá Nhân</h2>
                        <form id="personalInfoForm" action="<%= request.getContextPath() %>/updateProfile" method="post">
                            <input type="hidden" name="userId" value="<%= currentUser.getUserID() %>"/>
                            
                            <div class="form-group">
                                <label>Họ và Tên</label>
                                <input type="text" name="fullName" value="<%= currentUser.getFullName() %>" required/>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Địa Chỉ Email</label>
                                    <input type="email" value="<%= currentUser.getEmail() %>" readonly/>
                                    <small>Địa chỉ email không thể thay đổi</small>
                                </div>
                                <div class="form-group">
                                    <label>Số Điện Thoại</label>
                                    <input type="tel" id="phone" name="phone" value="<%= currentUser.getPhone() %>" pattern="0\d{9,}" required />
                                    <div id="phoneError" class="error-message"></div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Vai Trò</label>
                                <input type="text" value="<%= currentUser.getRole() %>" readonly/>
                            </div>
                            
                            <div class="form-group">
                                <label>Ngày Sinh</label>
                                <input type="date" id="birthdate" name="birthdate" value="<%= currentUser.getDateOfBirth() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(currentUser.getDateOfBirth()) : "" %>"/>
                                <div id="birthdateError" class="error-message"></div>
                            </div>
                            
                            <div class="form-group">
                                <label>Địa Chỉ</label>
                                <textarea name="address" rows="3" placeholder="Nhập địa chỉ của bạn"><%= currentUser.getAddress() != null ? currentUser.getAddress() : "" %></textarea>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Cập Nhật Hồ Sơ
                                </button>
                                <a href="<%= request.getContextPath() %>/home.jsp" class="btn btn-success">
                                    <i class="fas fa-home"></i> Trang Chủ
                                </a>
                                <% if (currentUser.isAdmin()) { %>
                                <a href="<%= request.getContextPath() %>/adminDashboard" class="btn btn-warning">
                                    <i class="fas fa-tools"></i> Trang Quản Trị
                                </a>
                                <% } %>
                            </div>
                        </form>
                    </div>
                    
                    <div id="security" class="section">
                        <h2>Cài Đặt Bảo Mật</h2>
                        <h4>Đổi Mật Khẩu</h4>
                        <form id="passwordForm" method="post" action="<%= request.getContextPath() %>/changePassword">
                            <div class="form-group">
                                <label>Mật Khẩu Hiện Tại</label>
                                <div class="password-group">
                                    <input type="password" name="currentPassword" id="currentPassword" required/>
                                    <button type="button" class="toggle-password" data-target="currentPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Mật Khẩu Mới</label>
                                <div class="password-group">
                                    <input type="password" id="newPassword" name="newPassword" required/>
                                    <button type="button" class="toggle-password" data-target="newPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div id="passwordError" class="error-message"></div>
                            </div>
                            <div class="form-group">
                                <label>Xác Nhận Mật Khẩu Mới</label>
                                <div class="password-group">
                                    <input type="password" id="confirmPassword" name="confirmPassword" required/>
                                    <button type="button" class="toggle-password" data-target="confirmPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-key"></i> Đổi Mật Khẩu
                            </button>
                        </form>
                        
                        <h3>Quản Lý Phiên</h3>
                        <button class="btn btn-danger" onclick="alert('Tính năng này đang được phát triển')">
                            <i class="fas fa-sign-out-alt"></i> Đăng Xuất Tất Cả Phiên
                        </button>
                    </div>
                    
                    <div id="preferences" class="section">
                        <h2>Tùy Chọn</h2>
                        <form>
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Ngôn Ngữ</label>
                                    <select name="language">
                                        <option value="vi" selected>Tiếng Việt</option>
                                        <option value="en">English</option>
                                        <option value="fr">Français</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Múi Giờ</label>
                                    <select name="timezone">
                                        <option value="utc+7" selected>UTC+7 (Việt Nam)</option>
                                        <option value="utc-5">UTC-5</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Tùy Chọn Thông Báo</label>
                                <div style="margin-top: 0.5rem;">
                                    <label style="font-weight: 400; margin-bottom: 0.5rem;">
                                        <input type="checkbox" name="emailNotifications" checked/> Thông báo qua email
                                    </label>
                                    <label style="font-weight: 400; margin-bottom: 0.5rem;">
                                        <input type="checkbox" name="matchReminders" checked/> Nhắc nhở trận đấu
                                    </label>
                                    <label style="font-weight: 400; margin-bottom: 0;">
                                        <input type="checkbox" name="teamUpdates" checked/> Cập nhật đội bóng
                                    </label>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Lưu Tùy Chọn
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/jquery @3.6.4/dist/jquery.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Password toggle functionality
                const toggleButtons = document.querySelectorAll('.toggle-password');
                
                toggleButtons.forEach(button => {
                    button.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        const targetId = this.getAttribute('data-target');
                        const passwordInput = document.getElementById(targetId);
                        const icon = this.querySelector('i');
                        
                        if (passwordInput) {
                            if (passwordInput.type === 'password') {
                                passwordInput.type = 'text';
                                icon.className = 'fas fa-eye-slash';
                            } else {
                                passwordInput.type = 'password';
                                icon.className = 'fas fa-eye';
                            }
                        }
                    });
                });

                // Form validation for password change
                document.getElementById('passwordForm').addEventListener('submit', function (e) {
                    const newPass = document.getElementById('newPassword').value;
                    const confirm = document.getElementById('confirmPassword').value;
                    
                    if (newPass !== confirm) {
                        alert("Xác nhận mật khẩu không khớp");
                        e.preventDefault();
                        return false;
                    }
                    
                    if (!/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/.test(newPass)) {
                        alert("Mật khẩu phải có ít nhất 8 ký tự bao gồm 1 chữ hoa, 1 chữ thường và 1 số.");
                        e.preventDefault();
                        return false;
                    }
                });
                
                // Birthdate validation
                document.getElementById('birthdate').addEventListener('change', function () {
                    const date = new Date(this.value);
                    if (date >= new Date()) {
                        document.getElementById('birthdateError').textContent = "Ngày sinh không thể ở tương lai.";
                        this.setCustomValidity("Ngày sinh không hợp lệ.");
                    } else {
                        document.getElementById('birthdateError').textContent = "";
                        this.setCustomValidity("");
                    }
                });
                
                // Phone validation
                document.getElementById('phone').addEventListener('input', function () {
                    const value = this.value.replace(/\D/g, '');
                    const errorDiv = document.getElementById('phoneError');
                    if (!value.startsWith('0') || value.length < 10) {
                        errorDiv.textContent = "Số điện thoại hợp lệ phải bắt đầu bằng 0 và có ít nhất 10 chữ số.";
                    } else {
                        errorDiv.textContent = "";
                    }
                });
            });

            // Section navigation
            function showSection(sectionId) {
                document.querySelectorAll('.section').forEach(sec => sec.classList.remove('active'));
                document.getElementById(sectionId).classList.add('active');
                document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
                document.querySelector(`.nav-link[onclick*="${sectionId}"]`).classList.add('active');
            }
        </script>
    </body>
</html>