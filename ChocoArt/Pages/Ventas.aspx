<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Ventas.aspx.cs" Inherits="ChocoArt.Pages.Ventas" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Registro de Ventas</title>
    <link rel="stylesheet" href="../Content/styles.css">
    <style>
        .admin-body { background: var(--bg-light); min-height: 100vh; padding-top: 100px; }
        .data-card { background: white; padding: 2rem; border-radius: 20px; box-shadow: var(--shadow); margin-top: 2rem; }
        .table-controls { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th { text-align: left; padding: 1.2rem; background: #f8f9fa; border-bottom: 2px solid #eee; color: var(--primary); font-weight: 800; }
        td { padding: 1.2rem; border-bottom: 1px solid #eee; }
        .invoice-badge { background: #e2e3e5; padding: 0.3rem 0.6rem; border-radius: 5px; font-family: monospace; font-weight: 700; }
        
        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); overflow-y: auto; }
        .modal-content { background: white; margin: 5% auto; padding: 2.5rem; border-radius: 25px; width: 850px; box-shadow: var(--shadow); }
        .modal-header { margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; color: var(--primary); display: flex; justify-content: space-between; align-items: center; }
        
        .form-row { display: flex; gap: 1rem; margin-bottom: 1.5rem; align-items: flex-end; }
        .form-group { flex: 1; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; color: var(--text-dark); }
        .form-control { width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd; }
        
        .sale-table { margin-top: 1rem; max-height: 300px; overflow-y: auto; border: 1px solid #eee; border-radius: 10px; }
        .total-section { margin-top: 2rem; display: flex; justify-content: flex-end; gap: 3rem; background: #f8f9fa; padding: 1.5rem; border-radius: 15px; }
        .total-box { text-align: right; }
        .total-label { font-size: 0.9rem; color: var(--text-muted); display: block; }
        .total-value { font-size: 1.8rem; font-weight: 800; color: var(--primary); }
        .change-value { font-size: 1.8rem; font-weight: 800; color: #2a9d8f; }
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
            <h1>Registro de <span>Ventas</span></h1>
            <p>Monitorea las transacciones y la facturación de tu negocio.</p>
        </div>

        <div class="data-card reveal active">
            <div class="table-controls">
                <h3>Historial de Ventas</h3>
                <button class="btn btn-primary" onclick="openSaleModal()">+ Nueva Venta</button>
            </div>
            <table id="tblVentas">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Correlativo</th>
                        <th>Fecha</th>
                        <th>Cliente</th>
                        <th>Fecha Ingreso</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </main>

    <!-- Modal Nueva Venta -->
    <div id="saleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Registrar Nueva Venta</h3>
                <span style="font-weight: 700; color: var(--secondary);" id="lblFecha"></span>
            </div>
            
            <div class="form-row">
                <div class="form-group" style="flex: 2;">
                    <label>Seleccionar Cliente</label>
                    <select id="selCliente" class="form-control"></select>
                </div>
            </div>

            <hr style="margin: 1.5rem 0; border: none; border-top: 1px solid #eee;">
            
            <div class="form-row">
                <div class="form-group" style="flex: 2;">
                    <label>Producto</label>
                    <select id="selProducto" class="form-control" onchange="updateUnitPrice()"></select>
                </div>
                <div class="form-group">
                    <label>Precio</label>
                    <input type="number" id="txtPrecio" class="form-control" readonly>
                </div>
                <div class="form-group" style="flex: 0.5;">
                    <label>Cant.</label>
                    <input type="number" id="txtCantidad" class="form-control" value="1" min="1">
                </div>
                <button class="btn btn-secondary" onclick="addItem()" style="padding: 0.8rem 1.5rem;">Añadir</button>
            </div>

            <div class="sale-table">
                <table id="tblDetalle">
                    <thead>
                        <tr>
                            <th>Producto</th>
                            <th style="text-align: center;">Cant.</th>
                            <th style="text-align: right;">Precio</th>
                            <th style="text-align: right;">Subtotal</th>
                            <th style="text-align: center;"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Items dynamically added -->
                    </tbody>
                </table>
            </div>

            <div class="total-section">
                <div class="total-box">
                    <span class="total-label">Efectivo Recibido</span>
                    <input type="number" id="txtEfectivo" class="form-control" style="font-size: 1.2rem; text-align: right; width: 150px;" oninput="calculateChange()">
                </div>
                <div class="total-box">
                    <span class="total-label">Cambio</span>
                    <span class="change-value" id="lblCambio">Q 0.00</span>
                </div>
                <div class="total-box">
                    <span class="total-label">TOTAL A PAGAR</span>
                    <span class="total-value" id="lblTotal">Q 0.00</span>
                </div>
            </div>

            <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                <button class="btn btn-outline" onclick="closeSaleModal()" style="flex: 1;">Cancelar</button>
                <button class="btn btn-primary" onclick="processSale()" style="flex: 1; font-weight: 700;">PROCESAR VENTA</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        let saleItems = [];
        let allProducts = [];

        $(document).ready(function() { 
            loadVentas(); 
            $('#lblFecha').text(new Date().toLocaleDateString());
        });

        function loadVentas() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getVentas' },
                success: function(res) {
                    if (res.status === 'success') {
                        let html = '';
                        res.data.forEach(v => {
                            html += `<tr>
                                <td>${v.idVenta}</td>
                                <td><span class="invoice-badge">#${String(v.idVenta).padStart(5, '0')}</span></td>
                                <td>${v.fechaFactura ? new Date(v.fechaFactura).toLocaleDateString() : 'N/A'}</td>
                                <td style="font-weight: 600;">${v.cliente || 'Consumidor Final'}</td>
                                <td style="color: var(--text-muted); font-size: 0.85rem;">${v.fechaingreso}</td>
                            </tr>`;
                        });
                        $('#tblVentas tbody').html(html);
                    }
                }
            });
        }

        function openSaleModal() {
            saleItems = [];
            renderItems();
            loadFormData();
            $('#txtEfectivo').val('');
            $('#lblCambio').text('Q 0.00');
            $('#saleModal').fadeIn();
        }

        function closeSaleModal() {
            $('#saleModal').fadeOut();
        }

        function loadFormData() {
            // Load Customers
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getClientes' },
                success: function(res) {
                    if (res.status === 'success') {
                        let html = '<option value="">-- Seleccionar Cliente --</option>';
                        res.data.forEach(c => {
                            html += `<option value="${c.idCliente}">${c.nombres} ${c.apellidos} (NIT: ${c.NIT || 'C/F'})</option>`;
                        });
                        $('#selCliente').html(html);
                    }
                }
            });

            // Load Products
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getProductos' },
                success: function(res) {
                    if (res.status === 'success') {
                        allProducts = res.data;
                        let html = '<option value="">-- Seleccionar Producto --</option>';
                        res.data.forEach(p => {
                            html += `<option value="${p.idProducto}">${p.producto} (Stock: ${p.existencia})</option>`;
                        });
                        $('#selProducto').html(html);
                    }
                }
            });
        }

        function updateUnitPrice() {
            const id = $('#selProducto').val();
            const prod = allProducts.find(p => p.idProducto == id);
            if (prod) {
                $('#txtPrecio').val(prod.precio_venta);
            } else {
                $('#txtPrecio').val('');
            }
        }

        function addItem() {
            const id = $('#selProducto').val();
            const cant = parseInt($('#txtCantidad').val());
            const price = parseFloat($('#txtPrecio').val());
            
            if (!id || !cant || isNaN(price)) {
                return Swal.fire('Error', 'Selecciona un producto y cantidad válida', 'warning');
            }

            const prod = allProducts.find(p => p.idProducto == id);
            if (cant > prod.existencia) {
                return Swal.fire('Stock Insuficiente', `Solo hay ${prod.existencia} unidades disponibles`, 'warning');
            }

            // Check if already in list
            const existing = saleItems.find(i => i.idProducto == id);
            if (existing) {
                existing.cantidad += cant;
            } else {
                saleItems.push({
                    idProducto: id,
                    nombre: prod.producto,
                    cantidad: cant,
                    precio_unitario: price
                });
            }

            renderItems();
            // Reset inputs
            $('#selProducto').val('');
            $('#txtPrecio').val('');
            $('#txtCantidad').val('1');
        }

        function removeItem(idx) {
            saleItems.splice(idx, 1);
            renderItems();
        }

        function renderItems() {
            let html = '';
            let total = 0;
            saleItems.forEach((item, idx) => {
                const sub = item.cantidad * item.precio_unitario;
                total += sub;
                html += `<tr>
                    <td>${item.nombre}</td>
                    <td style="text-align: center;">${item.cantidad}</td>
                    <td style="text-align: right;">Q ${item.precio_unitario.toFixed(2)}</td>
                    <td style="text-align: right; font-weight: 700;">Q ${sub.toFixed(2)}</td>
                    <td style="text-align: center;">
                        <button class="action-btn" onclick="removeItem(${idx})">❌</button>
                    </td>
                </tr>`;
            });
            $('#tblDetalle tbody').html(html);
            $('#lblTotal').text(`Q ${total.toFixed(2)}`);
            calculateChange();
        }

        function calculateChange() {
            const total = parseFloat($('#lblTotal').text().replace('Q ', ''));
            const efectivo = parseFloat($('#txtEfectivo').val()) || 0;
            const cambio = efectivo - total;
            $('#lblCambio').text(`Q ${Math.max(0, cambio).toFixed(2)}`);
        }

        function processSale() {
            const idC = $('#selCliente').val();
            if (!idC) return Swal.fire('Atención', 'Debes seleccionar un cliente', 'warning');
            if (saleItems.length === 0) return Swal.fire('Atención', 'La venta no tiene productos', 'warning');

            const total = parseFloat($('#lblTotal').text().replace('Q ', ''));
            const efectivo = parseFloat($('#txtEfectivo').val()) || 0;
            if (efectivo < total) return Swal.fire('Atención', 'El efectivo es insuficiente', 'error');

            Swal.fire({
                title: '¿Confirmar Venta?',
                text: `Total: Q ${total.toFixed(2)}`,
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Sí, vender',
                cancelButtonText: 'Revisar'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '../Handlers/ProjectHandler.ashx',
                        type: 'POST',
                        data: {
                            cmd: 'saveVenta',
                            idCliente: idC,
                            items: JSON.stringify(saleItems)
                        },
                        success: function(res) {
                            if (res.status === 'success') {
                                Swal.fire('¡Venta Exitosa!', `Venta registrada: #${String(res.idVenta).padStart(5, '0')}`, 'success');
                                closeSaleModal();
                                loadVentas();
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
