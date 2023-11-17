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
        [StringLength(3)]
        [DataType(DataType.Text)]
        public int Tipo { get; set; }

        [Required(ErrorMessage = "El campo codigo entidad es obligatorio.")]
        [Display(Name = "Codigo")]
        [StringLength(5)]
        [DataType(DataType.Text)]
        public int Codigo { get; set; }

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Required(ErrorMessage = "El campo nombre entidad es obligatorio.")]
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "El campo Fecha y Hora de Reporte es obligatorio.")]
        [Display(Name = "FechaHora")]
        [StringLength(3)]
        [DataType(DataType.DateTime)]
        public DateTime FechaHora { get; set; }

        [Required(ErrorMessage = "El campo Nombre Comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string NombreComercial { get; set; }

        [Required(ErrorMessage = "El campo Tipo de Producto Deposito es obligatorio.")]
        [Display(Name = "Tipo de Producto Deposito")]
        [StringLength(1)]
        [DataType(DataType.Text)]
        public int TipodeProductoDeposito { get; set; }

        [Required(ErrorMessage = "El campo Apertura Digital es obligatorio.")]
        [Display(Name = "Apertura Digital")]
        [StringLength(1)]
        [DataType(DataType.Text)]
        public int AperturaDigital { get; set; }

        [Required(ErrorMessage = "El campo Número de clientes únicos es obligatorio.")]
        [Display(Name = "Número de clientes únicos")]
        [StringLength(8)]
        [DataType(DataType.Text)]
        public int NumerodeClientesUnicos { get; set; }

        [Required(ErrorMessage = "El campo Cuota de Manejo es obligatorio.")]
        [Display(Name = "Cuota de Manejo")]
        [StringLength(7)]
        [DataType(DataType.Text)]
        public int CuotadeManejo { get; set; }

        [Required(ErrorMessage = "El campo Observaciones Cuota de Manejo es obligatorio.")]
        [Display(Name = "Observaciones Cuota de Manejo")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int ObservacionesCuotadeManejo { get; set; }

        [Required(ErrorMessage = "El campo Grupo Poblacional es obligatorio.")]
        [Display(Name = "Grupo Poblacional")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int GrupoPoblacional { get; set; }

        [Required(ErrorMessage = "El campo Ingresos es obligatorio.")]
        [Display(Name = "Ingresos")]
        [StringLength(1)]
        [DataType(DataType.Text)]
        public int Ingresos { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Cuenta de Ahorros1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros1")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int ServicioGratuitoCuentadeAhorros1 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Cuenta de Ahorros2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros2")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int ServicioGratuitoCuentadeAhorros2 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Cuenta de Ahorros3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros3")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int ServicioGratuitoCuentadeAhorros3 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Tarjeta Debito1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito1")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int ServicioGratuitoTarjetaDebito1 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Tarjeta Debito2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito2")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int ServicioGratuitoTarjetaDebito2 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Tarjeta Debito3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito3")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int ServicioGratuitoTarjetaDebito3 { get; set; }
    }
}