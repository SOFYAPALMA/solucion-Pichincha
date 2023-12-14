using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426ConsultaDetalle
    {
        [Display(Name = "Detalle")]
        public int idDetalle { get; set; }

        [Display(Name = "Propiedades Formato")]
        public int idPropiedadesFormato { get; set; }

        [Display(Name = "Subcuenta")]
        public string Subcuenta { get; set; } = "0";//Campo fijo por default= 0

        [Required(ErrorMessage = "El campo Caracteristica Credito es obligatorio.")]
        [Display(Name = "Caracteristica Credito")]
        public string CaracteristicaCredito { get; set; }
        [Display(Name = "Caracteristica Credito")]
        public int idCaracteristicaCredito { get; set; }

        [Display(Name = "Costo")]
        public int Costo { get; set; }

        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        [Display(Name = "Tasa")]
        public decimal Tasa { get; set; }

        [Display(Name = "Tipo Aseguradora")]
        public string TipoAseguradora { get; set; }
        [Display(Name = "Tipo Aseguradora")]
        public int idTipoAseguradora { get; set; }

        [Display(Name = "Código Aseguradora")]
        public string CodigoAseguradora { get; set; }
        [Display(Name = "Código Aseguradora")]
        public int idCodigoAseguradora { get; set; }

        [Display(Name = "Observaciones")]
        public string Observaciones { get; set; }
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }

        [Display(Name = "Unidad Captura")]
        public int UnidadCaptura { get; set; } = 1;
        public int Estado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }
        public int? CodigoRegistro { get; set; }
        public int? idDetalleAnterior { get; set; }

    }
}