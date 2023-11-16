USE [BPAPP]
GO
/****** Object:  User [PICHINCHA\juamar896]    Script Date: 15/11/2023 6:21:39 p. m. ******/
CREATE USER [PICHINCHA\juamar896] FOR LOGIN [PICHINCHA\juamar896] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [UserBPAPP]    Script Date: 15/11/2023 6:21:39 p. m. ******/
CREATE USER [UserBPAPP] FOR LOGIN [UserBPAPP] WITH DEFAULT_SCHEMA=[bpapp]
GO
ALTER ROLE [db_owner] ADD MEMBER [PICHINCHA\juamar896]
GO
ALTER ROLE [db_owner] ADD MEMBER [UserBPAPP]
GO
/****** Object:  Schema [bpapp]    Script Date: 15/11/2023 6:21:39 p. m. ******/
CREATE SCHEMA [bpapp]
GO
/****** Object:  StoredProcedure [bpapp].[spActualizaDetalleCreditos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<Actualizacion del información que viene desde el front end, de las Detalle_Creditos 
-- Varaibles de Salida: 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE  PROCEDURE [bpapp].[spActualizaDetalleCreditos]
	@idDetalle [INT],
	@Subcuenta [VARCHAR](5) ,
	@idCaracteristicaCredito [INT] ,
	@Costo [INT] ,
	@Tasa [NUMERIC](18, 2) ,
	@idTipoAseguradora [INT] ,
	@idCodigoAseguradora [INT] ,
	@idObservaciones [INT] ,
	@UnidadCaptura [VARCHAR](5) ,
	@IndicadorTermina [INT] OUTPUT,
	@MensajeSalida [VARCHAR](256) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EstadoAct int
	
	SET @IndicadorTermina = 1
	SET @MensajeSalida = 'Proceso termina con Exíto'

	BEGIN TRY 

		SELECT @EstadoAct = CASE estado WHEN 1 THEN 1 WHEN 2 THEN 3 ELSE estado END 
		FROM  bpapp.DetalleCreditos 
		WHERE idDetalle = @idDetalle
		
		IF  @EstadoAct NOT IN (0,4)		
		BEGIN
		
			UPDATE bpapp.DetalleCreditos
			SET Estado = 0,
				FechaEstado = GETDATE()
			WHERE idDetalle = @idDetalle
			
			INSERT INTO [bpapp].[DetalleCreditos] (idPropiedadesFormato ,Subcuenta,idCaracteristicaCredito,Costo,Tasa ,idTipoAseguradora ,idCodigoAseguradora,idObservaciones,UnidadCaptura,Estado,FechaProceso,FechaEstado,CodigoRegistro,idDetalleAnterior)	
			SELECT idPropiedadesFormato,@Subcuenta,@idCaracteristicaCredito,@Costo,@Tasa,@idTipoAseguradora,@idCodigoAseguradora,@idObservaciones,@UnidadCaptura,@EstadoAct,GETDATE(),GETDATE(),CodigoRegistro,@idDetalle
			FROM bpapp.DetalleCreditos
			WHERE idDetalle = @idDetalle
		
		END 
			ELSE 
			BEGIN	
				SET @IndicadorTermina = -1
				SET @MensajeSalida = 'Termina Sin errores pero no realiza la acción, dado que el estado del registro no Corresponde!, esta Inactivo, o esta en Edición Detalle'
				
			END 

	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		set @IndicadorTermina = -1

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spActualizaDetalleDeposito]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<actuaizacion de la información que viene desde el front end >
-- Varaibles de Salida: 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE PROCEDURE [bpapp].[spActualizaDetalleDeposito]
	@idDetalle int,
	@subCuenta varchar(5),
	@idOperacionServicio int,
	@idCanal int,
	@NumOperServiciosCuotamanejo int,
	@CostoFijo numeric(18,2),
	@CostoProporcionOperacionServicio numeric(18,2),
	@idObservaciones int,
	@UnidadCaptura varchar(5),
	@Estado int,
	@IndicadorTermina int output

AS
BEGIN
	
	SET NOCOUNT ON;
	set @IndicadorTermina = 1


	BEGIN TRY 
		/*Sentencia*/

		UPDATE [bpapp].[DetalleDepositos]
			SET
				subCuenta = @subCuenta,
				idOperacionServicio = @idOperacionServicio,
				idCanal = @idCanal,
				NumOperServiciosCuotamanejo = @NumOperServiciosCuotamanejo,
				CostoFijo = @CostoFijo,
				CostoProporcionOperacionServicio = @CostoProporcionOperacionServicio ,
				idObservaciones = @idObservaciones,
				UnidadCaptura = @UnidadCaptura,
				Estado = @Estado, 
				FechaProceso = getdate()

		WHERE
			idDetalle  = @idDetalle 

		


	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		set @IndicadorTermina = -1

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spActualizaPropiedadesCreditos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<Actualizacion del información que viene desde el front end, de las propiedades creditos. 
-- Varaibles de Salida: 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE PROCEDURE [bpapp].[spActualizaPropiedadesCreditos]
	@idPropiedadesFormato INT, 
	@Tipo [INT] ,
	@Codigo [VARCHAR](10) ,
	@Nombre [VARCHAR](32) ,
	@idCodigoCredito [INT] ,
	@idAperturaDigital [INT] ,
	@Usuario [VARCHAR](32) ,
	@IndicadorTermina INT OUTPUT,
	@MensajeSalida VARCHAR(256) OUTPUT


AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @idPropiedadesFormatoNew INT , @EstadoAct int
	
	SET @IndicadorTermina = 1
	SET @MensajeSalida = 'Proceso termina con Exíto'


	BEGIN TRY 
		
		SELECT @EstadoAct = CASE estado WHEN 1 THEN 1 WHEN 2 THEN 3 ELSE estado END 
		FROM  bpapp.PropiedadesCredito 
		WHERE idPropiedadesFormato = @idPropiedadesFormato
		
		IF  @EstadoAct NOT IN (0,4)		
		BEGIN
				UPDATE A 
				SET
					Estado = 0,
					FechaEstado = GETDATE()
				FROM  bpapp.PropiedadesCreditos A
				WHERE idPropiedadesFormato = @idPropiedadesFormato
					
				INSERT INTO [bpapp].[PropiedadesCreditos] (Tipo,Codigo,Nombre,idCodigoCredito,idAperturaDigital,Fecha_horaActualizacion,Usuario,Estado,Fechacorte,FechaEstado,CodigoRegistro,idPropiedadesFormatoAnterior)	
				SELECT @Tipo,
						@Codigo,
						@Nombre,
						@idCodigoCredito,
						@idAperturaDigital,
						getdate(),
						@Usuario, 
						@EstadoAct, 
						getdate(), 
						getdate(), 
						CodigoRegistro,
						@idPropiedadesFormato 
				FROM bpapp.PropiedadesCredito 
				WHERE idPropiedadesFormato = @idPropiedadesFormato
				
				SET @idPropiedadesFormatoNew = @@IDENTITY;
				
				
				UPDATE bpapp.DetalleCreditos
				SET idPropiedadesFormato = @idPropiedadesFormatoNew
				WHERE 
					idPropiedadesFormato = @idPropiedadesFormato
				
			
		END 
			ELSE 
			BEGIN	
				SET @IndicadorTermina = -1
				SET @MensajeSalida = 'Termina Sin errores pero no Realiza la accion, dado que el estado del registro no Corresponde!, esta Inactivo, o esta en Edición Detalle'
				
			END 
		
	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		SET @IndicadorTermina = -1
		SET @MensajeSalida = @ERROR  

				
	END CATCH   
	
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spActualizaPropiedadesDepositos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<Actualizacion del información que viene desde el front end, de las propiedades Depositos. 
-- Varaibles de Salida: 
	@IdPropiedadesFornato int Valor de la tabla el cual debe ser relacionado con la tabla de detalle en el campo "IdPropiedadesFornato" 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE PROCEDURE [bpapp].[spActualizaPropiedadesDepositos]
	@idPropiedadesFormato INT,
	@Tipo	VARCHAR(5) ,
	@Codigo VARCHAR(10),
	@Nombre VARCHAR(32),
	@NombreComercial VARCHAR(64),
	@idTipoProductoDeposito INT,
	@idAperturaDigital INT, 
	@NumeroClientes INT,
	@CuotaManejo INT,
	@idObservacionesCuota INT,
	@idGrupoPoblacional INT,
	@idIngresos INT,
	@idSerGratuito_CtaAHO INT,
	@idSerGratuito_CtaAHO2 INT,
	@idSerGratuito_CtaAHO3 INT,
	@idSerGratuito_TCRDebito INT,
	@idSerGratuito_TCRDebito2 INT,
	@idSerGratuito_TCRDebito3 INT,
	@Usuario VARCHAR(32),
	@IndicadorTermina INT OUTPUT,
	@MensajeSalida VARCHAR(256) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idPropiedadesFormatoNew INT , @EstadoAct INT
	
	SET @IndicadorTermina = 1
	SET @MensajeSalida = 'Proceso termina con Exíto'


	BEGIN TRY 
	
		SELECT @EstadoAct = CASE estado WHEN 1 THEN 1 WHEN 2 THEN 3 ELSE Estado END 
		FROM  bpapp.PropiedadesDepositos 
		WHERE idPropiedadesFormato = @idPropiedadesFormato
		
		IF  @EstadoAct NOT IN (0,4)		
		BEGIN
			UPDATE A 
				SET
					Estado = 0,
					FechaEstado = GETDATE()
				FROM  bpapp.[PropiedadesDepositos] A
				WHERE idPropiedadesFormato = @idPropiedadesFormato

				
				INSERT INTO [bpapp].[PropiedadesDepositos] (Tipo,Codigo,Nombre,NombreComercial,idTipoProductoDeposito,idAperturaDigital,NumeroClientes,CuotaManejo,
				idObservacionesCuota,idGrupoPoblacional,idIngresos,idSerGratuito_CtaAHO,idSerGratuito_CtaAHO2,idSerGratuito_CtaAHO3,idSerGratuito_TCRDebito,
				idSerGratuito_TCRDebito2,idSerGratuito_TCRDebito3,Fecha_horaActualizacion,Usuario,Estado,Fechacorte,FechaEstado,CodigoRegistro,idPropiedadesFormatoAnterior)
				SELECT @Tipo,
					@Codigo,
					@Nombre,
					@NombreComercial,
					@idTipoProductoDeposito,
					@idAperturaDigital,
					@NumeroClientes,
					@CuotaManejo,
					@idObservacionesCuota,
					@idGrupoPoblacional,
					@idIngresos,
					@idSerGratuito_CtaAHO,
					@idSerGratuito_CtaAHO2,
					@idSerGratuito_CtaAHO3,
					@idSerGratuito_TCRDebito,
					@idSerGratuito_TCRDebito2,
					@idSerGratuito_TCRDebito3,
					GETDATE(),
					@Usuario,
					@EstadoAct,
					GETDATE(),
					GETDATE(),
					CodigoRegistro,
					@idPropiedadesFormato
				FROM bpapp.PropiedadesDepositos 
				WHERE idPropiedadesFormato = @idPropiedadesFormato
				
				SET @idPropiedadesFormatoNew = @@IDENTITY;
				
				UPDATE bpapp.DetalleDepositos
				SET idPropiedadesFormato = @idPropiedadesFormatoNew
				WHERE 
					idPropiedadesFormato = @idPropiedadesFormato
						
			
		END
			ELSE 
			BEGIN	
				SET @IndicadorTermina = -1
				SET @MensajeSalida = 'Termina Sin errores pero no Realiza la accion, dado que el estado del registro no Corresponde!, esta Inactivo, o esta en Edición Detalle'
			END 



	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		SET @IndicadorTermina = -1
		SET @MensajeSalida = @ERROR 

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spActualizarPermisos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--PROCEDIMIENTO PARA ACTUALIZAR PERMISOS
create procedure [bpapp].[spActualizarPermisos](
@Detalle xml,
@Resultado bit output
)
as
begin
begin try

	BEGIN TRANSACTION
	declare @permisos table(idpermisos int,activo bit)

	insert into @permisos(idpermisos,activo)
	select 
	idpermisos = Node.Data.value('(IdPermisos)[1]','int'),
	activo = Node.Data.value('(Activo)[1]','bit')
	FROM @Detalle.nodes('/DETALLE/PERMISO') Node(Data)

	select * from @permisos

	update p set p.Activo = pe.activo from bpapp.PERMISOS p
	inner join @permisos pe on pe.idpermisos = p.IdPermisos

	COMMIT
	set @Resultado = 1

end try
begin catch
	ROLLBACK
	set @Resultado = 0
end catch
end


GO
/****** Object:  StoredProcedure [bpapp].[spAseguraCodigoRegistroCreditos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [bpapp].[spAseguraCodigoRegistroCreditos]    Script Date: 11/15/2023 10:53:46 ******/


-- =============================================
-- Author:		Marsoft S.A.S.>
-- Create date: Nov 7 2023>
-- Generacion de la data para exportar a al super para el formato 426 ReporteF426 -- CREDITOS
-- Objetivo: procedimiento mediante el cual se va a entrega la información del repoorte solicitado. 
-- Insercion y almacenado de respuesta del Web Service se deja en el campo "CodigoRespuesta" 
-- El estado se actualiza en este caso  como 2 = ENVIADO
-- =============================================
CREATE PROCEDURE [bpapp].[spAseguraCodigoRegistroCreditos]
	@Tiporegistros VARCHAR(1) = 'E',
	@idPropiedadesFormato INT = 0,
	@idRegistrosDetalle INT = 0,
	@CodigoRegistro VARCHAR(64) ,
	@IndicadorTermina int output
	
AS
BEGIN
	SET NOCOUNT ON;
	SET @IndicadorTermina = 1
	
	BEGIN TRY 
	
		IF (@Tiporegistros = 'E')
			UPDATE PC
			SET CodigoRegistro = @CodigoRegistro,
				Estado = 2,
				FechaEstado = GETDATE()
			FROM	bpapp.PropiedadesCreditos PC
			WHERE	 idPropiedadesFormato= @idPropiedadesFormato
				
		ELSE
			UPDATE DC
			SET CodigoRegistro = @CodigoRegistro,
				Estado = 2,
				FechaEstado = GETDATE()
			FROM	bpapp.DetalleCreditos DC
			WHERE	idDetalle = @idRegistrosDetalle
		
		
	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		set @IndicadorTermina = -1

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spConsultaDetalleCredito]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<consulta de la información que viene desde el front end >
-- Varaibles de Salida: 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
create  PROCEDURE [bpapp].[spConsultaDetalleCredito]
	@idPropiedadesFormato int, 
	@IndicadorTermina int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @IndicadorTermina = 1

	BEGIN TRY 
		/*Sentencia*/
		

		SELECT * 
		FROM	bpapp.DetalleCreditos
		WHERE	idPropiedadesFormato = @idPropiedadesFormato 
		


	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		SET @IndicadorTermina = -1

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spConsultaDetalleDeposito]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<consulta de la información que viene desde el front end >
-- Varaibles de Salida: 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE PROCEDURE [bpapp].[spConsultaDetalleDeposito]
	@idPropiedadesFormato int, 
	@IndicadorTermina int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @IndicadorTermina = 1

	BEGIN TRY 
		/*Sentencia*/
		

		SELECT * FROM [bpapp].[DetalleDepositos]
		WHERE
			idPropiedadesFormato = @idPropiedadesFormato 
		


	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		SET @IndicadorTermina = -1

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spConsultaPropiedadesCredito]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<Actualizacion del información que viene desde el front end, de las propiedades Credito. 
-- Varaibles de Salida: 
	@IdPropiedadesFornato int Valor de la tabla el cual debe ser relacionado con la tabla de detalle en el campo "IdPropiedadesFornato" 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE PROCEDURE [bpapp].[spConsultaPropiedadesCredito]
	@idPropiedadesFormato int = 0,
	@IndicadorTermina int output

AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ValorI INT, @Valorf INT

	SET @IndicadorTermina = 1


	BEGIN TRY 
		/*Sentencia*/

		IF(@idPropiedadesFormato = 0)
		BEGIN
			SET @ValorI = 1 
			SET @Valorf = 999999999
		END 
		ELSE
		BEGIN
			SET @ValorI = @idPropiedadesFormato 
			SET @Valorf = @idPropiedadesFormato
		END

		SELECT * FROM [bpapp].[PropiedadesCreditos]
		WHERE
			idPropiedadesFormato between @ValorI and @Valorf



	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		set @IndicadorTermina = -1

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spConsultaPropiedadesDepositos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<Actualizacion del información que viene desde el front end, de las propiedades Depositos. 
-- Varaibles de Salida: 
	@IdPropiedadesFornato int Valor de la tabla el cual debe ser relacionado con la tabla de detalle en el campo "IdPropiedadesFornato" 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE  PROCEDURE [bpapp].[spConsultaPropiedadesDepositos]
	@idPropiedadesFormato int = 0,
	@IndicadorTermina int output

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ValorI INT, @Valorf INT

	SET @IndicadorTermina = 1


	BEGIN TRY 
		/*Sentencia*/

		IF(@idPropiedadesFormato = 0)
		BEGIN
			SET @ValorI = 1 
			SET @Valorf = 999999999
		END 
		ELSE
		BEGIN
			SET @ValorI = @idPropiedadesFormato 
			SET @Valorf = @idPropiedadesFormato
		END

		SELECT * FROM [bpapp].[PropiedadesDepositos]
		WHERE
			idPropiedadesFormato between @ValorI and @Valorf



	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		set @IndicadorTermina = -1

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spEliminarRol]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDIMIENTO PARA ELIMINAR ROL
CREATE procedure [bpapp].[spEliminarRol](
@IdRol int,
@Resultado bit output
)
as
begin
	SET @Resultado = 1

	--validamos que el rol no se encuentre asignado a algun usuario
	IF not EXISTS (select * from BPAPP.USUARIO u
	inner join BPAPP.ROL r on r.IdRol  = u.IdRol
	where r.IdRol = @IdRol)
	begin	
		delete from BPAPP.PERMISOS where IdRol = @IdRol
		delete from BPAPP.ROL where IdRol = @IdRol
	end
	ELSE
		SET @Resultado = 0

end
GO
/****** Object:  StoredProcedure [bpapp].[spGeneraReporteF424]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marsoft S.A.S.>
-- Create date: Nov 7 2023>
-- Objetivo: procedimiento mediante el cual se va a entrega la información del repsorte solicitado. 
-- =============================================
CREATE PROCEDURE [bpapp].[spGeneraReporteF424]
	@Estado INT,
	@Tiporegistros VARCHAR(1) = 'E',
	@idRegistrosDetalle INT = 0
AS
BEGIN
	IF (@Tiporegistros = 'E')
		SELECT idPropiedadesFormato LlaveDetalle,Tipo tipo_entidad, Codigo entidad_cod,Nombre codigo_registro, Fechacorte fecha_reporte,NombreComercial nombre_comercial,	
				bpapp.fnTraeCodigoDominio(idTipoProductoDeposito) tipo_producto,
				bpapp.fnTraeCodigoDominio(idAperturaDigital) apertura_digital,NumeroClientes num_clientes_unicos,
				bpapp.fnTraeCodigoDominio(CuotaManejo) cuota_manejo,
				bpapp.fnTraeCodigoDominio(idObservacionesCuota) obs_cuota_manejo,
				bpapp.fnTraeCodigoDominio(idGrupoPoblacional) grupo_poblacional,
				bpapp.fnTraeCodigoDominio(idIngresos) ingresos,
				bpapp.fnTraeCodigoDominio(idSerGratuito_CtaAHO) cuenta_ahorros_1,
				bpapp.fnTraeCodigoDominio(idSerGratuito_CtaAHO2) cuenta_ahorros_2,
				bpapp.fnTraeCodigoDominio(idSerGratuito_CtaAHO3) cuenta_ahorros_3,
				bpapp.fnTraeCodigoDominio(idSerGratuito_TCRDebito) tarjeta_debito_1,
				bpapp.fnTraeCodigoDominio(idSerGratuito_TCRDebito2) tarjeta_debito_2,
				bpapp.fnTraeCodigoDominio(idSerGratuito_TCRDebito3) tarjeta_debito_3
		FROM	[bpapp].[PropiedadesDepositos]
		WHERE	Estado = @Estado
	ELSE
		SELECT idDetalle, 
				UnidadCaptura codigo_registro_uc,bpapp.fnTraeCodigoDominio(idOperacionServicio) operacion_servicio,idcanal Canal,
				bpapp.fnTraeCodigoDominio(NumOperServiciosCuotamanejo) num_oper_serv_cuota_manejo, 
				CostoFijo costo_fijo,CostoProporcionOperacionServicio costo_prop_oper_serv,bpapp.fnTraeCodigoDominio(idObservaciones) observaciones
		FROM	bpapp.DetalleDepositos
		WHERE
				idPropiedadesFormato = @idRegistrosDetalle 
				AND Estado <> 2


		
	
END


--
GO
/****** Object:  StoredProcedure [bpapp].[spGeneraReporteF425]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marsoft S.A.S.>
-- Create date: Nov 7 2023>
-- Objetivo: procedimiento mediante el cual se va a entrega la información del repsorte solicitado. 
-- Parametrso del SP 
-- =============================================
CREATE PROCEDURE [bpapp].[spGeneraReporteF425]
	@Estado INT,
	@Tiporegistros VARCHAR(1) = 'E',
	@idRegistrosDetalle INT = 0
	
AS
BEGIN
	
	IF (@Tiporegistros = 'E')
		SELECT idPropiedadesFormato LlaveDetalle,
				Tipo tipo_entidad, Codigo entidad_cod,Nombre codigo_registro, Fechacorte fecha_reporte,NombreComercial nombre_comercial,bpapp.fnTraeCodigoDominio (idAperturaDigital) apertura_digital,
				NumeroClientes num_clientes_unicos,bpapp.fnTraeCodigoDominio(idFranquicia)franquicia, CuotaManejo cuota_manejo,bpapp.fnTraeCodigoDominio(idObservacionesCuota) obs_cuota_manejo,
				bpapp.fnTraeCodigoDominio (idGrupoPoblacional) grupo_poblacional,bpapp.fnTraeCodigoDominio (idCupo) cupo,bpapp.fnTraeCodigoDominio (idServicioGratuito_1) servicio_gratuito_1 ,
				bpapp.fnTraeCodigoDominio (idServicioGratuito_2) servicio_gratuito_2,bpapp.fnTraeCodigoDominio (idServicioGratuito_3) servicio_gratuito_3
		FROM	bpapp.PropiedadesTarjetaCredito
		WHERE	Estado = @Estado
	ELSE
	
		SELECT UnidadCaptura codigo_registro_uc, bpapp.fnTraeCodigoDominio(idOperacionServicio) operacion_servicio,canal Canal,CostoFijo costo_fijo,
				CostoFijoMaximo costo_fijo_maximo, CostoProporcionOperacionServicio costo_prop_oper_serv, CostoProporcionMaxOperacionServicio costo_prop_max_oper_serv, 
				Tasa tasa,TasaMaxima tasa_maxima,bpapp.fnTraeCodigoDominio(idTipoAseguradora) tipo_entidad_aseguradora, bpapp.fnTraeCodigoDominio(idCodigoAseguradora) 
				entidad_cod_aseguradora,bpapp.fnTraeCodigoDominio(idObservaciones) observaciones
		FROM	bpapp.DetalleTarjetaCredito
		WHERE	idPropiedadesFormato = @idRegistrosDetalle 
				AND Estado  <> 2
	
		
END

GO
/****** Object:  StoredProcedure [bpapp].[spInsertaDetalleCreditos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Noviembre 2023
-- Description:	<Insercion de la información que viene desde el front end, de la Detalle_Creditos . 
-- Varaibles de Salida: 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE PROCEDURE [bpapp].[spInsertaDetalleCreditos]
	@idPropiedadesFormato [INT] ,
	@Subcuenta [VARCHAR](5) ,
	@idCaracteristicaCredito [INT] ,
	@Costo [INT] ,
	@Tasa [NUMERIC](18, 2) ,
	@idTipoAseguradora [INT] ,
	@idCodigoAseguradora [INT] ,
	@idObservaciones [INT] ,
	@UnidadCaptura [VARCHAR](5) ,
	@IndicadorTermina INT OUTPUT,
	@MensajeSalida VARCHAR(256) OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET @IndicadorTermina = 1
	SET @MensajeSalida = 'Proceso termina con Exíto'

	BEGIN TRY 
	
		INSERT INTO [bpapp].[DetalleCreditos] (idPropiedadesFormato ,Subcuenta,idCaracteristicaCredito,Costo,Tasa ,idTipoAseguradora ,idCodigoAseguradora,idObservaciones,UnidadCaptura,Estado,FechaProceso,FechaEstado )	
		SELECT @idPropiedadesFormato,@Subcuenta,@idCaracteristicaCredito,@Costo,@Tasa,@idTipoAseguradora,@idCodigoAseguradora,@idObservaciones,@UnidadCaptura,1,GETDATE(),GETDATE()


	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		SET @IndicadorTermina = -1
		SET @MensajeSalida = @ERROR  
				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spInsertaDetalleDeposito]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<Insercion de la información que viene desde el front end, para el detalle de lso depositos!>
-- Varaibles de Salida: 
	
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE PROCEDURE [bpapp].[spInsertaDetalleDeposito]
	@idPropiedadesFormato INT,
	@subCuenta VARCHAR(5),
	@idOperacionServicio INT,
	@idCanal INT,
	@NumOperServiciosCuotamanejo INT,
	@CostoFijo NUMERIC(18,2),
	@CostoProporcionOperacionServicio NUMERIC(18,2),
	@idObservaciones INT,
	@UnidadCaptura VARCHAR(5),
	@IndicadorTermina INT OUTPUT,
	@MensajeSalida VARCHAR(256) OUTPUT

AS
BEGIN
	
	SET NOCOUNT ON;
	SET @IndicadorTermina = 1
	SET @MensajeSalida = 'Proceso termina con Exíto'
	
	BEGIN TRY 
	
		INSERT INTO [bpapp].[DetalleDepositos] (idPropiedadesFormato,subCuenta,idOperacionServicio,idCanal,NumOperServiciosCuotamanejo,CostoFijo,CostoProporcionOperacionServicio,idObservaciones,
		UnidadCaptura,Estado,FechaProceso)
		SELECT @idPropiedadesFormato,
				@subCuenta,
				@idOperacionServicio,
				@idCanal,
				@NumOperServiciosCuotamanejo,
				@CostoFijo,
				@CostoProporcionOperacionServicio,
				@idObservaciones,
				@UnidadCaptura,
				1,
				getdate()
		


	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		SET @IndicadorTermina = -1
		SET @MensajeSalida = @ERROR  

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spInsertaPropiedadesCreditos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Noviembre 2023
-- Description:	<Insercion de la información que viene desde el front end, de la Propiedades_Creditos . 
-- Varaibles de Salida: 
	@IdPropiedadesFornato int Valor de la tabla el cual debe ser relacionado con la tabla de detalle en el campo "IdPropiedadesFornato" 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE PROCEDURE [bpapp].[spInsertaPropiedadesCreditos]
	
	@Tipo [INT] ,
	@Codigo [VARCHAR](10) ,
	@Nombre [VARCHAR](32) ,
    @Fecha_horaActualizacion  DATETIME,
	@idCodigoCredito [INT] ,
	@idAperturaDigital [INT] ,
	@Usuario [VARCHAR](32) ,
	@IdPropiedadesFormato INT OUTPUT,
	@IndicadorTermina INT OUTPUT,
	@MensajeSalida VARCHAR(256) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @IndicadorTermina = 1
	SET @IdPropiedadesFormato = 0
	SET @MensajeSalida = 'Proceso termina con Exíto'

	BEGIN TRY 

		INSERT INTO [bpapp].[PropiedadesCreditos] (Tipo,Codigo,Nombre,idCodigoCredito,idAperturaDigital,Fecha_horaActualizacion,Usuario,Estado,Fechacorte,FechaEstado)	
		SELECT @Tipo,@Codigo,@Nombre,@idCodigoCredito,@idAperturaDigital,getdate(),@Usuario, 1, getdate(), getdate()
		
		SET @IdPropiedadesFormato = @@IDENTITY;
	

	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		SET @IndicadorTermina = -1
		SET @MensajeSalida = @ERROR  

				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spInsertaPropiedadesDepositos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Omar Ramírez Marsoft S.A.S
-- Create date: Novimebre 23 2023
-- Description:	<Insercion de la información que viene desde el front end, de la rpopiedades Depositos. 
-- Varaibles de Salida: 
	@IdPropiedadesFornato int Valor de la tabla el cual debe ser relacionado con la tabla de detalle en el campo "IdPropiedadesFornato" 
	@IndicadorTermina int  -1 Termina con Error, 1 termina exitoso.
================================================*/
CREATE  PROCEDURE [bpapp].[spInsertaPropiedadesDepositos]
	@Tipo	VARCHAR(5) ,
	@Codigo VARCHAR(10),
	@Nombre VARCHAR(32),
	@NombreComercial VARCHAR(64),
	@TipoProductoDeposito INT,
	@AperturaDigital INT, 
	@NumeroClientes INT,
	@CuotaManejo INT,
	@ObservacionesCuota INT,
	@GrupoPoblacional INT,
	@Ingresos INT,
	@SerGratuito_CtaAHO INT,
	@SerGratuito_CtaAHO2 INT,
	@SerGratuito_CtaAHO3 INT,
	@SerGratuito_TCRDebito INT,
	@SerGratuito_TCRDebito2 INT,
	@SerGratuito_TCRDebito3 INT,
	@Usuario VARCHAR(32),
	@IdPropiedadesFomato INT OUTPUT,
	@IndicadorTermina INT OUTPUT,
	@MensajeSalida VARCHAR(256) OUTPUT

