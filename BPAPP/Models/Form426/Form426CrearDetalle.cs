using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426CrearDetalle
    {
        public int idDetalle { get; set; }

        [Required(ErrorMessage = "El campo  propiedades formato es obligatorio.")]
        [Display(Name = "Propiedades Formato")]
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo  subcuenta es obligatorio.")]
        [Display(Name = "Subcuenta")]
        public int Subcuenta { get; set; }

        public string CaracteristicaCredito { get; set; }

        [Required(ErrorMessage = "El campo caracteristica credito es obligatorio.")]
        [Display(Name = "Caracteristica Credito")]
        public int idCaracteristicaCredito { get; set; }

        public int Costo { get; set; }

        public int Tasa { get; set; }

        [Display(Name = "Tipo Aseguradora")]
        public string TipoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo tipo aseguradora es obligatorio.")]
        [Display(Name = "Tipo Aseguradora")]
        public int idTipoAseguradora { get; set; }

        [Display(Name = "Codigo Aseguradora")]
        public string CodigoAseguradora { get; set; }
        
        [Display(Name = "Codigo Aseguradora")]
        public int idCodigoAseguradora { get; set; }
        public string Observaciones { get; set; }

        [Required(ErrorMessage = "El campo Observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }
        public int UnidadCaptura { get; set; } = 1;
        public int Estado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }
        public int CodigoRegistro { get; set; }
        public int? idDetalleAnterior { get; set; }
    }
}