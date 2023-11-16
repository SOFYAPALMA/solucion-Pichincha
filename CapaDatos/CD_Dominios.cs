using CapaModelo;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CapaDatos
{
    public class CD_Dominios
    {
        public static List<Dominio> Obtener(int TipoDominio)
        {
            List<Dominio> rptLista = new List<Dominio>();
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                SqlCommand cmd = new SqlCommand("select * from BPAPP.fntraevaloresdominio(" + TipoDominio + ")", oConexion);
                cmd.CommandType = CommandType.Text;

                try
                {
                    oConexion.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        rptLista.Add(new Dominio()
                        {
                            IdDominio = Convert.ToInt32(dr["Dominio"].ToString()),
                            Nombre = dr["Descripcion"].ToString(),
                        });
                    }
                    dr.Close();

                    return rptLista;

                }
                catch (Exception ex)
                {
                    rptLista = null;
                    return rptLista;
                }
            }
        }
    }
}
