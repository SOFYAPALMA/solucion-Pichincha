using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class CrearTipoDominioDTO
    {
        [Required(ErrorMessage = "El campo Numero Dominio es obligatorio.")]
        [Display(Name = "Codigo Dominio")]
        public int idDominio { get; set; }

        [Required(ErrorMessage = "El campo Descripción es obligatorio.")]
        [Display(Name = "Descripción dominio")]
        public string Descripcion { get; set; }

        [Display(Name = "Fecha")]
        public string Fecha { get; set; }

        [Display(Name = "Estado")]
        public bool Estado { get; set; }

        [Display(Name = "Columna")]
        public string Columna { get; set; }

    }
}