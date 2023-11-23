using BP.Repositorio;
using CapaDatos;
using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    public class Formato424Controller : Controller
    {

        public ActionResult Crear()
        {
            Form424CrearEncabezado form424 = new Form424CrearEncabezado();
            LlenadoListasEncabezado();
            return View(form424);
        }

        public ActionResult CrearDetalle(int id)
        {
            Form424CrearDetalle form424 = new Form424CrearDetalle();
            form424.idPropiedadesFormato = id;
            LlenadoListasDetalle();

            return View(form424);
        }

        [HttpPost]
        public ActionResult Crear(Form424CrearEncabezado form424)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                int idusuario = int.Parse(Session["IdUsuario"].ToString());

                Formulario424_EncabezadoCrear encabezado = Mapper.getMapper(form424);
                encabezado.Usuario = idusuario;
                bool respuesta = DatosFormato424.RegistrarEncabezado(encabezado);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato424.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el encabezado, por favor valide los datos.");
                    LlenadoListasEncabezado();
                    return View(form424);
                }
            }
            else
            {
                LlenadoListasEncabezado();
                return View(form424);
            }
        }

        [HttpPost]
        public ActionResult CrearDetalle(Form424CrearDetalle form424)
        {
            if (ModelState.IsValid)
            {
                Formulario424_Detalle encabezado = Mapper.getMapper(form424);

                bool respuesta = DatosFormato424.RegistrarDetalle(encabezado);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato424.Mensaje;

                    return RedirectToAction("Details/" + form424.idPropiedadesFormato);
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el detalle, por favor valide los datos.");
                    LlenadoListasDetalle();
                    return View(form424);
                }
            }
            else
            {
                LlenadoListasDetalle();
                return View(form424);
            }
        }

        public ActionResult Update(int id)
        {
            Formulario424_EncabezadoConsulta encabezado = DatosFormato424.DetalleEncabezado(id);
            Form424ConsultaEncabezado form424 = Mapper.getMapper(encabezado);
            LlenadoListasEncabezado();
            return View(form424);
        }

        public ActionResult UpdateDetalle(int id)
        {
            Formulario424_DetalleConsulta detalle = DatosFormato424.DetallesDetalles(id);
            Form424ConsultaDetalle form424 = Mapper.getMapper(detalle);
            LlenadoListasDetalle();
            return View(form424);
        }

        [HttpPost]
        public ActionResult UpdateDetalle(Form424ConsultaDetalle detalle)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                int idusuario = int.Parse(Session["IdUsuario"].ToString());

                Formulario424_Detalle upd = Mapper.getMapper(detalle);
                bool respuesta = DatosFormato424.ActualizarDetalle(upd);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato424.Mensaje;

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
        public ActionResult Update(Form424ConsultaEncabezado encabezado)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                int idusuario = int.Parse(Session["IdUsuario"].ToString());

                Formulario424_EncabezadoActualizar upd = Mapper.getMapper(encabezado);
                upd.Usuario = idusuario;
                bool respuesta = DatosFormato424.ActualizarEncabezado(upd);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosFormato424.Mensaje;

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
            Formulario424_EncabezadoConsulta encabezado = DatosFormato424.DetalleEncabezado(id);
            Form424ConsultaEncabezado form424 = Mapper.getMapper(encabezado);

            List<Formulario424_DetalleConsulta> encabezados = DatosFormato424.ListaDetalles(id);
            List<Form424ConsultaDetalle> form424Detalles = Mapper.getMapper(encabezados);

            ViewBag.ListaDetalles = form424Detalles;
            LlenadoListasEncabezado();
            return View(form424);
        }

        public ActionResult List()
        {
            List<Formulario424_EncabezadoConsulta> encabezados = DatosFormato424.Lista();
            List<Form424ConsultaEncabezado> form424 = Mapper.getMapper(encabezados);

            return View(form424);
        }

        public ActionResult ListDetalles(int id)
        {
            List<Formulario424_DetalleConsulta> encabezados = DatosFormato424.ListaDetalles(id);
            List<Form424ConsultaDetalle> form424 = Mapper.getMapper(encabezados);

            return View(form424);
        }

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        private void LlenadoListasEncabezado()
        {
            List<Dominio> tipodeProductoDeposito = DatosDominio.Obtener(1);
            List<Dominio> aperturaDeposito = DatosDominio.Obtener(2);
            List<Dominio> grupoPoblacional = DatosDominio.Obtener(3);
            List<Dominio> ingresos = DatosDominio.Obtener(4);
            List<Dominio> observacionesCuotadeManejo = DatosDominio.Obtener(5);
            List<Dominio> servicioGratuitoCuentadeAhorros = DatosDominio.Obtener(6);
            List<Dominio> NombreComercial = DatosDominio.Obtener(21);

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


            if (servicioGratuitoCuentadeAhorros.Count() == 0)
            {
                ModelState.AddModelError("ServicioGratuitoTarjetaDebito1", "No se encuentra valores para la lista de Servicio Gratuito Tarjeta Debito");
            }
            ViewBag.ServicioGratuitoTarjetaDebito = new SelectList(servicioGratuitoCuentadeAhorros, "IdDominio", "Nombre");

            if (NombreComercial.Count() == 0)
            {
                ModelState.AddModelError("idNombreComercial", "No se encuentra valores para la lista de nombres comeraciales");
            }
            ViewBag.NombreComercial = new SelectList(NombreComercial, "IdDominio", "Nombre");
        }

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        private void LlenadoListasDetalle()
        {
            List<Dominio> idOperacionServicio = DatosDominio.Obtener(10);
            List<Dominio> idCanal = DatosDominio.Obtener(20);
            List<Dominio> CostoProporcionOperacionServicio = DatosDominio.Obtener(10);
            List<Dominio> idObservaciones = DatosDominio.Obtener(11);

            if (idOperacionServicio.Count() == 0)
            {
                ModelState.AddModelError("idOperacionServicio", "No se encuentra valores para la lista de tipo de Descripcion operacion servicio");
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
                ModelState.AddModelError("idObservaciones", "No se encuentra valores para la lista de Observaciones");
            }
            ViewBag.IDObservaciones = new SelectList(idObservaciones, "IdDominio", "Nombre");

        }

    }
}