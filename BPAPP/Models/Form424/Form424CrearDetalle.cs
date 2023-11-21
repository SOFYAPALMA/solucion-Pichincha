using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form424CrearDetalle
    {
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo Subcuentas es obligatorio.")]
        [Display(Name = "Sub cuentas")]
        public int Subcuentas { get; set; }

        [Required(ErrorMessage = "El campo Operacion o Servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo Canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int idCanal { get; set; }

        [Required(ErrorMessage = "El campo Número de operaciones o servicios incluidos en cuota de manejo es obligatorio.")]
        [Display(Name = "Número de operaciones o servicios incluidos en cuota de manejo")]
        public int NumOperServiciosCuotamanejo { get; set; }

        [Required(ErrorMessage = "El campo Costo fijo es obligatorio.")]
        [Display(Name = "Costo fijo")]
        public int CostoFijo { get; set; }

        [Required(ErrorMessage = "El campo Costo proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcional a operación o servicio")]
        public int CostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo Observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }

        [Required(ErrorMessage = "El campo Unidad Captura es obligatorio.")]
        [Display(Name = "Unidad Captura")]
        public int UnidadCaptura { get; set; }

        [Required(ErrorMessage = "El campo Nombre Comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }
    }
}