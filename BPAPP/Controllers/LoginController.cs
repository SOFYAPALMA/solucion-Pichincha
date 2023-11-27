using CapaDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace ProyectoWeb.Controllers
{
    [Authorize]
    public class LoginController : Controller
    {
        // GET: Login       
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(string usuario, string contrasenia) {

            int idUsuario = CD_Usuario.LoginUsuario(usuario, contrasenia);

            if (idUsuario == 0) {
                FormsAuthentication.SetAuthCookie(usuario, false);
                ViewBag.Error = "Usuario o contraseña no correcta";
                return View();
            }

            Session["IdUsuario"] = idUsuario;
          
            return RedirectToAction("Index", "Home");
        }

    }
}