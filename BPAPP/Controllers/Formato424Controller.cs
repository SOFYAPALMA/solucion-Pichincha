﻿using BP.Repositorio;
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
                    TempData["Notificacion"] = CD_Formato424.Mensaje;

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

        public ActionResult Update(int id)
        {
            Formulario424_EncabezadoConsulta encabezado = DatosFormato424.Detalles(id);
            Form424ConsultaEncabezado form424 = Mapper.getMapper(encabezado);
            LlenadoListasEncabezado();
            return View(form424);
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
                    TempData["Notificacion"] = CD_Formato424.Mensaje;

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
            Formulario424_EncabezadoConsulta encabezado = DatosFormato424.Detalles(id);
            Form424ConsultaEncabezado form424 = Mapper.getMapper(encabezado);
            LlenadoListasEncabezado();
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
        private void LlenadoListasEncabezado()
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

        /// <summary>
        /// Llena las listas que requiere el controlador
        /// </summary>
        private void LlenadoListasDetalle()
        {

        }

    }
}