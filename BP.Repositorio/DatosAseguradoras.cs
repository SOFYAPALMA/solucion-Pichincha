using CapaModelo;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BP.Repositorio
{
    public class DatosAseguradoras : ConexionMS
    {
        private static DatosAseguradoras instance = null;

        public static DatosAseguradoras Instanciar()
        {
            if (instance == null)
            {
                instance = new DatosAseguradoras();
            }
            return instance;
        }

        static DatosAseguradoras()
        {

        }

        public static string Mensaje { get; private set; }

        public static Aseguradoras DetallesDetalles(int asg)
        {
            try
            {
                Aseguradoras rpt = new Aseguradoras();
                limpiarParametros();
                AdicionarParametros("")


            }



        }


    }
}
