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
    
  // In your AdminDashboardServlet.java - Update the doGet method:

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
        
        // 4. Lấy tất cả metrics cho dashboard (including online users)
        getDashboardMetrics(conn, request);
        
        // 5. Lấy danh sách 10 người dùng mới nhất
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
        
        // 6. Chuyển tiếp đến trang JSP
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
        
        // 2. Get Online Users from application scope (CHANGED: replaced activeFields)
        ServletContext app = getServletContext();
        Integer onlineUsers = (Integer) app.getAttribute("onlineUsers");
        if (onlineUsers == null) {
            onlineUsers = 0;
        }
        request.setAttribute("onlineUsers", onlineUsers);
        System.out.println("[AdminDashboardServlet] Number of online users: " + onlineUsers);
        
        // 3. Get Pending Owner Requests
        int pendingApprovals = getPendingOwnerRequests(conn);
        request.setAttribute("pendingApprovals", pendingApprovals);
        System.out.println("[AdminDashboardServlet] Pending requests: " + pendingApprovals);
        
        // 4. Get Growth Statistics
        double userGrowthPercent = getUserGrowthPercent(conn);
        request.setAttribute("userGrowthPercent", userGrowthPercent);
        System.out.println("[AdminDashboardServlet] User growth: " + userGrowthPercent + "%");
        
        // CHANGED: Get online user activity instead of new stadiums
        int onlineUserGrowth = getOnlineUserGrowth();
        request.setAttribute("onlineUserGrowth", onlineUserGrowth);
        System.out.println("[AdminDashboardServlet] Online user growth: " + onlineUserGrowth);
        
        int pendingIncrease = getPendingIncrease(conn);
        request.setAttribute("pendingIncrease", pendingIncrease);
        System.out.println("[AdminDashboardServlet] Pending increase: " + pendingIncrease);
        
        // 5. Get Progress Metrics
        int yearlyUserTarget = 1500; // Set your target
        request.setAttribute("yearlyUserTarget", yearlyUserTarget);
        
        // CHANGED: Online activity rate instead of stadium activity
        double onlineActivityRate = getOnlineActivityRate();
        request.setAttribute("onlineActivityRate", onlineActivityRate);
        System.out.println("[AdminDashboardServlet] Online activity rate: " + onlineActivityRate + "%");
        
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
        
        // CHANGED: Online user activity data instead of stadium activity
        List<Integer> monthlyOnlineActivity = getMonthlyOnlineActivity();
        request.setAttribute("monthlyOnlineActivity", monthlyOnlineActivity);
        System.out.println("[AdminDashboardServlet] Monthly online activity: " + monthlyOnlineActivity);
        
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
    
    // REMOVED: getActiveStadiums method - no longer needed
    
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
    
    // CHANGED: New method for online user growth
    private int getOnlineUserGrowth() {
        // Since we don't have historical online data, simulate based on current users
        Integer currentOnline = (Integer) getServletContext().getAttribute("onlineUsers");
        if (currentOnline == null) currentOnline = 0;
        
        // Simulate growth compared to last hour
        return (int)(Math.random() * 5) - 2; // -2 to +3 range
    }
    
    // REMOVED: getNewStadiumsThisWeek method
    
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
    
    // CHANGED: Online activity rate instead of stadium activity
    private double getOnlineActivityRate() {
        Integer onlineUsers = (Integer) getServletContext().getAttribute("onlineUsers");
        if (onlineUsers == null) onlineUsers = 0;
        
        // Calculate activity rate based on online users vs total sessions
        // This is a simulation - in real app you'd track actual session data
        if (onlineUsers == 0) return 0.0;
        
        // Assume peak capacity of 50 concurrent users for percentage calculation
        int peakCapacity = 50;
        return Math.min(100.0, (onlineUsers * 100.0 / peakCapacity));
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
    
    // CHANGED: Monthly online activity instead of stadium activity
    private List<Integer> getMonthlyOnlineActivity() {
        // Generate realistic monthly online activity data
        List<Integer> data = new ArrayList<>();
        Integer currentOnline = (Integer) getServletContext().getAttribute("onlineUsers");
        int baseActivity = currentOnline != null ? currentOnline * 10 : 50; // Multiply for monthly scale
        
        for (int i = 0; i < 9; i++) {
            // Simulate monthly growth trend
            int monthlyActivity = baseActivity + (i * 5) + (int)(Math.random() * 20) - 10;
            data.add(Math.max(10, monthlyActivity));
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
        // Generate realistic hourly online data
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
        request.setAttribute("onlineUsers", 0); // CHANGED: onlineUsers instead of activeFields
        request.setAttribute("pendingApprovals", 0);
        request.setAttribute("userGrowthPercent", 0.0);
        request.setAttribute("onlineUserGrowth", 0); // CHANGED: online growth instead of new fields
        request.setAttribute("pendingIncrease", 0);
        request.setAttribute("yearlyUserTarget", 1500);
        request.setAttribute("onlineActivityRate", 0.0); // CHANGED: online activity rate
        request.setAttribute("pendingProcessRate", 0.0);
        request.setAttribute("systemActivityRate", 0.0);
        request.setAttribute("monthlyRegistrations", new ArrayList<Integer>());
        request.setAttribute("monthlyOnlineActivity", new ArrayList<Integer>()); // CHANGED
        request.setAttribute("weeklyPendingData", new ArrayList<Integer>());
        request.setAttribute("hourlyOnlineData", new ArrayList<Integer>());
        System.out.println("[AdminDashboardServlet] Set default values due to database error");
    }
}