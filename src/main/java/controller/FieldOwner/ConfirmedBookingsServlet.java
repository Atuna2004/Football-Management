package controller.FieldOwner;

import connect.DBConnection;
import dao.BookingDAO;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Booking;
import model.User;

@WebServlet("/confirmedBookings")
public class ConfirmedBookingsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = DBConnection.getConnection(); // Lấy connection từ DBConnection

        // Khởi tạo DAO với connection
        BookingDAO bookingDAO = new BookingDAO(); // Giả sử BookingDAO có constructor nhận Connection
        AccountDAO accountDAO = new AccountDAO(conn);

        int currentPage = 1;
        int pageSize = 10;

        // Lấy trang hiện tại từ tham số URL
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

        // Lấy tất cả các booking đã confirm
        List<Booking> allConfirmedBookings = bookingDAO.getConfirmedBookings();

        // Tính tổng doanh thu
        double totalRevenue = 0;
        for (Booking booking : allConfirmedBookings) {
            totalRevenue += booking.getTotalAmount();
        }

        // Tạo list chứa thông tin chi tiết mỗi booking + fullName
        List<Map<String, Object>> bookingDetails = new ArrayList<>();

        for (Booking booking : allConfirmedBookings) {
            Map<String, Object> detail = new HashMap<>();
            detail.put("booking", booking);

            // Lấy thông tin người dùng theo userID
            User user = null;
            try {
                user = accountDAO.getUserById(booking.getUserID());
            } catch (SQLException ex) {
                Logger.getLogger(ConfirmedBookingsServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            detail.put("fullname", user != null ? user.getFullName() : "Không xác định");

            bookingDetails.add(detail);
        }

        // Tính tổng số trang
        int totalBookings = bookingDetails.size();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);

        // Cắt danh sách theo trang hiện tại
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalBookings);
        List<Map<String, Object>> paginatedBookings = bookingDetails.subList(startIndex, endIndex);

        // Set thuộc tính gửi sang JSP
        request.setAttribute("confirmedBookings", paginatedBookings);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalRevenue", totalRevenue);

        // Forward đến JSP
        request.getRequestDispatcher("/fieldOwner/confirmBookings.jsp").forward(request, response);
    }
}