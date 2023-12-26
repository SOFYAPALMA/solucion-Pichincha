using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425CrearDetalle
    {
        public int idPropiedadesFormato { get; set; }

        public int idDetalle { get; set; }

        [Display(Name = "Subcuenta")]
        public string Subcuenta { get; set; } = "0";//Campo fijo por default= 0

        [Required(ErrorMessage = "El campo operación o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionoServicio { get; set; }

        [Display(Name = "Canal")]
        public int idCanal { get; set; }

        [Display(Name = "Canal")]
        public string Canal { get; set; }

        [Required(ErrorMessage = "El campo costo fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal CostoFijo { get; set; }

        [Display(Name = "Costo Fijo Maximo")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal CostoFijoMaximo { get; set; }

        [Display(Name = "Costo proporcional a op o servicio")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal? CostoProporcionOperacionServicio { get; set; }

        [Display(Name = "Costo maximo op servicio")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public int? CostoProporcionMaxOperacionServicio { get; set; }

        [Display(Name = "Tasa")]
        [RegularExpression(@"^\d+(\.\d{1,4})?$")]
        public decimal? Tasa { get; set; }

        [Display(Name = "Tasa Maxima")]
        [RegularExpression(@"^\d+(\.\d{1,4})?$")]
        public decimal? TasaMaxima { get; set; }

        [Display(Name = "Tipo de aseguradora")]
        public int? idTipoAseguradora { get; set; }

        [Display(Name = "Observaciones")]
        public int? idObservaciones { get; set; }

        [Display(Name = "Unidad Captura")]
        public int UnidadCaptura { get; set; }

        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }
        public int Estado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }

        [Display(Name = "Código Aseguradora")]
        public int? idCodigoAseguradora { get; set; }
    }
}