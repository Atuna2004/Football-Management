<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chỉnh sửa sân bóng</title>
  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/crudStadium.css">
  <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
          integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
          crossorigin=""/>
    <style>
        /* ✅ Bắt buộc: Chiều cao bản đồ */
        #map {
            height: 300px !important;
            min-height: 300px;
            width: 100%;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background-color: #f8f9fa;
            margin: 10px 0;
        }

        /* ✅ Fix CSS cho Edge và các trình duyệt cũ */
        .leaflet-overlay-pane svg {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }
        body {
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
            text-size-adjust: 100%;
        }
        .leaflet-container {
            -webkit-tap-highlight-color: transparent;
            -ms-touch-action: pan-x pan-y;
            touch-action: pan-x pan-y;
        }
        .leaflet-tile, .leaflet-marker-icon, .leaflet-control-zoom a {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        /* === CSS hiện tại của bạn (giữ nguyên) === */
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

<div class="container-fluid py-5 background-container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0"><i class="fas fa-edit me-2"></i>Cập nhật sân bóng</h4>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/stadium/config?action=update" method="post"
                          id="updateStadiumForm" novalidate>
                        <input type="hidden" name="stadiumID" value="${stadium.stadiumID}"/>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="name" class="form-label">
                                        <i class="fas fa-signature me-2"></i>Tên sân
                                    </label>
                                    <input type="text" name="name" id="name" class="form-control"
                                           value="${stadium.name}" required
                                           pattern="^[a-zA-Z0-9\sÀ-ỹ]+$"
                                           placeholder="Nhập tên sân bóng"/>
                                    <div class="invalid-feedback">
                                        Tên sân không được chứa ký tự đặc biệt
                                    </div>
                                </div>
                            </div>
                           <!-- Địa chỉ + Bản đồ Leaflet -->
                                <div class="mb-3">
                                    <label for="location" class="form-label">
                                        <i class="bi bi-geo-alt me-1"></i>
                                        Địa điểm <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" name="location" id="location" class="form-control" 
                                           value="${stadium.location}" required 
                                           placeholder="Nhập địa chỉ hoặc chọn trên bản đồ" />
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">
                                        <i class="bi bi-map me-1"></i>
                                        Chọn vị trí trên bản đồ
                                    </label>
                                    <div id="map"></div>
                                </div>

                                <!-- Tọa độ ẩn -->
                                <input type="hidden" id="lat" name="latitude" value="${stadium.latitude}" />
                                <input type="hidden" id="lng" name="longitude" value="${stadium.longitude}" />

                        <div class="mb-3">
                            <label for="description" class="form-label">
                                <i class="fas fa-info-circle me-2"></i>Mô tả
                            </label>
                            <textarea name="description" id="description" class="form-control"
                                      rows="4"
                                      placeholder="Nhập mô tả chi tiết về sân bóng">${stadium.description}</textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="status" class="form-label">
                                        <i class="fas fa-toggle-on me-2"></i>Trạng thái
                                    </label>
                                    <select name="status" id="status" class="form-select">
                                        <option value="active" ${stadium.status == 'active' ? 'selected' : ''}>
                                            <i class="fas fa-check-circle me-2"></i>Hoạt động
                                        </option>
                                        <option value="inactive" ${stadium.status == 'inactive' ? 'selected' : ''}>
                                            <i class="fas fa-times-circle me-2"></i>Không hoạt động
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="phoneNumber" class="form-label">
                                        <i class="fas fa-phone me-2"></i>Số điện thoại
                                    </label>
                                    <input type="tel" name="phoneNumber" id="phoneNumber" class="form-control"
                                           value="${stadium.phoneNumber}"
                                           pattern="^0\d{9,10}$"
                                           placeholder="Nhập số điện thoại liên hệ"/>
                                    <div class="invalid-feedback">
                                        Số điện thoại phải bắt đầu bằng số 0 và có 10 hoặc 11 số
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end mt-4">
                            <a href="${pageContext.request.contextPath}/fieldOwner/FOSTD"
                               class="btn btn-secondary me-2">
                                <i class="fas fa-times me-2"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save me-2"></i>Cập nhật
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

<script>
    document.getElementById('updateStadiumForm').addEventListener('submit', function (event) {
        event.preventDefault();

        const name = document.getElementById('name');
        const location = document.getElementById('location');
        const phoneNumber = document.getElementById('phoneNumber');
        let isValid = true;

        if (!name.value.match(/^[a-zA-Z0-9\sÀ-ỹ]+$/)) {
            name.classList.add('is-invalid');
            isValid = false;
        } else {
            name.classList.remove('is-invalid');
            name.classList.add('is-valid');
        }

        if (!location.value.match(/^.+,\s*.+,\s*.+$/)) {
            location.classList.add('is-invalid');
            isValid = false;
        } else {
            location.classList.remove('is-invalid');
            location.classList.add('is-valid');
        }

        if (!phoneNumber.value.match(/^0\d{9,10}$/)) {
            phoneNumber.classList.add('is-invalid');
            isValid = false;
        } else {
            phoneNumber.classList.remove('is-invalid');
            phoneNumber.classList.add('is-valid');
        }

        if (isValid) {
            this.submit();
        }
    });

    const inputs = [
        {id: 'name', pattern: /^[a-zA-Z0-9\sÀ-ỹ]+$/},
        {id: 'location', pattern: /^.+,\s*.+,\s*.+$/},
        {id: 'phoneNumber', pattern: /^0\d{9,10}$/}
    ];

    inputs.forEach(input => {
        document.getElementById(input.id).addEventListener('input', function () {
            if (this.value && !this.value.match(input.pattern)) {
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else if (this.value) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            } else {
                this.classList.remove('is-invalid', 'is-valid');
            }
        });
    });
</script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
            integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
            crossorigin=""></script>

    <!-- Script bản đồ Leaflet (từ create stadium) -->
    <script>
        // ✅ Đảm bảo compatibility với Edge và các trình duyệt cũ
        (function() {
            'use strict';

            if (!String.prototype.includes) {
                String.prototype.includes = function(search, start) {
                    if (typeof start !== 'number') start = 0;
                    if (start + search.length > this.length) return false;
                    return this.indexOf(search, start) !== -1;
                };
            }

            function domReady(fn) {
                if (document.readyState === 'complete' || document.readyState === 'interactive') {
                    setTimeout(fn, 1);
                } else {
                    document.addEventListener('DOMContentLoaded', fn);
                }
            }

            domReady(function () {
                console.log("📄 DOM đã sẵn sàng. Đang khởi tạo bản đồ...");
                var mapContainer = document.getElementById("map");
                if (!mapContainer) {
                    console.error("❌ Không tìm thấy thẻ <div id='map'>");
                    alert("Không thể hiển thị bản đồ.");
                    return;
                }

                var attempts = 0;
                var maxAttempts = 50;
                function initMapWhenReady() {
                    attempts++;
                    if (typeof L === 'undefined') {
                        if (attempts < maxAttempts) {
                            console.log("⏳ Đang chờ Leaflet... (attempt " + attempts + ")");
                            setTimeout(initMapWhenReady, 100);
                        } else {
                            console.error("❌ Timeout: Không thể load Leaflet library");
                            alert("Không thể tải thư viện bản đồ. Vui lòng thử lại.");
                        }
                        return;
                    }
                    console.log("✅ Leaflet đã sẵn sàng!");

                    var defaultLat = 21.0285;
                    var defaultLng = 105.8048;
                    var latInput = document.getElementById("lat");
                    var lngInput = document.getElementById("lng");
                    var locationInput = document.getElementById("location");

                    var initLat = latInput.value ? parseFloat(latInput.value) : defaultLat;
                    var initLng = lngInput.value ? parseFloat(lngInput.value) : defaultLng;

                    if (isNaN(initLat) || isNaN(initLng)) {
                        initLat = defaultLat;
                        initLng = defaultLng;
                    }

                    try {
                        var map = L.map('map', {
                            preferCanvas: false,
                            zoomControl: true,
                            attributionControl: true
                        }).setView([initLat, initLng], 15);

                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                            maxZoom: 19
                        }).addTo(map);

                        var marker = L.marker([initLat, initLng], { 
                            draggable: true,
                            title: 'Vị trí sân bóng'
                        }).addTo(map);

                        marker.on("dragend", function(e) {
                            var pos = e.target.getLatLng();
                            setTimeout(function() {
                                updateLocation(pos.lat, pos.lng);
                            }, 500);
                        });

                        map.on("click", function(e) {
                            marker.setLatLng(e.latlng);
                            map.panTo(e.latlng);
                            setTimeout(function() {
                                updateLocation(e.latlng.lat, e.latlng.lng);
                            }, 500);
                        });

                        var debounceTimer;
                        function handleLocationInput() {
                            clearTimeout(debounceTimer);
                            debounceTimer = setTimeout(function() {
                                if (locationInput.value.trim() !== "") {
                                    console.log("🔍 Đang tìm địa chỉ:", locationInput.value);
                                    geocodeAddress(locationInput.value);
                                }
                            }, 1000);
                        }

                        if (locationInput.addEventListener) {
                            locationInput.addEventListener("input", handleLocationInput);
                        } else if (locationInput.attachEvent) {
                            locationInput.attachEvent("oninput", handleLocationInput);
                        }

                        window.currentMap = map;
                        window.currentMarker = marker;

                        if (locationInput.value && locationInput.value.trim() !== "") {
                            setTimeout(function() {
                                geocodeAddress(locationInput.value);
                            }, 1000);
                        }

                        console.log("🗺️ Bản đồ đã được khởi tạo thành công!");
                        setTimeout(function() {
                            map.invalidateSize();
                        }, 100);

                    } catch (error) {
                        console.error("❌ Lỗi khởi tạo bản đồ:", error);
                        alert("Có lỗi khi khởi tạo bản đồ: " + error.message);
                    }
                }
                initMapWhenReady();
            });

            // ✅ Hàm toàn cục
            window.updateLocation = function(lat, lng) {
                console.log("📍 Cập nhật vị trí:", lat.toFixed(6), lng.toFixed(6));
                document.getElementById("lat").value = lat.toFixed(6);
                document.getElementById("lng").value = lng.toFixed(6);

                var locationInput = document.getElementById("location");
                var originalValue = locationInput.value;
                locationInput.value = "🔄 Đang tải địa chỉ...";
                locationInput.style.color = "#6c757d";

                setTimeout(function() {
                    reverseGeocode(lat, lng, function(success, address) {
                        if (success && address) {
                            locationInput.value = address;
                            locationInput.style.color = "#212529";
                            console.log("✅ Địa chỉ:", address);
                        } else {
                            locationInput.value = originalValue;
                            locationInput.style.color = "#212529";
                            console.warn("❌ Không thể lấy địa chỉ");
                        }
                    });
                }, 500);
            };

            window.reverseGeocode = function(lat, lng, callback) {
                var url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=" + lat + "&lon=" + lng + "&accept-language=vi";
                if (window.fetch) {
                    fetch(url, { headers: { 'User-Agent': 'SanBongApp (contact@sanbong.vn)' } })
                    .then(r => r.json())
                    .then(data => {
                        if (data && data.display_name) {
                            callback(true, data.display_name);
                        } else {
                            callback(false, null);
                        }
                    })
                    .catch(() => callback(false, null));
                } else {
                    var xhr = new XMLHttpRequest();
                    xhr.open('GET', url, true);
                    xhr.setRequestHeader('User-Agent', 'SanBongApp (contact@sanbong.vn)');
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                            try {
                                var data = JSON.parse(xhr.responseText);
                                callback(data && data.display_name ? true : false, data.display_name || null);
                            } catch (e) { callback(false, null); }
                        }
                    };
                    xhr.send();
                }
            };

            window.geocodeAddress = function(address) {
                var url = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(address) + "&countrycodes=VN&accept-language=vi&limit=1";
                var locationInput = document.getElementById("location");
                locationInput.style.color = "#6c757d";

                if (window.fetch) {
                    fetch(url, { headers: { 'User-Agent': 'SanBongApp (contact@sanbong.vn)' } })
                    .then(r => r.json())
                    .then(data => {
                        setTimeout(function() {
                            locationInput.style.color = "#212529";
                            if (data && data.length > 0) {
                                var loc = data[0];
                                var lat = parseFloat(loc.lat);
                                var lng = parseFloat(loc.lon);
                                if (window.currentMap && window.currentMarker) {
                                    window.currentMap.setView([lat, lng], 15);
                                    window.currentMarker.setLatLng([lat, lng]);
                                    document.getElementById("lat").value = lat.toFixed(6);
                                    document.getElementById("lng").value = lng.toFixed(6);
                                    locationInput.value = loc.display_name;
                                } else {
                                    document.getElementById("lat").value = lat.toFixed(6);
                                    document.getElementById("lng").value = lng.toFixed(6);
                                    locationInput.value = loc.display_name;
                                }
                            } else {
                                alert("Không tìm thấy địa chỉ '" + address + "'. Vui lòng thử lại.");
                            }
                        }, 500);
                    })
                    .catch(err => {
                        setTimeout(() => {
                            locationInput.style.color = "#212529";
                            alert("Lỗi khi tìm địa chỉ: " + err.message);
                        }, 500);
                    });
                }
            };
        })();
    </script>

    <!-- Script xử lý hình ảnh (giữ nguyên từ file cũ) -->
    <script>
        const imageInput = document.getElementById('stadiumImage');
        const uploadArea = document.getElementById('imageUploadArea');
        const uploadPlaceholder = document.getElementById('uploadPlaceholder');
        const previewContainer = document.getElementById('imagePreviewContainer');
        const imagePreview = document.getElementById('imagePreview');

        uploadArea.addEventListener('click', function(e) {
            if (e.target !== uploadArea && !uploadArea.contains(e.target)) return;
            if (e.target.tagName === 'BUTTON') return;
            if (previewContainer.style.display === 'block') return;
            imageInput.click();
        });

        imageInput.addEventListener('change', function(e) {
            if (e.target.files[0]) handleFile(e.target.files[0]);
        });

        uploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });
        uploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
        });
        uploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                imageInput.files = files;
                handleFile(files[0]);
            }
        });

        function handleFile(file) {
            if (!file) return;
            if (!file.type.startsWith('image/')) {
                alert('❌ Vui lòng chọn file hình ảnh hợp lệ!');
                resetFileInput();
                return;
            }
            if (file.size > 10 * 1024 * 1024) {
                alert('❌ Kích thước file không được vượt quá 10MB!');
                resetFileInput();
                return;
            }
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

        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter' && e.target.type !== 'submit') {
                    e.preventDefault();
                }
            });
        });

        const textarea = document.getElementById('description');
        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });
    </script>
</body>
</html>
