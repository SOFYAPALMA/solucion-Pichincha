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
                AdicionarParametros("AperturaDigital", obj.AperturaDigital);
                AdicionarParametros("NumeroClientes", obj.NumeroClientes);
                AdicionarParametros("Franquicia", obj.Franquicia);
                AdicionarParametros("CuotaManejo", obj.CuotaManejo);
                AdicionarParametros("ObservacionesCuota", obj.ObservacionesCuota);
                AdicionarParametros("CuotaManejoMaxima", obj.CuotaManejoMaxima);
                AdicionarParametros("GrupoPoblacional", obj.GrupoPoblacional);
                AdicionarParametros("Cupo", obj.Cupo);
                AdicionarParametros("ServicioGratuito_1", obj.ServicioGratuito_1);
                AdicionarParametros("ServicioGratuito_2", obj.ServicioGratuito_2);
                AdicionarParametros("ServicioGratuito_3", obj.ServicioGratuito_3);
                AdicionarParametros("Fecha_horaActualizacion", obj.Fecha_horaActualizacion);
                AdicionarParametros("Usuario", obj.Usuario);
                AdicionarParametros("Estado", obj.Estado);
                AdicionarParametros("Fechacorte", obj.Fechacorte);
                AdicionarParametros("FechaEstado", obj.FechaEstado);
                AdicionarParametros("CodigoRegistro", obj.CodigoRegistro);

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
                AdicionarParametros("@Subcuenta", obj.Subcuenta);
                AdicionarParametros("@idOperacionServicio", obj.idOperacionoServicio);
                AdicionarParametros("@Canal", obj.Canal);
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
                AdicionarParametros("@Estado", obj.Estado);
                AdicionarParametros("@[FechaProceso", obj.FechaProceso);
                AdicionarParametros("@FechaEstado", obj.FechaEstado); AdicionarParametros("@UnidadCaptura", obj.UnidadCaptura);

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
                AdicionarParametros("Tipo", obj.Tipo);
                AdicionarParametros("Codigo", obj.Codigo);
                AdicionarParametros("Nombre", obj.Nombre);
                AdicionarParametros("NombreComercial", obj.NombreComercial);
                AdicionarParametros("AperturaDigital", obj.AperturaDigital);
                AdicionarParametros("NumeroClientes", obj.NumeroClientes);
                AdicionarParametros("Franquicia", obj.Franquicia);
                AdicionarParametros("CuotaManejo", obj.CuotaManejo);
                AdicionarParametros("ObservacionesCuota", obj.ObservacionesCuota);
                AdicionarParametros("CuotaManejoMaxima", obj.CuotaManejoMaxima);
                AdicionarParametros("GrupoPoblacional", obj.GrupoPoblacional);
                AdicionarParametros("Cupo", obj.Cupo);
                AdicionarParametros("ServicioGratuito_1", obj.ServicioGratuito_1);
                AdicionarParametros("ServicioGratuito_2", obj.ServicioGratuito_2);
                AdicionarParametros("ServicioGratuito_3", obj.ServicioGratuito_3);
                AdicionarParametros("Fecha_horaActualizacion", obj.Fecha_horaActualizacion);
                AdicionarParametros("Usuario", obj.Usuario);
                AdicionarParametros("Estado", obj.Estado);
                AdicionarParametros("Fechacorte", obj.Fechacorte);
                AdicionarParametros("FechaEstado", obj.FechaEstado);
                AdicionarParametros("CodigoRegistro", obj.CodigoRegistro);

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
