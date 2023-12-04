using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ProyectoWeb.Models.Dominio
{
    public class DominioConsultaEncabezado
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