using System;

namespace ProyectoWeb.Models
{
    public class Form426ConsultaEncabezado
    {
        public string PropiedadesFormato { get; set; }

        [Display(Name = "Registro")]
        public int idPropiedadesFormato { get; set; }
        public int Tipo { get; set; }
        public int Codigo { get; set; }
        public string Nombre { get; set; }
        public string CodigoCredito { get; set; }
        public int idCodigoCredito { get; set; }
        public string AperturaDigital { get; set; }
        public int idAperturaDigital { get; set; }
        public string Fecha_horaActualizacion { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }
        public string Fechacorte { get; set; }
        public string FechaEstado { get; set; }
        public int CodigoRegistro { get; set; }
        public string PropiedadesFormatoAnterior { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }
    }
}