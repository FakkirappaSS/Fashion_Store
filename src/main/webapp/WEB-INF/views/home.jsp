<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<!-- Hero Banner Slider -->
<div class="hero-banner-full">
    <!-- Slide 1 -->
    <div class="hero-slide active" style="background-image: url('https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=2070');">
        <div class="hero-content">
            <h1 class="hero-title">Unlock Your Style:<br>Premium Collective</h1>
            <p class="hero-subtitle">Discover the latest trends and elevate your wardrobe with our curated selection of premium fashion.</p>
            <a href="${pageContext.request.contextPath}/products" class="btn hero-btn">Shop Collection</a>
        </div>
    </div>
    
    <!-- Slide 2 -->
    <div class="hero-slide" style="background-image: url('https://images.unsplash.com/photo-1445205170230-053b83016050?q=80&w=2071');">
        <div class="hero-content">
            <h1 class="hero-title">Winter Essentials<br>Are Here</h1>
            <p class="hero-subtitle">Cozy up in style. Shop our exclusive winter lineup featuring premium coats and knits.</p>
            <a href="${pageContext.request.contextPath}/products?category=4" class="btn hero-btn">Explore Winter</a>
        </div>
    </div>
    
    <!-- Slide 3 -->
    <div class="hero-slide" style="background-image: url('https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1920');">
        <div class="hero-content">
            <h1 class="hero-title">Accessorize Your<br>Everyday Look</h1>
            <p class="hero-subtitle">From minimalist watches to statement bags. Find the perfect finishing touch.</p>
            <a href="${pageContext.request.contextPath}/products?category=3" class="btn hero-btn">Shop Accessories</a>
        </div>
    </div>

    <!-- Navigation -->
    <div class="slider-arrows">
        <button class="slider-arrow prev" aria-label="Previous Slide">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
        </button>
        <button class="slider-arrow next" aria-label="Next Slide">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
        </button>
    </div>
    <div class="slider-dots">
        <span class="dot active"></span>
        <span class="dot"></span>
        <span class="dot"></span>
    </div>
</div>

<div class="container">
    <!-- Shop by Category -->
    <div class="section-header">
        <h2 class="section-title">Shop by Category</h2>
    </div>
    
    <div class="category-grid">
        <c:forEach var="cat" items="${categories}">
            <!-- Dynamic Image Mapping based on Category Name -->
            <c:set var="catImage" value="https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?q=80&w=800" /> <!-- Default -->
            <c:choose>
                <c:when test="${cat.categoryName.toLowerCase().contains('men')}">
                    <c:set var="catImage" value="https://images.unsplash.com/photo-1617137968427-85924c800a22?q=80&w=800" />
                </c:when>
                <c:when test="${cat.categoryName.toLowerCase().contains('women')}">
                    <c:set var="catImage" value="https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=800" />
                </c:when>
                <c:when test="${cat.categoryName.toLowerCase().contains('kid')}">
                    <c:set var="catImage" value="https://images.unsplash.com/photo-1514090458221-65bb69cf63e6?q=80&w=800" />
                </c:when>
                <c:when test="${cat.categoryName.toLowerCase().contains('accessori')}">
                    <c:set var="catImage" value="https://images.unsplash.com/photo-1584916201218-f4242ceb4809?q=80&w=800" />
                </c:when>
                <c:when test="${cat.categoryName.toLowerCase().contains('footwear') or cat.categoryName.toLowerCase().contains('shoe')}">
                    <c:set var="catImage" value="https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=800" />
                </c:when>
                <c:when test="${cat.categoryName.toLowerCase().contains('ethnic')}">
                    <c:set var="catImage" value="${pageContext.request.contextPath}/assets/images/categories/ethnic_wear.jpg" />
                </c:when>
                <c:when test="${cat.categoryName.toLowerCase().contains('active') or cat.categoryName.toLowerCase().contains('gym')}">
                    <c:set var="catImage" value="https://images.unsplash.com/photo-1518611012118-696072aa579a?q=80&w=800" />
                </c:when>
                <c:when test="${cat.categoryName.toLowerCase().contains('winter') or cat.categoryName.toLowerCase().contains('coat')}">
                    <c:set var="catImage" value="https://images.unsplash.com/photo-1551028719-00167b16eac5?q=80&w=800" />
                </c:when>
            </c:choose>

            <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}" class="category-card">
                <div class="category-img-container">
                    <img src="${catImage}" alt="${cat.categoryName}" class="category-img">
                    <div class="category-label">
                        <div class="category-name">${cat.categoryName}</div>
                        <div class="category-subtext">Explore Collection &rarr;</div>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>

    <!-- Curated Arrivals -->
    <div class="section-header mt-5">
        <h2 class="section-title">Curated Arrivals</h2>
        <a href="${pageContext.request.contextPath}/products" class="view-all-btn">View all products</a>
    </div>
    
    <div class="product-grid">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="product" items="${products}" end="7">
                    <a href="${pageContext.request.contextPath}/product-details?id=${product.productId}" class="product-card">
                        <div class="product-image-wrapper">
                            <c:if test="${product.discountPercent > 0}">
                                <div class="discount-badge">-${product.discountPercent}%</div>
                            </c:if>
                            <c:set var="isWishlisted" value="false" />
                            <c:if test="${not empty sessionScope.wishlistProductIds and sessionScope.wishlistProductIds.contains(product.productId)}">
                                <c:set var="isWishlisted" value="true" />
                            </c:if>
                            <form action="${pageContext.request.contextPath}/toggle-wishlist" method="POST" style="position: absolute; top: 10px; right: 10px; z-index: 10;">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="action" value="${isWishlisted ? 'remove' : 'add'}">
                                <button type="submit" class="wishlist-btn" aria-label="${isWishlisted ? 'Remove from Wishlist' : 'Add to Wishlist'}" onclick="event.stopPropagation();" title="${isWishlisted ? 'Remove from wishlist' : 'Add to wishlist'}">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="${isWishlisted ? '#ef4444' : 'none'}" stroke="${isWishlisted ? '#ef4444' : 'currentColor'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
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
                            <button class="btn btn-block btn-view-details mt-3">View Details</button>
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-error" style="grid-column: 1 / -1;">
                    No products available at the moment.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
