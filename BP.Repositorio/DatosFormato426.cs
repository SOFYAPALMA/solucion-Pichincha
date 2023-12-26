using CapaModelo;
using Comun;
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
                AdicionarParametros("TipoProductoCredito", obj.TipoProductoCredito);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("@IdPropiedadesFormato", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaPropiedadesCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
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
                AdicionarParametros("@idPropiedadesFormato", obj.idPropiedadesFormato);
                AdicionarParametros("@Subcuenta", obj.Subcuenta);
                AdicionarParametros("@idCaracteristicaCredito", obj.idCaracteristicaCredito);
                AdicionarParametros("@Costo", obj.Costo);
                AdicionarParametros("@Tasa", obj.Tasa);
                AdicionarParametros("@idTipoAseguradora", obj.idTipoAseguradora);
                AdicionarParametros("@idCodigoAseguradora", obj.idCodigoAseguradora);
                AdicionarParametros("@idObservaciones", obj.idObservaciones);
                AdicionarParametros("@UnidadCaptura", obj.UnidadCaptura);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaDetalleCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en RegistrarEncabezadoDetalle", ex);
            }

            return respuesta;
        }

        public static bool ActualizarEncabezado(Formulario426_Encabezado obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idPropiedadesFormato", obj.idPropiedadesFormato);
                AdicionarParametros("@Tipo", obj.Tipo);
                AdicionarParametros("@Codigo", obj.Codigo);
                AdicionarParametros("@Nombre", obj.Nombre);
                AdicionarParametros("@TipoProductoCredito", obj.TipoProductoCredito);
                AdicionarParametros("@idCodigoCredito", obj.idCodigoCredito);
                AdicionarParametros("@idAperturaDigital", obj.idAperturaDigital);
                AdicionarParametros("@Usuario", obj.Usuario);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spActualizaPropiedadesCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ActualizarEncabezado", ex);
            }

            return respuesta;
        }
        public static bool EliminarEncabezado(int id)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idPropiedadesFormato", id);
                AdicionarParametros("@Tiporegistros", "E");

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spEliminaCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("No se puede eliminar el encabezado tiene detalle", ex);
            }

            return respuesta;
        }

        public static bool EliminarDetalle(int id, int idDetalle)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idPropiedadesFormato", id);
                AdicionarParametros("@Tiporegistros", "");
                AdicionarParametros("@idDetalle", idDetalle);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spEliminaCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("No se puede eliminar el encabezado tiene detalle", ex);
            }

            return respuesta;
        }
        public static bool ActualizarDetalle(Formulario426_Detalle obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idDetalle", obj.idDetalle);
                AdicionarParametros("@Subcuenta", obj.Subcuenta);
                AdicionarParametros("@idCaracteristicaCredito", obj.idCaracteristicaCredito);
                AdicionarParametros("@Costo", obj.Costo);
                AdicionarParametros("@Tasa", obj.Tasa);
                AdicionarParametros("@idTipoAseguradora", obj.idTipoAseguradora);
                AdicionarParametros("@idCodigoAseguradora", obj.idCodigoAseguradora);
                AdicionarParametros("@idObservaciones", obj.idObservaciones);
                AdicionarParametros("@UnidadCaptura", obj.UnidadCaptura);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spActualizaDetalleCreditos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ActualizarDetalle", ex);
            }

            return respuesta;
        }

        public static Formulario426_Detalle DetallesDetalles(int id)
        {
            try
            {
                Formulario426_Detalle rpt = new Formulario426_Detalle();
                limpiarParametros();
                AdicionarParametros("idDetalle", id);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaDetalleCredito").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    var dictionary = new Dictionary<string, object>();
                    foreach (DataColumn column in dt.Columns)
                    {
                        dictionary[column.ColumnName] = dt.Rows[0][column];
                    }

                    string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<Formulario426_Detalle>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ListaDetalles", ex);
            }
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
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<Formulario426_Encabezado>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
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
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<List<Formulario426_Encabezado>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
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

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaDetalleCredito").Tables[0];

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
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<List<Formulario426_Detalle>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ListaDetalles", ex);
            }
        }
    }
}

