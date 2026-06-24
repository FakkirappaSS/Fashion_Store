<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container" style="margin-top: 40px;">
    <h2 class="page-title">Checkout</h2>
    
    <div style="display: flex; gap: 30px; align-items: flex-start;">
        <div class="card" style="flex: 2;">
            <h3 style="margin-top: 0; margin-bottom: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;">Delivery Details</h3>
            
            <c:if test="${param.error == 'true'}">
                <div class="alert alert-error">Failed to place order. Please try again.</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/place-order" method="POST">
                <div style="margin-bottom: 20px;">
                    <label for="deliveryAddress">Shipping Address</label>
                    <textarea id="deliveryAddress" name="deliveryAddress" rows="4" required style="width: 100%; padding: 12px; margin-top: 8px; border: 1px solid var(--border-color); border-radius: 6px; resize: vertical;">${sessionScope.user.address}</textarea>
                </div>
                
                <h3 style="margin-top: 30px; margin-bottom: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;">Payment Method</h3>
                
                <div style="display: flex; gap: 20px; margin-bottom: 30px;">
                    <label style="flex: 1; border: 1px solid var(--border-color); padding: 15px; border-radius: 6px; cursor: pointer; display: flex; align-items: center; gap: 10px;">
                        <input type="radio" name="paymentMethod" value="Card" required>
                        <span>Credit / Debit Card</span>
                    </label>
                    <label style="flex: 1; border: 1px solid var(--border-color); padding: 15px; border-radius: 6px; cursor: pointer; display: flex; align-items: center; gap: 10px;">
                        <input type="radio" name="paymentMethod" value="UPI">
                        <span>UPI</span>
                    </label>
                    <label style="flex: 1; border: 1px solid var(--border-color); padding: 15px; border-radius: 6px; cursor: pointer; display: flex; align-items: center; gap: 10px;">
                        <input type="radio" name="paymentMethod" value="COD">
                        <span>Cash on Delivery</span>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-block" style="padding: 15px; font-size: 16px;">Place Order</button>
            </form>
        </div>
        
        <div class="card" style="flex: 1;">
            <h3 style="margin-top: 0; margin-bottom: 20px; font-size: 20px;">Order Summary</h3>
            
            <div style="margin-bottom: 20px; max-height: 300px; overflow-y: auto;">
                <c:forEach var="item" items="${cart.items}">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 15px; align-items: center;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <div style="width: 40px; height: 40px; background: #e2e8f0; border-radius: 4px; overflow: hidden;">
                                <c:if test="${not empty item.product.imageUrl}">
                                    <img src="${item.product.imageUrl}" style="width: 100%; height: 100%; object-fit: cover;">
                                </c:if>
                            </div>
                            <div>
                                <div style="font-size: 14px; font-weight: 500;">${item.product.productName}</div>
                                <div style="font-size: 12px; color: var(--text-light);">Size: ${item.sizeLabel} | Qty: ${item.quantity}</div>
                            </div>
                        </div>
                        <div style="font-weight: 500;">&#8377;<fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#,##0.00"/></div>
                    </div>
                </c:forEach>
            </div>
            
            <div style="display: flex; justify-content: space-between; margin-bottom: 20px; padding-top: 15px; border-top: 1px solid var(--border-color); font-size: 18px; font-weight: 700;">
                <span>Total</span>
                <span>&#8377;<fmt:formatNumber value="${cartTotal}" pattern="#,##0.00"/></span>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
