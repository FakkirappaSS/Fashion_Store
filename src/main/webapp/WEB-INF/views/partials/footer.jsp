<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <footer class="site-footer" style="background-color: var(--bg-light); border-top: 1px solid var(--border-color); padding: 60px 0 20px 0; margin-top: auto;">
        <div class="container" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 40px; margin-bottom: 40px;">
            <div class="footer-col">
                <h3 style="font-size: 20px; font-weight: 800; color: var(--primary-color); margin-bottom: 20px; letter-spacing: -0.5px;">FashionStore</h3>
                <p style="color: var(--text-light); line-height: 1.6; font-size: 14px;">Elevating your everyday style with premium quality apparel and accessories curated just for you.</p>
            </div>
            
            <div class="footer-col">
                <h4 style="font-weight: 600; margin-bottom: 20px; font-size: 16px;">Quick Links</h4>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/home" style="color: var(--text-light); text-decoration: none; font-size: 14px; transition: color 0.2s;">Home</a>
                    <a href="${pageContext.request.contextPath}/products" style="color: var(--text-light); text-decoration: none; font-size: 14px; transition: color 0.2s;">Shop</a>
                    <a href="${pageContext.request.contextPath}/cart" style="color: var(--text-light); text-decoration: none; font-size: 14px; transition: color 0.2s;">Cart</a>
                    <a href="${pageContext.request.contextPath}/wishlist" style="color: var(--text-light); text-decoration: none; font-size: 14px; transition: color 0.2s;">Wishlist</a>
                </div>
            </div>
            
            <div class="footer-col">
                <h4 style="font-weight: 600; margin-bottom: 20px; font-size: 16px;">Customer Service</h4>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <a href="#" style="color: var(--text-light); text-decoration: none; font-size: 14px; transition: color 0.2s;">Contact Us</a>
                    <a href="#" style="color: var(--text-light); text-decoration: none; font-size: 14px; transition: color 0.2s;">Shipping & Returns</a>
                    <a href="#" style="color: var(--text-light); text-decoration: none; font-size: 14px; transition: color 0.2s;">FAQ</a>
                    <a href="#" style="color: var(--text-light); text-decoration: none; font-size: 14px; transition: color 0.2s;">Size Guide</a>
                </div>
            </div>
            
            <div class="footer-col">
                <h4 style="font-weight: 600; margin-bottom: 20px; font-size: 16px;">Newsletter</h4>
                <p style="color: var(--text-light); font-size: 14px; margin-bottom: 15px;">Subscribe to get special offers, free giveaways, and once-in-a-lifetime deals.</p>
                <form id="newsletter-form" style="display: flex; gap: 8px;">
                    <input type="email" id="newsletter-email" required placeholder="Enter your email" style="padding: 10px 14px; border: 1px solid var(--border-color); border-radius: 4px; flex: 1; background: var(--white); color: var(--text-main);">
                    <button type="submit" class="btn" style="padding: 10px 16px;">Subscribe</button>
                </form>
                <div id="newsletter-message" style="margin-top: 10px; font-size: 14px; font-weight: 500; display: none;"></div>
            </div>

            <script>
                document.addEventListener("DOMContentLoaded", function() {
                    const form = document.getElementById("newsletter-form");
                    const emailInput = document.getElementById("newsletter-email");
                    const messageDiv = document.getElementById("newsletter-message");
                    
                    if (form) {
                        form.addEventListener("submit", function(event) {
                            event.preventDefault();
                            const email = emailInput.value.trim();
                            if (email) {
                                messageDiv.style.display = "block";
                                messageDiv.style.color = "#047857";
                                messageDiv.innerHTML = "✨ Thank you for subscribing!";
                                emailInput.value = "";
                                
                                setTimeout(function() {
                                    messageDiv.style.display = "none";
                                }, 4000);
                            }
                        });
                    }
                });
            </script>
        </div>
        
        <div class="container">
            <div style="border-top: 1px solid var(--border-color); padding-top: 20px; display: flex; justify-content: space-between; align-items: center; color: var(--text-light); font-size: 13px;">
                <div>&copy; 2026 FashionStore. All rights reserved.</div>
                <div style="display: flex; gap: 15px;">
                    <a href="#" style="color: var(--text-light); text-decoration: none;">Privacy Policy</a>
                    <a href="#" style="color: var(--text-light); text-decoration: none;">Terms of Service</a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
