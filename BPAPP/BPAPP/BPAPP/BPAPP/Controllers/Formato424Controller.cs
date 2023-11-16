using CapaDatos;
using CapaModelo;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    public class Formato424Controller : Controller
    {
        // GET: NivelAcademico
        public ActionResult Crear()
        {
            return View();
        }

        public JsonResult Listar()
        {
            List<Formato424> oListaNivel = CD_Formato424.Listar();
            return Json(new { data = oListaNivel }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult Guardar(Formato424 oNivel)
        {
            bool respuesta = true;

            try
            {
                oNivel.HoraInicio = Convert.ToDateTime(oNivel.TextoHoraInicio, new CultureInfo("es-ES"));
                oNivel.HoraFin = Convert.ToDateTime(oNivel.TextoHoraFin, new CultureInfo("es-ES"));

                if (oNivel.IdNivel == 0)
                {
                    respuesta = CD_Formato424.Registrar(oNivel);
                }
                else
                {
                    respuesta = CD_Formato424.Editar(oNivel);
                }

            }
            catch
            {

                respuesta = false;
            }


            return Json(new { resultado = respuesta }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult Eliminar(int idnivel = 0)
        {
            bool respuesta = CD_Formato424.Eliminar(idnivel);

            return Json(new { resultado = respuesta }, JsonRequestBehavior.AllowGet);
        }

    }
}