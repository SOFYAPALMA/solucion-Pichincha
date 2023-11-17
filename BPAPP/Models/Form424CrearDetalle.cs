using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ProyectoWeb.Models
{
    public class Form424CrearDetalle
    {
        [Required(ErrorMessage = "El campo Subcuentas es obligatorio.")]
        [Display(Name = "Subcuentas")]
        [StringLength(3)]
        [DataType(DataType.Text)]
        public int Subcuentas { get; set; }

        [Required(ErrorMessage = "El campo Operacion o Servicio es obligatorio.")]
        [Display(Name = "Operacion o Servicio")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int OperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo Canal es obligatorio.")]
        [Display(Name = "Canal")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int Canal { get; set; }

        [Required(ErrorMessage = "El campo Número de operaciones o servicios incluidos en cuota de manejo es obligatorio.")]
        [Display(Name = "Número de operaciones o servicios incluidos en cuota de manejo")]
        [StringLength(3)]
        [DataType(DataType.Text)]
        public int NumerodeOperacionoServiciosIncluidosenCuotadeManejo { get; set; }

        [Required(ErrorMessage = "El campo Costo fijo es obligatorio.")]
        [Display(Name = "Costo fijo")]
        [StringLength(6)]
        [DataType(DataType.Text)]
        public int CostoFijo { get; set; }

        [Required(ErrorMessage = "El campo Costo proporcional a operación o servicio es obligatorio.")]
        [Display(Name = "Costo proporcional a operación o servicio")]
        [StringLength(6)]
        [DataType(DataType.Text)]
        public int CostoProporcionalalaOperacionoServicio { get; set; }

        [Required(ErrorMessage = "El campo Observaciones es obligatorio.")]
        [Display(Name = "Observaciones")]
        [StringLength(2)]
        [DataType(DataType.Text)]
        public int Observaciones { get; set; }

    }
}