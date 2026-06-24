package com.fashionstore.controller;

import com.fashionstore.dao.WishlistDAO;
import com.fashionstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/toggle-wishlist")
public class ToggleWishlistServlet extends HttpServlet {
    private WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        if (session == null || session.getAttribute("user") == null) {
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\":false, \"error\":\"unauthorized\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login?message=Please login to manage wishlist");
            return;
        }

        User user = (User) session.getAttribute("user");
        int productId = Integer.parseInt(request.getParameter("productId"));
        String action = request.getParameter("action"); // 'add' or 'remove'
        
        java.util.Set<Integer> wishlistProductIds = (java.util.Set<Integer>) session.getAttribute("wishlistProductIds");
        if (wishlistProductIds == null) {
            wishlistProductIds = new java.util.HashSet<>();
        }
        
        if ("add".equals(action)) {
            wishlistDAO.addProductToWishlist(user.getUserId(), productId);
            wishlistProductIds.add(productId);
        } else if ("remove".equals(action)) {
            wishlistDAO.removeProductFromWishlist(user.getUserId(), productId);
            wishlistProductIds.remove(productId);
        }
        session.setAttribute("wishlistProductIds", wishlistProductIds);
        
        if (isAjax) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":true, \"action\":\"" + action + "\"}");
            return;
        }
        
        String referer = request.getHeader("Referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }
}
