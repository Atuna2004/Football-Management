<!-- become-owner-request.jsp - UPDATED -->
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Yêu cầu làm chủ sân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Gửi yêu cầu làm chủ sân</h2>
    
    <!-- Hiển thị lỗi nếu có -->
    <% if (session.getAttribute("ownerRequestError") != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= session.getAttribute("ownerRequestError") %>
        </div>
        <% session.removeAttribute("ownerRequestError"); %>
    <% } %>
    
    <form action="<%= request.getContextPath() %>/submit-owner-request" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="fullName" class="form-label">Họ và tên *</label>
            <input type="text" class="form-control" id="fullName" name="fullName"
                   value="${currentUser != null ? currentUser.fullName : ''}" required>
        </div>
        
        <div class="mb-3">
            <label for="email" class="form-label">Email *</label>
            <input type="email" class="form-control" id="email" name="email"
                   value="${currentUser != null ? currentUser.email : ''}" required>
        </div>
        
        <div class="mb-3">
            <label for="phone" class="form-label">Số điện thoại *</label>
            <input type="tel" class="form-control" id="phone" name="phone" required>
        </div>
        
        <div class="mb-3">
            <label for="businessLicense" class="form-label">Giấy phép kinh doanh (PDF)</label>
            <input type="file" class="form-control" id="businessLicense" name="businessLicense"
                   accept="application/pdf">
            <small class="form-text text-muted">Tải lên file PDF của giấy phép kinh doanh (nếu có)</small>
        </div>
        
        <div class="mb-3">
            <label for="message" class="form-label">Lời nhắn / Lý do muốn làm chủ sân</label>
            <textarea class="form-control" id="message" name="message" rows="4" 
                      placeholder="Chia sẻ kinh nghiệm, kế hoạch kinh doanh hoặc lý do bạn muốn trở thành chủ sân..."></textarea>
        </div>
        
        <button type="submit" class="btn btn-primary">Gửi yêu cầu</button>
        <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-secondary">Hủy</a>
    </form>
</div>
</body>
</html>