using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425CrearEncabezado
    {  /// <summary>
       /// Referencia a al tipo entidad
       /// </summary>
        [Required(ErrorMessage = "El campo tipo entidad es obligatorio.")]
        [Display(Name = "Tipo")]
        public int Tipo { get; } = 001; //Campo fijo por default= 001

        [Required(ErrorMessage = "El campo código entidad es obligatorio.")]
        [Display(Name = "Codigo")]
        public int Codigo { get; } = 00057; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Required(ErrorMessage = "El campo nombre o sigla de la entidad es obligatorio.")]
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Required(ErrorMessage = "El campo apertura digital es obligatorio.")]
        [Display(Name = "Apertura Digital")]
        public int idAperturaDigital { get; set; }

        [Required(ErrorMessage = "El campo número de clientes únicos es obligatorio.")]
        [Display(Name = "Número de clientes únicos")]
        public int NumeroClientes { get; set; }

        [Required(ErrorMessage = "El campo franquicia es obligatorio.")]
        [Display(Name = "Franquicia")]
        public int idFranquicia { get; set; }

        [Required(ErrorMessage = "El campo cuota de manejo es obligatorio.")]
        [Display(Name = "Cuota de Manejo")]
        public int CuotaManejo { get; set; }

        [Required(ErrorMessage = "El campo observaciones cuota de manejo es obligatorio.")]
        [Display(Name = "Observaciones Cuota de Manejo")]
        public int idObservacionesCuota { get; set; }

        [Required(ErrorMessage = "El campo grupo poblacional es obligatorio.")]
        [Display(Name = "Grupo Poblacional")]
        public int idGrupoPoblacional { get; set; }

        [Required(ErrorMessage = "El campo ingresos es obligatorio.")]
        [Display(Name = "Ingresos")]
        public int Ingresos { get; set; }

        [Required(ErrorMessage = "El campo cuota manejo máxima es obligatorio.")]
        [Display(Name = "Cuota Manejo Maxima")]
        public int CuotaManejoMaxima { get; set; }

        [Required(ErrorMessage = "El campo cupo es obligatorio.")]
        [Display(Name = "Cupo")]
        public int idCupo { get; set; }

        [Required(ErrorMessage = "El campo servicio gratuito 1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito 1")]
        public int idServicioGratuito_1 { get; set; }

        [Required(ErrorMessage = "El campo servicio gratuito 2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito 2")]
        public int idServicioGratuito_2 { get; set; }

        [Required(ErrorMessage = "El campo servicio gratuito 3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito 3")]
        public int idServicioGratuito_3 { get; set; }

        [Required(ErrorMessage = "El campo usuario es obligatorio.")]
        [Display(Name = "Usuario")]
        public int Usuario { get; set; }

        [Required(ErrorMessage = "El campo estado es obligatorio.")]
        [Display(Name = "Estado")]
        public int Estado { get; set; }

        [Display(Name = "Fecha corte")]
        public string Fechacorte { get; set; }

        [Display(Name = "Fecha Estado")]
        public string FechaEstado { get; set; }

        [Required(ErrorMessage = "El campo código registro es obligatorio.")]
        [Display(Name = "Codigo Registro")]
        public int CodigoRegistro { get; set; }

        [Display(Name = "Fecha hora actualizacion")]
        public string Fecha_horaActualizacion { get; set; }
        public int idPropiedadesFormato { get; set; }

        [Required(ErrorMessage = "El campo nombre comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }
    }
}