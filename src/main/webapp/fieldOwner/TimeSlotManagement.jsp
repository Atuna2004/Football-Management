<%@ page import="java.util.*" %>
<%@ page import="model.TimeSlot" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<html>
<head>
    <title>Quản lý TimeSlot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/timeSlotManagement.css">
</head>
<body>

<!-- Header -->
<div class="top-header">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="logo">
            <h3>
                <a class="item" href="<%= request.getContextPath() %>/home.jsp">
                    <i class="fas fa-futbol me-2"></i>
                    Field Manager Page
                </a>
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

<!-- Sidebar -->
<aside class="sidebar">
<%@ include file="FieldOwnerSB.jsp" %>
</aside>

<!-- Nội dung chính -->
<main class="main-content">
    <!-- Back to Dashboard Button -->
    <div class="back-to-dashboard">
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
            ← Quay về Dashboard
        </a>
    </div>

    <h2>Quản lý TimeSlot</h2>


    <!-- Form chọn sân và tuần -->
    <form method="get" action="${pageContext.request.contextPath}/LoadTimeSlotsServlet" class="controls-row">
        <div class="form-group">
            <label for="stadiumId">Chọn sân:</label>
            <select name="stadiumId" id="stadiumId" class="form-select">
                <option value="">Đang tải...</option>
            </select>
        </div>

        <div class="form-group">
            <label for="week">Chọn tuần:</label>
            <select name="week" id="week" class="form-select">
                <option value="current">Tuần này</option>
                <option value="next">Tuần sau</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Tải lịch</button>
    </form>

    <%
        List<TimeSlot> timeSlots = (List<TimeSlot>) request.getAttribute("timeSlots");
        LocalDate startOfWeek = (LocalDate) request.getAttribute("startOfWeek");

        if (timeSlots != null && !timeSlots.isEmpty()) {

            // Tạo danh sách ngày trong tuần
            List<LocalDate> allDays = new ArrayList<>();
            for (int i = 0; i < 7; i++) {
                allDays.add(startOfWeek.plusDays(i));
            }

            // Lấy tất cả các mốc thời gian
            Set<LocalTime> allTimes = new TreeSet<>();
            for (TimeSlot ts : timeSlots) {
                allTimes.add(ts.getStartTime());
            }

            // Nhóm theo ngày và giờ
            Map<LocalDate, Map<LocalTime, List<TimeSlot>>> groupedByDateAndTime = new HashMap<>();
            for (TimeSlot ts : timeSlots) {
                groupedByDateAndTime
                    .computeIfAbsent(ts.getDate(), d -> new HashMap<>())
                    .computeIfAbsent(ts.getStartTime(), t -> new ArrayList<>())
                    .add(ts);
            }
    %>

    <form method="post" action="${pageContext.request.contextPath}/UpdateTimeSlotServlet">
        <input type="hidden" name="stadiumId" value="<%= request.getParameter("stadiumId") %>">
        <input type="hidden" name="week" value="<%= request.getParameter("week") %>">

        <div class="calendar-container">
            <div class="calendar-grid">
                <div class="time-slot"></div>
                <% for (LocalDate date : allDays) { %>
                    <div class="day-header">
                        <%= date.getDayOfWeek() %><br/>
                        <%= date %>
                    </div>
                <% } %>

                <% for (LocalTime time : allTimes) { %>
                    <div class="time-slot"><%= time %></div>
                    <% for (LocalDate date : allDays) { %>
                        <div class="slot-cell">
                            <%
                                List<TimeSlot> slots = groupedByDateAndTime
                                    .getOrDefault(date, Collections.emptyMap())
                                    .getOrDefault(time, Collections.emptyList());

                                for (TimeSlot ts : slots) {
                                    String statusClass = "inactive";
                                    if (ts.isActive()) {
                                        statusClass = ts.isBooked() ? "booked" : "available";
                                    }
                            %>
                                <div class="slot-box <%= statusClass %>">
                                    <label>
                                        <% if (ts.isBooked()) { %>
                                            <!-- Đã đặt → không cho check -->
                                            <input type="checkbox" disabled>
                                            <span style="color: #dc3545; font-weight: bold;">
                                                <%= ts.getFieldName() %><br/>
                                                <%= ts.getPrice() %> VND<br/>
                                                ĐÃ ĐẶT
                                            </span>
                                        <% } else { %>
                                            <!-- Chưa đặt → cho phép check -->
                                            <input type="checkbox" name="timeSlotIds" value="<%= ts.getTimeSlotID() %>">
                                            <%= ts.getFieldName() %><br/>
                                            <%= ts.getPrice() %> VND<br/>
                                            <%= ts.isActive() ? "Hoạt động" : "Ngưng hoạt động" %>
                                        <% } %>
                                    </label>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>

        <div class="btn-group mt-4">
            <button type="submit" name="action" value="toggleActive" class="btn">
                Kích hoạt / Hủy kích hoạt
            </button>
            <button type="submit" name="action" value="book" class="btn">
                Đặt thủ công
            </button>
        </div>
    </form>

    <% } else if (request.getParameter("stadiumId") != null) { %>
        <p>Không có khung giờ nào.</p>
    <% } %>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const stadiumSelect = document.getElementById("stadiumId");

        // Gọi servlet để lấy danh sách sân
        fetch('<%= request.getContextPath() %>/LoadStadiumListServlet')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Không thể kết nối đến máy chủ');
                }
                return response.text();
            })
            .then(data => {
                // Xóa toàn bộ option cũ
                stadiumSelect.innerHTML = '';

                // Nếu không có dữ liệu
                if (!data.trim()) {
                    const option = document.createElement("option");
                    option.value = "";
                    option.textContent = "Không có sân nào";
                    stadiumSelect.appendChild(option);
                    return;
                }

                // Phân tích dữ liệu dạng: "1:Sân A;2:Sân B;"
                const stadiumPairs = data.split(';').filter(pair => pair.trim() !== '');
                stadiumPairs.forEach(pair => {
                    const [id, name] = pair.split(':', 2); // Chỉ chia 2 phần: id và name
                    if (id && name) {
                        const option = document.createElement("option");
                        option.value = id;
                        option.textContent = name.trim();
                        stadiumSelect.appendChild(option);
                    }
                });

                // Nếu có sân, tự động chọn sân đầu tiên
                if (stadiumSelect.options.length > 0) {
                    stadiumSelect.selectedIndex = 0;
                }

                // Trigger sự kiện change (nếu cần load dữ liệu ngay)
                stadiumSelect.dispatchEvent(new Event('change'));
            })
            .catch(error => {
                console.error("Lỗi khi tải danh sách sân:", error);
                stadiumSelect.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
            });
    });
</script>
</body>
</html>