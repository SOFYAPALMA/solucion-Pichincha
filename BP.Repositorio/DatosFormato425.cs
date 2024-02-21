using CapaModelo;
using Comun;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace BP.Repositorio
{
    public class DatosFormato425 : ConexionMS
    {
        #region Comun
        private static DatosFormato425 instance = null;

        public static DatosFormato425 Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosFormato425();
            }

            return instance;
        }

        static DatosFormato425()
        {

        }
        #endregion
        public static string Mensaje { get; private set; }

        public static bool RegistrarEncabezado(Formulario425_Encabezado obj)
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
                AdicionarParametros("@idAperturaDigital", obj.idAperturaDigital);
                AdicionarParametros("NumeroClientes", obj.NumeroClientes);
                AdicionarParametros("idFranquicia", obj.idFranquicia);
                AdicionarParametros("CuotaManejo", obj.CuotaManejo);
                AdicionarParametros("idObservacionesCuota", obj.idObservacionesCuota);
                AdicionarParametros("CuotaManejoMaxima", obj.CuotaManejoMaxima);
                AdicionarParametros("idGrupoPoblacional", obj.idGrupoPoblacional);
                AdicionarParametros("idCupo", obj.idCupo);
                AdicionarParametros("idServicioGratuito_1", obj.idServicioGratuito_1);
                AdicionarParametros("idServicioGratuito_2", obj.idServicioGratuito_2);
                AdicionarParametros("idServicioGratuito_3", obj.idServicioGratuito_3);
                AdicionarParametros("Usuario", obj.Usuario);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("IdPropiedadesFormato", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaPropiedadesTarjetaCredito");

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

        public static bool RegistrarDetalle(Formulario425_Detalle obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idPropiedadesFormato", obj.idPropiedadesFormato);
                AdicionarParametros("@Subcuenta", obj.Subcuenta);
                AdicionarParametros("@idOperacionServicio", obj.idOperacionServicio);
                AdicionarParametros("@idCanal", obj.idCanal);
                AdicionarParametros("@CostoFijo", obj.CostoFijo);
                AdicionarParametros("@CostoFijoMaximo", obj.CostoFijoMaximo);
                AdicionarParametros("@CostoProporcionOperacionServicio", obj.CostoProporcionOperacionServicio);
                AdicionarParametros("@CostoProporcionMaxOperacionServicio", obj.CostoProporcionMaxOperacionServicio);
                AdicionarParametros("@Tasa", obj.Tasa);
                AdicionarParametros("@TasaMaxima", obj.TasaMaxima);
                AdicionarParametros("@idTipoAseguradora", obj.idTipoAseguradora);
                AdicionarParametros("@idCodigoAseguradora", obj.idCodigoAseguradora);
                AdicionarParametros("@idObservaciones", obj.idObservaciones);
                AdicionarParametros("@UnidadCaptura", obj.UnidadCaptura);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaDetalleTarjetaCredito");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                desconectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en RegistrarDetalle", ex);
            }

            return respuesta;
        }

        public static bool ActualizarEncabezado(Formulario425_Encabezado obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("IdPropiedadesFormato", obj.idPropiedadesFormato);
                AdicionarParametros("Tipo", obj.Tipo);
                AdicionarParametros("Codigo", obj.Codigo);
                AdicionarParametros("Nombre", obj.Nombre);
                AdicionarParametros("idNombreComercial", obj.idNombreComercial);
                AdicionarParametros("idAperturaDigital", obj.idAperturaDigital);
                AdicionarParametros("NumeroClientes", obj.NumeroClientes);
                AdicionarParametros("idFranquicia", obj.idFranquicia);
                AdicionarParametros("CuotaManejo", obj.CuotaManejo);
                AdicionarParametros("idObservacionesCuota", obj.idObservacionesCuota);
                AdicionarParametros("CuotaManejoMaxima", obj.CuotaManejoMaxima);
                AdicionarParametros("idGrupoPoblacional", obj.idGrupoPoblacional);
                AdicionarParametros("idCupo", obj.idCupo);
                AdicionarParametros("idServicioGratuito_1", obj.idServicioGratuito_1);
                AdicionarParametros("idServicioGratuito_2", obj.idServicioGratuito_2);
                AdicionarParametros("idServicioGratuito_3", obj.idServicioGratuito_3);
                AdicionarParametros("Usuario", obj.Usuario);


                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spActualizaPropiedadesTarjetaCredito");

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

        //public static bool EliminarEncabezado(int id)
        //{
        //    Instanciar();
        //    bool respuesta = false;

        //    try
        //    {
        //        limpiarParametros();
        //        AdicionarParametros("@idPropiedadesFormato", id);
        //        AdicionarParametros("@Tiporegistros", "E");

        //        AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
        //        AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

        //        ejecutarScalar("bpapp.spEliminaTarjetaCredito");

        //        respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
        //        Mensaje = RecuperarParametrosOut("MensajeSalida");
        //        Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
        //    }
        //    catch (Exception ex)
        //    {
        //        desconectar();
        //        Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
        //        throw new Exception("No se puede eliminar el encabezado tiene detalle", ex);
        //    }

        //    return respuesta;
        //}

        public static bool EliminarDetalle(Formulario425_Detalle obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();

                
                AdicionarParametros("@idDetalle", obj.idDetalle);
                AdicionarParametros("@Subcuenta", obj.idObservaciones);
                AdicionarParametros("@idOperacionServicio", obj.idOperacionServicio);
                AdicionarParametros("@idCanal", obj.idCanal);
                AdicionarParametros("@CostoFijo", obj.CostoFijo);
                AdicionarParametros("@CostoFijoMaximo", obj.CostoFijoMaximo);
                AdicionarParametros("@CostoProporcionOperacionServicio", obj.CostoProporcionOperacionServicio);
                AdicionarParametros("@CostoProporcionMaxOperacionServicio", obj.CostoProporcionMaxOperacionServicio);
                AdicionarParametros("@idOperacionServicio", obj.idOperacionServicio);
                AdicionarParametros("@idTipoAseguradora", obj.idTipoAseguradora);
                AdicionarParametros("@idCodigoAseguradora", obj.idCodigoAseguradora);
                AdicionarParametros("@CostoFijo", obj.CostoFijo);
                AdicionarParametros("@Tasa", obj.Tasa);
                AdicionarParametros("@TasaMaxima", obj.TasaMaxima);
                AdicionarParametros("@idObservaciones", obj.idObservaciones);


                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spDesactivaDetalleTarjetaCredito");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Termina Sin errores pero no realiza la acción, dado que el estado del registro no Corresponde!, esta Inactivo, o esta en Edición Detalle", ex);
            }

            return respuesta;
        }

        public static bool ActualizarDetalle(Formulario425_Detalle obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idDetalle", obj.idDetalle);
                AdicionarParametros("@Subcuenta", obj.Subcuenta);
                AdicionarParametros("@idOperacionServicio", obj.idOperacionServicio);
                AdicionarParametros("@idCanal", obj.idCanal);
                AdicionarParametros("@CostoFijo", obj.CostoFijo);
                AdicionarParametros("@CostoFijoMaximo", obj.CostoFijoMaximo);
                AdicionarParametros("@CostoProporcionOperacionServicio", obj.CostoProporcionOperacionServicio);
                AdicionarParametros("@CostoProporcionMaxOperacionServicio", obj.CostoProporcionMaxOperacionServicio);
                AdicionarParametros("@Tasa", obj.Tasa);
                AdicionarParametros("@TasaMaxima", obj.TasaMaxima);
                AdicionarParametros("@idTipoAseguradora", obj.idTipoAseguradora);
                AdicionarParametros("@idCodigoAseguradora", obj.idCodigoAseguradora);
                AdicionarParametros("@idObservaciones", obj.idObservaciones);
                AdicionarParametros("@UnidadCaptura", obj.UnidadCaptura);


                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spActualizaDetalleTarjetaCredito");

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

        public static Formulario425_Detalle DetallesDetalles(int id)
        {
            try
            {
                Formulario425_Detalle rpt = new Formulario425_Detalle();
                limpiarParametros();
                AdicionarParametros("idDetalle", id);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaDetalleTarjetaCredito").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    var dictionary = new Dictionary<string, object>();
                    foreach (DataColumn column in dt.Columns)
                    {
                        dictionary[column.ColumnName] = dt.Rows[0][column];
                    }

                    string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<Formulario425_Detalle>(serializedObject);
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

        public static Formulario425_Encabezado Detalles(int FormatoId)
        {
            try
            {
                Formulario425_Encabezado rpt = new Formulario425_Encabezado();
                limpiarParametros();
                AdicionarParametros("idPropiedadesFormato", FormatoId);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaPropiedadesTarjetaCredito").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    var dictionary = new Dictionary<string, object>();
                    foreach (DataColumn column in dt.Columns)
                    {
                        dictionary[column.ColumnName] = dt.Rows[0][column];
                    }

                    string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<Formulario425_Encabezado>(serializedObject);
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

        public static List<Formulario425_Encabezado> Lista()
        {
            try
            {
                List<Formulario425_Encabezado> rpt = new List<Formulario425_Encabezado>();
                limpiarParametros();
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaPropiedadesTarjetaCredito").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<Formulario425_Encabezado>>(serializedObject);
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

        public static List<Formulario425_Detalle> ListaDetalles(int FormatoId)
        {
            try
            {
                List<Formulario425_Detalle> rpt = new List<Formulario425_Detalle>();
                limpiarParametros();
                AdicionarParametros("idPropiedadesFormato", FormatoId);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaDetalleTarjetaCredito").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<Formulario425_Detalle>>(serializedObject);
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