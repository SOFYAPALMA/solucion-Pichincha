using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaModelo
{
    public class Formulario425_Detalle
    {
        public int Subcuentas { get; set; }
        public int OperacionoServicio { get; set; }
        public int Canal { get; set; }
        public int CostoFijo { get; set; }
        public int CostoFijoMaximo { get; set; }
        public int CostoProporcionalalaOperacionoServicio { get; set; }
        public int CostoProporcionalMaximoalaOperacionoServicio { get; set; }
        public char Tasa { get; set; }
        public char TasaMaxima { get; set; }
        public int TipoAseguradora { get; set; }
        public int CodigoAseguradora { get; set; }
        public int Observaciones { get; set; }
    }
}
