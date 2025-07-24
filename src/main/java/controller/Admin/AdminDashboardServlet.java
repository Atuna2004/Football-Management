package controller.Admin;

import connect.DBConnection;
import dao.AccountDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            System.out.println("[AdminDashboardServlet] Not logged in, redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }
        
        Connection conn = null;
        AccountDAO accountDAO = null;
        
        try {
            // 2. Lấy kết nối từ DBConnection
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            
            // 3. Truyền kết nối vào AccountDAO qua constructor
            accountDAO = new AccountDAO(conn);
            
            // 4. Lấy tất cả metrics cho dashboard
            getDashboardMetrics(conn, request);
            
            // 5. Lấy danh sách 10 người dùng mới nhất (giữ logic cũ)
            List<User> allUsers = accountDAO.getRecentUsers(10);
            if (allUsers.isEmpty()) {
                System.out.println("[AdminDashboardServlet] Recent users list is empty.");
            } else {
                System.out.println("[AdminDashboardServlet] Recent users list:");
                for (User u : allUsers) {
                    System.out.printf(" - UserID: %d, Name: %s, Email: %s, Phone: %s, IsActive: %b, CreatedAt: %s%n",
                            u.getUserID(), u.getFullName(), u.getEmail(), u.getPhone(),
                            u.isActive(), u.getCreatedAt());
                }
            }
            request.setAttribute("allUsers", allUsers);
            
            // 6. Số người dùng đang online (giữ logic cũ)
            ServletContext app = getServletContext();
            Integer onlineUsers = (Integer) app.getAttribute("onlineUsers");
            if (onlineUsers == null) {
                onlineUsers = 0;
            }
            System.out.println("[AdminDashboardServlet] Number of online users: " + onlineUsers);
            request.setAttribute("onlineUsers", onlineUsers);
            
            // 7. Chuyển tiếp đến trang JSP
            System.out.println("[AdminDashboardServlet] Forwarding to /admin/adminPage.jsp");
            request.getRequestDispatcher("/admin/adminPage.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("[AdminDashboardServlet] Database error: " + e.getMessage());
            e.printStackTrace();
            // Set default values in case of error
            setDefaultValues(request);
            request.getRequestDispatcher("/admin/adminPage.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("[AdminDashboardServlet] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống!");
            
        } finally {
            // 8. Luôn đóng kết nối trong block finally
            if (conn != null) {
                try {
                    if (!conn.isClosed()) {
                        DBConnection.closeConnection(conn);
                    }
                } catch (SQLException ex) {
                    System.err.println("[AdminDashboardServlet] Failed to close connection: " + ex.getMessage());
                }
            }
        }
    }
    
    private void getDashboardMetrics(Connection conn, HttpServletRequest request) throws SQLException {
        // 1. Get Total Users (excluding admins)
        int totalUsers = getTotalUsers(conn);
        request.setAttribute("totalUsers", totalUsers);
        System.out.println("[AdminDashboardServlet] Total users: " + totalUsers);
        
        // 2. Get Active Stadiums
        int activeFields = getActiveStadiums(conn);
        request.setAttribute("activeFields", activeFields);
        System.out.println("[AdminDashboardServlet] Active stadiums: " + activeFields);
        
        // 3. Get Pending Owner Requests
        int pendingApprovals = getPendingOwnerRequests(conn);
        request.setAttribute("pendingApprovals", pendingApprovals);
        System.out.println("[AdminDashboardServlet] Pending requests: " + pendingApprovals);
        
        // 4. Get Growth Statistics
        double userGrowthPercent = getUserGrowthPercent(conn);
        request.setAttribute("userGrowthPercent", userGrowthPercent);
        System.out.println("[AdminDashboardServlet] User growth: " + userGrowthPercent + "%");
        
        int newStadiumsThisWeek = getNewStadiumsThisWeek(conn);
        request.setAttribute("newFieldsThisWeek", newStadiumsThisWeek);
        System.out.println("[AdminDashboardServlet] New stadiums this week: " + newStadiumsThisWeek);
        
        int pendingIncrease = getPendingIncrease(conn);
        request.setAttribute("pendingIncrease", pendingIncrease);
        System.out.println("[AdminDashboardServlet] Pending increase: " + pendingIncrease);
        
        // 5. Get Progress Metrics
        int yearlyUserTarget = 1500; // Set your target
        request.setAttribute("yearlyUserTarget", yearlyUserTarget);
        
        double stadiumActivityRate = getStadiumActivityRate(conn);
        request.setAttribute("fieldActivityRate", stadiumActivityRate);
        System.out.println("[AdminDashboardServlet] Stadium activity rate: " + stadiumActivityRate + "%");
        
        double requestProcessRate = getRequestProcessRate(conn);
        request.setAttribute("pendingProcessRate", requestProcessRate);
        System.out.println("[AdminDashboardServlet] Request process rate: " + requestProcessRate + "%");
        
        double systemActivityRate = getSystemActivityRate(conn);
        request.setAttribute("systemActivityRate", systemActivityRate);
        System.out.println("[AdminDashboardServlet] System activity rate: " + systemActivityRate + "%");
        
        // 6. Get Chart Data
        List<Integer> monthlyRegistrations = getMonthlyRegistrations(conn);
        request.setAttribute("monthlyRegistrations", monthlyRegistrations);
        System.out.println("[AdminDashboardServlet] Monthly registrations: " + monthlyRegistrations);
        
        List<Integer> monthlyStadiumActivity = getMonthlyStadiumActivity(conn);
        request.setAttribute("monthlyFieldActivity", monthlyStadiumActivity);
        System.out.println("[AdminDashboardServlet] Monthly stadium activity: " + monthlyStadiumActivity);
        
        List<Integer> weeklyPendingData = getWeeklyPendingData(conn);
        request.setAttribute("weeklyPendingData", weeklyPendingData);
        System.out.println("[AdminDashboardServlet] Weekly pending data: " + weeklyPendingData);
        
        List<Integer> hourlyOnlineData = getHourlyOnlineData();
        request.setAttribute("hourlyOnlineData", hourlyOnlineData);
        System.out.println("[AdminDashboardServlet] Hourly online data: " + hourlyOnlineData);
    }
    
    private int getTotalUsers(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT u.UserID) " +
                    "FROM [User] u " +
                    "INNER JOIN UserRole ur ON u.UserID = ur.UserID " +
                    "INNER JOIN Role r ON ur.RoleID = r.RoleID " +
                    "WHERE r.RoleName != 'Admin'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getActiveStadiums(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Stadium WHERE Status = 'Available'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getPendingOwnerRequests(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM OwnerRequest WHERE Status = 'Pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private double getUserGrowthPercent(Connection conn) throws SQLException {
        String sql = "SELECT " +
                    "COUNT(CASE WHEN MONTH(CreatedAt) = MONTH(GETDATE()) " +
                    "AND YEAR(CreatedAt) = YEAR(GETDATE()) THEN 1 END) as current_month, " +
                    "COUNT(CASE WHEN MONTH(CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE())) " +
                    "AND YEAR(CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE())) THEN 1 END) as last_month " +
                    "FROM [User] " +
                    "WHERE CreatedAt >= DATEADD(MONTH, -2, GETDATE())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int currentMonth = rs.getInt("current_month");
                int lastMonth = rs.getInt("last_month");
                if (lastMonth == 0) return currentMonth > 0 ? 100.0 : 0.0;
                return ((double)(currentMonth - lastMonth) / lastMonth) * 100;
            }
            return 0.0;
        }
    }
    
    private int getNewStadiumsThisWeek(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Stadium " +
                    "WHERE CreatedAt >= DATEADD(DAY, -7, GETDATE()) " +
                    "AND Status = 'Available'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getPendingIncrease(Connection conn) throws SQLException {
        String sql = "SELECT " +
                    "COUNT(CASE WHEN CAST(SubmittedDate AS DATE) = CAST(GETDATE() AS DATE) THEN 1 END) as today, " +
                    "COUNT(CASE WHEN CAST(SubmittedDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) THEN 1 END) as yesterday " +
                    "FROM OwnerRequest " +
                    "WHERE Status = 'Pending' " +
                    "AND SubmittedDate >= DATEADD(DAY, -2, GETDATE())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("today") - rs.getInt("yesterday");
            }
            return 0;
        }
    }
    
    private double getStadiumActivityRate(Connection conn) throws SQLException {
        String sql = "SELECT " +
                    "COUNT(CASE WHEN Status = 'Available' THEN 1 END) * 100.0 / COUNT(*) as activity_rate " +
                    "FROM Stadium " +
                    "WHERE Status IN ('Available', 'Unavailable')";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble("activity_rate") : 0.0;
        }
    }
    
    private double getRequestProcessRate(Connection conn) throws SQLException {
        String sql = "SELECT " +
                    "COUNT(CASE WHEN Status = 'Approved' THEN 1 END) * 100.0 / " +
                    "COUNT(CASE WHEN Status IN ('Pending', 'Approved', 'Rejected') THEN 1 END) as process_rate " +
                    "FROM OwnerRequest " +
                    "WHERE SubmittedDate >= DATEADD(DAY, -30, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble("process_rate") : 0.0;
        }
    }
    
    private double getSystemActivityRate(Connection conn) throws SQLException {
        String sql = "SELECT " +
                    "(COUNT(DISTINCT b.UserID) + COUNT(DISTINCT s.OwnerID)) * 10.0 as activity_score " +
                    "FROM Booking b " +
                    "CROSS JOIN Stadium s " +
                    "WHERE b.CreatedAt >= DATEADD(DAY, -7, GETDATE()) " +
                    "OR s.CreatedAt >= DATEADD(DAY, -7, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? Math.min(100, rs.getDouble("activity_score")) : 75.0;
        }
    }
    
    private List<Integer> getMonthlyRegistrations(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as count " +
                    "FROM [User] " +
                    "WHERE CreatedAt >= DATEADD(MONTH, -9, GETDATE()) " +
                    "GROUP BY YEAR(CreatedAt), MONTH(CreatedAt) " +
                    "ORDER BY YEAR(CreatedAt), MONTH(CreatedAt)";
        
        List<Integer> data = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.add(rs.getInt("count"));
            }
        }
        
        // Ensure we have 9 data points
        while (data.size() < 9) {
            data.add(0, 0);
        }
        while (data.size() > 9) {
            data.remove(0);
        }
        
        return data;
    }
    
    private List<Integer> getMonthlyStadiumActivity(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as count " +
                    "FROM Stadium " +
                    "WHERE CreatedAt >= DATEADD(MONTH, -9, GETDATE()) " +
                    "AND Status = 'Available' " +
                    "GROUP BY YEAR(CreatedAt), MONTH(CreatedAt) " +
                    "ORDER BY YEAR(CreatedAt), MONTH(CreatedAt)";
        
        List<Integer> data = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.add(rs.getInt("count"));
            }
        }
        
        while (data.size() < 9) {
            data.add(0, 0);
        }
        while (data.size() > 9) {
            data.remove(0);
        }
        
        return data;
    }
    
    private List<Integer> getWeeklyPendingData(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as count " +
                    "FROM OwnerRequest " +
                    "WHERE SubmittedDate >= DATEADD(DAY, -7, GETDATE()) " +
                    "AND Status = 'Pending' " +
                    "GROUP BY CAST(SubmittedDate AS DATE) " +
                    "ORDER BY CAST(SubmittedDate AS DATE)";
        
        List<Integer> data = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.add(rs.getInt("count"));
            }
        }
        
        while (data.size() < 7) {
            data.add(0);
        }
        
        return data;
    }
    
    private List<Integer> getHourlyOnlineData() {
        // Generate realistic sample data since we don't have real-time session tracking
        List<Integer> data = new ArrayList<>();
        Integer onlineUsers = (Integer) getServletContext().getAttribute("onlineUsers");
        int baseUsers = onlineUsers != null ? onlineUsers : 5;
        
        for (int i = 0; i < 12; i++) {
            // Simulate realistic hourly variation
            int variation = (int)(Math.random() * 6) - 3; // -3 to +3
            data.add(Math.max(1, baseUsers + variation));
        }
        
        return data;
    }
    
    private void setDefaultValues(HttpServletRequest request) {
        // Set safe default values in case of database error
        request.setAttribute("totalUsers", 0);
        request.setAttribute("activeFields", 0);
        request.setAttribute("pendingApprovals", 0);
        request.setAttribute("userGrowthPercent", 0.0);
        request.setAttribute("newFieldsThisWeek", 0);
        request.setAttribute("pendingIncrease", 0);
        request.setAttribute("yearlyUserTarget", 1500);
        request.setAttribute("fieldActivityRate", 0.0);
        request.setAttribute("pendingProcessRate", 0.0);
        request.setAttribute("systemActivityRate", 0.0);
        request.setAttribute("monthlyRegistrations", new ArrayList<Integer>());
        request.setAttribute("monthlyFieldActivity", new ArrayList<Integer>());
        request.setAttribute("weeklyPendingData", new ArrayList<Integer>());
        request.setAttribute("hourlyOnlineData", new ArrayList<Integer>());
        System.out.println("[AdminDashboardServlet] Set default values due to database error");
    }
}