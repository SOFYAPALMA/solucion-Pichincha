using CapaModelo;
using Comun;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace BP.Repositorio
{
    public class DatosFormato424 : ConexionMS
    {
        #region Comun
        private static DatosFormato424 instance = null;

        public static DatosFormato424 Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosFormato424();
            }

            return instance;
        }

        static DatosFormato424()
        {

        }
        #endregion
        public static string Mensaje { get; private set; }

        public static bool RegistrarEncabezado(Formulario424_Encabezado obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("Tipo", obj.Tipo);
                AdicionarParametros("Codigo", obj.Codigo);
                AdicionarParametros("Nombre", obj.Nombre);
                AdicionarParametros("idNombreComercial", obj.idNombreComercial);
                AdicionarParametros("TipoProductoDeposito", obj.idTipoProductoDeposito);
                AdicionarParametros("AperturaDigital", obj.AperturaDigital);
                AdicionarParametros("NumeroClientes", obj.NumeroClientes);
                AdicionarParametros("CuotaManejo", obj.CuotaManejo);
                AdicionarParametros("ObservacionesCuota", obj.idObservacionesCuota);
                AdicionarParametros("GrupoPoblacional", obj.GrupoPoblacional);
                AdicionarParametros("Ingresos", obj.Ingresos);
                AdicionarParametros("SerGratuito_CtaAHO", obj.idSerGratuito_CtaAHO);
                AdicionarParametros("SerGratuito_CtaAHO2", obj.idSerGratuito_CtaAHO2);
                AdicionarParametros("SerGratuito_CtaAHO3", obj.idSerGratuito_CtaAHO3);
                AdicionarParametros("SerGratuito_TCRDebito", obj.idSerGratuito_TCRDebito);
                AdicionarParametros("SerGratuito_TCRDebito2", obj.idSerGratuito_TCRDebito2);
                AdicionarParametros("SerGratuito_TCRDebito3", obj.idSerGratuito_TCRDebito3);
                AdicionarParametros("Usuario", obj.Usuario);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("IdPropiedadesFomato", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaPropiedadesDepositos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en RegistrarEncabezado", ex);
            }

            return respuesta;
        }

        public static bool RegistrarDetalle(Formulario424_Detalle obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idPropiedadesFormato", obj.idPropiedadesFormato);
                AdicionarParametros("@subCuenta", obj.subCuenta);
                AdicionarParametros("@idOperacionServicio", obj.idOperacionServicio);
                AdicionarParametros("@idCanal", obj.idCanal);
                AdicionarParametros("@NumOperServiciosCuotamanejo", obj.NumOperServiciosCuotamanejo);
                AdicionarParametros("@CostoFijo", obj.CostoFijo);
                AdicionarParametros("@CostoProporcionOperacionServicio", obj.CostoProporcionOperacionServicio);
                AdicionarParametros("@idObservaciones", obj.idObservaciones);
                AdicionarParametros("@UnidadCaptura", obj.UnidadCaptura);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaDetalleDeposito");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en RegistrarEncabezadoDetalle", ex);
            }

            return respuesta;
        }


        public static bool ActualizarEncabezado(Formulario424_Encabezado obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idPropiedadesFormato", obj.idPropiedadesFormato);
                AdicionarParametros("Tipo", obj.Tipo);
                AdicionarParametros("Codigo", obj.Codigo);
                AdicionarParametros("Nombre", obj.Nombre);
                AdicionarParametros("idNombreComercial", obj.idNombreComercial);
                AdicionarParametros("idTipoProductoDeposito", obj.idTipoProductoDeposito);
                AdicionarParametros("idAperturaDigital", obj.idAperturaDigital);
                AdicionarParametros("NumeroClientes", obj.NumeroClientes);
                AdicionarParametros("CuotaManejo", obj.CuotaManejo);
                AdicionarParametros("idObservacionesCuota", obj.idObservacionesCuota);
                AdicionarParametros("idGrupoPoblacional", obj.idGrupoPoblacional);
                AdicionarParametros("idIngresos", obj.idIngresos);
                AdicionarParametros("idSerGratuito_CtaAHO", obj.idSerGratuito_CtaAHO);
                AdicionarParametros("idSerGratuito_CtaAHO2", obj.idSerGratuito_CtaAHO2);
                AdicionarParametros("idSerGratuito_CtaAHO3", obj.idSerGratuito_CtaAHO3);
                AdicionarParametros("idSerGratuito_TCRDebito", obj.idSerGratuito_TCRDebito);
                AdicionarParametros("idSerGratuito_TCRDebito2", obj.idSerGratuito_TCRDebito2);
                AdicionarParametros("idSerGratuito_TCRDebito3", obj.idSerGratuito_TCRDebito3);
                AdicionarParametros("Usuario", obj.Usuario);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spActualizaPropiedadesDepositos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ActualizarEncabezado", ex);
            }

            return respuesta;
        }

        public static bool ActualizarDetalle(Formulario424_Detalle obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idDetalle", obj.idDetalle);
                AdicionarParametros("@subCuenta", obj.subCuenta);
                AdicionarParametros("@idOperacionServicio", obj.idOperacionServicio);
                AdicionarParametros("@idCanal", obj.idCanal);
                AdicionarParametros("@NumOperServiciosCuotamanejo", obj.NumOperServiciosCuotamanejo);
                AdicionarParametros("@CostoFijo", obj.CostoFijo);
                AdicionarParametros("@CostoProporcionOperacionServicio", obj.CostoProporcionOperacionServicio);
                AdicionarParametros("@idObservaciones", obj.idObservaciones);
                AdicionarParametros("@UnidadCaptura", obj.UnidadCaptura);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spActualizaDetalleDeposito");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ActualizarDetalle", ex);
            }

            return respuesta;
        }

        public static Formulario424_Encabezado DetalleEncabezado(int FormatoId)
        {
            try
            {
                Formulario424_Encabezado rpt = new Formulario424_Encabezado();
                limpiarParametros();
                AdicionarParametros("idPropiedadesFormato", FormatoId);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaPropiedadesDepositos").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    var dictionary = new Dictionary<string, object>();
                    foreach (DataColumn column in dt.Columns)
                    {
                        dictionary[column.ColumnName] = dt.Rows[0][column];
                    }

                    string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<Formulario424_Encabezado>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en Detalles", ex);
            }
        }

        public static List<Formulario424_Encabezado> Lista()
        {
            try
            {
                List<Formulario424_Encabezado> rpt = new List<Formulario424_Encabezado>();
                limpiarParametros();
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaPropiedadesDepositos").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<Formulario424_Encabezado>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en Detalles", ex);
            }
        }

        public static List<Formulario424_Detalle> ListaDetalles(int FormatoId)
        {
            try
            {
                List<Formulario424_Detalle> rpt = new List<Formulario424_Detalle>();
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
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<List<Formulario424_Detalle>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ListaDetalles", ex);
            }
        }

        public static Formulario424_Detalle DetallesDetalles(int FormatoId)
        {
            try
            {
                Formulario424_Detalle rpt = new Formulario424_Detalle();
                limpiarParametros();
                AdicionarParametros("idDetalle", FormatoId);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaDetalleDeposito").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    var dictionary = new Dictionary<string, object>();
                    foreach (DataColumn column in dt.Columns)
                    {
                        dictionary[column.ColumnName] = dt.Rows[0][column];
                    }

                    string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<Formulario424_Detalle>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ListaDetalles", ex);
            }
        }
    }
}
