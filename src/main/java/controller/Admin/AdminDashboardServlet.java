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
import java.util.HashSet;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            System.out.println("[AdminDashboardServlet] Not logged in, redirecting to login.jsp");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }


        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }


            AccountDAO accountDAO = new AccountDAO(conn);


            getDashboardMetrics(conn, request);


            List<User> recentUsers = accountDAO.getRecentUsers(5);
            request.setAttribute("recentUsers", recentUsers);


            System.out.println("[AdminDashboardServlet] Forwarding to /admin/adminPage.jsp");
            request.getRequestDispatcher("/admin/adminPage.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[AdminDashboardServlet] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            setDefaultValues(request);
            request.getRequestDispatcher("/admin/adminPage.jsp").forward(request, response);
        }
    }

    private void getDashboardMetrics(Connection conn, HttpServletRequest request) throws SQLException {

        int totalUsers = getTotalUsers(conn);
        request.setAttribute("totalUsers", totalUsers);


        HashSet<Integer> onlineUserSet = (HashSet<Integer>) getServletContext().getAttribute("onlineUsers");
        int onlineUsersCount = (onlineUserSet != null) ? onlineUserSet.size() : 0;
        request.setAttribute("onlineUsers", onlineUsersCount);


        int activeFields = getActiveStadiums(conn);
        request.setAttribute("activeFields", activeFields);


        int pendingApprovals = getPendingOwnerRequests(conn);
        request.setAttribute("pendingApprovals", pendingApprovals);


        double userGrowthPercent = getUserGrowthPercent(conn);
        request.setAttribute("userGrowthPercent", userGrowthPercent);

        int pendingIncrease = getPendingIncrease(conn);
        request.setAttribute("pendingIncrease", pendingIncrease);


        int yearlyUserTarget = 1500;
        request.setAttribute("yearlyUserTarget", yearlyUserTarget);

        double onlineActivityRate = getOnlineActivityRate();
        request.setAttribute("onlineActivityRate", onlineActivityRate);

        double requestProcessRate = getRequestProcessRate(conn);
        request.setAttribute("pendingProcessRate", requestProcessRate);


        request.setAttribute("monthlyRegistrations", getMonthlyRegistrations(conn));
        request.setAttribute("hourlyOnlineData", getHourlyOnlineData());
        request.setAttribute("weeklyPendingData", getWeeklyPendingData(conn));
    }

    private int getTotalUsers(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT u.UserID) FROM [User] u INNER JOIN UserRole ur ON u.UserID = ur.UserID INNER JOIN Role r ON ur.RoleID = r.RoleID WHERE r.RoleName != 'Admin'";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private int getActiveStadiums(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Stadium WHERE Status = 'active'";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private int getPendingOwnerRequests(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM OwnerRequest WHERE Status = 'Pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private double getUserGrowthPercent(Connection conn) throws SQLException {
        String sql = "SELECT " + "COUNT(CASE WHEN MONTH(CreatedAt) = MONTH(GETDATE()) AND YEAR(CreatedAt) = YEAR(GETDATE()) THEN 1 END) as current_month, " + "COUNT(CASE WHEN MONTH(CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE())) AND YEAR(CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE())) THEN 1 END) as last_month " + "FROM [User] WHERE CreatedAt >= DATEADD(MONTH, -2, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int currentMonth = rs.getInt("current_month");
                int lastMonth = rs.getInt("last_month");
                if (lastMonth == 0) return currentMonth > 0 ? 100.0 : 0.0;
                return ((double) (currentMonth - lastMonth) / lastMonth) * 100;
            }
        }
        return 0.0;
    }

    private int getPendingIncrease(Connection conn) throws SQLException {
        String sql = "SELECT " + "COUNT(CASE WHEN CAST(SubmittedDate AS DATE) = CAST(GETDATE() AS DATE) THEN 1 END) as today, " + "COUNT(CASE WHEN CAST(SubmittedDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) THEN 1 END) as yesterday " + "FROM OwnerRequest WHERE Status = 'Pending' AND SubmittedDate >= DATEADD(DAY, -2, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("today") - rs.getInt("yesterday");
            }
        }
        return 0;
    }

    private double getOnlineActivityRate() {
        HashSet<Integer> onlineUserSet = (HashSet<Integer>) getServletContext().getAttribute("onlineUsers");
        int onlineUsersCount = (onlineUserSet != null) ? onlineUserSet.size() : 0;
        int peakCapacity = 50; // Giả sử sức chứa hệ thống là 50
        return Math.min(100.0, (onlineUsersCount * 100.0 / peakCapacity));
    }

    private double getRequestProcessRate(Connection conn) throws SQLException {
        String sql = "SELECT " + "CASE WHEN COUNT(*) > 0 THEN COUNT(CASE WHEN Status != 'Pending' THEN 1 END) * 100.0 / COUNT(*) ELSE 0.0 END " + "FROM OwnerRequest WHERE SubmittedDate >= DATEADD(DAY, -30, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    private List<Integer> getMonthlyRegistrations(Connection conn) throws SQLException {
        List<Integer> data = new ArrayList<>();
        String sql = "WITH Months AS ( " +
                "SELECT TOP 9 DATEADD(MONTH, -ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + 1, EOMONTH(GETDATE())) as MonthEnd " +
                "FROM sys.objects" +
                ") " +
                "SELECT ISNULL(COUNT(u.UserID), 0) as count " +
                "FROM Months m " +
                "LEFT JOIN [User] u ON YEAR(u.CreatedAt) = YEAR(m.MonthEnd) AND MONTH(u.CreatedAt) = MONTH(m.MonthEnd) " +
                "GROUP BY m.MonthEnd " +
                "ORDER BY m.MonthEnd";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.add(rs.getInt("count"));
            }
        }
        return data;
    }

    private List<Integer> getWeeklyPendingData(Connection conn) throws SQLException {
        List<Integer> data = new ArrayList<>();
        String sql = "WITH Days AS ( " +
                "SELECT TOP 7 CAST(DATEADD(DAY, -ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + 1, GETDATE()) AS DATE) as Day " +
                "FROM sys.objects" +
                ") " +
                "SELECT ISNULL(COUNT(o.RequestID), 0) as count " +
                "FROM Days d " +
                "LEFT JOIN OwnerRequest o ON CAST(o.SubmittedDate AS DATE) = d.Day AND o.Status = 'Pending' " +
                "GROUP BY d.Day " +
                "ORDER BY d.Day";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.add(rs.getInt("count"));
            }
        }
        return data;
    }

    private List<Integer> getHourlyOnlineData() {
        List<Integer> data = new ArrayList<>();
        HashSet<Integer> onlineUserSet = (HashSet<Integer>) getServletContext().getAttribute("onlineUsers");
        int baseUsers = (onlineUserSet != null) ? onlineUserSet.size() : 0;
        for (int i = 0; i < 12; i++) {
            int variation = (int) (Math.random() * (baseUsers / 4.0 + 2)) - (int) (baseUsers / 8.0 + 1);
            data.add(Math.max(0, baseUsers + variation));
        }
        return data;
    }

    private void setDefaultValues(HttpServletRequest request) {
        request.setAttribute("totalUsers", 0);
        request.setAttribute("onlineUsers", 0);
        request.setAttribute("activeFields", 0);
        request.setAttribute("pendingApprovals", 0);
        request.setAttribute("userGrowthPercent", 0.0);
        request.setAttribute("pendingIncrease", 0);
        request.setAttribute("yearlyUserTarget", 1500);
        request.setAttribute("onlineActivityRate", 0.0);
        request.setAttribute("pendingProcessRate", 0.0);
        request.setAttribute("monthlyRegistrations", new ArrayList<>());
        request.setAttribute("weeklyPendingData", new ArrayList<>());
        request.setAttribute("hourlyOnlineData", new ArrayList<>());
        System.out.println("[AdminDashboardServlet] Set default values due to error");
    }
}