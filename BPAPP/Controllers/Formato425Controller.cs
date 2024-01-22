using BP.Repositorio;
using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    [Authorize]
    public class Formato425Controller : Controller
    {

        public ActionResult Crear()
        {
            Form425CrearEncabezado form425 = new Form425CrearEncabezado();
            LlenadoListasEncabezado();
            return View(form425);
        }

        public ActionResult CrearDetalle(int id)
        {
            Form425CrearDetalle form425 = new Form425CrearDetalle();
            form425.idPropiedadesFormato = id;
            LlenadoListasDetalle();

            return View(form425);
        }

        [HttpPost]
        public ActionResult Crear(Form425CrearEncabezado form425)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                int idusuario = int.Parse(Session["IdUsuario"].ToString());

                Formulario425_Encabezado encabezado = Mapper.getMapper(form425);
                encabezado.Usuario = idusuario;
                bool respuesta = DatosFormato425.RegistrarEncabezado(encabezado);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato425.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el encabezado, por favor valide los datos.");
                    LlenadoListasEncabezado();
                    return View(form425);
                }
            }
            else
            {
                LlenadoListasEncabezado();
                return View(form425);
            }
        }

        [HttpPost]
        public ActionResult CrearDetalle(Form425CrearDetalle form425)
        {
            if (ModelState.IsValid)
            {
                /* //Validaciones
                 if (form425.CostoFijo == 0)
                 {
                     ModelState.AddModelError("CostoFijo", "Agregue un valor diferente de cero.");
                     LlenadoListasDetalle();
                     return View(form425);
                 }

                 if (form425.CostoFijoMaximo == 0)
                 {
                     ModelState.AddModelError("CostoFijoMaximo", "Agregue un valor diferente de cero.");
                     LlenadoListasDetalle();
                     return View(form425);
                 }

                 if (form425.CostoProporcionOperacionServicio == 0)
                 {
                     ModelState.AddModelError("CostoProporcionOperacionServicio", "Agregue un valor diferente de cero.");
                     LlenadoListasDetalle();
                     return View(form425);
                 }

                 if (form425.CostoProporcionMaxOperacionServicio == 0)
                 {
                     ModelState.AddModelError("CostoProporcionMaxOperacionServicio", "Agregue un valor diferente de cero.");
                     LlenadoListasDetalle();
                     return View(form425);
                 }*/

                Formulario425_Detalle encabezado = Mapper.getMapper(form425);

                bool respuesta = DatosFormato425.RegistrarDetalle(encabezado);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato425.Mensaje;

                    return RedirectToAction("Details/" + form425.idPropiedadesFormato);
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el detalle, por favor valide los datos.");
                    LlenadoListasDetalle();
                    return View(form425);
                }

            }
            else
            {
                LlenadoListasDetalle();
                return View(form425);
            }
        }

        public ActionResult Update(int id)
        {
            Formulario425_Encabezado encabezado = DatosFormato425.Detalles(id);
            Form425ConsultaEncabezado form425 = Mapper.getMapper(encabezado);
            LlenadoListasEncabezado();
            return View(form425);
        }

        public ActionResult UpdateDetalle(int id)
        {
            Formulario425_Detalle detalle = DatosFormato425.DetallesDetalles(id);
            Form425ConsultaDetalle form425 = Mapper.getMapper(detalle);
            LlenadoListasDetalle();
            LlenadoAseguradoras(form425.idTipoAseguradora);
            return View(form425);
        }

        [HttpPost]
        public ActionResult UpdateDetalle(Form425ConsultaDetalle detalle)
        {
            if (ModelState.IsValid)
            {
                Formulario425_Detalle upd = Mapper.getMapper(detalle);
                bool respuesta = DatosFormato425.ActualizarDetalle(upd);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato425.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo actualizar el detalle, por favor valide los datos.");
                    LlenadoListasDetalle();
                    return View(detalle);
                }
            }
            else
            {
                LlenadoListasDetalle();
                return View(detalle);
            }
        }

        [HttpPost]
        public ActionResult Update(Form425ConsultaEncabezado encabezado)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                int idusuario = int.Parse(Session["IdUsuario"].ToString());

                Formulario425_Encabezado upd = Mapper.getMapper(encabezado);
                upd.Usuario = idusuario;
                bool respuesta = DatosFormato425.ActualizarEncabezado(upd);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato425.Mensaje;

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
            Formulario425_Encabezado encabezado = DatosFormato425.Detalles(id);
            Form425ConsultaEncabezado form425 = Mapper.getMapper(encabezado);

            List<Formulario425_Detalle> encabezados = DatosFormato425.ListaDetalles(id);
            List<Form425ConsultaDetalle> form425Detalles = Mapper.getMapper(encabezados);

            ViewBag.ListaDetalles = form425Detalles;
            LlenadoListasEncabezado();
            return View(form425);
        }

        public ActionResult List()
        {
            List<Formulario425_Encabezado> encabezados = DatosFormato425.Lista();
            List<Form425ConsultaEncabezado> form425 = Mapper.getMapper(encabezados);

            return View(form425);
        }

        public ActionResult ListDetalles(int id)
        {
            List<Formulario425_Detalle> encabezados = DatosFormato425.ListaDetalles(id);
            List<Form425ConsultaDetalle> form425 = Mapper.getMapper(encabezados);

            return View(form425);
        }

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        private void LlenadoListasEncabezado()
        {

            List<DominioModel> tipodeProductoDeposito = DatosDominio.Obtener(1);
            List<DominioModel> NombreComercial = DatosDominio.Obtener(22);
            List<DominioModel> AperturaDigital = DatosDominio.Obtener(2);
            List<DominioModel> Franquicia = DatosDominio.Obtener(7);
            List<DominioModel> observacionesCuotadeManejo = DatosDominio.Obtener(19);
            List<DominioModel> grupoPoblacional = DatosDominio.Obtener(3);
            List<DominioModel> idCupo = DatosDominio.Obtener(8);
            List<DominioModel> idServicioGratuito = DatosDominio.Obtener(9);

            if (tipodeProductoDeposito.Count() == 0)
            {
                ModelState.AddModelError("tipodeProductoDeposito", "No se encuentra valores para la lista de tipo de producto tarjeta de credito");
            }
            ViewBag.tipodeProductoDeposito = new SelectList(tipodeProductoDeposito, "Dominio", "Descripcion");

            if (NombreComercial.Count() == 0)
            {
                ModelState.AddModelError("NombreComercial", "No se encuentra valores para la lista de tipo de producto nombre comercial");
            }
            ViewBag.NombreComercial = new SelectList(NombreComercial, "Dominio", "Descripcion");

            if (AperturaDigital.Count() == 0)
            {
                ModelState.AddModelError("idAperturaDigital", "No se encuentra valores para la lista de apertura digital");
            }
            ViewBag.AperturaDigital = new SelectList(AperturaDigital, "Dominio", "Descripcion");

            if (Franquicia.Count() == 0)
            {
                ModelState.AddModelError("idFranquicia", "No se encuentra valores para la lista de franquicia");
            }
            ViewBag.Franquicia = new SelectList(Franquicia, "Dominio", "Descripcion");

            if (observacionesCuotadeManejo.Count() == 0)
            {
                ModelState.AddModelError("ObservacionesCuotadeManejo", "No se encuentra valores para la lista de observaciones cuota de manejo");
            }
            ViewBag.ObservacionesCuotadeManejo = new SelectList(observacionesCuotadeManejo, "Dominio", "Descripcion");

            if (grupoPoblacional.Count() == 0)
            {
                ModelState.AddModelError("GrupoPoblacional", "No se encuentra valores para la lista de grupo poblacional");
            }
            ViewBag.GrupoPoblacional = new SelectList(grupoPoblacional, "Dominio", "Descripcion");

            if (idCupo.Count() == 0)
            {
                ModelState.AddModelError("idCupo", "No se encuentra valores para la lista de cupo");
            }
            ViewBag.Cupo = new SelectList(idCupo, "Dominio", "Descripcion");


            if (idServicioGratuito.Count() == 0)
            {
                ModelState.AddModelError("idServicioGratuito", "No se encuentra valores para la lista de servicio gratuito");
            }
            ViewBag.ServicioGratuito = new SelectList(idServicioGratuito, "Dominio", "Descripcion");

        }

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        private void LlenadoListasDetalle()
        {
            List<DominioModel> idOperacionServicio = DatosDominio.Obtener(12);
            List<DominioModel> idCanal = DatosDominio.Obtener(20);
            List<Aseguradoras> idTipoAseguradora = DatosAseguradoras.Tipos();
            List<DominioModel> idObservaciones = DatosDominio.Obtener(13);

            if (idOperacionServicio.Count() == 0)
            {
                ModelState.AddModelError("idOperacionoServicio", "No se encuentra valores para la lista de tipo de descripcion operacion servicio");
            }
            ViewBag.DescripcionOperacionServicio = new SelectList(idOperacionServicio, "Dominio", "Descripcion");

            if (idCanal.Count() == 0)
            {
                ModelState.AddModelError("Canal", "No se encuentra valores para la lista de tipo de canal");
            }
            ViewBag.Canal = new SelectList(idCanal, "Dominio", "Descripcion");

            if (idTipoAseguradora.Count() == 0)
            {
                ModelState.AddModelError("idTipoAseguradora", "No se encuentra valores para la lista de Tipo aseguradora");
            }
            ViewBag.TipoAseguradora = new SelectList(idTipoAseguradora, "Tipo", "Descripcion");

            if (idObservaciones.Count() == 0)
            {
                ModelState.AddModelError("idObservaciones", "No se encuentra valores para la lista de Observaciones");
            }
            ViewBag.Observaciones = new SelectList(idObservaciones, "Dominio", "Descripcion");
            ViewBag.CodigoAseguradora = new SelectList(new List<Aseguradoras>(), "Codigo", "Descripcion");
        }

        [HttpGet]
        public JsonResult LlenadoAseguradoras(int? tipo)
        {
            List<Aseguradoras> idCodigoAseguradora = DatosAseguradoras.Lista(tipo);

            if (idCodigoAseguradora.Count() == 0)
            {
                ModelState.AddModelError("idCodigoAseguradora", "No se encuentra valores para la lista de codigo aseguradora");
            }
            ViewBag.CodigoAseguradora = new SelectList(idCodigoAseguradora, "Codigo", "Descripcion");
            return Json(new SelectList(idCodigoAseguradora, "Codigo", "Descripcion"), JsonRequestBehavior.AllowGet);
        }

    }
}