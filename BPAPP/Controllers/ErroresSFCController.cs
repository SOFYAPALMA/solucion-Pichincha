using BP.Repositorio;
using CapaModelo;
using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    [Authorize]
    public class ErroresSFCController : Controller
    {
        // GET: ErroresSFC
        public ActionResult Index(string TReg, int idPropForm, int idRegDet, int form)
        {
            Errores_SFCModel _SFCModels = DatosErroresSFC.DetalleErroresSFC(TReg, idPropForm, idRegDet, form);
            Errores_SFCDTO errores = Mapper.getMapper(_SFCModels);

            return View(errores);
        }
    }
}