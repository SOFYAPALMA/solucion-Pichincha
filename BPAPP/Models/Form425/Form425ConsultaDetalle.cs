using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425ConsultaDetalle
    {
        public int idDetalle { get; set; }

        [Display(Name = "Registro")]
        public int idPropiedadesFormato { get; set; }

        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }

        [Display(Name = "Subcuentas")]
        public string Subcuenta { get; set; } = "0";//Campo fijo por default= 0

        [Required(ErrorMessage = "El campo operacion o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionoServicio { get; set; }
        public string OperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo Canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int idCanal { get; set; }

        [Display(Name = "Canal")]
        public string Canal { get; set; }

        [Display(Name = "Costo Fijo")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal? CostoFijo { get; set; }

        [Display(Name = "Costo fijo máximo")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal? CostoFijoMaximo { get; set; }

        [Display(Name = "Costo proporcion a operación o servicio")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal? CostoProporcionOperacionServicio { get; set; }

        [Display(Name = "Costo proporcional max a operación o servicio")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal? CostoProporcionMaxOperacionServicio { get; set; }

        [Display(Name = "Tasa")]
        [RegularExpression(@"^\d+(\.\d{1,4})?$")]
        public decimal? Tasa { get; set; }

        [Display(Name = "Tasa máxima")]
        [RegularExpression(@"^\d+(\.\d{1,4})?$")]
        public decimal? TasaMaxima { get; set; }

        [Display(Name = "Tipo de aseguradora")]
        public int? idTipoAseguradora { get; set; }
        public string TipoAseguradora { get; set; }

        [Display(Name = "Código de aseguradora")]
        public int? idCodigoAseguradora { get; set; }
        public string CodigoAseguradora { get; set; }

        [Display(Name = "Observaciones")]
        public int? idObservaciones { get; set; }
        public string Observaciones { get; set; }

        [Display(Name = "Unidad de captura")]
        public int UnidadCaptura { get; set; } = 1;
        public int Estado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }
    }
}