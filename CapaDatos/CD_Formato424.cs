using CapaModelo;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CapaDatos
{
    public class CD_Formato424
    {

        public static List<Formulario424_Encabezado> Listar()
        {
            List<Formulario424_Encabezado> rptLista = new List<Formulario424_Encabezado>();
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                SqlCommand cmd = new SqlCommand("spConsultaPropiedadesDepositos", oConexion);
                cmd.Parameters.Add("IndicadorTermina", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    oConexion.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        rptLista.Add(new Formulario424_Encabezado()
                        {
                            /*
                            IdNivel = Convert.ToInt32(dr["IdNivel"].ToString()),
                            DescripcionNivel = dr["DescripcionNivel"].ToString(),
                            DescripcionTurno = dr["DescripcionTurno"].ToString(),
                            HoraInicio = Convert.ToDateTime(dr["HoraInicio"].ToString()),
                            HoraFin = Convert.ToDateTime(dr["HoraFin"].ToString()),
                            Activo = Convert.ToBoolean(dr["Activo"])
                            */

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

        public static Formulario424_Encabezado Detalles(int FormatoId)
        {
            Formulario424_Encabezado rpt = new Formulario424_Encabezado();
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                SqlCommand cmd = new SqlCommand("spConsultaPropiedadesDepositos", oConexion);
                cmd.Parameters.AddWithValue("idPropiedadesFormato", FormatoId);
                cmd.Parameters.Add("IndicadorTermina", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    oConexion.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        var dictionary = new Dictionary<string, object>();
                        foreach (DataRow column in dr.GetSchemaTable().Rows)
                        {
                            string colName = column.Field<string>("ColumnName");
                            dictionary[colName] = dr[colName];
                        }

                        string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());

                        Formulario424_Encabezado cliente = JsonConvert.DeserializeObject<Formulario424_Encabezado>(serializedObject);
                    }
                    dr.Close();

                    return rpt;

                }
                catch (Exception ex)
                {
                    rpt = null;
                    return rpt;
                }
            }
        }


        public static bool Registrar(Formulario424_Encabezado obj)
        {
            bool respuesta = true;
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("spInsertaPropiedadesDepositos", oConexion);
                    cmd.Parameters.AddWithValue("Tipo", obj.Tipo);
                    /*cmd.Parameters.AddWithValue("DescripcionTurno", obj.DescripcionTurno);
                    cmd.Parameters.AddWithValue("HoraInicio", obj.HoraInicio);
                    cmd.Parameters.AddWithValue("HoraFin", obj.HoraFin);
                    */

                    cmd.Parameters.Add("IndicadorTermina", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("IdPropiedadesFomato", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("MensajeSalida", SqlDbType.Bit).Direction = ParameterDirection.Output;
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


        public static bool Editar(Formato424 oNivel)
        {
            bool respuesta = true;
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("usp_EditarNivel", oConexion);
                    cmd.Parameters.AddWithValue("IdNivel", oNivel.IdNivel);
                    cmd.Parameters.AddWithValue("DescripcionNivel", oNivel.DescripcionNivel);
                    cmd.Parameters.AddWithValue("DescripcionTurno", oNivel.DescripcionTurno);
                    cmd.Parameters.AddWithValue("HoraInicio", oNivel.HoraInicio);
                    cmd.Parameters.AddWithValue("HoraFin", oNivel.HoraFin);
                    cmd.Parameters.AddWithValue("Activo", oNivel.Activo);
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

        public static bool Eliminar(int idNivel)
        {
            bool respuesta = true;
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("usp_EliminarNivel", oConexion);
                    cmd.Parameters.AddWithValue("IdNivel", idNivel);
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
