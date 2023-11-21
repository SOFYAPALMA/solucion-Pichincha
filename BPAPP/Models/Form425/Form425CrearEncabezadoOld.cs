using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425CrearEncabezadoOld
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>
        [Required(ErrorMessage = "El campo tipo entidad es obligatorio.")]
        [Display(Name = "Tipo")]

        public int Tipo { get; } = 001; //Campo fijo por default= 001

        [Required(ErrorMessage = "El campo codigo entidad es obligatorio.")]
        [Display(Name = "Codigo")]

        public int Codigo { get; } = 00057; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Required(ErrorMessage = "El campo Nombre o sigla de la entidad es obligatorio.")]
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Required(ErrorMessage = "El campo Fecha y Hora de Reporte es obligatorio.")]
        [Display(Name = "Fecha Hora Reporte")]
        public DateTime FechaHora { get; set; }

        [Required(ErrorMessage = "El campo Nombre Comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }


        [Required(ErrorMessage = "El campo Apertura Digital es obligatorio.")]
        [Display(Name = "Apertura Digital")]
        public int AperturaDigital { get; set; }

        [Required(ErrorMessage = "El campo Número de clientes únicos es obligatorio.")]
        [Display(Name = "Número de clientes únicos")]
        public int NumerodeClientesUnicos { get; set; }

        [Required(ErrorMessage = "El campo Franquicia es obligatorio.")]
        [Display(Name = "Franquicia")]
        public int Franquicia { get; set; }

        [Required(ErrorMessage = "El campo Cuota de Manejo es obligatorio.")]
        [Display(Name = "Cuota de Manejo")]
        public int CuotadeManejo { get; set; }

        [Required(ErrorMessage = "El campo Observaciones Cuota de Manejo es obligatorio.")]
        [Display(Name = "Observaciones Cuota de Manejo")]
        public int ObservacionesCuotadeManejo { get; set; }

        [Required(ErrorMessage = "El campo Grupo Poblacional es obligatorio.")]
        [Display(Name = "Grupo Poblacional")]
        public int GrupoPoblacional { get; set; }

        [Required(ErrorMessage = "El campo Ingresos es obligatorio.")]
        [Display(Name = "Ingresos")]
        public int Ingresos { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Cuenta de Ahorros1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros1")]
        public int ServicioGratuitoCuentadeAhorros1 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Cuenta de Ahorros2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros2")]
        public int ServicioGratuitoCuentadeAhorros2 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Cuenta de Ahorros3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros3")]
        public int ServicioGratuitoCuentadeAhorros3 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Tarjeta Debito1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito1")]
        public int ServicioGratuitoTarjetaDebito1 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Tarjeta Debito2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito2")]
        public int ServicioGratuitoTarjetaDebito2 { get; set; }

        [Required(ErrorMessage = "El Servicio Gratuito Tarjeta Debito3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito3")]
        public int ServicioGratuitoTarjetaDebito3 { get; set; }
    }
}
