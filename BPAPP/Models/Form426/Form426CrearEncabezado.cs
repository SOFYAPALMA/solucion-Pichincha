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
        public string Tipo { get; } = "001"; //Campo fijo por default= 001

        [Display(Name = "Codigo")]
        public string Codigo { get; } = "00057"; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; set; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Required(ErrorMessage = "El campo producto crédito es obligatorio.")]
        [Display(Name = "Producto Crédito")]
        public int TipoProductoCredito { get; set; }


        [Required(ErrorMessage = "El campo código crédito es obligatorio.")]
        [Display(Name = "Código Crédito")]
        public int idCodigoCredito { get; set; }

        [Required(ErrorMessage = "El campo apertura digital es obligatorio.")]
        [Display(Name = "Apertura Digital")]
        public int idAperturaDigital { get; set; }

        [Display(Name = "Fecha hora actualizacion")]
        public DateTime Fecha_horaActualizacion { get; set; }

        [Display(Name = "Usuario")]
        public string Usuario { get; set; }

        [Display(Name = "Estado")]
        public string Estado { get; set; }
        public string DescripcionEstado { get; set; }

        [Display(Name = "Fecha corte")]
        public DateTime Fechacorte { get; set; }

        [Display(Name = "Fecha Estado")]
        public DateTime FechaEstado { get; set; }

        [Display(Name = "Codigo Registro")]
        public string CodigoRegistro { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }

    }
}