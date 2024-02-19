using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form424ConsultaEncabezado
    {
        [Display(Name = "Fecha Hora")]
        public DateTime FechaHora { get; set; }

        [Display(Name = "Apertura Digital")]
        public string AperturaDigital { get; set; }

        [Display(Name = "Codigo")]
        public string Codigo { get; set; } = "00057"; //Campo fijo por default= 00057

        [Display(Name = "Registro SFC")]
        public string CodigoRegistro { get; set; }

        [Display(Name = "Cuota Manejo")]
        public int? CuotaManejo { get; set; }
        public string Estado { get; set; }

        [Display(Name = "Estado")]
        public string DescripcionEstado { get; set; }

        [Display(Name = "Fecha")]
        public string Fecha_horaActualizacion { get; set; }
        public string Fechacorte { get; set; }
        public string FechaEstado { get; set; }

        [Display(Name = "Grupo Poblacional")]
        public string GrupoPoblacional { get; set; }
        public int? idAperturaDigital { get; set; }
        public int idGrupoPoblacional { get; set; }
        public int idIngresos { get; set; }
        public int idObservacionesCuota { get; set; }

        [Display(Name = "Número Registro")]
        public int idPropiedadesFormato { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }
        public int idSerGratuito_CtaAHO { get; set; }
        public int idSerGratuito_CtaAHO2 { get; set; }
        public int idSerGratuito_CtaAHO3 { get; set; }
        public int idSerGratuito_TCRDebito { get; set; }
        public int idSerGratuito_TCRDebito2 { get; set; }
        public int idSerGratuito_TCRDebito3 { get; set; }
        public int? idTipoProductoDeposito { get; set; }

        [Display(Name = "Ingresos")]
        public string Ingresos { get; set; }

        [Display(Name = "Nombre Entidad")]
        public string Nombre { get; set; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Display(Name = "Nombre Comercial")]
        public int? idNombreComercial { get; set; }

        [Display(Name = "Nombre Comercial")]
        public string NombreComercial { get; set; }

        [Display(Name = "Numero clientes")]
        public int NumeroClientes { get; set; }

        [Display(Name = "Observaciones Cuota")]
        public string ObservacionesCuota { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros 1")]
        public string SerGratuito_CtaAH1 { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros 2")]
        public string SerGratuito_CtaAH2 { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros 3")]
        public string SerGratuito_CtaAH3 { get; set; }

        [Display(Name = "Servicio Tarjeta Debito 1")]
        public string SerGratuito_TCRDebito1 { get; set; }

        [Display(Name = "Servicio Tarjeta Debito 2")]
        public string SerGratuito_TCRDebito2 { get; set; }

        [Display(Name = "Servicio Tarjeta Debito 3")]
        public string SerGratuito_TCRDebito3 { get; set; }

        [Display(Name = "Tipo Entidad")]
        public string Tipo { get; set; } = "001"; //Campo fijo por default= 001

        [Display(Name = "Tipo de Producto Deposito")]
        public string TipoProductoDeposito { get; set; }
        public int? Usuario { get; set; }

    }
}