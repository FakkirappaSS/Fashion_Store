<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container" style="margin-top: 40px;">
    <h2 class="page-title">Shopping Cart</h2>
    
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
    
    <c:choose>
        <c:when test="${not empty cart and not empty cart.items}">
            <div style="display: flex; gap: 30px; align-items: flex-start;">
                <div class="card" style="flex: 2;">
                    <table>
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Size</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Total</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cart.items}">
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 15px;">
                                            <div style="width: 60px; height: 60px; background: #e2e8f0; border-radius: 4px; overflow: hidden;">
                                                <c:if test="${not empty item.product.imageUrl}">
                                                    <img src="${item.product.imageUrl}" style="width: 100%; height: 100%; object-fit: cover;">
                                                </c:if>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" style="color: var(--text-main); font-weight: 500; text-decoration: none;">${item.product.productName}</a>
                                        </div>
                                    </td>
                                    <td>${item.sizeLabel}</td>
                                    <td>&#8377;<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/update-cart" method="POST" style="display: flex; gap: 5px;">
                                            <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                            <input type="number" name="quantity" value="${item.quantity}" min="1" max="10" style="width: 60px; padding: 5px; border: 1px solid var(--border-color); border-radius: 4px;">
                                            <button type="submit" class="btn btn-outline" style="padding: 5px 10px; font-size: 12px;">Update</button>
                                        </form>
                                    </td>
                                    <td style="font-weight: 600;">&#8377;<fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#,##0.00"/></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/remove-cart-item?id=${item.cartItemId}" class="btn btn-danger" style="padding: 5px 10px; font-size: 12px; text-decoration: none;">Remove</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <div class="card" style="flex: 1;">
                    <h3 style="margin-top: 0; margin-bottom: 20px; font-size: 20px;">Order Summary</h3>
                    
                    <div style="display: flex; justify-content: space-between; margin-bottom: 15px; color: var(--text-light);">
                        <span>Subtotal</span>
                        <span>&#8377;<fmt:formatNumber value="${cartTotal}" pattern="#,##0.00"/></span>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 15px; color: var(--text-light);">
                        <span>Shipping</span>
                        <span>Free</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 25px; padding-top: 15px; border-top: 1px solid var(--border-color); font-size: 18px; font-weight: 700;">
                        <span>Total</span>
                        <span>&#8377;<fmt:formatNumber value="${cartTotal}" pattern="#,##0.00"/></span>
                    </div>
                    
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-block" style="padding: 15px; font-size: 16px;">Proceed to Checkout</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card text-center" style="padding: 60px 20px;">
                <div style="font-size: 48px; color: #cbd5e1; margin-bottom: 20px;">🛒</div>
                <h3 style="font-size: 24px; margin-bottom: 10px;">Your cart is empty</h3>
                <p style="color: var(--text-light); margin-bottom: 30px;">Looks like you haven't added anything to your cart yet.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn">Continue Shopping</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
