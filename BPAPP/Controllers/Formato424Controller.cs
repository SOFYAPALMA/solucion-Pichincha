using CapaDatos;
using CapaModelo;
using ProyectoWeb.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    public class Formato424Controller : Controller
    {
        public ActionResult Crear()
        {
            Form424CrearEncabezado form424 = new Form424CrearEncabezado();
            LlenadoListas();
            return View(form424);
        }

        public ActionResult Update()
        {
            Form424CrearEncabezado form424 = new Form424CrearEncabezado();
            LlenadoListas();
            return View(form424);
        }

        public ActionResult Details()
        {
            Form424CrearEncabezado form424 = new Form424CrearEncabezado();
            LlenadoListas();
            return View(form424);
        }

        /*public JsonResult Listar()
        {
            List<Formato424> oListaNivel = CD_Formato424.Listar();
            return Json(new { data = oListaNivel }, JsonRequestBehavior.AllowGet);
        }*/

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        private void LlenadoListas()
        {
            List<Dominio> tipodeProductoDeposito = CD_Dominios.Obtener(1);
            List<Dominio> other = CD_Dominios.Obtener(111);

            if (tipodeProductoDeposito.Count() == 0)
            {
                ModelState.AddModelError("TipodeProductoDeposito", "No se encuentra valores para la lista de tipo de producto deposito");
            }
            ViewBag.TipodeProductoDeposito = new SelectList(tipodeProductoDeposito, "IdDominio", "Nombre");

            if (other.Count() == 0)
            {
                ModelState.AddModelError("OTRO", "No se encuentra valores para la lista de OTRO");
            }
            ViewBag.OTRO = new SelectList(other, "IdDominio", "Nombre");
        }

        [HttpPost]
        public JsonResult Guardar(Formato424 oNivel)
        {
            bool respuesta = true;

            try
            {
                oNivel.HoraInicio = Convert.ToDateTime(oNivel.TextoHoraInicio, new CultureInfo("es-ES"));
                oNivel.HoraFin = Convert.ToDateTime(oNivel.TextoHoraFin, new CultureInfo("es-ES"));

               /* if (oNivel.IdNivel == 0)
                {
                    respuesta = CD_Formato424.Registrar(oNivel);
                }
                else
                {
                    respuesta = CD_Formato424.Editar(oNivel);
                }*/

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