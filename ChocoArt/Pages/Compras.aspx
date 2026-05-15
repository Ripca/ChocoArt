<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Compras.aspx.cs" Inherits="ChocoArt.Pages.Compras" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Compras de Insumos</title>
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
        
        .purchase-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 2rem; align-items: start; }
        .add-item-form { background: #f8f9fa; padding: 1.5rem; border-radius: 15px; border: 1px solid #eee; }
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
            <h1>Ingreso de <span>Compras</span></h1>
            <p>Registra las facturas de materia prima para aumentar el inventario de insumos.</p>
        </div>

        <div class="purchase-grid reveal active">
            <!-- Formulario para agregar insumo -->
            <div class="add-item-form">
                <h3 style="margin-bottom: 1rem; font-size: 1.2rem;">Detalles de la Factura</h3>
                
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">No. Orden / Factura</label>
                    <input type="text" id="txtNoOrden" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;" placeholder="Opcional">
                </div>
                
                <hr style="border: 0; border-top: 1px solid #ddd; margin: 1.5rem 0;">

                <h3 style="margin-bottom: 1rem; font-size: 1.2rem;">Agregar Insumo</h3>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Insumo</label>
                    <select id="cmbInsumos" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                        <option value="">Cargando...</option>
                    </select>
                </div>
                <div style="display: flex; gap: 1rem; margin-bottom: 1rem;">
                    <div style="flex: 1;">
                        <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Cantidad</label>
                        <input type="number" step="0.01" id="txtCantidad" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                    </div>
                    <div style="flex: 1;">
                        <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Costo Unit. (Q)</label>
                        <input type="number" step="0.01" id="txtCosto" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                    </div>
                </div>
                <button class="btn btn-outline" style="width: 100%;" onclick="agregarAlCarrito()">Agregar a la Lista</button>
            </div>

            <!-- Lista de compras -->
            <div class="data-card" style="margin-top: 0;">
                <h3 style="margin-bottom: 1rem;">Artículos en la Orden</h3>
                <table id="tblCarrito">
                    <thead>
                        <tr>
                            <th>Insumo</th>
                            <th>Cantidad</th>
                            <th>Precio Unit.</th>
                            <th>Subtotal</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td colspan="5" style="text-align: center; color: #999;">No hay artículos agregados.</td></tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" style="text-align: right; font-weight: bold; padding-top: 1rem;">Gran Total:</td>
                            <td colspan="2" style="font-weight: bold; color: var(--secondary); font-size: 1.2rem; padding-top: 1rem;" id="lblGranTotal">Q0.00</td>
                        </tr>
                    </tfoot>
                </table>

                <div style="text-align: right; margin-top: 2rem;">
                    <button class="btn btn-primary" style="padding: 1rem 3rem; font-size: 1.1rem;" onclick="procesarCompra()">Procesar Ingreso al Inventario</button>
                </div>
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        let carrito = [];
        let insumosCatalogo = [];

        $(document).ready(function() {
            loadInsumos();
        });

        function loadInsumos() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getInsumos' },
                success: function(res) {
                    if (res.status === 'success') {
                        insumosCatalogo = res.data;
                        let html = '<option value="">Seleccione Insumo...</option>';
                        res.data.forEach(i => {
                            html += `<option value="${i.idInsumo}">${i.nombre} (por ${i.unidad_compra}, rinde ${i.rendimiento_por_compra} ${i.unidad_receta})</option>`;
                        });
                        $('#cmbInsumos').html(html);
                    }
                }
            });
        }

        $('#cmbInsumos').change(function() {
            let selectedId = $(this).val();
            let insumo = insumosCatalogo.find(x => x.idInsumo == selectedId);
            if(insumo) {
                $('#txtCosto').val((insumo.costo_unitario * insumo.rendimiento_por_compra).toFixed(2));
                $('#txtCantidad').val(''); // clear to force user input
                $('#txtCantidad').focus();
            }
        });

        function agregarAlCarrito() {
            const idInsumo = $('#cmbInsumos').val();
            const textInsumo = $('#cmbInsumos option:selected').text();
            const cantidad = parseFloat($('#txtCantidad').val());
            const precio = parseFloat($('#txtCosto').val());

            if (!idInsumo || !cantidad || cantidad <= 0 || isNaN(precio) || precio < 0) {
                Swal.fire('Atención', 'Datos de insumo inválidos', 'warning');
                return;
            }

            carrito.push({
                idInsumo: idInsumo,
                nombre: textInsumo,
                cantidad: cantidad,
                precio: precio
            });

            renderCarrito();
            
            $('#cmbInsumos').val('');
            $('#txtCantidad').val('');
            $('#txtCosto').val('');
        }

        function removeFromCarrito(index) {
            carrito.splice(index, 1);
            renderCarrito();
        }

        function renderCarrito() {
            if (carrito.length === 0) {
                $('#tblCarrito tbody').html('<tr><td colspan="5" style="text-align: center; color: #999;">No hay artículos agregados.</td></tr>');
                $('#lblGranTotal').text('Q0.00');
                return;
            }

            let html = '';
            let total = 0;
            carrito.forEach((item, index) => {
                let subtotal = item.cantidad * item.precio;
                total += subtotal;
                html += `<tr>
                    <td style="font-weight: 600;">${item.nombre}</td>
                    <td>${item.cantidad}</td>
                    <td>Q${item.precio.toFixed(2)}</td>
                    <td>Q${subtotal.toFixed(2)}</td>
                    <td>
                        <button class="action-btn" title="Quitar" onclick="removeFromCarrito(${index})">🗑️</button>
                    </td>
                </tr>`;
            });

            $('#tblCarrito tbody').html(html);
            $('#lblGranTotal').text('Q' + total.toFixed(2));
        }

        function procesarCompra() {
            if (carrito.length === 0) {
                Swal.fire('Atención', 'No hay insumos para ingresar', 'warning');
                return;
            }

            const noOrden = $('#txtNoOrden').val();

            Swal.fire({
                title: '¿Confirmar Ingreso?',
                text: "Se aumentará el inventario de estos insumos.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#2a9d8f',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, registrar'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '../Handlers/ProjectHandler.ashx',
                        type: 'POST',
                        data: {
                            cmd: 'saveCompra',
                            no_orden_compra: noOrden,
                            fecha_orden: new Date().toISOString().split('T')[0],
                            items: JSON.stringify(carrito)
                        },
                        success: function(res) {
                            if (res.status === 'success') {
                                Swal.fire('Completado', res.message, 'success');
                                carrito = [];
                                renderCarrito();
                                $('#txtNoOrden').val('');
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
