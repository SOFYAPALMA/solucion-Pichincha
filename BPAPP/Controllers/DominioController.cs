using BP.Repositorio;
using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    [Authorize]
    public class DominioController : Controller
    {
        public ActionResult Crear()
        {
            CrearTipoDominioDTO dominio = new CrearTipoDominioDTO();
            //LlenadoListasDominio();

            return View(dominio);
        }

        public ActionResult CrearDetalle(int id)
        {
            CrearTipoDominioDTO dominio = new CrearTipoDominioDTO();
            dominio.idDominio = id;
            //LlenadoListasDetalle();

            return View(dominio);
        }

        public ActionResult Details(int id)
        {
            TipoDominioModel encabezado = DatosDominio.DetalleTipoDominio(id);
            ConsultaTipoDominioDTO td = Mapper.getMapper(encabezado);

            List<DominioModel> encabezados = DatosDominio.ListaDominios(id);
            List<ConsultaDominioDTO> Detalles = Mapper.getMapper(encabezados);

            ViewBag.ListaDetalles = Detalles;
            //LlenadoListasEncabezado();
            return View(td);
        }

        public ActionResult List()
        {
            List<TipoDominioModel> encabezados = DatosDominio.ListaTiposDominios();
            List<ConsultaTipoDominioDTO> enc = Mapper.getMapper(encabezados);

            return View(enc);
        }

        public ActionResult ListDetalles(int id)
        {
            List<DominioModel> encabezados = DatosDominio.ListaDominios(id);
            List<ConsultaDominioDTO> det = Mapper.getMapper(encabezados);

            return View(det);
        }
    }
}