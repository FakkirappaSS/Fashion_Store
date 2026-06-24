// main.js
document.addEventListener('DOMContentLoaded', () => {
    console.log('FashionStore initialized');

    // --- Theme Toggle Logic ---
    const themeToggleBtn = document.getElementById('themeToggleBtn');
    const sunIcon = document.getElementById('sunIcon');
    const moonIcon = document.getElementById('moonIcon');

    // Check for saved theme preference in localStorage
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        document.documentElement.classList.add('dark-theme');
        updateThemeIcons('dark');
    }

    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', () => {
            document.documentElement.classList.toggle('dark-theme');
            let theme = 'light';
            if (document.documentElement.classList.contains('dark-theme')) {
                theme = 'dark';
            }
            localStorage.setItem('theme', theme);
            updateThemeIcons(theme);
        });
    }

    function updateThemeIcons(theme) {
        if (!sunIcon || !moonIcon) return;
        if (theme === 'dark') {
            sunIcon.style.display = 'block';
            moonIcon.style.display = 'none';
        } else {
            sunIcon.style.display = 'none';
            moonIcon.style.display = 'block';
        }
    }

    // --- Hero Slider Logic ---
    const slides = document.querySelectorAll('.hero-slide');
    const dots = document.querySelectorAll('.dot');
    const prevBtn = document.querySelector('.slider-arrow.prev');
    const nextBtn = document.querySelector('.slider-arrow.next');

    if (slides.length > 0) {
        let currentSlide = 0;
        let slideInterval;

        function goToSlide(index) {
            slides[currentSlide].classList.remove('active');
            dots[currentSlide].classList.remove('active');
            
            currentSlide = (index + slides.length) % slides.length;
            
            slides[currentSlide].classList.add('active');
            dots[currentSlide].classList.add('active');
        }

        function nextSlide() {
            goToSlide(currentSlide + 1);
        }

        function prevSlide() {
            goToSlide(currentSlide - 1);
        }

        function startSlideShow() {
            slideInterval = setInterval(nextSlide, 5000); // 5 seconds
        }

        function resetSlideShow() {
            clearInterval(slideInterval);
            startSlideShow();
        }

        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                nextSlide();
                resetSlideShow();
            });
        }

        if (prevBtn) {
            prevBtn.addEventListener('click', () => {
                prevSlide();
                resetSlideShow();
            });
        }

        dots.forEach((dot, index) => {
            dot.addEventListener('click', () => {
                goToSlide(index);
                resetSlideShow();
            });
        });

        // Initialize first slide as active
        slides[0].classList.add('active');
        dots[0].classList.add('active');
        startSlideShow();
    }

    // --- AJAX Wishlist Logic ---
    const wishlistForms = document.querySelectorAll('form[action*="/toggle-wishlist"]');
    wishlistForms.forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const btn = this.querySelector('.wishlist-btn');
            const svg = btn.querySelector('svg');
            const actionInput = this.querySelector('input[name="action"]');
            
            const formData = new URLSearchParams(new FormData(this));
            
            fetch(this.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData.toString()
            })
            .then(response => {
                if (response.status === 401) {
                    window.location.href = this.action.replace('/toggle-wishlist', '/login?message=Please login to manage wishlist');
                    throw new Error('Unauthorized');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    if (data.action === 'add') {
                        svg.setAttribute('fill', '#ef4444');
                        svg.setAttribute('stroke', '#ef4444');
                        actionInput.value = 'remove';
                        btn.title = 'Remove from wishlist';
                    } else {
                        svg.setAttribute('fill', 'none');
                        svg.setAttribute('stroke', 'currentColor');
                        actionInput.value = 'add';
                        btn.title = 'Add to wishlist';
                    }
                }
            })
            .catch(error => console.error('Error toggling wishlist:', error));
        });
    });
});
