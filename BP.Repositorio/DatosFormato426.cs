using CapaModelo;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace BP.Repositorio
{
    public class DatosFormato426 : ConexionMS
    {
        #region Comun
        private static DatosFormato426 instance = null;

        public static DatosFormato426 Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosFormato426();
            }

            return instance;
        }

        static DatosFormato426()
        {

        }
        #endregion
        public static string Mensaje { get; private set; }

        public static bool RegistrarEncabezado(Formulario426_Encabezado obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("Tipo", obj.Tipo);
                AdicionarParametros("Codigo", obj.Codigo);
                AdicionarParametros("Nombre", obj.Nombre);
                AdicionarParametros("idCodigoCredito", obj.idCodigoCredito);
                AdicionarParametros("idAperturaDigital", obj.idAperturaDigital);
                AdicionarParametros("Usuario", obj.Usuario);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("@IdPropiedadesFormato", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaPropiedadesCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
            }
            catch (Exception ex)
            {
                throw new Exception("Error en RegistrarEncabezado", ex);
            }

            return respuesta;
        }

        public static bool RegistrarEncabezadoDetalle(Formulario426_Detalle obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                //AdicionarParametros("@Tipo", obj.Tipo);
                //AdicionarParametros("@Codigo", obj.Codigo);
                //AdicionarParametros("@Nombre", obj.Nombre);
                //AdicionarParametros("@Fecha_horaActualizacion", obj.Fecha_horaActualizacion);
                //AdicionarParametros("@idCodigoCredito", obj.idCodigoCredito);
                //AdicionarParametros("@idAperturaDigital", obj.idAperturaDigital);
                //AdicionarParametros("@Usuario", obj.Usuario);
                //AdicionarParametros("@IdPropiedadesFormato", obj.IdPropiedadesFormato);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaPropiedadesCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
            }
            catch (Exception ex)
            {
                throw new Exception("Error en RegistrarEncabezadoDetalle", ex);
            }

            return respuesta;
        }


        public static bool ActualizarEncabezado(Formulario426_Encabezado obj) // no cuenta con StoreProcedure en DB
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("Tipo", obj.Tipo);
                AdicionarParametros("Codigo", obj.Codigo);
                AdicionarParametros("Nombre", obj.Nombre);
                //AdicionarParametros("NombreComercial", obj.NombreComercial);
                //AdicionarParametros("idAperturaDigital", obj.idAperturaDigital);
                //AdicionarParametros("NumeroClientes", obj.NumeroClientes);
                //AdicionarParametros("idFranquicia", obj.idFranquicia);
                //AdicionarParametros("CuotaManejo", obj.CuotaManejo);
                //AdicionarParametros("idObservacionesCuota", obj.idObservacionesCuota);
                //AdicionarParametros("CuotaManejoMaxima", obj.CuotaManejoMaxima);
                //AdicionarParametros("idGrupoPoblacional", obj.idGrupoPoblacional);
                //AdicionarParametros("idCupo", obj.idCupo);
                //AdicionarParametros("idServicioGratuito_1", obj.idServicioGratuito_1);
                //AdicionarParametros("idServicioGratuito_2", obj.idServicioGratuito_2);
                //AdicionarParametros("idServicioGratuito_3", obj.idServicioGratuito_3);
                //AdicionarParametros("Fecha_horaActualizacion", obj.Fecha_horaActualizacion);
                //AdicionarParametros("Usuario", obj.Usuario);
                //AdicionarParametros("Estado", obj.Estado);
                //AdicionarParametros("Fechacorte", obj.Fechacorte);
                //AdicionarParametros("FechaEstado", obj.FechaEstado);
                //AdicionarParametros("CodigoRegistro", obj.CodigoRegistro);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spActualizaPropiedadesCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ActualizarEncabezado", ex);
            }

            return respuesta;
        }

        public static Formulario426_Encabezado Detalles(int FormatoId)
        {
            try
            {
                Formulario426_Encabezado rpt = new Formulario426_Encabezado();
                limpiarParametros();
                AdicionarParametros("idPropiedadesFormato", FormatoId);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaPropiedadesCredito").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    var dictionary = new Dictionary<string, object>();
                    foreach (DataColumn column in dt.Columns)
                    {
                        dictionary[column.ColumnName] = dt.Rows[0][column];
                    }

                    string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());

                    rpt = JsonConvert.DeserializeObject<Formulario426_Encabezado>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en Detalles", ex);
            }
        }

        public static List<Formulario426_Encabezado> Lista()
        {
            try
            {
                List<Formulario426_Encabezado> rpt = new List<Formulario426_Encabezado>();
                limpiarParametros();
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaPropiedadesCredito").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

                    foreach (DataRow row in dt.Rows)
                    {
                        var dictionary = new Dictionary<string, object>();
                        foreach (DataColumn column in dt.Columns)
                        {
                            dictionary[column.ColumnName] = row[column];
                        }

                        list.Add(dictionary);
                    }

                    string serializedObject = JsonConvert.SerializeObject(list, new DatetimeToStringConverter());

                    rpt = JsonConvert.DeserializeObject<List<Formulario426_Encabezado>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en Detalles", ex);
            }
        }

        public static List<Formulario426_Detalle> ListaDetalles(int FormatoId)
        {
            try
            {
                List<Formulario426_Detalle> rpt = new List<Formulario426_Detalle>();
                limpiarParametros();
                AdicionarParametros("idPropiedadesFormato", FormatoId);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaDetalleDeposito").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

                    foreach (DataRow row in dt.Rows)
                    {
                        var dictionary = new Dictionary<string, object>();
                        foreach (DataColumn column in dt.Columns)
                        {
                            dictionary[column.ColumnName] = row[column];
                        }

                        list.Add(dictionary);
                    }

                    string serializedObject = JsonConvert.SerializeObject(list, new DatetimeToStringConverter());

                    rpt = JsonConvert.DeserializeObject<List<Formulario426_Detalle>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ListaDetalles", ex);
            }
        }
    }
}

