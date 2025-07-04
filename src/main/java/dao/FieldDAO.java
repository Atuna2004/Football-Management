package dao;

import connect.DBConnection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Field;

public class FieldDAO {
    private DBConnection connection;

    public FieldDAO(DBConnection conn) {
        this.connection = conn;
    }

    public List<Field> getFieldsByStadiumId(int stadiumId) throws SQLException {
        List<Field> fields = new ArrayList<>();
        String query = "SELECT * FROM Field WHERE StadiumID = ?";
        
        try (PreparedStatement stmt = connection.getConnection().prepareStatement(query)) {
            stmt.setInt(1, stadiumId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Field field = new Field();
                field.setFieldID(rs.getInt("FieldID"));
                field.setStadiumID(rs.getInt("StadiumID"));
                field.setFieldName(rs.getString("FieldName"));
                field.setType(rs.getString("Type"));
                field.setDescription(rs.getString("Description"));
                field.setActive(rs.getBoolean("isActive")); // Thêm isActive
                fields.add(field);
            }
        }
        return fields;
    }
    
    public Field getFieldById(int fieldId) throws SQLException {
        String query = "SELECT * FROM Field WHERE FieldID = ?";
        try (PreparedStatement stmt = connection.getConnection().prepareStatement(query)) {
            stmt.setInt(1, fieldId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Field field = new Field();
                field.setFieldID(rs.getInt("FieldID"));
                field.setStadiumID(rs.getInt("StadiumID"));
                field.setFieldName(rs.getString("FieldName"));
                field.setType(rs.getString("Type"));
                field.setDescription(rs.getString("Description"));
                field.setActive(rs.getBoolean("isActive"));
                return field;
            }
        }
        return null;
    }
    
    // File: dao/FieldDAO.java

    public boolean createField(Field field) throws SQLException {
        String query = "INSERT INTO Field (StadiumID, FieldName, Type, Description, isActive) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.getConnection().prepareStatement(query)) {
            stmt.setInt(1, field.getStadiumID());
            stmt.setString(2, field.getFieldName());
            stmt.setString(3, field.getType());
            stmt.setString(4, field.getDescription());
            stmt.setBoolean(5, field.getIsActive());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateField(Field field) throws SQLException {
        String query = "UPDATE Field SET FieldName = ?, Type = ?, Description = ?, isActive = ? WHERE FieldID = ?";

        try (PreparedStatement stmt = connection.getConnection().prepareStatement(query)) {
            stmt.setString(1, field.getFieldName());
            stmt.setString(2, field.getType());
            stmt.setString(3, field.getDescription());
            stmt.setBoolean(4, field.getIsActive());
            stmt.setInt(5, field.getFieldID());

            return stmt.executeUpdate() > 0;
        }
    }
    
    private static Field getLastInsertedField(FieldDAO fieldDAO) throws SQLException {
    String query = "SELECT TOP 1 * FROM Field ORDER BY FieldID DESC";
    try (PreparedStatement stmt = fieldDAO.connection.getConnection().prepareStatement(query);
         ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
            Field field = new Field();
            field.setFieldID(rs.getInt("FieldID"));
            field.setStadiumID(rs.getInt("StadiumID"));
            field.setFieldName(rs.getString("FieldName"));
            field.setType(rs.getString("Type"));
            field.setDescription(rs.getString("Description"));
            field.setActive(rs.getBoolean("isActive"));
            return field;
        }
    }
    return null;
}

    public boolean deleteField(int fieldId) throws SQLException {
        String query = "DELETE FROM Field WHERE FieldID = ?";

        try (PreparedStatement stmt = connection.getConnection().prepareStatement(query)) {
            stmt.setInt(1, fieldId);
            return stmt.executeUpdate() > 0;
        }
    }
    
}