package com.fashionstore.controller;

import com.fashionstore.dao.WishlistDAO;
import com.fashionstore.model.Product;
import com.fashionstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    private WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?message=Please login to view your wishlist");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<Product> wishlist = wishlistDAO.getUserWishlist(user.getUserId());
        request.setAttribute("wishlist", wishlist);
        
        request.getRequestDispatcher("/WEB-INF/views/wishlist.jsp").forward(request, response);
    }
}
