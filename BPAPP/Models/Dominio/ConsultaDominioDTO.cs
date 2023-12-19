using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class ConsultaDominioDTO
    {
        public int Dominio { get; set; }

        [Display(Name = "Código dominio")]
        public int idDominioGen { get; set; }

        [Display(Name = "Código tipo dominio")]
        public int idDominio { get; set; }

        [Display(Name = "Descripción")]
        public string Descripcion { get; set; }
        public int idCodigo { get; set; }
        public string Fecha { get; set; }
        [Display(Name = "Estado")]
        public string Estado { get; set; }
    }
}
