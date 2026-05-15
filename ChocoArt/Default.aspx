<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ChocoArt.Default" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Diseños Únicos de Chocofrutas</title>
    <link rel="apple-touch-icon" sizes="180x180" href="assets/favicon_io/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="assets/favicon_io/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="assets/favicon_io/favicon-16x16.png">
    <link rel="shortcut icon" href="assets/favicon_io/favicon.ico" type="image/x-icon">
    <link rel="manifest" href="assets/favicon_io/site.webmanifest">
    <meta name="description" content="ChocoArt ofrece una experiencia dulce y especial con diseños únicos de frutas con chocolate en Boca del Monte.">
    <link rel="stylesheet" href="Content/styles.css">
    <style>
        .login-nav {
            background: var(--primary);
            color: var(--white) !important;
            padding: 0.8rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 4px 15px rgba(93, 58, 26, 0.2);
        }
        .login-nav:hover {
            background: var(--secondary);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(230, 57, 70, 0.3);
            color: var(--white) !important;
        }
        .header-actions {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }
        @media (max-width: 768px) {
            .login-nav {
                display: none; /* Occult on mobile, show only in sidebar */
            }
        }
        .sidebar-login-btn {
            background: var(--white);
            color: var(--primary) !important;
            padding: 1rem;
            border-radius: 15px;
            text-align: center;
            margin-top: 2rem;
            font-weight: 800;
            display: block;
        }
    </style>
</head>
<body>

    <!-- Sidebar Navigation -->
    <div id="sidebar" class="sidebar">
        <button id="close-sidebar" class="close-btn">&times;</button>
        <div class="sidebar-content">
            <img src="assets/LogoChocoArt.png" alt="ChocoArt Logo" class="sidebar-logo">
            <nav>
                <ul>
                    <li><a href="#home">Inicio</a></li>
                    <li><a href="#about">Nosotros</a></li>
                    <li><a href="#gallery">Diseños</a></li>
                    <li><a href="#contact">Contacto</a></li>
                </ul>
            </nav>
            <a href="Pages/Login.aspx" class="sidebar-login-btn">Iniciar Sesión</a>
        </div>
    </div>
    <div id="overlay" class="overlay"></div>

    <!-- Header -->
    <header id="header">
        <div class="container header-container">
            <div class="logo">
                <a href="#home">
                    <img src="assets/LogoChocoArt.png" alt="ChocoArt Logo">
                </a>
            </div>
            <div class="header-actions">
                <a href="Pages/Login.aspx" class="login-nav">Iniciar Sesión</a>
                <div id="menu-toggle" class="menu-toggle">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>
        </div>
    </header>

    <main>
        <!-- Hero Section -->
        <section id="home" class="hero">
            <div class="container hero-container">
                <div class="hero-content reveal">
                    <h1>Diseños <span>Únicos</span></h1>
                    <p>Transmitiendo alegría y creatividad a través de la fruta y el chocolate.</p>
                    <div class="hero-btns">
                        <a href="#gallery" class="btn btn-primary">Ver Diseños</a>
                        <a href="#about" class="btn btn-outline">Nuestra Misión</a>
                    </div>
                </div>
                <div class="hero-image reveal">
                    <img src="assets/1.png" alt="ChocoArt Showcase" class="floating">
                </div>
            </div>
        </section>

        <!-- About Section (Mission, Vision, Objective) -->
        <section id="about" class="about">
            <div class="container">
                <div class="section-title reveal">
                    <h2>Nuestra Esencia</h2>
                    <p>Conoce lo que nos impulsa a crear cada día.</p>
                </div>
                <div class="about-grid">
                    <div class="about-card reveal">
                        <div class="card-icon">🎯</div>
                        <h3>Objetivo</h3>
                        <p>Atraer a los clientes con nuestros diseños para ingresar en el área de Boca del Monte.</p>
                    </div>
                    <div class="about-card reveal highlight">
                        <div class="card-icon">✨</div>
                        <h3>Misión</h3>
                        <p>Ofrecer una experiencia dulce y especial transmitiendo alegría y creatividad.</p>
                    </div>
                    <div class="about-card reveal">
                        <div class="card-icon">👁️</div>
                        <h3>Visión</h3>
                        <p>Destacar por los diseños y posicionarnos como la primera opción del consumidor en Boca del Monte.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Gallery Section -->
        <section id="gallery" class="gallery">
            <div class="container">
                <div class="section-title reveal">
                    <h2>Galería de Arte Frutal</h2>
                    <p>Cada pieza es una obra de arte comestible.</p>
                </div>
                <div class="gallery-grid">
                    <div class="gallery-item reveal">
                        <img src="assets/CorazonDeMelon.png" alt="Corazon de Melon">
                        <div class="gallery-overlay"><span>Corazon de Melon</span></div>
                    </div>
                    <div class="gallery-item reveal">
                        <img src="assets/EstrellaDePina.JPG" alt="Estrella de Pina">
                        <div class="gallery-overlay"><span>Estrella de Pina</span></div>
                    </div>
                    <div class="gallery-item reveal">
                        <img src="assets/Fresa.png" alt="Fresa con Chocolate">
                        <div class="gallery-overlay"><span>Fresa Artistica</span></div>
                    </div>
                    <div class="gallery-item reveal">
                        <img src="assets/ChocoPinaPino.png" alt="Choco Pina con Toppings">
                        <div class="gallery-overlay"><span>Choco Pina</span></div>
                    </div>
                    <div class="gallery-item reveal">
                        <img src="assets/Topings.png" alt="Chocolate con Toppings">
                        <div class="gallery-overlay"><span>Toppings</span></div>
                    </div>
                    <div class="gallery-item reveal">
                        <img src="assets/Chocolate.png" alt="Chocolate">
                        <div class="gallery-overlay"><span>Chocolate</span></div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer id="contact">
        <div class="container footer-container">
            <div class="footer-info">
                <img src="assets/LogoChocoArt.png" alt="ChocoArt Logo" class="footer-logo">
                <p>Boca del Monte, Guatemala</p>
                <p>Una experiencia dulce y creativa.</p>
            </div>
            <div class="footer-links">
                <h4>Enlaces</h4>
                <ul>
                    <li><a href="#home">Inicio</a></li>
                    <li><a href="#about">Nosotros</a></li>
                    <li><a href="#gallery">Diseños</a></li>
                </ul>
            </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 ChocoArt. Todos los derechos reservados.</p>
        </div>
    </footer>

    <script src="Scripts/script.js"></script>
</body>
</html>
