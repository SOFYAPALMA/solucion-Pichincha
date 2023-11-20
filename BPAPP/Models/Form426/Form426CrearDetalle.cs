using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ProyectoWeb.Models.Form426
{
    public class Form426CrearDetalle
    {
        [Required(ErrorMessage = "El campo Subcuenta es obligatorio.")]
        [Display(Name = "Subcuenta")]
        public int Subcuenta { get; set; }

        [Required(ErrorMessage = "El campo Característica del crédito es obligatorio.")]
        [Display(Name = "Caracteristica del Credito")]
        public int idCaracteristicaCredito { get; set; }

        [Required(ErrorMessage = "El campo Costo es obligatorio.")]
        [Display(Name = "Costo")]
        public int Costo { get; set; }

        [Required(ErrorMessage = "El campo Tasa es obligatorio.")]
        [Display(Name = "Tasa")]
        public int Tasa { get; set; }

        [Required(ErrorMessage = "El campo Tipo de aseguradora es obligatorio.")]
        [Display(Name = "Tipo Aseguradora")]
        public int idTipoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo Codigo aseguradora es obligatorio.")]
        [Display(Name = "Codigo Aseguradora")]
        public int idCodigoAseguradora { get; set; }

        [Required(ErrorMessage = "El campo Observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        public int idObservaciones { get; set; }

        [Required(ErrorMessage = "El campo unidad captura es obligatorio.")]
        [Display(Name = "Unidad Captura")]
        public int UnidadCaptura { get; set; }
    }
}