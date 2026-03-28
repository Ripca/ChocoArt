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
        public static bool ValidateLogin(string user, string password)
        {
            string query = "SELECT COUNT(*) FROM usuarios WHERE usuario = @user AND password = @pass AND activo = 1";
            MySqlParameter[] p = {
                new MySqlParameter("@user", MySqlDbType.VarChar) { Value = user },
                new MySqlParameter("@pass", MySqlDbType.VarChar) { Value = password }
            };
            
            DataTable dt = ExecuteQuery(query, p);
            return dt.Rows.Count > 0 && Convert.ToInt32(dt.Rows[0][0]) > 0;
        }
    }
}
