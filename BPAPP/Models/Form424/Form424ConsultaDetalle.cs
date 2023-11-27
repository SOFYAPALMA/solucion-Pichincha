using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form424ConsultaDetalle
    {
        public int idDetalle { get; set; }

        [Required(ErrorMessage = "El campo nombre comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }

        [Display(Name = "Registro")]
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo subcuentas es obligatorio.")]
        [Display(Name = "Subcuentas")]
        public string Subcuenta { get; set; }

        [Required(ErrorMessage = "El campo operacion o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionServicio { get; set; }
        public string OperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int idCanal { get; set; }
        public string Canal { get; set; }

        [Required(ErrorMessage = "El campo número de operaciones o servicios incluidos en cuota de manejo es obligatorio.")]
        [Display(Name = "Número de operaciones o servicios incluidos en cuota de manejo")]
        public int NumOperServiciosCuotamanejo { get; set; }

        [Required(ErrorMessage = "El campo costo fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        public decimal CostoFijo { get; set; }

        [Required(ErrorMessage = "El campo Costo proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcional a operación o servicio")]
        public decimal CostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }
        public string Observaciones { get; set; }

        [Display(Name = "Unidad captura")]
        public int UnidadCaptura { get; set; } = 1;
    }
}