﻿using BP.Repositorio;
using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    [Authorize]
    public class DominioController : Controller
    {
        public ActionResult Crear()
        {
            CrearTipoDominioDTO dominio = new CrearTipoDominioDTO();
            //LlenadoListasDominio();
            return View(dominio);
        }

        public ActionResult CrearDetalle(int id)
        {
            DominioModel dominio = new DominioModel();
            dominio.idDominio = id;
            //LlenadoListasDetalle();

            return View(dominio);
        }

        [HttpPost]
        public ActionResult Crear(CrearTipoDominioDTO dominio)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                int idusuario = int.Parse(Session["IdUsuario"].ToString());

                TipoDominioModel encabezado = Mapper.getMapper(dominio);
                bool respuesta = DatosDominio.RegistrarEncabezado(encabezado);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosDominio.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el encabezado, por favor valide los datos.");
                    // LlenadoListasEncabezado();
                    return View(dominio);
                }

            }
            else
            {
                //LlenadoListasEncabezado();
                return View(dominio);
            }
        }

        [HttpPost]
        public ActionResult CrearDetalle(CrearDominioDTO dominio)
        {
            if (ModelState.IsValid)
            {
                DominioModel encabezado = Mapper.getMapper(dominio);

                bool respuesta = DatosDominio.RegistrarDetalle(encabezado);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosDominio.Mensaje;

                    return RedirectToAction("Details/" + dominio.idDominio);
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo crear el detalle, por favor valide los datos.");
                    //LlenadoListasDetalle();
                    return View(dominio);
                }
            }
            else
            {
                // LlenadoListasDetalle();
                return View(dominio);
            }
        }

        public ActionResult Update(int id)
        {
            TipoDominioModel encabezado = DatosDominio.DetalleEncabezado(id);
            ConsultaTipoDominioDTO dominio = Mapper.getMapper(encabezado);
            //LlenadoListasEncabezado();
            return View(dominio);
        }

        public ActionResult UpdateDetalle(int id)
        {
            DominioModel detalle = DatosDominio.DetalleDominio(id);
            CrearDominioDTO dominio = Mapper.getMapper(detalle);
            //LlenadoListasDetalle();
            return View(dominio);
        }

        [HttpPost]
        public ActionResult UpdateDetalle(CrearDominioDTO detalle)
        {
            if (ModelState.IsValid)
            {
                if (Session["IdUsuario"] == null)
                    return RedirectToAction("Login");

                int idusuario = int.Parse(Session["IdUsuario"].ToString());

                DominioModel upd = Mapper.getMapper(detalle);
                bool respuesta = DatosDominio.ActualizarDetalle(upd);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosDominio.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo actualizar el detalle, por favor valide los datos.");
                    //LlenadoListasDetalle();
                    return View(detalle);
                }
            }
            else
            {
                //LlenadoListasDetalle();
                return View(detalle);
            }
        }

        [HttpPost]
        public ActionResult Update(CrearTipoDominioDTO encabezado)
        {
            if (ModelState.IsValid)
            {
                TipoDominioModel upd = Mapper.getMapper(encabezado);
                bool respuesta = DatosDominio.ActualizarEncabezado(upd);

                if (respuesta)
                {
                    TempData["Notificacion"] = DatosDominio.Mensaje;

                    return RedirectToAction("List");
                }
                else
                {
                    ModelState.AddModelError("", "No se pudo actualizar el encabezado, por favor valide los datos.");
                    //LlenadoListasEncabezado();
                    return View(encabezado);
                }
            }
            else
            {
                //LlenadoListasEncabezado();
                return View(encabezado);
            }
        }

        public ActionResult Details(int id)
        {
            TipoDominioModel encabezado = DatosDominio.DetalleTipoDominio(id);
            ConsultaTipoDominioDTO td = Mapper.getMapper(encabezado);

            List<DominioModel> encabezados = DatosDominio.ListaDominios(id);
            List<ConsultaDominioDTO> Detalles = Mapper.getMapper(encabezados);

            ViewBag.ListaDetalles = Detalles;
            //LlenadoListasEncabezado();
            return View(td);
        }

        public ActionResult List()
        {
            List<TipoDominioModel> encabezados = DatosDominio.ListaTiposDominios();
            List<ConsultaTipoDominioDTO> enc = Mapper.getMapper(encabezados);

            return View(enc);
        }

        public ActionResult ListDetalles(int id)
        {
            List<DominioModel> encabezados = DatosDominio.ListaDominios(id);
            List<ConsultaDominioDTO> det = Mapper.getMapper(encabezados);

            return View(det);
        }
    }
}
