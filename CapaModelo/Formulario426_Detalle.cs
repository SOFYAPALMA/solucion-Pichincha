using System;

namespace CapaModelo
{
    public class Formulario426_Detalle
    {
        public int idDetalle { get; set; }
        public int idPropiedadesFormato { get; set; }
        public string Subcuenta { get; set; }
        public string CaracteristicaCredito { get; set; }
        public int idCaracteristicaCredito { get; set; }
        public int? Costo { get; set; }
        public decimal? Tasa { get; set; }
        public string TipoAseguradora { get; set; }
        public int? idTipoAseguradora { get; set; }
        public string CodigoAseguradora { get; set; }
        public int? idCodigoAseguradora { get; set; }
        public string Observaciones { get; set; }
        public int? idObservaciones { get; set; }
        public int? UnidadCaptura { get; set; } = 1;
        public string Estado { get; set; }
        public string DescripcionEstado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }
        public string CodigoRegistro { get; set; }
        public int? idDetalleAnterior { get; set; }
    }

}
