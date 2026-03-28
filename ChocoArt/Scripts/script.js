document.addEventListener('DOMContentLoaded', () => {
    const menuToggle = document.getElementById('menu-toggle');
    const closeSidebar = document.getElementById('close-sidebar');
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');
    const header = document.getElementById('header');
    const navLinks = document.querySelectorAll('.sidebar nav ul li a');

    // Sidebar Toggle
    const toggleSidebar = () => {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
        menuToggle.classList.toggle('active');
        document.body.classList.toggle('no-scroll');
    };

    menuToggle.addEventListener('click', toggleSidebar);
    closeSidebar.addEventListener('click', toggleSidebar);
    overlay.addEventListener('click', toggleSidebar);

    // Close sidebar on link click
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
            document.body.classList.remove('no-scroll');
        });
    });

    // Header Scroll Effect
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });

    // Reveal Animations on Scroll
    const reveals = document.querySelectorAll('.reveal');
    const revealOnScroll = () => {
        for (let i = 0; i < reveals.length; i++) {
            const windowHeight = window.innerHeight;
            const elementTop = reveals[i].getBoundingClientRect().top;
            const elementVisible = 150;
            if (elementTop < windowHeight - elementVisible) {
                reveals[i].classList.add('active');
            }
        }
    };

    window.addEventListener('scroll', revealOnScroll);
    revealOnScroll(); // Initial check

    // Floating Fruits System
    const createFloatingFruits = () => {
        const fruitImages = ['assets/1.png', 'assets/4.png', 'assets/fresa.jpg'];
        const container = document.body;

        for (let i = 0; i < 8; i++) {
            const fruit = document.createElement('img');
            fruit.src = fruitImages[Math.floor(Math.random() * fruitImages.length)];
            fruit.className = `floating-fruit type-${(i % 2) + 1}`;
            
            // Random positions
            fruit.style.top = `${Math.random() * 100}vh`;
            fruit.style.left = `${Math.random() * 100}vw`;
            fruit.style.width = `${Math.random() * 50 + 50}px`;
            
            // Random animation delay
            fruit.style.animationDelay = `${Math.random() * 10}s`;
            
            container.appendChild(fruit);
        }
    };

    createFloatingFruits();
});
