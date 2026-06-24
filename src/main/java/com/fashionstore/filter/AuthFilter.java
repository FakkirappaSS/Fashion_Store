package com.fashionstore.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Intercepts requests to secure directories/URLs.
 * Redirects unauthenticated users to the login page.
 */
@WebFilter(urlPatterns = {"/profile", "/checkout", "/my-orders", "/cart", "/place-order", "/order-details", "/add-to-cart", "/update-cart", "/remove-cart-item"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Check if session exists and user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        String loginURI = httpRequest.getContextPath() + "/login";
        boolean isLoginRequest = httpRequest.getRequestURI().equals(loginURI);
        
        if (isLoggedIn || isLoginRequest) {
            // User is logged in, or is accessing login page, allow request to proceed
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            // Store the intended destination to redirect back after login
            String returnUrl = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                returnUrl += "?" + httpRequest.getQueryString();
            }
            httpRequest.getSession(true).setAttribute("returnUrl", returnUrl);
            
            httpResponse.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
