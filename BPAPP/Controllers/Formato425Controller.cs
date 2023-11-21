using BP.Repositorio;
using CapaDatos;
using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
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

            List<Dominio> tipodeProductoDeposito = CD_Dominios.Obtener(1);
            List<Dominio> idAperturaDigital = CD_Dominios.Obtener(2);
            List<Dominio> idFranquicia = CD_Dominios.Obtener(7);
            List<Dominio> observacionesCuotadeManejo = CD_Dominios.Obtener(5);
            List<Dominio> grupoPoblacional = CD_Dominios.Obtener(3);
            List<Dominio> idCupo = CD_Dominios.Obtener(8);
            List<Dominio> idServicioGratuito = CD_Dominios.Obtener(9);

            if (tipodeProductoDeposito.Count() == 0)
            {
                ModelState.AddModelError("Tipo Producto Tarjeta credito", "No se encuentra valores para la lista de tipo de producto tarjeta de credito");
            }
            ViewBag.TipodeProductoDeposito = new SelectList(tipodeProductoDeposito, "IdDominio", "Nombre");

            if (idAperturaDigital.Count() == 0)
            {
                ModelState.AddModelError("Apertura digital", "No se encuentra valores para la lista de Apertura digital");
            }
            ViewBag.idAperturaDigital = new SelectList(idAperturaDigital, "IdDominio", "Nombre");

            if (idFranquicia.Count() == 0)
            {
                ModelState.AddModelError("idFranquicia", "No se encuentra valores para la lista de Franquicia");
            }
            ViewBag.idFranquicia = new SelectList(idFranquicia, "IdDominio", "Nombre");

            if (observacionesCuotadeManejo.Count() == 0)
            {
                ModelState.AddModelError("ObservacionesCuotadeManejo", "No se encuentra valores para la lista de Observaciones Cuota de Manejo");
            }
            ViewBag.ObservacionesCuotadeManejo = new SelectList(observacionesCuotadeManejo, "IdDominio", "Nombre");

            if (grupoPoblacional.Count() == 0)
            {
                ModelState.AddModelError("GrupoPoblacional", "No se encuentra valores para la lista de Grupo Poblacional");
            }
            ViewBag.GrupoPoblacional = new SelectList(grupoPoblacional, "IdDominio", "Nombre");

            if (idCupo.Count() == 0)
            {
                ModelState.AddModelError("idCupo", "No se encuentra valores para la lista de Cupo");
            }
            ViewBag.Cupo = new SelectList(idCupo, "IdDominio", "Nombre");


            if (idServicioGratuito.Count() == 0)
            {
                ModelState.AddModelError("idServicioGratuito", "No se encuentra valores para la lista de Servicio Gratuito");
            }
            ViewBag.ServicioGratuito = new SelectList(idServicioGratuito, "IdDominio", "Nombre");

        }

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        private void LlenadoListasDetalle()
        {
            List<Dominio> idOperacionServicio = CD_Dominios.Obtener(10);
            List<Dominio> idCanal = CD_Dominios.Obtener(20);
            List<Dominio> idTipoAseguradora = CD_Dominios.Obtener(17);
            List<Dominio> idCodigoAseguradora = CD_Dominios.Obtener(17);
            List<Dominio> idObservaciones = CD_Dominios.Obtener(13);

            if (idOperacionServicio.Count() == 0)
            {
                ModelState.AddModelError("Descripcion Operacion Servicio", "No se encuentra valores para la lista de tipo de Descripcion operacion servicio");
            }
            ViewBag.DescripcionOperacionServicio = new SelectList(idOperacionServicio, "IdDominio", "Nombre");if (idCanal.Count() == 0)
            {
                ModelState.AddModelError("Canal", "No se encuentra valores para la lista de tipo de Canal");
            }
            ViewBag.Canal = new SelectList(idCanal, "Canal", "Descripcion");

            if (idTipoAseguradora.Count() == 0)
            {
                ModelState.AddModelError("idTipoAseguradora", "No se encuentra valores para la lista de Tipo aseguradora");
            }
            ViewBag.idTipoAseguradora = new SelectList(idTipoAseguradora, "IdDominio", "Nombre");

            if (idCodigoAseguradora.Count() == 0)
            {
                ModelState.AddModelError("idCodigoAseguradora", "No se encuentra valores para la lista de Codigo Aseguradora");
            }
            ViewBag.idCodigoAseguradora = new SelectList(idCodigoAseguradora, "IdDominio", "Nombre");

            if (idObservaciones.Count() == 0)
            {
                ModelState.AddModelError("ID Observaciones", "No se encuentra valores para la lista de ID Observaciones");
            }
            ViewBag.IDObservaciones = new SelectList(idObservaciones, "IdDominio", "Nombre");

        }

    }
}