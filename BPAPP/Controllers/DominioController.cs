using ProyectoWeb.Models.Dominio;
using System;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    [Authorize]
    public class DominioController : Controller
    {
        public ActionResult Crear()
        {
            DominioCrearEncabezado dominio = new DominioCrearEncabezado();
            LlenadoListasDominio();

            return View(dominio);
        }

        public ActionResult CrearDetalle(int id)
        {
            DominioCrearEncabezado dominio = new DominioCrearEncabezado();
            dominio.idDominio = id;
            LlenadoListasDetalle();

            return View(dominio);
        }
    }
}