<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý yêu cầu làm chủ sân</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css " rel="stylesheet">
    <style>
        /* Paste toàn bộ CSS bạn đã gửi vào đây */
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
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-card .icon {
            font-size: 24px;
            margin-bottom: 10px;
        }
        .stat-card .number {
            font-size: 36px;
            font-weight: bold;
            color: #333;
        }
        .stat-card .label {
            color: #888;
            font-size: 14px;
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
        .requests-container {
            display: grid;
            gap: 20px;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
        }
        .request-card {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 10px;
            background: #fff;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        .request-status {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            color: white;
        }
        .status-pending { background: #ffe066; color: #5e4d00; }
        .status-approved { background: #a7f3d0; color: #065f46; }
        .status-rejected { background: #fecaca; color: #991b1b; }
        .owner-avatar {
            display: inline-flex;
            width: 40px;
            height: 40px;
            align-items: center;
            justify-content: center;
            background: #4f46e5;
            color: white;
            border-radius: 50%;
            font-weight: bold;
        }
        .detail-row {
            margin-bottom: 10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
        }
        .btn-approve {
            background-color: #48bb78;
            color: white;
        }
        .btn-reject {
            background-color: #e53e3e;
            color: white;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 70%;
            border-radius: 10px;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
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
            .requests-container {
                grid-template-columns: 1fr;
            }
            .modal-content {
                width: 95%;
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
                <div class="icon"><i class="fas fa-check-circle"></i></div>
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
                <div class="icon"><i class="fas fa-times-circle"></i></div>
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
                <div class="icon"><i class="fas fa-list-ul"></i></div>
                <div class="number">${fn:length(requestList)}</div>
                <div class="label">Tổng yêu cầu</div>
            </div>
        </div>
        <!-- Bộ lọc -->
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
        <!-- Danh sách yêu cầu -->
        <c:if test="${empty requestList}">
            <p>Các yêu cầu đăng ký làm chủ sân sẽ hiển thị tại đây</p>
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
                                    <a href="${pageContext.request.contextPath}/uploads/${req.businessLicense}" 
                                       target="_blank" class="detail-value">
                                       Tải xuống file PDF
                                    </a>
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
                            <!-- Chỉ hiển thị nút hành động nếu là PENDING -->
                            <c:if test="${fn:toLowerCase(req.status) == 'pending'}">
                                <div class="actions mt-3">
                                    <button class="btn btn-approve"
                                            onclick="showApproveModal(${req.requestID})">
                                        <i class="fas fa-check"></i> Phê duyệt
                                    </button>
                                    <button class="btn btn-reject"
                                            onclick="showRejectModal(${req.requestID})">
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

<!-- Modal Phê duyệt -->
<div id="approveModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-check-circle" style="color: #38a169;"></i> Phê duyệt yêu cầu</h3>
            <span class="close" onclick="closeModal('approveModal')">&times;</span>
        </div>
        <form action="<c:url value='/admin/approve-request'/>" method="post">
            <input type="hidden" name="requestId" id="approveRequestId">
            <div class="form-group">
                <label for="approveNote">Ghi chú phê duyệt (tùy chọn):</label>
                <textarea id="approveNote" name="note" class="form-control" rows="3"></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeModal('approveModal')">Hủy</button>
                <button type="submit" class="btn btn-approve" name="action" value="approve">Phê duyệt</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Từ chối -->
<div id="rejectModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-times-circle" style="color: #e53e3e;"></i> Từ chối yêu cầu</h3>
            <span class="close" onclick="closeModal('rejectModal')">&times;</span>
        </div>
        <form action="<c:url value='/admin/approve-request'/>" method="post">
            <input type="hidden" name="requestId" id="rejectRequestId">
            <div class="form-group">
                <label for="rejectNote">Lý do từ chối:</label>
                <textarea id="rejectNote" name="note" class="form-control" rows="3" required></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeModal('rejectModal')">Hủy</button>
                <button type="submit" class="btn btn-reject" name="action" value="reject">Từ chối</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showApproveModal(id) {
        document.getElementById('approveRequestId').value = id;
        document.getElementById('approveModal').style.display = "block";
    }
    function showRejectModal(id) {
        document.getElementById('rejectRequestId').value = id;
        document.getElementById('rejectModal').style.display = "block";
    }
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = "none";
    }

    // Tìm kiếm tức thì
    document.getElementById("searchInput").addEventListener("input", function () {
        const filter = this.value.toLowerCase();
        const cards = document.querySelectorAll(".request-card");
        cards.forEach(card => {
            const name = card.getAttribute("data-name");
            if (name.includes(filter)) {
                card.style.display = "";
            } else {
                card.style.display = "none";
            }
        });
    });

    // Lọc theo trạng thái
    document.getElementById("statusFilter").addEventListener("change", function () {
        const selectedStatus = this.value.toLowerCase();
        const cards = document.querySelectorAll(".request-card");
        cards.forEach(card => {
            const status = card.getAttribute("data-status").toLowerCase();
            if (selectedStatus === "" || status === selectedStatus) {
                card.style.display = "";
            } else {
                card.style.display = "none";
            }
        });
    });
</script>
</body>
</html>