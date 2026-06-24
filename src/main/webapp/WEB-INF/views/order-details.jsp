<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container" style="margin-top: 40px;">
    

    <c:if test="${param.success == 'true'}">
        <div class="alert alert-success">Order placed successfully! Thank you for shopping with us.</div>
    </c:if>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
        <h2 class="page-title" style="margin-bottom: 0;">Order Details</h2>
        <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline" style="padding: 8px 16px;">Back to Orders</a>
    </div>
    
    <c:choose>
        <c:when test="${not empty order}">
            <div style="display: flex; gap: 30px; align-items: flex-start;">
                <div class="card" style="flex: 2;">
                    <div style="display: flex; justify-content: space-between; border-bottom: 1px solid var(--border-color); padding-bottom: 15px; margin-bottom: 20px;">
                        <div>
                            <h3 style="margin: 0 0 5px 0;">Order #${order.orderId}</h3>
                            <div style="color: var(--text-light); font-size: 14px;">Placed on: ${order.orderDate}</div>
                        </div>
                        <div style="text-align: right;">
                            <span style="padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 500; 
                                ${order.orderStatus == 'Pending' ? 'background: #fef3c7; color: #d97706;' : ''}
                                ${order.orderStatus == 'Delivered' ? 'background: #d1fae5; color: #059669;' : ''}">
                                ${order.orderStatus}
                            </span>
                        </div>
                    </div>
                    
                    <h4 style="margin-bottom: 15px;">Items</h4>
                    <table>
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Size</th>
                                <th>Price</th>
                                <th>Qty</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.orderItems}">
                                <tr>
                                    <td>
                                        <div style="font-weight: 500;">${item.productName}</div>
                                    </td>
                                    <td>${item.sizeLabel}</td>
                                    <td>&#8377;<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                    <td>${item.quantity}</td>
                                    <td style="font-weight: 600;">&#8377;<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <div class="card" style="flex: 1;">
                    <h3 style="margin-top: 0; margin-bottom: 20px; font-size: 20px;">Summary</h3>
                    
                    <div style="display: flex; justify-content: space-between; margin-bottom: 15px; color: var(--text-light);">
                        <span>Payment Method</span>
                        <span style="font-weight: 500; color: var(--text-main);">${order.paymentMethod}</span>
                    </div>
                    
                    <div style="border-top: 1px solid var(--border-color); margin: 20px 0;"></div>
                    
                    <div style="display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 18px; font-weight: 700;">
                        <span>Total Paid</span>
                        <span>&#8377;<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                    </div>
                    
                    <h4 style="margin-top: 30px; margin-bottom: 15px; font-size: 16px;">Delivery Address</h4>
                    <p style="color: var(--text-light); line-height: 1.5; margin: 0;">
                        ${order.deliveryAddress}
                    </p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-error">Order not found or you don't have permission to view it.</div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
