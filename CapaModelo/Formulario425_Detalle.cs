using System;

namespace CapaModelo
{
    public class Formulario425_Detalle
    {
        public string Detalle { get; set; }
        public int idDetalle { get; set; }
        public string PropiedadesFormato { get; set; }
        public int idPropiedadesFormato { get; set; }
        public int Subcuenta { get; set; }
        public string OperacionoServicio { get; set; }
        public int idOperacionoServicio { get; set; }
        public string Canal { get; set; }
        public int idCanal { get; set; }
        public decimal CostoFijo { get; set; }
        public decimal CostoFijoMaximo { get; set; }
        public decimal CostoProporcionOperacionServicio { get; set; }
        public decimal CostoProporcionMaxOperacionServicio { get; set; }
        public decimal Tasa { get; set; }
        public decimal TasaMaxima { get; set; }
        public string TipoAseguradora { get; set; }
        public int idTipoAseguradora { get; set; }
        public string CodigoAseguradora { get; set; }
        public int idCodigoAseguradora { get; set; }
        public string Observaciones { get; set; }
        public int idObservaciones { get; set; }
        public int UnidadCaptura { get; set; }
        public int Estado { get; set; }
        public string FechaProceso { get; set; }
        public string FechaEstado { get; set; }

    }
}
