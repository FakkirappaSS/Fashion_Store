<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container" style="margin-top: 40px;">
    <h2 class="page-title">My Orders</h2>

    <div class="card">
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <c:choose>
                    <c:when test="${not empty orders}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Date</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td><strong>#${order.orderId}</strong></td>
                                        <td>${order.orderDate}</td>
                                        <td>&#8377;<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                        <td>
                                            <span
                                                style="padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 500; 
                                        ${order.orderStatus == 'Pending' ? 'background: #fef3c7; color: #d97706;' : ''}
                                        ${order.orderStatus == 'Delivered' ? 'background: #d1fae5; color: #059669;' : ''}">
                                                ${order.orderStatus}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/order-details?id=${order.orderId}"
                                                class="btn btn-outline" style="padding: 6px 12px; font-size: 12px;">View
                                                Details</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center" style="padding: 40px 0;">
                            <p style="color: var(--text-light); margin-bottom: 20px;">You haven't placed any orders yet.
                            </p>
                            <a href="${pageContext.request.contextPath}/products" class="btn">Start Shopping</a>
                        </div>
                    </c:otherwise>
                </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />