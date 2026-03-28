using System;
using System.Data;
using MySqlConnector;

namespace ChocoArt.Data
{
    public class CoreConnection
    {
        private static string connectionString = "Server=localhost;Port=3306;Database=chocoartdb;Uid=root;Pwd=admin;";

        public static MySqlConnection GetConnection()
        {
            try
            {
                MySqlConnection conn = new MySqlConnection(connectionString);
                conn.Open();
                return conn;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al conectar a la base de datos: " + ex.Message);
            }
        }

        public static void CloseConnection(MySqlConnection conn)
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }
        }
    }
}
