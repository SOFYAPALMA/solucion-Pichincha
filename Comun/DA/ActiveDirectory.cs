using Comun.DA;
using System;
using System.DirectoryServices;

namespace Comun.DA1
{
    /// <summary>
    /// Clase para traer datos del active directory
    /// </summary>
    public class ActiveDirectory
    {
        private ADSettings _settings;

        public ActiveDirectory(ADSettings settings)
        {
            _settings = settings;
        }

        /// <summary>
        /// metodo para validar el usuario
        /// </summary>
        /// <param name="clave">Clave del usuario</param>
        /// <param name="usuario">Nombre del usuario</param>
        /// <returns>un booleano</returns>
        public bool ValidacionUsuario(string clave, string usuario)
        {
            bool aceptaClave = true;
            Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Ingreso a ValidacionUsuario: Usuario: " + usuario, Logs.Tipo.Log);
            string adPath = _settings.Path;
            Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Path: " + adPath, Logs.Tipo.Log);
            try
            {
                //usuario = TraerConfiguracion("UsuarioLDAP", ubicacion);
                //clave = TraerConfiguracion("ClaveLDAP", ubicacion);
                string domain = _settings.Server;
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Dominio: " + domain, Logs.Tipo.Log);
                string domainAndusuario = domain + @"\" + usuario;
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Dominio y Usuario: " + domainAndusuario, Logs.Tipo.Log);

                DirectoryEntry entry = new DirectoryEntry(adPath, domainAndusuario, clave);
                try
                {
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Directorio Activo: NativeObject", Logs.Tipo.Log);
                    // Bind to the native AdsObject to force authentication.
                    object obj = entry.NativeObject;
                    return aceptaClave;
                }
                catch (Exception e)
                {
                    Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Error en ValidacionUsuario contra el directorio activo. " + e.Message, Logs.Tipo.Log);
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ValidacionUsuario directorio activo", ex);
            }
        }

        /// <summary>
        /// metodo para validar el usuario, con autenticacion segura
        /// </summary>
        /// <param name="clave">Clave del usuario ldap</param>
        /// <param name="usuario">Nombre del usuario ldap</param>
        /// <param name="UsuarioBusqueda">Usuario que se va a buscar puede ser el mismo que autentica</param>
        /// <returns>un booleano</returns>
        public bool ValidacionUsuario(string clave, string usuario, string UsuarioBusqueda)
        {
            string ldap = _settings.Server;
            string strSearchAD = "";

            Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Ingreso a ValidacionUsuario: Usuario: " + usuario + " UsuarioBusqueda: " + UsuarioBusqueda, Logs.Tipo.Log);

            strSearchAD += "(sAMAccountName=" + UsuarioBusqueda + ")";

            DirectoryEntry adEntry = new DirectoryEntry(ldap, usuario, clave, AuthenticationTypes.Secure);

            DirectorySearcher adSearch = new DirectorySearcher(adEntry);

            adSearch.Filter = "(&(objectClass=user)" + strSearchAD + ")";
            SearchResultCollection objResultados;

            try
            {
                objResultados = adSearch.FindAll();
                return true;
            }
            catch (Exception e)
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), "Error en ValidacionUsuario 2 contra el directorio activo. " + e.Message, Logs.Tipo.Log);

                return false;
            }
        }

    }
}
