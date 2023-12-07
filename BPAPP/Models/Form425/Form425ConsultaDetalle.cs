using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425ConsultaDetalle
    {
        public int idDetalle { get; set; }

        [Required(ErrorMessage = "El campo registro es obligatorio.")]
        [Display(Name = "Registro")]
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo nombre comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }

        [Display(Name = "Subcuentas")]
        public string Subcuenta { get; set; } = "0";//Campo fijo por default= 0

        [Required(ErrorMessage = "El campo operación o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionoServicio { get; set; }
        public string OperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int idCanal { get; set; }   
        
        [Display(Name = "Canal")]
        public string Canal { get; set; }

        [Required(ErrorMessage = "El campo costo fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        public decimal CostoFijo { get; set; }

        [Required(ErrorMessage = "El campo costo fijo máximo es obligatorio.")]
        [Display(Name = "Costo fijo máximo")]
        public decimal CostoFijoMaximo { get; set; }

        [Required(ErrorMessage = "El campo costo proporción a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcion a operación o servicio")]
        public decimal CostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo costo max proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcional max a operación o servicio")]
        public decimal CostoProporcionMaxOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo tasa es obligatorio.")]
        [Display(Name = "Tasa")]
        public decimal Tasa { get; set; }

        [Required(ErrorMessage = "El campo tasa máxima es obligatorio.")]
        [Display(Name = "Tasa máxima")]
        public decimal TasaMaxima { get; set; }

        [Required(ErrorMessage = "El campo tipo de aseguradora es obligatorio.")]
        [Display(Name = "Tipo de aseguradora")]
        public int idTipoAseguradora { get; set; }
        public string TipoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo código de aseguradora es obligatorio.")]
        [Display(Name = "Código de aseguradora")]
        public int idCodigoAseguradora { get; set; }
        public string CodigoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }
        public string Observaciones { get; set; }

        [Display(Name = "Unidad de captura")]
        public int UnidadCaptura { get; set; } = 1;
        public int Estado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }
    }
}