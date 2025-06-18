<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cài đặt</title>
    <link rel="stylesheet" href="assets/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', sans-serif;
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            min-height: 100vh;
        }

        .main-container {
            display: flex;
        }

        .settings-container {
            margin-left: 250px;
            padding: 40px;
            width: calc(100% - 250px);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            min-height: 100vh;
            border-radius: 20px 0 0 0;
            box-shadow: -10px 0 30px rgba(0, 0, 0, 0.1);
        }

        .settings-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .settings-header h2 {
            font-size: 28px;
            color: #2d3748;
            margin: 0;
            position: relative;
        }

        .settings-header h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 50px;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        .section-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            border: 1px solid #f0f0f0;
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #4a5568;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: background-color 0.3s ease, transform 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
            margin-left: 10px;
        }

        .btn-secondary:hover {
            background: #cbd5e0;
        }

        .profile-section {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #d1d5db;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        .profile-info {
            display: flex;
            flex-direction: column;
        }

        .profile-name {
            font-size: 20px;
            font-weight: 600;
            color: #2d3748;
        }

        .profile-email {
            font-size: 14px;
            color: #718096;
        }

        .settings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
        }

        .form-actions {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
        }

        /* Ripple Animation */
        .btn {
            position: relative;
            overflow: hidden;
        }

        .ripple-effect {
            position: absolute;
            border-radius: 50%;
            transform: scale(0);
            animation: ripple 0.6s ease-out;
            background: rgba(255, 255, 255, 0.7);
            transform: scale(0);
            animation: ripple 0.6s ease-out;
        }

        @keyframes ripple {
            to {
                transform: scale(2);
                opacity: 0;
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .settings-container {
                margin-left: 0;
                padding: 20px;
            }

            .profile-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .settings-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="main-container">
    <%@ include file="sidebar.jsp" %>

    <div class="settings-container">

        <div class="settings-header">
            <h2><i class="fas fa-cog"></i> Cài đặt tài khoản</h2>
        </div>

        <!-- Thông tin người dùng -->
        <div class="profile-section">
            <div class="avatar">${fn:substring(user.fullName, 0, 1)}</div>
            <div class="profile-info">
                <div class="profile-name">${user.fullName}</div>
                <div class="profile-email">${user.email}</div>
            </div>
        </div>

        <!-- Cài đặt tài khoản -->
        <div class="section-card">
            <div class="section-title"><i class="fas fa-user-cog"></i> Thông tin tài khoản</div>
            <form id="accountForm">
                <div class="form-group">
                    <label for="fullName">Họ tên</label>
                    <input type="text" id="fullName" value="${user.fullName}" placeholder="Nhập họ tên mới">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" value="${user.email}" disabled>
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="text" id="phone" value="${user.phone}" placeholder="Nhập số điện thoại">
                </div>
                <div class="form-group">
                    <label for="dob">Ngày sinh</label>
                    <input type="date" id="dob" value="<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd' />">
                </div>
                <div class="form-group">
                    <label for="address">Địa chỉ</label>
                    <input type="text" id="address" value="${user.address}" placeholder="Nhập địa chỉ">
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="resetAccountForm()">Huỷ</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>

        <!-- Đổi mật khẩu -->
        <div class="section-card">
            <div class="section-title"><i class="fas fa-lock"></i> Đổi mật khẩu</div>
            <form id="passwordForm">
                <div class="form-group">
                    <label for="oldPassword">Mật khẩu hiện tại</label>
                    <input type="password" id="oldPassword" placeholder="Nhập mật khẩu cũ">
                </div>
                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới</label>
                    <input type="password" id="newPassword" placeholder="Nhập mật khẩu mới">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                    <input type="password" id="confirmPassword" placeholder="Xác nhận mật khẩu">
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="resetPasswordForm()">Huỷ</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-key"></i> Cập nhật mật khẩu
                    </button>
                </div>
            </form>
        </div>

        <!-- Tùy chọn nâng cao -->
        <div class="section-card">
            <div class="section-title"><i class="fas fa-bell"></i> Thông báo & Bảo mật</div>
            <div class="form-group">
                <label>
                    <input type="checkbox" checked> Nhận thông báo qua email khi có cập nhật
                </label>
            </div>
            <div class="form-group">
                <label>
                    <input type="checkbox"> Kích hoạt xác thực hai bước
                </label>
            </div>
            <div class="form-group">
                <label>
                    <input type="checkbox"> Ghi nhớ thiết bị đăng nhập
                </label>
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-primary" onclick="saveSettings()">
                    <i class="fas fa-check-circle"></i> Lưu cài đặt
                </button>
            </div>
        </div>

    </div>
</div>

<!-- Ripple JS -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(btn => {
            btn.addEventListener('click', function (e) {
                if (!this.classList.contains('btn-disabled')) {
                    e.preventDefault();
                }
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                ripple.style.cssText = `
                    position: absolute;
                    width: ${size}px;
                    height: ${size}px;
                    background: rgba(255, 255, 255, 0.6);
                    border-radius: 50%;
                    left: ${e.clientX - rect.left - size / 2}px;
                    top: ${e.clientY - rect.top - size / 2}px;
                    transform: scale(0);
                    animation: ripple 0.6s ease-out;
                    pointer-events: none;
                `;
                this.appendChild(ripple);
                setTimeout(() => ripple.remove(), 600);
            });
        });
    });

    const style = document.createElement('style');
    style.textContent = `
        @keyframes ripple {
            to {
                transform: scale(2);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);

    // Hàm reset form thông tin tài khoản
    function resetAccountForm() {
        document.getElementById("fullName").value = "${user.fullName}";
        document.getElementById("phone").value = "${user.phone}";
        document.getElementById("dob").value = "<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd' />";
        document.getElementById("address").value = "${user.address}";
    }

    // Hàm reset form mật khẩu
    function resetPasswordForm() {
        document.getElementById("oldPassword").value = "";
        document.getElementById("newPassword").value = "";
        document.getElementById("confirmPassword").value = "";
    }

    // Hàm lưu thông tin tài khoản
    document.getElementById("accountForm").addEventListener("submit", function (e) {
        e.preventDefault();
        alert("Thông tin tài khoản đã được cập nhật thành công!");
    });

    // Hàm lưu mật khẩu
    document.getElementById("passwordForm").addEventListener("submit", function (e) {
        e.preventDefault();
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        if (newPassword !== confirmPassword) {
            alert("Mật khẩu không khớp!");
        } else {
            alert("Mật khẩu đã được cập nhật!");
        }
    });

    // Hàm lưu cài đặt chung
    function saveSettings() {
        alert("Cài đặt đã được lưu thành công.");
    }
</script>

</body>
</html>