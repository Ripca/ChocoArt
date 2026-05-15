<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Recetas.aspx.cs" Inherits="ChocoArt.Pages.Recetas" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChocoArt | Fórmulas y Recetas</title>
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
        
        .product-selector { background: white; padding: 1.5rem; border-radius: 15px; box-shadow: var(--shadow); margin-bottom: 1rem; display: flex; gap: 1rem; align-items: center; }
        .recipe-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 2rem; align-items: start; }
        .add-insumo-form { background: #f8f9fa; padding: 1.5rem; border-radius: 15px; border: 1px solid #eee; }
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
            <h1>Fórmulas y <span>Recetas</span></h1>
            <p>Define los insumos necesarios para fabricar cada producto final.</p>
        </div>

        <div class="product-selector reveal active">
            <h3 style="margin: 0; color: var(--primary);">1. Selecciona un Producto:</h3>
            <select id="cmbProductos" style="flex: 1; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;" onchange="loadReceta()">
                <option value="">Seleccione...</option>
            </select>
        </div>

        <div class="recipe-grid reveal active" id="recipeArea" style="display: none;">
            <div class="add-insumo-form">
                <h3 style="margin-bottom: 1rem; font-size: 1.2rem;">Añadir Insumo a la Receta</h3>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Insumo</label>
                    <select id="cmbInsumos" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;">
                        <option value="">Seleccione...</option>
                    </select>
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.3rem; font-weight: 600;">Cantidad requerida</label>
                    <input type="number" step="0.01" id="txtCantidad" style="width: 100%; padding: 0.8rem; border-radius: 10px; border: 1px solid #ddd;" placeholder="Ej. 1, 80, 0.5">
                    <small style="color: #666;">Basado en la unidad de medida del insumo.</small>
                </div>
                <button class="btn btn-outline" style="width: 100%;" onclick="addInsumoToTemp()">Agregar Insumo</button>
            </div>

            <div class="data-card" style="margin-top: 0;">
                <h3 style="margin-bottom: 0.5rem;" id="lblProductoActual">Composición</h3>
                <p style="color: #666; margin-bottom: 1rem;">La lista actual en pantalla. Usa el botón abajo para guardar.</p>
                <table id="tblReceta">
                    <thead>
                        <tr>
                            <th>Insumo</th>
                            <th>Cantidad</th>
                            <th>Costo Ref.</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="2" style="text-align: right; font-weight: bold;">Costo Total Estimado de Fab.:</td>
                            <td colspan="2" style="font-weight: bold; color: var(--secondary);" id="lblCostoTotal">Q0.00</td>
                        </tr>
                    </tfoot>
                </table>
                
                <div style="text-align: right; margin-top: 2rem;">
                    <button class="btn btn-primary" style="padding: 1rem 3rem; font-size: 1.1rem; width: 100%;" onclick="confirmarReceta()"> Aceptar y Guardar Receta Completa</button>
                </div>
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        let insumosCatalogo = [];
        let tempReceta = [];

        $(document).ready(function() {
            loadCatalogos();
        });

        function loadCatalogos() {
            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getProductos' },
                success: function(res) {
                    if (res.status === 'success') {
                        let html = '<option value="">Seleccione un Producto...</option>';
                        res.data.forEach(p => {
                            html += `<option value="${p.idProducto}">${p.producto} (Q${p.precio_venta})</option>`;
                        });
                        $('#cmbProductos').html(html);
                    }
                }
            });

            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getInsumos' },
                success: function(res) {
                    if (res.status === 'success') {
                        insumosCatalogo = res.data;
                        let html = '<option value="">Seleccione Insumo...</option>';
                        res.data.forEach(i => {
                            html += `<option value="${i.idInsumo}">${i.nombre} (por ${i.unidad_receta})</option>`;
                        });
                        $('#cmbInsumos').html(html);
                    }
                }
            });
        }

        function loadReceta() {
            const idProd = $('#cmbProductos').val();
            const textProd = $('#cmbProductos option:selected').text();
            
            if(!idProd) {
                $('#recipeArea').fadeOut();
                return;
            }

            $('#lblProductoActual').text('Composición: ' + textProd.split('(')[0]);
            $('#recipeArea').fadeIn();

            $.ajax({
                url: '../Handlers/ProjectHandler.ashx',
                data: { cmd: 'getRecetas', idProducto: idProd },
                success: function(res) {
                    if (res.status === 'success') {
                        tempReceta = [];
                        res.data.forEach(r => {
                            tempReceta.push({
                                idInsumo: r.idInsumo,
                                nombre: r.nombre,
                                unidad_medida: r.unidad_medida,
                                cantidad: r.cantidad,
                                costo_unitario: r.costo_unitario
                            });
                        });
                        renderReceta();
                    }
                }
            });
        }

        function renderReceta() {
            let html = '';
            let currentCostTotal = 0;

            if(tempReceta.length === 0) {
                html = '<tr><td colspan="4" style="text-align:center; color:#999;">Esta fórmula está vacía. Añade insumos.</td></tr>';
            } else {
                tempReceta.forEach((r, index) => {
                    const costoIngrediente = r.cantidad * r.costo_unitario;
                    currentCostTotal += costoIngrediente;
                    html += `<tr>
                        <td style="font-weight: 600;">${r.nombre}</td>
                        <td>${parseFloat(r.cantidad)} <span style="font-size: 0.85em; color: #666;">${r.unidad_medida}</span></td>
                        <td>Q${costoIngrediente.toFixed(2)}</td>
                        <td>
                            <button class="action-btn" title="Quitar" onclick="removeTempInsumo(${index})">🗑️</button>
                        </td>
                    </tr>`;
                });
            }
            $('#tblReceta tbody').html(html);
            $('#lblCostoTotal').text('Q' + currentCostTotal.toFixed(2));
        }

        function addInsumoToTemp() {
            const idInsumo = $('#cmbInsumos').val();
            const cant = parseFloat($('#txtCantidad').val());

            if(!idInsumo || isNaN(cant) || cant <= 0) {
                Swal.fire('Atención', 'Selecciona un insumo y asegúrate de colocar una cantidad válida', 'warning');
                return;
            }

            // Verify if exists already
            let exists = tempReceta.find(x => x.idInsumo == idInsumo);
            if(exists) {
                exists.cantidad += cant;
            } else {
                let insumoInfo = insumosCatalogo.find(x => x.idInsumo == idInsumo);
                tempReceta.push({
                    idInsumo: parseInt(idInsumo),
                    nombre: insumoInfo.nombre,
                    unidad_medida: insumoInfo.unidad_receta,
                    cantidad: cant,
                    costo_unitario: parseFloat(insumoInfo.costo_unitario)
                });
            }

            $('#txtCantidad').val('');
            $('#cmbInsumos').val('');
            renderReceta();
        }

        function removeTempInsumo(index) {
            Swal.fire({
                title: '¿Quitar insumo?',
                text: "Se retirará de la lista en pantalla.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#E63946',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, quitar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    tempReceta.splice(index, 1);
                    renderReceta();
                }
            });
        }

        function confirmarReceta() {
            const idProd = $('#cmbProductos').val();
            if(!idProd) return;

            // Optional: prevent empty recipes if they don't want them, but let's allow it in case they want to clear it.
            
            Swal.fire({
                title: 'Guardar Fórmula',
                text: "¿Estás seguro de establecer estos insumos como la receta de este producto?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#2a9d8f',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, confirmar y guardar',
                cancelButtonText: 'Seguir editando'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Send entire array
                    const simplifed = tempReceta.map(x => { return { idInsumo: x.idInsumo, cantidad: x.cantidad }; });

                    $.ajax({
                        url: '../Handlers/ProjectHandler.ashx',
                        type: 'POST',
                        data: {
                            cmd: 'saveRecetaBatch',
                            idProducto: idProd,
                            items: JSON.stringify(simplifed)
                        },
                        success: function(res) {
                            if (res.status === 'success') {
                                Swal.fire('¡Excelente!', res.message, 'success');
                                $('#cmbProductos').val('');
                                $('#recipeArea').fadeOut();
                                tempReceta = [];
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
