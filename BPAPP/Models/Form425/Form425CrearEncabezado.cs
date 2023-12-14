using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425CrearEncabezado
    {  /// <summary>
       /// Referencia a al tipo entidad
       /// </summary>

        [Display(Name = "Tipo")]
        public string Tipo { get; } = "001"; //Campo fijo por default= 001

        [Display(Name = "Codigo")]
        public string Codigo { get; } = "00057"; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Display(Name = "Apertura Digital")]
        public int? idAperturaDigital { get; set; }

        [Display(Name = "Número de clientes únicos")]
        public int? NumeroClientes { get; set; }

        [Display(Name = "Franquicia")]
        public int? idFranquicia { get; set; }

        [Display(Name = "Cuota de Manejo")]
        public int? CuotaManejo { get; set; }

        [Display(Name = "Observaciones Cuota de Manejo")]
        public int? idObservacionesCuota { get; set; }

        [Display(Name = "Grupo Poblacional")]
        public int? idGrupoPoblacional { get; set; }

        [Display(Name = "Ingresos")]
        public int Ingresos { get; set; }

        [Display(Name = "Cuota Manejo Maxima")]
        public int? CuotaManejoMaxima { get; set; }

        [Display(Name = "Cupo")]
        public int? idCupo { get; set; }

        [Display(Name = "Servicio Gratuito 1")]
        public int? idServicioGratuito_1 { get; set; }

        [Display(Name = "Servicio Gratuito 2")]
        public int? idServicioGratuito_2 { get; set; }

        [Display(Name = "Servicio Gratuito 3")]
        public int? idServicioGratuito_3 { get; set; }

        [Display(Name = "Usuario")]
        public int Usuario { get; set; }

        [Display(Name = "Estado")]
        public int Estado { get; set; }

        [Display(Name = "Fecha corte")]
        public string Fechacorte { get; set; }

        [Display(Name = "Fecha Estado")]
        public string FechaEstado { get; set; }

        [Display(Name = "Codigo Registro")]
        public int CodigoRegistro { get; set; }

        [Display(Name = "Fecha hora actualizacion")]
        public string Fecha_horaActualizacion { get; set; }
        public int idPropiedadesFormato { get; set; }

        [Display(Name = "Nombre Comercial")]
        public int? idNombreComercial { get; set; }
    }
}