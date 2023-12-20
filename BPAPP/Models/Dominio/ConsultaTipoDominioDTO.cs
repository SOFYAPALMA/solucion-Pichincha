using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class ConsultaTipoDominioDTO
    {
        [Display(Name = "Código tipo dominio")]
        public int idDominio { get; set; }

        [Display(Name = "Descripción dominio")]
        public string Descripcion { get; set; }
        public string Fecha { get; set; }

        [Display(Name = "Estado")]
        public bool Estado { get; set; }
        public string Columna { get; set; }
    }
}