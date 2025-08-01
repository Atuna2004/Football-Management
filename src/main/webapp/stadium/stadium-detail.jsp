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
<jsp:include page="/includes/footer.jsp"/>
<%
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sân bóng - <%= stadium.getName() %></title>
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

        /* Comment Section Styles */
        .comment-section {
            padding: 40px;
            border-top: 1px solid #e9ecef;
            max-width: 800px;
            margin: 0 auto;
        }

        .comment-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .comment-form textarea {
            width: 100%;
            height: 100px;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            resize: vertical;
            font-family: inherit;
            margin-bottom: 10px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .comment-form textarea:focus {
            border-color: #1976d2;
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.15);
            outline: none;
        }

        .comment-form textarea.invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.15);
        }

        .word-counter {
            text-align: right;
            font-size: 12px;
            color: #6c757d;
            margin-bottom: 15px;
            font-weight: 500;
        }

        .word-counter.warning {
            color: #ffc107;
        }

        .word-counter.danger {
            color: #dc3545;
        }

        .comment-item {
            border-bottom: 1px solid #f0f0f0;
            padding: 20px 0;
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-header {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
        }

        .comment-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 12px;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }

        .comment-user-info {
            flex: 1;
        }

        .comment-user-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 2px;
        }

        .comment-time {
            font-size: 12px;
            color: #6c757d;
        }

        .comment-content {
            color: #333;
            line-height: 1.6;
            margin-bottom: 15px;
            white-space: pre-wrap;
        }

        .replies-section {
            margin-left: 52px;
            border-left: 2px solid #e9ecef;
            padding-left: 20px;
            margin-top: 15px;
        }

        .reply-item {
            padding: 15px 0;
            border-bottom: 1px solid #f8f9fa;
        }

        .reply-item:last-child {
            border-bottom: none;
        }

        .owner-reply {
            background-color: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            border-left: 3px solid #1976d2;
        }

        .owner-badge {
            background: #1976d2;
            color: white;
            font-size: 10px;
            padding: 2px 8px;
            border-radius: 12px;
            margin-left: 8px;
            font-weight: 500;
        }

        .reply-form {
            margin-top: 15px;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }

        .reply-form textarea {
            width: 100%;
            height: 60px;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            resize: vertical;
            margin-bottom: 5px;
            transition: border-color 0.2s ease;
        }

        .reply-form textarea.invalid {
            border-color: #dc3545;
        }

        .reply-word-counter {
            text-align: right;
            font-size: 11px;
            color: #6c757d;
            margin-bottom: 10px;
        }

        .reply-word-counter.warning {
            color: #ffc107;
        }

        .reply-word-counter.danger {
            color: #dc3545;
        }

        .reply-btn {
            background: #1976d2;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
        }

        .reply-btn:hover {
            background: #1565c0;
        }

        .comment-pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .comment-pagination .pagination {
            margin: 0;
        }

        .comment-pagination .page-link {
            color: #1976d2;
            border-color: #dee2e6;
        }

        .comment-pagination .page-item.active .page-link {
            background-color: #1976d2;
            border-color: #1976d2;
        }

        .loading-spinner {
            text-align: center;
            padding: 20px;
            color: #6c757d;
        }

        .no-comments {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }

        .validation-error {
            background: #f8d7da;
            color: #721c24;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 14px;
            border: 1px solid #f5c6cb;
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
                <div class="info-icon"><i class="fas fa-map-marker-alt"></i></div>
                <div class="info-content">
                    <div class="info-label">Địa chỉ</div>
                    <div class="info-value"><%= stadium.getLocation() %></div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="fas fa-info-circle"></i></div>
                <div class="info-content">
                    <div class="info-label">Mô tả</div>
                    <div class="info-value"><%= stadium.getDescription() %></div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="fas fa-phone"></i></div>
                <div class="info-content">
                    <div class="info-label">Số điện thoại</div>
                    <div class="info-value"><%= stadium.getPhoneNumber() %></div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="fas fa-check-circle"></i></div>
                <div class="info-content">
                    <div class="info-label">Trạng thái</div>
                    <div class="info-value"><%= stadium.getStatus() %></div>
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
        <a class="btn-custom" href="stadiums" style="background: #6c757d;"><i class="fas fa-arrow-left"></i> Quay lại</a>
        <button type="button" class="btn-custom btn-report" data-bs-toggle="modal" data-bs-target="#reportModal">
            <i class="fas fa-flag"></i> Báo cáo
        </button>
        <a class="btn-custom" href="timeslot?stadiumId=<%= stadium.getStadiumID() %>">
            Xem lịch đặt sân <i class="fas fa-arrow-right"></i>
        </a>
    </div>

    <!-- Comment Section -->
    <div class="comment-section">
        <h3 style="font-size: 24px; font-weight: 600; color: #1976d2; margin-bottom: 30px; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-comments"></i> 
            Đánh giá & Bình luận 
            <span id="comment-count" style="background: #1976d2; color: white; padding: 4px 12px; border-radius: 20px; font-size: 14px;">
                ${commentCount != null ? commentCount : 0}
            </span>
        </h3>

        <!-- Comment Form (only for logged-in users) -->
        <%
            model.User sessionUser = (model.User) session.getAttribute("currentUser");
            if (sessionUser != null) {
        %>
        <div class="comment-form">
            <div id="validation-error" class="validation-error" style="display: none;"></div>
            <form id="commentForm">
                <input type="hidden" name="stadiumId" value="<%= stadium.getStadiumID() %>">
                <textarea name="content" 
                          placeholder="Chia sẻ trải nghiệm của bạn về sân bóng này..." 
                          required
                          maxlength="600"></textarea>
                <div class="word-counter">
                    <span id="word-count">0</span>/100 từ
                </div>
                <button type="submit" class="btn-custom" style="margin: 0;">
                    <i class="fas fa-paper-plane"></i> Đăng bình luận
                </button>
            </form>
        </div>
        <% } else { %>
        <div style="text-align: center; padding: 20px; background: #f8f9fa; border-radius: 12px; margin-bottom: 30px;">
            <p style="margin: 0; color: #6c757d;">
                <a href="login" style="color: #1976d2; text-decoration: none;">Đăng nhập</a> 
                để bình luận về sân bóng này
            </p>
        </div>
        <% } %>

        <!-- Comments Display -->
        <div id="comments-container">
            <div class="loading-spinner">
                <i class="fas fa-spinner fa-spin"></i> Đang tải bình luận...
            </div>
        </div>

        <!-- Pagination -->
        <div id="comment-pagination" class="comment-pagination"></div>
    </div>
</div>

<!-- Report Modal -->
<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="reportForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="reportModalLabel"><i class="fas fa-flag text-warning me-2"></i>Báo cáo sân bóng</h5>
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
                    <button type="submit" class="btn btn-danger"><i class="fas fa-paper-plane me-2"></i>Gửi báo cáo</button>
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

<!-- Comment Success Modal -->
<div class="modal fade" id="commentSuccessModal" tabindex="-1" aria-labelledby="commentSuccessModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content text-center">
            <div class="modal-body py-4">
                <i class="fas fa-circle-check text-success mb-3" style="font-size: 3.5rem;"></i>
                <h4 class="fw-bold mb-2">Bình luận thành công!</h4>
                <p class="text-muted small mb-3">Cảm ơn bạn đã chia sẻ.</p>
                <button type="button" class="btn btn-success w-100" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const stadiumId = <%= stadium.getStadiumID() %>;
    const currentUserId = <%= sessionUser != null ? sessionUser.getUserID() : "null" %>;
    const stadiumOwnerId = <%= stadium.getOwnerID() %>;
    const MAX_WORDS = 100;
    let currentPage = 1;

    document.addEventListener('DOMContentLoaded', function () {
        // Initialize word counter for main comment form
        const mainTextarea = document.querySelector('#commentForm textarea[name="content"]');
        if (mainTextarea) {
            setupWordCounter(mainTextarea, 'word-count');
        }

        // Report form functionality
        setupReportForm();
        
        // Comment functionality
        loadComments(1);
        setupCommentForm();
        setupReplyHandlers();
    });

    function setupWordCounter(textarea, counterId) {
        textarea.addEventListener('input', function() {
            updateWordCount(this, counterId);
        });
        updateWordCount(textarea, counterId);
    }

    function updateWordCount(textarea, counterId) {
        const content = textarea.value.trim();
        const words = content === '' ? 0 : content.split(/\s+/).length;
        const counter = document.getElementById(counterId);
        const counterParent = counter ? counter.parentElement : null;
        
        if (counter) {
            counter.textContent = words;
            
            if (counterParent) {
                counterParent.classList.remove('warning', 'danger');
                if (words > MAX_WORDS) {
                    counterParent.classList.add('danger');
                    textarea.classList.add('invalid');
                } else if (words > MAX_WORDS * 0.9) {
                    counterParent.classList.add('warning');
                    textarea.classList.remove('invalid');
                } else {
                    textarea.classList.remove('invalid');
                }
            }
        }
    }

    function setupReportForm() {
        const reportForm = document.getElementById('reportForm');
        const reportModalEl = document.getElementById('reportModal');
        
        if (reportModalEl && reportForm) {
            const reportModal = new bootstrap.Modal(reportModalEl);
            const successModal = new bootstrap.Modal(document.getElementById('successModal'));

            reportForm.addEventListener('submit', function (e) {
                e.preventDefault();
                
                const submitButton = this.querySelector('button[type="submit"]');
                submitButton.disabled = true;
                submitButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';

                fetch('submit-report', {
                    method: 'POST',
                    body: new URLSearchParams(new FormData(this))
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        reportModal.hide();
                        setTimeout(() => successModal.show(), 500);
                    } else {
                        alert('Lỗi: ' + (data.message || 'Không thể gửi báo cáo.'));
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                    alert('Đã xảy ra lỗi khi gửi báo cáo. Vui lòng thử lại.');
                })
                .finally(() => {
                    submitButton.disabled = false;
                    submitButton.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Gửi báo cáo';
                });
            });

            reportModalEl.addEventListener('hidden.bs.modal', function () {
                reportForm.reset();
            });
        }
    }

    function setupCommentForm() {
        const commentForm = document.getElementById('commentForm');
        if (commentForm) {
            commentForm.addEventListener('submit', function(e) {
                e.preventDefault();
                if (validateCommentForm(this)) {
                    submitComment(this);
                }
            });
        }
    }

    function setupReplyHandlers() {
        document.addEventListener('submit', function(e) {
            if (e.target.classList.contains('reply-form-inner')) {
                e.preventDefault();
                if (validateReplyForm(e.target)) {
                    submitReply(e.target);
                }
            }
        });

        document.addEventListener('input', function(e) {
            if (e.target.matches('.reply-form textarea[name="content"]')) {
                const counterId = 'reply-word-count-' + Date.now();
                let counter = e.target.parentNode.querySelector('.reply-word-counter span');
                if (!counter) {
                    const counterDiv = document.createElement('div');
                    counterDiv.className = 'reply-word-counter';
                    counterDiv.innerHTML = '<span id="' + counterId + '">0</span>/360 từ';
                    e.target.parentNode.insertBefore(counterDiv, e.target.nextSibling);
                    counter = counterDiv.querySelector('span');
                }
                updateWordCount(e.target, counter.id);
            }
        });
    }

    function validateCommentForm(form) {
        const textarea = form.querySelector('textarea[name="content"]');
        const content = textarea.value.trim();
        
        if (content === '') {
            showValidationError('Vui lòng nhập nội dung bình luận.');
            textarea.focus();
            return false;
        }
        
        const words = content.split(/\s+/).length;
        if (words > MAX_WORDS) {
            showValidationError('Bình luận không được vượt quá ' + MAX_WORDS + ' từ. Hiện tại: ' + words + ' từ.');
            textarea.focus();
            return false;
        }
        
        hideValidationError();
        return true;
    }

    function validateReplyForm(form) {
        const textarea = form.querySelector('textarea[name="content"]');
        const content = textarea.value.trim();
        
        if (content === '') {
            alert('Vui lòng nhập nội dung trả lời.');
            textarea.focus();
            return false;
        }
        
        const words = content.split(/\s+/).length;
        if (words > MAX_WORDS) {
            alert('Trả lời không được vượt quá ' + MAX_WORDS + ' từ. Hiện tại: ' + words + ' từ.');
            textarea.focus();
            return false;
        }
        
        return true;
    }

    function showValidationError(message) {
        const errorDiv = document.getElementById('validation-error');
        if (errorDiv) {
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
        }
    }

    function hideValidationError() {
        const errorDiv = document.getElementById('validation-error');
        if (errorDiv) {
            errorDiv.style.display = 'none';
        }
    }

    function loadComments(page) {
        currentPage = page;
        const container = document.getElementById('comments-container');
        
        container.innerHTML = '<div class="loading-spinner"><i class="fas fa-spinner fa-spin"></i> Đang tải bình luận...</div>';

        fetch('load-comments?stadiumId=' + stadiumId + '&page=' + page)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    displayComments(data.comments);
                    displayPagination(data.pagination);
                    updateCommentCount(data.pagination.totalComments);
                } else {
                    container.innerHTML = '<div class="no-comments">Không thể tải bình luận.</div>';
                }
            })
            .catch(error => {
                console.error('Error loading comments:', error);
                container.innerHTML = '<div class="no-comments">Lỗi khi tải bình luận.</div>';
            });
    }

    function displayComments(comments) {
        const container = document.getElementById('comments-container');
        
        if (comments.length === 0) {
            container.innerHTML = '<div class="no-comments"><i class="fas fa-comments"></i><br>Chưa có bình luận nào.<br>Hãy là người đầu tiên chia sẻ!</div>';
            return;
        }

        let html = '';
        
        comments.forEach(comment => {
            html += '<div class="comment-item">' +
                '<div class="comment-header">' +
                    '<img src="' + (comment.userAvatar || '/images/default-avatar.png') + '" ' +
                         'alt="Avatar" class="comment-avatar" ' +
                         'onerror="this.src=\'/images/default-avatar.png\'">' +
                    '<div class="comment-user-info">' +
                        '<div class="comment-user-name">' +
                            escapeHtml(comment.userName) +
                            (comment.isOwnerReply ? '<span class="owner-badge">CHỦ SÂN</span>' : '') +
                        '</div>' +
                        '<div class="comment-time">' + comment.timeAgo + '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="comment-content">' + escapeHtml(comment.content) + '</div>';
                
            // Add replies if they exist
            if (comment.replies && comment.replies.length > 0) {
                html += '<div class="replies-section">';
                comment.replies.forEach(reply => {
                    html += '<div class="reply-item ' + (reply.isOwnerReply ? 'owner-reply' : '') + '">' +
                        '<div class="comment-header">' +
                            '<img src="' + (reply.userAvatar || '/images/default-avatar.png') + '" ' +
                                 'alt="Avatar" class="comment-avatar" style="width: 32px; height: 32px;" ' +
                                 'onerror="this.src=\'/images/default-avatar.png\'">' +
                            '<div class="comment-user-info">' +
                                '<div class="comment-user-name">' +
                                    escapeHtml(reply.userName) +
                                    (reply.isOwnerReply ? '<span class="owner-badge">CHỦ SÂN</span>' : '') +
                                '</div>' +
                                '<div class="comment-time">' + reply.timeAgo + '</div>' +
                            '</div>' +
                        '</div>' +
                        '<div class="comment-content">' + escapeHtml(reply.content) + '</div>' +
                    '</div>';
                });
                html += '</div>';
            }
            
            // Add reply form for stadium owner
            if (canUserReply()) {
                html += '<div class="reply-form">' +
                    '<form class="reply-form-inner">' +
                        '<input type="hidden" name="stadiumId" value="' + stadiumId + '">' +
                        '<input type="hidden" name="parentCommentId" value="' + comment.commentId + '">' +
                        '<textarea name="content" placeholder="Trả lời bình luận này..." required maxlength="600"></textarea>' +
                        '<button type="submit" class="reply-btn">' +
                            '<i class="fas fa-reply"></i> Trả lời' +
                        '</button>' +
                    '</form>' +
                '</div>';
            }
            
            html += '</div>';
        });
        
        container.innerHTML = html;
    }

    function displayPagination(pagination) {
        const container = document.getElementById('comment-pagination');
        
        if (pagination.totalPages <= 1) {
            container.innerHTML = '';
            return;
        }

        let html = '<nav><ul class="pagination">';
        
        // Previous button
        if (pagination.currentPage > 1) {
            html += '<li class="page-item">' +
                        '<a class="page-link" href="#" onclick="loadComments(' + (pagination.currentPage - 1) + '); return false;">' +
                            '<i class="fas fa-chevron-left"></i>' +
                        '</a>' +
                    '</li>';
        }
        
        // Page numbers
        const startPage = Math.max(1, pagination.currentPage - 2);
        const endPage = Math.min(pagination.totalPages, pagination.currentPage + 2);
        
        for (let i = startPage; i <= endPage; i++) {
            html += '<li class="page-item ' + (i === pagination.currentPage ? 'active' : '') + '">' +
                        '<a class="page-link" href="#" onclick="loadComments(' + i + '); return false;">' + i + '</a>' +
                    '</li>';
        }
        
        // Next button
        if (pagination.currentPage < pagination.totalPages) {
            html += '<li class="page-item">' +
                        '<a class="page-link" href="#" onclick="loadComments(' + (pagination.currentPage + 1) + '); return false;">' +
                            '<i class="fas fa-chevron-right"></i>' +
                        '</a>' +
                    '</li>';
        }
        
        html += '</ul></nav>';
        container.innerHTML = html;
    }

    function submitComment(form) {
        const submitButton = form.querySelector('button[type="submit"]');
        const originalText = submitButton.innerHTML;
        
        submitButton.disabled = true;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';

        fetch('add-comment', {
            method: 'POST',
            body: new URLSearchParams(new FormData(form))
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                form.reset();
                updateWordCount(form.querySelector('textarea'), 'word-count');
                loadComments(1);
                
                const commentSuccessModal = new bootstrap.Modal(document.getElementById('commentSuccessModal'));
                commentSuccessModal.show();
            } else {
                showValidationError(data.message || 'Không thể gửi bình luận.');
            }
        })
        .catch(error => {
            console.error('Error submitting comment:', error);
            showValidationError('Đã xảy ra lỗi khi gửi bình luận. Vui lòng thử lại.');
        })
        .finally(() => {
            submitButton.disabled = false;
            submitButton.innerHTML = originalText;
        });
    }

    function submitReply(form) {
        const submitButton = form.querySelector('button[type="submit"]');
        const originalText = submitButton.innerHTML;
        
        submitButton.disabled = true;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';

        fetch('add-comment', {
            method: 'POST',
            body: new URLSearchParams(new FormData(form))
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                form.reset();
                loadComments(currentPage);
                
                const commentSuccessModal = new bootstrap.Modal(document.getElementById('commentSuccessModal'));
                commentSuccessModal.show();
            } else {
                alert('Lỗi: ' + (data.message || 'Không thể gửi trả lời.'));
            }
        })
        .catch(error => {
            console.error('Error submitting reply:', error);
            alert('Đã xảy ra lỗi khi gửi trả lời. Vui lòng thử lại.');
        })
        .finally(() => {
            submitButton.disabled = false;
            submitButton.innerHTML = originalText;
        });
    }

    function canUserReply() {
        return currentUserId !== null && currentUserId === stadiumOwnerId;
    }

    function updateCommentCount(count) {
        const countElement = document.getElementById('comment-count');
        if (countElement) {
            countElement.textContent = count;
        }
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>
</body>
</html>