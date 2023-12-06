using CapaModelo;
using Comun;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace BP.Repositorio
{
    public class DatosCreditos : ConexionMS
    {
        private static DatosCreditos instance = null;
        public static DatosCreditos Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosCreditos();
            }
            return instance;
        }

        static DatosCreditos()
        {

        }

        public static string Mensaje { get; private set; }

        public static List<ProductoCreditoModel> Tipos()
        {
            try
            {
                List<ProductoCreditoModel> rpt = new List<ProductoCreditoModel>();
                limpiarParametros();

                DataTable dt = ejecutarStoreProcedure("bpapp.spDominioCreditoProducto").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<ProductoCreditoModel>>(serializedObject);
                }

                return rpt;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw new Exception("Error en Tipos", ex);
            }
        }

        public static List<ProductoCreditoModel> Lista(int codigo)
        {
            try
            {
                List<ProductoCreditoModel> rpt = new List<ProductoCreditoModel>();
                limpiarParametros();
                AdicionarParametros("@idProductoCredito", codigo);
                AdicionarParametros("@tipoDominio", 1);
               
                DataTable dt = ejecutarStoreProcedure("bpapp.spDominioCreditoProducto").Tables[0];

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

                    rpt = JsonConvert.DeserializeObject<List<ProductoCreditoModel>>(serializedObject);
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

