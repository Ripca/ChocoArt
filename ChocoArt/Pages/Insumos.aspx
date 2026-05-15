<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Insumos.aspx.cs" Inherits="ChocoArt.Pages.Insumos" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Gestión de Insumos</title>
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
        .action-btn { background: none; border: none; font-size: 1.2rem; cursor: pointer; margin-right: 0.5rem; transition: var(--transition); }
        .action-btn:hover { transform: scale(1.2); }
        
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); overflow-y: auto; }
        .modal-content { background: white; margin: 1rem auto; padding: 2rem; border-radius: 25px; width: min(500px, 95%); box-shadow: var(--shadow); position: relative; }
        .modal-header { margin-bottom: 1.5rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; color: var(--primary); }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

        /* ====== RESPONSIVE ====== */
        @media (max-width: 768px) {
            .admin-body { padding-top: 75px; }
            .container { padding: 0 0.8rem; }
            .data-card { padding: 0.8rem; overflow-x: auto; -webkit-overflow-scrolling: touch; }
            table { font-size: 0.8rem; min-width: 500px; }
            th, td { padding: 0.6rem 0.5rem; }
            .table-controls { flex-direction: column; align-items: stretch; gap: 0.8rem; }
            .table-controls .btn { width: 100%; text-align: center; padding: 0.8rem 1rem; font-size: 0.95rem; }
            .modal-content { 
                width: 95% !important; 
                margin: 0.5rem auto !important; 
                padding: 1.2rem !important; 
                max-height: 90vh; 
                overflow-y: auto; 
            }
            .form-grid { grid-template-columns: 1fr; }
            .reveal h1 { font-size: 1.6rem; }
            .header-container { padding: 0 0.5rem; }
        }
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
            <h1>Materia <span>Prima</span> e Insumos</h1>
            <p>Controla los ingredientes (bananos, fresas, chocolate en gramos, cajas).</p>
        </div>

        <!-- Aviso eliminado por petición del usuario -->

        <div class="data-card reveal active">
            <div class="table-controls">
                <h3>Lista de Insumos</h3>
                <button class="btn btn-primary" onclick="openModal()">+ Nuevo Insumo</button>
            </div>
            <table id="tblInsumos">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Insumo</th>
                        <th>Unidad Compra</th>
                        <th>Unidad Receta</th>
                        <th>Rendimiento</th>
                        <th>Costo Receta</th>
                        <th>Existencia (Receta)</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </main>

    <!-- Modal Form -->
    <div id="insumoModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Nuevo Insumo</h3>
            </div>
            <input type="hidden" id="txtIdInsumo" value="0">
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Nombre del Insumo</label>
                <input type="text" id="txtNombre" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;" placeholder="Ej. Chocolate Oscuro, Banano, etc.">
            </div>
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.3rem; font-weight: 600; color: var(--primary);">1. ¿Cómo compras este insumo?</label>
                <input type="text" id="txtUnidadCompra" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;" placeholder="Ej. Bolsa, Caja, Galón, Libra">
            </div>
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.3rem; font-weight: 600; color: var(--primary);">2. ¿Cómo lo descuentas en tus recetas?</label>
                <input type="text" id="txtUnidadReceta" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;" placeholder="Ej. Unidad, Gramos, Onzas, Porción">
            </div>
            <div style="margin-bottom: 1rem; background: #f8f9fa; padding: 1rem; border-radius: 10px; border: 1px solid #eee;">
                <label style="display: block; margin-bottom: 0.3rem; font-weight: 600; color: var(--primary);">3. Rendimiento</label>
                <p style="font-size: 0.85em; color: #666; margin-top: 0; margin-bottom: 0.5rem;">¿Cuántas unidades de receta/consumo obtienes por cada unidad de compra?</p>
                <input type="number" step="0.01" id="txtRendimiento" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;" placeholder="Ej. 50">
            </div>

            <!-- Costo y Existencia internos, gestionados por Compras -->
            <input type="hidden" id="txtExistencia" value="0">
            <input type="hidden" id="txtCosto" value="0">
            <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                <button class="btn btn-outline" onclick="closeModal()" style="flex: 1;">Cancelar</button>
                <button class="btn btn-primary" onclick="saveInsumo()" style="flex: 1;">Guardar</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function() {
            loadInsumos();
        });

        function loadInsumos() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getInsumos' },
                success: function(res) {
                    if (res.status === 'success') {
                        let html = '';
                        res.data.forEach(p => {
                            html += `<tr>
                                <td>${p.idInsumo}</td>
                                <td style="font-weight: 600;">${p.nombre}</td>
                                <td><span style="background: var(--bg-light); padding: 0.3rem 0.6rem; border-radius: 10px; font-size: 0.85em;">${p.unidad_compra}</span></td>
                                <td><span style="background: var(--bg-light); padding: 0.3rem 0.6rem; border-radius: 10px; font-size: 0.85em;">${p.unidad_receta}</span></td>
                                <td>${p.rendimiento_por_compra}</td>
                                <td>Q${Number(p.costo_unitario).toFixed(2)}</td>
                                <td style="color: ${p.existencia > 10 ? 'var(--secondary)' : 'var(--primary)'}; font-weight: 800;">${p.existencia}</td>
                                <td>
                                    <button class="action-btn" title="Editar" onclick="editInsumo(${p.idInsumo}, '${p.nombre}', '${p.unidad_compra}', '${p.unidad_receta}', ${p.rendimiento_por_compra}, ${p.costo_unitario}, ${p.existencia})">✏️</button>
                                    <button class="action-btn" title="Eliminar" onclick="deleteInsumo(${p.idInsumo})">🗑️</button>
                                </td>
                            </tr>`;
                        });
                        $('#tblInsumos tbody').html(html);
                    }
                }
            });
        }

        function openModal() {
            $('#txtIdInsumo').val('0');
            $('#txtNombre').val('');
            $('#txtUnidadCompra').val('');
            $('#txtUnidadReceta').val('');
            $('#txtRendimiento').val('1');
            $('#txtCosto').val('0');
            $('#txtExistencia').val('0');
            $('#modalTitle').text('Nuevo Insumo');
            $('#insumoModal').fadeIn();
        }

        function closeModal() {
            $('#insumoModal').fadeOut();
        }

        function editInsumo(id, nombre, unidadC, unidadR, rend, costo, stock) {
            $('#txtIdInsumo').val(id);
            $('#txtNombre').val(nombre);
            $('#txtUnidadCompra').val(unidadC);
            $('#txtUnidadReceta').val(unidadR);
            $('#txtRendimiento').val(rend);
            $('#txtCosto').val(costo);
            $('#txtExistencia').val(stock);
            $('#modalTitle').text('Editar Insumo');
            $('#insumoModal').fadeIn();
        }

        function saveInsumo() {
            const data = {
                cmd: 'saveInsumo',
                idInsumo: $('#txtIdInsumo').val(),
                nombre: $('#txtNombre').val(),
                unidad_compra: $('#txtUnidadCompra').val(),
                unidad_receta: $('#txtUnidadReceta').val(),
                rendimiento_por_compra: $('#txtRendimiento').val() || 1,
                costo_unitario: $('#txtCosto').val() || 0,
                existencia: $('#txtExistencia').val() || 0
            };
            
            if (!data.nombre) {
                Swal.fire('Atención', 'El nombre es obligatorio', 'warning');
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
                        loadInsumos();
                    } else {
                        Swal.fire('Error', res.message, 'error');
                    }
                }
            });
        }

        function deleteInsumo(id) {
            Swal.fire({
                title: '¿Eliminar Insumo?',
                text: "Si este insumo está en alguna receta, podría causar errores.",
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
                        data: { cmd: 'deleteInsumo', idInsumo: id },
                        success: function(res) {
                            if (res.status === 'success') {
                                Swal.fire('Eliminado', res.message, 'success');
                                loadInsumos();
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
