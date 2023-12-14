using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form424ConsultaDetalle
    {
        public int idDetalle { get; set; }

        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }

        [Display(Name = "Registro")]
        public int idPropiedadesFormato { get; set; }

        [Display(Name = "Subcuentas")]
        public string Subcuenta { get; set; } = "0";//Campo fijo por default= 0

        [Required(ErrorMessage = "El campo operacion o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionServicio { get; set; }
        public string OperacionServicio { get; set; }

        [Display(Name = "Canal")]
        public int? idCanal { get; set; }
        public string Canal { get; set; }

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
        public string Observaciones { get; set; }

        [Display(Name = "Unidad captura")]
        public int UnidadCaptura { get; set; } = 1;
    }
}