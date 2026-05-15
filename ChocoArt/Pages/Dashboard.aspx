<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="ChocoArt.Pages.Dashboard" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Dashboard</title>
    <link rel="apple-touch-icon" sizes="180x180" href="../assets/favicon_io/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../assets/favicon_io/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="../assets/favicon_io/favicon-16x16.png">
    <link rel="shortcut icon" href="../assets/favicon_io/favicon.ico" type="image/x-icon">
    <link rel="manifest" href="../assets/favicon_io/site.webmanifest">
    <link rel="stylesheet" href="../Content/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

        <div id="menu-container" class="dashboard-grid">
            <!-- Los menús se cargarán dinámicamente aquí -->
        </div>
    </main>

    <footer style="background: transparent; padding: 2rem 0; text-align: center; color: var(--text-muted);">
        <p>&copy; 2026 ChocoArt. Sistema de Gestión Interna.</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Cargar Menús Dinámicos
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getMenus' },
                success: function(res) {
                    if(res.status === 'success') {
                        let menus = res.data;
                        let html = '';
                        
                        menus.forEach(function(m) {
                            html += `
                                <a href="${m.url}" class="mod-card reveal active">
                                    <span class="mod-icon"><i class="${m.icono}"></i></span>
                                    <h3>${m.nombre}</h3>
                                    <p>${m.descripcion || ''}</p>
                                </a>`;
                        });
                        
                        $('#menu-container').html(html);
                    } else {
                        console.error('Error al cargar menús:', res.message);
                        $('#menu-container').html('<p style="color:red; text-align:center; padding:2rem;">Error al cargar el panel: ' + res.message + '</p>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error de red/servidor:', error);
                    $('#menu-container').html('<p style="color:red; text-align:center; padding:2rem;">Error de comunicación con el servidor.</p>');
                }
            });
        });
    </script>
</body>
</html>
