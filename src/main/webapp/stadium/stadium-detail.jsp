<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Stadium" %>
<%
    Stadium stadium = (Stadium) request.getAttribute("stadium");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sân bóng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
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
                ← Quay lại danh sách
            </a>
            <a class="btn-custom" href="timeslot?stadiumId=<%= stadium.getStadiumID() %>">
                Xem lịch đặt sân →
            </a>
        </div>
    </div>
    
    <%@ include file="/includes/footer.jsp" %>
</body>
</html>