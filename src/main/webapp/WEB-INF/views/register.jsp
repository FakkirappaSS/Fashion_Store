<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container">
    <div class="form-container card" style="max-width: 550px;">
        <h2 class="page-title text-center">Create an Account</h2>
        <p class="text-center" style="color: var(--text-light); margin-bottom: 30px;">Join FashionStore today.</p>
        
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="POST">
            <div>
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" required placeholder="John Doe">
            </div>
            
            <div>
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="john@example.com">
            </div>
            
            <div style="display: flex; gap: 15px;">
                <div style="flex: 1;">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" required placeholder="1234567890">
                </div>
                <div style="flex: 1;">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender" required style="width: 100%; padding: 12px 15px; margin: 8px 0 20px 0; border: 1px solid var(--border-color); border-radius: 6px;">
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>
            
            <div>
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Create a strong password">
            </div>
            
            <div>
                <label for="address">Delivery Address</label>
                <textarea id="address" name="address" rows="3" placeholder="Enter your full address" style="width: 100%; padding: 12px 15px; margin: 8px 0 20px 0; border: 1px solid var(--border-color); border-radius: 6px; font-family: 'Inter', sans-serif; font-size: 14px; resize: vertical; box-sizing: border-box;"></textarea>
            </div>
            
            <button type="submit" class="btn btn-block" style="margin-top: 10px;">Create Account</button>
        </form>
        
        <p class="text-center" style="margin-top: 24px; font-size: 14px;">
            Already have an account? <a href="${pageContext.request.contextPath}/login" style="color: var(--secondary-color); text-decoration: none; font-weight: 500;">Sign in</a>
        </p>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
