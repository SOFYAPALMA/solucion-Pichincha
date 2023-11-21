﻿using System;

namespace ProyectoWeb.Models
{
    public class Form426ConsultaEncabezado
    {
        public int idPropiedadesFormato { get; set; }
        public int Tipo { get; set; }
        public int Codigo { get; set; }
        public string Nombre { get; set; }
        public string CodigoCredito { get; set; }
        public int idCodigoCredito { get; set; }
        public string AperturaDigital { get; set; }
        public int idAperturaDigital { get; set; }
        public DateTime Fecha_horaActualizacion { get; set; }
        public int Usuario { get; set; }
        public string Estado { get; set; }
        public DateTime Fechacorte { get; set; }
        public DateTime FechaEstado { get; set; }
        public int CodigoRegistro { get; set; }
        public int idPropiedadesFormatoAnterior { get; set; }
    }
}