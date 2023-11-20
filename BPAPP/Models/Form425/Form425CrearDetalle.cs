using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425CrearDetalle
    {
        [Required(ErrorMessage = "El campo subcuenta es obligatorio.")]
        [Display(Name = "Subcuenta")]
        public int Subcuenta { get; set; }

        [Required(ErrorMessage = "El campo operaciono servicio es obligatorio.")]
        [Display(Name = "OperacionoServicio")]
        public int idOperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int Canal { get; set; }

        [Required(ErrorMessage = "El campo costo fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        public int CostoFijo { get; set; }

        [Required(ErrorMessage = "El campo costo fijo maximo es obligatorio.")]
        [Display(Name = "Costo Fijo Maximo")]
        public int CostoFijoMaximo { get; set; }

        [Required(ErrorMessage = "El campo costo proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo Fijo Maximo")]
        public int CostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo costo proporcional máximo a operación o servicio es obligatorio.")]
        [Display(Name = "Costo maximo op servicio")]
        public int CostoProporcionMaxOperacionServicio { get; set; }
        
        [Required(ErrorMessage = "El campo tasa es obligatorio.")]
        [Display(Name = "Tasa")]
        public int Tasa { get; set; }

        [Required(ErrorMessage = "El campo Tasa máxima es obligatorio.")]
        [Display(Name = "Tasa Maxima")]
        public int TasaMaxima { get; set; }

        [Required(ErrorMessage = "El campo Tipo de aseguradoraipo de aseguradora es obligatorio.")]
        [Display(Name = "Tipo de aseguradora")]
        public int idTipoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }

        [Required(ErrorMessage = "El campo Tasa máxima es obligatorio.")]
        [Display(Name = "Tasa Maxima")]
        public int UnidadCaptura { get; set; }
        public int Estado { get; set; }
        public int FechaProceso { get; set; }
        public int FechaEstado { get; set; }
    }
}