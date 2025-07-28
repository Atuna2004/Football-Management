<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chỉnh sửa sân bóng</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"  rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts - Roboto -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/crudStadium.css">
    
    <style>
        .current-image {
            max-width: 100%;
            max-height: 250px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .image-preview {
            max-width: 100%;
            max-height: 200px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid #28a745;
        }
        
        .image-upload-area {
            border: 2px dashed #ffc107;
            border-radius: 8px;
            padding: 30px 20px;
            text-align: center;
            background-color: #fff8e1;
            transition: all 0.3s ease;
            cursor: pointer;
            min-height: 150px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        
        .image-upload-area:hover {
            border-color: #ff9800;
            background-color: #fff3c4;
            transform: translateY(-2px);
        }
        
        .image-upload-area.dragover {
            border-color: #ff9800;
            background-color: #fff3c4;
            transform: scale(1.02);
        }
        
        .current-image-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .new-image-section {
            background-color: #e8f5e8;
            border-radius: 8px;
            padding: 15px;
            border: 1px solid #28a745;
        }
        
        .no-image-placeholder {
            background-color: #f8f9fa;
            border: 1px dashed #dee2e6;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
            color: #6c757d;
        }
        
        .upload-icon {
            font-size: 3rem;
            color: #ffc107;
            margin-bottom: 15px;
        }
        
        .btn-remove-image {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(220, 53, 69, 0.8);
            border: none;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            color: white;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-remove-image:hover {
            background-color: rgba(220, 53, 69, 1);
        }
        
        .image-container {
            position: relative;
            display: inline-block;
        }
        
        .form-section {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .section-title {
            color: #495057;
            font-weight: 600;
            margin-bottom: 20px;
            border-bottom: 2px solid #ffc107;
            padding-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container-fluid pt-5">
        <div class="row justify-content-center">
            <div class="col-md-9 col-lg-8">
                <div class="card shadow border-0">
                    <div class="card-header bg-warning text-dark">
                        <h4 class="mb-0">
                            <i class="bi bi-pencil-square me-2"></i>
                            Cập nhật sân bóng: ${stadium.name}
                        </h4>
                    </div>
                    
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/stadium/config?action=update" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="stadiumID" value="${stadium.stadiumID}" />
                            
                            <!-- Stadium Information Section -->
                            <div class="form-section">
                                <h5 class="section-title">
                                    <i class="bi bi-info-circle me-2"></i>
                                    Thông tin sân bóng
                                </h5>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="name" class="form-label">
                                            <i class="bi bi-stadium me-1"></i>
                                            Tên sân <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" name="name" id="name" class="form-control" 
                                               value="${stadium.name}" required placeholder="Nhập tên sân bóng" />
                                    </div>
                                    
                                    <div class="col-md-6 mb-3">
                                        <label for="phoneNumber" class="form-label">
                                            <i class="bi bi-telephone me-1"></i>
                                            Số điện thoại
                                        </label>
                                        <input type="text" name="phoneNumber" id="phoneNumber" class="form-control" 
                                               value="${stadium.phoneNumber}" placeholder="Nhập số điện thoại" />
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="location" class="form-label">
                                        <i class="bi bi-geo-alt me-1"></i>
                                        Địa điểm <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" name="location" id="location" class="form-control" 
                                           value="${stadium.location}" required placeholder="Nhập địa chỉ sân bóng" />
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-8 mb-3">
                                        <label for="description" class="form-label">
                                            <i class="bi bi-card-text me-1"></i>
                                            Mô tả
                                        </label>
                                        <textarea name="description" id="description" class="form-control" rows="4" 
                                                  placeholder="Mô tả chi tiết về sân bóng...">${stadium.description}</textarea>
                                    </div>
                                    
                                    <div class="col-md-4 mb-3">
                                        <label for="status" class="form-label">
                                            <i class="bi bi-toggle-on me-1"></i>
                                            Trạng thái
                                        </label>
                                        <select name="status" id="status" class="form-select">
                                            <option value="active" ${stadium.status == 'active' ? 'selected' : ''}>
                                                <i class="bi bi-check-circle"></i> Hoạt động
                                            </option>
                                            <option value="inactive" ${stadium.status == 'inactive' ? 'selected' : ''}>
                                                <i class="bi bi-x-circle"></i> Không hoạt động
                                            </option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Stadium Image Section -->
                            <div class="form-section">
                                <h5 class="section-title">
                                    <i class="bi bi-image me-2"></i>
                                    Hình ảnh sân bóng
                                </h5>
                                
                                <!-- Current Image Display -->
                                <div class="current-image-section">
                                    <label class="form-label fw-bold text-muted mb-3">
                                        <i class="bi bi-eye me-1"></i>
                                        Hình ảnh hiện tại:
                                    </label>
                                    
                                    <div class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty stadium.imageURL}">
                                                <div class="image-container">
                                                    <img src="${stadium.imageURL}" alt="Stadium Image" class="current-image">
                                                    <div class="mt-3">
                                                        <span class="badge bg-success">
                                                            <i class="bi bi-check-circle me-1"></i>
                                                            Đã có hình ảnh
                                                        </span>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-image-placeholder">
                                                    <i class="bi bi-image" style="font-size: 4rem; color: #dee2e6;"></i>
                                                    <p class="mb-0 mt-3">
                                                        <span class="badge bg-secondary">Chưa có hình ảnh</span>
                                                    </p>
                                                    <small class="text-muted">Hãy tải lên hình ảnh mới bên dưới</small>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- New Image Upload -->
                                <div class="mt-4">
                                    <label class="form-label fw-bold">
                                        <i class="bi bi-cloud-upload me-1"></i>
                                        Tải lên hình ảnh mới (tùy chọn):
                                    </label>
                                    
                                    <div class="image-upload-area" id="imageUploadArea">
                                        <input type="file" name="stadiumImage" id="stadiumImage" class="form-control" accept="image/*" style="display: none;" />
                                        
                                        <div id="uploadPlaceholder">
                                            <i class="bi bi-cloud-upload upload-icon"></i>
                                            <h5 class="text-warning mb-3">Tải lên hình ảnh mới</h5>
                                            <p class="mb-2">
                                                Kéo thả hình ảnh vào đây hoặc 
                                                <span class="text-primary fw-bold" style="cursor: pointer;" onclick="document.getElementById('stadiumImage').click()">
                                                    nhấn để chọn file
                                                </span>
                                            </p>
                                            <small class="text-muted">
                                                <i class="bi bi-info-circle me-1"></i>
                                                Hỗ trợ: JPG, PNG, GIF (Tối đa 10MB)
                                            </small>
                                        </div>
                                        
                                        <div id="imagePreviewContainer" style="display: none;">
                                            <div class="new-image-section">
                                                <p class="text-success mb-3 fw-bold">
                                                    <i class="bi bi-check-circle me-1"></i>
                                                    Hình ảnh mới sẽ được cập nhật:
                                                </p>
                                                <img id="imagePreview" class="image-preview mb-3" alt="New Image Preview">
                                                <div>
                                                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeNewImage()">
                                                        <i class="bi bi-trash me-1"></i>
                                                        Hủy hình ảnh mới
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex justify-content-between align-items-center pt-3">
                                <a href="${pageContext.request.contextPath}/fieldOwner/FOSTD" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>
                                    Quay lại
                                </a>
                                
                                <div>
                                    <button type="reset" class="btn btn-outline-warning me-2" onclick="resetForm()">
                                        <i class="bi bi-arrow-clockwise me-1"></i>
                                        Đặt lại
                                    </button>
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-check-circle me-1"></i>
                                        Cập nhật sân bóng
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Image upload functionality
        const imageInput = document.getElementById('stadiumImage');
        const uploadArea = document.getElementById('imageUploadArea');
        const uploadPlaceholder = document.getElementById('uploadPlaceholder');
        const previewContainer = document.getElementById('imagePreviewContainer');
        const imagePreview = document.getElementById('imagePreview');

        // Click to upload
        uploadArea.addEventListener('click', function(e) {
            if (e.target !== uploadArea && !uploadArea.contains(e.target)) return;
            if (e.target.tagName === 'BUTTON') return;
            if (previewContainer.style.display === 'block') return;
            imageInput.click();
        });

        // File input change
        imageInput.addEventListener('change', function(e) {
            if (e.target.files[0]) {
                handleFile(e.target.files[0]);
            }
        });

        // Drag and drop functionality
        uploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            e.stopPropagation();
            uploadArea.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            e.stopPropagation();
            uploadArea.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            e.stopPropagation();
            uploadArea.classList.remove('dragover');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                imageInput.files = files;
                handleFile(files[0]);
            }
        });

        function handleFile(file) {
            if (!file) return;
            
            // Validate file type
            if (!file.type.startsWith('image/')) {
                alert('❌ Vui lòng chọn file hình ảnh hợp lệ!');
                resetFileInput();
                return;
            }
            
            // Validate file size (10MB)
            if (file.size > 10 * 1024 * 1024) {
                alert('❌ Kích thước file không được vượt quá 10MB!');
                resetFileInput();
                return;
            }

            // Show preview
            const reader = new FileReader();
            reader.onload = function(e) {
                imagePreview.src = e.target.result;
                uploadPlaceholder.style.display = 'none';
                previewContainer.style.display = 'block';
            };
            reader.readAsDataURL(file);
        }

        function removeNewImage() {
            resetFileInput();
            uploadPlaceholder.style.display = 'block';
            previewContainer.style.display = 'none';
            uploadArea.classList.remove('dragover');
        }

        function resetFileInput() {
            imageInput.value = '';
            imagePreview.src = '';
        }

        function resetForm() {
            if (confirm('Bạn có chắc chắn muốn đặt lại tất cả thông tin?')) {
                document.querySelector('form').reset();
                removeNewImage();
            }
        }

        // Prevent form submission on Enter key in input fields
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter' && e.target.type !== 'submit') {
                    e.preventDefault();
                }
            });
        });

        // Auto-resize textarea
        const textarea = document.getElementById('description');
        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });
    </script>
</body>
</html>