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

        private void HandleLogin(HttpContext context)
        {
            string user = context.Request["user"];
            string pass = context.Request["pass"];
            
            bool isValid = DbActions.ValidateLogin(user, pass);
            if (isValid)
            {
                context.Session["Usuario"] = user;
                context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Login correcto" }));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = "Usuario o contraseña incorrectos" }));
            }
        }

        private void HandleGetUsuarios(HttpContext context)
        {
            DataTable dt = DbActions.ExecuteQuery("SELECT idUsuario, usuario, activo, fechaCreacion FROM usuarios");
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleGetProductos(HttpContext context)
        {
            DataTable dt = DbActions.ExecuteQuery("SELECT * FROM productos");
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", data = dt }));
        }

        private void HandleSaveUsuario(HttpContext context)
        {
            string id = context.Request["idUsuario"];
            string user = context.Request["usuario"];
            string pass = context.Request["password"];
            string activo = context.Request["activo"]; // "1" or "0"

            string query = "";
            MySqlParameter[] p;

            if (string.IsNullOrEmpty(id) || id == "0")
            {
                query = "INSERT INTO usuarios (usuario, password, activo) VALUES (@user, @pass, @active)";
                p = new MySqlParameter[] {
                    new MySqlParameter("@user", user),
                    new MySqlParameter("@pass", pass),
                    new MySqlParameter("@active", activo == "1" ? (object)1 : (object)0)
                };
            }
            else
            {
                query = "UPDATE usuarios SET usuario = @user, password = @pass, activo = @active WHERE idUsuario = @id";
                p = new MySqlParameter[] {
                    new MySqlParameter("@user", user),
                    new MySqlParameter("@pass", pass),
                    new MySqlParameter("@active", activo == "1" ? (object)1 : (object)0),
                    new MySqlParameter("@id", id)
                };
            }

            int rows = DbActions.ExecuteNonQuery(query, p);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Usuario guardado correctamente" }));
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
            string costo = context.Request["precio_costo"];
            string venta = context.Request["precio_venta"];
            string stock = context.Request["existencia"];

            string query = "";
            MySqlParameter[] p;

            if (string.IsNullOrEmpty(id) || id == "0")
            {
                query = "INSERT INTO productos (producto, descripcion, precio_costo, precio_venta, existencia) VALUES (@nombre, @desc, @costo, @venta, @stock)";
                p = new MySqlParameter[] {
                    new MySqlParameter("@nombre", nombre),
                    new MySqlParameter("@desc", desc),
                    new MySqlParameter("@costo", Convert.ToDecimal(costo)),
                    new MySqlParameter("@venta", Convert.ToDecimal(venta)),
                    new MySqlParameter("@stock", Convert.ToInt32(stock))
                };
            }
            else
            {
                query = "UPDATE productos SET producto = @nombre, descripcion = @desc, precio_costo = @costo, precio_venta = @venta, existencia = @stock WHERE idProducto = @id";
                p = new MySqlParameter[] {
                    new MySqlParameter("@nombre", nombre),
                    new MySqlParameter("@desc", desc),
                    new MySqlParameter("@costo", Convert.ToDecimal(costo)),
                    new MySqlParameter("@venta", Convert.ToDecimal(venta)),
                    new MySqlParameter("@stock", Convert.ToInt32(stock)),
                    new MySqlParameter("@id", id)
                };
            }

            DbActions.ExecuteNonQuery(query, p);
            context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Producto guardado correctamente" }));
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
            string query = @"SELECT v.idVenta, v.noFactura, v.serie, v.fechaFactura, 
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

            using (var conn = CoreConnection.GetConnection())
            {
                using (var trans = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Insertar Venta Header
                        string queryVenta = "INSERT INTO ventas (noFactura, serie, fechaFactura, idCliente) VALUES (@no, @serie, @fecha, @idC); SELECT LAST_INSERT_ID();";
                        int noFactura = new Random().Next(1000, 9999); // Simulación de correlativo
                        MySqlCommand cmdVenta = new MySqlCommand(queryVenta, conn, trans);
                        cmdVenta.Parameters.AddWithValue("@no", noFactura);
                        cmdVenta.Parameters.AddWithValue("@serie", "A");
                        cmdVenta.Parameters.AddWithValue("@fecha", DateTime.Now);
                        cmdVenta.Parameters.AddWithValue("@idC", idCliente);
                        
                        int idVenta = Convert.ToInt32(cmdVenta.ExecuteScalar());

                        // 2. Insertar Detalles y Actualizar Stock
                        foreach (var item in items)
                        {
                            string queryDetalle = "INSERT INTO ventas_detalle (idVenta, idProducto, cantidad, precio_unitario) VALUES (@idV, @idP, @cant, @prec)";
                            MySqlCommand cmdDetalle = new MySqlCommand(queryDetalle, conn, trans);
                            cmdDetalle.Parameters.AddWithValue("@idV", idVenta);
                            cmdDetalle.Parameters.AddWithValue("@idP", item.idProducto);
                            cmdDetalle.Parameters.AddWithValue("@cant", item.cantidad);
                            cmdDetalle.Parameters.AddWithValue("@prec", item.precio_unitario);
                            cmdDetalle.ExecuteNonQuery();

                            // Actualizar Existencia
                            string queryStock = "UPDATE productos SET existencia = existencia - @cant WHERE idProducto = @idP";
                            MySqlCommand cmdStock = new MySqlCommand(queryStock, conn, trans);
                            cmdStock.Parameters.AddWithValue("@cant", item.cantidad);
                            cmdStock.Parameters.AddWithValue("@idP", item.idProducto);
                            cmdStock.ExecuteNonQuery();
                        }

                        trans.Commit();
                        context.Response.Write(JsonConvert.SerializeObject(new { status = "success", message = "Venta procesada con éxito", noFactura = noFactura }));
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        throw ex;
                    }
                }
            }
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
