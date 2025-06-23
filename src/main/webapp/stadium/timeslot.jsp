<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.TimeSlot" %>
<%@ page import="java.util.*, java.time.*, java.time.format.DateTimeFormatter" %>

<%
    LocalDate startOfWeek = (LocalDate) request.getAttribute("startOfWeek");
    List<TimeSlot> timeSlots = (List<TimeSlot>) request.getAttribute("timeSlots");
    Integer offsetAttr = (Integer) request.getAttribute("weekOffset");
    int weekOffset = (offsetAttr != null) ? offsetAttr : 0;

    int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));

    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd/MM");
    DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MMM yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    String[] dayNamesVi = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật"};

    Map<LocalDate, Map<LocalTime, List<TimeSlot>>> groupedSlots = new HashMap<>();
    for (TimeSlot ts : timeSlots) {
        groupedSlots
            .computeIfAbsent(ts.getDate(), d -> new HashMap<>())
            .computeIfAbsent(ts.getStartTime(), t -> new ArrayList<>())
            .add(ts);
    }

    Set<LocalTime> allTimes = new TreeSet<>();
    for (Map<LocalTime, List<TimeSlot>> map : groupedSlots.values()) {
        allTimes.addAll(map.keySet());
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Đặt Sân</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/timeSlot.css"/>
    <style>
        .booking-form {
            width: 100%;
        }
        .booking-item label {
            display: block;
            padding: 8px;
            border: 1px solid #ccc;
            margin: 3px;
            background-color: #f0f0f0;
            cursor: pointer;
        }
        .booking-item input[type="checkbox"] {
            margin-right: 10px;
        }
        .calendar-grid {
            display: grid;
            grid-template-columns: 100px repeat(7, 1fr);
        }
        .day-header, .time-slot, .day-column {
            padding: 5px;
        }
        .time-slot {
            font-weight: bold;
        }
        .booked label {
            background-color: #ffd6d6;
            color: #a33;
        }
    </style>
</head>
<body>
<div class="calendar-container">
    <div class="calendar-header">
        <div class="nav-section">
            <form action="timeslot" method="get" style="display:flex; gap:5px;">
                <input type="hidden" name="weekOffset" value="<%= weekOffset - 1 %>">
                <input type="hidden" name="stadiumId" value="<%= stadiumId %>">
                <button class="nav-arrow" type="submit">‹</button>
            </form>
            <button class="today-btn" onclick="location.href='timeslot?weekOffset=0&stadiumId=<%= stadiumId %>'">Hôm nay</button>
            <form action="timeslot" method="get" style="display:flex; gap:5px;">
                <input type="hidden" name="weekOffset" value="<%= weekOffset + 1 %>">
                <input type="hidden" name="stadiumId" value="<%= stadiumId %>">
                <button class="nav-arrow" type="submit">›</button>
            </form>
            <span class="date-range">
                <%= startOfWeek.format(dayFormatter) %> - <%= startOfWeek.plusDays(6).format(dayFormatter) %> <%= startOfWeek.format(monthFormatter) %>
            </span>
        </div>
    </div>

    <!-- Form bao toàn bộ TimeSlot -->
    <form action="create-booking" method="get" class="booking-form">
        <input type="hidden" name="stadiumId" value="<%= stadiumId %>" />

        <div class="calendar-grid">
            <div class="time-column"></div>

            <% for (int i = 0; i < 7; i++) {
                LocalDate date = startOfWeek.plusDays(i); %>
                <div class="day-header">
                    <div class="day-name"><%= dayNamesVi[i] %></div>
                    <div class="day-date"><%= date.format(dayFormatter) %></div>
                </div>
            <% } %>

            <% for (LocalTime time : allTimes) { %>
                <div class="time-slot"><%= time.format(timeFormatter) %></div>
                <% for (int i = 0; i < 7; i++) {
                    LocalDate date = startOfWeek.plusDays(i);
                    List<TimeSlot> slots = groupedSlots
                            .getOrDefault(date, Collections.emptyMap())
                            .getOrDefault(time, Collections.emptyList());
                %>
                <div class="day-column">
                <% for (TimeSlot slot : slots) {
                       boolean disabled = slot.isTrulyBooked(); %>
                    <div class="booking-item <%= disabled ? "booked" : "" %>">
                        <label>
                            <input type="checkbox" name="timeSlotIds" value="<%= slot.getTimeSlotID() %>"
                                   <%= disabled ? "disabled" : "" %> />
                            <%= slot.getFieldName() %> - 
                            <%= String.format("%.0f đ", slot.getPrice()) %>
                            <% if (disabled) { %>
                                <span style="color: red;">
                                    (<%= "Confirmed".equalsIgnoreCase(slot.getBookingStatus()) ? "Đã đặt" : "Đang giữ chỗ" %>)
                                </span>
                            <% } %>
                        </label>
                    </div>
                <% } %>
                </div>
                <% } %>
            <% } %>
        </div>

        <div style="text-align:center; margin-top:20px; display: flex; justify-content: center; gap: 20px;">
            <a href="${pageContext.request.contextPath}/stadiums" class="back-button">← Quay lại chọn sân</a>
            <button type="submit">Tiếp tục đặt món</button>
        </div>
    </form>
</div>
</body>
</html>
