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
            List<Dominio> aperturaDeposito = CD_Dominios.Obtener(2);
            List<Dominio> grupoPoblacional = CD_Dominios.Obtener(3);
            List<Dominio> ingresos = CD_Dominios.Obtener(4);
            List<Dominio> observacionesCuotadeManejo = CD_Dominios.Obtener(5);
            List<Dominio> servicioGratuitoCuentadeAhorros1 = CD_Dominios.Obtener(6);
            List<Dominio> servicioGratuitoCuentadeAhorros2 = CD_Dominios.Obtener(6);
            List<Dominio> servicioGratuitoCuentadeAhorros3 = CD_Dominios.Obtener(6);
            List<Dominio> servicioGratuitoTarjetaDebito1 = CD_Dominios.Obtener(9);
            List<Dominio> servicioGratuitoTarjetaDebito2 = CD_Dominios.Obtener(9);
            List<Dominio> servicioGratuitoTarjetaDebito3 = CD_Dominios.Obtener(9);


            if (tipodeProductoDeposito.Count() == 0)
            {
                ModelState.AddModelError("TipodeProductoDeposito", "No se encuentra valores para la lista de tipo de producto deposito");
            }
            ViewBag.TipodeProductoDeposito = new SelectList(tipodeProductoDeposito, "IdDominio", "Nombre");

            if (aperturaDeposito.Count() == 0)
            {
                ModelState.AddModelError("AperturaDeposito", "No se encuentra valores para la lista de Apertura Deposito");
            }
            ViewBag.AperturaDeposito = new SelectList(aperturaDeposito, "IdDominio", "Nombre");

            if (grupoPoblacional.Count() == 0)
            {
                ModelState.AddModelError("GrupoPoblacional", "No se encuentra valores para la lista de Grupo Poblacional");
            }
            ViewBag.GrupoPoblacional = new SelectList(grupoPoblacional, "IdDominio", "Nombre");

            if (ingresos.Count() == 0)
            {
                ModelState.AddModelError("Ingresos", "No se encuentra valores para la lista de Ingresos");
            }
            ViewBag.Ingresos = new SelectList(ingresos, "IdDominio", "Nombre");

            if (observacionesCuotadeManejo.Count() == 0)
            {
                ModelState.AddModelError("ObservacionesCuotadeManejo", "No se encuentra valores para la lista de Observaciones Cuota de Manejo");
            }
            ViewBag.ObservacionesCuotadeManejo = new SelectList(observacionesCuotadeManejo, "IdDominio", "Nombre");

            if (servicioGratuitoCuentadeAhorros1.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoCuentadeAhorros1", "No se encuentra valores para la lista de Servicio Gratuito Cuenta de Ahorros1");
            }
            ViewBag.ServicioGratuitoCuentadeAhorros1 = new SelectList(servicioGratuitoCuentadeAhorros1, "IdDominio", "Nombre");

            if (servicioGratuitoCuentadeAhorros2.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoCuentadeAhorros2", "No se encuentra valores para la lista de Servicio Gratuito Cuenta de Ahorros2");
            }
            ViewBag.ServicioGratuitoCuentadeAhorros2 = new SelectList(servicioGratuitoCuentadeAhorros2, "IdDominio", "Nombre");

            if (servicioGratuitoCuentadeAhorros3.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoCuentadeAhorros3", "No se encuentra valores para la lista de Servicio Gratuito Cuenta de Ahorros1");
            }
            ViewBag.ServicioGratuitoCuentadeAhorros3 = new SelectList(servicioGratuitoCuentadeAhorros3, "IdDominio", "Nombre");

            if (servicioGratuitoTarjetaDebito1.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoTarjetaDebito1", "No se encuentra valores para la lista de Servicio Gratuito Tarjeta Debito1");
            }
            ViewBag.ServicioGratuitoTarjetaDebito1 = new SelectList(servicioGratuitoTarjetaDebito1, "IdDominio", "Nombre");

            if (servicioGratuitoTarjetaDebito2.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoTarjetaDebito2", "No se encuentra valores para la lista de Servicio Gratuito Tarjeta Debito2");
            }
            ViewBag.ServicioGratuitoTarjetaDebito2 = new SelectList(servicioGratuitoTarjetaDebito2, "IdDominio", "Nombre");

            if (servicioGratuitoTarjetaDebito3.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoTarjetaDebito3", "No se encuentra valores para la lista de Servicio Gratuito Tarjeta Debito3");
            }
            ViewBag.ServicioGratuitoTarjetaDebito3 = new SelectList(servicioGratuitoTarjetaDebito3, "IdDominio", "Nombre");

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