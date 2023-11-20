using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoWeb.Models.Form426
{
    public class Form425ConsultaEncabezado
    {
        public int idPropiedadesFormato { get; set; }
        public int Tipo { get; set; }
        public int Codigo { get; set; }
        public string Nombre { get; set; }
        public string idCodigoCredito { get; set; }
        public string idAperturaDigital { get; set; }
        public DateTime Fecha_horaActualizacion { get; set; }
        public int Usuario { get; set; }
        public string Estado { get; set; }
        public DateTime Fechacorte { get; set; }
        public DateTime FechaEstado { get; set; }
        public int CodigoRegistro { get; set; }
        public int idPropiedadesFormatoAnterior { get; set; }
    }
}