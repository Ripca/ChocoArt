<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="ChocoArt.Pages.Productos" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Gestión de Productos</title>
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
        
        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); overflow-y: auto; }
        .modal-content { background: white; margin: 1rem auto; padding: 2rem; border-radius: 25px; width: min(500px, 95%); box-shadow: var(--shadow); position: relative; }
        .modal-header { margin-bottom: 1.5rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; color: var(--primary); }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .recipe-section { margin-top: 1.5rem; border-top: 2px solid #eee; padding-top: 1rem; }
        .recipe-table { font-size: 0.9rem; margin-top: 0.5rem; }
        .recipe-table th, .recipe-table td { padding: 0.5rem; }
        .recipe-controls { display: flex; gap: 0.5rem; margin-top: 0.5rem; }

        /* ====== RESPONSIVE ====== */
        @media (max-width: 768px) {
            .admin-body { padding-top: 75px; }
            .container { padding: 0 0.8rem; }
            .data-card { padding: 0.8rem; overflow-x: auto; -webkit-overflow-scrolling: touch; }
            table { font-size: 0.8rem; min-width: 350px; }
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
            .recipe-controls { flex-wrap: wrap; }
            .recipe-controls select, .recipe-controls input { flex: 1 1 100%; }
            .recipe-controls .btn { width: 100%; }
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
            <h1>Catálogo de <span>Productos</span></h1>
            <p>Define tus creaciones, establece precios y controla el inventario.</p>
        </div>

        <div class="data-card reveal active">
            <div class="table-controls">
                <h3>Lista de Productos</h3>
                <button class="btn btn-primary" onclick="openModal()">+ Nuevo Producto</button>
            </div>
            <table id="tblProductos">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Producto</th>
                        <th>Costo</th>
                        <th>Venta</th>
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
    <div id="productModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Nuevo Producto</h3>
            </div>
            <input type="hidden" id="txtIdProducto" value="0">
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Nombre del Producto</label>
                <input type="text" id="txtProducto" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
            </div>
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Descripción</label>
                <textarea id="txtDescripcion" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd; height: 80px;"></textarea>
            </div>
            <div class="form-grid">
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Precio Costo</label>
                    <input type="number" step="0.01" id="txtCosto" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd; background: #e9ecef; cursor: not-allowed;" readonly placeholder="Auto-calculado">
                    <small style="color: #666; font-size: 0.8rem;">Se actualiza automáticamente al guardar su Receta.</small>
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Precio Venta (Q)</label>
                    <input type="number" step="0.01" id="txtVenta" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                </div>
            </div>

            <div class="recipe-section">
                <h4 style="color: var(--primary); margin-bottom: 0.5rem;">Composición (Receta)</h4>
                <div class="recipe-controls">
                    <select id="selInsumo" style="flex: 2; padding: 0.5rem; border-radius: 8px; border: 1px solid #ddd;">
                        <option value="">-- Seleccionar Insumo --</option>
                    </select>
                    <input type="number" id="txtCantInsumo" step="0.01" placeholder="Cant." style="flex: 1; padding: 0.5rem; border-radius: 8px; border: 1px solid #ddd;">
                    <button type="button" class="btn btn-primary" onclick="addInsumoRow()" style="padding: 0.5rem 1rem;">+</button>
                </div>
                <table class="recipe-table" id="tblRecipeEditor">
                    <thead>
                        <tr style="background: #f8f9fa;">
                            <th>Insumo</th>
                            <th>Cantidad</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Recipe rows here -->
                    </tbody>
                </table>
            </div>

            <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                <button class="btn btn-outline" onclick="closeModal()" style="flex: 1;">Cancelar</button>
                <button class="btn btn-primary" onclick="saveProduct()" style="flex: 1;">Guardar</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        let allInsumos = [];

        $(document).ready(function() {
            loadInsumos();
            loadProducts();
        });

        function loadInsumos() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getInsumos' },
                success: function(res) {
                    if (res.status === 'success') {
                        allInsumos = res.data;
                        let html = '<option value="">-- Seleccionar Insumo --</option>';
                        allInsumos.forEach(i => {
                            html += `<option value="${i.idInsumo}">${i.nombre} (${i.unidad_receta})</option>`;
                        });
                        $('#selInsumo').html(html);
                    }
                }
            });
        }

        function loadProducts() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getProductos' },
                success: function(res) {
                    if (res.status === 'success') {
                        let html = '';
                        res.data.forEach(p => {
                            html += `<tr>
                                <td>${p.idProducto}</td>
                                <td>${p.producto}</td>
                                <td>Q${p.precio_costo.toFixed(2)}</td>
                                <td style="color: var(--secondary); font-weight: 700;">Q${p.precio_venta.toFixed(2)}</td>
                                <td>
                                    <button class="action-btn" title="Editar" onclick="editProduct(${JSON.stringify(p).replace(/"/g, '&quot;')})">✏️</button>
                                    <button class="action-btn" title="Eliminar" onclick="deleteProduct(${p.idProducto})">🗑️</button>
                                </td>
                            </tr>`;
                        });
                        $('#tblProductos tbody').html(html);
                    }
                }
            });
        }

        function openModal() {
            $('#txtIdProducto').val('0');
            $('#txtProducto').val('');
            $('#txtDescripcion').val('');
            $('#txtCosto').val('');
            $('#txtVenta').val('8.00');
            $('#tblRecipeEditor tbody').empty();
            $('#modalTitle').text('Nuevo Producto');
            
            // Re-centrar modal si es necesario
            // Modal se adapta automáticamente vía CSS min()
            
            $('#productModal').fadeIn();
        }
        
        function closeModal() {
            $('#productModal').fadeOut();
        }

        function editProduct(p) {
            $('#txtIdProducto').val(p.idProducto);
            $('#txtProducto').val(p.producto);
            $('#txtDescripcion').val(p.descripcion);
            $('#txtCosto').val(p.precio_costo);
            $('#txtVenta').val(p.precio_venta);
            $('#modalTitle').text('Editar Producto');
            
            // Modal se adapta automáticamente vía CSS min()
            
            // Cargar Receta
            $('#tblRecipeEditor tbody').empty();
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getRecetas', idProducto: p.idProducto },
                success: function(res) {
                    if (res.status === 'success') {
                        res.data.forEach(r => {
                            addInsumoRow(r.idInsumo, r.cantidad);
                        });
                    }
                }
            });

            $('#productModal').fadeIn();
        }

        function addInsumoRow(id = null, cant = null) {
            const idI = id || $('#selInsumo').val();
            const cantidad = cant || $('#txtCantInsumo').val();

            if (!idI || !cantidad || cantidad <= 0) {
                if(!id) Swal.fire('Error', 'Seleccione un insumo y cantidad válida', 'error');
                return;
            }

            // Evitar duplicados en la tabla del editor
            let existe = false;
            $('#tblRecipeEditor tbody tr').each(function() {
                if ($(this).attr('data-id') == idI) existe = true;
            });

            if (existe && !id) {
                Swal.fire('Atención', 'Este insumo ya está en la lista', 'warning');
                return;
            }

            const insumoObj = allInsumos.find(i => i.idInsumo == idI);
            const nombre = insumoObj ? insumoObj.nombre : "Desconocido";

            const row = `<tr data-id="${idI}">
                <td>${nombre}</td>
                <td><input type="number" step="0.01" class="edit-cant" value="${cantidad}" style="width:70px; padding:2px; border:1px solid #ccc; border-radius:4px;"></td>
                <td><button type="button" class="action-btn" onclick="$(this).closest('tr').remove()">❌</button></td>
            </tr>`;

            $('#tblRecipeEditor tbody').append(row);
            
            if(!id) {
                $('#selInsumo').val('');
                $('#txtCantInsumo').val('');
            }
        }

        function saveProduct() {
            // Serializar Receta desde la tabla
            let receta = [];
            $('#tblRecipeEditor tbody tr').each(function() {
                receta.push({
                    idInsumo: parseInt($(this).attr('data-id')),
                    cantidad: parseFloat($(this).find('.edit-cant').val())
                });
            });

            const data = {
                cmd: 'saveProducto',
                idProducto: $('#txtIdProducto').val(),
                producto: $('#txtProducto').val(),
                descripcion: $('#txtDescripcion').val(),
                precio_venta: $('#txtVenta').val(),
                receta: JSON.stringify(receta)
            };
            
            if (!data.producto) {
                Swal.fire('Atención', 'El nombre del producto es obligatorio', 'warning');
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
                        loadProducts();
                    } else {
                        Swal.fire('Error', res.message, 'error');
                    }
                }
            });
        }

        function deleteProduct(id) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: "Esta acción eliminará el producto del catálogo",
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
                        data: { cmd: 'deleteProducto', idProducto: id },
                        success: function(res) {
                            if (res.status === 'success') {
                                Swal.fire('Eliminado', 'El producto ha sido eliminado.', 'success');
                                loadProducts();
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
