using System.Web.Mvc;

namespace ProyectoWeb.Controllers
{
    [Authorize]
    public class consumoWSController : Controller
    {
        public ActionResult Consumo()
        {
            return View();

        }

        [HttpPost]
        public ActionResult Consumo(string WS = null)
        {
            ServiceReferenceTarifas.SincronizarTarifasSFCClient sFCClient = new ServiceReferenceTarifas.SincronizarTarifasSFCClient();
            ServiceReferenceTarifas.RequestHeaderOut requestHeader = new ServiceReferenceTarifas.RequestHeaderOut();


            requestHeader.systemId = "Tarifas";
            requestHeader.messageId = "${=java.util.UUID.randomUUID()}";//insertar un # aleatorio, random o nuevo ID para identificar la transaccion
            requestHeader.invokerDateTime = System.DateTime.Parse(System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));

            ServiceReferenceTarifas.SecurityCredential security = new ServiceReferenceTarifas.SecurityCredential();
            security.userName = "Tarifas_${=org.apache.commons.lang.RandomStringUtils.randomNumeric(3)}";
            security.userToken = "anyType";
            requestHeader.securityCredential = security;

            //ServiceReferenceTarifas.ResponseStatus responseStat = new ServiceReferenceTarifas.ResponseStatus();
            //responseStat.statusCode = "SUCCESS";
            //requestHeader.responseStatus = responseStat;

            ServiceReferenceTarifas.Destination destinationn = new ServiceReferenceTarifas.Destination();
            destinationn.name = "Tarifas";
            destinationn.@namespace = @"http://www.pichincha.com.co/tarifas";
            destinationn.operation = "SincronizarTarifasSFC";
            requestHeader.destination = destinationn;

            requestHeader.classification = new string[] { "http://www.corp.gov/hoc/rapidum" };


            ServiceReferenceTarifas.InformacionCanal canal = new ServiceReferenceTarifas.InformacionCanal();
            canal.canal = "00003";
            canal.segmento = "00";

            ServiceReferenceTarifas.Tarifa tarifa = new ServiceReferenceTarifas.Tarifa();
            // tarifa.codigoProducto = "TCC1";
            tarifa.tipoEntidad = "1";
            tarifa.entidadCod = "57";
            tarifa.fechaReporte = "2023-11-22 22:13:06.95";
            tarifa.aperturaDigital = "2";
            tarifa.tasa = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}.00";
            tarifa.tipoEntidadAseguradora = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.entidadCodAseguradora = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.observaciones = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.nombreComercial = "nombre comercial de pruebas QA";
            tarifa.numClientesUnicos = "3${=org.apache.commons.lang.RandomStringUtils.randomNumeric(3)}";
            tarifa.cuotaManejo = "0";
            tarifa.grupoPoblacional = "1";
            tarifa.obsCuotaManejo = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.operacionServicio = "claustra fremunt";
            tarifa.canal = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.costoFijo = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}.00";
            tarifa.costoPropOperServ = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.codigoCredito = "1";
            tarifa.caracteristicaCredito = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.costo = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.franquicia = "1";
            tarifa.cuotaManejoMaxima = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.cupo = "1";
            tarifa.servicioGratuito1 = "11";
            tarifa.servicioGratuito2 = "12";
            tarifa.servicioGratuito3 = "13";
            tarifa.costoFijoMaximo = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}.00";
            tarifa.cupo = "1";
            tarifa.costoPropMaxOperServ = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}.00";
            tarifa.tasaMaxima = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}.00";
            tarifa.tipoProducto = "3";
            tarifa.ingresos = "1";
            tarifa.cuentaAhorros1 = "1";
            tarifa.cuentaAhorros2 = "2";
            tarifa.cuentaAhorros3 = "3";
            tarifa.tarjetaDebito1 = "8";
            tarifa.tarjetaDebito2 = "9";
            tarifa.tarjetaDebito3 = "10";
            tarifa.numOperServCuotaManejo = "${=org.apache.commons.lang.RandomStringUtils.randomNumeric(1)}";
            tarifa.codigoRegistroCabSFC = "mollitque animos";
            tarifa.codigoRegistroUcSFC = "montis insuper altos";

            ServiceReferenceTarifas.Respuesta respuesta = new ServiceReferenceTarifas.Respuesta();

            ServiceReferenceTarifas.ResponseHeaderOut headerOut = sFCClient.sincronizarTarifasSFC(requestHeader, canal, "TCC1", ref tarifa, out respuesta);
            return View();
        }
    }
}


