package com.fashionstore.dao;

import com.fashionstore.model.CartItem;
import com.fashionstore.model.Product;
import com.fashionstore.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartItemDAO {
    
    public List<CartItem> getItemsByCartId(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.*, p.product_name, p.image_url, p.unit_price AS current_unit_price FROM cart_items ci JOIN products p ON ci.product_id = p.product_id WHERE ci.cart_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, cartId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setSizeLabel(rs.getString("size_label"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("current_unit_price"));
                    item.setAddedAt(rs.getTimestamp("added_at"));
                    
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setUnitPrice(rs.getBigDecimal("current_unit_price"));
                    item.setProduct(p);
                    
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean addItemToCart(CartItem item) {
        // First check if item already exists with same size
        String checkSql = "SELECT cart_item_id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ? AND size_label = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
             
            checkStmt.setInt(1, item.getCartId());
            checkStmt.setInt(2, item.getProductId());
            checkStmt.setString(3, item.getSizeLabel());
            
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    // Update quantity
                    int existingId = rs.getInt("cart_item_id");
                    int newQuantity = rs.getInt("quantity") + item.getQuantity();
                    return updateItemQuantity(existingId, newQuantity);
                }
            }
            
            // Insert new
            String insertSql = "INSERT INTO cart_items (cart_id, product_id, size_label, quantity, unit_price) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setInt(1, item.getCartId());
                insertStmt.setInt(2, item.getProductId());
                insertStmt.setString(3, item.getSizeLabel());
                insertStmt.setInt(4, item.getQuantity());
                insertStmt.setBigDecimal(5, item.getUnitPrice());
                return insertStmt.executeUpdate() > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateItemQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, quantity);
            stmt.setInt(2, cartItemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeItem(int cartItemId) {
        String sql = "DELETE FROM cart_items WHERE cart_item_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, cartItemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
