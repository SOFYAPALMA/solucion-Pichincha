using BP.Repositorio;
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

        [HttpPost]
        public ActionResult Crear(Form424CrearEncabezado form424)
        {
            if (ModelState.IsValid)
            {
                Formulario424_EncabezadoCrear encabezado = Mapper.getMapper(form424);
                bool respuesta = DatosFormato424.RegistrarEncabezado(encabezado);

                if(respuesta)
                {
                    TempData["Notificacion"] = CD_Formato424.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el encabezado, por favor valide los datos.");
                    LlenadoListas();  
                    return View(form424);
                }
            }
            else
            {
                LlenadoListas();
                return View(form424);
            }
        }

        public ActionResult Update()
        {
            Form424CrearEncabezado form424 = new Form424CrearEncabezado();
            LlenadoListas();
            return View(form424);
        }

        public ActionResult Details(int id)
        {
            Formulario424_EncabezadoConsulta encabezado = DatosFormato424.Detalles(id);
            Form424ConsultaEncabezado form424 = Mapper.getMapper(encabezado);
            LlenadoListas();
            return View(form424);
        }

        public ActionResult List()
        {
            List<Formulario424_EncabezadoConsulta> encabezados = DatosFormato424.Lista();
            List<Form424ConsultaEncabezado> form424 = Mapper.getMapper(encabezados);

            return View(form424);
        }

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
            List<Dominio> servicioGratuitoCuentadeAhorros = CD_Dominios.Obtener(6);
            List<Dominio> servicioGratuitoTarjetaDebito = CD_Dominios.Obtener(9);

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

            if (servicioGratuitoCuentadeAhorros.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoCuentadeAhorros1", "No se encuentra valores para la lista de Servicio Gratuito Cuenta de Ahorros");
            }
            ViewBag.ServicioGratuitoCuentadeAhorros = new SelectList(servicioGratuitoCuentadeAhorros, "IdDominio", "Nombre");


            if (servicioGratuitoTarjetaDebito.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoTarjetaDebito1", "No se encuentra valores para la lista de Servicio Gratuito Tarjeta Debito");
            }
            ViewBag.ServicioGratuitoTarjetaDebito = new SelectList(servicioGratuitoTarjetaDebito, "IdDominio", "Nombre");
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