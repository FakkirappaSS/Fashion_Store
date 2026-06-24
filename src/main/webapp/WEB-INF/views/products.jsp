<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <jsp:include page="/WEB-INF/views/partials/header.jsp" />
            <jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

            <div class="container" style="padding-top: 40px; padding-bottom: 60px;">

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <h1 class="page-title" style="margin-bottom: 0;">
                        <c:choose>
                            <c:when test="${not empty param.q}">
                                Search Results for "${param.q}"
                            </c:when>
                            <c:otherwise>
                                Shop All
                            </c:otherwise>
                        </c:choose>
                    </h1>

                    <!-- Category Filter -->
                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <a href="${pageContext.request.contextPath}/products"
                            class="btn ${empty param.category ? 'btn-outline' : 'btn-outline'}"
                            style="${empty param.category ? 'background: var(--primary-color); color: white;' : ''}">All</a>
                        <c:forEach var="cat" items="${categories}">
                            <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}"
                                class="btn btn-outline"
                                style="${param.category == cat.categoryId ? 'background: var(--primary-color); color: white;' : ''}">${cat.categoryName}</a>
                        </c:forEach>
                    </div>
                </div>

                <div class="product-grid">
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <a href="${pageContext.request.contextPath}/product-details?id=${product.productId}"
                                    class="product-card">
                                    <div class="product-image-wrapper">
                                        <c:if test="${product.discountPercent > 0}">
                                            <div class="discount-badge">-${product.discountPercent}%</div>
                                        </c:if>
                                        <c:set var="isWishlisted" value="false" />
                                        <c:if
                                            test="${not empty sessionScope.wishlistProductIds and sessionScope.wishlistProductIds.contains(product.productId)}">
                                            <c:set var="isWishlisted" value="true" />
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/toggle-wishlist" method="POST"
                                            style="position: absolute; top: 10px; right: 10px; z-index: 10;">
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <input type="hidden" name="action"
                                                value="${isWishlisted ? 'remove' : 'add'}">
                                            <button type="submit" class="wishlist-btn"
                                                aria-label="${isWishlisted ? 'Remove from Wishlist' : 'Add to Wishlist'}"
                                                onclick="event.stopPropagation();"
                                                title="${isWishlisted ? 'Remove from wishlist' : 'Add to wishlist'}">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                    viewBox="0 0 24 24" fill="${isWishlisted ? '#ef4444' : 'none'}"
                                                    stroke="${isWishlisted ? '#ef4444' : 'currentColor'}"
                                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path
                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                    </path>
                                                </svg>
                                            </button>
                                        </form>
                                        <c:choose>
                                            <c:when test="${not empty product.imageUrl}">
                                                <img src="${product.imageUrl}" alt="${product.productName}"
                                                    class="product-image">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="product-image placeholder">No Image</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="product-info">
                                        <div class="product-category">${product.categoryName}</div>
                                        <h3 class="product-title">${product.productName}</h3>
                                        <div class="product-price">&#8377;
                                            <fmt:formatNumber value="${product.unitPrice}" pattern="#,##0.00" />
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-error" style="grid-column: 1 / -1;">
                                No products found.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <jsp:include page="/WEB-INF/views/partials/footer.jsp" />