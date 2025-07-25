<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý yêu cầu làm chủ sân</title>
    
    <!-- External CSS Links -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Owner Request CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ownerRequest.css" />
</head>
<body>
    <div class="main-container">
        <%@ include file="sidebar.jsp" %>
        
        <div class="approve-management">
            <!-- Header Section -->
            <div class="header-section">
                <h2>
                    <i class="fas fa-clipboard-check"></i> 
                    Phê duyệt chủ sân
                </h2>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-cards">
                <div class="stat-card pending">
                    <div class="icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="number">
                        <c:set var="pendingCount" value="0" />
                        <c:forEach var="req" items="${requestList}">
                            <c:if test="${fn:toLowerCase(req.status) == 'pending'}">
                                <c:set var="pendingCount" value="${pendingCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${pendingCount}
                    </div>
                    <div class="label">Chờ duyệt</div>
                </div>
                
                <div class="stat-card approved">
                    <div class="icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="number">
                        <c:set var="approvedCount" value="0" />
                        <c:forEach var="req" items="${requestList}">
                            <c:if test="${fn:toLowerCase(req.status) == 'approved'}">
                                <c:set var="approvedCount" value="${approvedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${approvedCount}
                    </div>
                    <div class="label">Đã duyệt</div>
                </div>
                
                <div class="stat-card rejected">
                    <div class="icon">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="number">
                        <c:set var="rejectedCount" value="0" />
                        <c:forEach var="req" items="${requestList}">
                            <c:if test="${fn:toLowerCase(req.status) == 'rejected'}">
                                <c:set var="rejectedCount" value="${rejectedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${rejectedCount}
                    </div>
                    <div class="label">Từ chối</div>
                </div>
                
                <div class="stat-card total">
                    <div class="icon">
                        <i class="fas fa-list-ul"></i>
                    </div>
                    <div class="number">${fn:length(requestList)}</div>
                    <div class="label">Tổng yêu cầu</div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Tìm theo tên...">
                </div>
                <select id="statusFilter" class="filter-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="PENDING">Chờ duyệt</option>
                    <option value="APPROVED">Đã duyệt</option>
                    <option value="REJECTED">Từ chối</option>
                </select>
            </div>

            <!-- Request Cards Container -->
            <c:if test="${empty requestList}">
                <div class="empty-state">
                    <i class="fas fa-clipboard-check"></i>
                    <h3>Chưa có yêu cầu nào</h3>
                    <p>Các yêu cầu đăng ký làm chủ sân sẽ hiển thị tại đây khi có người dùng gửi yêu cầu.</p>
                </div>
            </c:if>

            <c:if test="${not empty requestList}">
                <div class="requests-container" id="requestsContainer">
                    <c:forEach var="req" items="${requestList}">
                        <div class="request-card" data-status="${req.status}" data-name="${fn:toLowerCase(req.fullName)}">
                            <div class="request-status status-${fn:toLowerCase(req.status)}">
                                <c:choose>
                                    <c:when test="${req.status == 'PENDING'}">Chờ duyệt</c:when>
                                    <c:when test="${req.status == 'APPROVED'}">Đã duyệt</c:when>
                                    <c:otherwise>Từ chối</c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="request-header d-flex align-items-center mb-3">
                                <div class="owner-avatar me-3">
                                    ${fn:substring(req.fullName, 0, 1)}
                                </div>
                                <div class="owner-info">
                                    <h5>${req.fullName}</h5>
                                    <small>${req.email}</small>
                                </div>
                            </div>
                            
                            <div class="request-details">
                                <div class="detail-row">
                                    <span class="detail-label">Số điện thoại:</span>
                                    <span class="detail-value">${req.phoneNumber}</span>
                                </div>
                                
                                <c:if test="${not empty req.businessLicense}">
                                    <div class="detail-row">
                                        <span class="detail-label">Giấy phép kinh doanh:</span>
                                        <span class="detail-value">
                                            <a href="${pageContext.request.contextPath}/uploads/${req.businessLicense}" 
                                               target="_blank">
                                               <i class="fas fa-file-pdf"></i> Tải xuống file PDF
                                            </a>
                                        </span>
                                    </div>
                                </c:if>
                                
                                <div class="detail-row">
                                    <span class="detail-label">Ngày gửi:</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${req.submittedDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </span>
                                </div>
                                
                                <div class="detail-row">
                                    <span class="detail-label">Lý do:</span>
                                    <span class="detail-value">${req.message}</span>
                                </div>
                                
                                <c:if test="${not empty req.adminNote}">
                                    <div class="detail-row">
                                        <span class="detail-label">Ghi chú admin:</span>
                                        <span class="detail-value">${req.adminNote}</span>
                                    </div>
                                </c:if>
                                
                                <!-- Action buttons only for pending requests -->
                                <c:if test="${fn:toLowerCase(req.status) == 'pending'}">
                                    <div class="actions mt-3">
                                        <button class="btn btn-approve" onclick="showApproveModal(${req.requestID})">
                                            <i class="fas fa-check"></i> Phê duyệt
                                        </button>
                                        <button class="btn btn-reject" onclick="showRejectModal(${req.requestID})">
                                            <i class="fas fa-ban"></i> Từ chối
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Approve Modal -->
    <div id="approveModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>
                    <i class="fas fa-check-circle" style="color: #10b981;"></i> 
                    Phê duyệt yêu cầu
                </h3>
                <button class="close" onclick="closeModal('approveModal')">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form action="<c:url value='/admin/approve-request'/>" method="post">
                <input type="hidden" name="requestId" id="approveRequestId">
                <div class="form-group">
                    <label for="approveNote">Ghi chú phê duyệt (tùy chọn):</label>
                    <textarea id="approveNote" name="note" class="form-control" rows="4" 
                              placeholder="Nhập ghi chú cho quyết định phê duyệt..."></textarea>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('approveModal')">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                    <button type="submit" class="btn btn-approve" name="action" value="approve">
                        <i class="fas fa-check"></i> Phê duyệt
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Reject Modal -->
    <div id="rejectModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>
                    <i class="fas fa-times-circle" style="color: #ef4444;"></i> 
                    Từ chối yêu cầu
                </h3>
                <button class="close" onclick="closeModal('rejectModal')">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form action="<c:url value='/admin/approve-request'/>" method="post">
                <input type="hidden" name="requestId" id="rejectRequestId">
                <div class="form-group">
                    <label for="rejectNote">Lý do từ chối:</label>
                    <textarea id="rejectNote" name="note" class="form-control" rows="4" required 
                              placeholder="Nhập lý do từ chối yêu cầu..."></textarea>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('rejectModal')">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                    <button type="submit" class="btn btn-reject" name="action" value="reject">
                        <i class="fas fa-ban"></i> Từ chối
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Modal functions
        function showApproveModal(id) {
            document.getElementById('approveRequestId').value = id;
            document.getElementById('approveModal').style.display = "block";
            document.body.style.overflow = 'hidden';
        }

        function showRejectModal(id) {
            document.getElementById('rejectRequestId').value = id;
            document.getElementById('rejectModal').style.display = "block";
            document.body.style.overflow = 'hidden';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
            document.body.style.overflow = 'auto';
            
            // Clear form data
            if (modalId === 'approveModal') {
                document.getElementById('approveNote').value = '';
            } else if (modalId === 'rejectModal') {
                document.getElementById('rejectNote').value = '';
            }
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const approveModal = document.getElementById('approveModal');
            const rejectModal = document.getElementById('rejectModal');
            
            if (event.target === approveModal) {
                closeModal('approveModal');
            } else if (event.target === rejectModal) {
                closeModal('rejectModal');
            }
        };

        // Search functionality
        document.getElementById("searchInput").addEventListener("input", function () {
            const filter = this.value.toLowerCase();
            const cards = document.querySelectorAll(".request-card");
            
            cards.forEach(card => {
                const name = card.getAttribute("data-name");
                if (name.includes(filter)) {
                    card.style.display = "";
                    card.style.animation = "fadeIn 0.3s ease-in";
                } else {
                    card.style.display = "none";
                }
            });
        });

        // Status filter functionality
        document.getElementById("statusFilter").addEventListener("change", function () {
            const selectedStatus = this.value.toLowerCase();
            const cards = document.querySelectorAll(".request-card");
            
            cards.forEach(card => {
                const status = card.getAttribute("data-status").toLowerCase();
                if (selectedStatus === "" || status === selectedStatus) {
                    card.style.display = "";
                    card.style.animation = "fadeIn 0.3s ease-in";
                } else {
                    card.style.display = "none";
                }
            });
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Escape to close modal
            if (e.key === 'Escape') {
                closeModal('approveModal');
                closeModal('rejectModal');
            }
        });

        // Button ripple effects
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn');
            
            buttons.forEach(btn => {
                btn.style.position = 'relative';
                btn.style.overflow = 'hidden';
                
                btn.addEventListener('click', function(e) {
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

            // Add dynamic CSS for animations
            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    to {
                        transform: scale(2);
                        opacity: 0;
                    }
                }
                
                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
                
                .request-card {
                    animation: fadeIn 0.6s ease-out;
                }
            `;
            document.head.appendChild(style);

            console.log('Owner Request Management page initialized successfully!');
        });
    </script>
</body>
</html>