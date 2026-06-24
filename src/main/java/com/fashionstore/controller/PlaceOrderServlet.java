package com.fashionstore.controller;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.dao.CartItemDAO;
import com.fashionstore.dao.OrderDAO;
import com.fashionstore.dao.OrderItemDAO;
import com.fashionstore.dao.ProductVariantDAO;
import com.fashionstore.model.Cart;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.Order;
import com.fashionstore.model.OrderItem;
import com.fashionstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {
    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private ProductVariantDAO productVariantDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        cartItemDAO = new CartItemDAO();
        orderDAO = new OrderDAO();
        orderItemDAO = new OrderItemDAO();
        productVariantDAO = new ProductVariantDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        String paymentMethod = request.getParameter("paymentMethod");
        String deliveryAddress = request.getParameter("deliveryAddress");
        
        Cart cart = cartDAO.getCartByUserId(user.getUserId());
        if (cart != null) {
            List<CartItem> cartItems = cartItemDAO.getItemsByCartId(cart.getCartId());
            
            if (!cartItems.isEmpty()) {
                BigDecimal totalAmount = BigDecimal.ZERO;
                for (CartItem ci : cartItems) {
                    totalAmount = totalAmount.add(ci.getUnitPrice().multiply(new BigDecimal(ci.getQuantity())));
                }
                
                Order order = new Order();
                order.setUserId(user.getUserId());
                order.setTotalAmount(totalAmount);
                order.setPaymentMethod(paymentMethod);
                order.setOrderStatus("Pending");
                order.setDeliveryAddress(deliveryAddress);
                
                int orderId = orderDAO.createOrder(order);
                
                if (orderId > 0) {
                    List<OrderItem> orderItems = new ArrayList<>();
                    for (CartItem ci : cartItems) {
                        OrderItem oi = new OrderItem();
                        oi.setOrderId(orderId);
                        oi.setProductId(ci.getProductId());
                        oi.setProductName(ci.getProduct().getProductName());
                        oi.setQuantity(ci.getQuantity());
                        oi.setUnitPrice(ci.getUnitPrice());
                        oi.setSubtotal(ci.getUnitPrice().multiply(new BigDecimal(ci.getQuantity())));
                        oi.setSizeLabel(ci.getSizeLabel());
                        orderItems.add(oi);
                        
                        // Decrease stock
                        productVariantDAO.decreaseStock(ci.getProductId(), ci.getSizeLabel(), ci.getQuantity());
                    }
                    
                    orderItemDAO.addOrderItems(orderItems);
                    
                    // Clear cart
                    cartDAO.clearCart(cart.getCartId());
                    
                    response.sendRedirect(request.getContextPath() + "/order-details?id=" + orderId + "&success=true");
                    return;
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/checkout?error=true");
    }
}
