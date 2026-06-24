package com.fashionstore.controller;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.dao.CartItemDAO;
import com.fashionstore.model.Cart;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        cartItemDAO = new CartItemDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String sizeLabel = request.getParameter("sizeLabel");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Cart cart = cartDAO.getCartByUserId(user.getUserId());
            if (cart == null) {
                cart = cartDAO.createCartForUser(user.getUserId());
            }
            
            CartItem item = new CartItem();
            item.setCartId(cart.getCartId());
            item.setProductId(productId);
            item.setSizeLabel(sizeLabel);
            item.setQuantity(quantity);
            // Since the products table schema doesn't have a price column,
            // we use a fixed placeholder price here for demonstration.
            item.setUnitPrice(new BigDecimal("49.99")); 

            cartItemDAO.addItemToCart(item);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
