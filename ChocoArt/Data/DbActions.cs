using System;
using System.Data;
using MySqlConnector;

namespace ChocoArt.Data
{
    public class DbActions
    {
        public static DataTable ExecuteQuery(string query, MySqlParameter[] parameters = null)
        {
            DataTable dt = new DataTable();
            using (MySqlConnection conn = CoreConnection.GetConnection())
            {
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        public static int ExecuteNonQuery(string query, MySqlParameter[] parameters = null)
        {
            int rowsAffected = 0;
            using (MySqlConnection conn = CoreConnection.GetConnection())
            {
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    rowsAffected = cmd.ExecuteNonQuery();
                }
            }
            return rowsAffected;
        }

        // Specific Actions
        public static DataTable GetLoginUser(string user, string password)
        {
            string query = @"SELECT u.idUsuario, u.usuario, r.nombre as rol 
                             FROM usuarios u
                             INNER JOIN usuario_rol ur ON u.idUsuario = ur.idUsuario
                             INNER JOIN roles r ON ur.idRol = r.idRol
                             WHERE u.usuario = @user AND u.password = @pass AND u.activo = 1 AND ur.estado = 1";
            MySqlParameter[] p = {
                new MySqlParameter("@user", MySqlDbType.VarChar) { Value = user },
                new MySqlParameter("@pass", MySqlDbType.VarChar) { Value = HashSHA1(password) }
            };

            return ExecuteQuery(query, p);
        }

        /// <summary>
        /// Convierte texto plano a SHA1 hexadecimal lowercase.
        /// Equivalente a MySQL's SHA1() — el usuario escribe normal, el sistema lo hashea antes de comparar.
        /// </summary>
        private static string HashSHA1(string input)
        {
            using (var sha1 = System.Security.Cryptography.SHA1.Create())
            {
                byte[] bytes = sha1.ComputeHash(System.Text.Encoding.UTF8.GetBytes(input));
                var sb = new System.Text.StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2")); // lowercase hex, igual que MySQL SHA1()
                return sb.ToString();
            }
        }
    }
}
