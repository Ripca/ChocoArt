<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Clientes.aspx.cs" Inherits="ChocoArt.Pages.Clientes" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Gestión de Clientes</title>
    <link rel="stylesheet" href="../Content/styles.css">
    <style>
        .admin-body { background: var(--bg-light); min-height: 100vh; padding-top: 100px; }
        .data-card { background: white; padding: 2rem; border-radius: 20px; box-shadow: var(--shadow); margin-top: 2rem; }
        .table-controls { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th { text-align: left; padding: 1.2rem; background: #f8f9fa; border-bottom: 2px solid #eee; color: var(--primary); font-weight: 800; }
        td { padding: 1.2rem; border-bottom: 1px solid #eee; }
        .action-btn { background: none; border: none; font-size: 1.2rem; cursor: pointer; margin-right: 0.5rem; transition: var(--transition); }
        .action-btn:hover { transform: scale(1.2); }
        
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
        .modal-content { background: white; margin: 5% auto; padding: 2.5rem; border-radius: 25px; width: 500px; box-shadow: var(--shadow); }
        .modal-header { margin-bottom: 1.5rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; color: var(--primary); }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
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
            <h1>Cartera de <span>Clientes</span></h1>
            <p>Mantén un registro detallado de tus clientes y sus preferencias.</p>
        </div>

        <div class="data-card reveal active">
            <div class="table-controls">
                <h3>Lista de Clientes</h3>
                <button class="btn btn-primary" onclick="openModal()">+ Nuevo Cliente</button>
            </div>
            <table id="tblClientes">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre Completo</th>
                        <th>NIT</th>
                        <th>Teléfono</th>
                        <th>Género</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </main>

    <div id="clienteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h3 id="modalTitle">Nuevo Cliente</h3></div>
            <input type="hidden" id="txtIdCliente" value="0">
            <div class="form-grid">
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Nombres</label>
                    <input type="text" id="txtNombres" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Apellidos</label>
                    <input type="text" id="txtApellidos" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                </div>
            </div>
            <div class="form-grid">
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">NIT</label>
                    <input type="text" id="txtNIT" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Teléfono</label>
                    <input type="text" id="txtTelefono" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                </div>
            </div>
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Género</label>
                <select id="selGenero" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                    <option value="1">Masculino</option>
                    <option value="0">Femenino</option>
                </select>
            </div>
            <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                <button class="btn btn-outline" onclick="closeModal()" style="flex: 1;">Cancelar</button>
                <button class="btn btn-primary" onclick="saveCliente()" style="flex: 1;">Guardar</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function() { loadClientes(); });

        function loadClientes() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getClientes' },
                success: function(res) {
                    if (res.status === 'success') {
                        let html = '';
                        res.data.forEach(c => {
                            html += `<tr>
                                <td>${c.idCliente}</td>
                                <td>${c.nombres} ${c.apellidos}</td>
                                <td>${c.NIT || 'C/F'}</td>
                                <td>${c.telefono || 'N/A'}</td>
                                <td>${c.genero ? 'M' : 'F'}</td>
                                <td>
                                    <button class="action-btn" title="Editar" onclick='editCliente(${JSON.stringify(c).replace(/'/g, "&apos;")})'>✏️</button>
                                    <button class="action-btn" title="Eliminar" onclick="deleteCliente(${c.idCliente})">🗑️</button>
                                </td>
                            </tr>`;
                        });
                        $('#tblClientes tbody').html(html);
                    }
                }
            });
        }

        function openModal() {
            $('#txtIdCliente').val('0');
            $('#txtNombres').val(''); $('#txtApellidos').val('');
            $('#txtNIT').val(''); $('#txtTelefono').val('');
            $('#selGenero').val('1');
            $('#modalTitle').text('Nuevo Cliente');
            $('#clienteModal').fadeIn();
        }

        function closeModal() { $('#clienteModal').fadeOut(); }

        function editCliente(c) {
            $('#txtIdCliente').val(c.idCliente);
            $('#txtNombres').val(c.nombres); $('#txtApellidos').val(c.apellidos);
            $('#txtNIT').val(c.NIT); $('#txtTelefono').val(c.telefono);
            $('#selGenero').val(c.genero ? '1' : '0');
            $('#modalTitle').text('Editar Cliente');
            $('#clienteModal').fadeIn();
        }

        function saveCliente() {
            const data = {
                cmd: 'saveCliente',
                idCliente: $('#txtIdCliente').val(),
                nombres: $('#txtNombres').val(),
                apellidos: $('#txtApellidos').val(),
                nit: $('#txtNIT').val(),
                genero: $('#selGenero').val(),
                telefono: $('#txtTelefono').val()
            };
            
            if (!data.nombres || !data.apellidos) {
                Swal.fire('Atención', 'Nombre y Apellido son obligatorios', 'warning');
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
                        loadClientes(); 
                    } else {
                        Swal.fire('Error', res.message, 'error');
                    }
                }
            });
        }

        function deleteCliente(id) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: "Esta acción eliminará al cliente de la cartera",
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
                        data: { cmd: 'deleteCliente', idCliente: id },
                        success: function(res) { 
                            if (res.status === 'success') {
                                Swal.fire('Eliminado', 'El cliente ha sido eliminado.', 'success');
                                loadClientes(); 
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
