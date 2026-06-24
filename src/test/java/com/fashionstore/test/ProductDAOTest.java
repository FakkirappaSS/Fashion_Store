package com.fashionstore.test;

import com.fashionstore.dao.ProductDAO;
import com.fashionstore.model.Product;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ProductDAOTest {

    private ProductDAO productDAO;

    @BeforeEach
    public void setUp() {
        productDAO = new ProductDAO();
    }

    @Test
    public void testGetAllActiveProducts() {
        // This test ensures the ProductDAO logic and its connection to the DB works correctly.
        List<Product> products = productDAO.getAllActiveProducts();
        
        assertNotNull(products, "The returned product list should not be null");
        System.out.println("Total active products retrieved from DB: " + products.size());
        
        if (!products.isEmpty()) {
            Product firstProduct = products.get(0);
            assertNotNull(firstProduct.getProductName(), "Product name should not be null");
            assertTrue(firstProduct.isActive(), "The retrieved product should be active");
            System.out.println("First retrieved product: " + firstProduct.getProductName() + " (Category: " + firstProduct.getCategoryName() + ")");
        } else {
            System.out.println("No active products found in the database. Add some data to test further.");
        }
    }
}
