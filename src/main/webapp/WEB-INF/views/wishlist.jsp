<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container" style="margin-top: 40px; min-height: 60vh;">
    <h2 class="page-title">My Wishlist</h2>
    
    <c:choose>
        <c:when test="${not empty wishlist}">
            <div class="product-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 30px;">
                <c:forEach var="product" items="${wishlist}">
                    <a href="${pageContext.request.contextPath}/product-details?id=${product.productId}" class="product-card" style="text-decoration: none; color: inherit;">
                        <div class="product-image-wrapper">
                            <c:if test="${product.discountPercent > 0}">
                                <div class="discount-badge">-${product.discountPercent}%</div>
                            </c:if>
                            
                            <!-- Remove from wishlist button -->
                            <form action="${pageContext.request.contextPath}/toggle-wishlist" method="POST" style="position: absolute; top: 10px; right: 10px; z-index: 10;">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="action" value="remove">
                                <button type="submit" class="wishlist-btn" aria-label="Remove from Wishlist" style="background: rgba(255,255,255,0.9); color: #ef4444;" title="Remove from wishlist" onclick="event.stopPropagation();">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                </button>
                            </form>
                            
                            <c:choose>
                                <c:when test="${not empty product.imageUrl}">
                                    <img src="${product.imageUrl}" alt="${product.productName}" class="product-image">
                                </c:when>
                                <c:otherwise>
                                    <div class="product-image placeholder" style="display:flex; align-items:center; justify-content:center; background:#f1f5f9; color:#94a3b8;">No Image</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-info">
                            <div class="product-category">${product.categoryName}</div>
                            <h3 class="product-title">${product.productName}</h3>
                            <div class="product-price">&#8377;<fmt:formatNumber value="${product.unitPrice}" pattern="#,##0.00"/></div>
                            <button class="btn btn-block btn-view-details mt-3" onclick="event.preventDefault(); window.location.href='${pageContext.request.contextPath}/product-details?id=${product.productId}';">View Details to Buy</button>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card text-center" style="padding: 60px 20px;">
                <div style="font-size: 48px; color: #cbd5e1; margin-bottom: 20px;">❤️</div>
                <h3 style="font-size: 24px; margin-bottom: 10px;">Your wishlist is empty</h3>
                <p style="color: var(--text-light); margin-bottom: 30px;">Save your favorite items here and find them easily later.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn">Explore Products</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
