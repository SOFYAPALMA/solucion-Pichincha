using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class CrearTipoDominioDTO
    {
        public int idDominio { get; set; }
        public string Descripcion { get; set; }
        public string Fecha { get; set; }
        public string Estado { get; set; }

        public string Columna { get; set; }

    }
}