<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tạo sân bóng mới</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/crudStadium.css">
    
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
          integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
          crossorigin=""/>

    <style>
        #map {
            height: 300px !important;
            min-height: 300px;
            width: 100%;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background-color: #f8f9fa;
            margin: 10px 0;
        }

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

        .leaflet-tile, .leaflet-marker-icon {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
            -webkit-user-drag: none;
        }

        .leaflet-control-zoom a {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        .coordinate-display {
            background: #e3f2fd;
            border: 1px solid #2196f3;
            border-radius: 6px;
            padding: 12px;
            margin-top: 10px;
            font-family: monospace;
            font-size: 0.9em;
        }

        .coordinate-display .coord-label {
            font-weight: bold;
            color: #1976d2;
        }

        .coordinate-display .coord-value {
            color: #0d47a1;
            background: white;
            padding: 2px 6px;
            border-radius: 3px;
            margin-left: 5px;
        }

        .location-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8em;
            font-weight: 600;
            margin-left: 10px;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-success {
            background: #d1edff;
            color: #0c5460;
            border: 1px solid #b3e5fc;
        }

        .status-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* 🔥 NEW: Debug panel styles */
        .debug-panel {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
            margin-top: 15px;
            font-family: monospace;
            font-size: 0.85em;
        }

        .debug-item {
            margin: 5px 0;
            padding: 3px 0;
        }

        .debug-label {
            font-weight: bold;
            color: #007bff;
            width: 120px;
            display: inline-block;
        }

        .debug-value {
            color: #495057;
            background: white;
            padding: 1px 4px;
            border-radius: 2px;
        }
    </style>
</head>
<body>

<div class="container-fluid py-5 background-container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0"><i class="fas fa-futbol me-2"></i>Tạo Sân Bóng Mới</h4>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/stadium/config?action=create" method="post"
                          id="stadiumForm" novalidate>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">
                                    <i class="fas fa-signature me-2"></i>Tên sân <span class="text-danger">*</span>
                                </label>
                                <input type="text" name="name" id="name" class="form-control" required
                                       pattern="^[a-zA-Z0-9\sÀ-ỹ]+$"
                                       placeholder="Nhập tên sân bóng"/>
                                <div class="invalid-feedback">Tên sân không được chứa ký tự đặc biệt</div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label for="phoneNumber" class="form-label">
                                    <i class="fas fa-phone me-2"></i>Số điện thoại
                                </label>
                                <input type="tel" name="phoneNumber" id="phoneNumber" class="form-control"
                                       pattern="^0\d{9,10}$" placeholder="Nhập số điện thoại liên hệ"/>
                                <div class="invalid-feedback">Số điện thoại phải bắt đầu bằng số 0 và có 10 hoặc 11 số</div>
                            </div>
                        </div>

                        <!-- Location Input -->
                        <div class="mb-3">
                            <label for="location" class="form-label">
                                <i class="bi bi-geo-alt me-1"></i>Địa điểm 
                                <span class="text-danger">*</span>
                                <span id="locationStatus" class="location-status status-pending">Chưa chọn vị trí</span>
                            </label>
                            <input type="text" name="location" id="location" class="form-control"
                                   value="${stadium.location}" required
                                   placeholder="Nhập địa chỉ hoặc chọn trên bản đồ" />
                            <div class="invalid-feedback">Vui lòng nhập địa chỉ hoặc chọn vị trí trên bản đồ</div>
                        </div>

                        <!-- Map Container -->
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-map me-1"></i>Chọn vị trí trên bản đồ
                            </label>
                            <div class="alert alert-info py-2 px-3">
                                <i class="bi bi-info-circle me-2"></i>
                                <small>Click vào bản đồ để chọn vị trí chính xác của sân bóng hoặc kéo thả marker để điều chỉnh vị trí.</small>
                            </div>
                            <div id="map"></div>
                            
                            <!-- Real-time Coordinate Display -->
                            <div class="coordinate-display">
                                <span class="coord-label">📍 Tọa độ hiện tại:</span>
                                <span id="coordinateDisplay">Chưa chọn vị trí trên bản đồ</span>
                            </div>
                        </div>

                        <!-- 🔥 CRITICAL: Hidden inputs with correct names -->
                        <input type="hidden" id="lat" name="latitude" value="${stadium.latitude}" />
                        <input type="hidden" id="lng" name="longitude" value="${stadium.longitude}" />

                        <!-- 🔥 DEBUG: Visible debug panel for testing -->
                        <div class="debug-panel">
                            <h6><i class="fas fa-bug me-2"></i>Debug Panel (để kiểm tra tọa độ)</h6>
                            <div class="debug-item">
                                <span class="debug-label">Latitude:</span>
                                <span class="debug-value" id="debugLat">Chưa có</span>
                            </div>
                            <div class="debug-item">
                                <span class="debug-label">Longitude:</span>
                                <span class="debug-value" id="debugLng">Chưa có</span>
                            </div>
                            <div class="debug-item">
                                <span class="debug-label">Status:</span>
                                <span class="debug-value" id="debugStatus">Đang khởi tạo...</span>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label">
                                <i class="fas fa-info-circle me-2"></i>Mô tả
                            </label>
                            <textarea name="description" id="description" class="form-control" rows="4"
                                      placeholder="Nhập mô tả chi tiết về sân bóng"></textarea>
                        </div>

                        <!-- Status -->
                        <div class="col-md-6 mb-3">
                            <label for="status" class="form-label">
                                <i class="fas fa-toggle-on me-2"></i>Trạng thái
                            </label>
                            <select name="status" id="status" class="form-select">
                                <option value="active">Hoạt động</option>
                                <option value="inactive">Không hoạt động</option>
                            </select>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="d-flex justify-content-end mt-4">
                            <a href="${pageContext.request.contextPath}/fieldOwner/FOSTD"
                               class="btn btn-secondary me-2">
                                <i class="fas fa-times me-2"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save me-2"></i>Lưu sân
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Form Validation Script -->
<script>
    document.getElementById('stadiumForm').addEventListener('submit', function (event) {
        event.preventDefault();

        const name = document.getElementById('name');
        const location = document.getElementById('location');
        const phoneNumber = document.getElementById('phoneNumber');
        const latitude = document.getElementById('lat');
        const longitude = document.getElementById('lng');
        let isValid = true;

        // Validate name
        if (!name.value.trim() || !name.value.match(/^[a-zA-Z0-9\sÀ-ỹ]+$/)) {
            name.classList.add('is-invalid');
            isValid = false;
        } else {
            name.classList.remove('is-invalid');
            name.classList.add('is-valid');
        }

        // Validate location
        if (!location.value.trim()) {
            location.classList.add('is-invalid');
            isValid = false;
        } else {
            location.classList.remove('is-invalid');
            location.classList.add('is-valid');
        }

        // 🔥 CRITICAL: Validate coordinates
        if (!latitude.value || !longitude.value || latitude.value === '' || longitude.value === '') {
            alert('⚠️ Vui lòng chọn vị trí trên bản đồ trước khi lưu sân!');
            document.getElementById('locationStatus').className = 'location-status status-error';
            document.getElementById('locationStatus').textContent = 'Chưa chọn vị trí';
            isValid = false;
        }

        // Validate phone (optional)
        if (phoneNumber.value && !phoneNumber.value.match(/^0\d{9,10}$/)) {
            phoneNumber.classList.add('is-invalid');
            isValid = false;
        } else if (phoneNumber.value) {
            phoneNumber.classList.remove('is-invalid');
            phoneNumber.classList.add('is-valid');
        }

        if (isValid) {
            // 🔥 DEBUG: Log form data before submission
            console.log('=== FORM SUBMISSION ===');
            console.log('Stadium Name:', name.value);
            console.log('Location:', location.value);
            console.log('Latitude:', latitude.value);
            console.log('Longitude:', longitude.value);
            console.log('Phone:', phoneNumber.value);
            console.log('Description:', document.getElementById('description').value);
            console.log('Status:', document.getElementById('status').value);
            console.log('=======================');
            
            // Submit form
            this.submit();
        } else {
            console.log('❌ Form validation failed');
        }
    });
</script>

<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
        crossorigin=""></script>

<!-- Map Script -->
<script>
    (function() {
        'use strict';
        
        let currentMap = null;
        let currentMarker = null;
        let isMapReady = false;

        // 🔥 ENHANCED: Update all coordinate displays
        function updateAllCoordinateDisplays(lat, lng) {
            // Update hidden inputs
            document.getElementById('lat').value = lat.toFixed(6);
            document.getElementById('lng').value = lng.toFixed(6);
            
            // Update coordinate display
            document.getElementById('coordinateDisplay').innerHTML = 
                `<span class="coord-value">Lat: ${lat.toFixed(6)}</span> | <span class="coord-value">Lng: ${lng.toFixed(6)}</span>`;
            
            // Update debug panel
            document.getElementById('debugLat').textContent = lat.toFixed(6);
            document.getElementById('debugLng').textContent = lng.toFixed(6);
            document.getElementById('debugStatus').textContent = 'Đã chọn vị trí';
            
            // Update status
            const statusElement = document.getElementById('locationStatus');
            statusElement.className = 'location-status status-success';
            statusElement.textContent = 'Đã chọn vị trí';
            
            console.log('✅ Updated all coordinate displays:', lat.toFixed(6), lng.toFixed(6));
        }

        function updateLocationStatus(type, message) {
            const statusElement = document.getElementById('locationStatus');
            statusElement.className = `location-status status-${type}`;
            statusElement.textContent = message;
            
            document.getElementById('debugStatus').textContent = message;
        }

        // 🔥 CRITICAL: Enhanced updateLocation function
        window.updateLocation = function(lat, lng) {
            try {
                console.log("📍 Updating coordinates:", lat.toFixed(6), lng.toFixed(6));
                
                // Update all displays
                updateAllCoordinateDisplays(lat, lng);
                
                // Get address with loading indicator
                const locationInput = document.getElementById("location");
                if (locationInput) {
                    const originalValue = locationInput.value;
                    locationInput.value = "🔄 Đang tải địa chỉ...";
                    locationInput.style.color = "#6c757d";
                    
                    setTimeout(function() {
                        reverseGeocode(lat, lng, function(success, address) {
                            if (success && address) {
                                locationInput.value = address;
                                locationInput.style.color = "#212529";
                                locationInput.classList.remove('is-invalid');
                                locationInput.classList.add('is-valid');
                                console.log("✅ Address updated:", address);
                            } else {
                                locationInput.value = originalValue || `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
                                locationInput.style.color = "#212529";
                                console.warn("❌ Could not get address, using coordinates");
                            }
                        });
                    }, 300);
                }
                
            } catch (error) {
                console.error("❌ Error updating location:", error);
            }
        };

        // Reverse geocoding function
        window.reverseGeocode = function(lat, lng, callback) {
            const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&accept-language=vi&zoom=18`;

            fetch(url, {
                headers: { 'User-Agent': 'SanBongApp (contact@example.com)' }
            })
            .then(response => response.json())
            .then(data => {
                if (data && data.display_name) {
                    if (callback) callback(true, data.display_name);
                } else {
                    if (callback) callback(false, null);
                }
            })
            .catch(err => {
                console.warn("Reverse geocoding failed:", err);
                if (callback) callback(false, null);
            });
        };

        // Address geocoding function
        window.geocodeAddress = function(address) {
            const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}&countrycodes=VN&accept-language=vi&limit=1`;
            
            console.log("🔍 Searching for address:", address);
            updateLocationStatus('pending', 'Đang tìm vị trí...');

            fetch(url, {
                headers: { 'User-Agent': 'SanBongApp (contact@example.com)' }
            })
            .then(response => response.json())
            .then(data => {
                if (data && data.length > 0) {
                    const loc = data[0];
                    const lat = parseFloat(loc.lat);
                    const lng = parseFloat(loc.lon);
                    
                    console.log("✅ Found coordinates:", lat, lng);
                    
                    if (currentMap && currentMarker && isMapReady) {
                        currentMap.setView([lat, lng], 15);
                        currentMarker.setLatLng([lat, lng]);
                        updateLocation(lat, lng);
                    }
                } else {
                    console.warn("❌ Address not found:", address);
                    updateLocationStatus('error', 'Không tìm thấy');
                    alert(`Không tìm thấy địa chỉ '${address}'. Vui lòng chọn trực tiếp trên bản đồ.`);
                }
            })
            .catch(err => {
                console.warn("Geocoding error:", err);
                updateLocationStatus('error', 'Lỗi tìm kiếm');
            });
        };

        // Initialize map when DOM is ready
        document.addEventListener('DOMContentLoaded', function() {
            console.log("📄 DOM ready. Initializing map...");

            function initMap() {
                if (typeof L === 'undefined') {
                    console.log("⏳ Waiting for Leaflet...");
                    setTimeout(initMap, 100);
                    return;
                }

                console.log("✅ Leaflet ready!");

                // Default coordinates (Hanoi, Vietnam)
                const defaultLat = 21.0285;
                const defaultLng = 105.8048;

                const latInput = document.getElementById("lat");
                const lngInput = document.getElementById("lng");
                const locationInput = document.getElementById("location");

                let initLat = defaultLat;
                let initLng = defaultLng;

                // Check for existing coordinates
                if (latInput.value && lngInput.value) {
                    const existingLat = parseFloat(latInput.value);
                    const existingLng = parseFloat(lngInput.value);
                    if (!isNaN(existingLat) && !isNaN(existingLng)) {
                        initLat = existingLat;
                        initLng = existingLng;
                        console.log("📍 Using existing coordinates:", initLat, initLng);
                    }
                }

                try {
                    // Initialize map
                    currentMap = L.map('map', {
                        preferCanvas: false,
                        zoomControl: true,
                        attributionControl: true
                    }).setView([initLat, initLng], 15);

                    // Add tile layer
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                        maxZoom: 19,
                        subdomains: ['a', 'b', 'c']
                    }).addTo(currentMap);

                    // Add draggable marker
                    currentMarker = L.marker([initLat, initLng], { 
                        draggable: true,
                        title: 'Kéo thả để chọn vị trí sân bóng'
                    }).addTo(currentMap);

                    // 🔥 CRITICAL: Set initial coordinates
                    updateAllCoordinateDisplays(initLat, initLng);

                    // Map click event
                    currentMap.on("click", function(e) {
                        console.log("🖱️ Map clicked:", e.latlng.lat, e.latlng.lng);
                        currentMarker.setLatLng(e.latlng);
                        currentMap.panTo(e.latlng);
                        updateLocation(e.latlng.lat, e.latlng.lng);
                    });

                    // Marker drag event
                    currentMarker.on("dragend", function(e) {
                        const pos = e.target.getLatLng();
                        console.log("🎯 Marker dragged:", pos.lat, pos.lng);
                        updateLocation(pos.lat, pos.lng);
                    });

                    // Location input with debouncing
                    if (locationInput) {
                        let debounceTimer;
                        locationInput.addEventListener("input", function() {
                            clearTimeout(debounceTimer);
                            debounceTimer = setTimeout(() => {
                                if (this.value.trim() !== "") {
                                    geocodeAddress(this.value.trim());
                                }
                            }, 1000);
                        });
                    }

                    isMapReady = true;
                    console.log("🗺️ Map initialized successfully!");

                    // Ensure proper display
                    setTimeout(() => currentMap.invalidateSize(), 100);

                } catch (error) {
                    console.error("❌ Map initialization error:", error);
                    alert("Error initializing map: " + error.message);
                }
            }

            initMap();
        });

    })();
</script>

</body>
</html>