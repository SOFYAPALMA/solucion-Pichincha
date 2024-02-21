using CapaModelo;
using Comun;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace BP.Repositorio
{
    public class DatosErroresSFC : ConexionMS
    {
        #region Comun
        private static DatosErroresSFC instance = null;

        public static DatosErroresSFC Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosErroresSFC();
            }

            return instance;
        }

        static DatosErroresSFC()
        {

        }
        #endregion
   

        public static Errores_SFCModel DetalleErroresSFC(string TReg, int idPropForm, int idRegDet, int form)
        {
            Instanciar();

            try
            {
                Errores_SFCModel rpt = new Errores_SFCModel();
                limpiarParametros();

                AdicionarParametros("@Tiporegistros", TReg);
                AdicionarParametros("@idPropiedadesFormato", idPropForm);
                AdicionarParametros("@idRegistrosDetalle", idRegDet);
                AdicionarParametros("@Formato", form);

                DataTable dt = ejecutarStoreProcedure("bpapp.spErroresEntregaSuper").Tables[0];

                if (dt.Rows.Count > 0)
                {
                    Dictionary<string, object> details = new Dictionary<string, object>();

                    foreach (DataRow row in dt.Rows)
                    {
                        var dictionary = new Dictionary<string, object>();
                        foreach (DataColumn column in dt.Columns)
                        {
                            dictionary[column.ColumnName] = row[column];
                        }

                        details = dictionary;
                    }

                    string serializedObject = JsonConvert.SerializeObject(details, new DatetimeToStringConverter());
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), serializedObject, Logs.Tipo.Log);

                    rpt = JsonConvert.DeserializeObject<Errores_SFCModel>(serializedObject);
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

