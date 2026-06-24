package com.fashionstore.model;

public class ProductVariant {
    private int productSizeId;
    private int productId;
    private String sizeLabel;
    private int stockQuantity;
    private String skuCode;
    private boolean isAvailable;

    public ProductVariant() {}

    public int getProductSizeId() { return productSizeId; }
    public void setProductSizeId(int productSizeId) { this.productSizeId = productSizeId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getSizeLabel() { return sizeLabel; }
    public void setSizeLabel(String sizeLabel) { this.sizeLabel = sizeLabel; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    public String getSkuCode() { return skuCode; }
    public void setSkuCode(String skuCode) { this.skuCode = skuCode; }
    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }
}
