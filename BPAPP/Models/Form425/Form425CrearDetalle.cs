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

        [Required(ErrorMessage = "El campo operacion o servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        public int idOperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo canal es obligatorio.")]
        [Display(Name = "Canal")]
        public int Canal { get; set; }

        [Required(ErrorMessage = "El Costo fijo es obligatorio.")]
        [Display(Name = "Costo Fijo")]
        public int idCostoFijo { get; set; }

        [Required(ErrorMessage = "El campo costo fijo maximo es obligatorio.")]
        [Display(Name = "Costo Fijo Maximo")]
        public int idCostoFijoMaximo { get; set; }

        [Required(ErrorMessage = "El campo costo proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcional a op o servicio")]
        public int idCostoProporcionOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo costo proporcional máximo a operación o servicio es obligatorio.")]
        [Display(Name = "Costo maximo op servicio")]
        public int idCostoProporcionMaxOperacionServicio { get; set; }

        [Required(ErrorMessage = "El campo tasa es obligatorio.")]
        [Display(Name = "Tasa")]
        public int idTasa { get; set; }

        [Required(ErrorMessage = "El campo Tasa máxima es obligatorio.")]
        [Display(Name = "Tasa Maxima")]
        public int idTasaMaxima { get; set; }

        [Required(ErrorMessage = "El campo Tipo de aseguradoraipo de aseguradora es obligatorio.")]
        [Display(Name = "Tipo de aseguradora")]
        public int idTipoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }

        [Required(ErrorMessage = "El campo Unidad Captura es obligatorio.")]
        [Display(Name = "Unidad Captura")]
        public int UnidadCaptura { get; set; }

        [Required(ErrorMessage = "El campo Nombre Comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }
        public int Estado { get; set; }
        public DateTime FechaProceso { get; set; }
        public DateTime FechaEstado { get; set; }
        public int idCodigoAseguradora { get; set; }
    }
}