AS
BEGIN

	SET NOCOUNT ON;
	SET @IndicadorTermina = 1
	SET @MensajeSalida = 'Proceso termina con Exíto'

	BEGIN TRY 
		
		INSERT INTO [bpapp].[PropiedadesDepositos] (Tipo,Codigo,Nombre,NombreComercial,idTipoProductoDeposito,idAperturaDigital,NumeroClientes,CuotaManejo,
		idObservacionesCuota,idGrupoPoblacional,idIngresos,idSerGratuito_CtaAHO,idSerGratuito_CtaAHO2,idSerGratuito_CtaAHO3,idSerGratuito_TCRDebito,
		idSerGratuito_TCRDebito2,idSerGratuito_TCRDebito3,Fecha_horaActualizacion,Usuario,Estado,Fechacorte)
		SELECT @Tipo,
				@Codigo,
				@Nombre,
				@NombreComercial,
				@TipoProductoDeposito,
				@AperturaDigital,
				@NumeroClientes,
				@CuotaManejo,
				@ObservacionesCuota,
				@GrupoPoblacional,
				@Ingresos,
				@SerGratuito_CtaAHO,
				@SerGratuito_CtaAHO2,
				@SerGratuito_CtaAHO3,
				@SerGratuito_TCRDebito,
				@SerGratuito_TCRDebito2,
				@SerGratuito_TCRDebito3,
				GETDATE(),
				@Usuario,
				1,
				GETDATE() 

		SET @IdPropiedadesFomato = @@IDENTITY;

	END TRY
	BEGIN CATCH
					
		DECLARE @ERROR VARCHAR(MAX)
		SELECT @ERROR = 'MENSAJE ERROR: '		+ ERROR_MESSAGE()
							+ ', LINEA: '			+ CAST(ERROR_LINE() AS VARCHAR(3))
							+ ', ERROR NÚMERO: '	+ CAST(ERROR_NUMBER ()  AS VARCHAR(5))

		SET @IndicadorTermina = -1
		SET @MensajeSalida = @ERROR
				
	END CATCH   
	RETURN
END

GO
/****** Object:  StoredProcedure [bpapp].[spModificarRol]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDIMIENTO PARA MODIFICAR ROLES
CREATE procedure [bpapp].[spModificarRol](
@IdRol int,
@Descripcion varchar(60),
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM BPAPP.ROL WHERE Descripcion =@Descripcion and IdRol != @IdRol)
		
		update ROL set 
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdRol = @IdRol
	ELSE
		SET @Resultado = 0

end


GO
/****** Object:  StoredProcedure [bpapp].[spObtenerPermisos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--PROCEDMIENTO PARA OBTENER PERMISOS
CREATE procedure [bpapp].[spObtenerPermisos](
@IdRol int)
as
begin
select p.IdPermisos,m.Nombre[Menu],sm.Nombre[SubMenu],p.Activo from BPAPP.PERMISOS p
inner join BPAPP.SUBMENU sm on sm.IdSubMenu = p.IdSubMenu
inner join BPAPP.MENU m on m.IdMenu = sm.IdMenu
where p.IdRol = @IdRol
end


GO
/****** Object:  StoredProcedure [bpapp].[spObtenerRoles]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--PROCEDMIENTO PARA OBTENER ROLES
CREATE PROC [bpapp].[spObtenerRoles]
as
begin
 select IdRol, Descripcion,Activo from BPAPP.ROL
end


GO
/****** Object:  StoredProcedure [bpapp].[spRegistrarRol]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDIMIENTO PARA GUARDAR ROL
CREATE PROC [bpapp].[spRegistrarRol](
@Descripcion varchar(50),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM BPAPP.ROL WHERE Descripcion = @Descripcion)
	begin
		declare @idrol int = 0
		insert into BPAPP.ROL(Descripcion) values (
		@Descripcion
		)
		set @idrol  = Scope_identity()

		insert into BPAPP.PERMISOS(IdRol,IdSubMenu,Activo)
		select @idrol, IdSubMenu,0 from BPAPP.SUBMENU
	end
	ELSE
		SET @Resultado = 0
	
end



GO
/****** Object:  StoredProcedure [bpapp].[spReporteCreditosMomento_1]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marsoft S.A.S.>
-- Create date: Nov 7 2023>
-- Generacion de la data para exportar a al super para el formato 426 ReporteF426 -- CREDITOS
-- Objetivo: procedimiento mediante el cual se va a entrega la información del repoorte solicitado. 
-- Para MOMENTO 1  --  Insercion y alamcenado de respeusta del Web Service Codigo de Respuesta 
-- =============================================
CREATE PROCEDURE [bpapp].[spReporteCreditosMomento_1]
	@Tiporegistros VARCHAR(1) = 'E',
	@idRegistrosDetalle INT = 0
AS
BEGIN
	IF (@Tiporegistros = 'E')
		SELECT idPropiedadesFormato LlaveDetalle,
				Tipo tipo_entidad, 
				Codigo entidad_cod,
				Nombre codigo_registro, 
				Fechacorte fecha_reporte,
				bpapp.fnTraeCodigoDominio(idCodigoCredito) CodigoCredito,
				bpapp.fnTraeCodigoDominio(idAperturaDigital) apertura_digital
		FROM	bpapp.PropiedadesCreditos
		WHERE	Estado = 1
			
			
	ELSE
		SELECT UnidadCaptura codigo_registro_uc,
				bpapp.fnTraeCodigoDominio(idCaracteristicaCredito) caracteristica_credito,
				Costo costo,
				Tasa tasa, 
				idTipoAseguradora tipo_entidad_aseguradora, 
				idCodigoAseguradora entidad_cod_aseguradora,
				bpapp.fnTraeCodigoDominio(idObservaciones) Observaciones
		FROM	bpapp.DetalleCreditos
		WHERE	idPropiedadesFormato = @idRegistrosDetalle
				AND Estado = 1
		
	
END

GO
/****** Object:  StoredProcedure [bpapp].[spReporteCreditosMomento_3]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marsoft S.A.S.>
-- Create date: Nov 7 2023>
-- Generacion de la data para exportar a al super para el formato 426 ReporteF426 -- CREDITOS
-- Objetivo: procedimiento mediante el cual se va a entrega la información del repoorte solicitado. 
-- Para MOMENTO 3 --  Actualizacion y exportacion, Web Service Codigo de Respuesta 
-- Procedimiento que espera el Estado 3  -- Actualizado o el Esado  4 Detalle nuevo, y si es encabezado ao detalle, 
-- =============================================
CREATE PROCEDURE [bpapp].[spReporteCreditosMomento_3]
	@estado INT, 
	@Tiporegistros VARCHAR(1) = 'E'
	
AS
BEGIN
	IF (@Tiporegistros = 'E')
		SELECT idPropiedadesFormato LlaveDetalle,
				CodigoRegistro,
				Tipo tipo_entidad, 
				Codigo entidad_cod,
				Nombre codigo_registro, 
				Fechacorte fecha_reporte,
				bpapp.fnTraeCodigoDominio(idCodigoCredito) CodigoCredito,
				bpapp.fnTraeCodigoDominio(idAperturaDigital) apertura_digital
		FROM	bpapp.PropiedadesCreditos
		WHERE	Estado = @estado
			
	ELSE IF @estado = 3
			SELECT A.CodigoRegistro CodigoRegistroDe,
					B.CodigoRegistro CodigoRegistroEn,
					A.UnidadCaptura codigo_registro_uc,
					bpapp.fnTraeCodigoDominio(idCaracteristicaCredito) caracteristica_credito,
					A.Costo costo,
					A.Tasa tasa, 
					A.idTipoAseguradora tipo_entidad_aseguradora, 
					A.idCodigoAseguradora entidad_cod_aseguradora,
					bpapp.fnTraeCodigoDominio(idObservaciones) Observaciones
			FROM	bpapp.DetalleCreditos A
					INNER JOIN bpapp.PropiedadesCreditos B
					ON
						A.idPropiedadesFormato = B.idPropiedadesFormato
			WHERE	a.Estado = @estado
		ELSE
			SELECT B.CodigoRegistro CodigoRegistroEn,
					A.idDetalle,
					A.UnidadCaptura codigo_registro_uc,
					bpapp.fnTraeCodigoDominio(idCaracteristicaCredito) caracteristica_credito,
					A.Costo costo,
					A.Tasa tasa, 
					A.idTipoAseguradora tipo_entidad_aseguradora, 
					A.idCodigoAseguradora entidad_cod_aseguradora,
					bpapp.fnTraeCodigoDominio(idObservaciones) Observaciones
			FROM	bpapp.DetalleCreditos A
					INNER JOIN bpapp.PropiedadesCreditos B
					ON
						A.idPropiedadesFormato = B.idPropiedadesFormato
			WHERE	a.Estado = @estado
		
		
	
END

GO
/****** Object:  StoredProcedure [dbo].[usp_EliminarUsuario]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDIMIENTO PARA ELIMINAR USUARIO
CREATE procedure [dbo].[usp_EliminarUsuario](
@IdUsuario int,
@Resultado bit output
)
as
begin

	delete from BPAPP.USUARIO where IdUsuario = @IdUsuario
	SET @Resultado = 1
end


GO
/****** Object:  StoredProcedure [dbo].[usp_LoginUsuario]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_LoginUsuario](
@Usuario varchar(60),
@Clave varchar(60),
@IdUsuario int output
)
as
begin
	set @IdUsuario = 0
	if exists(select * from BPAPP.USUARIO where [LoginUsuario] COLLATE Latin1_General_CS_AS = @Usuario and LoginClave COLLATE Latin1_General_CS_AS = @Clave and Activo = 1)
		set @IdUsuario = (select top 1 IdUsuario from BPAPP.USUARIO where [LoginUsuario]  COLLATE Latin1_General_CS_AS = @Usuario and LoginClave COLLATE Latin1_General_CS_AS = @Clave and Activo = 1)
end
GO
/****** Object:  StoredProcedure [dbo].[usp_ModificarUsuario]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDIMIENTO PARA MODIFICAR USUARIO
CREATE procedure [dbo].[usp_ModificarUsuario](
@IdUsuario int,
@Nombres varchar(50),
@Apellidos varchar(50),
@IdRol int,
@Usuario varchar(50),
@Clave varchar(50),
@DescripcionReferencia varchar(50),
@IdReferencia int,
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM BPAPP.USUARIO WHERE LoginUsuario = @Usuario and IdUsuario != @IdUsuario)
		
		update BPAPP.USUARIO set 
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		IdRol = @IdRol,
		LoginUsuario = @Usuario,
		LoginClave = @Clave,
		DescripcionReferencia = @DescripcionReferencia,
		IdReferencia = @IdReferencia,
		Activo = @Activo
		where IdUsuario = @IdUsuario

	ELSE
		SET @Resultado = 0

end


GO
/****** Object:  StoredProcedure [dbo].[usp_ObtenerDetalleUsuario]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDMIENTO PARA OBTENER DETALLE USUARIO
CREATE proc [dbo].[usp_ObtenerDetalleUsuario](
@IdUsuario int
)
as
begin
 select *,
(select * from BPAPP.ROL r
 where r.IdRol = up.IdRol
FOR XML PATH (''),TYPE) AS 'DetalleRol'
,
 (
 select t.NombreMenu,t.Icono,
 (select sm.Nombre[NombreSubMenu],sm.NombreFormulario,sm.Accion,p.Activo
	 from BPAPP.PERMISOS p
	 inner join BPAPP.ROL r on r.IdRol = p.IdRol
	 inner join BPAPP.SUBMENU sm on sm.IdSubMenu = p.IdSubMenu
	 inner join BPAPP.MENU m on m.IdMenu = sm.IdMenu
	 inner join BPAPP.USUARIO u on u.IdRol = r.IdRol and u.IdUsuario = up.IdUsuario
	where sm.IdMenu = t.IdMenu
  FOR XML PATH ('SubMenu'),TYPE) AS 'DetalleSubMenu' 

 from (
 select distinct m.Nombre[NombreMenu],m.IdMenu,m.Icono
 from BPAPP.PERMISOS p
 inner join BPAPP.ROL r on r.IdRol = p.IdRol
 inner join BPAPP.SUBMENU sm on sm.IdSubMenu = p.IdSubMenu
 inner join BPAPP.MENU m on m.IdMenu = sm.IdMenu
 inner join BPAPP.USUARIO u on u.IdRol = r.IdRol and u.IdUsuario = up.IdUsuario
 where p.Activo = 1) t
 FOR XML PATH ('Menu'),TYPE) AS 'DetalleMenu'  
 from BPAPP.USUARIO up
 where UP.IdUsuario = @IdUsuario
 FOR XML PATH(''), ROOT('Usuario')  

end


GO
/****** Object:  StoredProcedure [dbo].[usp_ObtenerUsuario]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDMIENTO PARA OBTENER USUARIOS
CREATE PROC [dbo].[usp_ObtenerUsuario]
as
begin
 select u.IdUsuario,u.Nombres,u.Apellidos,u.LoginUsuario,u.LoginClave,u.IdRol,u.Activo,u.DescripcionReferencia,r.Descripcion[DescripcionRol],u.Activo from BPAPP.USUARIO u
 inner join BPAPP.ROL r on r.IdRol = u.IdRol
end


GO
/****** Object:  StoredProcedure [dbo].[usp_RegistrarUsuario]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDIMIENTO PARA REGISTRAR USUARIO
CREATE PROC [dbo].[usp_RegistrarUsuario](
@Nombres varchar(50),
@Apellidos varchar(50),
@IdRol int,
@Usuario varchar(50),
@Clave varchar(50),
@DescripcionReferencia varchar(50),
@IdReferencia int,
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM BPAPP.USUARIO WHERE LoginUsuario = @Usuario)

		insert into BPAPP.USUARIO(Nombres,Apellidos,IdRol,LoginUsuario,LoginClave,DescripcionReferencia,IdReferencia) values (
		@Nombres,@Apellidos,@IdRol,@Usuario,@Clave,@DescripcionReferencia,@IdReferencia)
	ELSE
		SET @Resultado = 0
	
end

GO
/****** Object:  UserDefinedFunction [bpapp].[fnTraeCodigoDominio]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
- Author:		Marsoft S.A.S
- Create date: Nov 7 2023
- Description:	Devolver el valor , de acuerdo a la poscicion requerida, para los dominios, 
- Para devolver el valor real del dominio, se pasa el valrto del dominio general, 
- Funcion utilizada para los Reportes
-- =============================================*/
CREATE FUNCTION [bpapp].[fnTraeCodigoDominio] 
(
		@numDominioGen int
)
RETURNS int
AS
BEGIN
	DECLARE @ValorSalida INT
	SET @ValorSalida = 0

	SELECT @ValorSalida = idcodigo 
	FROM bpapp.dominios
	WHERE
		idDominiogen = @numDominioGen
	

	RETURN @ValorSalida

END

