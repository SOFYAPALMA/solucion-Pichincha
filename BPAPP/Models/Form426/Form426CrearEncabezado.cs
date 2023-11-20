using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ProyectoWeb.Models.Form426
{
    public class Form426CrearEncabezado
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
        [Required(ErrorMessage = "El campo codigo del credito es obligatorio.")]
        [Display(Name = "CodigoCredito")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Required(ErrorMessage = "El campo Fecha y hora de actualizacion es obligatorio.")]
        [Display(Name = "FechaHora")]
        public DateTime Fecha_horaActualizacion { get; set; }

        [Required(ErrorMessage = "El campo Apertura digital es obligatorio.")]
        [Display(Name = "Apertura Digital")]
        public int AperturaDigital { get; set; }

    }
}