<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="ChocoArt.Pages.Dashboard" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Dashboard</title>
    <link rel="stylesheet" href="../Content/styles.css">
    <style>
        .dashboard-body {
            background: var(--bg-light);
            min-height: 100vh;
        }
        .dashboard-container {
            padding-top: 120px;
            padding-bottom: 50px;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        .mod-card {
            background: white;
            padding: 2.5rem;
            border-radius: 25px;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            text-decoration: none;
            display: block;
        }
        .mod-card:hover {
            transform: translateY(-10px);
            border-color: var(--secondary);
            box-shadow: 0 15px 40px rgba(230, 57, 70, 0.1);
        }
        .mod-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            display: block;
        }
        .mod-card h3 {
            margin-bottom: 1rem;
            color: var(--primary);
        }
        .mod-card p {
            color: var(--text-muted);
            font-size: 0.95rem;
        }
        .welcome-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .logout-btn {
            padding: 0.8rem 1.5rem;
            font-size: 0.9rem;
        }
    </style>
</head>
<body class="dashboard-body">
    <header id="header" class="scrolled">
        <div class="container header-container">
            <div class="logo">
                <a href="Dashboard.aspx">
                    <img src="../assets/LogoChocoArt.png" alt="ChocoArt Logo" style="height: 45px;">
                </a>
            </div>
            <div class="user-info" style="display: flex; align-items: center; gap: 1.5rem;">
                <span style="font-weight: 600; color: var(--primary);">Hola, <%= Session["Usuario"] %></span>
                <a href="Login.aspx?logout=1" class="btn btn-outline logout-btn">Cerrar Sesión</a>
            </div>
        </div>
    </header>

    <main class="container dashboard-container">
        <div class="welcome-section">
            <div class="reveal active">
                <h1 style="font-size: 2.5rem;">Panel de <span>Administración</span></h1>
                <p>Gestiona todos los aspectos de tu negocio de Chocofrutas.</p>
            </div>
        </div>

        <div class="dashboard-grid">
            <a href="Usuarios.aspx" class="mod-card reveal active">
                <span class="mod-icon">👥</span>
                <h3>Usuarios</h3>
                <p>Gestiona los accesos al sistema, añade o bloquea colaboradores.</p>
            </a>

            <a href="Productos.aspx" class="mod-card reveal active">
                <span class="mod-icon">🍓</span>
                <h3>Productos</h3>
                <p>Controla el catálogo de diseños, precios y existencias.</p>
            </a>

            <a href="Ventas.aspx" class="mod-card reveal active">
                <span class="mod-icon">💰</span>
                <h3>Ventas</h3>
                <p>Visualiza el historial de pedidos y el rendimiento del negocio.</p>
            </a>

            <a href="Reportes.aspx" class="mod-card reveal active">
                <span class="mod-icon">📊</span>
                <h3>Reportes</h3>
                <p>Genera informes detallados de actividad y financiero.</p>
            </a>
        </div>
    </main>

    <footer style="background: transparent; padding: 2rem 0; text-align: center; color: var(--text-muted);">
        <p>&copy; 2026 ChocoArt. Sistema de Gestión Interna.</p>
    </footer>
</body>
</html>
