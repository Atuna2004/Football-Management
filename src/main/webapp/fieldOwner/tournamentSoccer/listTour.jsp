<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sân bóng - Field Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stadiumList.css">
    <style>
        .btn-group .btn {
            min-width: 36px;
            padding-left: 0.75rem;
            padding-right: 0.75rem;
            white-space: nowrap;
            border-radius: 0 !important;
        }
    </style>
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <div class="logo">
                <h3>
                    <a class="item" href="<%= request.getContextPath() %>/home.jsp">
                        <i class="fas fa-futbol me-2"></i>
                    </a>
                    Field Manager Page
                </h3>
            </div>

            <%
                User currentUser = (User) session.getAttribute("currentUser");
                if (currentUser != null) {
            %>
            <div class="user-greeting">
                <i class="fas fa-user-circle"></i>
                Xin chào, <%= currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getEmail() %>
            </div>
            <%
                } else {
            %>
            <div class="account item">
                <a class="register me-2" href="<%= request.getContextPath() %>/account/register.jsp">Đăng ký</a>
                <a href="<%= request.getContextPath() %>/account/login.jsp">Đăng nhập</a>
            </div>
            <%
                }
            %>
        </div>
    </div>  

    <div class="dashboard-container">
        <!-- Left Navigation Sidebar -->
        <%@ include file="../FieldOwnerSB.jsp" %>

        <main class="main-content">
            <div class="container-fluid">
                <% 
                    String successMsg = (String) session.getAttribute("success");
                    String errorMsg = (String) session.getAttribute("error");
                    if (successMsg != null) {
                %>
                    <div class="alert alert-success alert-dismissible fade show mt-3" role="alert" id="autoHideSuccess">
                        <%= successMsg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <%
                        session.removeAttribute("success");
                    }
                    if (errorMsg != null) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert" id="autoHideError">
                        <%= errorMsg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <%
                        session.removeAttribute("error");
                    }
                %>
                <!-- Header Section -->
                <div class="row row-cols-1 row-cols-md-3 mb-4">
                    <div class="col mt-3">
                        <h3><i class="fas fa-trophy me-2"></i>Danh sách giải đấu</h3>
                    </div>
                    <div class="col mt-3">
                        <form action="<%= request.getContextPath() %>/tournament-search" method="get">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Tìm kiếm giải đấu..." 
                                       name="searchT" aria-label="Search input" value="${param.searchT}">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                                
                    <!-- Nút thêm mới -->
                    <div class="col mt-3 text-end">
                        <button class="btn btn-success text-white" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="fas fa-plus me-2"></i> Thêm giải mới
                        </button>
                    </div>           
                </div>
                
                <!-- Tournament Table -->
                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th>STT</th>
                                        <th>Image</th>
                                        <th>Tên giải đấu</th>
                                        <th>Sân</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Ngày kết thúc</th>
                                        <th>Tạo vào</th>
                                        <th>Số đội tối đa</th>
                                        <th>Số đội hiện tại</th> 
                                        <th>Giải thưởng</th>
                                        <th style="width:120px">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty list}">
                                            <tr>
                                                <td colspan="7" class="text-center py-5">
                                                    <div class="text-muted">
                                                        <i class="fas fa-trophy fa-3x mb-3"></i>
                                                        <p class="mb-0">Chưa có giải đấu nào</p>
                                                        <small>Hãy thêm giải đấu đầu tiên của bạn!</small>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when> 
                                            <c:otherwise>
                                                <c:forEach items="${list}" var="t" >
                                                    <tr class="tournament-row" data-tournament-id="${t.tournamentID}"> 
                                                        <td>${t.tournamentID}</td>
                                                        <td>${t.name}</td>
                                                        <td>${t.stadiumName}</td>
                                                        <td>${t.startDate}</td>
                                                        <td>${t.endDate}</td>
                                                        <td>${t.createdAt}</td>
                                                        <td>${t.totalTeams}</td>
                                                        <td>${t.quantityTeams}</td>
                                                        <td>
                                                            <fmt:formatNumber value="${t.award}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                        </td>
                                                        <td style="width:120px">
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/tournament/registered-teams?tournamentId=${t.tournamentID}"
                                                                class="btn btn-info btn-sm d-flex align-items-center justify-content-center"
                                                                title="Xem đội đăng ký" style="min-width:36px;">
                                                                    <i class="fas fa-users"></i>
                                                                </a>
                                                                <button type="button"
                                                                    class="btn btn-primary btn-sm btn-action btn-edit-tournament d-flex align-items-center justify-content-center"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#editModal"
                                                                    data-id="${t.tournamentID}"
                                                                    data-name="${t.name}"
                                                                    data-description="${t.description}"
                                                                    data-start="${t.startDate}"
                                                                    data-end="${t.endDate}"
                                                                    data-stadium="${t.stadiumID}"
                                                                    data-image="${t.imageUrl}"
                                                                    data-totalteams="${t.totalTeams}"
                                                                    data-quantityteams="${t.quantityTeams}"
                                                                    data-award="${t.award}">
                                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                                </button>
                                                                <button type="button"
                                                                    class="btn btn-danger btn-sm btn-action btn-delete-tournament d-flex align-items-center justify-content-center"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#deleteModal"
                                                                    data-id="${t.tournamentID}"
                                                                    data-name="${t.name}">
                                                                    <i class="fa-solid fa-trash-can"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                    </c:choose>  
                                </tbody>
                            </table>
                        </div>
                    </div>                              
                </div> 
                
                <!-- Pagination -->
                <c:if test="${totalPages > 0}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&search=${param.search}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
            
            <!-- =================== MODAL ADD =================== -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <!-- Kiểm tra action và method -->
        <form action="${pageContext.request.contextPath}/add-tournament" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm Giải Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- Tên -->
                <div class="mb-3">
                    <label class="form-label">Tên giải đấu</label>
                    <!-- Kiểm tra name -->
                    <input type="text" name="nameTournament" class="form-control" required>
                </div>
                <!-- Sân -->
                <div class="mb-3">
                    <label class="form-label">Sân</label>
                    <!-- Kiểm tra name -->
                    <select name="stadiumId" class="form-select" required>
                        <c:forEach var="s" items="${stadiums}">
                            <option value="${s.stadiumID}">${s.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <!-- Mô tả (không bắt buộc) -->
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea name="description" class="form-control" rows="2" id="description"></textarea>
                </div>
                <!-- StartDate -->
                <div class="mb-3">
                    <label class="form-label">Ngày bắt đầu</label>
                    <!-- Kiểm tra name -->
                    <input type="date" name="startDate" class="form-control" required>
                </div>
                <!-- EndDate -->
                <div class="mb-3">
                    <label class="form-label">Ngày kết thúc</label>
                    <!-- Kiểm tra name -->
                    <input type="date" name="endDate" class="form-control" required>
                </div>
                <!-- Tổng số đội -->
                <div class="mb-3">
                    <label class="form-label">Tổng số đội</label>
                    <input type="number" name="totalTeams" class="form-control" min="2" id="totalTeams" required>
                </div>
                <!-- Giải thưởng -->
                <div class="mb-3">
                    <label class="form-label">Giải thưởng (VNĐ)</label>
                    <input type="number" name="award" class="form-control" min="0" step="1000" id="award" required>
                </div>
                <input type="hidden" name="imageUrl" id="imageUrl">
                <!-- AI Gen Ảnh -->
                <div class="mb-3 text-center">
                    <img id="ai-image-preview" src="#" alt="Ảnh giải đấu sẽ hiển thị ở đây" style="display:none; max-width:100%; max-height:200px; margin-top:10px; border-radius:8px;"/>
                </div>
            </div>
            <div class="modal-footer">
                <div class="d-flex flex-column flex-md-row w-100 gap-2">
                    <button type="button" class="btn btn-outline-secondary flex-fill" id="btn-ai-improve">
                        <i class="fa-solid fa-wand-magic-sparkles"></i> AI cải thiện nội dung
                    </button>
                    <button type="button" class="btn btn-outline-info flex-fill" id="btn-ai-gen-image">
                        <i class="fa-solid fa-image"></i> AI gen ảnh
                    </button>
                    <button type="submit" class="btn btn-orange flex-fill">Thêm giải</button>
                    <button type="button" class="btn btn-secondary flex-fill" data-bs-dismiss="modal">Huỷ</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Modal Edit Tournament -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form id="editForm" action="${pageContext.request.contextPath}/edit-tournament" method="post" enctype="multipart/form-data" class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editModalLabel">Chỉnh sửa giải đấu</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="tournamentId" id="editTournamentID">

        <div class="mb-3">
          <label class="form-label">Tên giải đấu</label>
          <input type="text" name="nameTournament" id="editName" class="form-control" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Mô tả</label>
          <textarea name="description" id="editDescription" class="form-control" rows="2"></textarea>
        </div>
        <div class="mb-3">
          <label class="form-label">Ngày bắt đầu</label>
          <input type="date" name="startDate" id="editStartDate" class="form-control" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Ngày kết thúc</label>
          <input type="date" name="endDate" id="editEndDate" class="form-control" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Sân</label>
          <select name="stadiumId" id="editStadium" class="form-select" required>
            <c:forEach var="s" items="${stadiums}">
              <option value="${s.stadiumID}">${s.name}</option>
            </c:forEach>
          </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Tổng số đội tối đa</label>
            <input type="number" name="totalTeams" id="editTotalTeams" class="form-control" min="2" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Số lượng đội hiện tại</label>
            <input type="number" id="editQuantityTeams" class="form-control" readonly>
        </div>
        <div class="mb-3">
            <label class="form-label">Giải thưởng (VNĐ)</label>
            <input type="number" name="award" id="editAward" class="form-control" min="0" step="1000" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Ảnh giải đấu</label>
          <input type="file" name="imageFile" id="editImageFile" class="form-control" accept="image/*">
          <div class="mt-2 text-center">
            <img id="editImagePreview" src="#" alt="Preview ảnh giải đấu" style="max-width:100%;max-height:200px;display:none;border-radius:8px;">
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
      </div>
    </form>
  </div>
</div>


    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle text-warning me-2"></i>Xác nhận xóa
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa giải đấu <strong id="tournamentName"></strong> không?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Việc xóa giải đấu sẽ ảnh hưởng đến các đội bóng!
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <form id="deleteForm" method="get" action="${pageContext.request.contextPath}/delete-tournament" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="tournamentID" id="deleteId">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-2"></i>Xóa
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://esm.run/@google/generative-ai"></script>
            <script type="module">
                import { GoogleGenAI, Modality } from "https://esm.run/@google/genai";
                const ai = new GoogleGenAI({apiKey: "AIzaSyARZh7ZkALP9zrvJ5l99vAFfILIQWtHU0k"});

                document.getElementById('btn-ai-improve').onclick = async function () {
                    const name = document.querySelector('input[name="nameTournament"]').value.trim();
                    const desc = document.getElementById('description').value.trim();
                    const totalTeams = document.getElementById('totalTeams').value.trim();
                    const award = document.getElementById('award').value.trim();

                    // Hiển thị trạng thái đang xử lý
                    const btn = document.getElementById('btn-ai-improve');
                    const oldText = btn.innerHTML;
                    btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang cải thiện...';
                    btn.disabled = true;

                    try {
                        const res = await fetch('${pageContext.request.contextPath}/aiImproveTournament', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/json'},
                            body: JSON.stringify({
                                nameTournament: name,
                                description: desc,
                                totalTeams: totalTeams,
                                award: award
                            })
                        });
                        const data = await res.json();
                        if (data.nameTournament) {
                            document.querySelector('input[name="nameTournament"]').value = data.nameTournament;
                        }
                        if (data.improvedDescription) {
                            document.getElementById('description').value = data.improvedDescription;
                        }
                        if (!data.nameTournament && !data.improvedDescription) {
                            alert("Không nhận được kết quả từ AI!");
                        }
                    } catch (e) {
                        alert("Lỗi khi gọi AI: " + e.message);
                    }
                    btn.innerHTML = oldText;
                    btn.disabled = false;
                };

                // AI gen ảnh (giữ nguyên như bạn đã có)
                document.getElementById('btn-ai-gen-image').onclick = async function () {
                    const preview = document.getElementById('ai-image-preview');
                    let loading = document.getElementById('ai-gen-image-loading');
                    if (!loading) {
                        loading = document.createElement('div');
                        loading.id = 'ai-gen-image-loading';
                        loading.className = 'text-center mb-2';
                        loading.innerHTML = '<div class="alert alert-info">Đang sinh ảnh AI, vui lòng chờ...</div>';
                        preview.parentNode.insertBefore(loading, preview);
                    }
                    preview.style.display = "none";
                    loading.style.display = "block";
                    let prompt = document.querySelector('input[name="nameTournament"]').value || "football tournament";
                    try {
                        // Gọi Gemini AI sinh ảnh (client-side)
                        const response = await ai.models.generateContent({
                            model: "gemini-2.0-flash-preview-image-generation",
                            contents: [{role: "user", parts: [{text: prompt}]}],
                            config: {
                                responseModalities: ["TEXT", "IMAGE"],
                            },
                        });
                        let imageUrl = null;
                        for (const part of response.candidates[0].content.parts) {
                            if (part.inlineData) {
                                imageUrl = "data:image/png;base64," + part.inlineData.data;
                                break;
                            }
                        }
                        if (imageUrl) {
                            // Gửi ảnh base64 lên server để upload lên Cloudinary
                            const res = await fetch('${pageContext.request.contextPath}/aiGenImage', {
                                method: 'POST',
                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                body: 'imageData=' + encodeURIComponent(imageUrl)
                            });
                            const data = await res.json();
                            if (data.url) {
                                preview.src = data.url;
                                preview.style.display = "block";
                                document.getElementById('imageUrl').value = data.url;
                            } else {
                                alert("Không upload được ảnh lên server!");
                            }
                        } else {
                            alert("Không nhận được ảnh nào từ AI!");
                        }
                    } catch (e) {
                        alert("Lỗi khi sinh ảnh AI: " + e.message);
                    }
                    loading.style.display = "none";
                };
            </script>
            <script>
                document.querySelectorAll('.btn-edit-tournament').forEach(btn => {
                    btn.addEventListener('click', function () {
                        document.getElementById('editTournamentID').value = this.getAttribute('data-id');
                        document.getElementById('editName').value = this.getAttribute('data-name');
                        document.getElementById('editDescription').value = this.getAttribute('data-description') || '';
                        document.getElementById('editStartDate').value = this.getAttribute('data-start');
                        document.getElementById('editEndDate').value = this.getAttribute('data-end');
                        document.getElementById('editStadium').value = this.getAttribute('data-stadium');
                        document.getElementById('editTotalTeams').value = this.getAttribute('data-totalteams');
                        document.getElementById('editQuantityTeams').value = this.getAttribute('data-quantityteams');
                        document.getElementById('editAward').value = this.getAttribute('data-award');
                        // Preview ảnh
                        const imgUrl = this.getAttribute('data-image');
                        const imgPreview = document.getElementById('editImagePreview');
                        if (imgUrl && imgUrl !== 'null') {
                            imgPreview.src = imgUrl;
                            imgPreview.style.display = 'block';
                        } else {
                            imgPreview.src = '#';
                            imgPreview.style.display = 'none';
                        }
                        // Reset file input
                        document.getElementById('editImageFile').value = '';
                    });
                });

                // Preview ảnh khi chọn file mới
                document.getElementById('editImageFile').addEventListener('change', function (e) {
                    const [file] = this.files;
                    const imgPreview = document.getElementById('editImagePreview');
                    if (file) {
                        imgPreview.src = URL.createObjectURL(file);
                        imgPreview.style.display = 'block';
                    }
                });
            </script>
            <script>
                document.querySelectorAll('.btn-delete-tournament').forEach(btn => {
                    btn.addEventListener('click', function () {
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        document.getElementById('deleteId').value = id;
                        document.getElementById('tournamentName').textContent = name;
                    }); 
                });
            </script>    
            <script>
                setTimeout(function() {
                    const success = document.getElementById('autoHideSuccess');
                    if (success) {
                          success.classList.remove('show');
                          setTimeout(() => success.remove(), 500);
                    }
                    const error = document.getElementById('autoHideError');
                    if (error) {
                        error.classList.remove('show');
                        setTimeout(() => error.remove(), 500);
                    }
                }, 3000);
            </script>  
    </body>
</html>