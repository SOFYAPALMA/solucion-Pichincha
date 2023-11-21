using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425ConsultaDetalle
    {
        public int idDetalle { get; set; }

        [Required(ErrorMessage = "El campo Registro es obligatorio.")]
        [Display(Name = "Registro")]
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo Subcuentas es obligatorio.")]
        [Display(Name = "Subcuentas")]
        public int Subcuenta { get; set; }

        [Required(ErrorMessage = "El campo Operacion o Servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionoServicio { get; set; }
        public string OperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo Canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int Canal { get; set; }

        [Required(ErrorMessage = "El campo Costo Fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        public int CostoFijo { get; set; }

        [Required(ErrorMessage = "El campo Costo fijo máximo es obligatorio.")]
        [Display(Name = "Costo fijo máximo")]
        public int CostoFijoMaximo { get; set; }

        [Required(ErrorMessage = "El campo Costo proporcion a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcion a operación o servicio")]
        public int CostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo Costo max proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcional max a operación o servicio")]
        public int CostoProporcionMaxOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo Tasa es obligatorio.")]
        [Display(Name = "Tasa")]
        public int Tasa { get; set; }

        [Required(ErrorMessage = "El campo Tasa máxima es obligatorio.")]
        [Display(Name = "Tasa máxima")]
        public int TasaMaxima { get; set; }

        [Required(ErrorMessage = "El campo Tipo de aseguradora es obligatorio.")]
        [Display(Name = "Tipo de aseguradora")]
        public int idTipoAseguradora { get; set; }
        public string TipoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo Código de aseguradora es obligatorio.")]
        [Display(Name = "Código de aseguradora")]
        public int idCodigoAseguradora { get; set; }
        public string CodigoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo Observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }
        public string Observaciones { get; set; }

        [Required(ErrorMessage = "El campo Unidad de captura es obligatorio.")]
        [Display(Name = "Unidad de captura")]
        public int UnidadCaptura { get; set; }
        public int Estado { get; set; }
        public DateTime FechaProceso { get; set; }
        public DateTime FechaEstado { get; set; }
    }
}