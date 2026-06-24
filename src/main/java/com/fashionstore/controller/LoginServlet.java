package com.fashionstore.controller;

import com.fashionstore.dao.UserDAO;
import com.fashionstore.model.User;
import com.fashionstore.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        User user = userDAO.getUserByEmail(email);
        
        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Load wishlist
            com.fashionstore.dao.WishlistDAO wishlistDAO = new com.fashionstore.dao.WishlistDAO();
            session.setAttribute("wishlistProductIds", wishlistDAO.getWishlistProductIds(user.getUserId()));
            
            // Check if there's a returnUrl in session
            String returnUrl = (String) session.getAttribute("returnUrl");
            if (returnUrl != null) {
                session.removeAttribute("returnUrl");
                response.sendRedirect(returnUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
