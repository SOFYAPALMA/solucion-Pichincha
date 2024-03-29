﻿using System.ComponentModel.DataAnnotations;

namespace ProyectoWeb.Models
{
    public class Form424CrearEncabezado
    {
        /// <summary>
        /// Referencia a al tipo entidad
        /// </summary>
        [Display(Name = "Tipo")]
        public string Tipo { get; } = "001"; //Campo fijo por default= 001

        [Display(Name = "Codigo")]
        public string Codigo { get; } = "00057"; //Campo fijo por default= 00057

        /// <summary>
        /// Captura de informacion para almacenamiento y visualizacion en el detalle
        /// </summary>
        [Display(Name = "Nombre Entidad")]
        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Nombre { get; } = "BCOPICHINCH"; //Campo fijo por default= BCOPICHINCH

        [Required(ErrorMessage = "El campo Nombre Comercial es obligatorio.")]
        [Display(Name = "Nombre Comercial")]
        public int idNombreComercial { get; set; }

        [Required(ErrorMessage = "El campo tipo de producto depósito es obligatorio.")]
        [Display(Name = "Tipo de Producto Deposito")]
        public int idTipoProductoDeposito { get; set; }

        [Required(ErrorMessage = "El campo Número de clientes únicos es obligatorio.")]
        [Display(Name = "Número de clientes únicos")]
        public int NumeroClientes { get; set; } //Campo numérico de registro manual, de acuerdo al cálculo de Clientes Únicos del MIS 

        [Display(Name = "Cuota de Manejo")]
        public int? CuotaManejo { get; set; } //Campo numérico de registro manual

        [Display(Name = "Observaciones Cuota de Manejo")]
        public int idObservacionesCuota { get; set; }

        [Required(ErrorMessage = "El campo grupo poblacional es obligatorio.")]
        [Display(Name = "Grupo Poblacional")]
        public int idGrupoPoblacional { get; set; }

        [Required(ErrorMessage = "El campo ingreso es obligatorio.")]
        [Display(Name = "Ingresos")]
        public int idIngresos { get; set; }

        [Required(ErrorMessage = "El campo servicio gratuito cuenta de Ahorros1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros1")]
        public int idSerGratuito_CtaAHO { get; set; }

        [Required(ErrorMessage = "El campo servicio gratuito cuenta de Ahorros2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros2")]
        public int idSerGratuito_CtaAHO2 { get; set; }

        [Required(ErrorMessage = "El campo servicio gratuito cuenta de Ahorros3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Cuenta de Ahorros3")]
        public int idSerGratuito_CtaAHO3 { get; set; }
        [Required(ErrorMessage = "El campo servicio gratuito tarjeta débito1 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito1")]
        public int idSerGratuito_TCRDebito { get; set; }

        [Required(ErrorMessage = "El campo servicio gratuito tarjeta débito2 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito2")]
        public int idSerGratuito_TCRDebito2 { get; set; }

        [Required(ErrorMessage = "El campo servicio gratuito tarjeta débito3 es obligatorio.")]
        [Display(Name = "Servicio Gratuito Tarjeta Debito3")]
        public int idSerGratuito_TCRDebito3 { get; set; }

        [Display(Name = "Apertura digital")]
        public int? idAperturaDigital { get; set; }
        public string CodigoRegistro { get; set; }
        public int? Usuario { get; set; }
    }
}