using CapaModelo;
using Comun;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace BP.Repositorio
{
    public class DatosAseguradoras : ConexionMS
    {
        private static DatosAseguradoras instance = null;

        public static DatosAseguradoras Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosAseguradoras();
            }
            return instance;
        }

        static DatosAseguradoras()
        {

        }

        public static string Mensaje { get; private set; }

        public static List<Aseguradoras> Lista()
        {
            try
            {
                List<Aseguradoras> rpt = new List<Aseguradoras>();
                limpiarParametros();
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);


                DataTable dt = ejecutarStoreProcedure("bpapp.spDominioAseguradoras").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    List<Dictionary<string,object>> list = new List<Dictionary<string, object>>();
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

                    rpt = JsonConvert.DeserializeObject<List<Aseguradoras>>(serializedObject);
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

