using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425CrearDetalle
    {
        public int idPropiedadesFormato { get; set; }

        public int idDetalle { get; set; }

        [Required(ErrorMessage = "El campo subcuenta es obligatorio.")]
        [Display(Name = "Subcuenta")]
        public int Subcuenta { get; set; }

        [Required(ErrorMessage = "El campo operación o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int Canal { get; set; }

        [Required(ErrorMessage = "El costo fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        public int CostoFijo { get; set; }

        [Required(ErrorMessage = "El campo costo fijo máximo es obligatorio.")]
        [Display(Name = "Costo Fijo Maximo")]
        public int CostoFijoMaximo { get; set; }

        [Required(ErrorMessage = "El campo costo proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcional a op o servicio")]
        public int CostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo costo proporcional máximo a operación o servicio es obligatorio.")]
        [Display(Name = "Costo maximo op servicio")]
        public int CostoProporcionMaxOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo tasa es obligatorio.")]
        [Display(Name = "Tasa")]
        public int Tasa { get; set; }

        [Required(ErrorMessage = "El campo tasa máxima es obligatorio.")]
        [Display(Name = "Tasa Maxima")]
        public int TasaMaxima { get; set; }

        [Required(ErrorMessage = "El campo tipo de aseguradora es obligatorio.")]
        [Display(Name = "Tipo de aseguradora")]
        public int idTipoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }

        [Required(ErrorMessage = "El campo unidad captura es obligatorio.")]
        [Display(Name = "Unidad Captura")]
        public int UnidadCaptura { get; set; }

        [Required(ErrorMessage = "El campo nombre comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }
        public int Estado { get; set; }
        public DateTime FechaProceso { get; set; }
        public DateTime FechaEstado { get; set; }

        [Required(ErrorMessage = "El campo id código aseguradora es obligatorio.")]
        [Display(Name = "Código Aseguradora")]
        public int idCodigoAseguradora { get; set; }
    }
}