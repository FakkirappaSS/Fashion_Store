package com.fashionstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class CartItem {
    private int cartItemId;
    private int cartId;
    private int productId;
    private String sizeLabel;
    private int quantity;
    private BigDecimal unitPrice;
    private Timestamp addedAt;

    // Additional field for convenience
    private Product product;

    public CartItem() {}

    public int getCartItemId() { return cartItemId; }
    public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getSizeLabel() { return sizeLabel; }
    public void setSizeLabel(String sizeLabel) { this.sizeLabel = sizeLabel; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public Timestamp getAddedAt() { return addedAt; }
    public void setAddedAt(Timestamp addedAt) { this.addedAt = addedAt; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}
