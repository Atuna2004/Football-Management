<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="model.Stadium" %>
<%
    Stadium stadium = (Stadium) request.getAttribute("stadium");
    if (stadium == null) {
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
%>
<jsp:include page="/includes/header.jsp"/>
<div style="text-align: center; padding: 50px; font-family: sans-serif;">
    <h1>404 - Không tìm thấy</h1>
    <p>Sân bóng bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
    <a href="${pageContext.request.contextPath}/stadiums">Quay lại danh sách sân bóng</a>
</div>
<%
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sân bóng - <%= stadium.getName() %>
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .stadium-detail-container {
            max-width: 1100px;
            margin: 30px auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .header-section {
            padding: 40px;
            border-bottom: 1px solid #e9ecef;
        }

        .header-section h2 {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
            color: #1976d2;
            text-align: center;
        }

        .content-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            padding: 40px;
        }

        .info-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .info-item {
            display: flex;
            align-items: flex-start;
            padding: 16px;
            background: #f8f9fa;
            border-radius: 12px;
            border-left: 4px solid #1976d2;
        }

        .info-icon {
            font-size: 20px;
            color: #1976d2;
            margin-right: 16px;
            min-width: 24px;
            text-align: center;
        }

        .info-content {
            flex: 1;
        }

        .info-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .info-value {
            color: #333;
            font-size: 16px;
            line-height: 1.5;
        }

        .map-section {
            display: flex;
            flex-direction: column;
        }

        .map-header {
            margin-bottom: 16px;
        }

        .map-header h4 {
            font-size: 20px;
            font-weight: 600;
            color: #1976d2;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .map-container {
            flex: 1;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        }

        .map-container iframe {
            width: 100%;
            height: 100%;
            min-height: 400px;
            border: none;
            display: block;
        }

        .btn-container {
            padding: 30px 40px;
            background: #f8f9fa;
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn-custom {
            background: linear-gradient(135deg, #1976d2, #42a5f5);
            color: white;
            font-weight: 600;
            padding: 14px 28px;
            border: none;
            border-radius: 10px;
            text-decoration: none;
            font-size: 15px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-custom:hover {
            background: linear-gradient(135deg, #1565c0, #1e88e5);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(25, 118, 210, 0.25);
            color: white;
        }

        .btn-report {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
        }

        .btn-report:hover {
            background: linear-gradient(135deg, #c82333, #dc3545);
            box-shadow: 0 8px 24px rgba(220, 53, 69, 0.25);
        }

        @media (max-width: 992px) {
            .content-wrapper {
                grid-template-columns: 1fr;
            }
        }

        .modal-content {
            border-radius: 16px;
            border: none;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            animation: modal-fade-in 0.3s ease-out;
        }

        @keyframes modal-fade-in {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e9ecef;
        }

        .modal-title {
            font-weight: 600;
            font-size: 1.1rem;
        }

        .modal-body {
            padding: 24px 24px 16px;
        }

        .modal-footer {
            padding: 16px 24px;
            background-color: #f8f9fa;
            border-top: 1px solid #e9ecef;
            border-bottom-left-radius: 16px;
            border-bottom-right-radius: 16px;
        }

        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 12px 16px;
            border: 1px solid #ced4da;
            font-size: 1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: #1976d2;
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.15);
        }

        .modal-footer .btn {
            padding: 10px 20px;
            font-weight: 500;
            border-radius: 8px;
        }

        #successModal .modal-content {
            animation: success-pop-in 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        @keyframes success-pop-in {
            from {
                opacity: 0;
                transform: scale(0.7);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
    </style>
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<div class="stadium-detail-container">
    <div class="header-section">
        <h2><%= stadium.getName() %>
        </h2>
    </div>

    <div class="content-wrapper">
        <div class="info-section">
            <div class="info-item">
                <div class="info-icon"><i class="fas fa-map-marker-alt"></i></div>
                <div class="info-content">
                    <div class="info-label">Địa chỉ</div>
                    <div class="info-value"><%= stadium.getLocation() %>
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="fas fa-info-circle"></i></div>
                <div class="info-content">
                    <div class="info-label">Mô tả</div>
                    <div class="info-value"><%= stadium.getDescription() %>
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="fas fa-phone"></i></div>
                <div class="info-content">
                    <div class="info-label">Số điện thoại</div>
                    <div class="info-value"><%= stadium.getPhoneNumber() %>
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="fas fa-check-circle"></i></div>
                <div class="info-content">
                    <div class="info-label">Trạng thái</div>
                    <div class="info-value"><%= stadium.getStatus() %>
                    </div>
                </div>
            </div>
        </div>

        <div class="map-section">
            <div class="map-header"><h4><i class="fas fa-map-marked-alt"></i> Vị trí trên bản đồ</h4></div>
            <div class="map-container">
                <iframe loading="lazy" allowfullscreen referrerpolicy="no-referrer-when-downgrade"
                        src="https://maps.google.com/maps?q=<%= java.net.URLEncoder.encode(stadium.getLocation(), "UTF-8") %>&output=embed">
                </iframe>
            </div>
        </div>
    </div>

    <div class="btn-container">
        <a class="btn-custom" href="stadiums" style="background: #6c757d;"><i class="fas fa-arrow-left"></i> Quay
            lại</a>
        <button type="button" class="btn-custom btn-report" data-bs-toggle="modal" data-bs-target="#reportModal">
            <i class="fas fa-flag"></i> Báo cáo
        </button>
        <a class="btn-custom" href="timeslot?stadiumId=<%= stadium.getStadiumID() %>">
            Xem lịch đặt sân <i class="fas fa-arrow-right"></i>
        </a>
    </div>
</div>

<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="reportForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="reportModalLabel"><i class="fas fa-flag text-warning me-2"></i>Báo cáo
                        sân bóng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="stadiumId" id="modalStadiumId" value="<%= stadium.getStadiumID() %>"/>
                    <div class="mb-3">
                        <label for="reason" class="form-label">Lý do báo cáo</label>
                        <select class="form-select" name="reason" id="reason" required>
                            <option value="" disabled selected>-- Chọn lý do --</option>
                            <option value="Sân không hoạt động">Sân không hoạt động</option>
                            <option value="Thông tin sai lệch">Thông tin sai lệch</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Mô tả chi tiết</label>
                        <textarea class="form-control" name="description" id="description" rows="4"
                                  placeholder="Vui lòng mô tả chi tiết vấn đề..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger"><i class="fas fa-paper-plane me-2"></i>Gửi báo cáo
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content text-center">
            <div class="modal-body py-4">
                <i class="fas fa-circle-check text-success mb-3" style="font-size: 3.5rem;"></i>
                <h4 class="fw-bold mb-2">Báo cáo thành công!</h4>
                <p class="text-muted small mb-3">Cảm ơn bạn. Chúng tôi sẽ xử lý sớm nhất.</p>
                <button type="button" class="btn btn-success w-100" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const reportForm = document.getElementById('reportForm');
        const reportModalEl = document.getElementById('reportModal');
        if (!reportModalEl) return;

        const reportModal = new bootstrap.Modal(reportModalEl);
        const successModal = new bootstrap.Modal(document.getElementById('successModal'));

        if (reportForm) {
            reportForm.addEventListener('submit', function (e) {
                e.preventDefault();

                const submitButton = this.querySelector('button[type="submit"]');
                submitButton.disabled = true;
                submitButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';

                const formData = new URLSearchParams(new FormData(this));

                fetch('submit-report', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => {
                        if (!response.ok) {
                            return response.text().then(text => {
                                throw new Error(text || 'Network response was not ok')
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            reportModal.hide();
                            setTimeout(() => {
                                successModal.show();
                            }, 500);
                        } else {
                            alert('Lỗi: ' + (data.message || 'Không thể gửi báo cáo.'));
                        }
                    })
                    .catch(err => {
                        console.error('[ERROR]', err);
                        alert('Đã xảy ra lỗi khi gửi báo cáo. Vui lòng thử lại.');
                    })
                    .finally(() => {
                        submitButton.disabled = false;
                        submitButton.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Gửi báo cáo';
                    });
            });
        }

        reportModalEl.addEventListener('hidden.bs.modal', function () {
            if (reportForm) {
                reportForm.reset();
            }
        });
    });
</script>
</body>
</html>