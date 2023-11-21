using CapaDatos;
using CapaModelo;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace ProyectoWeb.Controllers
{
    public class Formato426Controller : Controller
    {
        // GET: Docente
        public ActionResult Crear()
        {
            return View();
        }
        public JsonResult Listar()
        {
            List<Formato426> oListaFormato426 = CD_Formato426.Listar();
            return Json(new { data = oListaFormato426 }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult Guardar(Formato426 oFormato426)
        {
            bool respuesta = false;            

                if (oFormato426.idPropiedadesFormato == 0)
                {
                    respuesta = CD_Formato426.Registrar(oFormato426);
                }
                else
                {
                    respuesta = CD_Formato426.Editar(oFormato426);
                }         
           

            return Json(new { resultado = respuesta }, JsonRequestBehavior.AllowGet);
        }  

        [HttpGet]
        public JsonResult ConsultaReporte(string nombres, string apellidos, string codigo, string documentoidentidad)
        {

            DataTable dt = new DataTable();

            dt = CD_Formato426.Reporte(nombres, apellidos, codigo, documentoidentidad);

            return Json(new { data = DataTableToJSONWithJavaScriptSerializer(dt) }, JsonRequestBehavior.AllowGet);

        }

        public string DataTableToJSONWithJavaScriptSerializer(DataTable table)
        {
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
            Dictionary<string, object> childRow;
            foreach (DataRow row in table.Rows)
            {
                childRow = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    childRow.Add(col.ColumnName, row[col]);
                }
                parentRow.Add(childRow);
            }
            return jsSerializer.Serialize(parentRow);
        }


    }
}