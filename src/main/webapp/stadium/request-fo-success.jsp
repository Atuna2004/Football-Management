<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css"  rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="alert alert-success" role="alert">
        Yêu cầu của bạn đã được gửi thành công! Thông tin của bạn đã được gửi qua admin.
        Sau khi admin phê duyệt, chúng tôi sẽ gửi mail thông báo đến email của bạn.
    </div>
    <a href="<%= request.getContextPath() %>/home.jsp" class="btn btn-primary">Về trang chủ</a>
</div>
</body>
</html>