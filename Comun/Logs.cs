using System;
using System.IO;
using System.Reflection;
using System.Text;

namespace Comun
{
    public class Logs
    {
        #region Logs
        /// <summary>
        /// El tipo de log que escribiremos
        /// </summary>
        public enum Tipo
        {
            /// <summary>
            /// Cuando sucede un error
            /// </summary>
            Error,
            /// <summary>
            /// Cuando se quiere guardar el proceso
            /// </summary>
            Log,
            /// <summary>
            /// Cuando se quiere guardar una advertencia
            /// </summary>
            Advertencia
        }

        public static void EscribirLog(string pMensaje, Exception pEx)
        {
            try
            {
                string sExcep = CrearMensajeError(pEx);

                EscribirLog("", pMensaje + " " + sExcep ?? "", Tipo.Error);
            }
            catch (Exception e)
            {
                EscribirLog("Seguimiento", "Ocurrio un error en la escritura de log. " + e.Message + " " + pMensaje + pEx.Message ?? "", Tipo.Error);
            }
        }

        /// <summary>
        /// Metodo que escribe un txt con un mensaje
        /// </summary>
        /// <param name="Mensaje">Mensaje a escribir</param>
        public static void EscribirLog(MethodBase Nombre, string pMensaje, Exception pEx)
        {
            try
            {
                string sExcep = CrearMensajeError(pEx);

                EscribirLog(Nombre, pMensaje + " " + sExcep ?? "", Tipo.Error);
            }
            catch (Exception e)
            {
                EscribirLog(Nombre, "Ocurrio un error en la escritura de log. " + e.Message + " " + pMensaje + pEx.Message ?? "", Tipo.Error);
            }
        }

        /// <summary>
        /// Metodo que escribe un txt con un mensaje
        /// </summary>
        /// <param name="Mensaje">Mensaje a escribir</param>
        public static void EscribirLog(string Nombre, string pMensaje, Exception pEx)
        {
            try
            {
                string sExcep = CrearMensajeError(pEx);

                EscribirLog(Nombre, pMensaje + " " + sExcep ?? "", Tipo.Error);
            }
            catch (Exception e)
            {
                EscribirLog(Nombre, "Ocurrio un error en la escritura de log. " + e.Message + " " + pMensaje + pEx.Message ?? "", Tipo.Error);
            }
        }

        private static string CrearMensajeError(Exception pEx)
        {
            Exception Sub = pEx;
            int cnt = 0;
            StringBuilder Error = new StringBuilder();
            Error.AppendLine("");
            while (Sub != null)
            {
                string TargetSiteInt = Sub.TargetSite?.Name ?? "";
                string MensajeInt = Sub.Message ?? "";
                string FuenteInt = Sub.Source ?? "";

                Error.AppendLine("Metodo Interno: TargetSite " + cnt + ": " + TargetSiteInt + ", Mensaje Interno: " + cnt + ": " + MensajeInt + ", Fuente interna: " + cnt + ": " + FuenteInt);

                Sub = Sub.InnerException;

                cnt++;
            }

            return Error.ToString();
        }