GO
/****** Object:  UserDefinedFunction [bpapp].[fnVerificarDominio]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [bpapp].[fnVerificarDominio](@idDominioGen INT, @Columna varchar (50))
RETURNS INT
AS
BEGIN
    DECLARE @Existente INT;
    IF EXISTS (SELECT 1 FROM [bpapp].[TiposDominio] TD
					INNER JOIN [bpapp].[Dominios] D
						ON	TD.IdDominio = D.IdDominio
						AND TD.Columna = @Columna
						AND D.idDominioGen = @idDominioGen
				)
        SET @Existente = 1;
    ELSE
        SET @Existente = 0;

    RETURN @Existente;
END

		

GO
/****** Object:  Table [bpapp].[Aseguradoras]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Aseguradoras](
	[IdAseguradora] [int] NOT NULL,
	[Tipo] [int] NOT NULL,
	[Codigo] [int] NOT NULL,
	[NombreDelegaturaCompetente] [varchar](64) NOT NULL,
	[DenominacionSocialEntidad] [varchar](256) NOT NULL,
	[DenominacionAbreviadaEntidad] [varchar](128) NOT NULL,
	[NIT] [bigint] NOT NULL,
	[NombresRepresentanteLegal] [varchar](128) NULL,
	[ApellidosRepresentanteLegal] [varchar](128) NULL,
	[Cargo] [varchar](64) NULL,
	[Direccion] [varchar](128) NULL,
	[Domicilio] [varchar](64) NULL,
	[Telefono] [varchar](64) NULL,
	[Fax] [varchar](128) NULL,
	[PaginaWeb] [varchar](128) NULL,
	[Email] [varchar](160) NULL,
	[iddelegatura] [int] NULL,
	[idciudad] [int] NULL,
 CONSTRAINT [PK_Aseguradoras] PRIMARY KEY CLUSTERED 
(
	[IdAseguradora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Canal]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Canal](
	[idCodigo] [int] NOT NULL,
	[Descripcion] [varchar](64) NULL,
	[TipoCanal] [varchar](32) NULL,
 CONSTRAINT [PK_Canal] PRIMARY KEY CLUSTERED 
(
	[idCodigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Creditos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Creditos](
	[idcodigo] [int] NOT NULL,
	[idProducto] [int] NULL,
	[Monto_UVTs] [decimal](10, 3) NULL,
	[Plazo_meses] [int] NULL,
	[CodigoRegistro] [varchar](64) NULL,
 CONSTRAINT [PK_Creditos] PRIMARY KEY CLUSTERED 
(
	[idcodigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[DetalleCreditos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[DetalleCreditos](
	[idDetalle] [int] IDENTITY(1,1) NOT NULL,
	[idPropiedadesFormato] [int] NOT NULL,
	[Subcuenta] [varchar](5) NULL,
	[idCaracteristicaCredito] [int] NULL,
	[Costo] [int] NULL,
	[Tasa] [numeric](18, 2) NULL,
	[idTipoAseguradora] [int] NULL,
	[idCodigoAseguradora] [int] NULL,
	[idObservaciones] [int] NULL,
	[UnidadCaptura] [varchar](5) NULL,
	[Estado] [int] NULL,
	[FechaProceso] [datetime] NULL,
	[FechaEstado] [datetime] NOT NULL,
	[CodigoRegistro] [varchar](64) NULL,
	[idDetalleAnterior] [int] NULL,
 CONSTRAINT [PK_Detalle_Creditos] PRIMARY KEY CLUSTERED 
(
	[idDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[DetalleDepositos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[DetalleDepositos](
	[idDetalle] [int] IDENTITY(1,1) NOT NULL,
	[idPropiedadesFormato] [int] NOT NULL,
	[subCuenta] [varchar](5) NULL,
	[idOperacionServicio] [int] NULL,
	[idCanal] [int] NULL,
	[NumOperServiciosCuotamanejo] [int] NULL,
	[CostoFijo] [numeric](18, 2) NULL,
	[CostoProporcionOperacionServicio] [numeric](18, 2) NULL,
	[idObservaciones] [int] NULL,
	[UnidadCaptura] [varchar](5) NULL,
	[Estado] [int] NULL,
	[FechaProceso] [datetime] NULL,
	[FechaEstado] [datetime] NOT NULL,
	[CodigoRegistro] [varchar](64) NULL,
 CONSTRAINT [PK_Detalle_formato424] PRIMARY KEY CLUSTERED 
(
	[idDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[DetalleTarjetaCredito]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[DetalleTarjetaCredito](
	[idDetalle] [int] IDENTITY(1,1) NOT NULL,
	[idPropiedadesFormato] [int] NULL,
	[Subcuenta] [varchar](5) NULL,
	[idOperacionServicio] [int] NULL,
	[Canal] [int] NULL,
	[CostoFijo] [numeric](18, 2) NULL,
	[CostoFijoMaximo] [numeric](18, 2) NULL,
	[CostoProporcionOperacionServicio] [numeric](18, 2) NULL,
	[CostoProporcionMaxOperacionServicio] [numeric](18, 2) NULL,
	[Tasa] [numeric](18, 2) NULL,
	[TasaMaxima] [numeric](18, 2) NULL,
	[idTipoAseguradora] [int] NULL,
	[idCodigoAseguradora] [int] NULL,
	[idObservaciones] [int] NULL,
	[UnidadCaptura] [varchar](5) NULL,
	[Estado] [int] NULL,
	[FechaProceso] [datetime] NULL,
	[FechaEstado] [datetime] NOT NULL,
 CONSTRAINT [PK_Detalle_TarjetaCredito] PRIMARY KEY CLUSTERED 
(
	[idDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Dominios]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Dominios](
	[idDominioGen] [int] IDENTITY(1,1) NOT NULL,
	[idDominio] [int] NOT NULL,
	[idCodigo] [int] NOT NULL,
	[Descripcion] [varchar](64) NOT NULL,
	[Fecha] [datetime] NULL,
	[Estado] [smallint] NULL,
 CONSTRAINT [PK_Dominios_Generales] PRIMARY KEY CLUSTERED 
(
	[idDominioGen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Estados]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Estados](
	[idEstado] [int] NOT NULL,
	[Descripcion] [varchar](64) NOT NULL,
 CONSTRAINT [PK_Estados] PRIMARY KEY CLUSTERED 
(
	[idEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[LogErrores]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[LogErrores](
	[idLog] [int] IDENTITY(1,1) NOT NULL,
	[idTarifaFormato] [int] NOT NULL,
	[TipoError] [int] NOT NULL,
	[Descripcion_Error] [varchar](128) NOT NULL,
	[FechaError] [datetime] NULL,
	[TipoRegistro] [varchar](32) NULL,
	[CodigoRegistro] [varchar](64) NULL,
	[idRegistroDetalle] [int] NULL,
 CONSTRAINT [PK_LogErrores_Fg01] PRIMARY KEY CLUSTERED 
(
	[idLog] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Menu]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Menu](
	[IdMenu] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](60) NULL,
	[Icono] [varchar](60) NULL,
	[Activo] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
 CONSTRAINT [PK_MENU] PRIMARY KEY CLUSTERED 
(
	[IdMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Permisos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpapp].[Permisos](
	[IdPermisos] [int] IDENTITY(1,1) NOT NULL,
	[IdRol] [int] NULL,
	[IdSubMenu] [int] NULL,
	[Activo] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPermisos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [bpapp].[ProductoCredito]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[ProductoCredito](
	[idProducto] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](64) NULL,
 CONSTRAINT [PK_ProductoCredito] PRIMARY KEY CLUSTERED 
(
	[idProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[PropiedadesCreditos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[PropiedadesCreditos](
	[idPropiedadesFormato] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [int] NULL,
	[Codigo] [varchar](10) NULL,
	[Nombre] [varchar](32) NULL,
	[idCodigoCredito] [int] NULL,
	[idAperturaDigital] [int] NULL,
	[Fecha_horaActualizacion] [datetime] NULL,
	[Usuario] [varchar](32) NULL,
	[Estado] [int] NULL,
	[Fechacorte] [datetime] NULL,
	[FechaEstado] [datetime] NOT NULL,
	[CodigoRegistro] [varchar](64) NULL,
	[idPropiedadesFormatoAnterior] [int] NULL,
 CONSTRAINT [PK_Propiedades_Creditos] PRIMARY KEY CLUSTERED 
(
	[idPropiedadesFormato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[PropiedadesDepositos]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[PropiedadesDepositos](
	[idPropiedadesFormato] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [varchar](5) NULL,
	[Codigo] [varchar](10) NULL,
	[Nombre] [varchar](32) NULL,
	[NombreComercial] [varchar](64) NOT NULL,
	[idTipoProductoDeposito] [int] NULL,
	[idAperturaDigital] [int] NULL,
	[NumeroClientes] [int] NULL,
	[CuotaManejo] [int] NULL,
	[idObservacionesCuota] [int] NULL,
	[idGrupoPoblacional] [int] NULL,
	[idIngresos] [int] NULL,
	[idSerGratuito_CtaAHO] [int] NULL,
	[idSerGratuito_CtaAHO2] [int] NULL,
	[idSerGratuito_CtaAHO3] [int] NULL,
	[idSerGratuito_TCRDebito] [int] NULL,
	[idSerGratuito_TCRDebito2] [int] NULL,
	[idSerGratuito_TCRDebito3] [int] NULL,
	[Fecha_horaActualizacion] [datetime] NULL,
	[Usuario] [varchar](32) NULL,
	[Estado] [int] NULL,
	[Fechacorte] [datetime] NULL,
	[FechaEstado] [datetime] NOT NULL,
	[CodigoRegistro] [varchar](64) NULL,
	[idPropiedadesFormatoAnterior] [int] NULL,
 CONSTRAINT [PK_Propiedades_formato424_] PRIMARY KEY CLUSTERED 
(
	[idPropiedadesFormato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[PropiedadesTarjetaCredito]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[PropiedadesTarjetaCredito](
	[idPropiedadesFormato] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [int] NULL,
	[Codigo] [varchar](10) NULL,
	[Nombre] [varchar](32) NULL,
	[NombreComercial] [varchar](64) NULL,
	[idAperturaDigital] [int] NULL,
	[NumeroClientes] [int] NULL,
	[idFranquicia] [int] NULL,
	[CuotaManejo] [int] NULL,
	[idObservacionesCuota] [int] NULL,
	[CuotaManejoMaxima] [int] NULL,
	[idGrupoPoblacional] [int] NULL,
	[idCupo] [int] NULL,
	[idServicioGratuito_1] [int] NULL,
	[idServicioGratuito_2] [int] NULL,
	[idServicioGratuito_3] [int] NULL,
	[Fecha_horaActualizacion] [datetime] NULL,
	[Usuario] [varchar](32) NULL,
	[Estado] [int] NULL,
	[Fechacorte] [datetime] NULL,
	[FechaEstado] [datetime] NOT NULL,
	[CodigoRegistro] [varchar](64) NULL,
 CONSTRAINT [PK_Propiedades_TarjetaCredito] PRIMARY KEY CLUSTERED 
(
	[idPropiedadesFormato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Rol]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Rol](
	[IdRol] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](60) NULL,
	[Activo] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Submenu]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Submenu](
	[IdSubMenu] [int] IDENTITY(1,1) NOT NULL,
	[IdMenu] [int] NULL,
	[Nombre] [varchar](60) NULL,
	[NombreFormulario] [varchar](60) NULL,
	[Accion] [varchar](50) NULL,
	[Activo] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
 CONSTRAINT [PK_SUBMENU] PRIMARY KEY CLUSTERED 
(
	[IdSubMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[TiposDominio]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[TiposDominio](
	[idDominio] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](64) NOT NULL,
	[Fecha] [datetime] NULL,
	[Estado] [smallint] NULL,
	[Columna] [nvarchar](50) NULL,
 CONSTRAINT [PK_Tipos_Dominio] PRIMARY KEY CLUSTERED 
(
	[idDominio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [bpapp].[Usuario]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [bpapp].[Usuario](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Nombres] [varchar](100) NULL,
	[Apellidos] [varchar](100) NULL,
	[IdRol] [int] NULL,
	[LoginUsuario] [varchar](50) NULL,
	[LoginClave] [varchar](50) NULL,
	[DescripcionReferencia] [varchar](50) NULL,
	[IdReferencia] [int] NULL,
	[Activo] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [bpapp].[fnTraeValoresDominio]    Script Date: 15/11/2023 6:21:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
- Author:		Marsoft S.A.S
- Create date: Nov 7 2023
- Description:	Devolver el valor , de acuerdo a la poscicion requerida, para los dominios, 
- Para devolver el valor real del dominio, se pasa el valrto del dominio general, 
- Funcion utilizada para los Reportes
-- =============================================*/
CREATE FUNCTION [bpapp].[fnTraeValoresDominio] (@Dominio int)
	RETURNS TABLE
AS
RETURN
(
    
	select idDominioGen Dominio, CONVERT(VARCHAR(5),idCodigo) + ' - ' + Descripcion Descripcion
	FROM bpapp.dominios
	WHERE
		idDominio = @Dominio
	
	
);

