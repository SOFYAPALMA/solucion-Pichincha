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
    }
}
