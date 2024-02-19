using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form424CrearDetalle
    {
        public int idPropiedadesFormato { get; set; }

        [Display(Name = "Sub cuentas")]
        public string Subcuentas { get; set; } = "0";//Campo fijo por default= 0

        [Display(Name = "Operacion o Servicio")]
        public int? idOperacionServicio { get; set; }
                
        [Display(Name = "Canal")]
        public int? idCanal { get; set; }

        [Display(Name = "Número de operaciones o servicios incluidos en cuota de manejo")]
        public int? NumOperServiciosCuotamanejo { get; set; }

        [Display(Name = "Costo Fijo")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal? CostoFijo { get; set; }

        [Display(Name = "Costo proporcional a operación o servicio")]
        [RegularExpression(@"^\d+(\.\d{1,2})?$")]
        public decimal? CostoProporcionOperacionServicio { get; set; }

        [Display(Name = "Observaciones")]
        public int? idObservaciones { get; set; }

        [Display(Name = "Unidad Captura")]
        public int UnidadCaptura { get; set; } = 1;

        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }
    }
}