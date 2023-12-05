using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaModelo
{
    public class CreditosModel
    {
        public int idcodigo { get; set; }
        public int idProducto { get; set; }
        public decimal Monto_UVTs { get; set; }
        public int Plazo_meses { get; set; }
        public int CodigoRegistro { get; set; }
    }
}
