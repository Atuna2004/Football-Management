<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Stadium" %>
<%
    Stadium stadium = (Stadium) request.getAttribute("stadium");
    Integer userId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sân bóng</title>
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
            box-shadow: 0 8px 32px rgba(0,0,0,0.08);
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
            margin-right: 12px;
            min-width: 24px;
        }
        
        .info-content {
            flex: 1;
        }
        
        .info-label {
            font-weight: 600;
            color: #1976d2;
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
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
            background: #f0f4f8;
        }
        
        .map-container iframe {
            width: 100%;
            height: 400px;
            border: none;
            display: block;
        }
        
        .btn-container {
            padding: 30px 40px;
            background: #f8f9fa;
            display: flex;
            justify-content: center;
            gap: 20px;
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
            text-decoration: none;
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #8d9499);
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #5a6268, #7a8287);
            box-shadow: 0 8px 24px rgba(108, 117, 125, 0.25);
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
                gap: 30px;
                padding: 30px;
            }
            
            .stadium-detail-container {
                margin: 20px;
            }
            
            .header-section {
                padding: 30px 20px;
            }
            
            .btn-container {
                padding: 20px;
                flex-direction: column;
                align-items: center;
            }
            
            .btn-custom {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
        
        @media (max-width: 576px) {
            .header-section h2 {
                font-size: 24px;
            }
            
            .info-item {
                padding: 12px;
            }
            
            .map-container iframe {
                height: 300px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/includes/header.jsp" %>
    
    <div class="stadium-detail-container">
        <div class="header-section">
            <h2><%= stadium.getName() %></h2>
        </div>
        
        <div class="content-wrapper">
            <div class="info-section">
                <div class="info-item">
                    <div class="info-icon">📍</div>
                    <div class="info-content">
                        <div class="info-label">Địa chỉ</div>
                        <div class="info-value"><%= stadium.getLocation() %></div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">📝</div>
                    <div class="info-content">
                        <div class="info-label">Mô tả</div>
                        <div class="info-value"><%= stadium.getDescription() %></div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">📞</div>
                    <div class="info-content">
                        <div class="info-label">Số điện thoại</div>
                        <div class="info-value"><%= stadium.getPhoneNumber() %></div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">⚙️</div>
                    <div class="info-content">
                        <div class="info-label">Trạng thái</div>
                        <div class="info-value"><%= stadium.getStatus() %></div>
                    </div>
                </div>
            </div>
            
            <div class="map-section">
                <div class="map-header">
                    <h4>🗺️ Vị trí trên bản đồ</h4>
                </div>
                <div class="map-container">
                    <iframe
                        loading="lazy"
                        allowfullscreen
                        referrerpolicy="no-referrer-when-downgrade"
                        src="https://www.google.com/maps/embed/v1/place?key=AIzaSyBXtyXJaKZ7CqKPXLrwA3hJErc68ZaT3YA&q=<%= java.net.URLEncoder.encode(stadium.getLocation(), "UTF-8") %>">
                    </iframe>
                </div>
            </div>
        </div>
        
        <div class="btn-container">
            <a class="btn-custom btn-secondary" href="stadiums">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
            <button type="button" class="btn-custom btn-report" 
                    onclick="setReportStadiumId(<%= stadium.getStadiumID() %>)"
                    data-bs-toggle="modal" 
                    data-bs-target="#reportModal">
                <i class="fas fa-flag"></i> Báo cáo
            </button>
            <a class="btn-custom" href="timeslot?stadiumId=<%= stadium.getStadiumID() %>">
                Xem lịch đặt sân <i class="fas fa-arrow-right"></i>
            </a>
        </div>
    </div>
    
    <!-- Report Modal -->
    <div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form id="reportForm">
                    <div class="modal-header">
                        <h5 class="modal-title fw-semibold text-dark">
                            <i class="fas fa-flag me-2 text-warning"></i>Báo cáo sân bóng
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <input type="hidden" name="stadiumId" id="modalStadiumId" />

                        <div class="mb-3">
                            <label for="reason" class="form-label">Lý do báo cáo</label>
                            <select class="form-select" name="reason" id="reason" required>
                                <option value="">-- Chọn lý do --</option>
                                <option value="Sân không hoạt động">Sân không hoạt động</option>
                                <option value="Thông tin sai lệch">Thông tin sai lệch</option>
                                <option value="Hình ảnh không phù hợp">Hình ảnh không phù hợp</option>
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
                        <button type="button" class="btn btn-light text-muted" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-paper-plane me-2"></i>Gửi báo cáo
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content text-center shadow-lg">
                <div class="modal-body py-5">
                    <i class="fas fa-circle-check text-success mb-4" style="font-size: 3rem;"></i>
                    <h4 class="text-success fw-bold mb-3">Báo cáo thành công!</h4>
                    <p class="text-muted mb-4">Cảm ơn bạn đã báo cáo. Chúng tôi sẽ xử lý sớm nhất.</p>
                    <button type="button" class="btn btn-success px-4" data-bs-dismiss="modal">
                        <i class="fas fa-check me-1"></i>Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/includes/footer.jsp" %>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Function to set stadium ID when opening modal
        function setReportStadiumId(id) {
            const input = document.getElementById('modalStadiumId');
            if (input) {
                input.value = id;
                console.log('[DEBUG] Stadium ID set to:', id);
            } else {
                console.error('[ERROR] modalStadiumId input not found!');
            }
        }

        // Handle form submission
        document.getElementById('reportForm').addEventListener('submit', function (e) {
            e.preventDefault();

            const form = this;
            const formData = new FormData(form);

            console.log('=== FORM DATA DEBUG ===');
            for (const [key, val] of formData.entries()) {
                console.log(`${key}: "${val}" (length: ${val.length})`);
            }

            // Check if required fields are present
            const stadiumId = formData.get('stadiumId');
            const reason = formData.get('reason');
            const description = formData.get('description');

            console.log('=== VALIDATION CHECK ===');
            console.log('stadiumId:', stadiumId ? '✅ Present' : '❌ Missing');
            console.log('reason:', reason ? '✅ Present' : '❌ Missing');
            console.log('description:', description ? '✅ Present' : '❌ Missing');

            if (!stadiumId || !reason || !description) {
                alert('Vui lòng điền đầy đủ thông tin báo cáo!');
                return;
            }

            // Send the request
            fetch('submit-report', {
                method: 'POST',
                body: formData
            })
            .then(res => {
                console.log('Response status:', res.status);
                return res.text();
            })
            .then(text => {
                console.log('Raw response:', text);
                try {
                    const data = JSON.parse(text);
                    console.log('Parsed response:', data);
                    
                    if (data.success) {
                        // Close report modal
                        const reportModal = bootstrap.Modal.getInstance(document.getElementById('reportModal'));
                        if (reportModal) reportModal.hide();

                      <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content text-center shadow-lg">
                <div class="modal-body py-5">
                    <i class="fas fa-circle-check text-success mb-4" style="font-size: 3rem;"></i>
                    <h4 class="text-success fw-bold mb-3">Báo cáo thành công!</h4>
                    <p class="text-muted mb-4">Cảm ơn bạn đã báo cáo. Chúng tôi sẽ xử lý sớm nhất.</p>
                    <button type="button" class="btn btn-success px-4" data-bs-dismiss="modal">
                        <i class="fas fa-check me-1"></i>Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/includes/footer.jsp" %>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<!-- REPLACE YOUR ENTIRE SCRIPT SECTION WITH THIS FIXED VERSION: -->
<script>
    // Function to set stadium ID when opening modal
    function setReportStadiumId(id) {
        console.log('[DEBUG] Function called with ID:', id);
        const input = document.getElementById('modalStadiumId');
        if (input) {
            input.value = id;
            console.log('[DEBUG] Stadium ID set to:', id);
        } else {
            console.error('[ERROR] modalStadiumId input not found!');
        }
    }

    // Auto-set stadium ID when page loads
    document.addEventListener('DOMContentLoaded', function() {
        const stadiumId = <%= stadium.getStadiumID() %>;
        console.log('[DEBUG] Stadium ID from JSP:', stadiumId);
        
        // Set stadium ID immediately
        setReportStadiumId(stadiumId);
        
        // Also set it when button is clicked
        const reportButton = document.querySelector('[data-bs-target="#reportModal"]');
        if (reportButton) {
            reportButton.addEventListener('click', function() {
                console.log('[DEBUG] Report button clicked');
                setReportStadiumId(stadiumId);
            });
        }
    });

    // ✅ FIXED: Handle form submission with proper modal closing
    document.getElementById('reportForm').addEventListener('submit', function (e) {
        e.preventDefault();

        // Get form values manually
        const stadiumId = document.getElementById('modalStadiumId').value;
        const reason = document.getElementById('reason').value;
        const description = document.getElementById('description').value;

        console.log('=== FORM DATA DEBUG ===');
        console.log('stadiumId:', stadiumId);
        console.log('reason:', reason);
        console.log('description:', description);

        // Validate fields
        if (!stadiumId || !reason || !description) {
            alert('Vui lòng điền đầy đủ thông tin báo cáo!');
            return;
        }

        console.log('✅ Validation passed, sending request...');

        // Disable submit button during request
        const submitButton = this.querySelector('button[type="submit"]');
        if (submitButton) {
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';
        }

        // Create URL-encoded data
        const formData = new URLSearchParams();
        formData.append('stadiumId', stadiumId);
        formData.append('reason', reason);
        formData.append('description', description);

        console.log('Sending data:', formData.toString());

        // Send request
        fetch('submit-report', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(res => {
            console.log('Response status:', res.status);
            return res.text();
        })
        .then(text => {
            console.log('Raw response:', text);
            try {
                const data = JSON.parse(text);
                console.log('Parsed response:', data);
                
                if (data.success) {
                    // ✅ FIXED: Proper modal closing sequence
                    closeReportModal();
                    
                    // Wait a bit before showing success modal
                    setTimeout(() => {
                        showSuccessModal();
                    }, 300);
                    
                } else {
                    alert('Lỗi: ' + data.message);
                }
            } catch (e) {
                console.error('Response is not JSON:', text);
                alert('Phản hồi từ server không hợp lệ: ' + text);
            }
        })
        .catch(err => {
            console.error('[ERROR]', err);
            alert('Đã xảy ra lỗi khi gửi báo cáo. Vui lòng thử lại.');
        })
        .finally(() => {
            // Re-enable submit button
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Gửi báo cáo';
            }
        });
    });

    // ✅ FIXED: Proper modal closing function
    function closeReportModal() {
        const reportModalElement = document.getElementById('reportModal');
        const reportModal = bootstrap.Modal.getInstance(reportModalElement);
        
        if (reportModal) {
            // Hide the modal instance
            reportModal.hide();
        } else {
            // If no instance exists, create one and hide it
            const newModal = new bootstrap.Modal(reportModalElement);
            newModal.hide();
        }
        
        // ✅ FORCE REMOVE BACKDROP AND RESTORE SCROLLING
        setTimeout(() => {
            // Remove any lingering backdrop
            const backdrops = document.querySelectorAll('.modal-backdrop');
            backdrops.forEach(backdrop => backdrop.remove());
            
            // Remove modal-open class from body
            document.body.classList.remove('modal-open');
            
            // Restore body scroll
            document.body.style.overflow = '';
            document.body.style.paddingRight = '';
            
            // Reset form
            document.getElementById('reportForm').reset();
            document.getElementById('modalStadiumId').value = <%= stadium.getStadiumID() %>;
            
            console.log('✅ Report modal closed and cleaned up');
        }, 150);
    }

    // ✅ IMPROVED: Success modal function
    function showSuccessModal() {
        const successModalElement = document.getElementById('successModal');
        const successModal = new bootstrap.Modal(successModalElement);
        successModal.show();
        
        console.log('✅ Success modal shown');
    }

    // Reset form when modal is closed manually
    document.getElementById('reportModal').addEventListener('hidden.bs.modal', function() {
        const form = document.getElementById('reportForm');
        if (form) {
            form.reset();
            const idInput = document.getElementById('modalStadiumId');
            if (idInput) {
                idInput.value = <%= stadium.getStadiumID() %>;
            }
        }
        
        // Extra cleanup
        document.body.classList.remove('modal-open');
        document.body.style.overflow = '';
        document.body.style.paddingRight = '';
        
        console.log('✅ Report modal manually closed and cleaned up');
    });

    // ✅ SUCCESS MODAL AUTO-CLOSE
    document.getElementById('successModal').addEventListener('shown.bs.modal', function() {
        // Auto-close success modal after 3 seconds
        setTimeout(() => {
            const successModal = bootstrap.Modal.getInstance(this);
            if (successModal) {
                successModal.hide();
            }
        }, 3000);
    });
</script>
</html>