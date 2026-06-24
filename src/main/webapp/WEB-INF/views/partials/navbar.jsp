<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav>
    <div class="nav-container">
        <div style="display: flex; align-items: center; gap: 40px;">
            <a href="${pageContext.request.contextPath}/home" class="logo">FashionStore</a>
            
            <form action="${pageContext.request.contextPath}/products" method="GET" class="search-form" style="display: flex; align-items: center; position: relative;">
                <input type="text" name="q" placeholder="Search brands, categories, products..." value="${param.q}" style="width: 300px; padding: 10px 16px; margin: 0; border: 1px solid var(--border-color); border-radius: 20px; font-size: 14px; background: var(--bg-light);">
                <button type="submit" style="position: absolute; right: 10px; background: none; border: none; cursor: pointer; color: var(--text-light);">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                </button>
            </form>
            
            <button id="themeToggleBtn" class="theme-toggle" aria-label="Toggle Dark Mode">
                <!-- Sun Icon (default hidden in light mode via JS) -->
                <svg id="sunIcon" style="display: none;" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>
                <!-- Moon Icon -->
                <svg id="moonIcon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
            </button>
        </div>
        
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <a href="${pageContext.request.contextPath}/wishlist" style="display: flex; align-items: center; gap: 5px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                Wishlist
            </a>
            <a href="${pageContext.request.contextPath}/cart" style="display: flex; align-items: center; gap: 5px;">
                Cart 
                <c:if test="${not empty sessionScope.cart and sessionScope.cart.items.size() > 0}">
                    <span style="background: #ef4444; color: white; border-radius: 50%; width: 18px; height: 18px; display: inline-flex; align-items: center; justify-content: center; font-size: 10px; font-weight: bold;">${sessionScope.cart.items.size()}</span>
                </c:if>
            </a>
            
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/my-orders">Orders</a>
                    <a href="${pageContext.request.contextPath}/profile">Profile</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline" style="padding: 6px 16px;">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" style="margin-right: -10px;">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline" style="padding: 6px 16px;">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>
