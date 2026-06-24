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

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
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
        
        // Fetch some products for the homepage (e.g., all active products for now)
        List<Product> products = productDAO.getAllActiveProducts();
        List<Category> categories = categoryDAO.getAllActiveCategories();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}
