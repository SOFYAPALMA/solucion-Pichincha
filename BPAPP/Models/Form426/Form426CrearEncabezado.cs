using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426CrearEncabezado
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>
        [Display(Name = "Registro")]
        public int idPropiedadesFormato { get; set; }

        [Display(Name = "Tipo")]
        public int Tipo { get; } = 001; //Campo fijo por default= 001

        [Display(Name = "Codigo")]
        public int Codigo { get; } = 00057; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; set; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Required(ErrorMessage = "El campo ID Codigo Credito es obligatorio.")]
        [Display(Name = "ID Codigo Credito")]
        public int idCodigoCredito { get; set; }

        [Required(ErrorMessage = "El campo ID AperturaDigital es obligatorio.")]
        [Display(Name = "ID AperturaDigital")]
        public int idAperturaDigital { get; set; }

        [Display(Name = "Fecha hora actualizacion")]
        public DateTime Fecha_horaActualizacion { get; set; }

        [Display(Name = "Usuario")]
        public string Usuario { get; set; }

        [Display(Name = "Estado")]
        public string Estado { get; set; }

        [Display(Name = "Fecha corte")]
        public DateTime Fechacorte { get; set; }

        [Display(Name = "Fecha Estado")]
        public DateTime FechaEstado { get; set; }

        [Display(Name = "Codigo Registro")]
        public int CodigoRegistro { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }

    }
}