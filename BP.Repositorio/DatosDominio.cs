using CapaModelo;
using Comun;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace BP.Repositorio
{
    public class DatosDominio : ConexionMS
    {
        #region Comun
        private static DatosDominio instance = null;

        public static DatosDominio Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosDominio();
            }

            return instance;
        }

        static DatosDominio()
        {

        }
        #endregion
        public static string Mensaje { get; private set; }

        public static bool RegistrarEncabezado(TipoDominioModel obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();

                AdicionarParametros("Descripcion", obj.Descripcion);


                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaTipoDominio");

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

        public static bool RegistrarDetalle(DominioModel obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("@idDominio", obj.idDominio);
                AdicionarParametros("@idCodigo", obj.idCodigo);
                AdicionarParametros("@Descripcion", obj.Descripcion);

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaDominios");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
                Mensaje = RecuperarParametrosOut("MensajeSalida");
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Mensaje, Logs.Tipo.Log);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en RegistrarDetalle", ex);
            }

            return respuesta;
        }
        public static List<DominioModel> Obtener(int TipoDominio)
        {
            try
            {
                List<DominioModel> rpt = new List<DominioModel>();

                DataTable dt = EjecutarSql("SELECT * FROM BPAPP.fntraevaloresdominio(" + TipoDominio + ")", "tbl").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<DominioModel>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en Obtener", ex);
            }
        }

        public static List<DominioModel> ListaDominios(int id)
        {
            Instanciar();

            try
            {
                List<DominioModel> rpt = new List<DominioModel>();
                limpiarParametros();
                AdicionarParametros("@idDominio", id);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaDominios").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<DominioModel>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en ListaDominios", ex);
            }
        }

        public static List<TipoDominioModel> ListaTiposDominios()
        {
            Instanciar();

            try
            {
                List<TipoDominioModel> rpt = new List<TipoDominioModel>();
                limpiarParametros();

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaTiposDominios").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<TipoDominioModel>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en Lista", ex);
            }
        }

        public static TipoDominioModel DetalleTipoDominio(int id)
        {
            Instanciar();

            try
            {
                TipoDominioModel rpt = new TipoDominioModel();
                limpiarParametros();
                AdicionarParametros("@idDominio", id);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaTiposDominios").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    var dictionary = new Dictionary<string, object>();
                    foreach (DataColumn column in dt.Columns)
                    {
                        dictionary[column.ColumnName] = dt.Rows[0][column];
                    }

                    string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<TipoDominioModel>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en Lista", ex);
            }
        }
    }
}
