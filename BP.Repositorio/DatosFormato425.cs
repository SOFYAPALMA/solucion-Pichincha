using CapaModelo;
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
                AdicionarParametros("NombreComercial", obj.NombreComercial);
                AdicionarParametros("TipoProductoDeposito", obj.TipodeProductoDeposito);
                AdicionarParametros("AperturaDigital", obj.AperturaDigital);
                AdicionarParametros("NumeroClientes", obj.NumerodeClientesUnicos);
                AdicionarParametros("CuotaManejo", obj.CuotadeManejo);
                AdicionarParametros("ObservacionesCuota", obj.ObservacionesCuotadeManejo);
                AdicionarParametros("GrupoPoblacional", obj.GrupoPoblacional);
                AdicionarParametros("Ingresos", obj.Ingresos);
                AdicionarParametros("SerGratuito_CtaAHO", obj.ServicioGratuitoCuentadeAhorros1);
                AdicionarParametros("SerGratuito_CtaAHO2", obj.ServicioGratuitoCuentadeAhorros2);
                AdicionarParametros("SerGratuito_CtaAHO3", obj.ServicioGratuitoCuentadeAhorros3);
                AdicionarParametros("SerGratuito_TCRDebito", obj.ServicioGratuitoTarjetaDebito1);
                AdicionarParametros("SerGratuito_TCRDebito2", obj.ServicioGratuitoTarjetaDebito2);
                AdicionarParametros("SerGratuito_TCRDebito3", obj.ServicioGratuitoTarjetaDebito3);
                AdicionarParametros("Usuario", obj.Usuario);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("IdPropiedadesFomato", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaPropiedadesDepositos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
            }
            catch (Exception ex)
            {
                throw new Exception("Error en RegistrarEncabezado", ex);
            }

            return respuesta;
        }

        public static bool RegistrarEncabezadoDetalle(Formulario425_Detalle obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idPropiedadesFormato", obj.idPropiedadesFormato);
                AdicionarParametros("@subCuenta", obj.Subcuentas);
                AdicionarParametros("@idOperacionServicio", obj.idOperacionoServicio);
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
            }
            catch (Exception ex)
            {
                throw new Exception("Error en RegistrarEncabezadoDetalle", ex);
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
                AdicionarParametros("@idPropiedadesFormato", obj.idPropiedadesFormato);
                AdicionarParametros("Tipo", obj.Tipo);
                AdicionarParametros("Codigo", obj.Codigo);
                AdicionarParametros("Nombre", obj.Nombre);
                AdicionarParametros("NombreComercial", obj.NombreComercial);
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
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ActualizarEncabezado", ex);
            }

            return respuesta;
        }

        public static Formulario425_Encabezado Detalles(int FormatoId)
        {
            try
            {
                Formulario425_Encabezado rpt = new Formulario425_Encabezado();
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

                    rpt = JsonConvert.DeserializeObject<Formulario425_Encabezado>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
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

                    rpt = JsonConvert.DeserializeObject<List<Formulario425_Encabezado>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
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

                    rpt = JsonConvert.DeserializeObject<List<Formulario425_Detalle>>(serializedObject);
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
