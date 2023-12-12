using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426ConsultaEncabezado
    {
        [Display(Name = "Número Registro")]
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo tipo es obligatorio.")]
        [Display(Name = "Tipo")]
        public string Tipo { get; set; }

        [Required(ErrorMessage = "El campo código es obligatorio.")]
        [Display(Name = "Código")]
        public string Codigo { get; set; }

        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; set; }

        [Display(Name = "Producto Crédito")]
        public int TipoProductoCredito { get; set; }   
        public string DTipoProductoCredito { get; set; }

        [Display(Name = "Código Crédito")]
        public string CodigoCredito { get; set; }

        [Display(Name = "Código Crédito")]
        public int idCodigoCredito { get; set; }

        [Display(Name = "Apertura Digital")]
        public string AperturaDigital { get; set; }

        [Display(Name = "Apertura Digital")]
        public int idAperturaDigital { get; set; }
        public string Fecha_horaActualizacion { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }
        public string Fechacorte { get; set; }
        public string FechaEstado { get; set; }
        public int? CodigoRegistro { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }
    }
}