<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container" style="margin-top: 40px;">
    <div class="card" style="display: flex; gap: 40px; align-items: flex-start;">
        <div style="flex: 1; min-width: 300px;">
            <c:choose>
                <c:when test="${not empty product.imageUrl}">
                    <img src="${product.imageUrl}" alt="${product.productName}" style="width: 100%; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                </c:when>
                <c:otherwise>
                    <div style="width: 100%; height: 400px; background: #e2e8f0; display: flex; align-items: center; justify-content: center; border-radius: 8px;">No Image</div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div style="flex: 1;">
            <div style="text-transform: uppercase; color: var(--text-light); font-size: 14px; letter-spacing: 1px; margin-bottom: 10px;">${product.categoryName}</div>
            <h1 style="margin: 0 0 15px 0; font-size: 32px;">${product.productName}</h1>
            <div style="font-size: 24px; color: var(--primary-color); font-weight: 700; margin-bottom: 20px;">
                &#8377;<fmt:formatNumber value="${product.unitPrice}" pattern="#,##0.00"/>
                <c:if test="${product.discountPercent > 0}">
                    <span style="font-size: 14px; color: #ef4444; margin-left: 10px; font-weight: 500;">(-${product.discountPercent}%)</span>
                </c:if>
            </div>
            
            <p style="color: var(--text-light); line-height: 1.6; margin-bottom: 30px;">${product.description}</p>
            
            <form action="${pageContext.request.contextPath}/add-to-cart" method="POST" style="background: var(--bg-light); padding: 20px; border-radius: 8px; border: 1px solid var(--border-color);">
                <input type="hidden" name="productId" value="${product.productId}">
                
                <div style="margin-bottom: 15px;">
                    <label for="sizeLabel" style="display: block; margin-bottom: 8px; font-weight: 600;">Select Size</label>
                    <c:choose>
                        <c:when test="${empty product.variants}">
                            <select name="sizeLabel" id="sizeLabel" required style="width: 100%; background-color: #f1f5f9; cursor: not-allowed;" disabled>
                                <option value="N/A">Size Not Available (N/A)</option>
                            </select>
                            <input type="hidden" name="sizeLabel" value="N/A">
                        </c:when>
                        <c:otherwise>
                            <select name="sizeLabel" id="sizeLabel" required style="width: 100%;">
                                <option value="">Choose a size</option>
                                <c:forEach var="variant" items="${product.variants}">
                                    <option value="${variant.sizeLabel}">${variant.sizeLabel} (Stock: ${variant.stockQuantity})</option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div style="margin-bottom: 20px;">
                    <label for="quantity" style="display: block; margin-bottom: 8px; font-weight: 600;">Quantity</label>
                    <input type="number" name="quantity" id="quantity" value="1" min="1" max="10" required style="width: 100%;">
                </div>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <button type="submit" class="btn btn-block" style="padding: 14px;">Add to Cart</button>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-block btn-outline" style="padding: 14px; display: block; text-align: center;">Log in to Add to Cart</a>
                    </c:otherwise>
                </c:choose>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
