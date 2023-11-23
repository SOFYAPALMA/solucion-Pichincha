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
            List<DominioModel> idCodigoCredito = DatosDominio.Obtener(1);
            List<DominioModel> idAperturaDigital = DatosDominio.Obtener(2);


            if (idCodigoCredito.Count() == 0)
            {
                ModelState.AddModelError("idCodigoCredito", "No se encuentra valores para la lista de tipo de producto credito");
            }
            ViewBag.idCodigoCredito = new SelectList(idCodigoCredito, "Dominio", "Descripcion");

            if (idAperturaDigital.Count() == 0)
            {
                ModelState.AddModelError("idAperturaDigital", "No se encuentra valores para la lista de Apertura Deposito");
            }
            ViewBag.idAperturaDigital = new SelectList(idAperturaDigital, "Dominio", "Descripcion");
        }

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        /// 
        private void LlenadoListasDetalle()
        {
            List<DominioModel> idCaracteristicaCredito = DatosDominio.Obtener(1);
            List<DominioModel> idTipoAseguradora = DatosDominio.Obtener(17);
            List<DominioModel> idCodigoAseguradora = DatosDominio.Obtener(17);
            List<DominioModel> idObservaciones = DatosDominio.Obtener(14);


            if (idCaracteristicaCredito.Count() == 0)
            {
                ModelState.AddModelError("idCaracteristicaCredito", "No se encuentra valores para la lista de tipo de Caracteristica Credito");
            }
            ViewBag.idCaracteristicaCredito = new SelectList(idCaracteristicaCredito, "Dominio", "Descripcion");

            if (idTipoAseguradora.Count() == 0)
            {
                ModelState.AddModelError("idTipoAseguradora", "No se encuentra valores para la lista de tipo de Tipo Aseguradora");
            }
            ViewBag.idTipoAseguradora = new SelectList(idTipoAseguradora, "Dominio", "Descripcion");

            if (idCodigoAseguradora.Count() == 0)
            {
                ModelState.AddModelError("idCodigoAseguradora", "No se encuentra valores para la lista de Codigo Aseguradora");
            }
            ViewBag.idCodigoAseguradora = new SelectList(idCodigoAseguradora, "Dominio", "Descripcion");

            if (idObservaciones.Count() == 0)
            {
                ModelState.AddModelError("idObservaciones", "No se encuentra valores para la lista de ID Observaciones");
            }
            ViewBag.idObservaciones = new SelectList(idObservaciones, "Dominio", "Descripcion");

        }
    }

}