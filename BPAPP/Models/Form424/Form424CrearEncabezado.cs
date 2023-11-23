using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form424CrearEncabezado
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>
        [Required(ErrorMessage = "El campo tipo entidad es obligatorio.")]
        [Display(Name = "Tipo")]
        public int Tipo { get; } = 001; //Campo fijo por default= 001

        [Required(ErrorMessage = "El campo código entidad es obligatorio.")]
        [Display(Name = "Codigo")]
        public int Codigo { get; } = 00057; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Required(ErrorMessage = "El campo nombre entidad es obligatorio.")]
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Required(ErrorMessage = "El campo fecha y hora de reporte es obligatorio.")]
        [Display(Name = "FechaHora")]
        public DateTime FechaHora { get; set; }

        [Required(ErrorMessage = "El campo nombre comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }

        [Required(ErrorMessage = "El campo tipo de producto depósito es obligatorio.")]
        [Display(Name = "Tipo de Producto Deposito")]
        public int TipodeProductoDeposito { get; set; }

        [Required(ErrorMessage = "El campo apertura digital es obligatorio.")]
        [Display(Name = "Apertura Digital")]
        public int AperturaDigital { get; set; }

        [Required(ErrorMessage = "El campo número de clientes únicos es obligatorio.")]
        [Display(Name = "Número de clientes únicos")]
        public int NumerodeClientesUnicos { get; set; } //Campo numérico de registro manual, de acuerdo al cálculo de Clientes Únicos del MIS 

        [Required(ErrorMessage = "El campo cuota de manejo es obligatorio.")]
        [Display(Name = "Cuota de Manejo")]
        public int CuotadeManejo { get; set; } //Campo numérico de registro manual

        [Required(ErrorMessage = "El campo observaciones cuota de manejo es obligatorio.")]
        [Display(Name = "Observaciones Cuota de Manejo")]
        public int ObservacionesCuotadeManejo { get; set; }

        [Required(ErrorMessage = "El campo grupo poblacional es obligatorio.")]
        [Display(Name = "Grupo Poblacional")]
        public int GrupoPoblacional { get; set; }

        [Required(ErrorMessage = "El campo ingresos es obligatorio.")]
        [Display(Name = "Ingresos")]
        public int Ingresos { get; set; }

        [Required(ErrorMessage = "El servicio gratuito cuenta de ahorros1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros1")]
        public int ServicioGratuitoCuentadeAhorros1 { get; set; }

        [Required(ErrorMessage = "El servicio gratuito cuenta de ahorros2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros2")]
        public int ServicioGratuitoCuentadeAhorros2 { get; set; }

        [Required(ErrorMessage = "El servicio gratuito cuenta de ahorros3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros3")]
        public int ServicioGratuitoCuentadeAhorros3 { get; set; }

        [Required(ErrorMessage = "El servicio gratuito tarjeta débito1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito1")]
        public int ServicioGratuitoTarjetaDebito1 { get; set; }

        [Required(ErrorMessage = "El servicio gratuito tarjeta débito2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito2")]
        public int ServicioGratuitoTarjetaDebito2 { get; set; }

        [Required(ErrorMessage = "El servicio gratuito tarjeta débito3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito3")]
        public int ServicioGratuitoTarjetaDebito3 { get; set; }
    }
}