package dao;

import connect.DBConnection;
import model.Discount;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DiscountDAO {
   public Discount getDiscountByCode(String code) {
    String sql = "SELECT * FROM DiscountCode " +
                 "WHERE Code = ? " +
                 "AND ExpiryDate >= CAST(GETDATE() AS DATE) " +
                 "AND (MaxUsage - UsedCount) > 0";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, code);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Discount discount = new Discount();
            discount.setDiscountCodeID(rs.getInt("DiscountCodeID"));
            discount.setCode(rs.getString("Code"));
            discount.setPercentage(rs.getInt("DiscountPercent"));
            discount.setExpiryDate(rs.getDate("ExpiryDate").toLocalDate());
            // Optional: set available count
            discount.setQuantity(rs.getInt("MaxUsage") - rs.getInt("UsedCount"));
            return discount;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}


}
