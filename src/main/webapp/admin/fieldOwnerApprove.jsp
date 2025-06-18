<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Phê duyệt chủ sân</title>
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

            .approve-management {
                margin-left: 250px;
                padding: 40px;
                width: calc(100% - 250px);
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                min-height: 100vh;
                border-radius: 20px 0 0 0;
                box-shadow: -10px 0 30px rgba(0, 0, 0, 0.1);
            }

            .header-section {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 40px;
                padding-bottom: 20px;
                border-bottom: 2px solid #f0f0f0;
            }

            .header-section h2 {
                font-size: 32px;
                font-weight: 700;
                color: #2d3748;
                margin: 0;
                position: relative;
            }

            .header-section h2::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 0;
                width: 50px;
                height: 4px;
                background: linear-gradient(90deg, #667eea, #764ba2);
                border-radius: 2px;
            }

            .stats-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                padding: 25px;
                border-radius: 16px;
                text-align: center;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: 1px solid #f0f0f0;
                position: relative;
                overflow: hidden;
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #667eea, #764ba2);
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
            }

            .stat-card.pending::before {
                background: linear-gradient(90deg, #f6ad55, #ed8936);
            }

            .stat-card.approved::before {
                background: linear-gradient(90deg, #48bb78, #38a169);
            }

            .stat-card.rejected::before {
                background: linear-gradient(90deg, #e53e3e, #c53030);
            }

            .stat-card .icon {
                font-size: 36px;
                margin-bottom: 15px;
                color: #667eea;
            }

            .stat-card.pending .icon {
                color: #ed8936;
            }

            .stat-card.approved .icon {
                color: #38a169;
            }

            .stat-card.rejected .icon {
                color: #e53e3e;
            }

            .stat-card .number {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 5px;
                color: #2d3748;
            }

            .stat-card .label {
                font-size: 14px;
                color: #718096;
                font-weight: 500;
            }

            .filter-section {
                display: flex;
                gap: 20px;
                margin-bottom: 30px;
                flex-wrap: wrap;
                align-items: center;
            }

            .search-box {
                flex: 1;
                min-width: 300px;
                position: relative;
            }

            .search-box input {
                width: 100%;
                padding: 14px 20px 14px 50px;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 16px;
                transition: border-color 0.3s ease;
                background: white;
            }

            .search-box input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .search-box i {
                position: absolute;
                left: 18px;
                top: 50%;
                transform: translateY(-50%);
                color: #a0aec0;
                font-size: 16px;
            }

            .filter-select {
                padding: 14px 20px;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 16px;
                background: white;
                cursor: pointer;
                transition: border-color 0.3s ease;
                min-width: 160px;
            }

            .filter-select:focus {
                outline: none;
                border-color: #667eea;
            }

            .requests-container {
                display: grid;
                gap: 20px;
                grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            }

            .request-card {
                background: white;
                border-radius: 16px;
                padding: 25px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
                border: 1px solid #f0f0f0;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .request-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(0, 0, 0, 0.12);
            }

            .request-status {
                position: absolute;
                top: 20px;
                right: 20px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-pending {
                background: linear-gradient(135deg, #fed7aa, #fdba74);
                color: #9a3412;
            }

            .status-approved {
                background: linear-gradient(135deg, #bbf7d0, #86efac);
                color: #166534;
            }

            .status-rejected {
                background: linear-gradient(135deg, #fecaca, #fca5a5);
                color: #991b1b;
            }

            .request-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }

            .owner-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea, #764ba2);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                font-size: 18px;
                margin-right: 15px;
            }

            .owner-info h4 {
                margin: 0;
                font-size: 18px;
                font-weight: 600;
                color: #2d3748;
            }

            .owner-info p {
                margin: 5px 0 0 0;
                color: #718096;
                font-size: 14px;
            }

            .request-details {
                margin-bottom: 20px;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                padding: 8px 0;
                border-bottom: 1px solid #f7fafc;
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .detail-label {
                font-weight: 500;
                color: #4a5568;
                font-size: 14px;
            }

            .detail-value {
                color: #2d3748;
                font-weight: 600;
                font-size: 14px;
            }

            .documents-section {
                margin-bottom: 20px;
            }

            .documents-title {
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 10px;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .document-list {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
            }

            .document-item {
                background: #f7fafc;
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 12px;
                color: #4a5568;
                display: flex;
                align-items: center;
                gap: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .document-item:hover {
                background: #edf2f7;
            }

            .action-buttons {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }

            .btn {
                flex: 1;
                padding: 12px 20px;
                border: none;
                border-radius: 10px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-approve {
                background: linear-gradient(135deg, #48bb78, #38a169);
                color: white;
            }

            .btn-approve:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(72, 187, 120, 0.3);
            }

            .btn-reject {
                background: linear-gradient(135deg, #e53e3e, #c53030);
                color: white;
            }

            .btn-reject:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(229, 62, 62, 0.3);
            }

            .btn-view {
                background: linear-gradient(135deg, #3182ce, #2c5282);
                color: white;
            }

            .btn-view:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(49, 130, 206, 0.3);
            }

            .btn-disabled {
                background: #e2e8f0;
                color: #a0aec0;
                cursor: not-allowed;
            }

            .no-data {
                text-align: center;
                padding: 60px 20px;
                color: #718096;
                font-size: 18px;
                grid-column: 1 / -1;
            }

            .no-data i {
                font-size: 64px;
                margin-bottom: 20px;
                opacity: 0.5;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(5px);
            }

            .modal-content {
                background: white;
                margin: 5% auto;
                padding: 30px;
                border-radius: 16px;
                width: 90%;
                max-width: 600px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 2px solid #f0f0f0;
            }

            .modal-header h3 {
                margin: 0;
                color: #2d3748;
                font-size: 20px;
                font-weight: 600;
            }

            .close {
                font-size: 24px;
                cursor: pointer;
                color: #a0aec0;
                transition: color 0.3s ease;
            }

            .close:hover {
                color: #e53e3e;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #4a5568;
            }

            .form-group textarea {
                width: 100%;
                padding: 12px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                resize: vertical;
                min-height: 100px;
                transition: border-color 0.3s ease;
            }

            .form-group textarea:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .modal-actions {
                display: flex;
                gap: 10px;
                justify-content: flex-end;
            }

            .btn-secondary {
                background: #e2e8f0;
                color: #4a5568;
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                transition: background-color 0.3s ease;
            }

            .btn-secondary:hover {
                background: #cbd5e0;
            }

            @media (max-width: 768px) {
                .approve-management {
                    margin-left: 0;
                    width: 100%;
                    padding: 20px;
                    border-radius: 0;
                }

                .header-section {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 20px;
                }

                .stats-cards {
                    grid-template-columns: 1fr;
                }

                .filter-section {
                    flex-direction: column;
                }

                .search-box {
                    min-width: auto;
                }

                .requests-container {
                    grid-template-columns: 1fr;
                }

                .modal-content {
                    width: 95%;
                    margin: 10% auto;
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>

        <div class="main-container">
            <%@ include file="sidebar.jsp" %>

            <div class="approve-management">
                <div class="header-section">
                    <h2><i class="fas fa-clipboard-check"></i> Phê duyệt chủ sân</h2>
                </div>

                <!-- Thống kê -->
                <div class="stats-cards">
                    <div class="stat-card pending">
                        <div class="icon"><i class="fas fa-clock"></i></div>
                        <div class="number">
                            <c:set var="pendingCount" value="0" />
                            <c:forEach var="request" items="${requestList}">
                                <c:if test="${request.status == 'PENDING'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${pendingCount}
                        </div>
                        <div class="label">Chờ duyệt</div>
                    </div>
                    <div class="stat-card approved">
                        <div class="icon"><i class="fas fa-check-circle"></i></div>
                        <div class="number">
                            <c:set var="approvedCount" value="0" />
                            <c:forEach var="request" items="${requestList}">
                                <c:if test="${request.status == 'APPROVED'}">
                                    <c:set var="approvedCount" value="${approvedCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${approvedCount}
                        </div>
                        <div class="label">Đã duyệt</div>
                    </div>
                    <div class="stat-card rejected">
                        <div class="icon"><i class="fas fa-times-circle"></i></div>
                        <div class="number">${fn:length(requestList) - pendingCount - approvedCount}</div>
                        <div class="label">Từ chối</div>
                    </div>
                    <div class="stat-card">
                        <div class="icon"><i class="fas fa-list-alt"></i></div>
                        <div class="number">${fn:length(requestList)}</div>
                        <div class="label">Tổng yêu cầu</div>
                    </div>
                </div>

                <!-- Bộ lọc -->
                <div class="filter-section">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm theo tên chủ sân..." id="searchInput">
                    </div>
                    <select class="filter-select" id="statusFilter">
                        <option value="">Tất cả trạng thái</option>
                        <option value="PENDING">Chờ duyệt</option>
                        <option value="APPROVED">Đã duyệt</option>
                        <option value="REJECTED">Từ chối</option>
                    </select>
                    <select class="filter-select" id="dateFilter">
                        <option value="">Thời gian</option>
                        <option value="today">Hôm nay</option>
                        <option value="week">Tuần này</option>
                        <option value="month">Tháng này</option>
                    </select>
                </div>

                <!-- Danh sách yêu cầu -->
                <c:if test="${empty requestList}">
                    <div class="requests-container">
                        <div class="no-data">
                            <i class="fas fa-clipboard-list"></i>
                            <div>Chưa có yêu cầu phê duyệt nào</div>
                            <div style="font-size: 14px; margin-top: 10px; opacity: 0.7;">
                                Các yêu cầu đăng ký làm chủ sân sẽ hiển thị tại đây
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty requestList}">
                    <div class="requests-container" id="requestsContainer">
                        <c:forEach var="request" items="${requestList}">
                            <div class="request-card" data-status="${request.status}" data-name="${fn:toLowerCase(request.ownerName)}">
                                <div class="request-status status-${fn:toLowerCase(request.status)}">
                                    <c:choose>
                                        <c:when test="${request.status == 'PENDING'}">Chờ duyệt</c:when>
                                        <c:when test="${request.status == 'APPROVED'}">Đã duyệt</c:when>
                                        <c:otherwise>Từ chối</c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="request-header">
                                    <div class="owner-avatar">
                                        ${fn:substring(request.ownerName, 0, 1)}
                                    </div>
                                    <div class="owner-info">
                                        <h4>${request.ownerName}</h4>
                                        <p>${request.email}</p>
                                    </div>
                                </div>

                                <div class="request-details">
                                    <div class="detail-row">
                                        <span class="detail-label">Số điện thoại:</span>
                                        <span class="detail-value">${request.phoneNumber}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Địa chỉ:</span>
                                        <span class="detail-value">${request.address}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Ngày gửi:</span>
                                        <span class="detail-value">
                                            <fmt:formatDate value="${request.submittedDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </span>
                                    </div>
                                    <c:if test="${not empty request.businessLicense}">
                                        <div class="detail-row">
                                            <span class="detail-label">Giấy phép:</span>
                                            <span class="detail-value">${request.businessLicense}</span>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Tài liệu đính kèm -->
                                <div class="documents-section">
                                    <div class="documents-title">
                                        <i class="fas fa-paperclip"></i>
                                        Tài liệu đính kèm
                                    </div>
                                    <div class="document-list">
                                        <div class="document-item">
                                            <i class="fas fa-id-card"></i>
                                            CMND/CCCD
                                        </div>
                                        <div class="document-item">
                                            <i class="fas fa-file-alt"></i>
                                            Giấy phép kinh doanh
                                        </div>
                                        <div class="document-item">
                                            <i class="fas fa-image"></i>
                                            Hình ảnh sân bóng
                                        </div>
                                    </div>
                                </div>

                                <!-- Nút hành động -->
                                <div class="action-buttons">
                                    <c:choose>
                                        <c:when test="${request.status == 'PENDING'}">
                                            <button class="btn btn-approve" onclick="showApproveModal(${request.id})">
                                                <i class="fas fa-check"></i>
                                                Phê duyệt
                                            </button>
                                            <button class="btn btn-reject" onclick="showRejectModal(${request.id})">
                                                <i class="fas fa-times"></i>
                                                Từ chối
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-view" onclick="viewRequestDetails(${request.id})">
                                                <i class="fas fa-eye"></i>
                                                Xem chi tiết
                                            </button>
                                            <c:if test="${request.status == 'APPROVED'}">
                                                <button class="btn btn-reject" onclick="showRejectModal(${request.id})">
                                                    <i class="fas fa-ban"></i>
                                                    Thu hồi
                                                </button>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Modal phê duyệt -->
        <div id="approveModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-check-circle" style="color: #38a169;"></i> Phê duyệt yêu cầu</h3>
                    <span class="close" onclick="closeModal('approveModal')">&times;</span>
                </div>
                <form id="approveForm">
                    <div class="form-group">
                        <label for="approveNote">Ghi chú phê duyệt (tùy chọn):</label>
                        <textarea id="approveNote" name="note" placeholder="Nhập ghi chú cho việc phê duyệt..."></textarea>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeModal('approveModal')">Hủy</button>
                        <button type="submit" class="btn btn-approve">
                            <i class="fas fa-check"></i>
                            Phê duyệt
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal từ chối -->
        <div id="rejectModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-times-circle" style="color: #e53e3e;"></i> Từ chối yêu cầu</h3>
                    <span class="close" onclick="closeModal('rejectModal')">&times;</span>
                </div>
                <form id="rejectForm">
                    <div class="form-group">
                        <label for="rejectReason">Lý do từ chối <span style="color: #e53e3e;">*</span>:</label>
                        <textarea id="rejectReason" name="reason" placeholder="Nhập lý do từ chối yêu cầu..." required></textarea>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeModal('rejectModal')">Hủy</button>
                        <button type="submit" class="btn btn-reject">
                            <i class="fas fa-times"></i>
                            Từ chối
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            let currentRequestId = null;

            // Ripple effect
            document.addEventListener('DOMContentLoaded', function () {
                const buttons = document.querySelectorAll('button');
                buttons.forEach(btn => {
                    btn.style.position = 'relative';
                    btn.style.overflow = 'hidden';

                    btn.addEventListener('click', function (e) {
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

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', function() {
                filterRequests();
            });

            document.getElementById('statusFilter').addEventListener('change', function() {
                filterRequests();
            });

            function filterRequests() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const statusFilter = document.getElementById('statusFilter').value;
                const cards = document.querySelectorAll('.request-card');
                
                cards.forEach(card => {
                    const name = card.dataset.name;
                    const status = card.dataset.status;
                    
                    const matchesSearch = name.includes(searchTerm);
                    const matchesStatus = !statusFilter || status === statusFilter;
                    
                    if (matchesSearch && matchesStatus) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }

            // Modal functions
            function showApproveModal(requestId) {
                currentRequestId = requestId;
                document.getElementById('approveModal').style.display = 'block';
            }

            function showRejectModal(requestId) {
                currentRequestId = requestId;
                document.getElementById('rejectModal').style.display = 'block';
            }

            function closeModal(modalId) {