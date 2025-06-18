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
        <div class="view-toggle">
            <button class="view-btn active">Week</button>
            <button class="view-btn">Day</button>
        </div>
    </div>

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
                <% for (TimeSlot slot : slots) { %>
                    <div class="booking-item" onclick="bookSlot(<%= slot.getTimeSlotID() %>)">
                        <div class="booking-client"><%= slot.getFieldName() %></div>
                        <div class="booking-price"><%= String.format("%.0f đ", slot.getPrice()) %></div>
                    </div>
                <% } %>
            </div>
            <% } %>
        <% } %>
    </div>
</div>

<script>
    function bookSlot(slotId) {
        if (confirm("Bạn có muốn đặt TimeSlot #" + slotId + " không?")) {
            window.location.href = "selectFood.jsp?timeSlotId=" + slotId;
        }
    }
</script>
</body>
</html>
