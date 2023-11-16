using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ProyectoWeb.Models
{
    public class Form424CrearEncabezado
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>
        [Required(ErrorMessage = "El campo tipo entidad es obligatorio.")]
        [Display(Name = "Tipo entidad")]
        [StringLength(3)]
        [DataType(DataType.Text)]
        public int Tipo { get; set; }


        public int Codigo { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [Required(ErrorMessage = "El campo nombre es obligatorio.")]
        [Display(Name = "Nombre")]
        [StringLength(3)]
        [DataType(DataType.Text)]
        public string Nombre { get; set; }
        public DateTime FechaHora { get; set; }
        public string NombreComercial { get; set; }
        public int TipodeProductoDeposito { get; set; }
        public int AperturaDigital { get; set; }
        public int NumerodeClientesUnicos { get; set; }
        public int CuotadeManejo { get; set; }
        public int ObservacionesCuotadeManejo { get; set; }
        public int GrupoPoblacional { get; set; }
        public int Ingresos { get; set; }
        public int ServicioGratuitoCuentadeAhorros1 { get; set; }
        public int ServicioGratuitoCuentadeAhorros2 { get; set; }
        public int ServicioGratuitoCuentadeAhorros3 { get; set; }
        public int ServicioGratuitoTarjetaDebito1 { get; set; }
        public int ServicioGratuitoTarjetaDebito2 { get; set; }
        public int ServicioGratuitoTarjetaDebito3 { get; set; }
    }
}