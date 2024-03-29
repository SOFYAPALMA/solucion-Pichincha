﻿using CapaModelo;
using ProyectoWeb.Models;
using System.Collections.Generic;
using System;

namespace ProyectoWeb
{
    public class Mapper
    {

        #region Formulario 424
        public static Formulario424_Encabezado getMapper(Form424CrearEncabezado dto)
        {
            var result = new Formulario424_Encabezado()
            {
                CodigoRegistro = dto.CodigoRegistro,
                CuotaManejo = dto.CuotaManejo,
                idAperturaDigital = dto.idAperturaDigital,
                idGrupoPoblacional = dto.idGrupoPoblacional,
                idIngresos = dto.idIngresos,
                idObservacionesCuota = dto.idObservacionesCuota,
                idSerGratuito_CtaAHO = dto.idSerGratuito_CtaAHO,
                idSerGratuito_CtaAHO2 = dto.idSerGratuito_CtaAHO2,
                idSerGratuito_CtaAHO3 = dto.idSerGratuito_CtaAHO3,
                idSerGratuito_TCRDebito = dto.idSerGratuito_TCRDebito,
                idSerGratuito_TCRDebito2 = dto.idSerGratuito_TCRDebito2,
                idSerGratuito_TCRDebito3 = dto.idSerGratuito_TCRDebito3,
                idTipoProductoDeposito = dto.idTipoProductoDeposito,
                Nombre = dto.Nombre,
                idNombreComercial = dto.idNombreComercial,
                NumeroClientes = dto.NumeroClientes,
                Tipo = dto.Tipo,
                Codigo = dto.Codigo,
                Usuario = dto.Usuario
            };
            return result;
        }

