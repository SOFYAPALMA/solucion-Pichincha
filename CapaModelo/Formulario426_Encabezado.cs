using System.ComponentModel.DataAnnotations;

namespace CapaModelo
{
    public class Formulario426_Encabezado
    {

        [Required(ErrorMessage = "El campo propiedades formato es obligatorio.")]
        [Display(Name = "Propiedades")]
        public int idPropiedadesFormato { get; set; }
        public int idDetalle { get; set; }
        public int Subcuenta { get; set; }
        public int idCaracteristicaCredito { get; set; }
        public int Costo { get; set; }
        public int Tasa { get; set; }
        public string idTipoAseguradora { get; set; }
        public string idCodigoAseguradora { get; set; }
        public string idObservaciones { get; set; }
        public int UnidadCaptura { get; set; } = 1;
        public string Tipo { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        [Required(ErrorMessage = "El campo  tipo producto crédito es obligatorio.")]
        [Display(Name = "Producto Crédito")]
        public int TipoProductoCredito { get; set; }

        [Required(ErrorMessage = "El campo código crédito es obligatorio.")]
        [Display(Name = "Código Crédito")]
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
