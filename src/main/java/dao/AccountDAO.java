package dao;

import java.sql.*;
import java.util.*;
import model.User;
import model.Role;

public class AccountDAO {

    private Connection conn;

    public AccountDAO(Connection conn) {
        this.conn = conn;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.IsActive, r.RoleID, r.RoleName "
                + "FROM [User] u "
                + "LEFT JOIN UserRole ur ON u.UserID = ur.UserID "
                + "LEFT JOIN Role r ON ur.RoleID = r.RoleID "
                + "ORDER BY u.UserID";

        Map<Integer, User> userMap = new HashMap<>();

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("UserID");
                User acc = userMap.get(id);
                if (acc == null) {
                    acc = new User();
                    acc.setUserID(id);
                    acc.setFullName(rs.getString("FullName"));
                    acc.setEmail(rs.getString("Email"));
                    acc.setActive(rs.getBoolean("IsActive"));
                    acc.setRoles(new ArrayList<>());
                    userMap.put(id, acc);
                }
                String roleName = rs.getString("RoleName");
                if (roleName != null) {
                    acc.getRoles().add(new Role(rs.getInt("RoleID"), roleName));
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
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = extractUser(rs);
                    user.setRoles(getUserRoles(id));
                    return user;
                }
            }
        }
        return null;
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM [User] WHERE Email = ? AND IsActive = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Role role = new Role();
                    role.setRoleID(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));
                    roles.add(role);
                }
            }
        }
        return roles;
    }

    public boolean addUser(User user) throws SQLException {
        String sql = "INSERT INTO [User] (Email, PasswordHash, FullName, Phone, IsActive, GoogleID, AvatarUrl, DateOfBirth, Address) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int userID = generatedKeys.getInt(1);

                    String insertUserRoleSql = "INSERT INTO UserRole (UserID, RoleID) VALUES (?, 3)";
                    try (PreparedStatement ps = conn.prepareStatement(insertUserRoleSql)) {
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
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    public boolean deleteUser(int userID) throws SQLException {
        String sql = "DELETE FROM [User] WHERE UserID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            return stmt.executeUpdate() > 0;
        }
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
        String sql = "UPDATE [User] SET IsActive = 1 WHERE Email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(String email, String pass) throws SQLException {
        String sql = "UPDATE [User] SET PasswordHash = ? WHERE Email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, pass);
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
}
