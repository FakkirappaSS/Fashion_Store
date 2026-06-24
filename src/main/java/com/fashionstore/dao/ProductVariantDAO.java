package com.fashionstore.dao;

import com.fashionstore.model.ProductVariant;
import com.fashionstore.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductVariantDAO {
    
    public List<ProductVariant> getVariantsByProductId(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM product_sizes WHERE product_id = ? AND is_available = TRUE AND stock_quantity > 0";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductVariant pv = new ProductVariant();
                    pv.setProductSizeId(rs.getInt("product_size_id"));
                    pv.setProductId(rs.getInt("product_id"));
                    pv.setSizeLabel(rs.getString("size_label"));
                    pv.setStockQuantity(rs.getInt("stock_quantity"));
                    pv.setSkuCode(rs.getString("sku_code"));
                    pv.setAvailable(rs.getBoolean("is_available"));
                    variants.add(pv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return variants;
    }

    public boolean decreaseStock(int productId, String sizeLabel, int quantity) {
        String sql = "UPDATE product_sizes SET stock_quantity = stock_quantity - ? WHERE product_id = ? AND size_label = ? AND stock_quantity >= ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            stmt.setString(3, sizeLabel);
            stmt.setInt(4, quantity);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
