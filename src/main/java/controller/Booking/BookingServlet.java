package controller.Booking;

import connect.DBConnection;
import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/create-booking")
public class BookingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = 1; // Tạm hardcode người dùng đăng nhập
        String[] timeSlotIds = request.getParameterValues("timeSlotIds");
        String stadiumIdParam = request.getParameter("stadiumId");

        // Validate input
        if (stadiumIdParam == null || timeSlotIds == null || timeSlotIds.length == 0) {
            request.setAttribute("errorMessage", "Vui lòng chọn ít nhất một khung giờ để đặt sân.");
            request.setAttribute("stadiumId", stadiumIdParam); // Truyền lại để error.jsp có thể quay lại đúng sân
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        int stadiumId;
        try {
            stadiumId = Integer.parseInt(stadiumIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID sân không hợp lệ.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        double totalPrice = 0;
        try (Connection conn = DBConnection.getConnection()) {
            for (String idStr : timeSlotIds) {
                int tsId = Integer.parseInt(idStr);
                try (PreparedStatement ps = conn.prepareStatement("SELECT Price FROM TimeSlot WHERE TimeSlotID = ?")) {
                    ps.setInt(1, tsId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            totalPrice += rs.getDouble("Price");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tính tổng tiền đặt sân.");
            request.setAttribute("stadiumId", stadiumIdParam);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // Tạo đơn đặt sân
        BookingDAO dao = new BookingDAO();
        int bookingId = dao.createBooking(userId, totalPrice, totalPrice);

        if (bookingId != -1) {
            try {
                for (String idStr : timeSlotIds) {
                    int tsId = Integer.parseInt(idStr);
                    dao.insertBookingTimeSlot(bookingId, tsId);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "TimeSlot ID không hợp lệ.");
                request.setAttribute("stadiumId", stadiumIdParam);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Thành công => chuyển sang chọn món ăn
            response.sendRedirect("food?stadiumId=" + stadiumId + "&bookingId=" + bookingId);
        } else {
            request.setAttribute("errorMessage", "Không thể tạo đơn đặt sân.");
            request.setAttribute("stadiumId", stadiumIdParam);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
