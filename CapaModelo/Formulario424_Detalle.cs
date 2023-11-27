namespace CapaModelo
{
    public class Formulario424_Detalle
    {
        public int? CodigoRegistro { get; set; }
        public decimal CostoFijo { get; set; }
        public decimal CostoProporcionOperacionServicio { get; set; }
        public int Estado { get; set; }
        public string FechaEstado { get; set; }
        public string FechaProceso { get; set; }
        public int idCanal { get; set; }
        public string Canal { get; set; }
        public int idDetalle { get; set; }
        public int? idDetalleAnterior { get; set; }
        public int idObservaciones { get; set; }
        public int idOperacionServicio { get; set; }
        public int idPropiedadesFormato { get; set; }
        public string Observaciones { get; set; }
        public string OperacionServicio { get; set; }
        public string PropiedadesFormato { get; set; }
        public int NumOperServiciosCuotamanejo { get; set; }
        public string subCuenta { get; set; }
        public int UnidadCaptura { get; set; } = 1;
    }
}
