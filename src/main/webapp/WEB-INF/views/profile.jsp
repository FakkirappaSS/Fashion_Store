<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container" style="margin-top: 40px;">
    <div class="form-container card" style="max-width: 600px;">
        <h2 class="page-title">My Profile</h2>
        
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/profile" method="POST">
            <div>
                <label for="email">Email Address (Cannot be changed)</label>
                <input type="email" id="email" value="${sessionScope.user.email}" disabled style="background-color: #f1f5f9; cursor: not-allowed;">
            </div>
            
            <div>
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" value="${sessionScope.user.fullName}" required>
            </div>
            
            <div style="display: flex; gap: 15px;">
                <div style="flex: 1;">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" value="${sessionScope.user.phone}" required>
                </div>
                <div style="flex: 1;">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender" required style="width: 100%; padding: 12px 15px; margin: 8px 0 20px 0; border: 1px solid var(--border-color); border-radius: 6px;">
                        <option value="Male" ${sessionScope.user.gender == 'Male' ? 'selected' : ''}>Male</option>
                        <option value="Female" ${sessionScope.user.gender == 'Female' ? 'selected' : ''}>Female</option>
                        <option value="Other" ${sessionScope.user.gender == 'Other' ? 'selected' : ''}>Other</option>
                    </select>
                </div>
            </div>
            
            <div>
                <label for="address">Default Delivery Address</label>
                <textarea id="address" name="address" rows="3" style="width: 100%; padding: 12px 15px; margin: 8px 0 20px 0; border: 1px solid var(--border-color); border-radius: 6px; font-family: 'Inter', sans-serif; font-size: 14px; resize: vertical; box-sizing: border-box;">${sessionScope.user.address}</textarea>
            </div>
            
            <button type="submit" class="btn btn-block" style="margin-top: 10px;">Update Profile</button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
