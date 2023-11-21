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

        [Required(ErrorMessage = "El campo tipo entidad es obligatorio.")]
        [Display(Name = "Tipo")]
        public int Tipo { get; } = 001; //Campo fijo por default= 001

        [Required(ErrorMessage = "El campo Codigo entidad es obligatorio.")]
        [Display(Name = "Codigo")]
        public int Codigo { get; } = 00057; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Required(ErrorMessage = "El campo Nombre o sigla de la entidad es obligatorio.")]
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; set; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Required(ErrorMessage = "El campo Codigo Credito es obligatorio.")]
        [Display(Name = "Codigo Credito")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string CodigoCredito { get; set; }

        [Required(ErrorMessage = "El campo ID Codigo Credito es obligatorio.")]
        [Display(Name = "ID Codigo Credito")]
        public int idCodigoCredito { get; set; }

        [Required(ErrorMessage = "El campo Apertura Digital es obligatorio.")]
        [Display(Name = "Apertura Digital")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string AperturaDigital { get; set; }

        [Required(ErrorMessage = "El campo ID AperturaDigital es obligatorio.")]
        [Display(Name = "ID AperturaDigital")]
        public int idAperturaDigital { get; set; }

        [Required(ErrorMessage = "El campo Fecha hora actualizacion registro es obligatorio.")]
        [Display(Name = "Fecha hora actualizacion")]
        public DateTime Fecha_horaActualizacion { get; set; }

        [Required(ErrorMessage = "El Usuario es obligatorio.")]
        [Display(Name = "Usuario")]
        public string Usuario { get; set; }

        [Required(ErrorMessage = "El campo Estado es obligatorio.")]
        [Display(Name = "Estado")]
        public string Estado { get; set; }

        [Required(ErrorMessage = "El campo Fecha cortees obligatorio.")]
        [Display(Name = "Fecha corte")]
        public DateTime Fechacorte { get; set; }

        [Required(ErrorMessage = "El campo Fecha Estado es obligatorio.")]
        [Display(Name = "Fecha Estado")]
        public DateTime FechaEstado { get; set; }

        [Required(ErrorMessage = "El campo Codigo Registro es obligatorio.")]
        [Display(Name = "Codigo Registro")]
        public int CodigoRegistro { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }

    }
}