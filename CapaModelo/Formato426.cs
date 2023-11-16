using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaModelo
{
    public class Formato426
    {
        public int idPropiedadesFormato { get; set; }
        public int Tipo { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public int idCodigoCredito { get; set; }
        public int idAperturaDigital { get; set; }
        public DateTime Fecha_horaActualizacion { get; set; }
        public string Usuario { get; set; }
        public DateTime Fechacorte { get; set; }
        public DateTime FechaEstado { get; set; }
        public string CodigoRegistro { get; set; }
    }
}
