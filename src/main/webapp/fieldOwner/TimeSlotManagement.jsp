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
    <style>
        /* Header Styles */
        .top-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .logo h3 a.item {
            text-decoration: none !important;
            color: inherit;
        }
        .logo h3 a.item:hover {
            text-decoration: none !important;
            color: inherit;
        }
        /* Hoặc áp dụng rộng hơn cho tất cả link trong logo */
        .logo a {
            text-decoration: none !important;
            color: inherit;
        }
        .logo a:hover {
            text-decoration: none !important;
            color: inherit;
        }
        .user-greeting {
            color: white;
            font-size: 16px;
            font-weight: 500;
        }
        .user-greeting i {
            margin-right: 8px;
            color: rgba(255,255,255,0.8);
        }

        /* Main Layout */
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        h2 {
            color: #333;
        }
        form {
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
        }
        select {
            margin-right: 10px;
        }
        .calendar-grid {
            display: grid;
            grid-template-columns: 100px repeat(7, 1fr);
            gap: 1px;
            border: 1px solid #ccc;
        }
        .day-header, .time-slot, .slot-cell {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .day-header {
            background-color: #f2f2f2;
        }
        .time-slot {
            background-color: #e9e9e9;
            font-weight: bold;
        }
        .slot-cell {
            min-height: 100px;
            position: relative;
        }
        .slot-box {
            padding: 4px;
            margin: 2px;
            border-radius: 4px;
            box-sizing: border-box;
            cursor: pointer;
        }
        .booked {
            background-color: #ffe6e6;
            color: #990000;
        }
        .available {
            background-color: #e6ffe6;
            color: #006600;
        }
        .inactive {
            background-color: #f2f2f2;
            color: gray;
        }
        .slot-box input[type="checkbox"] {
            margin-right: 5px;
        }
        .btn-group {
            margin-top: 20px;
        }
        .btn-group button {
            padding: 10px 20px;
            margin-right: 10px;
            font-size: 14px;
            cursor: pointer;
        }
        /* Button to go back to dashboard */
        .back-to-dashboard {
            margin-bottom: 20px;
        }
    </style>
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

    <!-- Back to Dashboard Button -->
    <div class="back-to-dashboard">
        <a href="${pageContext.request.contextPath}/fieldOwner/FODB.jsp" class="btn btn-primary">
            ← Quay về Dashboard
        </a>
    </div>

    <h2>Quản lý TimeSlot</h2>

    <form method="get" action="${pageContext.request.contextPath}/LoadTimeSlotsServlet">
        <label for="stadiumId">Chọn sân:</label>
        <select name="stadiumId" id="stadiumId">
            <option value="1">Sân Vận Động A</option>
            <option value="2">Sân Vận Động B</option>
        </select>

        <label for="week">Chọn tuần:</label>
        <select name="week" id="week">
            <option value="current">Tuần này</option>
            <option value="next">Tuần sau</option>
        </select>

        <button type="submit">Tải lịch</button>
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
                                    <input type="checkbox" name="timeSlotIds" value="<%= ts.getTimeSlotID() %>">
                                    <%= ts.getFieldName() %><br/>
                                    <%= ts.getPrice() %> VND<br/>
                                    <%= ts.isActive() ? (ts.isBooked() ? "Đã đặt" : "Hoạt động") : "Ngưng hoạt động" %>
                                </label>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            <% } %>
        </div>

        <div class="btn-group">
            <button type="submit" name="action" value="toggleActive">Kích hoạt / Hủy kích hoạt</button>
            <button type="submit" name="action" value="book">Đặt thủ công</button>
        </div>
    </form>

    <% } else if (request.getParameter("stadiumId") != null) { %>
        <p>Không có khung giờ nào.</p>
    <% } %>

</body>
</html>