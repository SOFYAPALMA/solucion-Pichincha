using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form426CrearDetalle
    {
        public string Detalle { get; set; }

        [Required(ErrorMessage = "El campo  ID Detalle es obligatorio.")]
        [Display(Name = "ID Detalle")]
        public int idDetalle { get; set; }

        
        [Display(Name = "Propiedades Formato")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string PropiedadesFormato { get; set; }

        [Display(Name = "Propiedades Formato")]
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo  Subcuenta es obligatorio.")]
        [Display(Name = "Subcuenta")]
        public int Subcuenta { get; set; }

        
        [Display(Name = "Caracteristica Credito")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string CaracteristicaCredito { get; set; }

        [Required(ErrorMessage = "El campo Caracteristica Credito es obligatorio.")]
        [Display(Name = "Caracteristica Credito")]
        public int idCaracteristicaCredito { get; set; }

        [Required(ErrorMessage = "Costo.")]
        [Display(Name = "Costo")]
        public int Costo { get; set; }

        [Required(ErrorMessage = "Tasa es obligatorio.")]
        [Display(Name = "Tasa")]
        public int Tasa { get; set; }

        [Display(Name = "Tipo Aseguradora")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string TipoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo Tipo Aseguradora es obligatorio.")]
        [Display(Name = "Tipo Aseguradora")]
        public int idTipoAseguradora { get; set; }

        
        [Display(Name = "Codigo Aseguradora")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string CodigoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo Codigo Aseguradora es obligatorio.")]
        [Display(Name = "Codigo Aseguradora")]
        public int idCodigoAseguradora { get; set; }
        public string Observaciones { get; set; }

        [Required(ErrorMessage = "El campo ID Observaciones es obligatorio.")]
        [Display(Name = "ID Observaciones")]
        public int idObservaciones { get; set; }
        public int UnidadCaptura { get; set; }
        public int Estado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }
        public int CodigoRegistro { get; set; }
        public string DetalleAnterior { get; set; }
        public int idDetalleAnterior { get; set; }
    }
}