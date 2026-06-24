<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container">
    <div class="form-container card">
        <h2 class="page-title text-center">Welcome Back</h2>
        <p class="text-center" style="color: var(--text-light); margin-bottom: 30px;">Please enter your details to sign in.</p>
        
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${param.registered == 'true'}">
            <div class="alert alert-success">Registration successful! Please log in.</div>
        </c:if>
        <c:if test="${param.logout == 'true'}">
            <div class="alert alert-success">You have been successfully logged out.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div>
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="Enter your email">
            </div>
            
            <div>
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password">
            </div>
            
            <button type="submit" class="btn btn-block" style="margin-top: 10px;">Sign In</button>
        </form>
        
        <p class="text-center" style="margin-top: 24px; font-size: 14px;">
            Don't have an account? <a href="${pageContext.request.contextPath}/register" style="color: var(--secondary-color); text-decoration: none; font-weight: 500;">Sign up</a>
        </p>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
