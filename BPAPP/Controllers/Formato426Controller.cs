using BP.Repositorio;
using CapaDatos;
using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    public class Formato426Controller : Controller
    {
        public ActionResult Crear()
        {
            Form426CrearEncabezado form426 = new Form426CrearEncabezado();
            LlenadoListasEncabezado();
            return View(form426);
        }

        public ActionResult CrearDetalle(int id)
        {
            Form426CrearDetalle form426 = new Form426CrearDetalle();
            form426.idPropiedadesFormato = id;
            LlenadoListasDetalle();

            return View(form426);
        }

        [HttpPost]
        public ActionResult Crear(Form426CrearEncabezado form426)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                string idusuario = Session["IdUsuario"].ToString();

                Formulario426_Encabezado encabezado = Mapper.getMapper(form426);
                encabezado.Usuario = idusuario;
                bool respuesta = DatosFormato426.RegistrarEncabezado(encabezado);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato426.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el encabezado, por favor valide los datos.");
                    LlenadoListasEncabezado();
                    return View(form426);
                }
            }
            else
            {
                LlenadoListasEncabezado();
                return View(form426);
            }
        }

        [HttpPost]
        public ActionResult CrearDetalle(Form426CrearDetalle form426)
        {
            if (ModelState.IsValid)
            {
                Formulario426_Detalle encabezado = Mapper.getMapper(form426);

                bool respuesta = DatosFormato426.RegistrarEncabezadoDetalle(encabezado);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato426.Mensaje;

                    return RedirectToAction("Details/" + form426.idPropiedadesFormato);
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el detalle, por favor valide los datos.");
                    LlenadoListasDetalle();
                    return View(form426);
                }
            }
            else
            {
                LlenadoListasDetalle();
                return View(form426);
            }
        }

        public ActionResult Update(int id)
        {
            Formulario426_Encabezado encabezado = DatosFormato426.Detalles(id);
            Form426ConsultaEncabezado form426 = Mapper.getMapper(encabezado);
            LlenadoListasEncabezado();
            return View(form426);
        }

        [HttpPost]
        public ActionResult Update(Form426ConsultaEncabezado encabezado)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                string idusuario = Session["IdUsuario"].ToString();

                Formulario426_Encabezado upd = Mapper.getMapper(encabezado);
                upd.Usuario = idusuario;
                bool respuesta = DatosFormato426.ActualizarEncabezado(upd);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato426.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo actualizar el encabezado, por favor valide los datos.");
                    LlenadoListasEncabezado();
                    return View(encabezado);
                }
            }
            else
            {
                LlenadoListasEncabezado();
                return View(encabezado);
            }
        }

        public ActionResult Details(int id)
        {
            Formulario426_Encabezado encabezado = DatosFormato426.Detalles(id);
            Form426ConsultaEncabezado form426 = Mapper.getMapper(encabezado);

            List<Formulario426_Detalle> encabezados = DatosFormato426.ListaDetalles(id);
            List<Form426ConsultaDetalle> form426Detalles = Mapper.getMapper(encabezados);

            ViewBag.ListaDetalles = form426Detalles;
            LlenadoListasEncabezado();
            return View(form426);
        }

        public ActionResult List()
        {
            List<Formulario426_Encabezado> encabezados = DatosFormato426.Lista();
            List<Form426ConsultaEncabezado> form426 = Mapper.getMapper(encabezados);

            return View(form426);
        }

        public ActionResult ListDetalles(int id)
        {
            List<Formulario426_Detalle> encabezados = DatosFormato426.ListaDetalles(id);
            List<Form426ConsultaDetalle> form426 = Mapper.getMapper(encabezados);

            return View(form426);
        }

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        private void LlenadoListasEncabezado()
        {
            List<Dominio> idCodigoCredito = CD_Dominios.Obtener(1);
            List<Dominio> idAperturaDigital = CD_Dominios.Obtener(2);


            if (idCodigoCredito.Count() == 0)
            {
                ModelState.AddModelError("idCodigoCredito", "No se encuentra valores para la lista de tipo de producto credito");
            }
            ViewBag.idCodigoCredito = new SelectList(idCodigoCredito, "IdDominio", "Nombre");

            if (idAperturaDigital.Count() == 0)
            {
                ModelState.AddModelError("AperturaDeposito", "No se encuentra valores para la lista de Apertura Deposito");
            }
            ViewBag.AperturaDigital = new SelectList(idAperturaDigital, "IdDominio", "Nombre");


            /// <summary>
            /// Llena las listas que requiere el controlador
            /// </summary>
            /// 
            private void LlenadoListasDetalle()
            {
                List<Dominio> idOperacionServicio = CD_Dominios.Obtener(10);
                List<Dominio> idCanal = CD_Dominios.Obtener(20);
                List<Dominio> CostoProporcionOperacionServicio = CD_Dominios.Obtener(10);
                List<Dominio> idObservaciones = CD_Dominios.Obtener(11);

                if (idOperacionServicio.Count() == 0)
                {
                    ModelState.AddModelError("Descripcion Operacion Servicio", "No se encuentra valores para la lista de tipo de Descripcion operacion servicio");
                }
                ViewBag.DescripcionOperacionServicio = new SelectList(idOperacionServicio, "IdDominio", "Nombre");

                if (idCanal.Count() == 0)
                {
                    ModelState.AddModelError("Canal", "No se encuentra valores para la lista de tipo de Canal");
                }
                ViewBag.Canal = new SelectList(idCanal, "IdDominio", "Nombre");

                if (CostoProporcionOperacionServicio.Count() == 0)
                {
                    ModelState.AddModelError("costoProporcionOperacionServicio", "No se encuentra valores para la lista de Costo proporcion operacion servicio");
                }
                ViewBag.costoProporcionOperacionServicio = new SelectList(CostoProporcionOperacionServicio, "IdDominio", "Nombre");

                if (idObservaciones.Count() == 0)
                {
                    ModelState.AddModelError("ID Observaciones", "No se encuentra valores para la lista de ID Observaciones");
                }
                ViewBag.IDObservaciones = new SelectList(idObservaciones, "IdDominio", "Nombre");

            }
        }
    }

}