<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ChocoArt.Pages.Login" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Login</title>
    <link rel="stylesheet" href="../Content/styles.css">
    <style>
        .login-body {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #FEFAE0 0%, #ffeedb 100%);
        }
        .login-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(15px);
            padding: 3rem;
            border-radius: 30px;
            box-shadow: 0 20px 50px rgba(93, 58, 26, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .login-logo {
            height: 70px;
            margin-bottom: 2rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--primary);
            font-weight: 600;
        }
        .form-control {
            width: 100%;
            padding: 1rem 1.5rem;
            border-radius: 15px;
            border: 1px solid #ddd;
            background: white;
            font-family: inherit;
            transition: var(--transition);
        }
        .form-control:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 4px rgba(230, 57, 70, 0.1);
        }
        .btn-login {
            width: 100%;
            margin-top: 1rem;
        }
        .error-msg {
            color: var(--secondary);
            margin-top: 1rem;
            font-size: 0.9rem;
            display: none;
        }
    </style>
</head>
<body class="login-body">
    <div class="login-card">
        <img src="../assets/LogoChocoArt.png" alt="ChocoArt Logo" class="login-logo">
        <h2 style="margin-bottom: 2rem; color: var(--primary);">Acceso al Sistema</h2>
        
        <div class="form-group">
            <label>Usuario</label>
            <input type="text" id="txtUser" class="form-control" placeholder="Ingresa tu usuario">
        </div>
        
        <div class="form-group">
            <label>Contraseña</label>
            <input type="password" id="txtPass" class="form-control" placeholder="••••••••">
        </div>
        
        <button type="button" id="btnLogin" class="btn btn-primary btn-login">Entrar</button>
        
        <div id="errorMsg" class="error-msg">Usuario o contraseña incorrectos</div>
        
        <p style="margin-top: 2rem; font-size: 0.8rem; color: var(--text-muted);">
            &copy; 2026 ChocoArt. Gestión Interna.
        </p>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#btnLogin').on('click', function() {
                const user = $('#txtUser').val();
                const pass = $('#txtPass').val();
                
                if (!user || !pass) {
                    $('#errorMsg').text('Por favor completa todos los campos').fadeIn();
                    return;
                }

                $.ajax({
                    url: '../Handlers/ProjectHandler.ashx',
                    type: 'POST',
                    data: {
                        cmd: 'login',
                        user: user,
                        pass: pass
                    },
                    success: function(response) {
                        if (response.status === 'success') {
                            window.location.href = 'Dashboard.aspx';
                        } else {
                            $('#errorMsg').text(response.message).fadeIn();
                        }
                    },
                    error: function() {
                        $('#errorMsg').text('Error en la comunicación con el servidor').fadeIn();
                    }
                });
            });
            
            // Allow Enter key to submit
            $('.form-control').keypress(function(e) {
                if(e.which == 13) $('#btnLogin').click();
            });
        });
    </script>
</body>
</html>
