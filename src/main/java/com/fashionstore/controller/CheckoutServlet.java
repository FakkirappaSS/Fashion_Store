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
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        cartItemDAO = new CartItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user != null) {
            Cart cart = cartDAO.getCartByUserId(user.getUserId());
            if (cart != null) {
                List<CartItem> items = cartItemDAO.getItemsByCartId(cart.getCartId());
                cart.setItems(items);
                request.setAttribute("cart", cart);
                
                BigDecimal total = BigDecimal.ZERO;
                for(CartItem item : items) {
                    total = total.add(item.getUnitPrice().multiply(new BigDecimal(item.getQuantity())));
                }
                request.setAttribute("cartTotal", total);
                
                if (items.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            }
        }
        
        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }
}