        /// <summary>
        /// Metodo que escribe un txt con un mensaje
        /// </summary>
        /// <param name="Mensaje">Mensaje a escribir</param>
        public static void EscribirLog(MethodBase Nombre, string pMensaje, Tipo pTipo)
        {
            try
            {
                int EscribeLog = 0;

                if (pTipo == Tipo.Error)
                {
                    EscribeLog = 1;
                }
                else if (pTipo == Tipo.Log)
                {
                    EscribeLog = Tools.ParseoTexto(Tools.TraerConfiguracion("LogRealizar"));
                }

                if (EscribeLog == 1)
                {
                    EscribirDD(Nombre, pMensaje, pTipo);
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error ingreso " + pMensaje + ". Ocurrio un error en la escritura de log. ", e);
            }
        }

        /// <summary>
        /// Metodo que escribe un txt con un mensaje
        /// </summary>
        /// <param name="Mensaje">Mensaje a escribir</param>
        public static void EscribirLog(string Nombre, string pMensaje, Tipo pTipo)
        {
            try
            {
                int EscribeLog = 0;

                if (pTipo == Tipo.Error)
                {
                    EscribeLog = 1;
                }
                else if (pTipo == Tipo.Log)
                {
                    EscribeLog = Tools.ParseoTexto(Tools.TraerConfiguracion("LogRealizar"));
                }

                if (EscribeLog == 1)
                {
                    EscribirDD(Nombre, pMensaje, pTipo);
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error ingreso " + pMensaje + ". Ocurrio un error en la escritura de log. ", e);
            }
        }

        /// <summary>
        /// Metodo que escribe un txt con un mensaje
        /// </summary>
        /// <param name="Mensaje">Mensaje a escribir</param>
        public static void EscribirLog(string Nombre, Tipo pTipo)
        {
            try
            {
                int EscribeLog = 0;

                if (pTipo == Tipo.Error)
                {
                    EscribeLog = 1;
                }
                else if (pTipo == Tipo.Log)
                {
                    EscribeLog = Tools.ParseoTexto(Tools.TraerConfiguracion("LogRealizar"));
                }

                if (EscribeLog == 1)
                {
                    EscribirDD(Nombre, "", pTipo);
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error ingreso " + "" + ". Ocurrio un error en la escritura de log. ", e);
            }
        }

        #endregion

        #region Metodos auxiliares
        /// <summary>
        /// Escribe los mensajes en el disco duro
        /// </summary>
        /// <param name="pMensaje"></param>
        /// <param name="pTipo"></param>
        /// <param name="sNombreArc"></param>
        private static void EscribirDD(MethodBase Nombre, string pMensaje, Tipo pTipo)
        {
            try
            {
                if (string.IsNullOrEmpty(NombreLog))
                {
                    NombreLog = Tools.TraerConfiguracion("NombLog");
                }

                string DirLog = Tools.traerUbicacionLogs();
                string fecha = DateTime.Now.ToString("ddMMyyyy");

                if (!(Directory.Exists(DirLog)))
                {
                    Directory.CreateDirectory(DirLog);
                }

                if (!(Directory.Exists(DirLog + "\\" + fecha)))
                {
                    Directory.CreateDirectory(DirLog + "\\" + fecha);
                }

                if (pTipo == Tipo.Error)
                {
                    string sUbicacionE = DirLog + "\\" + fecha + @"\" + "Errores.txt";
                    sUbicacionE = sUbicacionE.Replace("\0", "");
                    using (StreamWriter w2 = new StreamWriter(sUbicacionE, true))
                    {
                        w2.WriteLine("------ " + pTipo.ToString() + " -------------Metodo: " + Nombre.Name + "-----Clase: " + Nombre.ReflectedType.FullName + "---------");
                        w2.WriteLine(DateTime.Now.ToString("HHmm") + ": _ " + pMensaje);
                        w2.Flush();
                        w2.Close();
                    }
                }

                string NombresLog = Tools.TraerConfiguracion("LogsActivos");
                string sUbicacion = DirLog + "\\" + fecha + @"\" + NombreLog;

                if (NombresLog.IndexOf(Nombre.ReflectedType.Name) != -1)
                {
                    sUbicacion += "_" + Nombre.ReflectedType.Name + ".txt";
                }
                else
                {
                    sUbicacion += "_LOGS.txt";
                }

                sUbicacion = sUbicacion.Replace("\0", "");
                sUbicacion = sUbicacion.Replace("+", "");
                using (StreamWriter w = new StreamWriter(sUbicacion, true))
                {
                    w.WriteLine("------ " + pTipo.ToString() + " -------------Metodo: " + Nombre.Name + "----- Clase: " + Nombre.ReflectedType.FullName + "--------------");
                    w.WriteLine(DateTime.Now.ToString("HHmm") + ": _ " + pMensaje);
                    w.Flush();
                    w.Close();
                }
            }
            catch (Exception e)
            {
                throw new Exception("Ocurrio un error en la escritura de log en disco duro. ", e);
            }
        }

        /// <summary>
        /// Escribe los mensajes en el disco duro
        /// </summary>
        /// <param name="pMensaje"></param>
        /// <param name="pTipo"></param>
        /// <param name="sNombreArc"></param>
        private static void EscribirDD(string Nombre, string pMensaje, Tipo pTipo)
        {
            try
            {
                if (string.IsNullOrEmpty(NombreLog))
                {
                    NombreLog = Tools.TraerConfiguracion("LogNombre");
                }

                string DirLog = Tools.traerUbicacionLogs();
                string fecha = DateTime.Now.ToString("ddMMyyyy");

                if (!(Directory.Exists(DirLog)))
                {
                    Directory.CreateDirectory(DirLog);
                }

                if (!(Directory.Exists(DirLog + "\\" + fecha)))
                {
                    Directory.CreateDirectory(DirLog + "\\" + fecha);
                }

                if (pTipo == Tipo.Error)
                {
                    string sUbicacionE = DirLog + "\\" + fecha + @"\" + "Errores.txt";
                    sUbicacionE = sUbicacionE.Replace("\0", "");
                    using (StreamWriter w2 = new StreamWriter(sUbicacionE, true))
                    {
                        w2.WriteLine("------ " + pTipo.ToString() + " -------------Metodo: " + Nombre + "---------");
                        w2.WriteLine(DateTime.Now.ToString("HHmm") + ": _ " + pMensaje);
                        w2.Flush();
                        w2.Close();
                    }
                }

                string NombresLog = Tools.TraerConfiguracion("LogsActivos");
                string sUbicacion = DirLog + "\\" + fecha + @"\" + NombreLog;

                if (NombresLog.IndexOf(Nombre) != -1)
                {
                    sUbicacion += "_" + Nombre + ".txt";
                }
                else
                {
                    sUbicacion += "_LOGS.txt";
                }

                sUbicacion = sUbicacion.Replace("\0", "");
                sUbicacion = sUbicacion.Replace("+", "");
                using (StreamWriter w = new StreamWriter(sUbicacion, true))
                {
                    w.WriteLine("------ " + pTipo.ToString() + " -------------Metodo: " + Nombre + "-------------------");
                    w.WriteLine(DateTime.Now.ToString("HHmm") + ": _ " + pMensaje);
                    w.Flush();
                    w.Close();
                }
            }
            catch (Exception e)
            {
                throw new Exception("Ocurrio un error en la escritura de log en disco duro. ", e);
            }
        }

        #endregion

        public static string NombreLog { get; set; }
    }
}
