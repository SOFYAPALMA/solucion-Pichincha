using System;
using System.DirectoryServices;

namespace Comun.DA
{
    public class ADManagment : IADManagment
    {
        private ADSettings _settings;

        public ADManagment(ADSettings settings)
        {
            _settings = settings;
        }

        /// <summary>
        /// Realiza la validación de un usuario de un dominio especifico
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public bool IsValidUser(string userName, string password)
        {

            bool isValid = false;
            string indiceLlave = string.Empty;
            string server = _settings.Server;
            bool encontado = !string.IsNullOrEmpty(server);
            int indice = 0;

            while (encontado)
            {
                encontado = !string.IsNullOrEmpty(server);
                if (!encontado)
                    continue;

                if (_settings.AllowADAuth)
                {
                    string? domain = _settings.Domain;
                    try
                    {
                        string directory = "LDAP://" + server;
                        string domainUser = domain + @"\" + userName;
                        DirectoryEntry entry = new DirectoryEntry(directory, domainUser, password, AuthenticationTypes.None);
                        object nativeObject = entry.NativeObject;
                        isValid = true;
                        break;
                    }
                    catch (Exception ex)
                    {
                        Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Error gestionado, si el AD esta OK validar mas a detalle.", ex);
                        //No hubo éxito
                        isValid = false;
                        encontado = false;
                    }
                }
                indice++;
                indiceLlave = indice.ToString();
            }

            return isValid;
        }

    }
}
