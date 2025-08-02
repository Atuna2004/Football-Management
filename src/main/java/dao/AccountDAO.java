package dao;

import connect.DBConnection;

import java.sql.*;
import java.util.*;

import model.User;
import model.Role;
import service.PasswordService;

public class AccountDAO {

    private Connection conn;

    public AccountDAO(Connection conn) {
        this.conn = conn;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.Phone, u.IsActive, u.Address, u.DateOfBirth, u.CreatedAt, u.AvatarUrl, u.GoogleID, r.RoleID, r.RoleName "
                + "FROM [User] u "
                + "LEFT JOIN UserRole ur ON u.UserID = ur.UserID "
                + "LEFT JOIN Role r ON ur.RoleID = r.RoleID "
                + "ORDER BY u.UserID";

        Map<Integer, User> userMap = new HashMap<>();

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("UserID");
                User acc = userMap.get(id);
                if (acc == null) {
                    acc = new User();
                    acc.setUserID(id);
                    acc.setFullName(rs.getString("FullName"));
                    acc.setEmail(rs.getString("Email"));
                    acc.setPhone(rs.getString("Phone"));
                    acc.setActive(rs.getBoolean("IsActive"));
                    acc.setAddress(rs.getString("Address"));
                    acc.setDateOfBirth(rs.getDate("DateOfBirth"));
                    acc.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    acc.setAvatarUrl(rs.getString("AvatarUrl"));
                    acc.setGoogleID(rs.getString("GoogleID"));
                    acc.setRoles(new ArrayList<>());
                    userMap.put(id, acc);
                }
                if (rs.getString("RoleName") != null) {
                    acc.getRoles().add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                }
            }
        }
        list.addAll(userMap.values());
        return list;
    }

    public List<User> getUsersByPage(int page, int itemsPerPage) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY UserID) AS RowNum FROM [User]) AS Sub "
                + "WHERE RowNum BETWEEN ? AND ?";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            int start = (page - 1) * itemsPerPage + 1;
            int end = page * itemsPerPage;

            stmt.setInt(1, start);
            stmt.setInt(2, end);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractUser(rs));
                }
            }
        }
        return list;
    }

    public List<User> searchUsers(String keyword) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.IsActive FROM [User] u WHERE u.FullName LIKE ? OR u.Email LIKE ?";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractUser(rs));
                }
            }
        }
        return list;
    }

    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM [User] WHERE UserID = ?";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = extractUser(rs);
                    user.setRoles(getUserRoles(user.getUserID()));
                    return user;
                }
            }
        }
        return null;
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM [User] WHERE Email = ? AND IsActive = 1";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = extractUser(rs);
                    user.setRoles(getUserRoles(user.getUserID()));
                    return user;
                }
            }
        }
        return null;
    }

    public List<Role> getUserRoles(int userID) throws SQLException {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT r.RoleID, r.RoleName FROM UserRole ur JOIN Role r ON ur.RoleID = r.RoleID WHERE ur.UserID = ?";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roles.add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                }
            }
        }
        return roles;
    }

    public boolean addUser(User user) throws SQLException {
        String sql = "INSERT INTO [User] (Email, PasswordHash, FullName, Phone, IsActive, GoogleID, AvatarUrl, DateOfBirth, Address) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, PasswordService.hashPassword(user.getPasswordHash())); // Hash mật khẩu trước khi lưu
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhone());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getGoogleID());
            stmt.setString(7, user.getAvatarUrl());
            if (user.getDateOfBirth() != null) {
                stmt.setDate(8, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                stmt.setNull(8, Types.DATE);
            }
            if (user.getAddress() != null && !user.getAddress().isEmpty()) {
                stmt.setString(9, user.getAddress());
            } else {
                stmt.setNull(9, Types.VARCHAR);
            }

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int userID = generatedKeys.getInt(1);
                    String insertRoleSql = "INSERT INTO UserRole (UserID, RoleID) VALUES (?, 3)";
                    try (PreparedStatement ps = conn.prepareStatement(insertRoleSql)) {
                        ps.setInt(1, userID);
                        ps.executeUpdate();
                    }
                }
            }
            return true;
        }
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE [User] SET Email=?, PasswordHash=?, FullName=?, Phone=?, IsActive=?, GoogleID=?, AvatarUrl=?, DateOfBirth=?, Address=? WHERE UserID=?";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhone());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getGoogleID());
            stmt.setString(7, user.getAvatarUrl());
            if (user.getDateOfBirth() != null) {
                stmt.setDate(8, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                stmt.setNull(8, Types.DATE);
            }
            if (user.getAddress() != null && !user.getAddress().isEmpty()) {
                stmt.setString(9, user.getAddress());
            } else {
                stmt.setNull(9, Types.VARCHAR);
            }
            stmt.setInt(10, user.getUserID());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateAvatar(int userID, String avatarUrl) throws SQLException {
        String sql = "UPDATE [User] SET AvatarUrl=? WHERE UserID=?";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, avatarUrl);
            stmt.setInt(2, userID);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int userID) throws SQLException {
        String sql = "UPDATE [User] SET IsActive=0 WHERE UserID=?";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<User> getRecentUsers(int limit) throws SQLException {
        Map<Integer, User> userMap = new LinkedHashMap<>();

        String sql = "SELECT TOP (?) u.*, r.RoleID, r.RoleName FROM [User] u "
                + "LEFT JOIN UserRole ur ON u.UserID = ur.UserID "
                + "LEFT JOIN Role r ON ur.RoleID = r.RoleID "
                + "ORDER BY u.CreatedAt DESC";


        try (PreparedStatement ps = this.conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("UserID");
                    User user = userMap.get(id);
                    if (user == null) {
                        user = extractUser(rs);
                        user.setRoles(new ArrayList<>());
                        userMap.put(id, user);
                    }
                    if (rs.getString("RoleName") != null) {
                        user.getRoles().add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                    }
                }
            }
        }
        return new ArrayList<>(userMap.values());
    }

    private User extractUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserID(rs.getInt("UserID"));
        u.setEmail(rs.getString("Email"));
        u.setPasswordHash(rs.getString("PasswordHash"));
        u.setFullName(rs.getString("FullName"));
        u.setPhone(rs.getString("Phone"));
        u.setCreatedAt(rs.getTimestamp("CreatedAt"));
        u.setActive(rs.getBoolean("IsActive"));
        u.setGoogleID(rs.getString("GoogleID"));
        u.setAvatarUrl(rs.getString("AvatarUrl"));
        u.setDateOfBirth(rs.getObject("DateOfBirth", java.sql.Date.class));
        u.setAddress(rs.getString("Address"));
        return u;
    }

    public boolean activateUser(String email) throws SQLException {
        String sql = "UPDATE [User] SET IsActive=1 WHERE Email=?";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(String email, String pass) throws SQLException {
        String sql = "UPDATE [User] SET PasswordHash = ? WHERE Email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, PasswordService.hashPassword(pass));
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<User> getPendingFieldOwners() throws SQLException {
        String sql = "SELECT u.* FROM [User] u JOIN UserRole ur ON u.UserID = ur.UserID WHERE ur.RoleID = 2 AND u.IsActive = 0";
        List<User> list = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(extractUser(rs));
            }
        }
        return list;
    }

    public User getUserByFacebookID(String facebookID) throws SQLException {
        String sql = "SELECT * FROM [User] WHERE FacebookID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, facebookID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = extractUser(rs);
                    user.setRoles(getUserRoles(user.getUserID()));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean updateFacebookID(int userID, String facebookID) throws SQLException {
        String sql = "UPDATE [User] SET FacebookID = ? WHERE UserID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, facebookID);
            stmt.setInt(2, userID);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<User> getUsersByRole(String roleName) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.Phone, u.IsActive, u.Address, u.DateOfBirth, u.CreatedAt, u.AvatarUrl, u.GoogleID, r.RoleID, r.RoleName "
                + "FROM [User] u "
                + "LEFT JOIN UserRole ur ON u.UserID = ur.UserID "
                + "LEFT JOIN Role r ON ur.RoleID = r.RoleID "
                + "WHERE r.RoleName = ? "
                + "ORDER BY u.UserID";

        Map<Integer, User> userMap = new HashMap<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, roleName);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("UserID");
                    User acc = userMap.get(id);
                    if (acc == null) {
                        acc = new User();
                        acc.setUserID(id);
                        acc.setFullName(rs.getString("FullName"));
                        acc.setEmail(rs.getString("Email"));
                        acc.setPhone(rs.getString("Phone"));
                        acc.setActive(rs.getBoolean("IsActive"));
                        acc.setAddress(rs.getString("Address"));
                        acc.setDateOfBirth(rs.getDate("DateOfBirth"));
                        acc.setCreatedAt(rs.getTimestamp("CreatedAt"));
                        acc.setAvatarUrl(rs.getString("AvatarUrl"));
                        acc.setGoogleID(rs.getString("GoogleID"));
                        acc.setRoles(new ArrayList<>());
                        userMap.put(id, acc);
                    }
                    if (rs.getString("RoleName") != null) {
                        acc.getRoles().add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                    }
                }
            }
        }
        list.addAll(userMap.values());
        return list;
    }


    public List<User> getUsersByRoleID(int roleID) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.Phone, u.IsActive, u.Address, u.DateOfBirth, u.CreatedAt, u.AvatarUrl, u.GoogleID, r.RoleID, r.RoleName "
                + "FROM [User] u "
                + "LEFT JOIN UserRole ur ON u.UserID = ur.UserID "
                + "LEFT JOIN Role r ON ur.RoleID = r.RoleID "
                + "WHERE ur.RoleID = ? "
                + "ORDER BY u.UserID";

        Map<Integer, User> userMap = new HashMap<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roleID);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("UserID");
                    User acc = userMap.get(id);
                    if (acc == null) {
                        acc = new User();
                        acc.setUserID(id);
                        acc.setFullName(rs.getString("FullName"));
                        acc.setEmail(rs.getString("Email"));
                        acc.setPhone(rs.getString("Phone"));
                        acc.setActive(rs.getBoolean("IsActive"));
                        acc.setAddress(rs.getString("Address"));
                        acc.setDateOfBirth(rs.getDate("DateOfBirth"));
                        acc.setCreatedAt(rs.getTimestamp("CreatedAt"));
                        acc.setAvatarUrl(rs.getString("AvatarUrl"));
                        acc.setGoogleID(rs.getString("GoogleID"));
                        acc.setRoles(new ArrayList<>());
                        userMap.put(id, acc);
                    }
                    if (rs.getString("RoleName") != null) {
                        acc.getRoles().add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                    }
                }
            }
        }
        list.addAll(userMap.values());
        return list;
    }


    public int getTotalUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM [User]";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getTotalUserCountByRole(String roleName) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT u.UserID) FROM [User] u " +
                "LEFT JOIN UserRole ur ON u.UserID = ur.UserID " +
                "LEFT JOIN Role r ON ur.RoleID = r.RoleID " +
                "WHERE r.RoleName = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, roleName);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int getTotalUserCountByRoleID(int roleID) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT u.UserID) FROM [User] u " +
                "LEFT JOIN UserRole ur ON u.UserID = ur.UserID " +
                "WHERE ur.RoleID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roleID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    // Add this method to your AccountDAO class
