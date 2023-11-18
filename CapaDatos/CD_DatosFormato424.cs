using CapaModelo;
using System;
using System.Data;

namespace CapaDatos
{
    public class CD_DatosFormato424 : ConexionMS
    {
        #region Comun
        private static CD_DatosFormato424 instance = null;

        public static CD_DatosFormato424 Instanciar()
        {
            if (instance == null)
            {
                instance = new CD_DatosFormato424();
            }

            return instance;
        }

        static CD_DatosFormato424()
        {

        }
        #endregion
        public static string Mensaje { get; private set; }

        public static bool RegistrarEncabezado(Formulario424_Encabezado obj)
        {
            Instanciar();
            bool respuesta = false;

            try
            {
                limpiarParametros();
                AdicionarParametros("Tipo", obj.Tipo);
                AdicionarParametros("Codigo", obj.Codigo);
                AdicionarParametros("Nombre", obj.Nombre);
                AdicionarParametros("NombreComercial", obj.NombreComercial);
                AdicionarParametros("TipodeProductoDeposito", obj.TipodeProductoDeposito);
                AdicionarParametros("AperturaDigital", obj.AperturaDigital);
                AdicionarParametros("NumerodeClientesUnicos", obj.NumerodeClientesUnicos);
                AdicionarParametros("CuotadeManejo", obj.CuotadeManejo);
                AdicionarParametros("ObservacionesCuotadeManejo", obj.ObservacionesCuotadeManejo);
                AdicionarParametros("GrupoPoblacional", obj.GrupoPoblacional);
                AdicionarParametros("CuotadeManejo", obj.CuotadeManejo);
                AdicionarParametros("ServicioGratuitoCuentadeAhorros1", obj.ServicioGratuitoCuentadeAhorros1);
                AdicionarParametros("ServicioGratuitoCuentadeAhorros2", obj.ServicioGratuitoCuentadeAhorros2);
                AdicionarParametros("ServicioGratuitoCuentadeAhorros3", obj.ServicioGratuitoCuentadeAhorros3);
                AdicionarParametros("ServicioGratuitoTarjetaDebito1", obj.ServicioGratuitoTarjetaDebito1);
                AdicionarParametros("ServicioGratuitoTarjetaDebito2", obj.ServicioGratuitoTarjetaDebito2);
                AdicionarParametros("ServicioGratuitoTarjetaDebito3", obj.ServicioGratuitoTarjetaDebito3);
                AdicionarParametros("Ingresos", obj.Ingresos);

                AdicionarParametrosOut("IndicadorTermina");
                AdicionarParametrosOut("IdPropiedadesFomato");
                AdicionarParametrosOut("MensajeSalida");

                DataTable dtFlujos = ejecutarStoreProcedure("bpapp.spInsertaPropiedadesDepositos").Tables[0];

                respuesta = Convert.ToBoolean(RecuperarParametrosOut("Resultado"));
                Mensaje = RecuperarParametrosOut("MensajeSalida");
            }
            catch (Exception ex)
            {
                throw new Exception("Error en RegistrarEncabezado", ex);
            }

            return respuesta;
        }
    }
}
