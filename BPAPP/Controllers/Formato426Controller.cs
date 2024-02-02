using BP.Repositorio;
using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    [Authorize]
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

                bool respuesta = DatosFormato426.RegistrarDetalle(encabezado);

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
            LlenadoCreditos(form426.TipoProductoCredito);
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

        //[HttpPost]
        ////[ValidateAntiForgeryToken]
        //public ActionResult DeleteEncabezado(int id)
        //{
        //    if (ModelState.IsValid)
        //    {
        //         bool respuesta = DatosFormato426.EliminarEncabezado(id);

        //        if (respuesta)
        //        {
        //            TempData["Notificacion"] = DatosFormato426.Mensaje;
        //            ModelState.AddModelError("", DatosFormato426.Mensaje);
        //            return RedirectToRoute("List");
        //        }
        //        else
        //        {
        //            ModelState.AddModelError("", "No se puede eliminar el encabezado tiene detalle.");
        //            LlenadoListasEncabezado();
        //            return View();
        //        }
        //    }
        //    else
        //    {
        //        LlenadoListasEncabezado();
        //        return View();
        //    }
        //}

        [HttpPost]
        public ActionResult DeleteDetalle(Formulario426_Detalle obj)
        {
            if (ModelState.IsValid)
            {
                bool respuesta = DatosFormato426.EliminarDetalle(obj);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato426.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se puede eliminar el detalle.");
                    LlenadoListasEncabezado();
                    return View();
                }
            }
            else
            {
                LlenadoListasEncabezado();
                return View();
            }
        }

        public ActionResult UpdateDetalle(int id)
        {
            Formulario426_Detalle detalle = DatosFormato426.DetallesDetalles(id);
            Form426ConsultaDetalle form426 = Mapper.getMapper(detalle);
            LlenadoListasDetalle();
            LlenadoAseguradoras(form426.idTipoAseguradora);
            return View(form426);
        }

        [HttpPost]
        public ActionResult UpdateDetalle(Form426ConsultaDetalle detalle)
        {
            if (ModelState.IsValid)
            {
                Formulario426_Detalle upd = Mapper.getMapper(detalle);
                bool respuesta = DatosFormato426.ActualizarDetalle(upd);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato426.Mensaje;

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
            List<ProductoCreditoModel> productoCredito = DatosCreditos.Tipos();//Lista de los 14 tipos de credito
            List<DominioModel> idAperturaDigital = DatosDominio.Obtener(2);

            if (productoCredito.Count() == 0)
            {
                ModelState.AddModelError("idProducto", "No se encuentra valores para la lista de tipo de codigo credito");
            }
            ViewBag.TiposCredito = new SelectList(productoCredito, "idCodigo", "Descripcion");

            if (idAperturaDigital.Count() == 0)
            {
                ModelState.AddModelError("idAperturaDigital", "No se encuentra valores para la lista de apertura digital");
            }
            ViewBag.AperturaDigital = new SelectList(idAperturaDigital, "Dominio", "Descripcion");
            ViewBag.CodigoCredito = new SelectList(new List<CreditosModel>(), "idCodigo", "Descripcion");
        }

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        /// 
        private void LlenadoListasDetalle()
        {
            List<DominioModel> idCaracteristicaCredito = DatosDominio.Obtener(15);
            List<Aseguradoras> idTipoAseguradora = DatosAseguradoras.Tipos();
            List<DominioModel> idObservaciones = DatosDominio.Obtener(14);


            if (idCaracteristicaCredito.Count() == 0)
            {
                ModelState.AddModelError("idCaracteristicaCredito", "No se encuentra valores para la lista de tipo de caracteristica credito");
            }
            ViewBag.CaracteristicaCredito = new SelectList(idCaracteristicaCredito, "Dominio", "Descripcion");

            if (idTipoAseguradora.Count() == 0)
            {
                ModelState.AddModelError("idTipoAseguradora", "No se encuentra valores para la lista de tipo aseguradora");
            }
            ViewBag.TipoAseguradora = new SelectList(idTipoAseguradora, "Tipo", "Descripcion");

            if (idObservaciones.Count() == 0)
            {
                ModelState.AddModelError("idObservaciones", "No se encuentra valores para la lista de observaciones");
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

        [HttpGet]
        public JsonResult LlenadoCreditos(int? tipo)
        {
            List<ProductoCreditoModel> idCodigoCredito = DatosCreditos.Lista(tipo);

            if (idCodigoCredito.Count() == 0)
            {
                ModelState.AddModelError("idCodigoCredito", "No se encuentra valores para la lista de codigo credito");
            }
            ViewBag.CodigoCredito = new SelectList(idCodigoCredito, "idCodigo", "Descripcion");
            return Json(new SelectList(idCodigoCredito, "idCodigo", "Descripcion"), JsonRequestBehavior.AllowGet);
        }
    }

}