using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

namespace Comun
{
    class Tools
    {
        #region Comun
        private static Tools instance = null;

        public static Tools Instanciar()
        {
            if (instance == null)
            {
                instance = new Tools();
            }

            return instance;
        }
        #endregion

        #region Conexion

        /// <summary>
        /// Trae la ubicacion de los logs en la maquina servidor 
        /// </summary>
        /// <returns></returns>
        public static string traerUbicacionLogs()
        {
            try
            {
                string ubiLogs = TraerConfiguracion("LogPath");

                if (ubiLogs == "")
                {
                    ubiLogs = @"C:\Temp";
                }

                return ubiLogs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Trae un parametro del archivo de configuración
        /// </summary>
        /// <param name="key">Parametro a traer</param>
        /// <returns>El valor de la key</returns>
        public static string TraerConfiguracion(string key)        
        {
            return ConfigurationManager.AppSettings[key] ?? "";
        }

        #endregion

        #region Controles de listas

        /// <summary>
        /// Con este metodo se carga el FormView deseado
        /// </summary>
        /// <param name="ctrCargar">FormView a cargar</param>
        /// <param name="dvCargado">datos para el control</param>
        public static void cargarFormView(FormView ctrCargar, DataView dvCargado)
        {
            ctrCargar.DataSource = dvCargado;
            ctrCargar.DataBind();
        }

        /// <summary>
        /// Inserta el elemento por defecto para el dropdownlist dado ("Seleccione..." valor "-1")
        /// </summary>
        /// <param name="ddl">Dropdown para hacer la inserción</param>
        public static void InsertDefaultValue(DropDownList ddl)
        {
            ddl.Items.Insert(0, new ListItem("Seleccione...", "-1"));
            //ddl.Items.Insert(1, new ListItem("No Aplica", "-2"));
        }

        /// <summary>
        /// Carga con los datos especificados el Control de listas especificado y los ordena de acuerdo a la columna que llevará el texto y si se autohabilitará el control de destino
        /// </summary>
        /// <param name="control">El control ha ser llenado</param>
        /// <param name="dv">El nombre de la dataview con los datos de origen</param>
        /// <param name="nombreColumnaValor">El nombre de la columna que asignará el valor a las entradas</param>
        /// <param name="nombreColumnaMostrar">El nombre de la columna que asignará el texto a las entradas</param>
        /// <param name="nombreColumnaOrdenar">Nombre de la columna en la tabla que será usada para el ordenamiento</param>
        public static void cargarControlDListas(ListControl control, DataView dv, string nombreColumnaValor, string nombreColumnaMostrar, string nombreColumnaOrdenar)
        {
            dv.Sort = nombreColumnaOrdenar;
            if (dv.Count > 0)
            {
                control.DataSource = dv;
                control.DataTextField = nombreColumnaMostrar;
                control.DataValueField = nombreColumnaValor;
                control.DataBind();
            }
            else
            {
                control.Items.Clear();
            }

            if (control is DropDownList)
            {
                InsertDefaultValue((DropDownList)control);
            }
        }

        /// <summary>
        /// Carga con los datos especificados el Control de listas especificado y los ordena de acuerdo a la columna que llevará el texto y si se autohabilitará el control de destino
        /// </summary>
        /// <param name="control">El control ha ser llenado</param>
        /// <param name="List">El nombre de la lista con los datos de origen</param>
        /// <param name="nombreColumnaValor">El nombre de la columna que asignará el valor a las entradas</param>
        /// <param name="nombreColumnaMostrar">El nombre de la columna que asignará el texto a las entradas</param>
        public static void cargarControlDListas(ListControl control, IList pList, string nombreColumnaValor, string nombreColumnaMostrar)
        {
            if (pList.Count > 0)
            {
                control.DataSource = pList;
                control.DataTextField = nombreColumnaMostrar;
                control.DataValueField = nombreColumnaValor;
                control.DataBind();
            }
            else
            {
                control.Items.Clear();
            }

            if (control is DropDownList)
            {
                InsertDefaultValue((DropDownList)control);
            }
        }

        /// <summary>
        /// Carga con los datos especificados el Control de listas especificado y si se autohabilitará el control de destino
        /// </summary>
        /// <param name="control">El control ha ser llenado</param>
        /// <param name="List">El nombre de la Lista con los datos de origen</param>
        public static void cargarControlDListas(ListControl control, IList List)
        {
            if (List.Count > 0)
            {
                control.DataSource = List;
                control.DataBind();
            }
            else
            {
                control.Items.Clear();
            }

            if (control is DropDownList)
            {
                InsertDefaultValue((DropDownList)control);
            }
        }

        /// <summary>
        /// Parsea un control list y devuelve el valor entero equivalente
        /// </summary>
        /// <param name="listControl"></param>
        /// <returns>valor entero equivalente</returns>
        public static Nullable<int> ParseListControl(ListControl listControl)
        {
            int selval = -1;
            if (int.TryParse(listControl.SelectedValue, out selval) && selval >= 0) return selval;
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="listControl"></param>
        /// <returns></returns>
        public static int ParseListControlNative(ListControl listControl)
        {
            int selval = -1;
            int.TryParse(listControl.SelectedValue, out selval);
            return selval;
        }

        /// <summary>
        /// Ordena los Items de un Control ListBox de la A a la Z, cuando sus items son repetidos y 
        /// su clave o valor es diferente. No retorna valor.
        /// </summary>
        /// <param name="ControlListBox">Control ListBox a ordenar.</param>
        public static void OrdenarItemsListBoxItemsRepetidos(ListBox ControlListBox)
        {
            SortedList sl = new SortedList();
            foreach (ListItem li in ControlListBox.Items)
            {
                sl.Add(li.Text + "." + li.Value, li.Value);
            }
            ControlListBox.Items.Clear();
            foreach (DictionaryEntry key in sl)
            {
                ListItem item = new ListItem();
                string[] texto = SepararARegistro(key.Key.ToString(), 46);
                item.Text = texto[0];
                item.Value = key.Value.ToString();
                ControlListBox.Items.Add(item);
            }
            //ControlListBox.DataSource = sl;
            //ControlListBox.DataValueField = "Value";
            //ControlListBox.DataTextField = "Key";
            //ControlListBox.DataBind();
        }

        /// <summary>
        /// Ordena los Items de un Control ListBox de la A a la Z. No retorna valor.
        /// </summary>
        /// <param name="ControlListBox">Control ListBox a ordenar.</param>
        public static void OrdenarItemsListBoxItems(ListBox ControlListBox)
        {
            SortedList sl = new SortedList();
            foreach (ListItem li in ControlListBox.Items)
            {
                sl.Add(li.Text, li.Value);
            }
            ControlListBox.DataSource = sl;
            ControlListBox.DataValueField = "Value";
            ControlListBox.DataTextField = "Key";
            ControlListBox.DataBind();
        }
        #endregion ListControls

        #region Parceo

        /// <summary>
        /// Valida que un valor sea diferente a sus valores por defecto, vacio o nulo
        /// </summary>
        /// <param name="valor">el valor que se desea validar</param>
        /// <returns>True si el valor viene por defecto, vacio o nulo, False si tiene un valor</returns>
        public static bool ValidarObligatorio(object valor)
        {
            bool retorno = false;

            try
            {
                if (valor == null)
                {
                    retorno = true;
                }
                else if (valor.GetType().Name == "String")
                {
                    if (valor.ToString().Trim() == "")
                    {
                        retorno = true;
                    }
                }
                else if (valor.GetType().Name == "String[]")
                {
                    string[] valor1 = (string[])valor;
                    if (valor1.Count() == 0)
                    {
                        retorno = true;
                    }
                }
                else if (valor.GetType().Name.IndexOf("Int") != -1)
                {
                    if (EqualityComparer<int>.Default.Equals((int)valor, default(int)))
                    {
                        retorno = true;
                    }
                }
                else if (valor.GetType().Name == "Double")
                {
                    if (EqualityComparer<double>.Default.Equals((double)valor, default(double)))
                    {
                        retorno = true;
                    }
                }
                else if (valor.GetType().Name == "DateTime")
                {
                    if (EqualityComparer<DateTime>.Default.Equals((DateTime)valor, default(DateTime)))
                    {
                        retorno = true;
                    }
                }
                else
                {
                    throw new NotImplementedException();
                }

                return retorno;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(),"Error en [ValidarObligatorio]. Detalle: ", ex);
                return true;
            }
        }

        /// <summary>
        /// Convierte el valor al tipo T
        /// Validar que sea un valor diferente del default EqualityComparer<T>.Default.Equals(variable, default(T))
        /// </summary>
        /// <typeparam name="T">El tipo que se desea convertir</typeparam>
        /// <param name="v">el valor que se desea convertir</param>
        /// <returns>El tipo convertido o su valor Default</returns>
        public static T Convertir<T>(object v)
        {
            try
            {
                return (T)Convert.ChangeType(v, typeof(T));
            }
            catch
            {
                return (T)Activator.CreateInstance(typeof(T));
            }
        }


        /// <summary>
        /// Convierte un Json una lista del Tipo determinado
        /// </summary>
        /// <typeparam name="T">Tipo al que se desea convertir el JSON</typeparam>
        /// <param name="Data">string que contiene el Json</param>
        /// <returns>una lista del  Tipo al que se desea convertir</returns>
        public static List<T> ConVertirJson<T>(string Data)
        {
            List<T> Collection = new List<T>();
            List<string> strCollection = new List<string>();
            try
            {
                Data = Data.Replace("[", "").Replace("]", "");
                Data = Data.Replace("}", "}|");
                strCollection = (Data.Split('|')).ToList();
                foreach (string item in strCollection)
                {
                    if (!string.IsNullOrEmpty(item))
                    {
                        string Value = item.Replace(",{", "{").Replace("},", "}");
                        Collection.Add(JsonConvert.DeserializeObject<T>(Value));
                    }
                }
                return Collection;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(),"Error en [List<T> ConVertirJson<T>]. Detalle: ", ex);
                return Collection;
            }
        }

        /// <summary>
        /// Convierte una fecha Json un string
        /// </summary>
        /// <param name="Data">string que contiene la fecha serializada en Json</param>
        /// <returns>string o null</returns>
        public static string DateJsonToString(string Fecha)
        {
            try
            {
                string sa = @"""" + Fecha + @"""";

                DateTime dt = new DateTime();
                dt = JsonConvert.DeserializeObject<DateTime>(sa);

                return dt.ToString();
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(),"Error en DateJsonToString. Detalle: ", ex);
                return null;
            }
        }

