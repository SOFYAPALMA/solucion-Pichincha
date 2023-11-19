using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;

namespace ProyectoWeb
{
    public class Mapper
    {
        public static Formulario424_EncabezadoCrear getMapper(Form424CrearEncabezado dto)
        {
            var result = new Formulario424_EncabezadoCrear()
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

        public static List<Form424ConsultaEncabezado> getMapper(List<Formulario424_EncabezadoConsulta> obj)
        {
            List<Form424ConsultaEncabezado> result = new List<Form424ConsultaEncabezado>();

            foreach (Formulario424_EncabezadoConsulta consulta in obj)
            {
                Form424ConsultaEncabezado encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        public static Form424ConsultaEncabezado getMapper(Formulario424_EncabezadoConsulta obj)
        {
            var result = new Form424ConsultaEncabezado()
            {
                FechaHora = obj.FechaHora,
                AperturaDigital = obj.AperturaDigital,
                Codigo = obj.Codigo,
                CodigoRegistro = obj.CodigoRegistro,
                CuotaManejo = obj.CuotaManejo,
                Estado = obj.Estado,
                Fecha_horaActualizacion = obj.Fecha_horaActualizacion,
                Fechacorte = obj.Fechacorte,
                FechaEstado = obj.FechaEstado,
                GrupoPoblacional = obj.GrupoPoblacional,
                idAperturaDigital = obj.idAperturaDigital,
                idGrupoPoblacional = obj.idGrupoPoblacional,
                idIngresos = obj.idIngresos,
                idObservacionesCuota = obj.idObservacionesCuota,
                idPropiedadesFormato = obj.idPropiedadesFormato,
                idPropiedadesFormatoAnterior = obj.idPropiedadesFormatoAnterior,
                idSerGratuito_CtaAHO = obj.idSerGratuito_CtaAHO,
                idSerGratuito_CtaAHO2 = obj.idSerGratuito_CtaAHO2,
                idSerGratuito_CtaAHO3 = obj.idSerGratuito_CtaAHO3,
                idSerGratuito_TCRDebito = obj.idSerGratuito_TCRDebito,
                idSerGratuito_TCRDebito2 = obj.idSerGratuito_TCRDebito2,
                idSerGratuito_TCRDebito3 = obj.idSerGratuito_TCRDebito3,
                idTipoProductoDeposito = obj.idTipoProductoDeposito,
                Ingresos = obj.Ingresos,
                Nombre = obj.Nombre,
                NombreComercial = obj.NombreComercial,
                NumeroClientes = obj.NumeroClientes,
                ObservacionesCuota = obj.ObservacionesCuota,
                SerGratuito_CtaAH1 = obj.SerGratuito_CtaAH1,
                SerGratuito_CtaAH2 = obj.SerGratuito_CtaAH2,
                SerGratuito_CtaAH3 = obj.SerGratuito_CtaAH3,
                SerGratuito_TCRDebito1 = obj.SerGratuito_TCRDebito1,
                SerGratuito_TCRDebito2 = obj.SerGratuito_TCRDebito2,
                SerGratuito_TCRDebito3 = obj.SerGratuito_TCRDebito3,
                Tipo = obj.Tipo,
                TipoProductoDeposito = obj.TipoProductoDeposito,
                Usuario = obj.Usuario
            };
            return result;
        }

        public static Formulario424_EncabezadoActualizar getMapper(Form424ConsultaEncabezado dto)
        {
            var result = new Formulario424_EncabezadoActualizar()
            {
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Tipo = dto.Tipo,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                Usuario = dto.Usuario,
                FechaHora = dto.FechaHora,
                NombreComercial = dto.NombreComercial,
                CodigoRegistro = dto.CodigoRegistro,
                CuotaManejo = dto.CuotaManejo,
                Estado = dto.Estado,
                Fecha_horaActualizacion = dto.Fecha_horaActualizacion,
                Fechacorte = dto.Fechacorte,
                FechaEstado = dto.FechaEstado,
                idAperturaDigital = dto.idAperturaDigital,
                idGrupoPoblacional = dto.idGrupoPoblacional,
                idIngresos = dto.idIngresos,
                idObservacionesCuota = dto.idObservacionesCuota,
                idPropiedadesFormatoAnterior = dto.idPropiedadesFormatoAnterior,
                idSerGratuito_CtaAHO = dto.idSerGratuito_CtaAHO,
                idSerGratuito_CtaAHO2 = dto.idSerGratuito_CtaAHO2,
                idSerGratuito_CtaAHO3 = dto.idSerGratuito_CtaAHO3,
                idSerGratuito_TCRDebito = dto.idSerGratuito_TCRDebito,
                idSerGratuito_TCRDebito2 = dto.idSerGratuito_TCRDebito2,
                idSerGratuito_TCRDebito3 = dto.idSerGratuito_TCRDebito3,
                idTipoProductoDeposito = dto.idTipoProductoDeposito,
                NumeroClientes = dto.NumeroClientes
            };
            return result;
        }
    }
}
