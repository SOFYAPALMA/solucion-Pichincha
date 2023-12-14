using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form424CrearEncabezado
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>
        [Display(Name = "Tipo")]
        public string Tipo { get; } = "001"; //Campo fijo por default= 001

        [Display(Name = "Codigo")]
        public string Codigo { get; } = "00057"; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Display(Name = "Nombre Comercial")]
        public int? idNombreComercial { get; set; }

        [Display(Name = "Tipo de Producto Deposito")]
        public int? idTipoProductoDeposito { get; set; }

        [Display(Name = "Número de clientes únicos")]
        public int NumeroClientes { get; set; } //Campo numérico de registro manual, de acuerdo al cálculo de Clientes Únicos del MIS 

        [Display(Name = "Cuota de Manejo")]
        public int? CuotaManejo { get; set; } //Campo numérico de registro manual

        [Display(Name = "Observaciones Cuota de Manejo")]
        public int? idObservacionesCuota { get; set; }

        [Display(Name = "Grupo Poblacional")]
        public int? idGrupoPoblacional { get; set; }

        [Display(Name = "Ingresos")]
        public int? idIngresos { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros1")]
        public int? idSerGratuito_CtaAHO { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros2")]
        public int? idSerGratuito_CtaAHO2 { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros3")]
        public int? idSerGratuito_CtaAHO3 { get; set; }

        [Display(Name = "Servicio Gratuito Tarjeta Debito1")]
        public int? idSerGratuito_TCRDebito { get; set; }

        [Display(Name = "Servicio Gratuito Tarjeta Debito2")]
        public int? idSerGratuito_TCRDebito2 { get; set; }

        [Display(Name = "Servicio Gratuito Tarjeta Debito3")]
        public int? idSerGratuito_TCRDebito3 { get; set; }

        [Display(Name = "Apertura digital")]
        public int? idAperturaDigital { get; set; }
        public string CodigoRegistro { get; set; }
        public int Usuario { get; set; }
    }
}