using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models.Dominio
{
    public class DominioCrearEncabezado
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>
        /// 
        [Display(Name = "Dominio")]
        public int Dominio { get; set; }
        public int idDominioGen { get; set; }
        public int idDominio { get; set; }

        [Display(Name = "Descripcion")]
        public string Descripcion { get; set; }
        public int idCodigo { get; set; }

        [Display(Name = "Fecha")]
        public string Fecha { get; set; }

        [Display(Name = "Estado")]
        public string Estado { get; set; }

    }
}