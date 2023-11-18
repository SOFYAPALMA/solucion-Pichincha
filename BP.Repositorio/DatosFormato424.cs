using CapaModelo;
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

        public static bool RegistrarEncabezado(Formulario424_EncabezadoCrear obj)
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
                AdicionarParametros("Usuario", obj.Usuario ?? "1");

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

        public static Formulario424_EncabezadoConsulta Detalles(int FormatoId)
        {
            try
            {
                Formulario424_EncabezadoConsulta rpt = new Formulario424_EncabezadoConsulta();
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

                    rpt = JsonConvert.DeserializeObject<Formulario424_EncabezadoConsulta>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en Detalles", ex);
            }
        }

        public static List<Formulario424_EncabezadoConsulta> Lista()
        {
            try
            {
                List<Formulario424_EncabezadoConsulta> rpt = new List<Formulario424_EncabezadoConsulta>();
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

                    rpt = JsonConvert.DeserializeObject<List<Formulario424_EncabezadoConsulta>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en Detalles", ex);
            }
        }
    }
}
