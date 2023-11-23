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

        [Required(ErrorMessage = "El campo subcuentas es obligatorio.")]
        [Display(Name = "Subcuentas")]
        public int Subcuenta { get; set; }

        [Required(ErrorMessage = "El campo operacion o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionoServicio { get; set; }
        public string OperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int Canal { get; set; }

        [Required(ErrorMessage = "El campo costo fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        public int CostoFijo { get; set; }

        [Required(ErrorMessage = "El campo costo fijo máximo es obligatorio.")]
        [Display(Name = "Costo fijo máximo")]
        public int CostoFijoMaximo { get; set; }

        [Required(ErrorMessage = "El campo costo proporción a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcion a operación o servicio")]
        public int CostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo costo max proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcional max a operación o servicio")]
        public int CostoProporcionMaxOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo tasa es obligatorio.")]
        [Display(Name = "Tasa")]
        public int Tasa { get; set; }

        [Required(ErrorMessage = "El campo tasa máxima es obligatorio.")]
        [Display(Name = "Tasa máxima")]
        public int TasaMaxima { get; set; }

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

        [Required(ErrorMessage = "El campo unidad de captura es obligatorio.")]
        [Display(Name = "Unidad de captura")]
        public int UnidadCaptura { get; set; }
        public int Estado { get; set; }
        public DateTime FechaProceso { get; set; }
        public DateTime FechaEstado { get; set; }
    }
}