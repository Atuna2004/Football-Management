<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Booking" %>
<html>
<head><title>Quản lý Check-in</title></head>
<body>
<h2>🎟️ Xác nhận Check-in</h2>

<form method="get" action="admincheck">
    <label>🔍 Mã check-in (token):</label>
    <input type="text" name="token" required />
    <button type="submit">Tìm đơn</button>
</form>

<% if (request.getAttribute("error") != null) { %>
    <p style="color:red;"><%= request.getAttribute("error") %></p>
<% } %>

<% if (request.getAttribute("message") != null) { %>
    <p style="color:green;"><%= request.getAttribute("message") %></p>
<% } %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    if (booking != null) {
%>
    <h3>Thông tin đơn đặt sân:</h3>
    <ul>
        <li>Mã đơn: <%= booking.getBookingID() %></li>
        <li>Trạng thái: <%= booking.getStatus() %></li>
        <li>Thời gian tạo: <%= booking.getCreatedAt() %></li>
        <li>Tổng tiền: <%= booking.getTotalAmount() %></li>
    </ul>

    <% if (!"CheckedIn".equalsIgnoreCase(booking.getStatus())) { %>
        <form method="post" action="admincheck">
            <input type="hidden" name="bookingId" value="<%= booking.getBookingID() %>" />
            <button type="submit">✅ Xác nhận Check-in</button>
        </form>
    <% } else { %>
        <p style="color:blue;">✅ Khách đã check-in.</p>
    <% } %>
<% } %>
</body>
</html>
