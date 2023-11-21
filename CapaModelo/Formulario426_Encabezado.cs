using System.ComponentModel.DataAnnotations;

namespace CapaModelo
{
    public class Formulario426_Encabezado
    {

        [Required(ErrorMessage = "El campo ID Propiedades Formato es obligatorio.")]
        [Display(Name = "ID Propiedades")]
        public int idPropiedadesFormato { get; set; }
        public int idDetalle { get; set; }
        public int Subcuenta { get; set; }
        public int idCaracteristicaCredito { get; set; }
        public int Costo { get; set; }
        public int Tasa { get; set; }
        public string idTipoAseguradora { get; set; }
        public string idCodigoAseguradora { get; set; }
        public string idObservaciones { get; set; }
        public int UnidadCaptura { get; set; }
        public int Tipo { get; set; }
        public int Codigo { get; set; }
        public string Nombre { get; set; }

        [Display(Name = "Codigo Credito")]
        public string CodigoCredito { get; set; }

        [Required(ErrorMessage = "El campo ID Codigo Credito es obligatorio.")]
        [Display(Name = "ID Codigo Credito")]
        public int idCodigoCredito { get; set; }
        public string AperturaDigital { get; set; }
        public int idAperturaDigital { get; set; }
        public string Fecha_horaActualizacion { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }
        public string Fechacorte { get; set; }
        public string FechaEstado { get; set; }
        public int? CodigoRegistro { get; set; }
        public int? idPropiedadesFormatoAnterior { get; set; }
    }
}
