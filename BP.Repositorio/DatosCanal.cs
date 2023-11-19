using CapaModelo;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace BP.Repositorio
{
    public class DatosCanal : ConexionMS
    {
        #region Comun
        private static DatosCanal instance = null;

        public static DatosCanal Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosCanal();
            }

            return instance;
        }

        static DatosCanal()
        {

        }
        #endregion
        public static string Mensaje { get; private set; }

        public static List<Canal> Lista()
        {
            try
            {
                List<Canal> rpt = new List<Canal>();
                limpiarParametros();
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);

                DataTable dt = ejecutarStoreProcedure("bpapp.spConsultaCanal").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<Canal>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en Lista", ex);
            }
        }
    }
}
