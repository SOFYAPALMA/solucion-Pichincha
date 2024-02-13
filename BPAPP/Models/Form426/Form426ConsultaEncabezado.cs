using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426ConsultaEncabezado
    {
        [Display(Name = "Número Registro")]
        public int idPropiedadesFormato { get; set; }
   
        [Display(Name = "Tipo")]
        public string Tipo { get; set; } = "001"; //Campo fijo por default= 001

        [Display(Name = "Código")]
        public string Codigo { get; set; } = "00057"; //Campo fijo por default= 00057

        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; set; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Display(Name = "Producto Crédito")]
        public int TipoProductoCredito { get; set; }

        [Display(Name = "Producto")]
        public string DTipoProductoCredito { get; set; }

        [Display(Name = "Código Crédito")]
        public string CodigoCredito { get; set; }

        [Display(Name = "Código Crédito")]
        public int? idCodigoCredito { get; set; }

        [Display(Name = "Apertura Digital")]
        public string AperturaDigital { get; set; }

        [Display(Name = "Apertura Digital")]
        public int idAperturaDigital { get; set; }
        public string Fecha_horaActualizacion { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }

        [Display(Name = "Estado")]
        public string DescripcionEstado { get; set; }
        public string Fechacorte { get; set; }
        public string FechaEstado { get; set; }
        [Display(Name = "Registro SFC")]
        public string CodigoRegistro { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }
    }
}