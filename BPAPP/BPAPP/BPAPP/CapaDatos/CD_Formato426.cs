using CapaModelo;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaDatos
{
    public class CD_Formato426
    {
        public static List<Formato426> Listar()
        {
            List<Formato426> rptListaDocente = new List<Formato426>();
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                SqlCommand cmd = new SqlCommand("bpapp.spConsultaPropiedadesCredito", oConexion);
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    oConexion.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        rptListaDocente.Add(new Formato426()
                        {
                            idPropiedadesFormato = Convert.ToInt32(dr["idPropiedadesFormato"].ToString()),
                            Tipo = Convert.ToInt32(dr["Tipo"].ToString()),
                            Codigo = dr["Codigo"].ToString(),
                            Nombre = dr["Nombre"].ToString(),
                            idCodigoCredito = Convert.ToInt32(dr["idCodigoCredito"].ToString()),
                            idAperturaDigital = Convert.ToInt32(dr["idAperturaDigital"].ToString()),
                            Fecha_horaActualizacion = Convert.ToDateTime(dr["Fecha_horaActualizacion"].ToString()),
                            Usuario = dr["Usuario"].ToString(),
                            CodigoRegistro = dr["CodigoRegistro"].ToString(),

                        });
                    }
                    dr.Close();

                    return rptListaDocente;

                }
                catch (Exception ex)
                {
                    rptListaDocente = null;
                    return rptListaDocente;
                }
            }
        }


        public static bool Registrar(Formato426 oFormato426)
        {
            bool respuesta = true;
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("bpapp.spInsertaPropiedadesCreditos", oConexion);
                    cmd.Parameters.AddWithValue("Tipo", oFormato426.Tipo);
                    cmd.Parameters.AddWithValue("Codigo", oFormato426.Codigo);
                    cmd.Parameters.AddWithValue("Nombre", oFormato426.Nombre);
                    cmd.Parameters.AddWithValue("Fecha_horaActualizacion", oFormato426.Fecha_horaActualizacion);
                    cmd.Parameters.AddWithValue("idCodigoCredito", oFormato426.idCodigoCredito);
                    cmd.Parameters.AddWithValue("idAperturaDigital", oFormato426.idAperturaDigital);
                    cmd.Parameters.Add("IndicadorTermina", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oConexion.Open();

                    cmd.ExecuteNonQuery();

                    respuesta = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);

                }
                catch (Exception ex)
                {
                    respuesta = false;
                }

            }

            return respuesta;

        }

        public static bool RegistrarDetalle(Formato426 oFormato426)
        {
            bool respuesta = true;
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("bpapp.spInsertaDetalleCreditos", oConexion);
                    cmd.Parameters.AddWithValue("Tipo", oFormato426.Tipo);
                    cmd.Parameters.AddWithValue("Codigo", oFormato426.Codigo);
                    cmd.Parameters.AddWithValue("Nombre", oFormato426.Nombre);
                    cmd.Parameters.AddWithValue("Fecha_horaActualizacion", oFormato426.Fecha_horaActualizacion);
                    cmd.Parameters.AddWithValue("idCodigoCredito", oFormato426.idCodigoCredito);
                    cmd.Parameters.AddWithValue("idAperturaDigital", oFormato426.idAperturaDigital);
                    cmd.Parameters.Add("IndicadorTermina", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oConexion.Open();

                    cmd.ExecuteNonQuery();

                    respuesta = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);

                }
                catch (Exception ex)
                {
                    respuesta = false;
                }

            }

            return respuesta;

        }


        public static bool Editar(Formato426 oFormato426)
        {
            bool respuesta = true;
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("bpapp.spActualizaPropiedadesCreditos", oConexion);
                    cmd.Parameters.AddWithValue("idPropiedadesFormato", oFormato426.idPropiedadesFormato);
                    cmd.Parameters.AddWithValue("Tipo", oFormato426.Tipo);
                    cmd.Parameters.AddWithValue("Codigo", oFormato426.Codigo);
                    cmd.Parameters.AddWithValue("Nombre", oFormato426.Nombre);
                    cmd.Parameters.AddWithValue("idCodigoCredito", oFormato426.idCodigoCredito);
                    cmd.Parameters.AddWithValue("idAperturaDigital", oFormato426.idAperturaDigital);
                    cmd.Parameters.AddWithValue("Fecha_horaActualizacion", oFormato426.Fecha_horaActualizacion);
                    cmd.Parameters.AddWithValue("Usuario", oFormato426.Usuario);
                    cmd.Parameters.AddWithValue("CodigoRegistro", oFormato426.CodigoRegistro);
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oConexion.Open();

                    cmd.ExecuteNonQuery();

                    respuesta = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);

                }
                catch (Exception ex)
                {
                    respuesta = false;
                }

            }

            return respuesta;

        }      
    }
}
