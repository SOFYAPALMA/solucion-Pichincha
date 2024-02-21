using CapaDatos;
using Comun.DA;
using Comun.DA1;
using System.Configuration;
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
                //User.Identity
                return View();
            }

            Session["IdUsuario"] = idUsuario;
          
            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        public ActionResult Index1(string usuario, string contrasenia) {

            ADSettings DAConfig = new ADSettings()
            {
                Server = ConfigurationManager.AppSettings["ActiveDirectory:Server"] ?? "",
                AllowADAuth = bool.Parse(ConfigurationManager.AppSettings["ActiveDirectory:AllowADAuth"] ?? "false"),
                Domain = ConfigurationManager.AppSettings["ActiveDirectory:Domain"] ?? ""
            };

            ADManagment aD = new ADManagment(DAConfig);

            bool ret = aD.IsValidUser(usuario, contrasenia);

            if (!ret)
            {
                FormsAuthentication.SetAuthCookie(usuario, false);
                ViewBag.Error = "Usuario o contraseña no correcta";
                //User.Identity
                return View();
            }

            return RedirectToAction("Index", "Home");
        }


        [HttpPost]
        public ActionResult Index2(string usuario, string contrasenia)
        {

            ADSettings DAConfig = new ADSettings()
            {
                Server = ConfigurationManager.AppSettings["ActiveDirectory:Server"] ?? "",
                AllowADAuth = bool.Parse(ConfigurationManager.AppSettings["ActiveDirectory:AllowADAuth"] ?? "false"),
                Domain = ConfigurationManager.AppSettings["ActiveDirectory:Domain"] ?? "",
                Path = ConfigurationManager.AppSettings["ActiveDirectory:Path"] ?? ""
            };

            ActiveDirectory aD = new ActiveDirectory(DAConfig);

            bool ret = aD.ValidacionUsuario(usuario, contrasenia);

            if (!ret)
            {
                FormsAuthentication.SetAuthCookie(usuario, false);
                ViewBag.Error = "Usuario o contraseña no correcta";
                //User.Identity
                return View();
            }

            return RedirectToAction("Index", "Home");
        }
    }
}