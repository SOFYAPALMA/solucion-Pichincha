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
        public int Subcuenta { get; set; }

        [Display(Name = "Caracteristica Credito")]
        public string CaracteristicaCredito { get; set; }
        public int idCaracteristicaCredito { get; set; }

        [Display(Name = "Costo")]
        public int Costo { get; set; }

        [Display(Name = "Tasa")]
        public decimal Tasa { get; set; }

        [Display(Name = "Tipo Aseguradora")]
        public string TipoAseguradora { get; set; }
        public int idTipoAseguradora { get; set; }

        [Display(Name = "Código Aseguradora")]
        public string CodigoAseguradora { get; set; }
        public int idCodigoAseguradora { get; set; }

        [Display(Name = "Observaciones")]
        public string Observaciones { get; set; }
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