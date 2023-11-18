using CapaModelo;
using System;
using System.Data;

namespace BP.Repositorio
{
    public class DatosFormato424 : ConexionMS
    {
        #region Comun
        private static DatosFormato424 instance = null;

        public static DatosFormato424 Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosFormato424();
            }

            return instance;
        }

        static DatosFormato424()
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
                AdicionarParametros("TipoProductoDeposito", obj.TipodeProductoDeposito);
                AdicionarParametros("AperturaDigital", obj.AperturaDigital);
                AdicionarParametros("NumeroClientes", obj.NumerodeClientesUnicos);
                AdicionarParametros("CuotaManejo", obj.CuotadeManejo);
                AdicionarParametros("ObservacionesCuota", obj.ObservacionesCuotadeManejo);
                AdicionarParametros("GrupoPoblacional", obj.GrupoPoblacional);
                AdicionarParametros("Ingresos", obj.Ingresos);
                AdicionarParametros("SerGratuito_CtaAHO", obj.ServicioGratuitoCuentadeAhorros1);
                AdicionarParametros("SerGratuito_CtaAHO2", obj.ServicioGratuitoCuentadeAhorros2);
                AdicionarParametros("SerGratuito_CtaAHO3", obj.ServicioGratuitoCuentadeAhorros3);
                AdicionarParametros("SerGratuito_TCRDebito", obj.ServicioGratuitoTarjetaDebito1);
                AdicionarParametros("SerGratuito_TCRDebito2", obj.ServicioGratuitoTarjetaDebito2);
                AdicionarParametros("SerGratuito_TCRDebito3", obj.ServicioGratuitoTarjetaDebito3);
                AdicionarParametros("Usuario", obj.Usuario ?? "1");

                AdicionarParametrosOut("IndicadorTermina", SqlDbType.Int);
                AdicionarParametrosOut("IdPropiedadesFomato", SqlDbType.Int);
                AdicionarParametrosOut("MensajeSalida", SqlDbType.VarChar, 256);

                ejecutarScalar("bpapp.spInsertaPropiedadesDepositos");

                respuesta = RecuperarParametrosOut("IndicadorTermina") == "1" ? true : false;
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
