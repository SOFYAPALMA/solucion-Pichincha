namespace ProyectoWeb.Models
{
    public class Form425CrearDetalle
    {
        public int idDetalle { get; set; }
        public int idPropiedadesFormato { get; set; }
        public int Subcuenta { get; set; }
        public int idOperacionoServicio { get; set; }
        public int Canal { get; set; }
        public int CostoFijo { get; set; }
        public int CostoFijoMaximo { get; set; }
        public int CostoProporcionOperacionServicio { get; set; }
        public int CostoProporcionMaxOperacionServicio { get; set; }
        public int Tasa { get; set; }
        public int TasaMaxima { get; set; }
        public int idTipoAseguradora { get; set; }
        public int idCodigoAseguradora { get; set; }
        public int idObservaciones { get; set; }
        public int UnidadCaptura { get; set; }
        public int Estado { get; set; }
        public int FechaProceso { get; set; }
        public int FechaEstado { get; set; }
    }
}