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
        <title>Hồ Sơ</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/profile.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/country-select-js @2.0.0/build/css/countrySelect.min.css" />
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1><div class="football-icon">⚽</div> Quản Lý Hồ Sơ</h1>
            </div>
            <div class="profile-container">
                <div class="profile-sidebar">
                    <div class="profile-avatar">
                        <% if (avatarUrl != null) { %>
                        <div class="avatar-circle" style="background-image: url('<%= avatarUrl %>'); background-size: cover; background-position: center;"></div>
                        <% } else { %>
                        <div class="avatar-circle">👤</div>
                        <% } %>
                        <form action="<%= request.getContextPath() %>/uploadAvatar" method="post" enctype="multipart/form-data" style="margin-top: 10px;">
                            <input type="file" name="avatar" accept="image/*" required />
                            <button type="submit" class="upload-btn">Tải Ảnh Đại Diện</button>
                        </form>
                    </div>
                    <ul class="nav-menu">
                        <li><button class="nav-link active" onclick="showSection('personal-info')">👤 Thông Tin Cá Nhân</button></li>
                        <li><button class="nav-link" onclick="showSection('security')">🔒 Bảo Mật</button></li>
                        <li><button class="nav-link" onclick="showSection('preferences')">⚙️ Tuỳ Chọn</button></li>
                    </ul>
                </div>
                <div class="main-content">
                    <% if (errorMessage != null) { %>
                    <div class="notification error">❌ <%= errorMessage %></div>
                    <% } else if (successMessage != null) { %>
                    <div class="notification success">✅ <%= successMessage %></div>
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
                                    <label>Email</label>
                                    <input type="email" value="<%= currentUser.getEmail() %>" readonly style="background-color:#e9ecef;"/>
                                    <small>Email không thể thay đổi.</small>
                                </div>
                                <div class="form-group">
                                    <label>Số Điện Thoại</label>
                                    <input type="tel" id="phone" name="phone" value="<%= currentUser.getPhone() %>" pattern="0\d{9,}" required />
                                    <div id="phoneError" class="error-message"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Vai Trò</label>
                                <input type="text" value="<%= currentUser.getRole() %>" readonly style="background-color:#e9ecef;"/>
                            </div>
                            <div class="form-group">
                                <label>Ngày Sinh</label>
                                <input type="date" id="birthdate" name="birthdate" value="<%= currentUser.getDateOfBirth() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(currentUser.getDateOfBirth()) : "" %>"/>
                                <div id="birthdateError" class="error-message"></div>
                            </div>
                            <div class="form-group">
                                <label>Địa Chỉ</label>
                                <textarea name="address" rows="3"><%= currentUser.getAddress() != null ? currentUser.getAddress() : "" %></textarea>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">Cập Nhật</button>
                                <a href="<%= request.getContextPath() %>/home.jsp" class="btn btn-primary">🏠 Trang Chủ</a>
                                <% if (currentUser.isAdmin()) { %>
                                <a href="<%= request.getContextPath() %>/adminDashboard" class="btn btn-primary">🛠️ Trang Quản Trị</a>
                                <% } %>
                            </div>
                        </form>
                    </div>
                    <div id="security" class="section">
                        <h2>Bảo Mật</h2>
                        <h4>Đổi Mật Khẩu</h4>
                        <form id="passwordForm" method="post" action="<%= request.getContextPath() %>/changePassword">
                            <div class="form-group">
                                <label>Mật Khẩu Hiện Tại</label>
                                <input type="password" name="currentPassword" required/>
                            </div>
                            <div class="form-group">
                                <label>Mật Khẩu Mới</label>
                                <input type="password" id="newPassword" name="newPassword" required/>
                                <div id="passwordError" class="error-message"></div>
                            </div>
                            <div class="form-group">
                                <label>Xác Nhận Mật Khẩu Mới</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" required/>
                            </div>
                            <button type="submit" class="btn btn-primary">Đổi Mật Khẩu</button>
                        </form>
                        <h3>Phiên Đăng Nhập</h3>
                        <button class="btn btn-danger" onclick="alert('Tính năng này đang phát triển')">Đăng Xuất Tất Cả Phiên</button>
                    </div>
                    <div id="preferences" class="section">
                        <h2>Tuỳ Chọn</h2>
                        <form>
                            <div class="form-group">
                                <label>Ngôn Ngữ</label>
                                <select name="language">
                                    <option value="en" selected>Tiếng Anh</option>
                                    <option value="vi">Tiếng Việt</option>
                                    <option value="fr">Tiếng Pháp</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Múi Giờ</label>
                                <select name="timezone">
                                    <option value="utc-5" selected>UTC-5</option>
                                    <option value="utc+7">UTC+7</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Nhận thông báo:</label><br/>
                                <input type="checkbox" name="emailNotifications" checked/> Email <br/>
                                <input type="checkbox" name="matchReminders" checked/> Nhắc trận đấu<br/>
                                <input type="checkbox" name="teamUpdates" checked/> Cập nhật đội<br/>
                            </div>
                            <button type="submit" class="btn btn-primary">Lưu</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!-- JS -->
        <script src="https://cdn.jsdelivr.net/npm/jquery @3.6.4/dist/jquery.min.js"></script>
        <script>
                            function showSection(sectionId) {
                                document.querySelectorAll('.section').forEach(sec => sec.classList.remove('active'));
                                document.getElementById(sectionId).classList.add('active');
                                document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
                                document.querySelector(`.nav-link[onclick*="${sectionId}"]`).classList.add('active');
                            }
                            document.getElementById('passwordForm').addEventListener('submit', function (e) {
                                const newPass = document.getElementById('newPassword').value;
                                const confirm = document.getElementById('confirmPassword').value;
                                if (newPass !== confirm) {
                                    alert("Mật khẩu xác nhận không khớp");
                                    e.preventDefault();
                                }
                                if (!/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/.test(newPass)) {
                                    alert("Mật khẩu ít nhất 8 ký tự, 1 hoa, 1 thường, 1 số.");
                                    e.preventDefault();
                                }
                            });
                            document.getElementById('birthdate').addEventListener('change', function () {
                                const date = new Date(this.value);
                                if (date >= new Date()) {
                                    document.getElementById('birthdateError').textContent = "Ngày sinh không được trong tương lai.";
                                    this.setCustomValidity("Ngày sinh không hợp lệ.");
                                } else {
                                    document.getElementById('birthdateError').textContent = "";
                                    this.setCustomValidity("");
                                }
                            });
                            document.getElementById('phone').addEventListener('input', function () {
                                const value = this.value.replace(/\D/g, '');
                                const errorDiv = document.getElementById('phoneError');
                                if (!value.startsWith('0') || value.length < 10) {
                                    errorDiv.textContent = "Số điện thoại hợp lệ phải bắt đầu bằng 0 và ít nhất 10 số.";
                                } else {
                                    errorDiv.textContent = "";
                                }
                            });
        </script>
    </body>
</html>