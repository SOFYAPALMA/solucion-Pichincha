using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426CrearDetalle
    {
        public int idDetalle { get; set; }

        [Display(Name = "Propiedades Formato")]
        public int idPropiedadesFormato { get; set; }

        [Display(Name = "Subcuenta")]
        public string Subcuenta { get; set; } = "0";//Campo fijo por default= 0

        public string CaracteristicaCredito { get; set; }

        [Required(ErrorMessage = "El campo Caracteristica Credito es obligatorio.")]
        [Display(Name = "Caracteristica Credito")]
        public int idCaracteristicaCredito { get; set; }

        public int Costo { get; set; }

        [RegularExpression(@"^\d+(\.\d{1,4})?$")]
        public decimal? Tasa { get; set; }

        [Display(Name = "Tipo Aseguradora")]
        public string TipoAseguradora { get; set; }

        [Display(Name = "Tipo Aseguradora")]
        public int? idTipoAseguradora { get; set; }

        [Display(Name = "Codigo Aseguradora")]
        public string CodigoAseguradora { get; set; }

        [Display(Name = "Codigo Aseguradora")]
        public int? idCodigoAseguradora { get; set; }
        public string Observaciones { get; set; }

        [Display(Name = "Observaciones")]
        public int? idObservaciones { get; set; }
        public int UnidadCaptura { get; set; } = 1;
        public int Estado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }
        public string CodigoRegistro { get; set; }
        public int? idDetalleAnterior { get; set; }

    }
}