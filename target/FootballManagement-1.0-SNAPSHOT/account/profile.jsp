<%@ page import="model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Football Profile Manager</title>
        <link rel="stylesheet" href="../css/profile.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/country-select-js@2.0.0/build/css/countrySelect.min.css"> 
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>
                    <div class="football-icon">⚽</div>
                    Quản Lý Hồ Sơ 
                </h1>
            </div>
            <div class="profile-container">
                <div class="profile-sidebar">
                    <div class="profile-avatar">
                        <%
                            String avatar = (String) session.getAttribute("avatar"); 
                            if (avatar == null || avatar.isEmpty()) {
                        %>
                        <div class="avatar-circle">👤</div>
                        <%
                            } else {
                        %>
                        <div class="avatar-circle" style="background-image: url('<%= request.getContextPath() + "/" + avatar %>'); background-size: cover;"></div>
                        <%
                            }
                        %>
                        <form action="${pageContext.request.contextPath}/uploadAvatar" method="post" enctype="multipart/form-data" style="margin-top: 10px;">
                            <input type="file" name="avatar" accept="image/*" required>
                            <button type="submit" class="upload-btn">Tải Ảnh Đại Diện</button>
                        </form>
                    </div>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <button class="nav-link active" onclick="showSection('personal-info')">
                                👤 Thông Tin Cá Nhân
                            </button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" onclick="showSection('security')">
                                🔒 Bảo Mật
                            </button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" onclick="showSection('preferences')">
                                ⚙️ Tuỳ Chọn
                            </button>
                        </li>
                    </ul>
                </div>
                <div class="main-content">
                    <div id="notification" class="notification"></div>
                    <div id="personal-info" class="section active">
                        <h2 class="section-title">Thông Tin Cá Nhân</h2>
                        <%
    User currentUser = (User) session.getAttribute("currentUser");
    int userId = 0;
    String fullName = "";
    String email = "";
    String phone = "";
    String birthdate = "";
    String address = "";
    if (currentUser != null) {
        userId = currentUser.getUserID();
        fullName = currentUser.getFullName();
        email = currentUser.getEmail();
        phone = currentUser.getPhone();
        if (currentUser.getDateOfBirth() != null) {
            birthdate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(currentUser.getDateOfBirth());
        }
        address = currentUser.getAddress();
    } else {
        response.sendRedirect(request.getContextPath() + "/account/login.jsp");
        return;
    }
                        %>

                        <form id="personalInfoForm" action="${pageContext.request.contextPath}/updateProfile" method="post">
                            <input type="hidden" name="userId" value="<%= ((User) session.getAttribute("currentUser")).getUserID() %>" />
                            <div class="form-group">
                                <label for="fullName">Họ và Tên</label>
                                <input type="text" id="fullName" name="fullName" value="<%= fullName %>" required />
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" value="<%= email %>" readonly style="background-color: #e9ecef; cursor: not-allowed;">
                                    <small class="email-note">Lưu ý: Email không thể thay đổi.</small>
                                </div>
                                <div class="form-group">
                                    <label for="phone">Số Điện Thoại</label>
                                    <input type="tel" id="phone" name="phone" value="<%= phone %>" pattern="\d{10,}" required />
                                    <small>Ví dụ: 0909123456</small>
                                    <div id="phoneError" style="color: red; font-size: 0.9em; margin-top: 5px;"></div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="birthdate">Ngày Sinh</label>
                                    <input type="date" id="birthdate" name="birthdate" value="<%= birthdate %>" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="address">Địa Chỉ</label>
                                <textarea id="address" name="address" rows="3"><%= currentUser.getAddress() != null ? currentUser.getAddress() : "" %></textarea>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">Cập Nhật Thông Tin</button>
                                <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-primary">🏠 Trang Chủ</a>
                            </div>
                        </form>
                    </div>


                    <div id="security" class="section">
                        <h2 class="section-title">Bảo Mật</h2>
                        <div style="margin-bottom: 30px;">
                            <h3>Đổi Mật Khẩu</h3>
                            <form id="passwordForm">
                                <div class="form-group">
                                    <label for="currentPassword">Mật Khẩu Hiện Tại</label>
                                    <input type="password" id="currentPassword" name="currentPassword" required>
                                </div>
                                <div class="form-group">
                                    <label for="newPassword">Mật Khẩu Mới</label>
                                    <input type="password" id="newPassword" name="newPassword" required>
                                </div>
                                <div class="form-group">
                                    <label for="confirmPassword">Xác Nhận Mật Khẩu Mới</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Đổi Mật Khẩu</button>
                            </form>
                        </div>
                        <div style="margin-bottom: 30px;">
                            <h3>Xác Thực Hai Lớp</h3>
                            <p>Thêm lớp bảo mật cho tài khoản của bạn</p>
                            <button class="btn btn-success" onclick="enable2FA()">Bật 2FA</button>
                        </div>
                        <div>
                            <h3>Phiên Đăng Nhập</h3>
                            <p>Quản lý các phiên đăng nhập hiện tại</p>
                            <button class="btn btn-danger" onclick="logoutAllSessions()">Đăng Xuất Tất Cả Phiên Khác</button>
                        </div>
                    </div>


                    <div id="preferences" class="section">
                        <h2 class="section-title">Tuỳ Chọn</h2>
                        <form id="preferencesForm">
                            <div class="form-group">
                                <label for="language">Ngôn Ngữ</label>
                                <select id="language" name="language">
                                    <option value="en" <%= "en".equals("en") ? "selected" : "" %>>Tiếng Anh</option>
                                    <option value="es">Tiếng Tây Ban Nha</option>
                                    <option value="fr">Tiếng Pháp</option>
                                    <option value="de">Tiếng Đức</option>
                                    <option value="it">Tiếng Ý</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="timezone">Múi Giờ</label>
                                <select id="timezone" name="timezone">
                                    <option value="utc-5" selected>Giờ Miền Đông (UTC-5)</option>
                                    <option value="utc-6">Giờ Miền Trung (UTC-6)</option>
                                    <option value="utc-7">Giờ Miền Núi (UTC-7)</option>
                                    <option value="utc-8">Giờ Miền Tây (UTC-8)</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <h3>Tuỳ Chọn Thông Báo</h3>
                                <div style="margin: 10px 0;">
                                    <input type="checkbox" id="emailNotifications" name="emailNotifications" checked>
                                    <label for="emailNotifications" style="display: inline; margin-left: 8px;">Nhận Email Thông Báo</label>
                                </div>
                                <div style="margin: 10px 0;">
                                    <input type="checkbox" id="matchReminders" name="matchReminders" checked>
                                    <label for="matchReminders" style="display: inline; margin-left: 8px;">Nhắc Nhở Trận Đấu</label>
                                </div>
                                <div style="margin: 10px 0;">
                                    <input type="checkbox" id="teamUpdates" name="teamUpdates" checked>
                                    <label for="teamUpdates" style="display: inline; margin-left: 8px;">Cập Nhật Đội Bóng</label>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">Lưu Tuỳ Chọn</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script> 
        <script src="https://cdn.jsdelivr.net/npm/country-select-js@2.0.0/build/js/countrySelect.min.js"></script> 
        <script>

                                document.querySelector('form').addEventListener('submit', function (e) {
                                    const phoneInput = document.getElementById('phone');
                                    const errorDiv = document.getElementById('phoneError');
                                    let phoneValue = phoneInput.value.replace(/\D+/g, '');
                                    if (!phoneValue) {
                                        errorDiv.textContent = 'Vui lòng nhập số điện thoại.';
                                        e.preventDefault();
                                        return;
                                    }
                                    if (!phoneValue.startsWith('0')) {
                                        errorDiv.textContent = 'Số điện thoại phải bắt đầu bằng số 0.';
                                        e.preventDefault();
                                        return;
                                    }
                                    if (phoneValue.length < 10) {
                                        errorDiv.textContent = 'Số điện thoại phải có ít nhất 10 chữ số.';
                                        e.preventDefault();
                                        return;
                                    }
                                    errorDiv.textContent = '';
                                });
                                document.getElementById('phone').addEventListener('input', function () {
                                    const phoneInput = this;
                                    const errorDiv = document.getElementById('phoneError');
                                    let phoneValue = phoneInput.value.replace(/\D+/g, '');

                                    if (!phoneValue) {
                                        errorDiv.textContent = 'Vui lòng nhập số điện thoại.';
                                    } else if (!phoneValue.startsWith('0')) {
                                        errorDiv.textContent = 'Số điện thoại phải bắt đầu bằng số 0.';
                                    } else if (phoneValue.length < 10) {
                                        errorDiv.textContent = 'Số điện thoại phải có ít nhất 10 chữ số.';
                                    } else {
                                        errorDiv.textContent = '';
                                    }
                                });
        </script>
        <script>
            $(document).ready(function () {
                $("#nationality").countrySelect({
                    preferredCountries: ['vn', 'us', 'gb']
                });
            });
            function showSection(sectionId) {
                const sections = document.querySelectorAll('.section');
                sections.forEach(section => section.classList.remove('active'));
                const navLinks = document.querySelectorAll('.nav-link');
                navLinks.forEach(link => link.classList.remove('active'));

                document.getElementById(sectionId).classList.add('active');
                event.target.classList.add('active');
            }
            function showNotification(message, type = 'success') {
                const notification = document.getElementById('notification');
                notification.textContent = message;
                notification.className = `notification ${type}`;
                notification.style.display = 'block';
                setTimeout(() => {
                    notification.style.display = 'none';
                }, 3000);
            }
            document.getElementById('passwordForm').addEventListener('submit', function (e) {
                e.preventDefault();
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                if (newPassword !== confirmPassword) {
                    showNotification('Mật khẩu không khớp!', 'error');
                    return;
                }
                showNotification('Mật khẩu đã được đổi thành công!', 'success');
                this.reset();
            });
            document.getElementById('preferencesForm').addEventListener('submit', function (e) {
                e.preventDefault();
                showNotification('Tuỳ chọn đã lưu thành công!', 'success');
            });
        </script>
    </body>
</html>