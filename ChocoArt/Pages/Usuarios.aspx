<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="ChocoArt.Pages.Usuarios" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Gestión de Usuarios</title>
    <link rel="apple-touch-icon" sizes="180x180" href="../assets/favicon_io/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../assets/favicon_io/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="../assets/favicon_io/favicon-16x16.png">
    <link rel="shortcut icon" href="../assets/favicon_io/favicon.ico" type="image/x-icon">
    <link rel="manifest" href="../assets/favicon_io/site.webmanifest">
    <link rel="stylesheet" href="../Content/styles.css">
    <style>
        .admin-body { background: var(--bg-light); min-height: 100vh; padding-top: 100px; }
        .data-card { background: white; padding: 2rem; border-radius: 20px; box-shadow: var(--shadow); margin-top: 2rem; }
        .table-controls { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th { text-align: left; padding: 1.2rem; background: #f8f9fa; border-bottom: 2px solid #eee; color: var(--primary); font-weight: 800; }
        td { padding: 1.2rem; border-bottom: 1px solid #eee; }
        .status-badge { padding: 0.4rem 0.8rem; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .status-active { background: #d4edda; color: #155724; }
        .status-inactive { background: #f8d7da; color: #721c24; }
        .action-btn { background: none; border: none; font-size: 1.2rem; cursor: pointer; margin-right: 0.5rem; transition: var(--transition); }
        .action-btn:hover { transform: scale(1.2); }
        
        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); overflow-y: auto; }
        .modal-content { background: white; margin: 2rem auto; padding: 2.5rem; border-radius: 25px; width: 400px; box-shadow: var(--shadow); position: relative; }
        .modal-header { margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; columns: var(--primary); }
    </style>
</head>
<body class="admin-body">
    <header id="header" class="scrolled">
        <div class="container header-container">
            <div class="logo"><a href="Dashboard.aspx"><img src="../assets/LogoChocoArt.png" alt="Logo" style="height: 45px;"></a></div>
            <nav><a href="Dashboard.aspx" class="btn btn-outline" style="padding: 0.6rem 1.2rem;">Volver al Panel</a></nav>
        </div>
    </header>

    <main class="container">
        <div class="reveal active">
            <h1>Gestión de <span>Usuarios</span></h1>
            <p>Añade, edita o elimina los accesos de tus colaboradores.</p>
        </div>

        <div class="data-card reveal active">
            <div class="table-controls">
                <h3>Lista de Usuarios</h3>
                <button class="btn btn-primary" onclick="openModal()">+ Nuevo Usuario</button>
            </div>
            <table id="tblUsuarios">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Usuario</th>
                        <th>Rol</th>
                        <th>Estado</th>
                        <th>Fecha Creación</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- JS loaded content -->
                </tbody>
            </table>
        </div>
    </main>

    <!-- Modal Form -->
    <div id="userModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Nuevo Usuario</h3>
            </div>
            <input type="hidden" id="txtIdUsuario" value="0">
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Nombre de Usuario</label>
                <input type="text" id="txtUsuario" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
            </div>
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Contraseña</label>
                <input type="password" id="txtPassword" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
            </div>
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Rol del Sistema</label>
                <select id="selRol" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                    <!-- Cargado dinámicamente -->
                </select>
            </div>
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Estado</label>
                <select id="selActivo" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                    <option value="1">Activo</option>
                    <option value="0">Inactivo</option>
                </select>
            </div>
            <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                <button class="btn btn-outline" onclick="closeModal()" style="flex: 1;">Cancelar</button>
                <button class="btn btn-primary" onclick="saveUser()" style="flex: 1;">Guardar</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function() {
            loadRoles();
            loadUsers();
        });

        function loadRoles() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getRoles' },
                success: function(res) {
                    if (res.status === 'success') {
                        let html = '';
                        res.data.forEach(r => {
                            html += `<option value="${r.idRol}">${r.nombre}</option>`;
                        });
                        $('#selRol').html(html);
                    }
                }
            });
        }

        function loadUsers() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getUsuarios' },
                success: function(res) {
                    if (res.status === 'success') {
                        let html = '';
                        res.data.forEach(u => {
                            html += `<tr>
                                <td>${u.idUsuario}</td>
                                <td>${u.usuario}</td>
                                <td><span class="status-badge" style="background:#e9ecef; color:#495057;">${(u.rol || 'Sin Rol').toUpperCase()}</span></td>
                                <td><span class="status-badge ${u.activo ? 'status-active' : 'status-inactive'}">${u.activo ? 'Activo' : 'Inactivo'}</span></td>
                                <td>${u.fechaCreacion}</td>
                                <td>
                                    <button class="action-btn" title="Editar" onclick="editUser(${JSON.stringify(u).replace(/"/g, '&quot;')})">✏️</button>
                                    <button class="action-btn" title="Eliminar" onclick="deleteUser(${u.idUsuario})">🗑️</button>
                                </td>
                            </tr>`;
                        });
                        $('#tblUsuarios tbody').html(html);
                    }
                }
            });
        }

        function openModal() {
            $('#txtIdUsuario').val('0');
            $('#txtUsuario').val('');
            $('#txtPassword').val('');
            $('#selRol').val($('#selRol option:first').val());
            $('#selActivo').val('1');
            $('#modalTitle').text('Nuevo Usuario');
            $('#userModal').fadeIn();
        }

        function closeModal() {
            $('#userModal').fadeOut();
        }

        function editUser(u) {
            $('#txtIdUsuario').val(u.idUsuario);
            $('#txtUsuario').val(u.usuario);
            $('#txtPassword').val(''); // No mostrar password
            $('#selRol').val(u.idRol);
            $('#selActivo').val(u.activo ? '1' : '0');
            $('#modalTitle').text('Editar Usuario');
            $('#userModal').fadeIn();
        }

        function saveUser() {
            const data = {
                cmd: 'saveUsuario',
                idUsuario: $('#txtIdUsuario').val(),
                usuario: $('#txtUsuario').val(),
                password: $('#txtPassword').val(),
                idRol: $('#selRol').val(),
                activo: $('#selActivo').val()
            };
            
            if (!data.usuario) {
                Swal.fire('Atención', 'El nombre de usuario es obligatorio', 'warning');
                return;
            }

            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                type: 'POST',
                data: data,
                success: function(res) {
                    if (res.status === 'success') {
                        Swal.fire('¡Éxito!', res.message, 'success');
                        closeModal();
                        loadUsers();
                    } else {
                        Swal.fire('Error', res.message, 'error');
                    }
                }
            });
        }

        function deleteUser(id) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: "Esta acción no se puede deshacer",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#E63946',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '../Handlers/ProjectHandler.ashx',
                        data: { cmd: 'deleteUsuario', idUsuario: id },
                        success: function(res) {
                            if (res.status === 'success') {
                                Swal.fire('Eliminado', 'El usuario ha sido eliminado.', 'success');
                                loadUsers();
                            } else {
                                Swal.fire('Error', res.message, 'error');
                            }
                        }
                    });
                }
            });
        }
    </script>
</body>
</html>
