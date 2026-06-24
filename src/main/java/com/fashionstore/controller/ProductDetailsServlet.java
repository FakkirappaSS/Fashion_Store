package com.fashionstore.controller;

import com.fashionstore.dao.ProductDAO;
import com.fashionstore.dao.ProductVariantDAO;
import com.fashionstore.model.Product;
import com.fashionstore.model.ProductVariant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/product-details")
public class ProductDetailsServlet extends HttpServlet {
    private ProductDAO productDAO;
    private ProductVariantDAO productVariantDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        productVariantDAO = new ProductVariantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productIdParam = request.getParameter("id");
        
        if (productIdParam != null && !productIdParam.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdParam);
                Product product = productDAO.getProductById(productId);
                
                if (product != null) {
                    List<ProductVariant> variants = productVariantDAO.getVariantsByProductId(productId);
                    product.setVariants(variants);
                    
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/WEB-INF/views/product-details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Ignore and fallback
            }
        }
        
        // If product not found, redirect to products page
        response.sendRedirect(request.getContextPath() + "/products");
    }
}
