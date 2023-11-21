using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426CrearEncabezado
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo tipo entidad es obligatorio.")]
        [Display(Name = "Tipo")]
        public int Tipo { get; } = 001; //Campo fijo por default= 001

        [Required(ErrorMessage = "El campo Codigo es obligatorio.")]
        [Display(Name = "Codigo")]
        public int Codigo { get; } = 00057; //Campo fijo por default= 00057
        public string Nombre { get; set; }
        public string CodigoCredito { get; set; }
        public int idCodigoCredito { get; set; }
        public string AperturaDigital { get; set; }
        public int idAperturaDigital { get; set; }
        public DateTime Fecha_horaActualizacion { get; set; }
        public int Usuario { get; set; }
        public string Estado { get; set; }
        public DateTime Fechacorte { get; set; }
        public DateTime FechaEstado { get; set; }
        public int CodigoRegistro { get; set; }
        public int idPropiedadesFormatoAnterior { get; set; }

    }
}