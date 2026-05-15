using System;
using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using Newtonsoft.Json;
using ChocoArt.Data;
using System.Data;
using MySqlConnector;

namespace ChocoArt.Handlers
{
    public class ProjectHandler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string cmd = context.Request["cmd"];
            
            try
            {
                switch (cmd)
                {
                    case "login":
                        HandleLogin(context);
                        break;
                    case "getSession":
                        HandleGetSession(context);
                        break;
                    case "getUsuarios":
                        HandleGetUsuarios(context);
                        break;
                    case "getProductos":
                        HandleGetProductos(context);
                        break;
                    case "saveUsuario":
                        HandleSaveUsuario(context);
                        break;
                    case "deleteUsuario":
                        HandleDeleteUsuario(context);
                        break;
                    case "saveProducto":
                        HandleSaveProducto(context);
                        break;
                    case "deleteProducto":
                        HandleDeleteProducto(context);
                        break;
                    case "getClientes":
                        HandleGetClientes(context);
                        break;
                    case "saveCliente":
                        HandleSaveCliente(context);
                        break;
                    case "deleteCliente":
                        HandleDeleteCliente(context);
                        break;
                    case "getVentas":
                        HandleGetVentas(context);
                        break;
                    case "saveVenta":
                        HandleSaveVenta(context);
                        break;
                    case "getInsumos": HandleGetInsumos(context); break;
                    case "saveInsumo": HandleSaveInsumo(context); break;
                    case "deleteInsumo": HandleDeleteInsumo(context); break;
                    case "getRecetas": HandleGetRecetas(context); break;
                    case "saveReceta": HandleSaveReceta(context); break;
                    case "deleteReceta": HandleDeleteReceta(context); break;
                    case "saveRecetaBatch": HandleSaveRecetaBatch(context); break;
                    case "getProductosParaVenta": HandleGetProductosParaVenta(context); break;
                    case "getRoles": HandleGetRoles(context); break;
                    case "getMenus": HandleGetMenus(context); break;
                    case "getCompras": HandleGetCompras(context); break;
                    case "saveCompra": HandleSaveCompra(context); break;
                    default:
                        context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = "Comando desconocido" }));
                        break;
                }
            }
            catch (Exception ex)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = ex.Message }));
            }
        }

        private void HandleGetSession(HttpContext context)
        {
            if (context.Session["Usuario"] != null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { 
                    status = "success", 
                    usuario = context.Session["Usuario"].ToString(), 
                    rol = context.Session["Rol"] != null ? context.Session["Rol"].ToString() : "admin" 
                }));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = "No session" }));
            }
        }

        private void HandleLogin(HttpContext context)
        {
            string user = context.Request["user"];
            string pass = context.Request["pass"];
            
            DataTable dtUser = DbActions.GetLoginUser(user, pass);
            if (dtUser.Rows.Count > 0)
            {
                context.Session["Usuario"] = dtUser.Rows[0]["usuario"].ToString();
                context.Session["Rol"] = dtUser.Rows[0]["rol"].ToString();
                context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Login correcto" }));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = "Usuario o contraseña incorrectos" }));
            }
        }

        private void HandleGetUsuarios(HttpContext context)
        {
            DataTable dt = DbActions.ExecuteQuery(@"SELECT u.idUsuario, u.usuario, r.nombre as rol, u.activo, u.fechaCreacion, r.idRol
                                                  FROM usuarios u
                                                  LEFT JOIN usuario_rol ur ON u.idUsuario = ur.idUsuario AND ur.estado = 1
                                                  LEFT JOIN roles r ON ur.idRol = r.idRol");
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleGetProductos(HttpContext context)
        {
            DataTable dt = DbActions.ExecuteQuery("SELECT * FROM productos");
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleGetProductosParaVenta(HttpContext context)
        {
            string query = @"SELECT 
                                p.idProducto, 
                                p.producto, 
                                p.precio_venta, 
                                0 as existencia_base,
                                (SELECT IFNULL(MIN(FLOOR(i.existencia / r.cantidad)), 0) 
                                 FROM recetas r 
                                 INNER JOIN insumos i ON r.idInsumo = i.idInsumo 
                                 WHERE r.idProducto = p.idProducto) as maxFabricable,
                                (SELECT COUNT(*) FROM recetas r WHERE r.idProducto = p.idProducto) as tieneReceta
                             FROM productos p";
            DataTable dt = DbActions.ExecuteQuery(query);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleSaveUsuario(HttpContext context)
        {
            string id = context.Request["idUsuario"];
            string user = context.Request["usuario"];
            string pass = context.Request["password"];
            string idRol = context.Request["idRol"];
            string activo = context.Request["activo"]; // "1" or "0"

            using (var conn = CoreConnection.GetConnection())
            {
                using (var trans = conn.BeginTransaction())
                {
                    try
                    {
                        int idUsuarioFinal;
                        if (string.IsNullOrEmpty(id) || id == "0")
                        {
                            string query = "INSERT INTO usuarios (usuario, password, activo) VALUES (@user, @pass, @active); SELECT LAST_INSERT_ID();";
                            MySqlCommand cmdUser = new MySqlCommand(query, conn, trans);
                            cmdUser.Parameters.AddWithValue("@user", user);
                            cmdUser.Parameters.AddWithValue("@pass", pass);
                            cmdUser.Parameters.AddWithValue("@active", activo == "1" ? 1 : 0);
                            idUsuarioFinal = Convert.ToInt32(cmdUser.ExecuteScalar());
                        }
                        else
                        {
                            idUsuarioFinal = Convert.ToInt32(id);
                            string query = "UPDATE usuarios SET usuario = @user, activo = @active" + (!string.IsNullOrEmpty(pass) ? ", password = @pass" : "") + " WHERE idUsuario = @id";
                            MySqlCommand cmdUpdate = new MySqlCommand(query, conn, trans);
                            cmdUpdate.Parameters.AddWithValue("@user", user);
                            cmdUpdate.Parameters.AddWithValue("@active", activo == "1" ? 1 : 0);
                            cmdUpdate.Parameters.AddWithValue("@id", idUsuarioFinal);
                            if (!string.IsNullOrEmpty(pass)) cmdUpdate.Parameters.AddWithValue("@pass", pass);
                            cmdUpdate.ExecuteNonQuery();

                            // Desactivar roles anteriores
                            string queryDeactivate = "UPDATE usuario_rol SET estado = 0 WHERE idUsuario = @idU";
                            MySqlCommand cmdDeactivate = new MySqlCommand(queryDeactivate, conn, trans);
                            cmdDeactivate.Parameters.AddWithValue("@idU", idUsuarioFinal);
                            cmdDeactivate.ExecuteNonQuery();
                        }

                        // Asignar Rol
                        string queryRol = "INSERT INTO usuario_rol (idUsuario, idRol, estado) VALUES (@idU, @idR, 1)";
                        MySqlCommand cmdRol = new MySqlCommand(queryRol, conn, trans);
                        cmdRol.Parameters.AddWithValue("@idU", idUsuarioFinal);
                        cmdRol.Parameters.AddWithValue("@idR", idRol);
                        cmdRol.ExecuteNonQuery();

                        trans.Commit();
                        context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Usuario y Rol guardados correctamente" }));
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        throw ex;
                    }
                }
            }
        }

        private void HandleGetRoles(HttpContext context)
        {
            DataTable dt = DbActions.ExecuteQuery("SELECT * FROM roles WHERE estado = 1");
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleGetMenus(HttpContext context)
        {
            string rolName = context.Session["Rol"]?.ToString()?.Trim();
            if (string.IsNullOrEmpty(rolName))
            {
                context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = "No session or role found" }));
                return;
            }

            string query = @"SELECT DISTINCT m.* 
                             FROM menus m
                             INNER JOIN rol_menu rm ON m.id_menu = rm.idMenu
                             INNER JOIN roles r ON rm.idRol = r.idRol
                             WHERE UPPER(TRIM(r.nombre)) = UPPER(@rol) 
                               AND m.estado = 1 
                               AND rm.estado = 1
                             ORDER BY m.orden ASC";
            
            DataTable dt = DbActions.ExecuteQuery(query, new MySqlParameter[] { new MySqlParameter("@rol", rolName) });
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleDeleteUsuario(HttpContext context)
        {
            string id = context.Request["idUsuario"];
            string query = "DELETE FROM usuarios WHERE idUsuario = @id";
            MySqlParameter[] p = { new MySqlParameter("@id", id) };
            
            DbActions.ExecuteNonQuery(query, p);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Usuario eliminado correctamente" }));
        }

        private void HandleSaveProducto(HttpContext context)
        {
            string id = context.Request["idProducto"];
            string nombre = context.Request["producto"];
            string desc = context.Request["descripcion"];
            string venta = context.Request["precio_venta"];
            string recetaJson = context.Request["receta"]; // JSON Array de {idInsumo, cantidad}

            var recetaItems = string.IsNullOrEmpty(recetaJson) ? new List<RecetaBatchTemp>() : JsonConvert.DeserializeObject<List<RecetaBatchTemp>>(recetaJson);

            using (var conn = CoreConnection.GetConnection())
            {
                using (var trans = conn.BeginTransaction())
                {
                    try
                    {
                        int idProductoFinal;
                        if (string.IsNullOrEmpty(id) || id == "0")
                        {
                            string query = "INSERT INTO productos (producto, descripcion, precio_venta) VALUES (@nombre, @desc, @venta); SELECT LAST_INSERT_ID();";
                            MySqlCommand cmdProd = new MySqlCommand(query, conn, trans);
                            cmdProd.Parameters.AddWithValue("@nombre", nombre);
                            cmdProd.Parameters.AddWithValue("@desc", desc);
                            cmdProd.Parameters.AddWithValue("@venta", Convert.ToDecimal(venta));
                            idProductoFinal = Convert.ToInt32(cmdProd.ExecuteScalar());
                        }
                        else
                        {
                            idProductoFinal = Convert.ToInt32(id);
                            string query = "UPDATE productos SET producto = @nombre, descripcion = @desc, precio_venta = @venta WHERE idProducto = @id";
                            MySqlCommand cmdProd = new MySqlCommand(query, conn, trans);
                            cmdProd.Parameters.AddWithValue("@nombre", nombre);
                            cmdProd.Parameters.AddWithValue("@desc", desc);
                            cmdProd.Parameters.AddWithValue("@venta", Convert.ToDecimal(venta));
                            cmdProd.Parameters.AddWithValue("@id", idProductoFinal);
                            cmdProd.ExecuteNonQuery();
                        }

                        // 2. Gestionar Receta
                        string delReceta = "DELETE FROM recetas WHERE idProducto = @idP";
                        MySqlCommand cmdDel = new MySqlCommand(delReceta, conn, trans);
                        cmdDel.Parameters.AddWithValue("@idP", idProductoFinal);
                        cmdDel.ExecuteNonQuery();

                        foreach (var item in recetaItems)
                        {
                            string insReceta = "INSERT INTO recetas (idProducto, idInsumo, cantidad) VALUES (@idP, @idI, @cant)";
                            MySqlCommand cmdIns = new MySqlCommand(insReceta, conn, trans);
                            cmdIns.Parameters.AddWithValue("@idP", idProductoFinal);
                            cmdIns.Parameters.AddWithValue("@idI", item.idInsumo);
                            cmdIns.Parameters.AddWithValue("@cant", item.cantidad);
                            cmdIns.ExecuteNonQuery();
                        }

                        // 3. Recalcular Costo
                        string queryCostoTotal = @"
                            SELECT IFNULL(SUM(r.cantidad * i.costo_unitario), 0)
                            FROM recetas r
                            INNER JOIN insumos i ON r.idInsumo = i.idInsumo
                            WHERE r.idProducto = @idP";
                        MySqlCommand cmdCosto = new MySqlCommand(queryCostoTotal, conn, trans);
                        cmdCosto.Parameters.AddWithValue("@idP", idProductoFinal);
                        decimal costoTotal = Convert.ToDecimal(cmdCosto.ExecuteScalar());

                        string updateProdCosto = "UPDATE productos SET precio_costo = @ctot WHERE idProducto = @idP";
                        MySqlCommand cmdUpdateProd = new MySqlCommand(updateProdCosto, conn, trans);
                        cmdUpdateProd.Parameters.AddWithValue("@ctot", Math.Round(costoTotal, 2));
                        cmdUpdateProd.Parameters.AddWithValue("@idP", idProductoFinal);
                        cmdUpdateProd.ExecuteNonQuery();

                        trans.Commit();
                        context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Producto y Receta guardados. Costo calculado: Q" + Math.Round(costoTotal, 2) }));
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        throw ex;
                    }
                }
            }
        }

        private void HandleDeleteProducto(HttpContext context)
        {
            string id = context.Request["idProducto"];
            string query = "DELETE FROM productos WHERE idProducto = @id";
            MySqlParameter[] p = { new MySqlParameter("@id", id) };
            
            DbActions.ExecuteNonQuery(query, p);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Producto eliminado correctamente" }));
        }

        private void HandleGetClientes(HttpContext context)
        {
            DataTable dt = DbActions.ExecuteQuery("SELECT * FROM clientes");
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleSaveCliente(HttpContext context)
        {
            string id = context.Request["idCliente"];
            string noms = context.Request["nombres"];
            string apes = context.Request["apellidos"];
            string nit = context.Request["nit"];
            string gen = context.Request["genero"];
            string tel = context.Request["telefono"];

            string query = "";
            MySqlParameter[] p;

            if (string.IsNullOrEmpty(id) || id == "0")
            {
                query = "INSERT INTO clientes (nombres, apellidos, NIT, genero, telefono) VALUES (@noms, @apes, @nit, @gen, @tel)";
                p = new MySqlParameter[] {
                    new MySqlParameter("@noms", noms),
                    new MySqlParameter("@apes", apes),
                    new MySqlParameter("@nit", nit),
                    new MySqlParameter("@gen", gen == "1" ? (object)1 : (object)0),
                    new MySqlParameter("@tel", tel)
                };
            }
            else
            {
                query = "UPDATE clientes SET nombres = @noms, apellidos = @apes, NIT = @nit, genero = @gen, telefono = @tel WHERE idCliente = @id";
                p = new MySqlParameter[] {
                    new MySqlParameter("@noms", noms),
                    new MySqlParameter("@apes", apes),
                    new MySqlParameter("@nit", nit),
                    new MySqlParameter("@gen", gen == "1" ? (object)1 : (object)0),
                    new MySqlParameter("@tel", tel),
                    new MySqlParameter("@id", id)
                };
            }

            DbActions.ExecuteNonQuery(query, p);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Cliente guardado correctamente" }));
        }

        private void HandleDeleteCliente(HttpContext context)
        {
            string id = context.Request["idCliente"];
            string query = "DELETE FROM clientes WHERE idCliente = @id";
            MySqlParameter[] p = { new MySqlParameter("@id", id) };
            
            DbActions.ExecuteNonQuery(query, p);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Cliente eliminado correctamente" }));
        }

        private void HandleGetVentas(HttpContext context)
        {
            string query = @"SELECT v.idVenta, v.fechaFactura, 
                             CONCAT(c.nombres, ' ', c.apellidos) as cliente, v.fechaingreso 
                             FROM ventas v 
                             LEFT JOIN clientes c ON v.idCliente = c.idCliente";
            DataTable dt = DbActions.ExecuteQuery(query);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleSaveVenta(HttpContext context)
        {
            string idCliente = context.Request["idCliente"];
            string itemsJson = context.Request["items"];
            
            var items = JsonConvert.DeserializeObject<List<VentaDetalleTemp>>(itemsJson);

            // VERIFICACIÓN INTEGRAL DE INSUMOS
            Dictionary<int, decimal> requiredInsumos = new Dictionary<int, decimal>();
            foreach(var item in items)
            {
                DataTable dtReceta = DbActions.ExecuteQuery("SELECT idInsumo, cantidad FROM recetas WHERE idProducto = " + item.idProducto);
                foreach(DataRow row in dtReceta.Rows)
                {
                    int idInsumo = Convert.ToInt32(row["idInsumo"]);
                    decimal needed = Convert.ToDecimal(row["cantidad"]) * item.cantidad;
                    if(requiredInsumos.ContainsKey(idInsumo)) requiredInsumos[idInsumo] += needed;
                    else requiredInsumos[idInsumo] = needed;
                }
            }

            foreach(var kvp in requiredInsumos)
            {
                DataTable dtInsumo = DbActions.ExecuteQuery("SELECT nombre, existencia FROM insumos WHERE idInsumo = " + kvp.Key);
                if(dtInsumo.Rows.Count > 0)
                {
                    decimal available = Convert.ToDecimal(dtInsumo.Rows[0]["existencia"]);
                    if(available < kvp.Value)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = $"No hay suficiente '{dtInsumo.Rows[0]["nombre"]}' (Sugerido/Requerido: {kvp.Value}, Stock: {available}). Deteniendo venta." }));
                        return;
                    }
                }
            }

            using (var conn = CoreConnection.GetConnection())
            {
                using (var trans = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Insertar Venta Header
                        string queryVenta = "INSERT INTO ventas (fechaFactura, idCliente) VALUES (@fecha, @idC); SELECT LAST_INSERT_ID();";
                        MySqlCommand cmdVenta = new MySqlCommand(queryVenta, conn, trans);
                        cmdVenta.Parameters.AddWithValue("@fecha", DateTime.Now);
                        cmdVenta.Parameters.AddWithValue("@idC", idCliente);
                        
                        int idVenta = Convert.ToInt32(cmdVenta.ExecuteScalar());

                        // 2. Insertar Detalles y Descontar!
                        foreach (var item in items)
                        {
                            string queryDetalle = "INSERT INTO ventas_detalle (idVenta, idProducto, cantidad, precio_unitario) VALUES (@idV, @idP, @cant, @prec)";
                            MySqlCommand cmdDetalle = new MySqlCommand(queryDetalle, conn, trans);
                            cmdDetalle.Parameters.AddWithValue("@idV", idVenta);
                            cmdDetalle.Parameters.AddWithValue("@idP", item.idProducto);
                            cmdDetalle.Parameters.AddWithValue("@cant", item.cantidad);
                            cmdDetalle.Parameters.AddWithValue("@prec", item.precio_unitario);
                            cmdDetalle.ExecuteNonQuery();

                            // Descontar INSUMOS basándose en la Receta
                            string getRecetaQuery = "SELECT idInsumo, cantidad FROM recetas WHERE idProducto = @idP2";
                            MySqlCommand cmdReceta = new MySqlCommand(getRecetaQuery, conn, trans);
                            cmdReceta.Parameters.AddWithValue("@idP2", item.idProducto);
                            
                            List<Tuple<int, decimal>> recetaList = new List<Tuple<int, decimal>>();
                            using (var reader = cmdReceta.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    recetaList.Add(new Tuple<int, decimal>(Convert.ToInt32(reader["idInsumo"]), Convert.ToDecimal(reader["cantidad"])));
                                }
                            }

                            foreach(var r in recetaList)
                            {
                                decimal descontar = r.Item2 * item.cantidad;
                                string queryStock = "UPDATE insumos SET existencia = existencia - @desc WHERE idInsumo = @idI";
                                MySqlCommand cmdStock = new MySqlCommand(queryStock, conn, trans);
                                cmdStock.Parameters.AddWithValue("@desc", descontar);
                                cmdStock.Parameters.AddWithValue("@idI", r.Item1);
                                cmdStock.ExecuteNonQuery();
                            }
                            
                        }

                        trans.Commit();
                        context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Venta procesada con éxito y materia prima descontada", idVenta = idVenta }));
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        throw ex;
                    }
                }
            }
        }

        private void HandleGetInsumos(HttpContext context)
        {
            DataTable dt = DbActions.ExecuteQuery("SELECT * FROM insumos");
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleSaveInsumo(HttpContext context)
        {
            string id = context.Request["idInsumo"];
            string nombre = context.Request["nombre"];
            string unidadCompra = context.Request["unidad_compra"];
            string unidadReceta = context.Request["unidad_receta"];
            string rendimiento = context.Request["rendimiento_por_compra"];
            string costo = context.Request["costo_unitario"];
            string stock = context.Request["existencia"];

            string queryCheck = "SELECT 1 FROM insumos WHERE nombre = @nombre AND idInsumo != @id";
            DataTable dtCheck = DbActions.ExecuteQuery(queryCheck, new MySqlParameter[] { 
                new MySqlParameter("@nombre", nombre),
                new MySqlParameter("@id", string.IsNullOrEmpty(id) ? "0" : id)
            });

            if (dtCheck.Rows.Count > 0)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = "Ya existe un insumo con este nombre." }));
                return;
            }

            string query;
            MySqlParameter[] p;

            if (string.IsNullOrEmpty(id) || id == "0")
            {
                query = "INSERT INTO insumos (nombre, unidad_compra, unidad_receta, rendimiento_por_compra, costo_unitario, existencia) VALUES (@nombre, @unidadC, @unidadR, @rend, @costo, @stock)";
                p = new MySqlParameter[] {
                    new MySqlParameter("@nombre", nombre),
                    new MySqlParameter("@unidadC", unidadCompra),
                    new MySqlParameter("@unidadR", unidadReceta),
                    new MySqlParameter("@rend", Convert.ToDecimal(rendimiento)),
                    new MySqlParameter("@costo", Convert.ToDecimal(costo)),
                    new MySqlParameter("@stock", Convert.ToDecimal(stock))
                };
            }
            else
            {
                query = "UPDATE insumos SET nombre = @nombre, unidad_compra = @unidadC, unidad_receta = @unidadR, rendimiento_por_compra = @rend, costo_unitario = @costo, existencia = @stock WHERE idInsumo = @id";
                p = new MySqlParameter[] {
                    new MySqlParameter("@nombre", nombre),
                    new MySqlParameter("@unidadC", unidadCompra),
                    new MySqlParameter("@unidadR", unidadReceta),
                    new MySqlParameter("@rend", Convert.ToDecimal(rendimiento)),
                    new MySqlParameter("@costo", Convert.ToDecimal(costo)),
                    new MySqlParameter("@stock", Convert.ToDecimal(stock)),
                    new MySqlParameter("@id", id)
                };
            }

            DbActions.ExecuteNonQuery(query, p);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Insumo guardado correctamente" }));
        }

        private void HandleDeleteInsumo(HttpContext context)
        {
            try {
                string id = context.Request["idInsumo"];
                string query = "DELETE FROM insumos WHERE idInsumo = @id";
                MySqlParameter[] p = { new MySqlParameter("@id", id) };
                DbActions.ExecuteNonQuery(query, p);
                context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Insumo eliminado correctamente" }));
            } catch (Exception ex) {
                context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = "No se puede eliminar insumo porque está siendo utilizado en compras o recetas." }));
            }
        }

        private void HandleGetRecetas(HttpContext context)
        {
            string id = context.Request["idProducto"];
            string query = @"SELECT r.idReceta, r.idProducto, r.idInsumo, r.cantidad, i.nombre, i.unidad_receta as unidad_medida, i.costo_unitario 
                             FROM recetas r 
                             INNER JOIN insumos i ON r.idInsumo = i.idInsumo 
                             WHERE r.idProducto = @id";
            DataTable dt = DbActions.ExecuteQuery(query, new MySqlParameter[] { new MySqlParameter("@id", id) });
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleSaveReceta(HttpContext context)
        {
            string idP = context.Request["idProducto"];
            string idI = context.Request["idInsumo"];
            string cant = context.Request["cantidad"];

            string queryCheck = "SELECT idReceta FROM recetas WHERE idProducto = @idP AND idInsumo = @idI";
            DataTable dt = DbActions.ExecuteQuery(queryCheck, new MySqlParameter[] { new MySqlParameter("@idP", idP), new MySqlParameter("@idI", idI) });

            if(dt.Rows.Count > 0) {
                 string query = "UPDATE recetas SET cantidad = @cant WHERE idProducto = @idP AND idInsumo = @idI";
                 DbActions.ExecuteNonQuery(query, new MySqlParameter[] { new MySqlParameter("@cant", Convert.ToDecimal(cant)), new MySqlParameter("@idP", idP), new MySqlParameter("@idI", idI) });
            } else {
                 string query = "INSERT INTO recetas (idProducto, idInsumo, cantidad) VALUES (@idP, @idI, @cant)";
                 DbActions.ExecuteNonQuery(query, new MySqlParameter[] { new MySqlParameter("@idP", idP), new MySqlParameter("@idI", idI), new MySqlParameter("@cant", Convert.ToDecimal(cant)) });
            }
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Insumo añadido a la receta" }));
        }

        private void HandleDeleteReceta(HttpContext context)
        {
            string id = context.Request["idReceta"];
            string query = "DELETE FROM recetas WHERE idReceta = @id";
            DbActions.ExecuteNonQuery(query, new MySqlParameter[] { new MySqlParameter("@id", id) });
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Insumo retirado de la receta" }));
        }

        private void HandleSaveRecetaBatch(HttpContext context)
        {
            string idP = context.Request["idProducto"];
            string itemsJson = context.Request["items"];
            
            var items = JsonConvert.DeserializeObject<List<RecetaBatchTemp>>(itemsJson);

            using (var conn = CoreConnection.GetConnection())
            {
                using (var trans = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Borrar toda la receta antigua
                        string delQuery = "DELETE FROM recetas WHERE idProducto = @id";
                        MySqlCommand cmdDel = new MySqlCommand(delQuery, conn, trans);
                        cmdDel.Parameters.AddWithValue("@id", idP);
                        cmdDel.ExecuteNonQuery();

                        // 2. Insertar los nuevos items
                        foreach (var item in items)
                        {
                            string insQuery = "INSERT INTO recetas (idProducto, idInsumo, cantidad) VALUES (@idP, @idI, @cant)";
                            MySqlCommand cmdIns = new MySqlCommand(insQuery, conn, trans);
                            cmdIns.Parameters.AddWithValue("@idP", idP);
                            cmdIns.Parameters.AddWithValue("@idI", item.idInsumo);
                            cmdIns.Parameters.AddWithValue("@cant", item.cantidad);
                            cmdIns.ExecuteNonQuery();
                        }

                        // 3. Auto-Actualizar el Precio Costo del Producto basado en la Fórmula Recién Creada
                        string queryCostoTotal = @"
                            SELECT IFNULL(SUM(r.cantidad * i.costo_unitario), 0)
                            FROM recetas r
                            INNER JOIN insumos i ON r.idInsumo = i.idInsumo
                            WHERE r.idProducto = @idP";
                        MySqlCommand cmdCosto = new MySqlCommand(queryCostoTotal, conn, trans);
                        cmdCosto.Parameters.AddWithValue("@idP", idP);
                        decimal costoTotal = Convert.ToDecimal(cmdCosto.ExecuteScalar());

                        string updateProdCosto = "UPDATE productos SET precio_costo = @ctot WHERE idProducto = @idP";
                        MySqlCommand cmdUpdateProd = new MySqlCommand(updateProdCosto, conn, trans);
                        cmdUpdateProd.Parameters.AddWithValue("@ctot", Math.Round(costoTotal, 2));
                        cmdUpdateProd.Parameters.AddWithValue("@idP", idP);
                        cmdUpdateProd.ExecuteNonQuery();

                        trans.Commit();
                        context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Receta guardada. El costo de fabricación (" + Math.Round(costoTotal, 2) + ") se reflejó en el producto." }));
                    }
                    catch(Exception ex)
                    {
                        trans.Rollback();
                        throw ex;
                    }
                }
            }
        }

        private class RecetaBatchTemp
        {
            public int idInsumo { get; set; }
            public decimal cantidad { get; set; }
        }

        private void HandleGetCompras(HttpContext context)
        {
            string query = @"SELECT c.idCompra, c.no_orden_compra, DATE_FORMAT(c.fecha_orden, '%Y-%m-%d') as fecha_orden, c.fechaingreso, 
                             IFNULL(SUM(d.cantidad * d.precio_costo_unitario), 0) as total
                             FROM compras c 
                             LEFT JOIN compras_detalle d ON c.idCompra = d.idCompra
                             GROUP BY c.idCompra";
            DataTable dt = DbActions.ExecuteQuery(query);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleSaveCompra(HttpContext context)
        {
            string noOrden = context.Request["no_orden_compra"];
            string fechaOrden = context.Request["fecha_orden"];
            string itemsJson = context.Request["items"];
            
            var items = JsonConvert.DeserializeObject<List<CompraDetalleTemp>>(itemsJson);

            using (var conn = CoreConnection.GetConnection())
            {
                using (var trans = conn.BeginTransaction())
                {
                    try
                    {
                        string queryCompra = "INSERT INTO compras (no_orden_compra, fecha_orden) VALUES (@no, @f); SELECT LAST_INSERT_ID();";
                        MySqlCommand cmdCompra = new MySqlCommand(queryCompra, conn, trans);
                        cmdCompra.Parameters.AddWithValue("@no", string.IsNullOrEmpty(noOrden) ? (object)DBNull.Value : Convert.ToInt32(noOrden));
                        cmdCompra.Parameters.AddWithValue("@f", string.IsNullOrEmpty(fechaOrden) ? DateTime.Now : Convert.ToDateTime(fechaOrden));
                        
                        int idCompra = Convert.ToInt32(cmdCompra.ExecuteScalar());

                        foreach (var item in items)
                        {
                            string queryDetalle = "INSERT INTO compras_detalle (idCompra, idInsumo, cantidad, precio_costo_unitario) VALUES (@idC, @idI, @cant, @prec)";
                            MySqlCommand cmdDetalle = new MySqlCommand(queryDetalle, conn, trans);
                            cmdDetalle.Parameters.AddWithValue("@idC", idCompra);
                            cmdDetalle.Parameters.AddWithValue("@idI", item.idInsumo);
                            cmdDetalle.Parameters.AddWithValue("@cant", item.cantidad);
                            cmdDetalle.Parameters.AddWithValue("@prec", item.precio);
                            cmdDetalle.ExecuteNonQuery();

                            // Calcular Costo Promedio Ponderado y Actualizar Stock
                            string getKardex = "SELECT existencia, costo_unitario, rendimiento_por_compra FROM insumos WHERE idInsumo = @idI FOR UPDATE";
                            MySqlCommand cmdKardex = new MySqlCommand(getKardex, conn, trans);
                            cmdKardex.Parameters.AddWithValue("@idI", item.idInsumo);
                            decimal oldExist = 0;
                            decimal oldCosto = 0;
                            decimal rendimiento = 1;
                            using (var reader = cmdKardex.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    oldExist = Convert.ToDecimal(reader["existencia"]);
                                    oldCosto = Convert.ToDecimal(reader["costo_unitario"]);
                                    rendimiento = Convert.ToDecimal(reader["rendimiento_por_compra"]);
                                }
                            }

                            decimal totalValueAntiguo = oldExist * oldCosto;
                            decimal totalValueNuevo = item.cantidad * item.precio;
                            decimal cantidadRecetaIngresada = item.cantidad * rendimiento;
                            decimal newExist = oldExist + cantidadRecetaIngresada;
                            decimal newCosto = newExist > 0 ? (totalValueAntiguo + totalValueNuevo) / newExist : 0;

                            string queryStock = "UPDATE insumos SET existencia = @newE, costo_unitario = @newC WHERE idInsumo = @idI2";
                            MySqlCommand cmdStock = new MySqlCommand(queryStock, conn, trans);
                            cmdStock.Parameters.AddWithValue("@newE", Math.Round(newExist, 2));
                            cmdStock.Parameters.AddWithValue("@newC", Math.Round(newCosto, 2));
                            cmdStock.Parameters.AddWithValue("@idI2", item.idInsumo);
                            cmdStock.ExecuteNonQuery();
                        }
                        trans.Commit();
                        context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Compra registrada con éxito", idCompra = idCompra }));
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        throw ex;
                    }
                }
            }
        }

        private class CompraDetalleTemp
        {
            public int idInsumo { get; set; }
            public decimal cantidad { get; set; }
            public decimal precio { get; set; }
        }

        private class VentaDetalleTemp
        {
            public int idProducto { get; set; }
            public int cantidad { get; set; }
            public decimal precio_unitario { get; set; }
        }

        public bool IsReusable => false;
    }
}
