using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProyectoWeb.Models
{
    public class Form424CrearDetalle
    {
        public int idPropiedadesFormato { get; set; }


        [Display(Name = "Sub cuentas")]
        public string Subcuentas { get; set; } = "0";//Campo fijo por default= 0

        [Required(ErrorMessage = "El campo operacion o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int idCanal { get; set; }

        [Required(ErrorMessage = "El campo número de operaciones o servicios incluidos en cuota de manejo es obligatorio.")]
        [Display(Name = "Número de operaciones o servicios incluidos en cuota de manejo")]
        public int NumOperServiciosCuotamanejo { get; set; }

        [Required(ErrorMessage = "El campo costo fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        public int CostoFijo { get; set; }

        //[Required(ErrorMessage = "El campo costo proporcional a operación o servicio es obligatorio.")]
        //[Display(Name = "Costo proporcional a operación o servicio")]
        [DataType(DataType.Currency)]
        [Column(TypeName = "decimal(18, 2)")]
        public int CostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }

        [Display(Name = "Unidad Captura")]
        public int UnidadCaptura { get; set; } = 1;

        [Required(ErrorMessage = "El campo nombre comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }
    }
}