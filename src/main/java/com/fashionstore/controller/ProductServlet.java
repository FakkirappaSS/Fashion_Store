package com.fashionstore.controller;

import com.fashionstore.dao.CategoryDAO;
import com.fashionstore.dao.ProductDAO;
import com.fashionstore.model.Category;
import com.fashionstore.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String categoryIdParam = request.getParameter("category");
        String searchQuery = request.getParameter("q");
        List<Product> products;
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            products = productDAO.searchProducts(searchQuery.trim());
        } else if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdParam);
                products = productDAO.getProductsByCategory(categoryId);
            } catch (NumberFormatException e) {
                products = productDAO.getAllActiveProducts();
            }
        } else {
            products = productDAO.getAllActiveProducts();
        }
        
        List<Category> categories = categoryDAO.getAllActiveCategories();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
    }
}