        public static List<Form424ConsultaEncabezado> getMapper(List<Formulario424_Encabezado> obj)
        {
            List<Form424ConsultaEncabezado> result = new List<Form424ConsultaEncabezado>();

            foreach (Formulario424_Encabezado consulta in obj)
            {
                Form424ConsultaEncabezado encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        public static Form424ConsultaEncabezado getMapper(Formulario424_Encabezado obj)
        {
            var result = new Form424ConsultaEncabezado()
            {
                AperturaDigital = obj.AperturaDigital,
                Codigo = obj.Codigo,
                CodigoRegistro = obj.CodigoRegistro,
                CuotaManejo = obj.CuotaManejo,
                Estado = obj.Estado,
                DescripcionEstado = obj.DescripcionEstado,
                Fecha_horaActualizacion = obj.Fecha_horaActualizacion,
                Fechacorte = obj.Fechacorte,
                FechaEstado = obj.FechaEstado,
                GrupoPoblacional = obj.GrupoPoblacional,
                idAperturaDigital = obj.idAperturaDigital,
                idGrupoPoblacional = obj.idGrupoPoblacional,
                idIngresos = obj.idIngresos,
                idObservacionesCuota = obj.idObservacionesCuota,
                idPropiedadesFormato = obj.idPropiedadesFormato,
                idPropiedadesFormatoAnterior = obj.idPropiedadesFormatoAnterior,
                idSerGratuito_CtaAHO = obj.idSerGratuito_CtaAHO,
                idSerGratuito_CtaAHO2 = obj.idSerGratuito_CtaAHO2,
                idSerGratuito_CtaAHO3 = obj.idSerGratuito_CtaAHO3,
                idSerGratuito_TCRDebito = obj.idSerGratuito_TCRDebito,
                idSerGratuito_TCRDebito2 = obj.idSerGratuito_TCRDebito2,
                idSerGratuito_TCRDebito3 = obj.idSerGratuito_TCRDebito3,
                idTipoProductoDeposito = obj.idTipoProductoDeposito,
                Ingresos = obj.Ingresos,
                Nombre = obj.Nombre,
                idNombreComercial = obj.idNombreComercial,
                NombreComercial = obj.NombreComercial,
                NumeroClientes = obj.NumeroClientes,
                ObservacionesCuota = obj.ObservacionesCuota,
                SerGratuito_CtaAH1 = obj.SerGratuito_CtaAH1,
                SerGratuito_CtaAH2 = obj.SerGratuito_CtaAH2,
                SerGratuito_CtaAH3 = obj.SerGratuito_CtaAH3,
                SerGratuito_TCRDebito1 = obj.SerGratuito_TCRDebito1,
                SerGratuito_TCRDebito2 = obj.SerGratuito_TCRDebito2,
                SerGratuito_TCRDebito3 = obj.SerGratuito_TCRDebito3,
                Tipo = obj.Tipo,
                TipoProductoDeposito = obj.TipoProductoDeposito,
                Usuario = obj.Usuario
            };
            return result;
        }

        public static Formulario424_Encabezado getMapper(Form424ConsultaEncabezado dto)
        {
            var result = new Formulario424_Encabezado()
            {
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Tipo = dto.Tipo,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                Usuario = dto.Usuario,
                idNombreComercial = dto.idNombreComercial,
                CodigoRegistro = dto.CodigoRegistro,
                CuotaManejo = dto.CuotaManejo,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                Fecha_horaActualizacion = dto.Fecha_horaActualizacion,
                Fechacorte = dto.Fechacorte,
                FechaEstado = dto.FechaEstado,
                idAperturaDigital = dto.idAperturaDigital ?? 0,
                idGrupoPoblacional = dto.idGrupoPoblacional,
                idIngresos = dto.idIngresos,
                idObservacionesCuota = dto.idObservacionesCuota,
                idPropiedadesFormatoAnterior = dto.idPropiedadesFormatoAnterior,
                idSerGratuito_CtaAHO = dto.idSerGratuito_CtaAHO,
                idSerGratuito_CtaAHO2 = dto.idSerGratuito_CtaAHO2,
                idSerGratuito_CtaAHO3 = dto.idSerGratuito_CtaAHO3,
                idSerGratuito_TCRDebito = dto.idSerGratuito_TCRDebito,
                idSerGratuito_TCRDebito2 = dto.idSerGratuito_TCRDebito2,
                idSerGratuito_TCRDebito3 = dto.idSerGratuito_TCRDebito3,
                idTipoProductoDeposito = dto.idTipoProductoDeposito,
                NumeroClientes = dto.NumeroClientes
            };

            return result;
        }

        public static List<Form424ConsultaDetalle> getMapper(List<Formulario424_Detalle> obj)
        {
            List<Form424ConsultaDetalle> result = new List<Form424ConsultaDetalle>();

            foreach (Formulario424_Detalle consulta in obj)
            {
                Form424ConsultaDetalle encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        public static Form424ConsultaDetalle getMapper(Formulario424_Detalle obj)
        {
            var result = new Form424ConsultaDetalle()
            {
                idDetalle = obj.idDetalle,
                idPropiedadesFormato = obj.idPropiedadesFormato,
                Subcuenta = obj.subCuenta,
                idCanal = obj.idCanal,
                Canal = obj.Canal,
                NumOperServiciosCuotamanejo = obj.NumOperServiciosCuotamanejo,
                CostoFijo = obj.CostoFijo,
                CostoProporcionOperacionServicio = obj.CostoProporcionOperacionServicio,
                idObservaciones = obj.idObservaciones,
                Observaciones = obj.Observaciones,
                UnidadCaptura = obj.UnidadCaptura,
                DescripcionEstado = obj.DescripcionEstado,
                CodigoRegistro = obj.CodigoRegistro,
                idOperacionServicio = obj.idOperacionServicio,
                OperacionServicio = obj.OperacionServicio,
                Estado = obj.Estado
            };
            return result;
        }

        public static Formulario424_Detalle getMapper(Form424CrearDetalle dto)
        {
            var result = new Formulario424_Detalle()
            {
                subCuenta = dto.Subcuentas,
                idCanal = dto.idCanal,
                idOperacionServicio = dto.idOperacionServicio,
                NumOperServiciosCuotamanejo = dto.NumOperServiciosCuotamanejo,
                CostoFijo = dto.CostoFijo,
                CostoProporcionOperacionServicio = dto.CostoProporcionOperacionServicio,
                idObservaciones = dto.idObservaciones,
                idPropiedadesFormato = dto.idPropiedadesFormato,
                UnidadCaptura = dto.UnidadCaptura
            };
            return result;
        }

        public static Formulario424_Detalle getMapper(Form424ConsultaDetalle dto)
        {
            var result = new Formulario424_Detalle()
            {
                idDetalle = dto.idDetalle,
                subCuenta = dto.Subcuenta,
                idCanal = dto.idCanal,
                idOperacionServicio = dto.idOperacionServicio,
                NumOperServiciosCuotamanejo = dto.NumOperServiciosCuotamanejo,
                CostoFijo = dto.CostoFijo,
                CostoProporcionOperacionServicio = dto.CostoProporcionOperacionServicio,
                idObservaciones = dto.idObservaciones,
                idPropiedadesFormato = dto.idPropiedadesFormato,
                UnidadCaptura = dto.UnidadCaptura
            };
            return result;
        }

        #endregion

        #region Formulario 425
        public static Formulario425_Encabezado getMapper(Form425CrearEncabezado dto)
        {
            var result = new Formulario425_Encabezado()
            {
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Tipo = dto.Tipo,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                idNombreComercial = dto.idNombreComercial,
                idAperturaDigital = dto.idAperturaDigital,
                NumeroClientes = dto.NumeroClientes,
                idFranquicia = dto.idFranquicia,
                CuotaManejo = dto.CuotaManejo,
                idObservacionesCuota = dto.idObservacionesCuota,
                CuotaManejoMaxima = dto.CuotaManejoMaxima,
                idGrupoPoblacional = dto.idGrupoPoblacional,
                idCupo = dto.idCupo,
                idServicioGratuito_1 = dto.idServicioGratuito_1,
                idServicioGratuito_2 = dto.idServicioGratuito_2,
                idServicioGratuito_3 = dto.idServicioGratuito_3,
                Fecha_horaActualizacion = dto.Fecha_horaActualizacion,
                Usuario = dto.Usuario,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                Fechacorte = dto.Fechacorte,
                FechaEstado = dto.FechaEstado,
                CodigoRegistro = dto.CodigoRegistro
            };
            return result;
        }

        public static List<Form425ConsultaEncabezado> getMapper(List<Formulario425_Encabezado> obj)
        {
            List<Form425ConsultaEncabezado> result = new List<Form425ConsultaEncabezado>();

            foreach (Formulario425_Encabezado consulta in obj)
            {
                Form425ConsultaEncabezado encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        public static Form425ConsultaEncabezado getMapper(Formulario425_Encabezado obj)
        {
            var result = new Form425ConsultaEncabezado()
            {
                idPropiedadesFormato = obj.idPropiedadesFormato,
                Tipo = obj.Tipo,
                Codigo = obj.Codigo,
                Nombre = obj.Nombre,
                idNombreComercial = obj.idNombreComercial,
                AperturaDigital = obj.AperturaDigital,
                idAperturaDigital = obj.idAperturaDigital,
                NumeroClientes = obj.NumeroClientes,
                Franquicia = obj.Franquicia,
                idFranquicia = obj.idFranquicia,
                CuotaManejo = obj.CuotaManejo,
                ObservacionesCuota = obj.ObservacionesCuota,
                idObservacionesCuota = obj.idObservacionesCuota,
                CuotaManejoMaxima = obj.CuotaManejoMaxima,
                GrupoPoblacional = obj.GrupoPoblacional,
                idGrupoPoblacional = obj.idGrupoPoblacional,
                Cupo = obj.Cupo,
                idCupo = obj.idCupo,
                ServicioGratuito_1 = obj.ServicioGratuito_1,
                idServicioGratuito_1 = obj.idServicioGratuito_1,
                ServicioGratuito_2 = obj.ServicioGratuito_2,
                idServicioGratuito_2 = obj.idServicioGratuito_2,
                ServicioGratuito_3 = obj.ServicioGratuito_3,
                idServicioGratuito_3 = obj.idServicioGratuito_3,
                Fecha_horaActualizacion = obj.Fecha_horaActualizacion,
                Usuario = obj.Usuario,
                Estado = obj.Estado,
                DescripcionEstado = obj.DescripcionEstado,
                Fechacorte = obj.Fechacorte,
                FechaEstado = obj.FechaEstado,
                CodigoRegistro = obj.CodigoRegistro,
                NombreComercial = obj.NombreComercial,
            };
            return result;
        }

        public static Formulario425_Encabezado getMapper(Form425ConsultaEncabezado dto)
        {
            var result = new Formulario425_Encabezado()
            {
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Tipo = dto.Tipo,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                idNombreComercial = dto.idNombreComercial,
                AperturaDigital = dto.AperturaDigital,
                idAperturaDigital = dto.idAperturaDigital,
                NumeroClientes = dto.NumeroClientes,
                Franquicia = dto.Franquicia,
                idFranquicia = dto.idFranquicia,
                CuotaManejo = dto.CuotaManejo,
                ObservacionesCuota = dto.ObservacionesCuota,
                idObservacionesCuota = dto.idObservacionesCuota,
                CuotaManejoMaxima = dto.CuotaManejoMaxima,
                GrupoPoblacional = dto.GrupoPoblacional,
                idGrupoPoblacional = dto.idGrupoPoblacional,
                Cupo = dto.Cupo,
                idCupo = dto.idCupo,
                ServicioGratuito_1 = dto.ServicioGratuito_1,
                idServicioGratuito_1 = dto.idServicioGratuito_1,
                ServicioGratuito_2 = dto.ServicioGratuito_2,
                idServicioGratuito_2 = dto.idServicioGratuito_2,
                ServicioGratuito_3 = dto.ServicioGratuito_3,
                idServicioGratuito_3 = dto.idServicioGratuito_3,
                Fecha_horaActualizacion = dto.Fecha_horaActualizacion,
                Usuario = dto.Usuario,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                Fechacorte = dto.Fechacorte,
                FechaEstado = dto.FechaEstado,
                CodigoRegistro = dto.CodigoRegistro
            };
            return result;
        }

        public static List<Form425ConsultaDetalle> getMapper(List<Formulario425_Detalle> obj)
        {
            List<Form425ConsultaDetalle> result = new List<Form425ConsultaDetalle>();

            foreach (Formulario425_Detalle consulta in obj)
            {
                Form425ConsultaDetalle encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        public static Form425ConsultaDetalle getMapper(Formulario425_Detalle obj)
        {
            var result = new Form425ConsultaDetalle()
            {
                idDetalle = obj.idDetalle,
                idPropiedadesFormato = obj.idPropiedadesFormato,
                Subcuenta = obj.Subcuenta,
                idOperacionoServicio = obj.idOperacionServicio,
                OperacionoServicio = obj.OperacionServicio,
                Canal = obj.Canal,
                idCanal = obj.idCanal,
                CostoFijo = obj.CostoFijo,
                CostoFijoMaximo = obj.CostoFijoMaximo,
                CostoProporcionOperacionServicio = obj.CostoProporcionOperacionServicio,
                CostoProporcionMaxOperacionServicio = obj.CostoProporcionMaxOperacionServicio,
                Tasa = obj.Tasa,
                TasaMaxima = obj.TasaMaxima,
                idTipoAseguradora = obj.idTipoAseguradora,
                TipoAseguradora = obj.TipoAseguradora,
                idCodigoAseguradora = obj.idCodigoAseguradora,
                CodigoAseguradora = obj.CodigoAseguradora,
                idObservaciones = obj.idObservaciones,
                Observaciones = obj.Observaciones,
                UnidadCaptura = obj.UnidadCaptura,
                Estado = obj.Estado,
                DescripcionEstado = obj.DescripcionEstado,
                FechaProceso = obj.FechaProceso,
                FechaEstado = obj.FechaEstado
            };
            return result;
        }

        public static Formulario425_Detalle getMapper(Form425ConsultaDetalle dto)
        {
            var result = new Formulario425_Detalle()
            {
                idDetalle = dto.idDetalle,
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Subcuenta = dto.Subcuenta,
                idOperacionServicio = dto.idOperacionoServicio,
                Canal = dto.Canal,
                idCanal = dto.idCanal,
                CostoFijo = dto.CostoFijo,
                CostoFijoMaximo = dto.CostoFijoMaximo,
                CostoProporcionOperacionServicio = dto.CostoProporcionOperacionServicio,
                CostoProporcionMaxOperacionServicio = dto.CostoProporcionMaxOperacionServicio,
                Tasa = dto.Tasa,
                TasaMaxima = dto.TasaMaxima,
                idTipoAseguradora = dto.idTipoAseguradora,
                idCodigoAseguradora = dto.idCodigoAseguradora,
                idObservaciones = dto.idObservaciones,
                UnidadCaptura = dto.UnidadCaptura,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                FechaProceso = dto.FechaProceso,
                FechaEstado = dto.FechaEstado
            };
            return result;
        }

        public static Formulario425_Detalle getMapper(Form425CrearDetalle dto)
        {
            var result = new Formulario425_Detalle()
            {
                idDetalle = dto.idDetalle,
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Subcuenta = dto.Subcuenta,
                idOperacionServicio = dto.idOperacionoServicio,
                Canal = dto.Canal,
                idCanal = dto.idCanal,
                CostoFijo = dto.CostoFijo,
                CostoFijoMaximo = dto.CostoFijoMaximo,
                CostoProporcionOperacionServicio = dto.CostoProporcionOperacionServicio,
                CostoProporcionMaxOperacionServicio = dto.CostoProporcionMaxOperacionServicio,
                Tasa = dto.Tasa,
                TasaMaxima = dto.TasaMaxima,
                idTipoAseguradora = dto.idTipoAseguradora,
                idCodigoAseguradora = dto.idCodigoAseguradora,
                idObservaciones = dto.idObservaciones,
                UnidadCaptura = dto.UnidadCaptura,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                FechaProceso = dto.FechaProceso,
                FechaEstado = dto.FechaEstado
            };
            return result;
        }

        #endregion

        #region Formulario 426
        public static Formulario426_Encabezado getMapper(Form426CrearEncabezado dto)
        {
            var result = new Formulario426_Encabezado()
            {
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Tipo = dto.Tipo,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                idCodigoCredito = dto.idCodigoCredito,
                idAperturaDigital = dto.idAperturaDigital,
                Fecha_horaActualizacion = dto.Fecha_horaActualizacion.ToString(),
                Usuario = dto.Usuario,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                Fechacorte = dto.Fechacorte.ToString(),
                FechaEstado = dto.FechaEstado.ToString(),
                CodigoRegistro = dto.CodigoRegistro,
                TipoProductoCredito = dto.TipoProductoCredito,
                idPropiedadesFormatoAnterior = dto.idPropiedadesFormatoAnterior
            };
            return result;
        }

        public static List<Form426ConsultaEncabezado> getMapper(List<Formulario426_Encabezado> obj)
        {
            List<Form426ConsultaEncabezado> result = new List<Form426ConsultaEncabezado>();

            foreach (Formulario426_Encabezado consulta in obj)
            {
                Form426ConsultaEncabezado encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        public static Form426ConsultaEncabezado getMapper(Formulario426_Encabezado obj)
        {
            var result = new Form426ConsultaEncabezado()
            {
                idPropiedadesFormato = obj.idPropiedadesFormato,
                Tipo = obj.Tipo,
                Codigo = obj.Codigo,
                Nombre = obj.Nombre,
                TipoProductoCredito = obj.TipoProductoCredito,
                DTipoProductoCredito = obj.DTipoProductoCredito,
                idCodigoCredito = obj.idCodigoCredito,
                CodigoCredito = obj.CodigoCredito,
                AperturaDigital = obj.AperturaDigital,
                idAperturaDigital = obj.idAperturaDigital,
                Fecha_horaActualizacion = obj.Fecha_horaActualizacion,
                Usuario = obj.Usuario,
                Estado = obj.Estado,
                DescripcionEstado = obj.DescripcionEstado,
                Fechacorte = obj.Fechacorte,
                FechaEstado = obj.FechaEstado,
                CodigoRegistro = obj.CodigoRegistro,
                idPropiedadesFormatoAnterior = obj.idPropiedadesFormatoAnterior
            };
            return result;
        }

        public static Formulario426_Encabezado getMapper(Form426ConsultaEncabezado dto)
        {
            var result = new Formulario426_Encabezado()
            {
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Tipo = dto.Tipo,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                TipoProductoCredito = dto.TipoProductoCredito,
                DTipoProductoCredito = dto.DTipoProductoCredito,
                idCodigoCredito = dto.idCodigoCredito,
                AperturaDigital = dto.AperturaDigital,
                idAperturaDigital = dto.idAperturaDigital,
                Fecha_horaActualizacion = dto.Fecha_horaActualizacion,
                Usuario = dto.Usuario,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                Fechacorte = dto.Fechacorte,
                FechaEstado = dto.FechaEstado,
                CodigoRegistro = dto.CodigoRegistro,
                idPropiedadesFormatoAnterior = dto.idPropiedadesFormatoAnterior
            };
            return result;
        }

        public static List<Form426ConsultaDetalle> getMapper(List<Formulario426_Detalle> obj)
        {
            List<Form426ConsultaDetalle> result = new List<Form426ConsultaDetalle>();

            foreach (Formulario426_Detalle consulta in obj)
            {
                Form426ConsultaDetalle encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        public static Form426ConsultaDetalle getMapper(Formulario426_Detalle obj)
        {
            var result = new Form426ConsultaDetalle()
            {
                idDetalle = obj.idDetalle,
                idPropiedadesFormato = obj.idPropiedadesFormato,
                Subcuenta = obj.Subcuenta,
                CaracteristicaCredito = obj.CaracteristicaCredito,
                idCaracteristicaCredito = obj.idCaracteristicaCredito,
                Costo = obj.Costo,
                Tasa = obj.Tasa,
                TipoAseguradora = obj.TipoAseguradora,
                idTipoAseguradora = obj.idTipoAseguradora,
                CodigoAseguradora = obj.CodigoAseguradora,
                idCodigoAseguradora = obj.idCodigoAseguradora,
                Observaciones = obj.Observaciones,
                idObservaciones = obj.idObservaciones,
                UnidadCaptura = obj.UnidadCaptura,
                Estado = obj.Estado,
                DescripcionEstado = obj.DescripcionEstado,
                FechaProceso = obj.FechaProceso,
                FechaEstado = obj.FechaEstado,
                CodigoRegistro = obj.CodigoRegistro,
                idDetalleAnterior = obj.idDetalleAnterior
            };
            return result;
        }

        public static Formulario426_Detalle getMapper(Form426CrearDetalle dto)
        {
            var result = new Formulario426_Detalle()
            {
                idDetalle = dto.idDetalle,
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Subcuenta = dto.Subcuenta,
                idCaracteristicaCredito = dto.idCaracteristicaCredito,
                Costo = dto.Costo,
                Tasa = dto.Tasa,
                idTipoAseguradora = dto.idTipoAseguradora,
                idCodigoAseguradora = dto.idCodigoAseguradora,
                idObservaciones = dto.idObservaciones,
                UnidadCaptura = dto.UnidadCaptura,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                FechaProceso = dto.FechaProceso,
                FechaEstado = dto.FechaEstado,
                CodigoRegistro = dto.CodigoRegistro,
                idDetalleAnterior = dto.idDetalleAnterior
            };
            return result;
        }

        public static Formulario426_Detalle getMapper(Form426ConsultaDetalle dto)
        {
            var result = new Formulario426_Detalle()
            {
                idDetalle = dto.idDetalle,
                idPropiedadesFormato = dto.idPropiedadesFormato,
                Subcuenta = dto.Subcuenta,
                idCaracteristicaCredito = dto.idCaracteristicaCredito,
                Costo = dto.Costo,
                Tasa = dto.Tasa,
                idTipoAseguradora = dto.idTipoAseguradora,
                idCodigoAseguradora = dto.idCodigoAseguradora,
                idObservaciones = dto.idObservaciones,
                UnidadCaptura = dto.UnidadCaptura,
                Estado = dto.Estado,
                DescripcionEstado = dto.DescripcionEstado,
                FechaProceso = dto.FechaProceso,
                FechaEstado = dto.FechaEstado,
                CodigoRegistro = dto.CodigoRegistro,
                idDetalleAnterior = dto.idDetalleAnterior
            };
            return result;
        }

        #endregion

        #region Dominios

        public static DominioModel getMapper(ConsultaDominioDTO dto)
        {
            var result = new DominioModel()
            {
                Dominio = dto.Dominio,
                idDominioGen = dto.idDominioGen,
                idDominio = dto.idDominio,
                Descripcion = dto.Descripcion,
                idCodigo = dto.idCodigo,
                Fecha = dto.Fecha,
                Estado = dto.Estado
            };
            return result;
        }

        public static List<ConsultaDominioDTO> getMapper(List<DominioModel> obj)
        {
            List<ConsultaDominioDTO> result = new List<ConsultaDominioDTO>();

            foreach (DominioModel consulta in obj)
            {
                ConsultaDominioDTO encabezado = getMapper2(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        private static ConsultaDominioDTO getMapper2(DominioModel obj)
        {
            var result = new ConsultaDominioDTO()
            {
                Dominio = obj.Dominio,
                idDominioGen = obj.idDominioGen,
                idDominio = obj.idDominio,
                Descripcion = obj.Descripcion,
                idCodigo = obj.idCodigo,
                Fecha = obj.Fecha,
                Estado = obj.Estado// == "1" ? "Inactivo" : "Activo"
            };
            return result;
        }

        public static DominioModel getMapper(CrearDominioDTO dto)
        {
            var result = new DominioModel()
            {
                Dominio = dto.Dominio,
                idDominioGen = dto.idDominioGen,
                idDominio = dto.idDominio,
                Descripcion = dto.Descripcion,
                idCodigo = dto.idCodigo,
                Fecha = dto.Fecha,
                Estado = dto.Estado
            };
            return result;
        }

        public static List<ConsultaTipoDominioDTO> getMapper(List<TipoDominioModel> obj)
        {
            List<ConsultaTipoDominioDTO> result = new List<ConsultaTipoDominioDTO>();

            foreach (TipoDominioModel consulta in obj)
            {
                ConsultaTipoDominioDTO encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }
        public static ConsultaTipoDominioDTO getMapper(TipoDominioModel obj)
        {
            var result = new ConsultaTipoDominioDTO()
            {
                idDominio = obj.idDominio,
                Descripcion = obj.Descripcion,
                Fecha = obj.Fecha,
                Estado = obj.Estado // == "1" ? "Inactivo" : "Activo"
            };
            return result;
        }
        public static TipoDominioModel getMapper(CrearTipoDominioDTO dto)
        {
            var result = new TipoDominioModel()
            {
                idDominio = dto.idDominio,
                Descripcion = dto.Descripcion,
                Fecha = dto.Fecha,
                Estado = dto.Estado
            };
            return result;
        }

        public static CrearDominioDTO getMapper(DominioModel dto)
        {
            var result = new CrearDominioDTO()
            {
                Dominio = dto.Dominio,
                idDominioGen = dto.idDominioGen,
                idDominio = dto.idDominio,
                Descripcion = dto.Descripcion,
                idCodigo = dto.idCodigo,
                Fecha = dto.Fecha,
                Estado = dto.Estado
            };
            return result;
        }

        #endregion

        #region Errores

        public static List<Errores_SFCDTO> getMapper(List<Errores_SFCModel> obj)
        {
            List<Errores_SFCDTO> result = new List<Errores_SFCDTO>();

            foreach (Errores_SFCModel consulta in obj)
            {
                Errores_SFCDTO encabezado = getMapper(consulta);
                result.Add(encabezado);
            }

            return result;
        }

        public static Errores_SFCDTO getMapper(Errores_SFCModel obj)
        {
            var result = new Errores_SFCDTO()
            {
                CodigoSalida = obj.CodigoSalida,
                Descripcion = obj.Descripcion

            };
            return result;
        }


        #endregion

    }
}
