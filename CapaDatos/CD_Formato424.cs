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
        public static string Mensaje { get; private set; }

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

        public static bool RegistrarEncabezado2(Formulario424_Encabezado obj)
        {
            bool respuesta = true;
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("bpapp.spInsertaPropiedadesDepositos", oConexion);
                    cmd.Parameters.AddWithValue("@TipodeProductoDeposito", obj.TipodeProductoDeposito);
                    cmd.Parameters.AddWithValue("Tipo", obj.Tipo);
                    cmd.Parameters.AddWithValue("Codigo", obj.Codigo);
                    cmd.Parameters.AddWithValue("Nombre", obj.Nombre);
                    cmd.Parameters.AddWithValue("NombreComercial", obj.NombreComercial);                    
                    cmd.Parameters.AddWithValue("AperturaDigital", obj.AperturaDigital);
                    cmd.Parameters.AddWithValue("NumerodeClientesUnicos", obj.NumerodeClientesUnicos);
                    cmd.Parameters.AddWithValue("CuotadeManejo", obj.CuotadeManejo);
                    cmd.Parameters.AddWithValue("ObservacionesCuotadeManejo", obj.ObservacionesCuotadeManejo);
                    cmd.Parameters.AddWithValue("GrupoPoblacional", obj.GrupoPoblacional);
                    cmd.Parameters.AddWithValue("CuotadeManejo", obj.CuotadeManejo);
                    cmd.Parameters.AddWithValue("ServicioGratuitoCuentadeAhorros1", obj.ServicioGratuitoCuentadeAhorros1);
                    cmd.Parameters.AddWithValue("ServicioGratuitoCuentadeAhorros2", obj.ServicioGratuitoCuentadeAhorros2);
                    cmd.Parameters.AddWithValue("ServicioGratuitoCuentadeAhorros3", obj.ServicioGratuitoCuentadeAhorros3);
                    cmd.Parameters.AddWithValue("ServicioGratuitoTarjetaDebito1", obj.ServicioGratuitoTarjetaDebito1);
                    cmd.Parameters.AddWithValue("ServicioGratuitoTarjetaDebito2", obj.ServicioGratuitoTarjetaDebito2);
                    cmd.Parameters.AddWithValue("ServicioGratuitoTarjetaDebito3", obj.ServicioGratuitoTarjetaDebito3);
                    cmd.Parameters.AddWithValue("Ingresos", obj.Ingresos);

                    cmd.Parameters.Add("IndicadorTermina", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("IdPropiedadesFomato", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("MensajeSalida", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oConexion.Open();

                    cmd.ExecuteNonQuery();

                    respuesta = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["MensajeSalida"].Value.ToString();

                }
                catch (Exception ex)
                {
                    throw new Exception("Error en RegistrarEncabezado", ex);
                }
            }

            return respuesta;

        }

        public static bool RegistrarEncabezado(Formulario424_Encabezado obj)
        {
            bool respuesta = true;
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("bpapp.spInsertaPropiedadesDepositos", oConexion);
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddWithValue("Tipo", obj.Tipo);
                    cmd.Parameters.AddWithValue("Codigo", obj.Codigo);
                    cmd.Parameters.AddWithValue("Nombre", obj.Nombre);
                    cmd.Parameters.AddWithValue("NombreComercial", obj.NombreComercial);
                    cmd.Parameters.AddWithValue("TipoProductoDeposito", obj.TipodeProductoDeposito);
                    cmd.Parameters.AddWithValue("AperturaDigital", obj.AperturaDigital);
                    cmd.Parameters.AddWithValue("NumeroClientes", obj.NumerodeClientesUnicos);
                    cmd.Parameters.AddWithValue("CuotaManejo", obj.CuotadeManejo);
                    cmd.Parameters.AddWithValue("ObservacionesCuota", obj.ObservacionesCuotadeManejo);
                    cmd.Parameters.AddWithValue("GrupoPoblacional", obj.GrupoPoblacional);
                    cmd.Parameters.AddWithValue("Ingresos", obj.Ingresos);
                    cmd.Parameters.AddWithValue("SerGratuito_CtaAHO", obj.ServicioGratuitoCuentadeAhorros1);
                    cmd.Parameters.AddWithValue("SerGratuito_CtaAHO2", obj.ServicioGratuitoCuentadeAhorros2);
                    cmd.Parameters.AddWithValue("SerGratuito_CtaAHO3", obj.ServicioGratuitoCuentadeAhorros3);
                    cmd.Parameters.AddWithValue("SerGratuito_TCRDebito", obj.ServicioGratuitoTarjetaDebito1);
                    cmd.Parameters.AddWithValue("SerGratuito_TCRDebito2", obj.ServicioGratuitoTarjetaDebito2);
                    cmd.Parameters.AddWithValue("SerGratuito_TCRDebito3", obj.ServicioGratuitoTarjetaDebito3);
                    cmd.Parameters.AddWithValue("Usuario", obj.Usuario ?? "1");

                    cmd.Parameters.Add("IndicadorTermina", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("IdPropiedadesFomato", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("MensajeSalida", SqlDbType.VarChar, 256).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oConexion.Open();

                    cmd.ExecuteNonQuery();

                    respuesta = Convert.ToBoolean(cmd.Parameters["IndicadorTermina"].Value);
                    Mensaje = cmd.Parameters["MensajeSalida"].Value.ToString();

                }
                catch (Exception ex)
                {
                    throw new Exception("Error en RegistrarEncabezado", ex);
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
