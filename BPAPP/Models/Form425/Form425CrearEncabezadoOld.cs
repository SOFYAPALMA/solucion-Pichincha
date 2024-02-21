using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425CrearEncabezadoOld
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>

        [Display(Name = "Tipo")]
        public int Tipo { get; } = 001; //Campo fijo por default= 001

        [Display(Name = "Codigo")]
        public int Codigo { get; } = 00057; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Display(Name = "Fecha Hora Reporte")]
        public DateTime FechaHora { get; set; }

        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }

        [Display(Name = "Apertura Digital")]
        public int AperturaDigital { get; set; }

        [Display(Name = "Número de clientes únicos")]
        public int NumerodeClientesUnicos { get; set; }

        [Display(Name = "Franquicia")]
        public int Franquicia { get; set; }

        [Display(Name = "Cuota de Manejo")]
        public int CuotadeManejo { get; set; }

        [Display(Name = "Observaciones Cuota de Manejo")]
        public int ObservacionesCuotadeManejo { get; set; }

        [Display(Name = "Grupo Poblacional")]
        public int GrupoPoblacional { get; set; }

        [Display(Name = "Ingresos")]
        public int Ingresos { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros1")]
        public int ServicioGratuitoCuentadeAhorros1 { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros2")]
        public int ServicioGratuitoCuentadeAhorros2 { get; set; }

        [Display(Name = "Servicio Gratuito Cuenta de Ahorros3")]
        public int ServicioGratuitoCuentadeAhorros3 { get; set; }

        [Display(Name = "Servicio Gratuito Tarjeta Debito1")]
        public int ServicioGratuitoTarjetaDebito1 { get; set; }

        [Display(Name = "Servicio Gratuito Tarjeta Debito2")]
        public int ServicioGratuitoTarjetaDebito2 { get; set; }

        [Display(Name = "Servicio Gratuito Tarjeta Debito3")]
        public int ServicioGratuitoTarjetaDebito3 { get; set; }
    }
}
