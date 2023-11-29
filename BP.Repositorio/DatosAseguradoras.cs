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

        public static Aseguradoras DetallesDetalles(int asg)
        {
            try
            {
                Aseguradoras rpt = new Aseguradoras();
                limpiarParametros();
                AdicionarParametros("idtipo", asg);
                AdicionarParametros("idcodigo", asg);
                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Bit);


                DataTable dt = ejecutarStoreProcedure("bpapp.spDominioAseguradoras").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    var dictionary = new Dictionary<string, object>();
                    foreach (DataColumn column in dt.Columns)
                    {
                        dictionary[column.ColumnName] = dt.Rows[0][column];
                    }

                    string serializedObject = JsonConvert.SerializeObject(dictionary, new DatetimeToStringConverter());
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<Aseguradoras>(serializedObject);
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