public boolean ownsStadium(int userId, int stadiumId) throws SQLException {
    String sql = "SELECT COUNT(*) FROM Stadium WHERE OwnerID = ? AND StadiumID = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        stmt.setInt(2, stadiumId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    }
    return false;
}

    // Updated getUsersByPage with role support
    public List<User> getUsersByPageWithRoles(int page, int itemsPerPage) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.Phone, u.IsActive, u.Address, u.DateOfBirth, u.CreatedAt, u.AvatarUrl, u.GoogleID, r.RoleID, r.RoleName " +
                "FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY UserID) AS RowNum FROM [User]) AS u " +
                "LEFT JOIN UserRole ur ON u.UserID = ur.UserID " +
                "LEFT JOIN Role r ON ur.RoleID = r.RoleID " +
                "WHERE u.RowNum BETWEEN ? AND ? " +
                "ORDER BY u.UserID";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            int start = (page - 1) * itemsPerPage + 1;
            int end = page * itemsPerPage;

            stmt.setInt(1, start);
            stmt.setInt(2, end);

            Map<Integer, User> userMap = new HashMap<>();

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("UserID");
                    User user = userMap.get(id);
                    if (user == null) {
                        user = new User();
                        user.setUserID(id);
                        user.setFullName(rs.getString("FullName"));
                        user.setEmail(rs.getString("Email"));
                        user.setPhone(rs.getString("Phone"));
                        user.setActive(rs.getBoolean("IsActive"));
                        user.setAddress(rs.getString("Address"));
                        user.setDateOfBirth(rs.getDate("DateOfBirth"));
                        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                        user.setAvatarUrl(rs.getString("AvatarUrl"));
                        user.setGoogleID(rs.getString("GoogleID"));
                        user.setRoles(new ArrayList<>());
                        userMap.put(id, user);
                    }
                    if (rs.getString("RoleName") != null) {
                        user.getRoles().add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                    }
                }
            }
            list.addAll(userMap.values());
        }
        return list;
    }

    // Get users by role with pagination
    public List<User> getUsersByRoleWithPagination(String roleName, int page, int itemsPerPage) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.Phone, u.IsActive, u.Address, u.DateOfBirth, u.CreatedAt, u.AvatarUrl, u.GoogleID, r.RoleID, r.RoleName " +
                "FROM (SELECT u.*, ROW_NUMBER() OVER (ORDER BY u.UserID) AS RowNum " +
                "      FROM [User] u " +
                "      LEFT JOIN UserRole ur ON u.UserID = ur.UserID " +
                "      LEFT JOIN Role r ON ur.RoleID = r.RoleID " +
                "      WHERE r.RoleName = ?) AS u " +
                "LEFT JOIN UserRole ur ON u.UserID = ur.UserID " +
                "LEFT JOIN Role r ON ur.RoleID = r.RoleID " +
                "WHERE u.RowNum BETWEEN ? AND ? " +
                "ORDER BY u.UserID";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            int start = (page - 1) * itemsPerPage + 1;
            int end = page * itemsPerPage;

            stmt.setString(1, roleName);
            stmt.setInt(2, start);
            stmt.setInt(3, end);

            Map<Integer, User> userMap = new HashMap<>();

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("UserID");
                    User user = userMap.get(id);
                    if (user == null) {
                        user = new User();
                        user.setUserID(id);
                        user.setFullName(rs.getString("FullName"));
                        user.setEmail(rs.getString("Email"));
                        user.setPhone(rs.getString("Phone"));
                        user.setActive(rs.getBoolean("IsActive"));
                        user.setAddress(rs.getString("Address"));
                        user.setDateOfBirth(rs.getDate("DateOfBirth"));
                        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                        user.setAvatarUrl(rs.getString("AvatarUrl"));
                        user.setGoogleID(rs.getString("GoogleID"));
                        user.setRoles(new ArrayList<>());
                        userMap.put(id, user);
                    }
                    if (rs.getString("RoleName") != null) {
                        user.getRoles().add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                    }
                }
            }
            list.addAll(userMap.values());
        }
        return list;
    }

    public List<User> getUsersByRoleIDWithPagination(int roleID, int page, int itemsPerPage) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.Phone, u.IsActive, u.Address, u.DateOfBirth, u.CreatedAt, u.AvatarUrl, u.GoogleID, r.RoleID, r.RoleName " +
                "FROM (SELECT u.*, ROW_NUMBER() OVER (ORDER BY u.UserID) AS RowNum " +
                "      FROM [User] u " +
                "      LEFT JOIN UserRole ur ON u.UserID = ur.UserID " +
                "      WHERE ur.RoleID = ?) AS u " +
                "LEFT JOIN UserRole ur ON u.UserID = ur.UserID " +
                "LEFT JOIN Role r ON ur.RoleID = r.RoleID " +
                "WHERE u.RowNum BETWEEN ? AND ? " +
                "ORDER BY u.UserID";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            int start = (page - 1) * itemsPerPage + 1;
            int end = page * itemsPerPage;

            stmt.setInt(1, roleID);
            stmt.setInt(2, start);
            stmt.setInt(3, end);

            Map<Integer, User> userMap = new HashMap<>();

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("UserID");
                    User user = userMap.get(id);
                    if (user == null) {
                        user = new User();
                        user.setUserID(id);
                        user.setFullName(rs.getString("FullName"));
                        user.setEmail(rs.getString("Email"));
                        user.setPhone(rs.getString("Phone"));
                        user.setActive(rs.getBoolean("IsActive"));
                        user.setAddress(rs.getString("Address"));
                        user.setDateOfBirth(rs.getDate("DateOfBirth"));
                        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                        user.setAvatarUrl(rs.getString("AvatarUrl"));
                        user.setGoogleID(rs.getString("GoogleID"));
                        user.setRoles(new ArrayList<>());
                        userMap.put(id, user);
                    }
                    if (rs.getString("RoleName") != null) {
                        user.getRoles().add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                    }
                }
            }
            list.addAll(userMap.values());
        }
        return list;
    }
}
