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
        public int Canal { get; set; }
        public int CostoFijo { get; set; }
        public int CostoFijoMaximo { get; set; }
        public int CostoProporcionOperacionServicio { get; set; }
        public int CostoProporcionMaxOperacionServicio { get; set; }
        public int Tasa { get; set; }
        public int TasaMaxima { get; set; }
        public string TipoAseguradora { get; set; }
        public int idTipoAseguradora { get; set; }
        public string CodigoAseguradora { get; set; }
        public int idCodigoAseguradora { get; set; }
        public string Observaciones { get; set; }
        public int idObservaciones { get; set; }
        public int UnidadCaptura { get; set; }
        public int Estado { get; set; }
        public DateTime FechaProceso { get; set; }
        public DateTime FechaEstado { get; set; }

    }
}
