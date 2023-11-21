using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426ConsultaEncabezado
    {
        public string PropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo ID Propiedades Formato es obligatorio.")]
        [Display(Name = "ID Propiedades Formato")]
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo Tipo es obligatorio.")]
        [Display(Name = "Tipo")]
        public int Tipo { get; set; }

        [Required(ErrorMessage = "El campo Codigo es obligatorio.")]
        [Display(Name = "Codigo")]
        public int Codigo { get; set; }

        [Required(ErrorMessage = "El campo  Propiedades Formato es obligatorio.")]
        [Display(Name = "Propiedades Formato")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "El campo Codigo Credito es obligatorio.")]
        [Display(Name = "Codigo Credito")]
        public string CodigoCredito { get; set; }
        public int idCodigoCredito { get; set; }

        [Required(ErrorMessage = "El campo AperturaDigital es obligatorio.")]
        [Display(Name = "Apertura Digital")]
        public string AperturaDigital { get; set; }
        public int idAperturaDigital { get; set; }
        public string Fecha_horaActualizacion { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }
        public string Fechacorte { get; set; }
        public string FechaEstado { get; set; }
        public int CodigoRegistro { get; set; }
        public string PropiedadesFormatoAnterior { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }
    }
}