<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="ChocoArt.Pages.Productos" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Gestión de Productos</title>
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
                        <th>Stock</th>
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
                    <input type="number" step="0.01" id="txtCosto" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Precio Venta</label>
                    <input type="number" step="0.01" id="txtVenta" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                </div>
            </div>
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Existencia</label>
                <input type="number" id="txtExistencia" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
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
        $(document).ready(function() {
            loadProducts();
        });

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
                                <td style="font-weight: 600;">${p.existencia}</td>
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
            $('#txtVenta').val('');
            $('#txtExistencia').val('');
            $('#modalTitle').text('Nuevo Producto');
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
            $('#txtExistencia').val(p.existencia);
            $('#modalTitle').text('Editar Producto');
            $('#productModal').fadeIn();
        }

        function saveProduct() {
            const data = {
                cmd: 'saveProducto',
                idProducto: $('#txtIdProducto').val(),
                producto: $('#txtProducto').val(),
                descripcion: $('#txtDescripcion').val(),
                precio_costo: $('#txtCosto').val(),
                precio_venta: $('#txtVenta').val(),
                existencia: $('#txtExistencia').val()
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
