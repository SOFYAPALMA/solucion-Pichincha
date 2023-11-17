using CapaModelo;
using ProyectoWeb.Models;

namespace ProyectoWeb
{
    public class Mapper
    {
        public static Formulario424_Encabezado getMapper(Form424CrearEncabezado dto)
        {
            var result = new Formulario424_Encabezado()
            {
                Tipo = dto.Tipo,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                FechaHora = dto.FechaHora,
                NombreComercial = dto.NombreComercial,
                TipodeProductoDeposito = dto.TipodeProductoDeposito,
                AperturaDigital = dto.AperturaDigital,
                NumerodeClientesUnicos = dto.NumerodeClientesUnicos,
                CuotadeManejo = dto.CuotadeManejo,
                ObservacionesCuotadeManejo = dto.ObservacionesCuotadeManejo,
                GrupoPoblacional = dto.GrupoPoblacional,
                Ingresos = dto.Ingresos,
                ServicioGratuitoCuentadeAhorros1 = dto.ServicioGratuitoCuentadeAhorros1,
                ServicioGratuitoCuentadeAhorros2 = dto.ServicioGratuitoCuentadeAhorros2,
                ServicioGratuitoCuentadeAhorros3 = dto.ServicioGratuitoCuentadeAhorros3,
                ServicioGratuitoTarjetaDebito1 = dto.ServicioGratuitoTarjetaDebito1,
                ServicioGratuitoTarjetaDebito2 = dto.ServicioGratuitoTarjetaDebito2,
                ServicioGratuitoTarjetaDebito3 = dto.ServicioGratuitoTarjetaDebito3
            };

            return result;
        }
    }
}
