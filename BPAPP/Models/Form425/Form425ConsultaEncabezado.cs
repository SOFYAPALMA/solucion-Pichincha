using System;
using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form425ConsultaEncabezado
    {
        [Display(Name = "Número Registro")]
        public int idPropiedadesFormato { get; set; }

        [Display(Name = "Tipo Entidad")]
        public string Tipo { get; set; } = "001"; //Campo fijo por default= 001
      
        [Display(Name = "Codigo")]
        public string Codigo { get; set; } = "00057"; //Campo fijo por default= 00057

        [Display(Name = "Nombre")]
        public string Nombre { get; set; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        public string AperturaDigital { get; set; }

        [Display(Name = "Apertura Digital")]
        public int idAperturaDigital { get; set; }

        [Display(Name = "Numero de clientes unicos")]
        public int NumeroClientes { get; set; }
        public string Franquicia { get; set; }

        [Display(Name = "Franquicia")]
        public int idFranquicia { get; set; }

        [Display(Name = "Cuota de manejo")]
        public int CuotaManejo { get; set; }
        public string ObservacionesCuota { get; set; }

        [Display(Name = "Observaciones cuota de manejo")]
        public int idObservacionesCuota { get; set; }

        [Display(Name = "Cuota de manejo maxima")]
        public int CuotaManejoMaxima { get; set; }
        public string GrupoPoblacional { get; set; }

        [Display(Name = "Grupo poblacional")]
        public int idGrupoPoblacional { get; set; }
        public string Cupo { get; set; }

        [Display(Name = "Cupo")]
        public int idCupo { get; set; }
        public string ServicioGratuito_1 { get; set; }

        [Display(Name = "Servicio gratuito 1")]
        public int? idServicioGratuito_1 { get; set; }
        public string ServicioGratuito_2 { get; set; }

        [Display(Name = "Servicio gratuito 2")]
        public int? idServicioGratuito_2 { get; set; }
        public string ServicioGratuito_3 { get; set; }

        [Display(Name = "Servicio gratuito 3")]
        public int? idServicioGratuito_3 { get; set; }

        [Display(Name = "Fecha Hora")]
        public string Fecha_horaActualizacion { get; set; }
        public int Usuario { get; set; }
        public string Estado { get; set; }
        [Display(Name = "Estado")]
        public string DescripcionEstado { get; set; }
        public string Fechacorte { get; set; }
        public string FechaEstado { get; set; }
        [Display(Name = "Registro SFC")]
        public string CodigoRegistro { get; set; }

        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }    
        
        [Display(Name = "Nombre Comercial")]
        public string NombreComercial { get; set; }

    }
}