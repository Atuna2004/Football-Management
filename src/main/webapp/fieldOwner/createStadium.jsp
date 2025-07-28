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

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">


    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">


    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/crudStadium.css">
  <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
          integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
          crossorigin=""/>

    <style>
        /* ✅ BẮT BUỘC: Đảm bảo bản đồ có chiều cao */
        #map {
            height: 300px !important;
            min-height: 300px;
            width: 100%;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background-color: #f8f9fa;
            margin: 10px 0;
        }

        /* ✅ Fix CSS cho Edge: Hỗ trợ tất cả trình duyệt */
        .leaflet-overlay-pane svg {
            -webkit-user-select: none; /* Safari, Chrome, Edge */
            -moz-user-select: none;    /* Firefox */
            -ms-user-select: none;     /* Internet Explorer/Edge Legacy */
            user-select: none;         /* Standard property */
        }

        body {
            -webkit-text-size-adjust: 100%; /* Safari, Chrome, Edge */
            -ms-text-size-adjust: 100%;     /* Internet Explorer/Edge Legacy */
            text-size-adjust: 100%;         /* Standard property */
        }

        th {
            -webkit-text-align-last: auto;  /* Safari, Chrome, Edge */
            -moz-text-align-last: auto;     /* Firefox */
            -ms-text-align-last: auto;      /* Internet Explorer/Edge Legacy */
            text-align-last: auto;          /* Standard property */
            text-align: start;              /* Fallback cho Edge cũ */
        }

        /* ✅ Thêm CSS hỗ trợ Edge cho các component Leaflet */
        .leaflet-container {
            -webkit-tap-highlight-color: transparent;
            -ms-touch-action: pan-x pan-y;
            touch-action: pan-x pan-y;
        }

        .leaflet-tile {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
            -webkit-user-drag: none;
        }

        .leaflet-marker-icon {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        /* ✅ Fix cho Edge: Đảm bảo buttons hoạt động đúng */
        .leaflet-control-zoom a {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }
    </style>
</head>

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
                                <div class="form-group">
                                    <label for="name" class="form-label"><i class="fas fa-signature me-2"></i>Tên
                                        sân</label>
                                    <input type="text" name="name" id="name" class="form-control" required
                                           pattern="^[a-zA-Z0-9\sÀ-ỹ]+$"
                                           placeholder="Nhập tên sân bóng"/>
                                    <div class="invalid-feedback">
                                        Tên sân không được chứa ký tự đặc biệt
                                    </div>
                                </div>
                            </div>
                           <div class="mb-3">
                                <label for="location" class="form-label">
                                    <i class="bi bi-geo-alt me-1"></i>
                                    Địa điểm <span class="text-danger">*</span>
                                </label>
                                <input type="text" name="location" id="location" class="form-control"
                                       value="${stadium.location}" required
                                       placeholder="Nhập địa chỉ hoặc chọn trên bản đồ" />
                            </div>

                            <!-- Bản đồ OpenStreetMap -->
                            <div class="mb-3">
                                <label class="form-label">
                                    <i class="bi bi-map me-1"></i>
                                    Chọn vị trí trên bản đồ
                                </label>
                                <div id="map"></div>
                            </div>

                            <!-- Ẩn lat/lng để gửi lên server -->
                            <input type="hidden" id="lat" name="latitude" value="${stadium.latitude}" />
                            <input type="hidden" id="lng" name="longitude" value="${stadium.longitude}" />


                        <div class="mb-3">
                            <label for="description" class="form-label"><i class="fas fa-info-circle me-2"></i>Mô
                                tả</label>
                            <textarea name="description" id="description" class="form-control" rows="4"
                                      placeholder="Nhập mô tả chi tiết về sân bóng"></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="status" class="form-label"><i class="fas fa-toggle-on me-2"></i>Trạng
                                        thái</label>
                                    <select name="status" id="status" class="form-select">
                                        <option value="active">Hoạt động</option>
                                        <option value="inactive">Không hoạt động</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="phoneNumber" class="form-label"><i class="fas fa-phone me-2"></i>Số điện
                                        thoại</label>
                                    <input type="tel" name="phoneNumber" id="phoneNumber" class="form-control"
                                           pattern="^0\d{9}$"
                                           placeholder="Nhập số điện thoại liên hệ"/>
                                    <div class="invalid-feedback">
                                        Số điện thoại phải bắt đầu bằng số 0 và có đủ 10 số
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
                                <i class="fas fa-save me-2"></i>Lưu sân
                            </button>
                        </div>
                    </form>


    
</div>


<script>
    document.getElementById('stadiumForm').addEventListener('submit', function (event) {
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

        if (!phoneNumber.value.match(/^0\d{9}$/)) {
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
        {id: 'phoneNumber', pattern: /^0\d{9}$/}
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

    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
            integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
            crossorigin=""></script>

    <!-- Script khởi tạo bản đồ với Edge support -->
    <script>
        // ✅ Đảm bảo compatibility với Edge
        (function() {
            'use strict';
            
            // Polyfill cho Edge cũ nếu cần
            if (!String.prototype.includes) {
                String.prototype.includes = function(search, start) {
                    if (typeof start !== 'number') {
                        start = 0;
                    }
                    if (start + search.length > this.length) {
                        return false;
                    } else {
                        return this.indexOf(search, start) !== -1;
                    }
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

                // ✅ Chờ Leaflet sẵn sàng với timeout để tránh infinite loop
                var attempts = 0;
                var maxAttempts = 50; // 5 giây
                
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
                        // ✅ Khởi tạo bản đồ với các options hỗ trợ Edge
                        var map = L.map('map', {
                            preferCanvas: false, // Sử dụng SVG thay vì Canvas cho compatibility tốt hơn
                            zoomControl: true,
                            attributionControl: true
                        }).setView([initLat, initLng], 15);

                        // ✅ Thêm tile layer với error handling
                        var tileLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                            maxZoom: 19,
                            subdomains: ['a', 'b', 'c']
                        });
                        
                        tileLayer.on('tileerror', function(error) {
                            console.warn('Tile loading error:', error);
                        });
                        
                        tileLayer.addTo(map);

                        var marker = L.marker([initLat, initLng], { 
                            draggable: true,
                            title: 'Vị trí sân bóng'
                        }).addTo(map);

                        // ✅ Event listeners với proper binding và delay 0.5s
                        marker.on("dragend", function(e) {
                            var pos = e.target.getLatLng();
                            // Delay 0.5s trước khi update location
                            setTimeout(function() {
                                updateLocation(pos.lat, pos.lng);
                            }, 500);
                        });

                        map.on("click", function(e) {
                            marker.setLatLng(e.latlng);
                            map.panTo(e.latlng);
                            // Delay 0.5s trước khi update location
                            setTimeout(function() {
                                updateLocation(e.latlng.lat, e.latlng.lng);
                            }, 500);
                        });

                        // ✅ Debounced input với delay 1s cho typing và geocoding
                        var debounceTimer;
                        function handleLocationInput() {
                            clearTimeout(debounceTimer);
                            debounceTimer = setTimeout(function() {
                                if (locationInput.value.trim() !== "") {
                                    console.log("🔍 Đang tìm địa chỉ sau 1 giây:", locationInput.value);
                                    geocodeAddress(locationInput.value);
                                }
                            }, 1000); // 1 giây delay
                        }

                        // ✅ Cross-browser event listener
                        if (locationInput.addEventListener) {
                            locationInput.addEventListener("input", handleLocationInput);
                        } else if (locationInput.attachEvent) {
                            locationInput.attachEvent("oninput", handleLocationInput);
                        }

                        // ✅ Lưu reference đến map và marker để sử dụng global
                        window.currentMap = map;
                        window.currentMarker = marker;

                        // ✅ Initial geocoding nếu có sẵn địa chỉ
                        if (locationInput.value && locationInput.value.trim() !== "") {
                            setTimeout(function() {
                                geocodeAddress(locationInput.value);
                            }, 1000);
                        }

                        console.log("🗺️ Bản đồ đã được khởi tạo thành công!");

                        // ✅ Invalidate size để đảm bảo hiển thị đúng trên Edge
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

            // ✅ Global functions với error handling và loading indicator
            window.updateLocation = function(lat, lng) {
                try {
                    console.log("📍 Đang cập nhật vị trí:", lat.toFixed(6), lng.toFixed(6));
                    document.getElementById("lat").value = lat.toFixed(6);
                    document.getElementById("lng").value = lng.toFixed(6);
                    
                    // Hiển thị trạng thái loading
                    var locationInput = document.getElementById("location");
                    var originalValue = locationInput.value;
                    locationInput.value = "🔄 Đang tải địa chỉ...";
                    locationInput.style.color = "#6c757d";
                    
                    // Delay 0.5s trước khi gọi reverse geocode
                    setTimeout(function() {
                        reverseGeocode(lat, lng, function(success, address) {
                            if (success && address) {
                                locationInput.value = address;
                                locationInput.style.color = "#212529";
                                console.log("✅ Đã cập nhật địa chỉ:", address);
                            } else {
                                locationInput.value = originalValue;
                                locationInput.style.color = "#212529";
                                console.warn("❌ Không thể lấy địa chỉ");
                            }
                        });
                    }, 500);
                } catch (error) {
                    console.error("Error updating location:", error);
                }
            };

            window.reverseGeocode = function(lat, lng, callback) {
                var url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=" + lat + "&lon=" + lng + "&accept-language=vi";

                // ✅ Fetch với fallback cho Edge cũ
                if (window.fetch) {
                    fetch(url, {
                        headers: {
                            'User-Agent': 'SanBongApp (contact@sanbong.vn)'
                        }
                    })
                    .then(function(response) {
                        if (!response.ok) throw new Error("HTTP " + response.status);
                        return response.json();
                    })
                    .then(function(data) {
                        if (data && data.display_name) {
                            if (callback) callback(true, data.display_name);
                        } else {
                            if (callback) callback(false, null);
                        }
                    })
                    .catch(function(err) {
                        console.warn("Không thể lấy địa chỉ:", err);
                        if (callback) callback(false, null);
                    });
                } else {
                    // Fallback for older browsers
                    var xhr = new XMLHttpRequest();
                    xhr.open('GET', url, true);
                    xhr.setRequestHeader('User-Agent', 'SanBongApp (contact@sanbong.vn)');
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === 4) {
                            if (xhr.status === 200) {
                                try {
                                    var data = JSON.parse(xhr.responseText);
                                    if (data && data.display_name) {
                                        if (callback) callback(true, data.display_name);
                                    } else {
                                        if (callback) callback(false, null);
                                    }
                                } catch (e) {
                                    console.warn("Error parsing response:", e);
                                    if (callback) callback(false, null);
                                }
                            } else {
                                console.warn("Request failed:", xhr.status);
                                if (callback) callback(false, null);
                            }
                        }
                    };
                    xhr.send();
                }
            };

            window.geocodeAddress = function(address) {
                var url = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(address) + "&countrycodes=VN&accept-language=vi&limit=1";
                
                console.log("🔍 Đang tìm kiếm địa chỉ:", address);
                
                // Hiển thị loading cho input
                var locationInput = document.getElementById("location");
                locationInput.style.color = "#6c757d";

                // ✅ Fetch với fallback cho Edge cũ
                if (window.fetch) {
                    fetch(url, {
                        headers: {
                            'User-Agent': 'SanBongApp (contact@sanbong.vn)'
                        }
                    })
                    .then(function(response) {
                        if (!response.ok) throw new Error("HTTP " + response.status);
                        return response.json();
                    })
                    .then(function(data) {
                        console.log("📍 Kết quả tìm kiếm:", data);
                        
                        // Delay 0.5s trước khi update map
                        setTimeout(function() {
                            locationInput.style.color = "#212529";
                            
                            if (data && data.length > 0) {
                                var loc = data[0];
                                var lat = parseFloat(loc.lat);
                                var lng = parseFloat(loc.lon);
                                
                                console.log("✅ Tìm thấy tọa độ:", lat, lng);
                                console.log("✅ Địa chỉ:", loc.display_name);
                                
                                // ✅ Sử dụng global map reference
                                if (window.currentMap && window.currentMarker) {
                                    console.log("🗺️ Đang cập nhật bản đồ...");
                                    window.currentMap.setView([lat, lng], 15);
                                    window.currentMarker.setLatLng([lat, lng]);
                                    
                                    // Update hidden inputs
                                    document.getElementById("lat").value = lat.toFixed(6);
                                    document.getElementById("lng").value = lng.toFixed(6);
                                    
                                    // Update location input với địa chỉ chính xác từ API
                                    locationInput.value = loc.display_name;
                                    
                                    console.log("✅ Đã cập nhật bản đồ thành công!");
                                } else {
                                    console.error("❌ Không tìm thấy map reference");
                                    // Fallback: tìm bằng cách cũ
                                    var mapElement = document.getElementById('map');
                                    if (mapElement && mapElement._leaflet_id) {
                                        var mapId = mapElement._leaflet_id;
                                        console.log("🔍 Tìm thấy map ID:", mapId);
                                        
                                        // Thử tìm trong L.Map instances
                                        if (typeof L !== 'undefined' && L.Map && L.Map._instances) {
                                            var mapInstance = L.Map._instances[mapId];
                                            if (mapInstance) {
                                                console.log("✅ Tìm thấy map instance qua L.Map._instances");
                                                mapInstance.setView([lat, lng], 15);
                                                mapInstance.eachLayer(function(layer) {
                                                    if (layer instanceof L.Marker) {
                                                        layer.setLatLng([lat, lng]);
                                                    }
                                                });
                                            }
                                        }
                                    }
                                    
                                    // Update inputs anyway
                                    document.getElementById("lat").value = lat.toFixed(6);
                                    document.getElementById("lng").value = lng.toFixed(6);
                                    locationInput.value = loc.display_name;
                                }
                            } else {
                                console.warn("❌ Không tìm thấy địa chỉ:", address);
                                alert("Không tìm thấy địa chỉ '" + address + "'. Vui lòng thử với địa chỉ khác.");
                            }
                        }, 500); // 0.5s delay
                    })
                    .catch(function(err) {
                        setTimeout(function() {
                            locationInput.style.color = "#212529";
                            console.warn("Lỗi khi tìm địa chỉ:", err);
                            alert("Có lỗi xảy ra khi tìm địa chỉ: " + err.message);
                        }, 500);
                    });
                } else {
                    // Fallback for older browsers
                    var xhr = new XMLHttpRequest();
                    xhr.open('GET', url, true);
                    xhr.setRequestHeader('User-Agent', 'SanBongApp (contact@sanbong.vn)');
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === 4) {
                            setTimeout(function() {
                                locationInput.style.color = "#212529";
                                
                                if (xhr.status === 200) {
                                    try {
                                        var data = JSON.parse(xhr.responseText);
                                        if (data && data.length > 0) {
                                            var loc = data[0];
                                            var lat = parseFloat(loc.lat);
                                            var lng = parseFloat(loc.lon);
                                            
                                            // Update map if available
                                            if (window.currentMap && window.currentMarker) {
                                                window.currentMap.setView([lat, lng], 15);
                                                window.currentMarker.setLatLng([lat, lng]);
                                            }
                                            
                                            document.getElementById("lat").value = lat.toFixed(6);
                                            document.getElementById("lng").value = lng.toFixed(6);
                                            locationInput.value = loc.display_name;
                                        } else {
                                            alert("Không tìm thấy địa chỉ nào phù hợp!");
                                        }
                                    } catch (e) {
                                        console.warn("Error parsing geocode response:", e);
                                        alert("Có lỗi xảy ra khi xử lý kết quả tìm kiếm.");
                                    }
                                } else {
                                    alert("Không thể kết nối đến dịch vụ tìm kiếm địa chỉ.");
                                }
                            }, 500);
                        }
                    };
                    xhr.send();
                }
            };

        })();
    </script>
</body>
</html>