        /// <summary>
        /// Convierte un dataTable a un JSON
        /// </summary>
        /// <param name="Data">DataTable</param>
        /// <returns>Retorna el JSON en un string</returns>
        public static string ConVertirJson(DataTable Data)
        {
            string StrJSON = "";
            try
            {
                StrJSON = JsonConvert.SerializeObject(Data);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(),"Error en [ConVertirJson]. Detalle: ", ex);
            }

            return StrJSON;
        }

        /// <summary>
        /// Convierte un object a un string Json
        /// </summary>
        /// <param name="Data">objeto a convertir</param>
        /// <returns>string json</returns>
        public static string ConVertirJson(object Data)
        {
            string StrJSON = "";
            try
            {
                StrJSON = JsonConvert.SerializeObject(Data);
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(),"Error en [ConVertirJson]. Detalle: ", ex);
            }

            return StrJSON;
        }

        /// <summary>
        /// Parsea un texto a entero
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>Entero con el valor convertido</returns>
        public static int ParseoTexto(object pTxt)
        {
            int ret;
            try
            {
                string txt = pTxt.ToString();
                return int.TryParse(txt, out ret) ? ret : -1;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(),"Error en [ParceoTexto]. Detalle: ", ex);
                return -1;
            }
        }

        /// <summary>
        /// Parsea un texto a entero
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>Entero con el valor convertido</returns>
        public static int? ParseoTextoANull(object pTxt)
        {
            int ret;
            try
            {
                string txt = pTxt.ToString();

                int valor = int.TryParse(txt, out ret) ? ret : -1;

                if (valor != -1)
                {
                    return ret;
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(),"Error en [ParceoTextoANull]. Detalle: ", ex);
                return -1;
            }
        }

        /// <summary>
        /// Parsea un texto a entero
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>Entero con el valor convertido</returns>
        public static float ParseoTextoAFloat(object pTxt)
        {
            float ret;
            try
            {
                string txt = pTxt.ToString();
                return float.TryParse(txt, out ret) ? ret : -1;
            }
            catch (Exception ex)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(),"Error en [ParseoTextoAFloat]. Detalle: ", ex);
                return -1;
            }
        }

        /// <summary>
        /// Parsea un texto proveniente de un textbox
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>Double con el valor convertido</returns>
        public static double ParseoTextoADouble(string txt)
        {
            double ret;
            return double.TryParse(txt, out ret) ? ret : 0;
        }

        /// <summary>
        /// Parsea un texto a decimal
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>El decimal con el valor convertido</returns>
        public static decimal? ParseoTextoADecimalNull(string txt)
        {
            decimal ret;

            if (decimal.TryParse(txt, out ret))
            {
                return ret;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Parsea un texto a decimal
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>El decimal con el valor convertido</returns>
        public static decimal ParseoTextoADecimal(string txt)
        {
            decimal ret;

            if (txt.IndexOf(",") != -1)
            {
                txt = txt.Replace(".", "");
                txt = txt.Replace(",", ".");
            }
            return decimal.TryParse(txt, System.Globalization.NumberStyles.Number, System.Globalization.CultureInfo.InvariantCulture, out ret) ? ret : -1;
        }

        /// <summary>
        /// Parsea un texto a decimal
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>El decimal con el valor convertido</returns>
        public static decimal? ParseoTextoADecimalCero(object txt)
        {
            decimal ret;
            if (txt != null)
            {
                return decimal.TryParse(txt.ToString(), out ret) ? ret : 0;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// Parsea un texto a decimal
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>El decimal con el valor convertido</returns>
        public static decimal ParseoTextoADecimalCero(string txt)
        {
            decimal ret;
            if (txt != null)
            {
                return decimal.TryParse(txt.ToString(), out ret) ? ret : 0;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// Parsea un texto a bool
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>el bool con el valor convertido o false si tiene algun error</returns>
        public static bool ParseoTextoABool(string txt)
        {
            bool ret;
            return bool.TryParse(txt, out ret) ? ret : false;
        }

        /// <summary>
        /// Parsea un texto a fecha
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>el bool con el valor convertido o la fecha del dia si no se puede convertir</returns>
        public static DateTime ParseoTextoAFecha(string txt)
        {
            DateTime ret;

            return DateTime.TryParse(txt, out ret) ? ret : DateTime.Now;
        }

        /// <summary>
        /// Parsea un texto a TimeSpan
        /// </summary>
        /// <param name="txt">la cadena de caracteres</param>
        /// <returns>el bool con el valor convertir</returns>
        public static bool ParseoTextoATime(string txt)
        {
            TimeSpan ret;
            return TimeSpan.TryParse(txt, out ret);
        }

        /// <summary>
        /// Quita los ceros que tenga 
        /// </summary>
        /// <param name="txt">texto de donde se va a estraer</param>
        /// <returns>Entero sin los ceros</returns>
        public static int QuitarCeros(string txt)
        {
            int ret;
            if (txt.StartsWith("0"))
                txt.Replace("0", "");
            return int.TryParse(txt, out ret) ? ret : -1;

        }
        #endregion

        #region Ayudas

        /// <summary>
        /// Corta el numero de carateres indicados en el valor ingresado
        /// </summary>
        /// <param name="Valor">Valor ingresado para cortar</param>
        /// <param name="Cortar">Numero de caracteres finales a cortar</param>
        /// <returns>El valor ingresado menos los caracteres eliminados.</returns>
        public static string CortarUltimoValor(string Valor, int Cortar)
        {
            if (Valor != null)
            {
                int lenV = Valor.Length;

                if (Cortar < lenV)
                {
                    Valor = Valor.Remove(lenV - Cortar, Cortar);
                }
            }

            return Valor;
        }

        /// <summary>
        /// Metodo que parte un registro de datos por un valor ancii
        /// </summary>
        /// <param name="valor">string que contiene cierta cantidad de caracteres</param>
        /// <param name="ancii">Valor de ancii por el cual se va a separar. </param>
        /// <returns>un arreglo de valores que contendra por si solo los registros</returns>
        public static string[] SepararARegistro(string valor, int ancii)
        {
            if (valor != null)
            {
                char[] chr = { (char)ancii };
                int valoresVacios = 0;
                string[] substring = valor.Split(chr); //valor.Split(chr35, StringSplitOptions.None);
                foreach (string val in substring)
                {
                    if (val == "" || val.Length <= 0)
                    {
                        valoresVacios++;
                    }
                }

                string[] resultado = new string[(substring.Length - valoresVacios)];
                int cont = 0;
                for (int i = 0; i < substring.Length; i++)
                {

                    if (substring[i] != "" && substring[i].Length > 0)
                    {
                        resultado[cont] = substring[i];
                        cont++;
                    }
                }
                return resultado;
            }
            else
            {
                string[] result = { };

                return result;
            }
        }

        [System.Runtime.InteropServices.DllImport("KERNEL32.DLL", EntryPoint = "GetPrivateProfileStringW", SetLastError = true,
        CharSet = System.Runtime.InteropServices.CharSet.Unicode, ExactSpelling = true, CallingConvention = System.Runtime.InteropServices.CallingConvention.StdCall)]
        private static extern int GetPrivateProfileString(string lpAppName, string lpKeyName, string lpDefault, string lpReturnString, int nSize, string lpFilename);

        /// <summary>
        /// Devuelve el valor de una clave de un fichero INI
        /// </summary>
        /// <param name="seccion">La sección de la que se quiere leer</param>
        /// <param name="KeyNombre">Clave</param>
        /// <param name="nombreArch">El fichero INI</param>
        /// <param name="opcional">Valor opcional que devolverá si no se encuentra la clave</param>
        /// <returns>El valor de la cleve de la seccion deseada</returns>
        /// <remarks></remarks>
        public static string ReadStringIni(string seccion, string KeyNombre, string nombreArch, string opcional)
        {
            int ret;
            string sRetVal, resultad;
            resultad = "";
            try
            {
                sRetVal = new string(' ', 1024);

                if (File.Exists(nombreArch))
                {
                    ret = GetPrivateProfileString(seccion, KeyNombre, opcional, sRetVal, sRetVal.Length, nombreArch);

                    foreach (char tmp in sRetVal.ToCharArray())
                    {
                        resultad = resultad + tmp.ToString();
                    }

                    if (ret == 0)
                    {
                        return opcional;
                    }
                    else
                    {
                        return resultad.Trim();
                    }
                }
                else
                {
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "No existe el archivo Ini de configuracion, revise la ubicacion en el web.config", Logs.Tipo.Error);
                    return opcional;
                }
            }
            catch
            {
                return opcional;
            }
        }

        #endregion
    }
}
