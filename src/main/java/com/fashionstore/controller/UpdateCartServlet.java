package com.fashionstore.controller;

import com.fashionstore.dao.CartItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {
    private CartItemDAO cartItemDAO;

    @Override
    public void init() throws ServletException {
        cartItemDAO = new CartItemDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity > 0) {
                cartItemDAO.updateItemQuantity(cartItemId, quantity);
            } else {
                cartItemDAO.removeItem(cartItemId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
