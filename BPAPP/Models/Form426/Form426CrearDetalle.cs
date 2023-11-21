﻿using System;

namespace ProyectoWeb.Models
{
    public class Form426CrearDetalle
    {
        public int idDetalle { get; set; }
        public int idPropiedadesFormato { get; set; }
        public int Subcuenta { get; set; }
        public int idCaracteristicaCredito { get; set; }
        public int Costo { get; set; }
        public int Tasa { get; set; }
        public int idTipoAseguradora { get; set; }
        public int idCodigoAseguradora { get; set; }
        public int idObservaciones { get; set; }
        public int UnidadCaptura { get; set; }
        public int Estado { get; set; }
        public DateTime FechaProceso { get; set; }
        public DateTime FechaEstado { get; set; }
        public int CodigoRegistro { get; set; }
        public int idDetalleAnterior { get; set; }
    }
}