GO
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (1, 27, 27, N'Delegatura para Seguros', N'Berkley Insurance Company', N'Berkley Insurance Company', 27, N'Jaime Alberto ', N'Aramburu Cortez', N'Representante para Colombia', N'Carrera 7 No. 80 - 4 Oficina  303, Centro de Negocios El Nogal', N'Bogotá D.C.', N'7420492', NULL, NULL, N'jaramburo@berkleylac.com                             gsalamanca@berkleylac.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (2, 27, 28, N'Delegatura para Seguros', N'Xl Insurance Company SE', N'Xl Insurance Company SE', 28, N'Pablo', N'Crain Loizaga Corcuera', N'Representante Principal para Colombia', N'Carrera 7 No. 114 - 33 Oficina 802 ', N'Bogotá D.C.', N'5938020', NULL, NULL, N'pablo.crain@xlcatlin.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (3, 27, 41, N'Delegatura para Seguros', N'NATIONAL UNION FIRE INSURANCE COMPANY OF PITTSBURGH P.A. OFICINA', N'NATIONAL UNION FIRE INSURANCE COMPANY OF PITTSBURGH P.A. OFICINA', 41, N'Luis Arturo ', N'Sonville De Armas ', N'Representante Principal para Colombia', N'Carrera 7 No.71-21 Oficinsa 1525', N'Bogotá D.C.', N'3257300', NULL, NULL, N'luis.sonville@aig.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (4, 11, 143, N'Delegatura para Seguros', N'Euro American Re Corredores de Reaseguros S.A.  Sigla: Ear S.A.', N'Ear S.A.', 143, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (5, 11, 161, N'Delegatura para Seguros', N'Cogent Andina Corredores de Reaseguros Ltda', N'Cogent Andina Corredores de Reaseguros Ltda', 161, N'Juan Carlos ', N'Prieto Vásquez ', N'Presidente', N'Carrera 11 No. 73-44 Of.409', N'Bogotá D.C.', N'3142399441', NULL, NULL, N'reaseguros@gmail.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (6, 11, 157, N'Delegatura para Seguros', N'Seguros Beta S.A. Corredores De Seguros ', N'Seguros Beta S.A. Corredores De Seguros', 8000000921, N'Juan Camilo', N'Salas Muñoz', N'Gerente', N'Carrera 63 No. 98 B - 54 Barrio Los Andres ', N'Bogotá D.C.', N'PBX 6439363', NULL, N'www.segurosbeta.com', N'contactenos@segurosbeta.com    / gerencia@segurosbeta.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (7, 11, 149, N'Delegatura para Seguros', N'Jargú S.A. Corredores de Seguros', N'Jargu S.A. Corredores De Seguros', 8000181658, N'Juan Carlos', N'Alvarez Jaramillo', N'Gerente', N'Carrera 19B No. 83 - 02 Oficinas 602 ', N'Bogotá D.C.', N'6171411', NULL, N'www.jargu.com', N'jargu@jargu.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (8, 11, 100, N'Delegatura para Seguros', N'Anpro Corredores de Seguros S.A.', N'Anpro Corredores De Seguros S.A.', 8000572186, N'Gerónimo', N'Barreneche Renaud', N'Gerente', N'Carrera 48 A No. 16 Sur 86 Piso 12 Ed.Plex Corporativo', N'Medellín -  Antioquia', N'3221026/3128718936', NULL, NULL, N'institucionalanpro@anpro.com.co; administrativoyfinanciero@anpro.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (9, 11, 101, N'Delegatura para Seguros', N'Santiago Vélez & Asociados Corredores de Seguros S.A.', N'Santiago Velez & Asociados Corredores De Seguros S.A.', 8000636065, N'Luis Fernando', N'Vélez Zuluaga', N'Gerente', N'Carrera 16A No 78 - 11 Oficina 202', N'Bogotá D.C.', N'6358808', N'6.17333e+006', N'www.segurosadomicilio.com', N'gerardm@sanvelez.com ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (10, 11, 102, N'Delegatura para Seguros', N'THB Colombia S.A. Corredores de Reaseguros', N'THB Colombia S.a Corredores De Reaseguros', 8000678400, N'Luis Ignacio ', N'Trujillo Echeverry', N'Presidente', N'Carrera 9 No. 123 - 76/86 Oficina 202 y 203', N'Bogotá D.C.', N'PBX 7560890', NULL, N'www.thbcolombia.com', N'luistrujillo@thbcolombia.com         manuelmelo@thbcolombia.com mauriciomelo@thbcolombia.com  alexandramayorga@thbcolombia.com                                  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (11, 11, 103, N'Delegatura para Seguros', N'J. A. Jaramillo S.A. Corredores de Reaseguros  Sigla Jaramillore', N'Jaramillore, Corredores De Reaseguros', 8001392931, N'Jorge Alberto', N'Jaramillo Sánchez ', N'Presidente', N'Carrera 11A No. 93 - 67  Oficina 203', N'Bogotá D.C.', N'6223390', N'6.213e+006', NULL, N'brokers@jaramillore.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (12, 11, 104, N'Delegatura para Seguros', N'Guy Carpenter Colombia Corredores de Reaseguros Ltda.', N'Guy Carpenter Colombia Corredores De Reaseguros Ltda.', 8001470383, N'Daniel Mauricio ', N'Parra Ferro ', N'Gerente General', N'Avenida Dorado No. 69 B - 45 Piso 9', N'Bogotá D.C.', N'57 (601) 5146400', N'4.26999e+006', N'www.guycarp.com', N'Gccolombia@guycarp.com  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (13, 11, 105, N'Delegatura para Seguros', N'AON REINSURANCE COLOMBIA LIMITADA CORREDORES DE REASEGUROS, pero', N'Aon Reinsurance Colombia Limitada.', 8001498166, N'Camilo Alberto', N'Ruiz Cortés ', N'Representante Legal', N'Carrera 11 No. 86 - 53 Piso 1 Of. 101', N'Bogotá D.C.', N'PBX 6222222 Tel. 6129496 - 6208948 - 6209080', N'6.20911e+006', N'www.aon.com/colombia', N'servicioalclientereinsurancecolombia@aon.com    Tatiana.fonseca@aon.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (14, 11, 112, N'Delegatura para Seguros', N'ARTHUR J. GALLAGHER  CORREDORES DE SEGUROS S.A.', N'Arthur J Gallagher Corredores De Seguros S.A.', 8001539905, N'Marcel', N' Saffon Tavera', N'Presidente', N'Avenida  Carrera 19 No. 120 - 71 Oficina No. 512', N'Bogotá D.C.', N'(1) 3902533', N'6.45839e+006', NULL, N'fabian_moreno@ajg.com                                              www.ajg.com/co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (15, 11, 123, N'Delegatura para Seguros', N'B.F.R. S.A. Sociedad Corredora de Seguros', N'B.F.R. S.a. Sociedad Corredora De Seguros', 8002250410, N'Cesare Giovanni', N'Rossi Buenaventura ', N'Gerente General', N'Carrera 9 No.71 - 38 Oficina 604', N'Bogotá D.C.', N'4858777', N'2.11185e+006', NULL, N'gerencia@bfrsa.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (16, 13, 41, N'Delegatura para Seguros', N'BBVA Seguros Colombia S.A. Pudiendo utilizar indistintamente, pa', N' Bbva Seguros', 8002260984, N'Marco Alejandro ', N'Arenas Prada ', N'Presidente', N'Carrera 15 No. 95 - 65 Edificio Astoria Piso 6', N'Bogotá D.C.', N'2191100 Ext.2728', N'3.12668e+006', N'www.bbva.com.co', N'bbvapres@impsat.net.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (17, 14, 25, N'Delegatura para Seguros', N'COLMENA SEGUROS RIESGOS LABORALES S.A., pudiendo actuar bajo las', N'Colmena Compañía De Seguros De Vida S.A.', 8002261753, N'Andrés David', N'Mendoza Ochoa', N'Presidente', N'Dirección General: Calle 72 No. 10 - 71 Pisos 4, 5 y  6                                                                         ', N'Bogotá D.C.', N'3241111', N'3.24087e+006', N'www.colmena_arl.com', NULL, NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (18, 14, 26, N'Delegatura para Seguros', N'BBVA Seguros de Vida Colombia S.A. pudiendo utilizar indistintam', N'BBVA Seguros De Vida', 8002408820, N'Marco Alejandro ', N'Arenas Prada ', N'Presidente', N'Carrera 15 No. 95 - 65 Edificio Astoria Pisos 5 y 6', N'Bogotá D.C.', N'2101600', N'3.12668e+006', N'www.bbvaseguros.com', N'bbvapres@impsat.net.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (19, 11, 156, N'Delegatura para Seguros', N'Gonseguros Corredores De Seguros S.A.', N'Gonseguros Corredores De Seguros S.A.', 8050038017, N'Claudia Liliana ', N'Gongora Rodríguez', N'Gerente', N'Calle 13 No. 101-71', N'Cali -Valle', N'3120202', NULL, NULL, N'clgongora@gonseguros.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (20, 13, 42, N'Delegatura para Seguros', N'SOLUNION COLOMBIA SEGUROS DE CRÉDITO S.A. Sigla: SOLUNION S.A.', N' Solunion S.A.', 8110191907, N'Jorge Andrés ', N'Jiménez Carcamo', N'Gerente  General', N'Carrera 7 Sur No. 42 - 70', N'Medellín - Antioquia', N'(054)4440145', NULL, NULL, N'credisegur@suramericana.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (21, 14, 29, N'Delegatura para Seguros', N'La Equidad Seguros de Vida Organismo Cooperativo, la cual podrá ', N'La Equidad Seguros De Vida', 8300086861, N'Néstor Raúl', N'Hernández Ospina', N'Presidente Ejecutivo ', N'Carrera 9A No. 99-07 Piso 13 Edificio 100 Street Torre Equidad', N'Bogotá D.C.', N'5922929 - 5922910', N'5.20074e+006', N'www.laequidadseguros.coop', N'presidencia@laequidadseguros.coop      ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (22, 11, 134, N'Delegatura para Seguros', N'ARTHUR J. GALLAGHER RE COLOMBIA LTDA. CORREDORES DE REASEGUROS', N'Arthur J. Gallagher Re Colombia Ltda. Corredores De Reaseguros', 8300103854, N'Adolfo', N'Urdaneta Gutiérrez ', N'Presidente', N'Avenida  Carrera 19 No. 120 - 71 Oficina No. 512', N'Bogotá D.C.', N'(1) 3902533', N'6.45839e+006', NULL, N'fabian_moreno@ajg.com                                              www.ajg.com/co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (23, 11, 136, N'Delegatura para Seguros', N'Correcol, Corredores Colombianos de Seguros, Corredores de Segur', N'Correcol', 8300180041, N'Enrique', N'Acevedo Schwabe', N'Presidente Ejecutivo', N'Calle 93A No. 11 - 36 Piso 4', N'Bogotá D.C.', N'5300053', N'5.3085e+006', N'www.correcol.com', N'sistemas@correcol.com ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (24, 27, 11, N'Delegatura para Seguros', N'Mapfre Re, Compañía de Reaseguros S.A.', N'Mapfre Re, Compañía de Reaseguros S.A.', 8300275325, N'Guillermo', N'Espinosa Calderón', N'Representante para Colombia', N'Calle 72 No. 10 - 07 Oficina 604', N'Bogotá D.C.', N'3264626', NULL, N'www.mapfrere.com', N'ricardo.perez@mapfre.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (25, 11, 145, N'Delegatura para Seguros', N'UIB Colombia S.A. Corredores de Reaseguros ', N'Uib Colombia S.A. Corredores De Reaseguros', 8300434926, N'Carlos Andrés', N'Gutierrez Nossa', N'Representante Legal', N'Calle 73 No 7 - 31 piso 6 Torre B Edificio El Camino', N'Bogotá D.C.', N'3267100', N'3.26711e+006', N'www.lambert.com.co', N'lambert.fenchurch@lambert.com.co  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (26, 14, 30, N'Delegatura para Seguros', N'Mapfre Colombia Vida Seguros S.A.', N'Mapfre Colombia Vida Seguros S.A.', 8300549046, N'Rafael', N'Prado González ', N'Presidente Ejecutivo', N'Carrera 14 No. 96 - 34 ', N'Bogotá D.C.', N'6503300', N'6.36462e+006', N'www.mapfrevida.com.co', N'vidacol@mapfre.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (27, 27, 15, N'Delegatura para Seguros', N'SCOR SE OFICINA DE REPRESENTACION EN COLOMBIA ', N'Scor SE', 8300915943, N'Germán Andrés', N'Aguirre Castañeda', N'Representante para Colombia', N'Carrera 7 No. 113 - 43 Oficina 906', N'Bogotá D.C.', N'(571) 6387888', NULL, N'www.scor.com', N'gaguirre@scor.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (28, 11, 151, N'Delegatura para Seguros', N'Willis Towers Watson Colombia Corredores de Reaseguros S.A.', N'Willis Towers Watson Colombia Corredores De Reaseguros S.A.', 8301311531, N'Jorge Alberto ', N' Ávila Venegas', N'Presidente', N'Avenida 19 No.95 - 20 Piso 24, Edificio Torre Sigma', N'Bogotá D.C.', N'6067575 / 3108602634', N'3.13475e+006', NULL, N'Anamaria.gomez@wtwco.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (29, 27, 4, N'Delegatura para Seguros', N'Mitsui Sumitomo Insurance Company Limited ', N'Mitsui Sumitomo Insurance Company Limited ', 8301369911, N'Taku', N'Nikaido', N'Representante Legal Principal para Colombia ', N'Calle 98 No. 9a- 46 Oficina 501 A Edificio Parque Chico 99 Torre 2', N'Bogotá D.C.', N'2569158 - 2569570 - 2569569 - 2569573', N'2.56957e+006', N'www.ms-ins.com', N'constanza-m@ms-ins.com  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (30, 13, 27, N'Delegatura para Seguros', N'Seguros Comerciales Bolívar S.A.', N'Seguros Comerciales Bolivar S.A.', 8600021807, N'Alvaro Alberto ', N'Carrillo Buitrago', N'Presidente', N'Avenida El Dorado No. 68B - 31 Piso 10', N'Bogotá D.C.', N'3410077', N'2.20151e+006', N'www.segurosbolivar.com', N'companiadesegurosbolivar@com.co ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (31, 14, 20, N'Delegatura para Seguros', N'Global  Seguros de Vida S.A. Sigla GLOBAL SEGUROS', N'Global Seguros', 8600021821, N'Luis Felipe', N'Daza Ferreira', N'Presidente', N'Carrera 9 No 74 - 62 ', N'Bogotá D.C.', N'3139200', NULL, N'www.globalseguroscolombia.com', NULL, NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (32, 14, 4, N'Delegatura para Seguros', N'"AXA Colpatria  Seguros de Vida S.A." (en adelante la "Sociedad"', N'Axa Colpatria Seguros De Vida  S.A.', 8600021839, N'Alexandra', N'Quiroga Velasquez ', N'Presidente', N'Carrera 7 No. 24 - 89 Pisos 4 y 7 (Torre Colpatria)', N'Bogotá D.C.', N'3364677 / 4235757 / 018000-512620', N'2.87e+006', N'www.pendiente.com.co', N'www.pendienteincluir                                  servicioalcliente@axacolpatria.co       notificacionesjudiciales@axacolpatria.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (33, 13, 6, N'Delegatura para Seguros', N'"AXA Colpatria Seguros S.A."  (en adelante la "Sociedad")', N'Axa Colpatria Seguros S.A.', 8600021846, N'Alexandra ', N'Quiroga Velásquez ', N'Presidente', N'Carrera 7 No. 24 - 89 Pisos 4 y 27 (Torre Colpatria)', N'Bogotá D.C.', N'3364677  /  4235757  /  018000-512620', N'286998', N'www.pendienteincluir', N'www.pendienteincluir                                  servicioalcliente@axacolpatria.co       notificacionesjudiciales@axacolpatria.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (34, 14, 13, N'Delegatura para Seguros', N'Metlife Colombia Seguros de Vida S.A. Siglas: "METLIFE COLOMBIA ', N'Metlife Colombia S.A', 8600023985, N'Carlos Ezequiel ', N'Mitnik Galant ', N'Presidente', N'Carrera 7 No. 99 - 54 Piso 5 ', N'Bogotá D.C.', N'PBX 6388240', N'6.3883e+006', N'www.metlife.com.co', N'secretaria.general@metlife.com.co ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (35, 13, 24, N'Delegatura para Seguros', N'La Previsora S.A. Compañía de Seguros', N'La Previsora S.a. Compañía De Seguros', 8600024002, N'Ramon Guillermo', N'Angarita Lamk', N'Presidente ', N'Calle 57 No. 9 - 07', N'Bogotá D.C.', N'3485757', NULL, N'www.previsora.gov.co               www.laprevisorasa.com', N'notificacionesactosadministrativos@previsora.gov.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (36, 14, 7, N'Delegatura para Seguros', N'Compañía de Seguros Bolívar S.A.   Denominación "SEGUROS BOLÍVAR', N'Seguros Bolivar S.A.', 8600025032, N'Alvaro Alberto ', N'Carrillo Buitrago', N'Presidente', N'Avenida El Dorado No. 68B - 31 Piso 10', N'Bogotá D.C.', N'3410077', N'2.20151e+006', N'www.segurosbolivar.com', N'companiadesegurosbolivar@com.co ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (37, 14, 9, N'Delegatura para Seguros', N'Skandia Compañía De  Seguros De Vida S.A., pudiendo en el desarr', N'Skandia Seguros De Vida S.A.', 8600025041, N'Santiago', N'García Martínez', N'Presidente', N'Avenida 19 No.109a - 30', N'Bogotá D.C.', N'018000517526  /                  6584000  / 6584300', N'2.14004e+006', N'www.skandia.com.co', N'notificacionestramites@skandia.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (38, 13, 7, N'Delegatura para Seguros', N'NACIONAL DE SEGUROS S.A. COMPAÑÍA DE SEGUROS GENERALES, y podrá ', N'Nacional De Seguros', 8600025279, N'Carlos Arturo', N'Vélez Mejía', N'Presidente Ejecutivo', N'Calle 94 No. 11-30 Piso 4', N'Bogotá D.C.', N'7463219', NULL, N'www.nacionaldeseguros.con.co', N'información@nacionaldeseguros.com.co          ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (39, 13, 9, N'Delegatura para Seguros', N'Zurich Colombia Seguros S.A.', N'Zurich Colombia Seguros S.A.', 8600025340, N'Juan Carlos', N'Realphe Guevara', N'Presidente', N'Calle 116 No.7 - 15 Of 1201 Ed. Cusezar', N'Bogotá D.C.', N'3190730', N'3.19075e+006', N'http://www.qbe.com.co                                              ', N'notificaciones.co@zurich.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (40, 10, 7, N'Delegatura para Seguros', N'"AXA Colpatria Capitalizadora S.A."  (en adelante la "Sociedad")', N'Axa Colpatria Capitalizadora  S.A.', 8600029454, N'Alexandra ', N'Quiroga Velasquez ', N'Presidente', N'Carrera 7 No. 24 - 89 Pisos 4 y 7 (Torre Colpatria)', N'Bogotá D.C.', N'3364677 / 4235757 /  018000-512620', N'2.87e+006', N'www.pendienteincluir', N'www.pendienteincluir                                  servicioalcliente@axacolpatria.co       notificacionesjudiciales@axacolpatria.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (41, 13, 14, N'Delegatura para Seguros', N'HDI SEGUROS S.A. Sigla: HDI SEGUROS', N'HDI Seguros', 8600048756, N'Luiz Francisco ', N'Minarelli Campos ', N'Presidente', N'Carrera 7 No. 72 - 13 Piso 8', N'Bogotá D.C.', N'3468888', N'2.55116e+006', N'www.generali.com.co', N'generalicolombia@generali.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (42, 10, 2, N'Delegatura para Seguros', N'Capitalizadora Bolívar S.A.', N'Capitalizadora Bolivar S.A.', 8600063596, N'Alvaro Alberto ', N'Carrillo Buitrago', N'Presidente', N'Avenida El Dorado No. 68B - 31 Piso 10', N'Bogotá D.C.', N'3410077', N'2.20151e+006', N'www.segurosbolivar.com', N'companiadesegurosbolivar@com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (43, 14, 19, N'Delegatura para Seguros', N'Seguros de Vida del Estado S.A.', N'Seguros De Vida Del Estado S.A.', 8600091744, N'Humberto', N'Mora Espinosa', N'Presidente', N'Calle 83 No.19-10', N'Bogotá D.C.', N'2186977 - 6019330', NULL, N'www.segurosdelestado.com', N'jurídico@segurosdelestado.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (44, 13, 30, N'Delegatura para Seguros', N'Segurexpo de Colombia S.A. Aseguradora de Crédito y del Comercio', N'Segurexpo', 8600091959, N'Manuel Eduardo', N'Arévalo Esguerra', N'Gerente  General', N'Calle 72 No. 6 - 44 Piso  12', N'Bogotá D.C.', N'3266969', N'2.11022e+006', N'www.segurexpo.com', N'notificacionesjudiciales@cesce.co segurexpo@cesce.co ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (45, 13, 29, N'Delegatura para Seguros', N'Seguros del Estado S.A.', N'Seguros Del Estado S.A.', 8600095786, N'Humberto', N'Mora Espinosa', N'Presidente', N'Calle 83 No.19-10', N'Bogotá D.C.', N'2186977 - 6019330', NULL, N'www.segurosdelestado.com', N'jurídico@segurosdelestado.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (46, 14, 23, N'Delegatura para Seguros', N'Positiva  Compañía de Seguros S.A.', N'Positiva Compañia De Seguros S.A.', 8600111536, N'José Luis', N' Correa López', N'Presidente ', N'Avenida Carrera 45 (autopista norte) No. 94 - 72', N'Bogotá D.C.', N'PBX 6502200  / /3307000  /018000111170', N'6.50215e+006', NULL, N'previda@latino.net.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (47, 14, 8, N'Delegatura para Seguros', N'Compañía de Seguros de Vida Aurora S.A.', N'Compañia De Seguros De Vida Aurora S.A.', 8600221375, N'Álvaro Hernán ', N'Vélez Millán ', N'Presidente                         ', N'Carrera 7 No. 74 - 21 Pisos 1 y 3', N'Bogotá D.C.', N'PBX 5524570', N'2.10283e+006', NULL, N'notificacionjudicial@segurosaurora.com  comercial@segurosaurora.com  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (48, 11, 71, N'Delegatura para Seguros', N'Howden Corredores de Seguros S.A.', N'Howden Corredores de Seguros S.A.', 8600230531, N'María Juliana', N'Tobón Peña', N'Presidente Ejecutivo', N'Avenida Carrera 45 # 102 – 10 Piso 6', N'Bogotá D.C.', N'57(1) 6075500', NULL, N'www.wacolda.com', N'scliente@hyperion.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (49, 11, 13, N'Delegatura para Seguros', N'Proseguros - Corredores de Seguros S.A. Sigla: Proseguros', N'Proseguros Corredores De Seguros S.A.', 8600248586, N'Natalia Milena ', N'Torres Gómez', N'Presidente', N'Avenida Carrera 45 # 102 – 10 Piso 6', N'Bogotá D.C.', N' +57 (1) 6075500', N'6.16999e+006', N'https://www.howdencolombia.co/howden-proseguros/', N'jairo.rojas@howdengroup.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (50, 13, 1, N'Delegatura para Seguros', N'Allianz Seguros S.A.', N'Allianz Seguros S.A.', 8600261825, N'David Alejandro', N'Colmenares Spence', N'Presidente', N'Carrera 13A No. 29-24/26 Piso 19', N'Bogotá D.C.', N'5600600', NULL, N'www.pendiente.com.co', NULL, NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (51, 13, 5, N'Delegatura para Seguros', N'CHUBB SEGUROS COLOMBIA S.A.', N'Chubb Seguros Colombia S.A.', 8600265186, N'Fabio', N'Cabral Da Silva ', N'Presidente', N'Carrera 7 No. 71 - 21  Torre B, Piso 7 Edificio Bolsa de Valores', N'Bogotá D.C.', N'3266200', NULL, N'www.ace_ina.com', N'servicioalcliente.co@chubb.com        notificacioneslegales.co@chubb.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (52, 14, 1, N'Delegatura para Seguros', N'Allianz Seguros de Vida S.A.', N'Allianz Seguros De Vida S.A.', 8600274041, N'David Alejandro', N'Colmenares Spence', N'Presidente', N'Carrera 13A No. 29 - 24/26 Piso 19', N'Bogotá D.C.', N'5600600', NULL, N'www.pendiente.com.co', NULL, NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (53, 11, 128, N'Delegatura para Seguros', N'"SEKURITAS S.A. Corredores de Seguros" y para todos los efectos ', N'Sekuritas S.A. Corredores De Seguros', 8600278289, N'Pablo', N'Stiefken Hollmann ', N'Presidente', N'Carrera  11 No. 86 - 60 Oficina 403', N'Bogotá D.C.', N'6222880', N'2.18406e+006', N'www.sekuritas.com.co', N'sekuritas@sekuritas.com.co  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (54, 15, 1, N'Delegatura para Seguros', N'La Equidad Seguros Generales Organismo Cooperativo - Denominació', N'La Equidad Seguros Generales', 8600284155, N'Néstor Raúl', N'Hernández Ospina', N'Presidente Ejecutivo ', N'Carrera 9A No. 99 - 07 Piso 13 Edificio 100 Street Torre Equidad', N'Bogotá D.C.', N'5922929 - 5922910', N'5.20074e+006', N'www.laequidadseguros.coop', N'presidencia@laequidadseguros.coop', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (55, 13, 25, N'Delegatura para Seguros', N'Seguros Alfa S.A.', N'Seguros Alfa S.A.', 8600319798, N'Sandra Patricia ', N'Solorzano Daza', N'Presidente', N'Avda. Calle 24 A No. 59 - 42, Torre 4, Pisos 4 y 5        Atención al Cliente y Correspondencia:                          Avda. ', N'Bogotá D.C.', N'3444720', NULL, N'www.segurosalfa.com.co', N'servicioalcliente@segurosalfa.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (56, 13, 17, N'Delegatura para Seguros', N'Compañía Mundial de Seguros S.A. Sigla: SEGUROS MUNDIAL ', N'Seguros Mundial ', 8600370136, N'Juan Enrique', N'Bustamante Molina', N'Presidente', N'Calle 33 No. 6B - 24 Pisos 2 y 3', N'Bogotá D.C.', N'2855600-2852511', N'2.85122e+006', N'www.mundialseguros.com.co', N'presidencia@segurosmundial.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (57, 13, 22, N'Delegatura para Seguros', N'SBS SEGUROS COLOMBIA S.A., pero podrá usar las siglas SBS SEGURO', N'SBS Seguros', 8600377079, N'Marta Lucia', N'Pava Vélez', N'Presidente', N'Avenida Carrera 9 No. 101 - 67 ', N'Bogotá D.C.', N'3138700', NULL, N'www.sbseguros.co', N'notificaciones.sbseguros@sbseguros.co     ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (58, 14, 16, N'Delegatura para Seguros', N'Pan American Life de Colombia Compañía de Seguros S.A.', N'Pan American Life De Colombia Compañía De Seguros S.A.', 8600382991, N'Diana Alejandra', N'Vargas Torres', N'Representante Legal', N'Calle 116 No # 23 - 06 / 28 Piso 7 Edificio Business Center Calle 116', N'Bogotá D.C.', N'PBX (571) 756 2323 / 018000115091', NULL, N'www.panamericanlife.com', N'mlemus@panamericanlife.com ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (59, 13, 33, N'Delegatura para Seguros', N'Liberty Seguros S.A., pudiendo utilizar comercialmente Liberty S', N'Liberty Seguros', 8600399880, N'Cesar Alberto', N' Rodriguez  Sepulveda', N'Presidente', N'Calle 72 No.10 - 07 y Calle 71 No.10 - 08 Pisos 1,6,7 y 8', N'Bogotá D.C.', N'3077050- 01 8000113390', NULL, N'www.libertyseguros.co', N'atencionalcliente@libertyseguros.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (60, 11, 129, N'Delegatura para Seguros', N'Colamseg Corredores de Seguros S.A.', N'Colamseg Corredores De Seguros S.A.', 8600487836, N'Martha Liliana ', N'Morales Riveros', N'Gerente', N'Carrera 11 No. 73 - 44 Oficina 808', N'Bogotá D.C.', N'3131584 - 3131562 -248142 4-2481714 - 3131573 -3172034 ', N'2.48171e+006', N'www.colamseg.com', N'colamseg@colamseg.com  /     info@colamseg.com                 ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (61, 11, 52, N'Delegatura para Seguros', N'CARPENTER MARSH FAC COLOMBIA CORREDORES DE REASEGUROS S.A.', N'Carpenter Marsh Fac Colombia Corredores De Reaseguros S.A.', 8600523309, N'Zulma Cristina', N'Suárez Olarte', N'Representante legal', N'Avenida  El  Dorado  No.  69b - 45,  Piso  9,  Edificio  Bogotá  Corporate  Center,  Bogotá  D.C., Colombia.', N'Bogotá D.C.', N'(57)6019501600 Ext.1231,1364', NULL, N'www.marsh.com', N'Oscar.Pinilla@marsh.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (62, 11, 125, N'Delegatura para Seguros', N'Avia Corredores de Seguros S.A.', N'Avia Corredores De Seguros S.A.', 8600567847, N'Rodrigo', N'Galvis López', N'Gerente', N'Calle 20 No. 4 - 55 Piso 3', N'Bogotá D.C.', N'5877120', N'5.40141e+006', NULL, N'Rodrigo.galvis@aviacorredoresdeseguros.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (63, 11, 74, N'Delegatura para Seguros', N'Corredores de Seguros Centroseguros S.A.', N'Centroseguros S.A.', 8600611998, N'María Cecilia', N'López de Uribe', N'Gerente', N'Carrera 7 No. 84A - 29 Oficina 901', N'Bogotá D.C.', N'3102699', NULL, N'www.Centroseguros.com.co', N'Centroseguros@centroseguros.com.co  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (64, 11, 55, N'Delegatura para Seguros', N'ReAsesores S.A. - Corredores de Reaseguros', N'Reasesores Ltda. Corredores De Reaseguros', 8600691955, N'Camilo', N'Samper Gómez', N'Presidente', N'Carrera 14 No. 86A - 48', N'Bogotá D.C.', N'2188663 - 2185611  -2188669 - 2366254', N'2.57747e+006', NULL, N'reacale@latino.com.co ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (65, 11, 56, N'Delegatura para Seguros', N'Aón Risk Services Colombia S.A. Corredores de Seguros  Sigla: Aó', N'Aon Risk Services Colombia S.A.', 8600692652, N'Mauricio', N'Acosta Valderrama', N'Presidente', N'Carrera 11 No. 86 - 35/53 Pisos 1, 4, 8 y 9', N'Bogotá D.C.', N'(571) 6381700 -                 (571) 6381900', NULL, NULL, N'Jose.luis.plana@aon.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (66, 13, 8, N'Delegatura para Seguros', N'Compañía Aseguradora de Fianzas S.A., Confianza Sigla: Seguros C', N'Seguros Confianza S.A.', 8600703749, N'Carlos Eduardo ', N'Luna Crudo ', N'Presidente ', N'Calle 82 No. 11 - 37 Piso 7', N'Bogotá D.C.', N'6444690', NULL, N'www.confianza.com.co.  ', N'centrodecontacto@confianza.com.co / notificacionesjudiciales@confianza.com.co                           ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (67, 14, 17, N'Delegatura para Seguros', N'Seguros de Vida Alfa S.A. Vidalfa', N'Seguros De Vida Alfa - Vidalfa', 8605036173, N'Sandra Patricia  ', N'Solorzano Daza', N'Presidente', N'Avda. Calle 24 A No. 59 - 42, Torre 4. Pisos 4 y 5.              Atención al Cliente - Correspondencia:                         ', N'Bogotá D.C.', N'3444720', N'3.44677e+006', N'www.segurosalfa.com.co', N'servicioalcliente@segurosalfa.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (68, 15, 2, N'Delegatura para Seguros', N'Aseguradora Solidaria de Colombia Entidad Cooperativa', N'Aseguradora Solidaria de Colombia Entidad Cooperativa', 8605246546, N'Francisco Andrés', N'Rojas Aguirre', N'Presidente Ejecutivo', N'Calle 100 No.9 A - 45 Pios 8 y 12', N'Bogotá D.C.', N'(051)6214330 / 6464330', N'2.57054e+006', N'www.solidaria.com.co', N'notificaciones@solidaria.com.co,', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (69, 11, 111, N'Delegatura para Seguros', N'ITAÚ CORREDOR DE SEGUROS COLOMBIA S.A. podra utilizar el nombre ', N'Itaú Corredor De Seguros', 8605266601, N'Ernesto', N'Sierra Pira', N'Gerente General', N'Carrera 11 No. 82 - 01 Piso 3', N'Bogotá D.C.', N'3394750 - 3394754', NULL, N'www.segurcol.com', N'correspondencia@segurcol.com ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (70, 11, 59, N'Delegatura para Seguros', N'VML S.A.  Corredores de Seguros', N'VML S.A. Corredores De Seguros', 8902069071, N'Nathalia', N'López Bernal', N'Presidente', N'Calle 121 No. 14 A - 23', N'Bogotá D.C.', N'6004333', N'6.00433e+006', N'www.vmlcorredores.com', N'notificaciones@vmlcorredores.com /  contaco@vmlcorredores.com   ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (71, 11, 80, N'Delegatura para Seguros', N'Corredores de Seguros del Valle S.A.', N'Corredores De Seguros Del Valle S.A.', 8903000401, N'Mariela', N'Franco de Duque', N'Gerente General', N'Avenida 3 Norte No. 32N - 05', N'Cali - Valle', N'6606446', N'6.61032e+006', NULL, N'seguros@correvalle.com   ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (72, 10, 3, N'Delegatura para Seguros', N'Capitalizadora Colmena S.A. Nombre de COLMENA CAPITALIZADORA, y ', N'Capitalizadora Colmena S.A.', 8903003832, N'Andrés David', N'Mendoza Ochoa', N'Presidente', N'Avenida El Dorado No. 69C - 03 Piso 6, Torre A, ', N'Bogotá D.C.', N'5141594', N'2.10513e+006', N'www.capitalizadoracolmena.com', N'andres_prieto@fundacion-social.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (73, 11, 28, N'Delegatura para Seguros', N'DELIMA MARSH S.A. LOS CORREDORES DE SEGUROS, pudiendo indistinta', N'Delima Marsh S.A.', 8903015840, N'Juan Pablo ', N'Salazar Santamaria', N'Presidente', N'Calle 67 Norte No. 6N - 85', N'Cali - Valle', N'6083100', NULL, N'www.delima.com             www.delimamarsh.com', N'Nicolas.Martinez@marsh.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (74, 11, 75, N'Delegatura para Seguros', N'Garcés Lloreda y Cía. S.A. Corredores de Seguros', N'Garces Lloreda Y Cia S.A.', 8903185322, N'Ana Lucía', N'Paz Tenorio', N'Gerente', N'Calle 70 Norte No. 3N - 45', N'Cali - Valle', N'4851110 - 6650390', N'6.65039e+006', NULL, N'garllor@garceslloreda.com                 alpaca@garceslloreda.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (75, 11, 10, N'Delegatura para Seguros', N'WILLIS TOWERS WATSON COLOMBIA CORREDORES DE SEGUROS S.A.', N'Willis Towers Watson Colombia', 8909016044, N'Margarita María', N' López Ramírez ', N'Presidente ', N'Avenida Carrera 19 No. 95-20 , Piso 16 Edificio Torre Sigma', N'Bogotá D.C.', N'6067575', N'2.8888e+006', NULL, N'hector.martinez@wtwco.com                                   Richard.viatela@wtwco.com  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (76, 13, 18, N'Delegatura para Seguros', N'SEGUROS GENERALES SURAMERICANA S.A. pudiendo emplear la sigla "S', N'Seguros Generales Sura', 8909034079, N'Juan David ', N'Escobar Franco', N'Presidente', N'Carrera 64B No. 49A - 30', N'Medellín - Antioquia', N'018000518888      (574)2602100', NULL, N'www.suramericana.com', N'bienvenida@suramericana.com.co  informacion_cliente@suramericana.com.co  solicitudes@suramericana.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (77, 14, 11, N'Delegatura para Seguros', N'SEGUROS DE VIDA SURAMERICANA S.A. pudiendo emplear la sigla "Seg', N'Seguros De Vida Sura', 8909037905, N'Juan David ', N'Escobar Franco', N'Presidente', N'Carrera 64B No. 49A - 30', N'Medellín - Antioquia', N'018000518888 - (574)2602100', NULL, N'www.suramericana.com.co', N'bienvenida@suramericana.com.co informacion_cliente@suramericana.com.co  solicitudes@suramericana.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (78, 11, 31, N'Delegatura para Seguros', N'"Aress" Corredores de Seguros S.A.', N'Aress Corredores De Seguros S.A.', 8909060252, N'Luis Guillermo', N'Betancur Vergara', N'Gerente', N'Calle 52 No. 47- 42 Piso 20 -Edificio Coltejer', N'Medellín -  Antioquia', N'(054)5111172', N'2.51246e+006', NULL, N'aress@aress.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (79, 11, 70, N'Delegatura para Seguros', N'Corredores de Seguros Asociados S.A.', N'Corredores De Seguros Asociados S.A.', 8914107712, N'Luz Elena ', N'Londoño Bernal', N'Gerente', N'Carrera 16 Bis No. 11-137 Pinares de San Martin', N'Pereira - Risaralda', N'3357302', NULL, N'www.correseguros.co ', N'infocorreseguros@gmail.com                 elenacorreseguros@gmail.com                              davidcorreseguros@gmail.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (80, 13, 26, N'Delegatura para Seguros', N'Mapfre Seguros Generales de Colombia S.A.  Sigla: MAPFRE SEGUROS', N'Mapfre Seguros', 8917000379, N'Rafael ', N'Prado González ', N'Presidente Ejecutivo', N'Avenida Carrera 70 No. 99-72 CISMAP', N'Bogotá D.C.', N'6503300', N'3.46879e+006', N'www.mapfre.com.co', N'jmincha@mapfre.com.co ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (81, 27, 19, N'Delegatura para Seguros', N'Hannover Rück SE Bogotá Oficina de Representación', N'Hannover Rück SE Bogotá ', 9001155523, N'Miguel Eduardo', N'Guarin Contreras', N'Representante para Colombia', N'Carrera 9 No. 77 - 67 Piso 5, Edificio Torre Unika ', N'Bogotá D.C.', N'(571) 6420066', NULL, NULL, NULL, NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (82, 11, 153, N'Delegatura para Seguros', N'Howden Re Corredores de Reaseguros S.A.', N'Howden Re Corredores De Reaseguros S.A.', 9001658689, N'José Miguel', N'Jiménez Ortegón', N'Presidente', N'Avenida Carrera 45 No.102-10, Piso 6', N'Bogotá D.C. ', N'2137952   -  6379758', NULL, NULL, N'laura.calvo@howdengroup.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (83, 13, 44, N'Delegatura para Seguros', N'Cardif Colombia Seguros Generales S.A.', N'Cardif Colombia Seguros Generales S.A.', 9002004353, N'Jorge Enrique ', N'Hernández Rodríguez', N'Presidente', N'Carrera 7a No. 75 - 66 ', N'Bogotá D.C.', N'7444040', NULL, N'www.presidencia@cardif.com.co', N'jorge.hernandez@cardifnet.com  ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (84, 11, 155, N'Delegatura para Seguros', N'Coomeva Corredores de Seguros S.A.', N'Coomeva Corredores De Seguros S.A.', 9003671641, N'Edwin Javier', N' Diaz Rangel', N'Gerente', N'Calle 13 No. 57 - 08 ', N'Cali - Valle', N'PBX (2) 3330000', NULL, N'www.corredoresdeseguros.coomeva.com.co             ', N'esteban_madero@coomeva.com.co, fabianl_torres@coomeva.com.co;                                               ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (85, 13, 45, N'Delegatura para Seguros', N'JMALUCELLITRAVELERS SEGUROS S.A. (en adelante la "COMPAÑÍA ASEGU', N'Jmalucellitravelers Seguros S.A.', 9004881513, N'José Miguel ', N'Otoya Grueso', N'Presidente Ejecutivo', N'Calle 98 No. 21-50 Oficina 901', N'Bogotá D.C.', N'7945774', NULL, NULL, N'jmtrv@jmtrv.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (86, 27, 24, N'Delegatura para Seguros', N'Liberty Managing Agency Limited', N'Liberty Managing Agency Limited', 9005339101, N'José Ernesto', N'Ospina Roa', N'Representante para Colombia                  REMOCIÓN: Acta 04/0', N'Avenida Carrera 9 No.113 - 52 Of. 505 Edificio Torres Unidas 2', N'Bogotá D.C.', N'(571) 7442441', NULL, NULL, N'jose.ospina@lybertysyndicates.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (87, 27, 25, N'Delegatura para Seguros', N'Münchener Rückversicherungs - Gesellschaft Aktiengesellschaft IN', N'Munich RE', 9005685795, N'Rodrigo', N'Nieto Cifuentes', N'Representante para Colombia', N'Carrera 7 No. 71 - 21 Of. 902 To B', N'Bogotá D.C.', N'3269600', N'3.17462e+006', NULL, N'rnieto@munichre.com   areimpell@munichre.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (88, 27, 26, N'Delegatura para Seguros', N'SWISS RE Colombia - Oficina de Representación', N'Swiss RE Colombia ', 9006431541, N'Manuel Ricardo', N'Pérez Cifuentes', N'Representante Principal para Colombia', N'Av. Carrera 7 No. 113 - 43  Oficina 1506', N'Bogotá D.C.', N'3211101', N'3.13589e+006', N'www.swissre.com', N'ManuelRicardo_Perez@swissre.com        Eduardo_Garduno@swissre.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (89, 13, 46, N'Delegatura para Seguros', N'COFACE COLOMBIA SEGUROS DE CRÉDITO S.A.  (en adelante: "COMPAÑÍA', N'Coface Colombia Seguros De Crédito S.A.', 9006796349, N'Hattieann Eliskka ', N'Giraldo Davila', N'Presidente', N'Carrera 11 N° 90 – 55 Piso 5', N'Bogotá D.C.', N'6231631', N'6.23163e+006', NULL, N'recepcion.colombia@coface.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (90, 13, 47, N'Delegatura para Seguros', N'BERKLEY INTERNATIONAL SEGUROS COLOMBIA S.A.  Sigla "BERKLEY COLO', N'Berkley Colombia', 9008149161, N'Maria Yolanda ', N'Ardila Guarin', N'Presidente', N'Calle 75 No. 5-88 Piso 3', N'Bogotá D.C.', N'601 3572727', NULL, NULL, N'notificacionesjudiciales@berkley.com.co               servicioalcliente@berkley.com.co', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (91, 27, 31, N'Delegatura para Seguros', N'Lloyd''s Colombia Oficina De Representación', N'Lloyd''s Colombia ', 9008852127, N'Sebastián', N'Gómez Ocampo', N'Representante para Colombia', N'Calle 90 No.11 - 13 Edificio Urban Plaza Oficina 510', N'Bogotá D.C.', N'Tel y Fax 3906000', NULL, NULL, N'Sebastian.Gomez@lloyds.com ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (92, 11, 158, N'Delegatura para Seguros', N'BRS International Latam Corredores De Reaseguros LTDA.', N'BRS International Latam Corredores De Reaseguros Ltda.', 9008903694, N'Dario Rodolfo', N'Pacanchique Moreno', N'Presidente', N'Carrera 9 No. 77-67 Oficina 1001', N'Bogotá D.C.', N'7449757- 7470166', NULL, NULL, N'pacanchique@brsint.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (93, 27, 38, N'Delegatura para Seguros', N'Austral Resseguradora S.A. (brasil)', N'Austral Resseguradora S.A. ', 9009517161, N'Tulio Hernán', N'Moreno Torres', N'Representante para Colombia', N'Carrera 7 No. 113-43 Oficina 908- Torre Samsung', N'Bogotá D.C.', N'7440992', NULL, NULL, N'hmoreno@australre.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (94, 27, 33, N'Delegatura para Seguros', N'Liberty Mutual Insurance Company', N'Liberty Mutual Insurance Company', 9009635394, N'Luis Henry', N'Sotelo Amaya', N'Representante Principal  para Colombia', N'Calle 72 No.10 - 07, Piso 3 Oficina 302-1', N'Bogotá D.C.', N'(1) 7426470-3132076731 o 3144433167', NULL, NULL, N'Henry.Sotelo@LibertyMutual.com ', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (95, 14, 31, N'Delegatura para Seguros', N'BMI COLOMBIA COMPAÑÍA DE SEGUROS DE VIDA S.A. (en adelante la BM', N'BMI Colombia', 9010613867, N'Carlos Alberto ', N'Sánchez Rodríguez', N'Presidente', N'Carrera 11 No. 84 - 09 Oficina 903', N'Bogotá D.C.', N'5187700 Ext. 119', NULL, NULL, N'notificaciones @bmicos.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (96, 27, 34, N'Delegatura para Seguros', N'Catlin Re Switzerland Ltd ', N'Catlin RE Switzerland Ltd ', 9010924614, N'Michael', N' Allen Yeats ', N'Representante Principal para Colombia', N'Carrera 9 # 115 - 30, oficina 1603 Edificio Tierra Firme', N'Bogotá D.C.', N'5938020/5938036/47', NULL, NULL, N'marilena.rodriguez@axaxl.com, carlos.gonzalez@axaxl.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (97, 27, 35, N'Delegatura para Seguros', N'Starr Indemnity & Liability Company', N'Starr Indemnity & Liability Company', 9011232074, N'Juan José ', N'Pirateque Calderón', N'Representante Principal para Colombia', N'Avenida Carrera 9 N°115-06/30, oficina 706, Edificio Tierra', N'Bogotá D.C.', N'601-9174731', NULL, NULL, N'juan.pirateque@starrcompanies.com www.starrcompanies.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (98, 27, 37, N'Delegatura para Seguros', N'Tokio Marine Compañía De Seguros S.A. De C.V.', N'Tokio Marine Compañía De Seguros S.A. De C.V.', 9013607332, N'María Fernanda ', N'Muñoz Saavedra ', N'Representante Legal Principal para Colombia ', N'Carrera 7 No. 71 - 21 Torre B Piso 15', N'Bogotá D.C.', N'(571) 3251104 / + (551) 325 1104', NULL, NULL, N'paula _valbuena@tokiomarine.com.mx', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (99, 27, 39, N'Delegatura para Seguros', N'KOREAN REINSURANCE COMPANY LIMITED (Corea)', N'Korean Reinsurance Company Limited', 9013725037, N'Sang Joon', N'Lee', N'Representante para Colombia', N'Carrera 9 No. 77-67, Oficina 406', N'Bogotá D.C.', N'(82-2) 37026992 - +57 310 623 4683', NULL, NULL, N'sonrisa@koreanre.co.kr', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (100, 11, 159, N'Delegatura para Seguros', N'Pacific RE Corredores De Reaseguros S.A.', N'Pacific RE Corredores De Reaseguros S.A.', 9013800663, N'Yoly Amelia', N'Rengifo Pedrique', N'Presidente', N'Carrera 19A No. 90 - 13 Of 501A Edificio. 90', N'Bogotá D.C.', N'300 2693', NULL, NULL, N'yoly.rengifo@pacificre.com.co', NULL, NULL)
GO
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (101, 11, 160, N'Delegatura para Seguros', N'Atlantic Latam Corredores de Reaseguros S.A.', N'Atlantic Latam Corredores de Reaseguros S.A.', 9013827867, N'José Fernando', N'Huertas Coral', N'Representante Legal', N'Calle 76 No 10-28 Bogota D.C. ', N'Bogotá D.C.', N'(031) 7463701 / 3106993585 / 3012402323 ', NULL, NULL, N'info@atlanticrebrokers.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (102, 14, 33, N'Delegatura para Seguros', N'COMPAÑÍA DE SEGUROS COLSANITAS S.A.', N'Colsanitas Seguros', 9014695802, N'Ignacio  ', N'Correa Sebastián', N'Presidente', N'Calle 100 No. 11 B-67', N'Bogotá D.C.', N'6466060/6017398939', NULL, NULL, N'impuestososi@colsanitas.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (103, 27, 40, N'Delegatura para Seguros', N'QBE Europe SA/NV', N'QBE Europe SA/NV', 9014948486, N'Christian', N'Hofmann Del Valle ', N'Representante para Colombia', N'Calle 114 No. 9 - 02, Oficina 1103, Torre Samsung', N'Bogotá D.C.', N'3183145841', NULL, N'http//:qbeeurope.com/', N'christian.hoffman@qbere.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (104, 13, 50, N'Delegatura para Seguros', N'COLMENA SEGUROS GENERALES S.A.', N'Colmena Seguros Generales, Colmena Seguros Patrimoniales, Colmen', 9015219126, N'Andrés David ', N'Mendoza Ochoa ', N'Presidente', N'Calle 72 No. 10-71 Piso 4,5 y 6', N'Bogotá D.C.', N'5141592', NULL, NULL, N'notificaciones@colmenaseguros.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (105, 14, 32, N'Delegatura para Seguros', N'COLMENA SEGUROS DE VIDA S.A., pero también podrá actuar bajo las', N'"COLMENA SEGUROS", "SEGUROS COLMENA","COLMENA SEGUROS DE VDA", "', 9015287311, N'Andrés David ', N'Mendoza Ochoa', N'Presidente', N'Calle 72 No. 10-71 Piso 6', N'Bogotá D.C.', N'3241111', NULL, NULL, N'notificaciones@colmenaseguros.com', NULL, NULL)
INSERT [bpapp].[Aseguradoras] ([IdAseguradora], [Tipo], [Codigo], [NombreDelegaturaCompetente], [DenominacionSocialEntidad], [DenominacionAbreviadaEntidad], [NIT], [NombresRepresentanteLegal], [ApellidosRepresentanteLegal], [Cargo], [Direccion], [Domicilio], [Telefono], [Fax], [PaginaWeb], [Email], [iddelegatura], [idciudad]) VALUES (106, 14, 34, N'Delegatura para Seguros', N'ASULADO SEGUROS DE VIDA S.A.', N'ASULADO SEGUROS DE VIDA S.A.', 9016606696, N'Patricia', N' Restrepo Gutierrez', N'Presidente', N'Carrera 43 A No. 3-101, piso 6', N'Medellín (Antioquia)', N'6043220025', NULL, NULL, N'notificacionesjudiciales@asulado.com.co', NULL, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (1, 1, CAST(545.000 AS Decimal(10, 3)), 60, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (2, 1, CAST(925.000 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (3, 1, CAST(1.228 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (4, 1, CAST(1.621 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (5, 1, CAST(2.814 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (11, 2, CAST(118.000 AS Decimal(10, 3)), 60, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (12, 2, CAST(284.000 AS Decimal(10, 3)), 60, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (13, 2, CAST(755.000 AS Decimal(10, 3)), 60, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (14, 2, CAST(1.256 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (15, 2, CAST(2.371 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (21, 3, CAST(33.000 AS Decimal(10, 3)), 12, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (22, 3, CAST(128.000 AS Decimal(10, 3)), 36, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (23, 3, CAST(243.000 AS Decimal(10, 3)), 48, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (24, 3, CAST(390.000 AS Decimal(10, 3)), 60, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (25, 3, CAST(1.441 AS Decimal(10, 3)), 84, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (31, 4, CAST(60.000 AS Decimal(10, 3)), 36, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (32, 4, CAST(191.000 AS Decimal(10, 3)), 48, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (33, 4, CAST(405.000 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (34, 4, CAST(852.000 AS Decimal(10, 3)), 84, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (35, 4, CAST(3.309 AS Decimal(10, 3)), 108, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (41, 5, CAST(39.000 AS Decimal(10, 3)), 36, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (42, 5, CAST(121.000 AS Decimal(10, 3)), 48, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (43, 5, CAST(261.000 AS Decimal(10, 3)), 60, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (44, 5, CAST(568.000 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (45, 5, CAST(1.792 AS Decimal(10, 3)), 84, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (51, 6, CAST(656.000 AS Decimal(10, 3)), 180, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (52, 6, CAST(1.171 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (53, 6, CAST(1.510 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (54, 6, CAST(1.922 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (55, 6, CAST(2.468 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (61, 7, CAST(656.000 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (62, 7, CAST(1.171 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (63, 7, CAST(1.510 AS Decimal(10, 3)), 300, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (64, 7, CAST(1.922 AS Decimal(10, 3)), 360, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (65, 7, CAST(2.468 AS Decimal(10, 3)), 360, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (71, 8, CAST(1.779 AS Decimal(10, 3)), 180, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (72, 8, CAST(2.480 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (73, 8, CAST(3.738 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (74, 8, CAST(5.061 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (75, 8, CAST(9.313 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (81, 9, CAST(1.779 AS Decimal(10, 3)), 180, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (82, 9, CAST(2.840 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (83, 9, CAST(3.738 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (84, 9, CAST(5.061 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (85, 9, CAST(9.313 AS Decimal(10, 3)), 240, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (91, 10, CAST(81.000 AS Decimal(10, 3)), 39, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (92, 10, CAST(168.000 AS Decimal(10, 3)), 48, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (93, 10, CAST(253.000 AS Decimal(10, 3)), 60, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (94, 10, CAST(354.000 AS Decimal(10, 3)), 72, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (95, 10, CAST(598.000 AS Decimal(10, 3)), 60, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (101, 11, CAST(31.000 AS Decimal(10, 3)), 12, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (102, 11, CAST(57.000 AS Decimal(10, 3)), 18, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (103, 11, CAST(92.000 AS Decimal(10, 3)), 24, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (104, 11, CAST(151.000 AS Decimal(10, 3)), 30, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (105, 11, CAST(419.000 AS Decimal(10, 3)), 36, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (111, 12, CAST(11.000 AS Decimal(10, 3)), 3, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (112, 12, CAST(41.000 AS Decimal(10, 3)), 12, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (113, 12, CAST(91.000 AS Decimal(10, 3)), 24, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (114, 12, CAST(182.000 AS Decimal(10, 3)), 36, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (115, 12, CAST(581.000 AS Decimal(10, 3)), 48, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (121, 13, CAST(27.000 AS Decimal(10, 3)), 12, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (122, 13, CAST(52.000 AS Decimal(10, 3)), 18, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (123, 13, CAST(84.000 AS Decimal(10, 3)), 24, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (124, 13, CAST(136.000 AS Decimal(10, 3)), 30, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (125, 13, CAST(420.000 AS Decimal(10, 3)), 36, NULL)
INSERT [bpapp].[Creditos] ([idcodigo], [idProducto], [Monto_UVTs], [Plazo_meses], [CodigoRegistro]) VALUES (131, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [bpapp].[DetalleCreditos] ON 

INSERT [bpapp].[DetalleCreditos] ([idDetalle], [idPropiedadesFormato], [Subcuenta], [idCaracteristicaCredito], [Costo], [Tasa], [idTipoAseguradora], [idCodigoAseguradora], [idObservaciones], [UnidadCaptura], [Estado], [FechaProceso], [FechaEstado], [CodigoRegistro], [idDetalleAnterior]) VALUES (4, 1, N'001
', 27, 0, CAST(0.00 AS Numeric(18, 2)), 0, 0, 2, N'01', 1, CAST(N'2023-05-31 00:00:00.000' AS DateTime), CAST(N'2023-05-31 00:00:00.000' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [bpapp].[DetalleCreditos] OFF
SET IDENTITY_INSERT [bpapp].[Dominios] ON 

INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1, 1, 1, N'Cuenta de ahorros (masivas)', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (2, 1, 2, N'Cuenta corriente (masivas)', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (4, 1, 3, N'Depósito de bajo monto y depósitos ordinarios (masivas)', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (5, 1, 4, N'Paquete de servicios básico', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (6, 1, 5, N'Cuentas de ahorros (totales)', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (7, 1, 6, N'Cuenta corriente (totales)', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (8, 1, 7, N'Depósitos de bajo monto y depósitos ordinarios (totales)', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (10, 2, 1, N'Producto con apertura digital', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (11, 2, 0, N'Sin definir', CAST(N'2023-11-03 15:14:37.170' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (12, 2, 2, N'Producto sin apertura digital
', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (14, 3, 1, N'Sin grupo particular definido', CAST(N'2023-11-02 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (16, 3, 2, N'Asalariado ', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (17, 3, 3, N'Independiente', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (18, 3, 4, N'Informal o con ingresos irregulares', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (19, 3, 5, N'Pensionado o adulto mayor', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (20, 3, 6, N'Menores de edad', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (21, 3, 7, N'Joven o estudiante', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (22, 3, 8, N'Residentes en el exterior', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (23, 3, 9, N'Extranjeros residentes en Colombia', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (24, 3, 10, N'Mujer', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (25, 3, 11, N'Rural', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (26, 3, 12, N'Microempresa', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (27, 3, 13, N'Pequeña empresa', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (28, 3, 14, N'Mediana empresa', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (29, 3, 15, N'Gran empresa', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (30, 3, 98, N'Otro', CAST(N'2023-11-02 12:27:29.327' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (31, 4, 1, N'Sin grupo particular de ingresos objetivo', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (34, 4, 2, N'Ingresos mensuales hasta de 1 SMMLV', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (35, 4, 3, N'Ingresos mensuales mayores a 1 y hasta 2 SMMLV', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (37, 4, 4, N'Ingresos mensuales mayores a 2 y hasta 4 SMMLV', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (38, 4, 5, N'Ingresos mensuales mayores a 4 y hasta 10 SMMLV', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (39, 4, 6, N'Ingresos mensuales mayores a 10 SMMLV', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (40, 5, 1, N'Cuota de manejo fija', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (41, 5, 2, N'No tiene cuota de manejo', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (42, 5, 3, N'Saldo promedio', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (43, 5, 4, N'Inactividad', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (44, 5, 5, N'Transacciones al mes', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (45, 5, 6, N'Primeros meses', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (46, 5, 7, N'Retiros', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (47, 5, 9, N'Portafolio de productos', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (48, 5, 98, N'Otros', CAST(N'2023-11-02 12:32:57.777' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (52, 6, 1, N'Talonario o libreta para cuentas de ahorro', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (53, 6, 2, N'Consignación nacional', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (54, 6, 3, N'Retiro ventanilla oficina dif radicación cuenta talonario libre', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (55, 6, 4, N'Copia de extracto en papel', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (56, 6, 5, N'Certificación bancaria', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (57, 6, 6, N'Expedición cheque de gerencia', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (58, 6, 7, N'Retiros red propia', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (59, 6, 8, N'Consultas en red propia', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (60, 6, 9, N'Certificación bancaria', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (61, 6, 10, N'Copia de extracto en papel y por internet', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (62, 6, 98, N'No aplica', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (63, 7, 1, N'American Express', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (64, 7, 2, N'Diners', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (65, 7, 3, N'MasterCard
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (66, 7, 4, N'Visa
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (67, 7, 5, N'Otra', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (68, 7, 6, N'Sin franquicia', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (69, 8, 1, N'Tarjeta diseñada sin un cupo objetivo
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (70, 8, 2, N'Tarjeta diseñada para cupo menor a 2 SMMLV
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (71, 8, 3, N'Tarjeta diseñada para cupo entre 2 y 6 SMMLV
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (72, 8, 4, N'Tarjeta diseñada para cupo mayor a 6 y hasta 10 SMMLV
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (73, 8, 5, N'Tarjeta diseñada para cupo mayor a 10 SMMLV
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (74, 9, 11, N'Avance en cajero de la misma entidad
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (75, 9, 12, N'Avance en oficina
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (76, 9, 13, N'Consulta de saldo en cajero de la misma entidad
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (77, 9, 14, N'Reposición por deterioro
', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (78, 9, 98, N'No aplica', CAST(N'2023-11-02 12:37:11.750' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (79, 10, 1, N'Consignación o depósito', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (80, 10, 2, N'Retiro', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (81, 10, 3, N'Retiro realizado fuera de Colombia', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (82, 10, 4, N'Pago o consumo', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (83, 10, 5, N'Pago con PSE', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (84, 10, 6, N'Pago o consumo realizado fuera de Colombia', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (85, 10, 7, N'Transferencia a cuenta en el mismo banco', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (86, 10, 8, N'Transferencia a cuenta en otra entidad', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (87, 10, 9, N'Transferencia en tiempo real', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (88, 10, 10, N'Recepción de transferencia desde otra entidad', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (89, 10, 11, N'Giro nacional (envío)', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (90, 10, 12, N'Tarjeta débito', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (91, 10, 13, N'Certificación o referencia', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (92, 10, 14, N'Consulta saldo o cupo de tarjeta de crédito nacional', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (93, 10, 15, N'Consulta movimientos', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (94, 10, 16, N'Copia de extracto', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (95, 10, 17, N'Reposición por pérdida o hurto', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (96, 10, 18, N'Reposición por deterioro', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (97, 10, 19, N'Debito automático', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (98, 10, 20, N'Transacción declinada por fondos insuficientes', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (99, 10, 21, N'Cheque de gerencia', CAST(N'2023-11-02 12:55:41.767' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (100, 11, 1, N'Costo fijo o proporcional  en dólares', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (101, 11, 2, N'Costo máximo', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (102, 11, 3, N'Costo mínimo', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (103, 11, 4, N'Costo depende del medio de pago', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (104, 11, 5, N'Oficinas o cajeros de aliados o redes no propias', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (105, 11, 6, N'Otras plazas', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (106, 11, 7, N'Monto de la transacción', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (107, 11, 8, N'Costo fijo por acceso', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (108, 11, 90, N'Desactivación', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (109, 11, 99, N'Otro', CAST(N'2023-11-02 12:58:42.840' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (110, 12, 13, N'Certificación o referencia', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (111, 12, 14, N'Consulta saldo o cupo de tarjeta de crédito nacional', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (112, 12, 15, N'Consulta movimientos', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (113, 12, 16, N'Copia de extracto', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (114, 12, 17, N'Reposición por pérdida o hurto', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (115, 12, 18, N'Reposición por deterioro', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (116, 12, 20, N'Transacción declinada por fondos insuficientes', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (117, 12, 22, N'Avance', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (118, 12, 23, N'Avance realizado fuera de Colombia', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (119, 12, 24, N'Compra de cartera', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (120, 12, 25, N'Comisión por transacciones internacionales', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (121, 12, 26, N'Spread TRM por consumos en el exterior (%)', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (122, 12, 27, N'VTUA porcentual (%)', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (123, 12, 28, N'Tasa de interés EA', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (124, 12, 32, N'Seguro de vida deudores', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (125, 12, 37, N'Cobro prejurídico ', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (126, 12, 38, N'Cobro jurídico ', CAST(N'2023-11-02 13:02:22.610' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (127, 13, 1, N'Costo fijo o proporcional  en dólares', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (128, 13, 2, N'Costo máximo', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (129, 13, 3, N'Costo mínimo', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (130, 13, 5, N'Oficinas o cajeros de aliados o redes no propias', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (131, 13, 6, N'Otras plazas', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (132, 13, 7, N'Monto de la transacción', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (133, 13, 9, N'Valor máximo cobros jurídicos', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (134, 13, 10, N'Valor mínimo cobros jurídicos', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (135, 13, 90, N'Desactivación', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (136, 13, 99, N'Otro', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (137, 14, 9, N'Valor máximo cobros jurídicos', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (138, 14, 10, N'Valor mínimo cobros jurídicos', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (139, 14, 11, N'Valor máximo avalúos', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (140, 14, 12, N'Valor mínimo avalúos', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (141, 14, 13, N'Cliente antigüo', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (142, 14, 14, N'Activo a financiar usado', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (143, 14, 15, N'Tasa de interés moratoria', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (144, 14, 16, N'Tasa variable UVR', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (145, 14, 17, N'Tasa variable IBR', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (146, 14, 18, N'Tasa variable DTF', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (147, 14, 19, N'Tasa variable diferente a UVR, IBR o DTF', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (148, 14, 90, N'Desactivación', CAST(N'2023-11-02 13:06:09.417' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (149, 15, 13, N'Certificación o referencia', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (150, 15, 14, N'Consulta saldo o cupo de tarjeta de crédito nacional', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (151, 15, 15, N'Consulta movimientos', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (152, 15, 16, N'Copia de extracto', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (153, 15, 17, N'Reposición por pérdida o hurto', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (154, 15, 18, N'Reposición por deterioro', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (155, 15, 20, N'Transacción declinada por fondos insuficientes', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (156, 15, 22, N'Avance', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (157, 15, 23, N'Avance realizado fuera de Colombia', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (158, 15, 24, N'Compra de cartera', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (159, 15, 25, N'Comisión por transacciones internacionales', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (160, 15, 26, N'Spread TRM por consumos en el exterior (%)', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (161, 15, 27, N'VTUA porcentual (%)', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (162, 15, 28, N'Tasa de interés EA', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (163, 15, 32, N'Seguro de vida deudores', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (164, 15, 37, N'Cobro prejurídico ', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (165, 15, 38, N'Cobro jurídico ', CAST(N'2023-11-03 10:21:18.730' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (166, 16, 1, N'ABEJORRAL - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (167, 16, 2, N'ABREGO - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (168, 16, 3, N'ABRIAQUI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (169, 16, 4, N'ACACIAS - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (170, 16, 5, N'ACANDI - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (171, 16, 6, N'ACEVEDO - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (172, 16, 7, N'ACHI - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (173, 16, 8, N'AGRADO - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (174, 16, 9, N'AGUA DE DIOS - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (175, 16, 10, N'AGUACHICA - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (176, 16, 11, N'AGUADA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (177, 16, 12, N'AGUADAS - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (178, 16, 13, N'AGUAZUL - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (179, 16, 14, N'AGUSTIN CODAZZI - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (180, 16, 15, N'AIPE - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (181, 16, 16, N'ALBAN - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (182, 16, 17, N'ALBAN - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (183, 16, 18, N'ALBANIA - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (184, 16, 19, N'ALBANIA - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (185, 16, 20, N'ALBANIA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (186, 16, 21, N'ALCALA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (187, 16, 22, N'ALDANA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (188, 16, 23, N'ALEJANDRIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (189, 16, 24, N'ALGARROBO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (190, 16, 25, N'ALGECIRAS - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (191, 16, 26, N'ALMAGUER - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (192, 16, 27, N'ALMEIDA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (193, 16, 28, N'ALPUJARRA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (194, 16, 29, N'ALTAMIRA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (195, 16, 30, N'ALTO BAUDO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (196, 16, 31, N'ALTOS DEL ROSARIO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (197, 16, 32, N'ALVARADO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (198, 16, 33, N'AMAGA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (199, 16, 34, N'AMALFI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (200, 16, 35, N'AMBALEMA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (201, 16, 36, N'ANAPOIMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (202, 16, 37, N'ANCUYA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (203, 16, 38, N'ANDALUCIA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (204, 16, 39, N'ANDES - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (205, 16, 40, N'ANGELOPOLIS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (206, 16, 41, N'ANGOSTURA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (207, 16, 42, N'ANOLAIMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (208, 16, 43, N'ANORI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (209, 16, 44, N'ANSERMA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (210, 16, 45, N'ANSERMANUEVO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (211, 16, 46, N'ANZA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (212, 16, 47, N'ANZOATEGUI - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (213, 16, 48, N'APARTADO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (214, 16, 49, N'APIA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (215, 16, 50, N'APULO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (216, 16, 51, N'AQUITANIA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (217, 16, 52, N'ARACATACA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (218, 16, 53, N'ARANZAZU - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (219, 16, 54, N'ARATOCA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (220, 16, 55, N'ARAUCA - ARAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (221, 16, 56, N'ARAUQUITA - ARAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (222, 16, 57, N'ARBELAEZ - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (223, 16, 58, N'ARBOLEDA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (224, 16, 59, N'ARBOLEDAS - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (225, 16, 60, N'ARBOLETES - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (226, 16, 61, N'ARCABUCO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (227, 16, 62, N'ARENAL - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (228, 16, 63, N'ARGELIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (229, 16, 64, N'ARGELIA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (230, 16, 65, N'ARGELIA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (231, 16, 66, N'ARIGUANI - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (232, 16, 67, N'ARJONA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (233, 16, 68, N'ARMENIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (234, 16, 69, N'ARMENIA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (235, 16, 70, N'ARMERO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (236, 16, 71, N'ARROYOHONDO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (237, 16, 72, N'ASTREA - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (238, 16, 73, N'ATACO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (239, 16, 74, N'ATRATO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (240, 16, 75, N'AYAPEL - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (241, 16, 76, N'BAGADO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (242, 16, 77, N'BAHIA SOLANO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (243, 16, 78, N'BAJO BAUDO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (244, 16, 79, N'BALBOA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (245, 16, 80, N'BALBOA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (246, 16, 81, N'BARANOA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (247, 16, 82, N'BARAYA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (248, 16, 83, N'BARBACOAS - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (249, 16, 84, N'BARBOSA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (250, 16, 85, N'BARBOSA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (251, 16, 86, N'BARICHARA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (252, 16, 87, N'BARRANCA DE UPIA - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (253, 16, 88, N'BARRANCABERMEJA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (254, 16, 89, N'BARRANCAS - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (255, 16, 90, N'BARRANCO DE LOBA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (256, 16, 91, N'BARRANCO MINAS - GUAINIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (257, 16, 92, N'BARRANQUILLA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (258, 16, 93, N'BECERRIL - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (259, 16, 94, N'BELALCAZAR - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (260, 16, 95, N'BELEN - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (261, 16, 96, N'BELEN - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (262, 16, 97, N'BELEN DE LOS ANDAQUIES - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (263, 16, 98, N'BELEN DE UMBRIA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (264, 16, 99, N'BELLO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (265, 16, 100, N'BELMIRA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (266, 16, 101, N'BELTRAN - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (267, 16, 102, N'BERBEO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (268, 16, 103, N'BETANIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (269, 16, 104, N'BETEITIVA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (270, 16, 105, N'BETULIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (271, 16, 106, N'BETULIA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (272, 16, 107, N'BITUIMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (273, 16, 108, N'BOAVITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (274, 16, 109, N'BOCHALEMA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (275, 16, 110, N'BOGOTA, D.C. - BOGOTA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (276, 16, 111, N'BOJACA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (277, 16, 112, N'BOJAYA - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (278, 16, 113, N'BOLIVAR - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (279, 16, 114, N'BOLIVAR - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (280, 16, 115, N'BOLIVAR - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (281, 16, 116, N'BOSCONIA - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (282, 16, 117, N'BOYACA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (283, 16, 118, N'BRICEÑO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (284, 16, 119, N'BRICEÑO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (285, 16, 120, N'BUCARAMANGA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (286, 16, 121, N'BUCARASICA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (287, 16, 122, N'BUENAVENTURA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (288, 16, 123, N'BUENAVISTA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (289, 16, 124, N'BUENAVISTA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (290, 16, 125, N'BUENAVISTA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (291, 16, 126, N'BUENAVISTA - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (292, 16, 127, N'BUENOS AIRES - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (293, 16, 128, N'BUESACO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (294, 16, 129, N'BUGALAGRANDE - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (295, 16, 130, N'BURITICA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (296, 16, 131, N'BUSBANZA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (297, 16, 132, N'CABRERA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (298, 16, 133, N'CABRERA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (299, 16, 134, N'CABUYARO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (300, 16, 135, N'CACAHUAL - GUAINIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (301, 16, 136, N'CACERES - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (302, 16, 137, N'CACHIPAY - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (303, 16, 138, N'CACHIRA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (304, 16, 139, N'CACOTA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (305, 16, 140, N'CAICEDO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (306, 16, 141, N'CAICEDONIA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (307, 16, 142, N'CAIMITO - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (308, 16, 143, N'CAJAMARCA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (309, 16, 144, N'CAJIBIO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (310, 16, 145, N'CAJICA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (311, 16, 146, N'CALAMAR - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (312, 16, 147, N'CALAMAR - GUAVIARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (313, 16, 148, N'CALARCA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (314, 16, 149, N'CALDAS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (315, 16, 150, N'CALDAS - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (316, 16, 151, N'CALDONO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (317, 16, 152, N'CALI - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (318, 16, 153, N'CALIFORNIA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (319, 16, 154, N'CALIMA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (320, 16, 155, N'CALOTO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (321, 16, 156, N'CAMPAMENTO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (322, 16, 157, N'CAMPO DE LA CRUZ - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (323, 16, 158, N'CAMPOALEGRE - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (324, 16, 159, N'CAMPOHERMOSO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (325, 16, 160, N'CANALETE - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (326, 16, 161, N'CAÑASGORDAS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (327, 16, 162, N'CANDELARIA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (328, 16, 163, N'CANDELARIA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (329, 16, 164, N'CANTAGALLO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (330, 16, 165, N'CAPARRAPI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (331, 16, 166, N'CAPITANEJO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (332, 16, 167, N'CAQUEZA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (333, 16, 168, N'CARACOLI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (334, 16, 169, N'CARAMANTA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (335, 16, 170, N'CARCASI - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (336, 16, 171, N'CAREPA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (337, 16, 172, N'CARMEN DE APICALA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (338, 16, 173, N'CARMEN DE CARUPA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (339, 16, 174, N'CARMEN DEL DARIEN - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (340, 16, 175, N'CAROLINA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (341, 16, 176, N'CARTAGENA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (342, 16, 177, N'CARTAGENA DEL CHAIRA - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (343, 16, 178, N'CARTAGO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (344, 16, 179, N'CARURU - VAUPES', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (345, 16, 180, N'CASABIANCA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (346, 16, 181, N'CASTILLA LA NUEVA - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (347, 16, 182, N'CAUCASIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (348, 16, 183, N'CEPITA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (349, 16, 184, N'CERETE - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (350, 16, 185, N'CERINZA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (351, 16, 186, N'CERRITO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (352, 16, 187, N'CERRO SAN ANTONIO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (353, 16, 188, N'CERTEGUI - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (354, 16, 189, N'CHACHAGsI - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (355, 16, 190, N'CHAGUANI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (356, 16, 191, N'CHALAN - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (357, 16, 192, N'CHAMEZA - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (358, 16, 193, N'CHAPARRAL - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (359, 16, 194, N'CHARALA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (360, 16, 195, N'CHARTA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (361, 16, 196, N'CHIA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (362, 16, 197, N'CHIBOLO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (363, 16, 198, N'CHIGORODO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (364, 16, 199, N'CHIMA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (365, 16, 200, N'CHIMA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (366, 16, 201, N'CHIMICHAGUA - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (367, 16, 202, N'CHINACOTA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (368, 16, 203, N'CHINAVITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (369, 16, 204, N'CHINCHINA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (370, 16, 205, N'CHINU - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (371, 16, 206, N'CHIPAQUE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (372, 16, 207, N'CHIPATA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (373, 16, 208, N'CHIQUINQUIRA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (374, 16, 209, N'CHIQUIZA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (375, 16, 210, N'CHIRIGUANA - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (376, 16, 211, N'CHISCAS - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (377, 16, 212, N'CHITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (378, 16, 213, N'CHITAGA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (379, 16, 214, N'CHITARAQUE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (380, 16, 215, N'CHIVATA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (381, 16, 216, N'CHIVOR - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (382, 16, 217, N'CHOACHI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (383, 16, 218, N'CHOCONTA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (384, 16, 219, N'CICUCO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (385, 16, 220, N'CIENAGA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (386, 16, 221, N'CIENAGA DE ORO - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (387, 16, 222, N'CIENEGA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (388, 16, 223, N'CIMITARRA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (389, 16, 224, N'CIRCASIA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (390, 16, 225, N'CISNEROS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (391, 16, 226, N'CIUDAD BOLIVAR - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (392, 16, 227, N'CLEMENCIA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (393, 16, 228, N'COCORNA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (394, 16, 229, N'COELLO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (395, 16, 230, N'COGUA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (396, 16, 231, N'COLOMBIA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (397, 16, 232, N'COLON - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (398, 16, 233, N'COLON - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (399, 16, 234, N'COLOSO - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (400, 16, 235, N'COMBITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (401, 16, 236, N'CONCEPCION - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (402, 16, 237, N'CONCEPCION - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (403, 16, 238, N'CONCORDIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (404, 16, 239, N'CONCORDIA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (405, 16, 240, N'CONDOTO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (406, 16, 241, N'CONFINES - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (407, 16, 242, N'CONSACA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (408, 16, 243, N'CONTADERO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (409, 16, 244, N'CONTRATACION - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (410, 16, 245, N'CONVENCION - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (411, 16, 246, N'COPACABANA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (412, 16, 247, N'COPER - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (413, 16, 248, N'CORDOBA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (414, 16, 249, N'CORDOBA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (415, 16, 250, N'CORDOBA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (416, 16, 251, N'CORINTO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (417, 16, 252, N'COROMORO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (418, 16, 253, N'COROZAL - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (419, 16, 254, N'CORRALES - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (420, 16, 255, N'COTA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (421, 16, 256, N'COTORRA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (422, 16, 257, N'COVARACHIA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (423, 16, 258, N'COVEÑAS - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (424, 16, 259, N'COYAIMA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (425, 16, 260, N'CRAVO NORTE - ARAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (426, 16, 261, N'CUASPUD - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (427, 16, 262, N'CUBARA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (428, 16, 263, N'CUBARRAL - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (429, 16, 264, N'CUCAITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (430, 16, 265, N'CUCUNUBA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (431, 16, 266, N'CUCUTA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (432, 16, 267, N'CUCUTILLA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (433, 16, 268, N'CUITIVA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (434, 16, 269, N'CUMARAL - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (435, 16, 270, N'CUMARIBO - VICHADA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (436, 16, 271, N'CUMBAL - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (437, 16, 272, N'CUMBITARA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (438, 16, 273, N'CUNDAY - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (439, 16, 274, N'CURILLO - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (440, 16, 275, N'CURITI - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (441, 16, 276, N'CURUMANI - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (442, 16, 277, N'DABEIBA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (443, 16, 278, N'DAGUA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (444, 16, 279, N'DIBULLA - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (445, 16, 280, N'DISTRACCION - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (446, 16, 281, N'DOLORES - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (447, 16, 282, N'DON MATIAS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (448, 16, 283, N'DOSQUEBRADAS - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (449, 16, 284, N'DUITAMA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (450, 16, 285, N'DURANIA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (451, 16, 286, N'EBEJICO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (452, 16, 287, N'EL AGUILA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (453, 16, 288, N'EL BAGRE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (454, 16, 289, N'EL BANCO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (455, 16, 290, N'EL CAIRO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (456, 16, 291, N'EL CALVARIO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (457, 16, 292, N'EL CANTON DEL SAN PABLO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (458, 16, 293, N'EL CARMEN - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (459, 16, 294, N'EL CARMEN DE ATRATO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (460, 16, 295, N'EL CARMEN DE BOLIVAR - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (461, 16, 296, N'EL CARMEN DE CHUCURI - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (462, 16, 297, N'EL CARMEN DE VIBORAL - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (463, 16, 298, N'EL CASTILLO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (464, 16, 299, N'EL CERRITO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (465, 16, 300, N'EL CHARCO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (466, 16, 301, N'EL COCUY - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (467, 16, 302, N'EL COLEGIO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (468, 16, 303, N'EL COPEY - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (469, 16, 304, N'EL DONCELLO - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (470, 16, 305, N'EL DORADO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (471, 16, 306, N'EL DOVIO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (472, 16, 307, N'EL ENCANTO - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (473, 16, 308, N'EL ESPINO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (474, 16, 309, N'EL GUACAMAYO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (475, 16, 310, N'EL GUAMO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (476, 16, 311, N'EL LITORAL DEL SAN JUAN - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (477, 16, 312, N'EL MOLINO - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (478, 16, 313, N'EL PASO - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (479, 16, 314, N'EL PAUJIL - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (480, 16, 315, N'EL PEÑOL - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (481, 16, 316, N'EL PEÑON - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (482, 16, 317, N'EL PEÑON - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (483, 16, 318, N'EL PEÑON - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (484, 16, 319, N'EL PIÑON - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (485, 16, 320, N'EL PLAYON - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (486, 16, 321, N'EL RETEN - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (487, 16, 322, N'EL RETORNO - GUAVIARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (488, 16, 323, N'EL ROBLE - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (489, 16, 324, N'EL ROSAL - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (490, 16, 325, N'EL ROSARIO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (491, 16, 326, N'EL SANTUARIO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (492, 16, 327, N'EL TABLON DE GOMEZ - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (493, 16, 328, N'EL TAMBO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (494, 16, 329, N'EL TAMBO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (495, 16, 330, N'EL TARRA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (496, 16, 331, N'EL ZULIA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (497, 16, 332, N'ELIAS - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (498, 16, 333, N'ENCINO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (499, 16, 334, N'ENCISO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (500, 16, 335, N'ENTRERRIOS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (501, 16, 336, N'ENVIGADO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (502, 16, 337, N'ESPINAL - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (503, 16, 338, N'FACATATIVA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (504, 16, 339, N'FALAN - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (505, 16, 340, N'FILADELFIA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (506, 16, 341, N'FILANDIA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (507, 16, 342, N'FIRAVITOBA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (508, 16, 343, N'FLANDES - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (509, 16, 344, N'FLORENCIA - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (510, 16, 345, N'FLORENCIA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (511, 16, 346, N'FLORESTA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (512, 16, 347, N'FLORIAN - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (513, 16, 348, N'FLORIDA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (514, 16, 349, N'FLORIDABLANCA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (515, 16, 350, N'FOMEQUE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (516, 16, 351, N'FONSECA - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (517, 16, 352, N'FORTUL - ARAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (518, 16, 353, N'FOSCA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (519, 16, 354, N'FRANCISCO PIZARRO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (520, 16, 355, N'FREDONIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (521, 16, 356, N'FRESNO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (522, 16, 357, N'FRONTINO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (523, 16, 358, N'FUENTE DE ORO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (524, 16, 359, N'FUNDACION - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (525, 16, 360, N'FUNES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (526, 16, 361, N'FUNZA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (527, 16, 362, N'FUQUENE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (528, 16, 363, N'FUSAGASUGA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (529, 16, 364, N'GACHALA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (530, 16, 365, N'GACHANCIPA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (531, 16, 366, N'GACHANTIVA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (532, 16, 367, N'GACHETA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (533, 16, 368, N'GALAN - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (534, 16, 369, N'GALAPA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (535, 16, 370, N'GALERAS - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (536, 16, 371, N'GAMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (537, 16, 372, N'GAMARRA - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (538, 16, 373, N'GAMBITA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (539, 16, 374, N'GAMEZA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (540, 16, 375, N'GARAGOA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (541, 16, 376, N'GARZON - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (542, 16, 377, N'GENOVA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (543, 16, 378, N'GIGANTE - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (544, 16, 379, N'GINEBRA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (545, 16, 380, N'GIRALDO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (546, 16, 381, N'GIRARDOT - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (547, 16, 382, N'GIRARDOTA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (548, 16, 383, N'GIRON - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (549, 16, 384, N'GOMEZ PLATA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (550, 16, 385, N'GONZALEZ - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (551, 16, 386, N'GRAMALOTE - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (552, 16, 387, N'GRANADA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (553, 16, 388, N'GRANADA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (554, 16, 389, N'GRANADA - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (555, 16, 390, N'GUACA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (556, 16, 391, N'GUACAMAYAS - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (557, 16, 392, N'GUACARI - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (558, 16, 393, N'GUACHENE - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (559, 16, 394, N'GUACHETA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (560, 16, 395, N'GUACHUCAL - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (561, 16, 396, N'GUADALAJARA DE BUGA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (562, 16, 397, N'GUADALUPE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (563, 16, 398, N'GUADALUPE - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (564, 16, 399, N'GUADALUPE - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (565, 16, 400, N'GUADUAS - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (566, 16, 401, N'GUAITARILLA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (567, 16, 402, N'GUALMATAN - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (568, 16, 403, N'GUAMAL - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (569, 16, 404, N'GUAMAL - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (570, 16, 405, N'GUAMO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (571, 16, 406, N'GUAPI - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (572, 16, 407, N'GUAPOTA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (573, 16, 408, N'GUARANDA - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (574, 16, 409, N'GUARNE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (575, 16, 410, N'GUASCA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (576, 16, 411, N'GUATAPE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (577, 16, 412, N'GUATAQUI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (578, 16, 413, N'GUATAVITA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (579, 16, 414, N'GUATEQUE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (580, 16, 415, N'GUATICA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (581, 16, 416, N'GUAVATA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (582, 16, 417, N'GUAYABAL DE SIQUIMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (583, 16, 418, N'GUAYABETAL - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (584, 16, 419, N'GUAYATA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (585, 16, 420, N'GUEPSA- SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (586, 16, 421, N'GUICAN - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (587, 16, 422, N'GUTIERREZ - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (588, 16, 423, N'HACARI - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (589, 16, 424, N'HATILLO DE LOBA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (590, 16, 425, N'HATO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (591, 16, 426, N'HATO COROZAL - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (592, 16, 427, N'HATONUEVO - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (593, 16, 428, N'HELICONIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (594, 16, 429, N'HERRAN - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (595, 16, 430, N'HERVEO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (596, 16, 431, N'HISPANIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (597, 16, 432, N'HOBO - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (598, 16, 433, N'HONDA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (599, 16, 434, N'IBAGUE - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (600, 16, 435, N'ICONONZO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (601, 16, 436, N'ILES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (602, 16, 437, N'IMUES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (603, 16, 438, N'INIRIDA - GUAINIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (604, 16, 439, N'INZA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (605, 16, 440, N'IPIALES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (606, 16, 441, N'IQUIRA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (607, 16, 442, N'ISNOS - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (608, 16, 443, N'ISTMINA - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (609, 16, 444, N'ITAGUI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (610, 16, 445, N'ITUANGO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (611, 16, 446, N'IZA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (612, 16, 447, N'JAMBALO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (613, 16, 448, N'JAMUNDI - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (614, 16, 449, N'JARDIN - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (615, 16, 450, N'JENESANO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (616, 16, 451, N'JERICO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (617, 16, 452, N'JERICO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (618, 16, 453, N'JERUSALEN - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (619, 16, 454, N'JESUS MARIA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (620, 16, 455, N'JORDAN - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (621, 16, 456, N'JUAN DE ACOSTA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (622, 16, 457, N'JUNIN - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (623, 16, 458, N'JURADO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (624, 16, 459, N'LA APARTADA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (625, 16, 460, N'LA ARGENTINA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (626, 16, 461, N'LA BELLEZA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (627, 16, 462, N'LA CALERA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (628, 16, 463, N'LA CAPILLA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (629, 16, 464, N'LA CEJA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (630, 16, 465, N'LA CELIA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (631, 16, 466, N'LA CHORRERA - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (632, 16, 467, N'LA CRUZ - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (633, 16, 468, N'LA CUMBRE - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (634, 16, 469, N'LA DORADA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (635, 16, 470, N'LA ESPERANZA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (636, 16, 471, N'LA ESTRELLA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (637, 16, 472, N'LA FLORIDA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (638, 16, 473, N'LA GLORIA - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (639, 16, 474, N'LA GUADALUPE - GUAINIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (640, 16, 475, N'LA JAGUA DE IBIRICO - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (641, 16, 476, N'LA JAGUA DEL PILAR - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (642, 16, 477, N'LA LLANADA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (643, 16, 478, N'LA MACARENA - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (644, 16, 479, N'LA MERCED - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (645, 16, 480, N'LA MESA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (646, 16, 481, N'LA MONTAÑITA - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (647, 16, 482, N'LA PALMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (648, 16, 483, N'LA PAZ - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (649, 16, 484, N'LA PAZ - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (650, 16, 485, N'LA PEDRERA - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (651, 16, 486, N'LA PEÑA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (652, 16, 487, N'LA PINTADA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (653, 16, 488, N'LA PLATA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (654, 16, 489, N'LA PLAYA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (655, 16, 490, N'LA PRIMAVERA - VICHADA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (656, 16, 491, N'LA SALINA - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (657, 16, 492, N'LA SIERRA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (658, 16, 493, N'LA TEBAIDA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (659, 16, 494, N'LA TOLA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (660, 16, 495, N'LA UNION - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (661, 16, 496, N'LA UNION - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (662, 16, 497, N'LA UNION - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (663, 16, 498, N'LA UNION - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (664, 16, 499, N'LA UVITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (665, 16, 500, N'LA VEGA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (666, 16, 501, N'LA VEGA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (667, 16, 502, N'LA VICTORIA (ANM) - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (668, 16, 503, N'LA VICTORIA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (669, 16, 504, N'LA VICTORIA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (670, 16, 505, N'LA VIRGINIA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (671, 16, 506, N'LABATECA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (672, 16, 507, N'LABRANZAGRANDE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (673, 16, 508, N'LANDAZURI - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (674, 16, 509, N'LEBRIJA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (675, 16, 510, N'LEGUIZAMO - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (676, 16, 511, N'LEIVA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (677, 16, 512, N'LEJANIAS - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (678, 16, 513, N'LENGUAZAQUE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (679, 16, 514, N'LERIDA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (680, 16, 515, N'LETICIA - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (681, 16, 516, N'LIBANO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (682, 16, 517, N'LIBORINA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (683, 16, 518, N'LINARES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (684, 16, 519, N'LLORO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (685, 16, 520, N'LOPEZ - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (686, 16, 521, N'LORICA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (687, 16, 522, N'LOS ANDES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (688, 16, 523, N'LOS CORDOBAS - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (689, 16, 524, N'LOS PALMITOS - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (690, 16, 525, N'LOS PATIOS - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (691, 16, 526, N'LOS SANTOS - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (692, 16, 527, N'LOURDES - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (693, 16, 528, N'LURUACO - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (694, 16, 529, N'MACANAL - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (695, 16, 530, N'MACARAVITA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (696, 16, 531, N'MACEO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (697, 16, 532, N'MACHETA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (698, 16, 533, N'MADRID - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (699, 16, 534, N'MAGANGUE - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (700, 16, 535, N'MAGsI - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (701, 16, 536, N'MAHATES - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (702, 16, 537, N'MAICAO - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (703, 16, 538, N'MAJAGUAL - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (704, 16, 539, N'MALAGA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (705, 16, 540, N'MALAMBO - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (706, 16, 541, N'MALLAMA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (707, 16, 542, N'MANATI - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (708, 16, 543, N'MANAURE - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (709, 16, 544, N'MANAURE - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (710, 16, 545, N'MANI - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (711, 16, 546, N'MANIZALES - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (712, 16, 547, N'MANTA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (713, 16, 548, N'MANZANARES - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (714, 16, 549, N'MAPIRIPAN - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (715, 16, 550, N'MARGARITA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (716, 16, 551, N'MARIA LA BAJA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (717, 16, 552, N'MARINILLA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (718, 16, 553, N'MARIPI - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (719, 16, 554, N'MARIQUITA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (720, 16, 555, N'MARMATO - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (721, 16, 556, N'MARQUETALIA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (722, 16, 557, N'MARSELLA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (723, 16, 558, N'MARULANDA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (724, 16, 559, N'MATANZA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (725, 16, 560, N'MEDELLIN - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (726, 16, 561, N'MEDINA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (727, 16, 562, N'MEDIO ATRATO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (728, 16, 563, N'MEDIO BAUDO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (729, 16, 564, N'MEDIO SAN JUAN - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (730, 16, 565, N'MELGAR - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (731, 16, 566, N'MERCADERES - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (732, 16, 567, N'MESETAS - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (733, 16, 568, N'MILAN - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (734, 16, 569, N'MIRAFLORES - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (735, 16, 570, N'MIRAFLORES - GUAVIARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (736, 16, 571, N'MIRANDA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (737, 16, 572, N'MIRITI - PARANA - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (738, 16, 573, N'MISTRATO - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (739, 16, 574, N'MITU - VAUPES', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (740, 16, 575, N'MOCOA - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (741, 16, 576, N'MOGOTES - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (742, 16, 577, N'MOLAGAVITA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (743, 16, 578, N'MOMIL - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (744, 16, 579, N'MOMPOS - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (745, 16, 580, N'MONGUA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (746, 16, 581, N'MONGUI - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (747, 16, 582, N'MONIQUIRA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (748, 16, 583, N'MOÑITOS - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (749, 16, 584, N'MONTEBELLO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (750, 16, 585, N'MONTECRISTO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (751, 16, 586, N'MONTELIBANO - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (752, 16, 587, N'MONTENEGRO - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (753, 16, 588, N'MONTERIA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (754, 16, 589, N'MONTERREY - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (755, 16, 590, N'MORALES - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (756, 16, 591, N'MORALES - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (757, 16, 592, N'MORELIA - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (758, 16, 593, N'MORICHAL (ANM) - GUAINIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (759, 16, 594, N'MORROA - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (760, 16, 595, N'MOSQUERA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (761, 16, 596, N'MOSQUERA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (762, 16, 597, N'MOTAVITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (763, 16, 598, N'MURILLO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (764, 16, 599, N'MURINDO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (765, 16, 600, N'MUTATA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (766, 16, 601, N'MUTISCUA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (767, 16, 602, N'MUZO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (768, 16, 603, N'NARIÑO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (769, 16, 604, N'NARIÑO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (770, 16, 605, N'NARIÑO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (771, 16, 606, N'NATAGA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (772, 16, 607, N'NATAGAIMA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (773, 16, 608, N'NECHI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (774, 16, 609, N'NECOCLI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (775, 16, 610, N'NEIRA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (776, 16, 611, N'NEIVA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (777, 16, 612, N'NEMOCON - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (778, 16, 613, N'NILO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (779, 16, 614, N'NIMAIMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (780, 16, 615, N'NOBSA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (781, 16, 616, N'NOCAIMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (782, 16, 617, N'NORCASIA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (783, 16, 618, N'NOROSI - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (784, 16, 619, N'NOVITA - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (785, 16, 620, N'NUEVA GRANADA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (786, 16, 621, N'NUEVO COLON - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (787, 16, 622, N'NUNCHIA - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (788, 16, 623, N'NUQUI - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (789, 16, 624, N'OBANDO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (790, 16, 625, N'OCAMONTE - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (791, 16, 626, N'OCAÑA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (792, 16, 627, N'OIBA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (793, 16, 628, N'OICATA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (794, 16, 629, N'OLAYA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (795, 16, 630, N'OLAYA HERRERA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (796, 16, 631, N'ONZAGA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (797, 16, 632, N'OPORAPA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (798, 16, 633, N'ORITO - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (799, 16, 634, N'OROCUE - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (800, 16, 635, N'ORTEGA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (801, 16, 636, N'OSPINA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (802, 16, 637, N'OTANCHE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (803, 16, 638, N'OVEJAS - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (804, 16, 639, N'PACHAVITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (805, 16, 640, N'PACHO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (806, 16, 641, N'PACOA- VAUPES', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (807, 16, 642, N'PACORA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (808, 16, 643, N'PADILLA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (809, 16, 644, N'PAEZ - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (810, 16, 645, N'PAEZ - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (811, 16, 646, N'PAICOL - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (812, 16, 647, N'PAILITAS - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (813, 16, 648, N'PAIME - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (814, 16, 649, N'PAIPA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (815, 16, 650, N'PAJARITO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (816, 16, 651, N'PALERMO - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (817, 16, 652, N'PALESTINA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (818, 16, 653, N'PALESTINA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (819, 16, 654, N'PALMAR - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (820, 16, 655, N'PALMAR DE VARELA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (821, 16, 656, N'PALMAS DEL SOCORRO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (822, 16, 657, N'PALMIRA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (823, 16, 658, N'PALMITO - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (824, 16, 659, N'PALOCABILDO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (825, 16, 660, N'PAMPLONA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (826, 16, 661, N'PAMPLONITA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (827, 16, 662, N'PANDI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (828, 16, 663, N'PANQUEBA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (829, 16, 664, N'PAPUNAUA - VAUPES', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (830, 16, 665, N'PARAMO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (831, 16, 666, N'PARATEBUENO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (832, 16, 667, N'PASCA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (833, 16, 668, N'PASTO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (834, 16, 669, N'PATIA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (835, 16, 670, N'PAUNA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (836, 16, 671, N'PAYA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (837, 16, 672, N'PAZ DE ARIPORO - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (838, 16, 673, N'PAZ DE RIO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (839, 16, 674, N'PEDRAZA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (840, 16, 675, N'PELAYA - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (841, 16, 676, N'PENSILVANIA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (842, 16, 677, N'PEQUE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (843, 16, 678, N'PEREIRA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (844, 16, 679, N'PESCA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (845, 16, 680, N'PEÐOL - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (846, 16, 681, N'PIAMONTE - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (847, 16, 682, N'PIEDECUESTA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (848, 16, 683, N'PIEDRAS - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (849, 16, 684, N'PIENDAMO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (850, 16, 685, N'PIJAO - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (851, 16, 686, N'PIJIÑO DEL CARMEN - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (852, 16, 687, N'PINCHOTE - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (853, 16, 688, N'PINILLOS - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (854, 16, 689, N'PIOJO - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (855, 16, 690, N'PISBA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (856, 16, 691, N'PITAL - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (857, 16, 692, N'PITALITO - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (858, 16, 693, N'PIVIJAY - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (859, 16, 694, N'PLANADAS - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (860, 16, 695, N'PLANETA RICA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (861, 16, 696, N'PLATO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (862, 16, 697, N'POLICARPA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (863, 16, 698, N'POLONUEVO - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (864, 16, 699, N'PONEDERA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (865, 16, 700, N'POPAYAN - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (866, 16, 701, N'PORE - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (867, 16, 702, N'POTOSI - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (868, 16, 703, N'PRADERA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (869, 16, 704, N'PRADO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (870, 16, 705, N'PROVIDENCIA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (871, 16, 706, N'PROVIDENCIA - SAN ANDRES', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (872, 16, 707, N'PUEBLO BELLO - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (873, 16, 708, N'PUEBLO NUEVO - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (874, 16, 709, N'PUEBLO RICO - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (875, 16, 710, N'PUEBLORRICO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (876, 16, 711, N'PUEBLOVIEJO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (877, 16, 712, N'PUENTE NACIONAL - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (878, 16, 713, N'PUERRES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (879, 16, 714, N'PUERTO ALEGRIA - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (880, 16, 715, N'PUERTO ARICA - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (881, 16, 716, N'PUERTO ASIS - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (882, 16, 717, N'PUERTO BERRIO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (883, 16, 718, N'PUERTO BOYACA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (884, 16, 719, N'PUERTO CAICEDO - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (885, 16, 720, N'PUERTO CARREÑO - VICHADA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (886, 16, 721, N'PUERTO COLOMBIA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (887, 16, 722, N'PUERTO COLOMBIA - GUAINIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (888, 16, 723, N'PUERTO CONCORDIA - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (889, 16, 724, N'PUERTO ESCONDIDO - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (890, 16, 725, N'PUERTO GAITAN - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (891, 16, 726, N'PUERTO GUZMAN - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (892, 16, 727, N'PUERTO LIBERTADOR - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (893, 16, 728, N'PUERTO LLERAS - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (894, 16, 729, N'PUERTO LOPEZ - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (895, 16, 730, N'PUERTO NARE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (896, 16, 731, N'PUERTO NARIÑO - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (897, 16, 732, N'PUERTO PARRA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (898, 16, 733, N'PUERTO RICO - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (899, 16, 734, N'PUERTO RICO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (900, 16, 735, N'PUERTO RONDON - ARAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (901, 16, 736, N'PUERTO SALGAR - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (902, 16, 737, N'PUERTO SANTANDER - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (903, 16, 738, N'PUERTO SANTANDER - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (904, 16, 739, N'PUERTO TEJADA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (905, 16, 740, N'PUERTO TRIUNFO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (906, 16, 741, N'PUERTO WILCHES - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (907, 16, 742, N'PULI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (908, 16, 743, N'PUPIALES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (909, 16, 744, N'PURACE - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (910, 16, 745, N'PURIFICACION - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (911, 16, 746, N'PURISIMA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (912, 16, 747, N'QUEBRADANEGRA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (913, 16, 748, N'QUETAME - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (914, 16, 749, N'QUIBDO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (915, 16, 750, N'QUIMBAYA - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (916, 16, 751, N'QUINCHIA - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (917, 16, 752, N'QUIPAMA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (918, 16, 753, N'QUIPILE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (919, 16, 754, N'RAGONVALIA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (920, 16, 755, N'RAMIRIQUI - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (921, 16, 756, N'RAQUIRA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (922, 16, 757, N'RECETOR - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (923, 16, 758, N'REGIDOR - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (924, 16, 759, N'REMEDIOS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (925, 16, 760, N'REMOLINO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (926, 16, 761, N'REPELON - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (927, 16, 762, N'RESTREPO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (928, 16, 763, N'RESTREPO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (929, 16, 764, N'RETIRO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (930, 16, 765, N'RICAURTE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (931, 16, 766, N'RICAURTE - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (932, 16, 767, N'RIO DE ORO - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (933, 16, 768, N'RIO IRO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (934, 16, 769, N'RIO QUITO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (935, 16, 770, N'RIO VIEJO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (936, 16, 771, N'RIOBLANCO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (937, 16, 772, N'RIOFRIO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (938, 16, 773, N'RIOHACHA - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (939, 16, 774, N'RIONEGRO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (940, 16, 775, N'RIONEGRO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (941, 16, 776, N'RIOSUCIO - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (942, 16, 777, N'RIOSUCIO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (943, 16, 778, N'RISARALDA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (944, 16, 779, N'RIVERA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (945, 16, 780, N'ROBERTO PAYAN - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (946, 16, 781, N'ROLDANILLO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (947, 16, 782, N'RONCESVALLES - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (948, 16, 783, N'RONDON - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (949, 16, 784, N'ROSAS - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (950, 16, 785, N'ROVIRA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (951, 16, 786, N'SABANA DE TORRES - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (952, 16, 787, N'SABANAGRANDE - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (953, 16, 788, N'SABANALARGA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (954, 16, 789, N'SABANALARGA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (955, 16, 790, N'SABANALARGA - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (956, 16, 791, N'SABANAS DE SAN ANGEL - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (957, 16, 792, N'SABANETA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (958, 16, 793, N'SABOYA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (959, 16, 794, N'SACAMA - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (960, 16, 795, N'SACHICA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (961, 16, 796, N'SAHAGUN - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (962, 16, 797, N'SALADOBLANCO - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (963, 16, 798, N'SALAMINA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (964, 16, 799, N'SALAMINA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (965, 16, 800, N'SALAZAR - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (966, 16, 801, N'SALDAÑA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (967, 16, 802, N'SALENTO - QUINDIO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (968, 16, 803, N'SALGAR - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (969, 16, 804, N'SAMACA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (970, 16, 805, N'SAMANA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (971, 16, 806, N'SAMANIEGO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (972, 16, 807, N'SAMPUES - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (973, 16, 808, N'SAN AGUSTIN - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (974, 16, 809, N'SAN ALBERTO - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (975, 16, 810, N'SAN ANDRES - SAN ANDRES', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (976, 16, 811, N'SAN ANDRES - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (977, 16, 812, N'SAN ANDRES DE CUERQUIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (978, 16, 813, N'SAN ANDRES DE TUMACO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (979, 16, 814, N'SAN ANDRES SOTAVENTO - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (980, 16, 815, N'SAN ANTERO - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (981, 16, 816, N'SAN ANTONIO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (982, 16, 817, N'SAN ANTONIO DEL TEQUENDAMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (983, 16, 818, N'SAN BENITO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (984, 16, 819, N'SAN BENITO ABAD - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (985, 16, 820, N'SAN BERNARDO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (986, 16, 821, N'SAN BERNARDO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (987, 16, 822, N'SAN BERNARDO DEL VIENTO - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (988, 16, 823, N'SAN CALIXTO - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (989, 16, 824, N'SAN CARLOS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (990, 16, 825, N'SAN CARLOS - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (991, 16, 826, N'SAN CARLOS DE GUAROA - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (992, 16, 827, N'SAN CAYETANO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (993, 16, 828, N'SAN CAYETANO - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (994, 16, 829, N'SAN CRISTOBAL - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (995, 16, 830, N'SAN DIEGO - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (996, 16, 831, N'SAN EDUARDO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (997, 16, 832, N'SAN ESTANISLAO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (998, 16, 833, N'SAN FELIPE - GUAINIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (999, 16, 834, N'SAN FERNANDO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1000, 16, 835, N'SAN FRANCISCO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1001, 16, 836, N'SAN FRANCISCO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1002, 16, 837, N'SAN FRANCISCO - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1003, 16, 838, N'SAN GIL - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1004, 16, 839, N'SAN JACINTO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1005, 16, 840, N'SAN JACINTO DEL CAUCA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1006, 16, 841, N'SAN JERONIMO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1007, 16, 842, N'SAN JOAQUIN - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1008, 16, 843, N'SAN JOSE - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1009, 16, 844, N'SAN JOSE DE LA MONTAÑA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1010, 16, 845, N'SAN JOSE DE MIRANDA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1011, 16, 846, N'SAN JOSE DE PARE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1012, 16, 847, N'SAN JOSE DE URE - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1013, 16, 848, N'SAN JOSE DEL FRAGUA - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1014, 16, 849, N'SAN JOSE DEL GUAVIARE - GUAVIARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1015, 16, 850, N'SAN JOSE DEL PALMAR - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1016, 16, 851, N'SAN JUAN DE ARAMA - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1017, 16, 852, N'SAN JUAN DE BETULIA - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1018, 16, 853, N'SAN JUAN DE RIO SECO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1019, 16, 854, N'SAN JUAN DE URABA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1020, 16, 855, N'SAN JUAN DEL CESAR - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1021, 16, 856, N'SAN JUAN NEPOMUCENO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1022, 16, 857, N'SAN JUANITO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1023, 16, 858, N'SAN LORENZO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1024, 16, 859, N'SAN LUIS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1025, 16, 860, N'SAN LUIS - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1026, 16, 861, N'SAN LUIS DE GACENO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1027, 16, 862, N'SAN LUIS DE PALENQUE - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1028, 16, 863, N'SAN LUIS DE SINCE - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1029, 16, 864, N'SAN MARCOS - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1030, 16, 865, N'SAN MARTIN - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1031, 16, 866, N'SAN MARTIN - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1032, 16, 867, N'SAN MARTIN DE LOBA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1033, 16, 868, N'SAN MATEO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1034, 16, 869, N'SAN MIGUEL - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1035, 16, 870, N'SAN MIGUEL - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1036, 16, 871, N'SAN MIGUEL DE SEMA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1037, 16, 872, N'SAN ONOFRE - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1038, 16, 873, N'SAN PABLO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1039, 16, 874, N'SAN PABLO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1040, 16, 875, N'SAN PABLO DE BORBUR - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1041, 16, 876, N'SAN PEDRO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1042, 16, 877, N'SAN PEDRO - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1043, 16, 878, N'SAN PEDRO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1044, 16, 879, N'SAN PEDRO DE CARTAGO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1045, 16, 880, N'SAN PEDRO DE URABA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1046, 16, 881, N'SAN PELAYO - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1047, 16, 882, N'SAN RAFAEL - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1048, 16, 883, N'SAN ROQUE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1049, 16, 884, N'SAN SEBASTIAN - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1050, 16, 885, N'SAN SEBASTIAN DE BUENAVISTA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1051, 16, 886, N'SAN VICENTE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1052, 16, 887, N'SAN VICENTE DE CHUCURI - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1053, 16, 888, N'SAN VICENTE DEL CAGUAN - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1054, 16, 889, N'SAN ZENON - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1055, 16, 890, N'SANDONA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1056, 16, 891, N'SANTA ANA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1057, 16, 892, N'SANTA BARBARA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1058, 16, 893, N'SANTA BARBARA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1059, 16, 894, N'SANTA BARBARA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1060, 16, 895, N'SANTA BARBARA DE PINTO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1061, 16, 896, N'SANTA CATALINA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1062, 16, 897, N'SANTA HELENA DEL OPON - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1063, 16, 898, N'SANTA ISABEL - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1064, 16, 899, N'SANTA LUCIA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1065, 16, 900, N'SANTA MARIA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1066, 16, 901, N'SANTA MARIA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1067, 16, 902, N'SANTA MARTA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1068, 16, 903, N'SANTA ROSA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1069, 16, 904, N'SANTA ROSA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1070, 16, 905, N'SANTA ROSA DE CABAL - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1071, 16, 906, N'SANTA ROSA DE OSOS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1072, 16, 907, N'SANTA ROSA DE VITERBO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1073, 16, 908, N'SANTA ROSA DEL SUR - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1074, 16, 909, N'SANTA ROSALIA - VICHADA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1075, 16, 910, N'SANTA SOFIA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1076, 16, 911, N'SANTACRUZ - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1077, 16, 912, N'SANTAFE DE ANTIOQUIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1078, 16, 913, N'SANTANA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1079, 16, 914, N'SANTANDER DE QUILICHAO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1080, 16, 915, N'SANTIAGO - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1081, 16, 916, N'SANTIAGO - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1082, 16, 917, N'SANTIAGO DE TOLU - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1083, 16, 918, N'SANTO DOMINGO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1084, 16, 919, N'SANTO TOMAS - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1085, 16, 920, N'SANTUARIO - RISARALDA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1086, 16, 921, N'SAPUYES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1087, 16, 922, N'SARAVENA - ARAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1088, 16, 923, N'SARDINATA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1089, 16, 924, N'SASAIMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1090, 16, 925, N'SATIVANORTE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1091, 16, 926, N'SATIVASUR - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1092, 16, 927, N'SEGOVIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1093, 16, 928, N'SESQUILE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1094, 16, 929, N'SEVILLA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1095, 16, 930, N'SIACHOQUE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1096, 16, 931, N'SIBATE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1097, 16, 932, N'SIBUNDOY - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1098, 16, 933, N'SILOS - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1099, 16, 934, N'SILVANIA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1100, 16, 935, N'SILVIA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1101, 16, 936, N'SIMACOTA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1102, 16, 937, N'SIMIJACA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1103, 16, 938, N'SIMITI - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1104, 16, 939, N'SINCELEJO - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1105, 16, 940, N'SIPI - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1106, 16, 941, N'SITIONUEVO - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1107, 16, 942, N'SOACHA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1108, 16, 943, N'SOATA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1109, 16, 944, N'SOCHA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1110, 16, 945, N'SOCORRO - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1111, 16, 946, N'SOCOTA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1112, 16, 947, N'SOGAMOSO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1113, 16, 948, N'SOLANO - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1114, 16, 949, N'SOLEDAD - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1115, 16, 950, N'SOLITA - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1116, 16, 951, N'SOMONDOCO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1117, 16, 952, N'SONSON - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1118, 16, 953, N'SOPETRAN - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1119, 16, 954, N'SOPLAVIENTO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1120, 16, 955, N'SOPO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1121, 16, 956, N'SORA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1122, 16, 957, N'SORACA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1123, 16, 958, N'SOTAQUIRA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1124, 16, 959, N'SOTARA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1125, 16, 960, N'SUAITA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1126, 16, 961, N'SUAN - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1127, 16, 962, N'SUAREZ - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1128, 16, 963, N'SUAREZ - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1129, 16, 964, N'SUAZA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1130, 16, 965, N'SUBACHOQUE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1131, 16, 966, N'SUCRE - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1132, 16, 967, N'SUCRE - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1133, 16, 968, N'SUCRE - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1134, 16, 969, N'SUESCA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1135, 16, 970, N'SUPATA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1136, 16, 971, N'SUPIA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1137, 16, 972, N'SURATA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1138, 16, 973, N'SUSA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1139, 16, 974, N'SUSACON - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1140, 16, 975, N'SUTAMARCHAN - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1141, 16, 976, N'SUTATAUSA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1142, 16, 977, N'SUTATENZA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1143, 16, 978, N'TABIO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1144, 16, 979, N'TADO - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1145, 16, 980, N'TALAIGUA NUEVO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1146, 16, 981, N'TAMALAMEQUE - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1147, 16, 982, N'TAMARA - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1148, 16, 983, N'TAME - ARAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1149, 16, 984, N'TAMESIS - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1150, 16, 985, N'TAMINANGO - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1151, 16, 986, N'TANGUA - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1152, 16, 987, N'TARAIRA - VAUPES', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1153, 16, 988, N'TARAPACA - AMAZONAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1154, 16, 989, N'TARAZA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1155, 16, 990, N'TARQUI - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1156, 16, 991, N'TARSO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1157, 16, 992, N'TASCO - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1158, 16, 993, N'TAURAMENA - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1159, 16, 994, N'TAUSA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1160, 16, 995, N'TELLO - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1161, 16, 996, N'TENA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1162, 16, 997, N'TENERIFE - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1163, 16, 998, N'TENJO - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1164, 16, 999, N'TENZA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1165, 16, 1000, N'TEORAMA - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1166, 16, 1001, N'TERUEL - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1167, 16, 1002, N'TESALIA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1168, 16, 1003, N'TIBACUY - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1169, 16, 1004, N'TIBANA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1170, 16, 1005, N'TIBASOSA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1171, 16, 1006, N'TIBIRITA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1172, 16, 1007, N'TIBU - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1173, 16, 1008, N'TIERRALTA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1174, 16, 1009, N'TIMANA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1175, 16, 1010, N'TIMBIO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1176, 16, 1011, N'TIMBIQUI - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1177, 16, 1012, N'TINJACA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1178, 16, 1013, N'TIPACOQUE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1179, 16, 1014, N'TIQUISIO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1180, 16, 1015, N'TITIRIBI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1181, 16, 1016, N'TOCA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1182, 16, 1017, N'TOCAIMA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1183, 16, 1018, N'TOCANCIPA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1184, 16, 1019, N'TOGsI - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1185, 16, 1020, N'TOLEDO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1186, 16, 1021, N'TOLEDO - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1187, 16, 1022, N'TOLU VIEJO - SUCRE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1188, 16, 1023, N'TONA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1189, 16, 1024, N'TOPAGA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1190, 16, 1025, N'TOPAIPI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1191, 16, 1026, N'TORIBIO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1192, 16, 1027, N'TORO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1193, 16, 1028, N'TOTA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1194, 16, 1029, N'TOTORO - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1195, 16, 1030, N'TRINIDAD - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1196, 16, 1031, N'TRUJILLO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1197, 16, 1032, N'TUBARA - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1198, 16, 1033, N'TUCHIN- CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1199, 16, 1034, N'TULUA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1200, 16, 1035, N'TUNJA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1201, 16, 1036, N'TUNUNGUA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1202, 16, 1037, N'TUQUERRES - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1203, 16, 1038, N'TURBACO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1204, 16, 1039, N'TURBANA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1205, 16, 1040, N'TURBO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1206, 16, 1041, N'TURMEQUE - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1207, 16, 1042, N'TUTA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1208, 16, 1043, N'TUTAZA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1209, 16, 1044, N'UBALA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
GO
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1210, 16, 1045, N'UBAQUE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1211, 16, 1046, N'ULLOA - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1212, 16, 1047, N'UMBITA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1213, 16, 1048, N'UNE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1214, 16, 1049, N'UNGUIA - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1215, 16, 1050, N'UNION PANAMERICANA - CHOCO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1216, 16, 1051, N'URAMITA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1217, 16, 1052, N'URIBE - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1218, 16, 1053, N'URIBIA - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1219, 16, 1054, N'URRAO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1220, 16, 1055, N'URUMITA - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1221, 16, 1056, N'USIACURI - ATLANTICO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1222, 16, 1057, N'UTICA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1223, 16, 1058, N'VALDIVIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1224, 16, 1059, N'VALENCIA - CORDOBA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1225, 16, 1060, N'VALLE DE SAN JOSE - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1226, 16, 1061, N'VALLE DE SAN JUAN - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1227, 16, 1062, N'VALLE DEL GUAMUEZ - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1228, 16, 1063, N'VALLEDUPAR - CESAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1229, 16, 1064, N'VALPARAISO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1230, 16, 1065, N'VALPARAISO - CAQUETA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1231, 16, 1066, N'VEGACHI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1232, 16, 1067, N'VELEZ - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1233, 16, 1068, N'VENADILLO - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1234, 16, 1069, N'VENECIA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1235, 16, 1070, N'VENECIA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1236, 16, 1071, N'VENTAQUEMADA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1237, 16, 1072, N'VERGARA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1238, 16, 1073, N'VERSALLES - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1239, 16, 1074, N'VETAS - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1240, 16, 1075, N'VIANI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1241, 16, 1076, N'VICTORIA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1242, 16, 1077, N'VIGIA DEL FUERTE - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1243, 16, 1078, N'VIJES - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1244, 16, 1079, N'VILLA CARO - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1245, 16, 1080, N'VILLA DE LEYVA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1246, 16, 1081, N'VILLA DE SAN DIEGO DE UBATE - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1247, 16, 1082, N'VILLA DEL ROSARIO - N. DE SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1248, 16, 1083, N'VILLA RICA - CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1249, 16, 1084, N'VILLAGARZON - PUTUMAYO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1250, 16, 1085, N'VILLAGOMEZ - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1251, 16, 1086, N'VILLAHERMOSA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1252, 16, 1087, N'VILLAMARIA - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1253, 16, 1088, N'VILLANUEVA - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1254, 16, 1089, N'VILLANUEVA - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1255, 16, 1090, N'VILLANUEVA - LA GUAJIRA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1256, 16, 1091, N'VILLANUEVA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1257, 16, 1092, N'VILLAPINZON - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1258, 16, 1093, N'VILLARRICA - TOLIMA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1259, 16, 1094, N'VILLAVICENCIO - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1260, 16, 1095, N'VILLAVIEJA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1261, 16, 1096, N'VILLETA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1262, 16, 1097, N'VIOTA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1263, 16, 1098, N'VIRACACHA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1264, 16, 1099, N'VISTAHERMOSA - META', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1265, 16, 1100, N'VITERBO - CALDAS', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1266, 16, 1101, N'YACOPI - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1267, 16, 1102, N'YACUANQUER - NARIÑO', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1268, 16, 1103, N'YAGUARA - HUILA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1269, 16, 1104, N'YALI - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1270, 16, 1105, N'YARUMAL - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1271, 16, 1106, N'YAVARATE - VAUPES', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1272, 16, 1107, N'YOLOMBO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1273, 16, 1108, N'YONDO - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1274, 16, 1109, N'YOPAL - CASANARE', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1275, 16, 1110, N'YOTOCO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1276, 16, 1111, N'YUMBO - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1277, 16, 1112, N'ZAMBRANO - BOLIVAR', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1278, 16, 1113, N'ZAPATOCA - SANTANDER', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1279, 16, 1114, N'ZAPAYAN - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1280, 16, 1115, N'ZARAGOZA - ANTIOQUIA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1281, 16, 1116, N'ZARZAL - VALLE DEL CAUCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1282, 16, 1117, N'ZETAQUIRA - BOYACA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1283, 16, 1118, N'ZIPACON - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1284, 16, 1119, N'ZIPAQUIRA - CUNDINAMARCA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1285, 16, 1120, N'ZONA BANANERA - MAGDALENA', CAST(N'2023-11-03 10:28:43.480' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1286, 18, 1, N'Delegatura para Conglomerados Financieros', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1287, 18, 2, N'Delegatura para Intermediarios Financieros', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1289, 18, 3, N'Delegatura para Emisores', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1291, 18, 4, N'Delegatura para Seguros', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1292, 18, 5, N'Delegatura para Pensiones', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1294, 18, 6, N'Delegatura para Fiduciarias', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1295, 18, 7, N'Delegatura para Intermediarios de Valores', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1299, 17, 10, N'Aseguradora tipo 1', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1302, 17, 11, N'Aseguradora tipo 2', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1303, 17, 13, N'Aseguradora tipo 3', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1305, 17, 14, N'Aseguradora tipo 4', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1306, 17, 15, N'Aseguradora tipo 5', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
INSERT [bpapp].[Dominios] ([idDominioGen], [idDominio], [idCodigo], [Descripcion], [Fecha], [Estado]) VALUES (1307, 17, 27, N'Aseguradora tipo 6', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0)
SET IDENTITY_INSERT [bpapp].[Dominios] OFF
INSERT [bpapp].[Estados] ([idEstado], [Descripcion]) VALUES (0, N'Inactivo')
INSERT [bpapp].[Estados] ([idEstado], [Descripcion]) VALUES (1, N'Pendiente Envio')
INSERT [bpapp].[Estados] ([idEstado], [Descripcion]) VALUES (2, N'Enviado')
INSERT [bpapp].[Estados] ([idEstado], [Descripcion]) VALUES (3, N'Actualizado')
INSERT [bpapp].[Estados] ([idEstado], [Descripcion]) VALUES (4, N'Nuevo Detalle')
SET IDENTITY_INSERT [bpapp].[Menu] ON 

INSERT [bpapp].[Menu] ([IdMenu], [Nombre], [Icono], [Activo], [FechaRegistro]) VALUES (1, N'USUARIOS', N' ', 1, CAST(N'2023-11-06 22:22:02.043' AS DateTime))
INSERT [bpapp].[Menu] ([IdMenu], [Nombre], [Icono], [Activo], [FechaRegistro]) VALUES (2, N'FORMATO 424', N' ', 1, CAST(N'2023-11-06 22:22:02.043' AS DateTime))
INSERT [bpapp].[Menu] ([IdMenu], [Nombre], [Icono], [Activo], [FechaRegistro]) VALUES (3, N'FORMATO 425', N' ', 1, CAST(N'2023-11-06 22:22:02.043' AS DateTime))
INSERT [bpapp].[Menu] ([IdMenu], [Nombre], [Icono], [Activo], [FechaRegistro]) VALUES (4, N'FORMATO 426', N' ', 1, CAST(N'2023-11-06 22:22:02.043' AS DateTime))
SET IDENTITY_INSERT [bpapp].[Menu] OFF
SET IDENTITY_INSERT [bpapp].[Permisos] ON 

INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (1, 1, 1, 1, CAST(N'2023-11-06 22:22:02.113' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (2, 1, 2, 1, CAST(N'2023-11-06 22:22:02.113' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (3, 1, 3, 1, CAST(N'2023-11-06 22:22:02.113' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (4, 1, 4, 1, CAST(N'2023-11-06 22:22:02.113' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (5, 1, 5, 1, CAST(N'2023-11-06 22:22:02.113' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (6, 1, 6, 1, CAST(N'2023-11-06 22:22:02.113' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (64, 6, 1, 0, CAST(N'2023-11-10 11:40:12.690' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (65, 6, 2, 0, CAST(N'2023-11-10 11:40:12.690' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (66, 6, 3, 0, CAST(N'2023-11-10 11:40:12.690' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (67, 6, 4, 0, CAST(N'2023-11-10 11:40:12.690' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (68, 6, 5, 0, CAST(N'2023-11-10 11:40:12.690' AS DateTime))
INSERT [bpapp].[Permisos] ([IdPermisos], [IdRol], [IdSubMenu], [Activo], [FechaRegistro]) VALUES (69, 6, 6, 0, CAST(N'2023-11-10 11:40:12.690' AS DateTime))
SET IDENTITY_INSERT [bpapp].[Permisos] OFF
SET IDENTITY_INSERT [bpapp].[ProductoCredito] ON 

INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (1, N'Crédito vehículo, modalidad consumo, con prenda
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (2, N'Crédito vehículo, modalidad consumo, sin garantía
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (3, N'Crédito libre inversión, modalidad consumo, garantía idónea
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (4, N'Crédito libre inversión, modalidad consumo, garantía no idónea
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (5, N'Crédito libre inversión, modalidad consumo, sin garantía
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (6, N'Crédito de vivienda, garantía hipotecaria VIS en pesos
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (7, N'Crédito de vivienda, garantía hipotecaria VIS en UVR
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (8, N'Crédito de vivienda, garantía hipotecaria no VIS en pesos
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (9, N'Leasing habitacional no VIS en pesos
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (10, N'Microcrédito, garantía del FAG
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (11, N'Microcrédito, garantía del FNG
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (12, N'Microcrédito, garantía no idónea
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (13, N'Microcrédito, sin garantía
')
INSERT [bpapp].[ProductoCredito] ([idProducto], [Descripcion]) VALUES (14, N'Crédito de consumo bajo monto, sin garantía
')
SET IDENTITY_INSERT [bpapp].[ProductoCredito] OFF
SET IDENTITY_INSERT [bpapp].[PropiedadesCreditos] ON 

INSERT [bpapp].[PropiedadesCreditos] ([idPropiedadesFormato], [Tipo], [Codigo], [Nombre], [idCodigoCredito], [idAperturaDigital], [Fecha_horaActualizacion], [Usuario], [Estado], [Fechacorte], [FechaEstado], [CodigoRegistro], [idPropiedadesFormatoAnterior]) VALUES (1, 1, N'00057', N'BCOPICHINCH
', 2, 2, CAST(N'2023-05-31 00:00:00.000' AS DateTime), N'Admin', 1, CAST(N'2023-05-31 00:00:00.000' AS DateTime), CAST(N'2023-05-31 00:00:00.000' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [bpapp].[PropiedadesCreditos] OFF
SET IDENTITY_INSERT [bpapp].[Rol] ON 

INSERT [bpapp].[Rol] ([IdRol], [Descripcion], [Activo], [FechaRegistro]) VALUES (1, N'ADMINISTRADOR', 1, CAST(N'2023-11-06 22:22:02.030' AS DateTime))
INSERT [bpapp].[Rol] ([IdRol], [Descripcion], [Activo], [FechaRegistro]) VALUES (6, N'USUARIO', 1, CAST(N'2023-11-10 11:40:12.690' AS DateTime))
SET IDENTITY_INSERT [bpapp].[Rol] OFF
SET IDENTITY_INSERT [bpapp].[Submenu] ON 

INSERT [bpapp].[Submenu] ([IdSubMenu], [IdMenu], [Nombre], [NombreFormulario], [Accion], [Activo], [FechaRegistro]) VALUES (1, 1, N'Crear Usuario', N'Usuario', N'Crear', 1, CAST(N'2023-11-06 22:22:02.097' AS DateTime))
INSERT [bpapp].[Submenu] ([IdSubMenu], [IdMenu], [Nombre], [NombreFormulario], [Accion], [Activo], [FechaRegistro]) VALUES (2, 1, N'Crear Rol', N'Rol', N'Crear', 1, CAST(N'2023-11-06 22:22:02.097' AS DateTime))
INSERT [bpapp].[Submenu] ([IdSubMenu], [IdMenu], [Nombre], [NombreFormulario], [Accion], [Activo], [FechaRegistro]) VALUES (3, 1, N'Asignar rol permisos', N'RolPermiso', N'Crear', 1, CAST(N'2023-11-06 22:22:02.097' AS DateTime))
INSERT [bpapp].[Submenu] ([IdSubMenu], [IdMenu], [Nombre], [NombreFormulario], [Accion], [Activo], [FechaRegistro]) VALUES (4, 2, N'Crear Registro Formato 424', N'Formato424', N'Crear', 1, CAST(N'2023-11-06 22:22:02.097' AS DateTime))
INSERT [bpapp].[Submenu] ([IdSubMenu], [IdMenu], [Nombre], [NombreFormulario], [Accion], [Activo], [FechaRegistro]) VALUES (5, 3, N'Crear Registro Formato 425', N'Formato425', N'Crear', 1, CAST(N'2023-11-06 22:22:02.097' AS DateTime))
INSERT [bpapp].[Submenu] ([IdSubMenu], [IdMenu], [Nombre], [NombreFormulario], [Accion], [Activo], [FechaRegistro]) VALUES (6, 4, N'Crear Registro Formato 426', N'Formato426', N'Crear', 1, CAST(N'2023-11-06 22:22:02.097' AS DateTime))
SET IDENTITY_INSERT [bpapp].[Submenu] OFF
SET IDENTITY_INSERT [bpapp].[TiposDominio] ON 

INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (1, N'Tipo de producto de depósito', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idTipoProductoDeposito')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (2, N'Apertura digital', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idAperturaDigital')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (3, N'Grupo poblacional objetivo', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idGrupoPoblacional')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (4, N'Ingresos', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idIngresos')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (5, N'Observaciones cuota manejo F424', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idObservacionesCuota')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (6, N'Servicio gratuito F424', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idSerGratuito_todas424')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (7, N'Franquicia', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idFranquicia')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (8, N'Cupo', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idCupo')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (9, N'Servicio gratuito F425', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idServicioGratuito_todas425')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (10, N'Operación servicio F424', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idOperacionServicio')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (11, N'Observaciones F424', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idObservaciones')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (12, N'Operación servicio F425', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idOperacionServicio')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (13, N'Observaciones 425', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idObservaciones')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (14, N'Observaciones 426', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idObservaciones')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (15, N'Operación servicio F426', CAST(N'2023-11-01 00:00:00.000' AS DateTime), 0, N'idCaracteristicaCredito')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (16, N'Ciudades', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0, N'idciudad')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (17, N'Tipo aseguradora', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0, N'Tipo')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (18, N'Delegaturas', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0, N'IdDelegatura')
INSERT [bpapp].[TiposDominio] ([idDominio], [Descripcion], [Fecha], [Estado], [Columna]) VALUES (19, N'', CAST(N'2023-11-03 00:00:00.000' AS DateTime), 0, NULL)
SET IDENTITY_INSERT [bpapp].[TiposDominio] OFF
SET IDENTITY_INSERT [bpapp].[Usuario] ON 

INSERT [bpapp].[Usuario] ([IdUsuario], [Nombres], [Apellidos], [IdRol], [LoginUsuario], [LoginClave], [DescripcionReferencia], [IdReferencia], [Activo], [FechaRegistro]) VALUES (1, N'Jair', N'Gazcon', 1, N'Admin', N'Admin123', N'NINGUNA', 0, 1, CAST(N'2023-11-06 22:22:02.110' AS DateTime))
INSERT [bpapp].[Usuario] ([IdUsuario], [Nombres], [Apellidos], [IdRol], [LoginUsuario], [LoginClave], [DescripcionReferencia], [IdReferencia], [Activo], [FechaRegistro]) VALUES (2, N'Pedro', N'Gonzales', 1, N'Pedro', N'Pedro123', N'NINGUNA', 0, 1, CAST(N'2023-11-09 10:41:05.367' AS DateTime))
INSERT [bpapp].[Usuario] ([IdUsuario], [Nombres], [Apellidos], [IdRol], [LoginUsuario], [LoginClave], [DescripcionReferencia], [IdReferencia], [Activo], [FechaRegistro]) VALUES (3, N'asdff', N'dfgd', 1, N'dfdf', N'4453', N'NINGUNA', 0, 1, CAST(N'2023-11-14 17:01:40.897' AS DateTime))
INSERT [bpapp].[Usuario] ([IdUsuario], [Nombres], [Apellidos], [IdRol], [LoginUsuario], [LoginClave], [DescripcionReferencia], [IdReferencia], [Activo], [FechaRegistro]) VALUES (4, N'dfgdg', N'dfgdfgdf', 1, N'34534', N'455', N'NINGUNA', 0, 1, CAST(N'2023-11-14 17:08:04.683' AS DateTime))
INSERT [bpapp].[Usuario] ([IdUsuario], [Nombres], [Apellidos], [IdRol], [LoginUsuario], [LoginClave], [DescripcionReferencia], [IdReferencia], [Activo], [FechaRegistro]) VALUES (5, N'fwef', N'dsfsf', 1, N'23424', N'34434', N'NINGUNA', 0, 1, CAST(N'2023-11-14 18:15:03.433' AS DateTime))
SET IDENTITY_INSERT [bpapp].[Usuario] OFF
/****** Object:  Index [UQ_Dominios_Generales]    Script Date: 15/11/2023 6:21:40 p. m. ******/
ALTER TABLE [bpapp].[Dominios] ADD  CONSTRAINT [UQ_Dominios_Generales] UNIQUE NONCLUSTERED 
(
	[idDominio] ASC,
	[idCodigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bpapp].[Menu] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [bpapp].[Menu] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [bpapp].[Permisos] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [bpapp].[Permisos] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [bpapp].[Rol] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [bpapp].[Rol] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [bpapp].[Submenu] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [bpapp].[Submenu] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [bpapp].[Usuario] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [bpapp].[Usuario] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [bpapp].[Creditos]  WITH CHECK ADD  CONSTRAINT [FK_Creditos_ProductoCredito] FOREIGN KEY([idProducto])
REFERENCES [bpapp].[ProductoCredito] ([idProducto])
GO
ALTER TABLE [bpapp].[Creditos] CHECK CONSTRAINT [FK_Creditos_ProductoCredito]
GO
ALTER TABLE [bpapp].[DetalleCreditos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Creditos_Dominios] FOREIGN KEY([idCaracteristicaCredito])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleCreditos] CHECK CONSTRAINT [FK_Detalle_Creditos_Dominios]
GO
ALTER TABLE [bpapp].[DetalleCreditos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Creditos_Dominios1] FOREIGN KEY([idObservaciones])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleCreditos] CHECK CONSTRAINT [FK_Detalle_Creditos_Dominios1]
GO
ALTER TABLE [bpapp].[DetalleCreditos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Creditos_Propiedades_Creditos] FOREIGN KEY([idPropiedadesFormato])
REFERENCES [bpapp].[PropiedadesCreditos] ([idPropiedadesFormato])
GO
ALTER TABLE [bpapp].[DetalleCreditos] CHECK CONSTRAINT [FK_Detalle_Creditos_Propiedades_Creditos]
GO
ALTER TABLE [bpapp].[DetalleDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Depositos_Canal] FOREIGN KEY([idCanal])
REFERENCES [bpapp].[Canal] ([idCodigo])
GO
ALTER TABLE [bpapp].[DetalleDepositos] CHECK CONSTRAINT [FK_Detalle_Depositos_Canal]
GO
ALTER TABLE [bpapp].[DetalleDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Depositos_Dominios] FOREIGN KEY([idOperacionServicio])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleDepositos] CHECK CONSTRAINT [FK_Detalle_Depositos_Dominios]
GO
ALTER TABLE [bpapp].[DetalleDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Depositos_Dominios1] FOREIGN KEY([idCanal])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleDepositos] CHECK CONSTRAINT [FK_Detalle_Depositos_Dominios1]
GO
ALTER TABLE [bpapp].[DetalleDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Depositos_Dominios2] FOREIGN KEY([idObservaciones])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleDepositos] CHECK CONSTRAINT [FK_Detalle_Depositos_Dominios2]
GO
ALTER TABLE [bpapp].[DetalleDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Depositos_Dominios3] FOREIGN KEY([idOperacionServicio])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleDepositos] CHECK CONSTRAINT [FK_Detalle_Depositos_Dominios3]
GO
ALTER TABLE [bpapp].[DetalleDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Depositos_Dominios4] FOREIGN KEY([idPropiedadesFormato])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleDepositos] CHECK CONSTRAINT [FK_Detalle_Depositos_Dominios4]
GO
ALTER TABLE [bpapp].[DetalleDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_TarifasDepositos_Propiedades_TarifasDepositos] FOREIGN KEY([idPropiedadesFormato])
REFERENCES [bpapp].[PropiedadesDepositos] ([idPropiedadesFormato])
GO
ALTER TABLE [bpapp].[DetalleDepositos] CHECK CONSTRAINT [FK_Detalle_TarifasDepositos_Propiedades_TarifasDepositos]
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_TarjetaCredito_Canal] FOREIGN KEY([Canal])
REFERENCES [bpapp].[Canal] ([idCodigo])
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito] CHECK CONSTRAINT [FK_Detalle_TarjetaCredito_Canal]
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios] FOREIGN KEY([idObservaciones])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito] CHECK CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios]
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios1] FOREIGN KEY([idOperacionServicio])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito] CHECK CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios1]
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios2] FOREIGN KEY([idCodigoAseguradora])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito] CHECK CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios2]
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios3] FOREIGN KEY([idTipoAseguradora])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito] CHECK CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios3]
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios4] FOREIGN KEY([idPropiedadesFormato])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito] CHECK CONSTRAINT [FK_Detalle_TarjetaCredito_Dominios4]
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_TarjetaCredito_Propiedades_TarjetaCredito] FOREIGN KEY([idPropiedadesFormato])
REFERENCES [bpapp].[PropiedadesTarjetaCredito] ([idPropiedadesFormato])
GO
ALTER TABLE [bpapp].[DetalleTarjetaCredito] CHECK CONSTRAINT [FK_Detalle_TarjetaCredito_Propiedades_TarjetaCredito]
GO
ALTER TABLE [bpapp].[Dominios]  WITH CHECK ADD  CONSTRAINT [FK_Dominios_Tipos_Dominio] FOREIGN KEY([idDominio])
REFERENCES [bpapp].[TiposDominio] ([idDominio])
GO
ALTER TABLE [bpapp].[Dominios] CHECK CONSTRAINT [FK_Dominios_Tipos_Dominio]
GO
ALTER TABLE [bpapp].[Permisos]  WITH CHECK ADD  CONSTRAINT [FK_Permisos_ROL] FOREIGN KEY([IdRol])
REFERENCES [bpapp].[Rol] ([IdRol])
GO
ALTER TABLE [bpapp].[Permisos] CHECK CONSTRAINT [FK_Permisos_ROL]
GO
ALTER TABLE [bpapp].[Permisos]  WITH CHECK ADD  CONSTRAINT [FK_Permisos_SUBMENU] FOREIGN KEY([IdSubMenu])
REFERENCES [bpapp].[Submenu] ([IdSubMenu])
GO
ALTER TABLE [bpapp].[Permisos] CHECK CONSTRAINT [FK_Permisos_SUBMENU]
GO
ALTER TABLE [bpapp].[PropiedadesCreditos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Creditos_Creditos] FOREIGN KEY([idCodigoCredito])
REFERENCES [bpapp].[Creditos] ([idcodigo])
GO
ALTER TABLE [bpapp].[PropiedadesCreditos] CHECK CONSTRAINT [FK_Propiedades_Creditos_Creditos]
GO
ALTER TABLE [bpapp].[PropiedadesCreditos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Creditos_Dominios] FOREIGN KEY([idAperturaDigital])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesCreditos] CHECK CONSTRAINT [FK_Propiedades_Creditos_Dominios]
GO
ALTER TABLE [bpapp].[PropiedadesCreditos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Creditos_Dominios1] FOREIGN KEY([idCodigoCredito])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesCreditos] CHECK CONSTRAINT [FK_Propiedades_Creditos_Dominios1]
GO
ALTER TABLE [bpapp].[PropiedadesCreditos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Creditos_Estados] FOREIGN KEY([Estado])
REFERENCES [bpapp].[Estados] ([idEstado])
GO
ALTER TABLE [bpapp].[PropiedadesCreditos] CHECK CONSTRAINT [FK_Propiedades_Creditos_Estados]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios] FOREIGN KEY([idObservacionesCuota])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios1] FOREIGN KEY([idGrupoPoblacional])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios1]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios10] FOREIGN KEY([idTipoProductoDeposito])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios10]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios11] FOREIGN KEY([idAperturaDigital])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios11]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios12] FOREIGN KEY([idTipoProductoDeposito])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios12]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios13] FOREIGN KEY([idObservacionesCuota])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios13]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios14] FOREIGN KEY([idGrupoPoblacional])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios14]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios15] FOREIGN KEY([idIngresos])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios15]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios16] FOREIGN KEY([idSerGratuito_CtaAHO])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios16]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios17] FOREIGN KEY([idSerGratuito_CtaAHO2])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios17]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios18] FOREIGN KEY([idSerGratuito_CtaAHO3])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios18]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios19] FOREIGN KEY([idSerGratuito_TCRDebito])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios19]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios2] FOREIGN KEY([idIngresos])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios2]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios20] FOREIGN KEY([idSerGratuito_TCRDebito2])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios20]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios21] FOREIGN KEY([idSerGratuito_TCRDebito3])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios21]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios3] FOREIGN KEY([idSerGratuito_CtaAHO])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios3]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios4] FOREIGN KEY([idSerGratuito_CtaAHO2])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios4]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios5] FOREIGN KEY([idSerGratuito_CtaAHO3])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios5]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios6] FOREIGN KEY([idSerGratuito_TCRDebito])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios6]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios7] FOREIGN KEY([idSerGratuito_TCRDebito2])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios7]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios8] FOREIGN KEY([idSerGratuito_TCRDebito3])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios8]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Dominios9] FOREIGN KEY([idSerGratuito_CtaAHO2])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Dominios9]
GO
ALTER TABLE [bpapp].[PropiedadesDepositos]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_Depositos_Estados] FOREIGN KEY([Estado])
REFERENCES [bpapp].[Estados] ([idEstado])
GO
ALTER TABLE [bpapp].[PropiedadesDepositos] CHECK CONSTRAINT [FK_Propiedades_Depositos_Estados]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios] FOREIGN KEY([idAperturaDigital])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios1] FOREIGN KEY([idFranquicia])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios1]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios10] FOREIGN KEY([idObservacionesCuota])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios10]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios11] FOREIGN KEY([idServicioGratuito_1])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios11]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios12] FOREIGN KEY([idServicioGratuito_2])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios12]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios2] FOREIGN KEY([idObservacionesCuota])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios2]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios3] FOREIGN KEY([idGrupoPoblacional])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios3]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios4] FOREIGN KEY([idCupo])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios4]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios5] FOREIGN KEY([idServicioGratuito_1])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios5]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios6] FOREIGN KEY([idServicioGratuito_2])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios6]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios7] FOREIGN KEY([idServicioGratuito_3])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios7]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios8] FOREIGN KEY([idAperturaDigital])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios8]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios9] FOREIGN KEY([idFranquicia])
REFERENCES [bpapp].[Dominios] ([idDominioGen])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Dominios9]
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [FK_Propiedades_TarjetaCredito_Estados] FOREIGN KEY([Estado])
REFERENCES [bpapp].[Estados] ([idEstado])
GO
ALTER TABLE [bpapp].[PropiedadesTarjetaCredito] CHECK CONSTRAINT [FK_Propiedades_TarjetaCredito_Estados]
GO
ALTER TABLE [bpapp].[Submenu]  WITH CHECK ADD  CONSTRAINT [FK_SUBMENU_MENU] FOREIGN KEY([IdMenu])
REFERENCES [bpapp].[Menu] ([IdMenu])
GO
ALTER TABLE [bpapp].[Submenu] CHECK CONSTRAINT [FK_SUBMENU_MENU]
GO
ALTER TABLE [bpapp].[Usuario]  WITH CHECK ADD FOREIGN KEY([IdRol])
REFERENCES [bpapp].[Rol] ([IdRol])
GO
ALTER TABLE [bpapp].[Usuario]  WITH CHECK ADD FOREIGN KEY([IdRol])
REFERENCES [bpapp].[Rol] ([IdRol])
GO
