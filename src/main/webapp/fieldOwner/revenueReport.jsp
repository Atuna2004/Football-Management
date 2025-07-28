<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Stadium" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Doanh Thu</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/revenueReport.css">
</head>
<body>

<!-- Top Header -->
<div class="top-header">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="logo">
            <h3>
                <a href="<%= request.getContextPath() %>/home.jsp">
                    <i class="fas fa-futbol me-2"></i>
                    Field Manager Page
                </a>
            </h3>
        </div>
        <%
            Object userObj = session.getAttribute("currentUser");
            if (userObj != null) {
        %>
            <div class="user-greeting">
                <i class="fas fa-user-circle"></i>
                Xin chào, <%= ((model.User) userObj).getFullName() %>
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

<!-- Sidebar Navigation -->
<%@ include file="FieldOwnerSB.jsp" %>

<!-- Main Content -->
<div class="main-content">
    <div class="card">
        <div class="card-header">
            <h5>Báo Cáo Doanh Thu</h5>
        </div>
        <div class="card-body">

            <!-- Form chọn kỳ và nút thao tác -->
            <div class="d-flex gap-2 mb-3 align-items-end">
                <div class="form-group">
                    <label for="stadiumId">Chọn sân:</label>
                    <select name="stadiumId" id="stadiumId" class="form-select">
                        <option value="">Đang tải...</option>
                    </select>
                </div>
                
                <div>
                    <label for="period">Chọn kỳ:</label>
                    <select id="period" class="form-select">
                        <option value="day" ${param.period == 'day' ? 'selected' : ''}>Theo Ngày</option>
                        <option value="month" ${param.period == 'month' ? 'selected' : ''}>Theo Tháng</option>
                        <option value="year" ${param.period == 'year' ? 'selected' : ''}>Theo Năm</option>
                    </select>
                </div>
                    
                <!-- Nút Xem Báo Cáo -->
                <button type="button" class="btn btn-primary" onclick="viewReport()">
                    <i class="fas fa-chart-bar"></i> Xem Báo Cáo
                </button>

                <!-- Nút Xuất ra Excel -->
                <button type="button" class="btn btn-success" onclick="exportExcel()">
                    <i class="fas fa-file-excel"></i> Xuất ra Excel
                </button>
            </div>

            <script>
                function viewReport() {
                    const stadiumId = document.getElementById('stadiumId').value;
                    const period = document.getElementById('period').value;

                    if (!stadiumId) {
                        alert("Vui lòng chọn một sân.");
                        return;
                    }

                    // ✅ Chuyển đến trang báo cáo chi tiết theo sân
                    const url = '${pageContext.request.contextPath}/revenue-stadium?stadiumId=' + stadiumId + '&period=' + period;
                    window.location.href = url;
                }

                function exportExcel() {
                    const period = document.getElementById('period').value;
                    window.location.href = '${pageContext.request.contextPath}/export-revenue-excel?period=' + period;
                }
            </script>

            <!-- Bảng báo cáo doanh thu -->
            <c:if test="${not empty reports and not empty stadiums and not empty periodList}">
                <table class="report-table table table-bordered">
                    <thead>
                        <tr>
                            <th>Thời Gian</th>
                            <c:forEach items="${stadiums}" var="s">
                                <th>${s}</th>
                            </c:forEach>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${periodList}" var="p">
                            <tr>
                                <td><strong>${p}</strong></td>
                                <c:forEach items="${stadiums}" var="s">
                                    <c:set var="found" value="false"/>
                                    <c:forEach items="${reports}" var="r">
                                        <c:if test="${r.stadiumName == s && r.period == p}">
                                            <td>${r.totalRevenue}</td>
                                            <c:set var="found" value="true"/>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${!found}">
                                        <td>0</td>
                                    </c:if>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <!-- Thông báo nếu không có dữ liệu -->
            <c:if test="${empty reports or empty stadiums}">
                <p class="empty-data">Không có dữ liệu để hiển thị.</p>
            </c:if>

        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

<!-- Hàm helper: Chuyển List<Stadium> thành JSON -->
<%!
    public String listStadiumsToJson(List<Stadium> stadiums) {
        if (stadiums == null || stadiums.isEmpty()) {
            return "[]";
        }
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < stadiums.size(); i++) {
            Stadium s = stadiums.get(i);
            sb.append(String.format("{id:%d,name:'%s'}", s.getStadiumID(), s.getName().replace("'", "\\'")));
            if (i < stadiums.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
%>

<!-- JavaScript: Load danh sách sân và xử lý sự kiện -->
<script>
    // Lấy danh sách sân từ server
    const stadiumList = <%= listStadiumsToJson((List<Stadium>) request.getAttribute("stadiums")) %>;

    // Hàm tải danh sách sân vào dropdown
    function loadStadiums() {
        const select = document.getElementById('stadiumId');
        select.innerHTML = ''; // Xóa tùy chọn mặc định

        if (stadiumList.length === 0) {
            const option = document.createElement('option');
            option.value = '';
            option.textContent = 'Không có sân nào';
            select.appendChild(option);
            return;
        }

        stadiumList.forEach(stadium => {
            const option = document.createElement('option');
            option.value = stadium.id;
            option.textContent = stadium.name;
            select.appendChild(option);
        });
    }

    // Gọi hàm khi trang load xong
    document.addEventListener("DOMContentLoaded", loadStadiums);
</script>

</body>
</html>