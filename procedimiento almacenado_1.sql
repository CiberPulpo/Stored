ALTER PROCEDURE DBO.PA_1
(
	@pcCtaCod		VARCHAR(18) ,	-- CODIGO DE CREDITO
    @pdHoy			DATE ,			-- FECHA ACTUAL DEL SISTEMA
    @pnCodTrans		INT = 0,
	@nCodError		INT = 0 OUTPUT,
	@cCodError		VARCHAR(1000) = '' OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	-- DEFINIENDO VARIABLES LOCALES DE LOS PARAMETROS DE ENTRADA
	DECLARE      
		@cCtaCod    VARCHAR(18),
		@dHoy		DATE

	SET @cCtaCod = @pcCtaCod
	SET @dHoy = @pdHoy
	-- /DEFINIENDO VARIABLES LOCALES DE LOS PARAMETROS

	DECLARE @AgenciaCredito VARCHAR(200)

	SELECT 
		@AgenciaCredito = A.cAgeDescripcion 
	FROM Agencias A 
	WHERE SUBSTRING(@cCtaCod,4,2) = A.cAgeCod 
	
	--VALIDAMOS LA CARGA
	SELECT @nCodError = 0, @cCodError = ''

	IF EXISTS (	SELECT A.cCtaCod
				FROM ColocRecup A WITH(NOLOCK)
				WHERE A.cCtaCod =@cCtaCod )
	BEGIN

		SELECT @nCodError = 1, @cCodError = 'El crédito es Pre-Judicial, tiene que amortizarlo por la opción de créditos judiciales'
		--select @cCodError
		RETURN  
	END


	DECLARE 
		@cCredPagoBloqueado VARCHAR(MAX) = ''
	
	SET @cCredPagoBloqueado = (SELECT nConsSisValor FROM ConstSistema WHERE nConsSisCod = 117)

	IF EXISTS(SELECT ITEMS FROM DBO.FN_SPLIT(@cCredPagoBloqueado,',') WHERE Items = @cCtaCod)
	BEGIN
		SELECT 
			@nCodError = 1, @cCodError = 'El crédito se encuentra bloqueado temporalmente para realizar pagos.'
		RETURN  
	END
--INICIO BLOQUEO POR PROCESO DE REPROGRAMACION DESDE LA OPNION FAVORABLE EN COMITÉ HASTA LA ACTIVACIÓN
	IF EXISTS(SELECT R.cCtaCod FROM colocaciones.reproglotesol R WITH(NOLOCK) WHERE R.cCtaCod=@cCtaCod AND R.bReactiva_FAE IN (1,2) AND R.nEstado=1 )
	BEGIN
		DECLARE @bReactiva_FAE INT,@nEstadoEnComite INT,@dFechaProdReactiva_FAE DATE='2021-07-31'
		SELECT 
			@bReactiva_FAE=R.bReactiva_FAE,
			@nEstadoEnComite=ccc.nEstadoEnComite
		FROM colocComiteColocacion ccc WITH(NOLOCK)
		INNER JOIN colocComite c WITH(NOLOCK) ON ccc.nIdComite=c.nIdComite  
		INNER JOIN colocaciones.reproglotesol R WITH(NOLOCK) ON R.cctacod=ccc.cCtaCod
		WHERE  R.bReactiva_FAE in (1,2)
		and R.nEstado=1 
		and R.bComiteFae_Reactiva=1--Que haya pasado por comité	
		and c.nEstado=0			   --que tenga el comité cerrado siempre) 
		and ccc.nEstadoEnComite=1  --en comité aprobado
		and ccc.cctacod=@cCtaCod
		and ccc.dFechaAudit>=@dFechaProdReactiva_FAE
		and ccc.nIdComite=( SELECT MAX(ccc.nIdComite)
							FROM colocComiteColocacion ccc WITH(NOLOCK)
							INNER JOIN colocComite c WITH(NOLOCK) ON ccc.nIdComite=c.nIdComite  
							INNER JOIN colocaciones.reproglotesol R WITH(NOLOCK) ON R.cctacod=ccc.cCtaCod
							WHERE c.nEstado=0			  
							and ccc.nEstadoEnComite=1  
							and ccc.cctacod=@cCtaCod
							and ccc.dFechaAudit>=@dFechaProdReactiva_FAE
						  )
		SET @bReactiva_FAE=ISNULL(@bReactiva_FAE,0)
		SET @nEstadoEnComite=ISNULL(@nEstadoEnComite,0)
		--SI ES REACTIVA Y TIENE OPINIÓN FAVORABLE
		IF (@bReactiva_FAE = 1 AND @nEstadoEnComite=1)
		BEGIN
		  	SELECT 
			@nCodError = 1, @cCodError = 'El crédito Reactiva se encuentra en proceso de reprogramación.' + CHAR(13) + 
										 'Se encuentra bloqueado temporalmente para realizar pagos.'
		    RETURN  
		END
		--SI ES FAE PYME Y TIENE OPINIÓN FAVORABLE
		IF (@bReactiva_FAE = 2 AND @nEstadoEnComite=1)
		BEGIN
		  	SELECT 
			@nCodError = 1, @cCodError = 'El crédito FAE MYPE se encuentra en proceso de reprogramación.' + CHAR(13) + 
										 'Se encuentra bloqueado temporalmente para realizar pagos.'
		    RETURN  
		END
	END
--FIN   BLOQUEO POR PROCESO DE REPROGRAMACION DESDE LA OPNION FAVORABLE EN COMITÉ HASTA LA ACTIVACIÓN

	IF NOT EXISTS (
		SELECT A.* 
		FROM ColocacCred A WITH(NOLOCK)
			INNER JOIN PRODUCTO B WITH(NOLOCK)
				ON A.cCtaCod =B.cCtaCod    
			LEFT JOIN ColocRecup C WITH(NOLOCK)
				ON A.cCtaCod =C.cCtaCod 
		WHERE A.cCtaCod =@cCtaCod 
            --AND A.nCalendDinamico = 0 
			AND SUBSTRING(A.CCTACOD,6,3) NOT IN ('215','115')
            AND B.nPrdEstado IN (2020,2021,2022,2030,2031,2032) 
            AND C.cCtaCod IS NULL and ISNULL(CRFA,'') NOT IN ('RFA','RFC','DIF')
            --AND ISNULL(A.bMiVivienda,0) = 0   
			)
	BEGIN
				 RETURN       
	END

DECLARE @cConstSistemaLogicaAnterior VARCHAR(MAX)=''

DECLARE @bUtilizaLogicaAnterior BIT = 0 

SELECT @cConstSistemaLogicaAnterior = nConsSisValor From constsistema Where nConsSisCod = 1573       

DECLARE @tbCreditosLogicaAnterior TABLE
(
	cCtaCod VARCHAR(18)
)

INSERT INTO @tbCreditosLogicaAnterior (cCtaCod)
SELECT Items
FROM dbo.fn_Split(@cConstSistemaLogicaAnterior, ',') 
WHERE ISNULL(@cConstSistemaLogicaAnterior, '') <> ''

IF EXISTS(SELECT cCtaCod FROM @tbCreditosLogicaAnterior WHERE cCtaCod IN(@cCtaCod, '1'))
	SET @bUtilizaLogicaAnterior = 1


IF (@bUtilizaLogicaAnterior = 0)
BEGIN --lóxica nueva 17/12/2020 basado en pago lote

	CREATE TABLE #DeudasFecha
	(
   		cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS, 
		nNroProxCuota INT,
		cMoneda VARCHAR(12) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nDiasAtraso INT,
		dVencProxCuota DATE,
		cDOI VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nUltimaCuota INT, 
		cPersCodTitular VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS,
		cPersNombreTitular VARCHAR(200) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nDeudaProxCuota MONEY,
		nDeudaVencida MONEY,
		nDeudaImpaga MONEY,
		nPrepago MONEY,
		nMontoColocado MONEY,
		nDeudaCancelacion MONEY,
		nSaldoCapital MONEY,
		nICCancelacion MONEY,
		nICVCancelacion MONEY,
		nICCCancelacion MONEY,
		nIGCancelacion MONEY,
		nISCancelacion MONEY,
		nIMoratorio	MONEY DEFAULT(0),
		nGastosCancelacion MONEY DEFAULT(0),
		nMicroseguroCancelacion	MONEY DEFAULT(0),
		nComisionCancelacion MONEY DEFAULT(0),
		nITFCanc MONEY DEFAULT(0),
		nIntGastosFecha MONEY,
		bPuntualito BIT DEFAULT(0),
		nMontoBonoFechaPuntualito MONEY,
		bCrediemprende BIT DEFAULT(0),
		nNroCuotaImpagaMinima INT,
		nNroCuotaImpagaMaxima INT,
		cEstadoCredito VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
		cProducto VARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nMoneda INT,
		nComportamientoPago INT DEFAULT(0),
		cOpeCod VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS,
		bBonoBuenPagador BIT DEFAULT(0),
		bMiVivienda BIT DEFAULT(0),
		nPlazo INT DEFAULT(0),
		nCalPago INT DEFAULT(0),
		nDeudaCancelacionNeta MONEY DEFAULT(0),
		nDeudaImpagaNeta MONEY DEFAULT(0),
		bAmpliado BIT DEFAULT(0),
		nBono MONEY DEFAULT(0),
		nCuotaExigible INT DEFAULT(0),
		nMontoVencido MONEY DEFAULT(0),
		nMontoPago1CuotaNoVencida MONEY DEFAULT(0),
		nMontoPago2CuotasNoVencidas MONEY DEFAULT(0),
		bCondRecup BIT DEFAULT(0),
		nMontoDctoPP MONEY DEFAULT(0),
		bAplicaDctoPP BIT DEFAULT(0),
		nIPCancelacion MONEY DEFAULT(0)
	)

	DECLARE @xDataDeudaFecha XML
	SET @xDataDeudaFecha = (
		SELECT @dHoy AS "@dFechaActual",
			(SELECT @cCtaCod cCtaCod, nCodTrans=311101
			FOR XML RAW('Credito'),ROOT('Creditos'),TYPE)
		FOR XML PATH('Parametros')
	)

	/*INSERT INTO #DeudasFecha (cCtaCod, nNroProxCuota, cMoneda, nDiasAtraso, dVencProxCuota, cDOI, nUltimaCuota, cPersCodTitular, cPersNombreTitular, nDeudaProxCuota, nDeudaVencida, nDeudaImpaga, nPrepago, nMontoColocado, nDeudaCancelacion, nSaldoCapital, 
							nICCancelacion, nICVCancelacion, nICCCancelacion, nIGCancelacion, nISCancelacion, nIMoratorio, nGastosCancelacion, nMicroseguroCancelacion, nComisionCancelacion, nITFCanc, nIntGastosFecha, bPuntualito, nMontoBonoFechaPuntualito, bCrediemprende, 
							nNroCuotaImpagaMinima, nNroCuotaImpagaMaxima, cEstadoCredito, cProducto, nMoneda, nComportamientoPago, cOpeCod, bBonoBuenPagador, bMivivienda, nPlazo, nCalPago, nDeudaCancelacionNeta, nDeudaImpagaNeta, bAmpliado, nBono, nCuotaExigible, 
							nMontoVencido, nMontoPago1CuotaNoVencida, nMontoPago2CuotasNoVencidas, bCondRecup, nMontoDctoPP, bAplicaDctoPP)*/
	EXEC Colocaciones.FluCred_SelDatosPagoCreditoLote_SP @xDataDeudaFecha, 0

	SELECT --compatibility
		A.cCtaCod, 
		nNroProxCuota, 
		nSaldoCapital as nSaldo, 
		cMoneda as Moneda, 
		A.nDiasAtraso,
		dVencProxCuota as VencProxCuota, 
		cDOI as DOI, 
		nUltimaCuota as UltCuota, 
		cPersCodTitular as CodigoCliente,
		cPersNombreTitular as Cliente, 
		nDeudaProxCuota as DeudaProxCuota, 
		nDeudaImpaga as DeudaImpaga,
		nPrepago as PrePago, 
		nMontoColocado as MontoColocado, 
		nDeudaCancelacion as DeudaCancelacion,
		nICCancelacion as ICCancelacion, 
		nIGCancelacion as IGCancelacion, 
		nIntGastosFecha as IntGastosFecha,
		nNroCuotaImpagaMinima as NroCuotaImpMin, 
		nNroCuotaImpagaMaxima as NroCuotaImpMax, 
		cEstadoCredito as EstadoCuenta, 
		cProducto as NombreProducto,
		nMoneda as CodigoMoneda, 
		nComportamientoPago as ComportamientoPago, 
		cOpeCod, nIMoratorio,
		bBonoBuenPagador as bBonoBP, 
		bMiVivienda, 
		nPlazo, 
		nBono as nMontoCuotaBP, 
		nMontoBonoFechaPuntualito as nMontoFechaBP,
		bPuntualito, 
		bCrediemprende as bCrediemp, 
		nCalPago as CalPago, 
		@AgenciaCredito as NombreAgencia,
		nDeudaCancelacionNeta as DeudaCancelacionNeto, 
		nDeudaImpagaNeta as DeudaImpagaNeta, 
		bAmpliado,
		dbo.CuotaAprobada(A.cCtaCod) as CuotaAprobada, 
		IIF(B.cCtaCod IS NULL, 0, 1) as pbAprobComisionCanc, 
		IIF(nCuotaExigible < nUltimaCuota, 1, 0) as bAplicaCancelacionAnticipada,
		nBono as nBonoCalen, 
		nCuotaExigible, 
		nMontoVencido, 
		nMontoPago1CuotaNoVencida,
		nMontoPago2CuotasNoVencidas, 
		bCondRecup, 
		nMontoDctoPP as nMontoDctoCuotaPP, 
		bAplicaDctoPP as bDctoPP		
	FROM #DeudasFecha A
		LEFT JOIN ColocRegistroComisionCancelacion B WITH(NOLOCK) ON A.cCtaCod = B.cCtaCod AND B.nEstadoRegistro = 0

	DROP TABLE #DeudasFecha
END --/lóxica nueva 17/12/2020 basado en pago lote
ELSE IF (@bUtilizaLogicaAnterior = 1)--lóxica anterior 17/12/2020
BEGIN

	CREATE TABLE #DatosCrediemprende
	(
	nNroCalen INT,
	nNumeroCuota INT,
	nCapital MONEY,
	nInteresCompensatorio MONEY,
	nInteresMoratorio MONEY,
	nBonoCrediemprende MONEY,
	nUltima INT
	);

	DECLARE 
		@nCuotaExigible INT = 0,
		@nUltimaCuotaCalendario INT = 0,
		-- LGEV
		@nDiasAtraso INT = 0,
		@nBonoCalen MONEY = 0,
		@bPagosAnticipados BIT = 0,
		@nPrimeraCuotaNoVencida INT = 0,
		@nMontoVencido MONEY = 0,
		@nMontoPago1CuotaNoVencida MONEY = 0,
		@nMontoPago2CuotasNoVencidas MONEY = 0,
		@nMetodologiaCalendario INT = 0
			
	SELECT 
		@nMetodologiaCalendario = X.nMetodologiaCalendario
	FROM
	(SELECT  
		B.cCtaCod, ISNULL(B.nMetodologiaCalendario, 0) nMetodologiaCalendario,
		ROW_NUMBER() OVER(PARTITION BY B.cCtaCod ORDER BY  B.dPrdEstado DESC ) as nFila
	FROM ColocacEstado B WITH(NOLOCK)
	WHERE B.cctacod = @cCtaCod
		AND B.nPrdEstado IN (2002, 2052)) X
	WHERE 
		X.nFila = 1

	SET @nDiasAtraso = (SELECT ISNULL(nDiasAtraso, 0) FROM ColocacCred WITH(NOLOCK) WHERE cCtaCod = @cCtaCod)
	SET @bPagosAnticipados = (SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END FROM ColocPagoAdelantado WITH(NOLOCK) WHERE cCtaCod = @cCtaCod )

	SET @nCuotaExigible = ( SELECT MIN(nCuota)
							FROM ColocacCred A WITH(NOLOCK)
								INNER JOIN ColocCalendario B WITH(NOLOCK)
									ON A.cCtaCod = B.cCtaCod
										AND A.nNroCalen = B.nNroCalen                  
                            WHERE A.cCtaCod = @cCtaCod
								AND B.nColocCalendApl = 1
                                AND B.dVenc >= @dHoy)

	SET @nUltimaCuotaCalendario = 
						( SELECT MAX(nCuota)
						FROM ColocacCred A WITH(NOLOCK)
							INNER JOIN ColocCalendario B WITH(NOLOCK)
							ON A.cCtaCod = B.cCtaCod
								AND A.nNroCalen = B.nNroCalen                  
						WHERE A.cCtaCod = @cCtaCod
							AND B.nColocCalendApl = 1)

    IF @nCuotaExigible IS NULL
    BEGIN
	   SET @nCuotaExigible = @nUltimaCuotaCalendario
    END

	SELECT 
		@nPrimeraCuotaNoVencida = MIN(B.nCuota)
	FROM ColocacCred A WITH(NOLOCK)
		INNER JOIN ColocCalendario B WITH(NOLOCK)
			ON A.cCtaCod = B.cCtaCod
			AND A.nNroCalen = B.nNroCalen
	WHERE A.cCtaCod = @cCtaCod
		AND B.nColocCalendApl = 1
		AND B.nColocCalendEstado = 0
		AND CONVERT(DATE, B.dVenc) >= @dHoy

	SELECT 
		@nMontoVencido = SUM(ISNULL(C.nMonto, 0) - ISNULL(C.nMontoPagado, 0))
	FROM ColocacCred A WITH(NOLOCK)
		INNER JOIN ColocCalendario B WITH(NOLOCK)
			ON A.cCtaCod = B.cCtaCod
			AND A.nNroCalen = B.nNroCalen
		INNER JOIN ColocCalendDet C WITH(NOLOCK)
			ON B.cCtaCod = C.cCtaCod
			AND B.nNroCalen = C.nNroCalen
			AND B.nColocCalendApl = C.nColocCalendApl
			AND B.nCuota = C.nCuota
	WHERE A.cCtaCod = @cCtaCod
		AND B.nColocCalendApl = 1
		AND B.nColocCalendEstado = 0
		AND CONVERT(DATE, B.dVenc) < @dHoy

	SELECT 
		@nMontoPago1CuotaNoVencida = SUM(ISNULL(C.nMonto, 0) - ISNULL(C.nMontoPagado, 0))
	FROM ColocacCred A WITH(NOLOCK)
		INNER JOIN ColocCalendario B WITH(NOLOCK)
			ON A.cCtaCod = B.cCtaCod
			AND A.nNroCalen = B.nNroCalen
		INNER JOIN ColocCalendDet C WITH(NOLOCK)
			ON B.cCtaCod = C.cCtaCod
			AND B.nNroCalen = C.nNroCalen
			AND B.nColocCalendApl = C.nColocCalendApl
			AND B.nCuota = C.nCuota
	WHERE A.cCtaCod = @cCtaCod
		AND B.nColocCalendApl = 1
		AND B.nColocCalendEstado = 0
		AND B.nCuota <= @nPrimeraCuotaNoVencida 

	SELECT 
		@nMontoPago2CuotasNoVencidas = SUM(ISNULL(C.nMonto, 0) - ISNULL(C.nMontoPagado, 0))
	FROM ColocacCred A WITH(NOLOCK)
		INNER JOIN ColocCalendario B WITH(NOLOCK)
			ON A.cCtaCod = B.cCtaCod
			AND A.nNroCalen = B.nNroCalen
		INNER JOIN ColocCalendDet C WITH(NOLOCK)
			ON B.cCtaCod = C.cCtaCod
			AND B.nNroCalen = C.nNroCalen
			AND B.nColocCalendApl = C.nColocCalendApl
			AND B.nCuota = C.nCuota
	WHERE A.cCtaCod = @cCtaCod
		AND B.nColocCalendApl = 1
		AND B.nColocCalendEstado = 0
		AND B.nCuota <= @nPrimeraCuotaNoVencida + 1

	SET @nMontoVencido = ISNULL(@nMontoVencido, 0)
	SET @nMontoPago1CuotaNoVencida = ISNULL(@nMontoPago1CuotaNoVencida, 0)
	SET @nMontoPago2CuotasNoVencidas = ISNULL(@nMontoPago2CuotasNoVencidas, 0)
	
	--CREANDO TABLA TEMPORAL QUE RECIBIRA LOS DATOS DEL PROCEDIMIENTO  [Colocaciones].[Gen_Sel_DatosBasicosPago_SP]  
	CREATE TABLE #DATOSPAGO 
    ( 
	   cCtaCod					VARCHAR(18),
        nNroCalen					INT,
        nColocCalendApl				INT,
        nCuota						INT,
        nPrdConceptoCod				INT,
        nMonto						MONEY,
        nMontoPagado				MONEY,
        nMontoEsp					MONEY,
        nMontoPagadoEsp				MONEY,
        nMontoBonoCE				MONEY,
        nMontoDctoPP				MONEY,
        nMontoPar					MONEY,
        nMontoParPagado				MONEY,
        PorPagar					MONEY,
        PorPagarPar					MONEY,
        DVENC						DATE,
        DPAGO						DATE,
        NCOLOCCALENDESTADO			INT,
        NCOLOCCALENDESTADOPAR			INT,
        NNROPROXCUOTA				INT,
        NDIASATRASO					INT,
        bMiVivienda					BIT,
        NSALDOINICIAL				MONEY,
        DFECHAINICIAL				DATE,
        cMetLiq					VARCHAR(4),
        cMensaje					VARCHAR(2),
        nICFecha					MONEY,
        nPrimeraCuotaVencer			INT,
        nSaldoCapital				MONEY,
        nUltCuota					INT,
        nPeriodoGracia				INT,
        nTipoDesembolso				INT,
        nICParcial					MONEY,
        dVencProxCuota				DATE,
        NTASAIC					MONEY,
        NTASAIG					MONEY,
        NMONTODESEMBOLSADO			MONEY,
        nCalendDinamico				INT,
        PDHOY						DATE,
        nMontoCol					MONEY,
        FechaVigencia				DATE,
        nPlazo						INT
        PRIMARY KEY (cctacod, ncuota, nprdconceptocod) 
	)                   


	DECLARE @cDOI				VARCHAR(11)='',
			@cCodProducto		VARCHAR(4) ='',
			@cNombreProducto		 VARCHAR(100)= '',
            @cOpeCod			 VARCHAR(6),
            @pnPrdEstado			 INT, 
            @bPuntualito			 BIT,
            @bCrediemp			 BIT,
            @bDctoPP			 BIT,
            @nCalPago           BIT,
            @nCalenDin          BIT =0,
			@bBonoBuenPagador	BIT,
		    @bAmpliado			BIT = 0,
		    @bCuoMayorMensual	  BIT = 0,
			@pbAprobComisionCanc  BIT=0,
			@bAplicaCancelacionAnticipada BIT = 0,
			@bAumentaIntereses BIT = 0

	SET @bAumentaIntereses = (SELECT CONVERT(BIT,nConsSisValor) FROM ConstSistema WHERE nConsSisCod = 21210)

       --TABLA CON DATOS DE CALENDARIO Y PROCESAMIENTO
	CREATE TABLE #DatosTemp
		(
             cCtaCod				VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS,            
             nNroCalen				INT,   
			 nColocCalendApl		INT,       
             nCuota					INT,
             nPrdConceptoCod		INT ,            
             nMonto					MONEY,
			 nMontoPagado			MONEY,               
             nMontoEsp				MONEY,
             nMontoPagadoEsp		MONEY,            
             nMontoBonoCE			MONEY,
             nMontoDctoPP			MONEY,
			 nMontoPar				MONEY,                   
             nMontoParPagado		MONEY,
             PorPagar				MONEY,                         
             PorPagarPar			MONEY,
             DVENC					DATE,                             
             DPAGO					DATE,
             NCOLOCCALENDESTADO		INT,           
             NCOLOCCALENDESTADOPAR	INT,
             NNROPROXCUOTA			INT,                
             NDIASATRASO			INT,    
             bMiVivienda			BIT,                  
             NSALDOINICIAL			MONEY, 
             DFECHAINICIAL			DATE,               
             cMetLiq				VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS,
             cMensaje				VARCHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS,          
             nICFecha				MONEY,
             nPrimeraCuotaVencer	INT,   
             nSaldoCapital			MONEY,
             nUltCuota				INT,                          
             nPeriodoGracia			INT,
             nTipoDesembolso		INT,       
             nICParcial				MONEY,   
             dVencProxCuota			DATE,       
             NTASAIC				MONEY,      
             NTASAIG				MONEY,                          
             NMONTODESEMBOLSADO		MONEY, 
             nCalendDinamico		INT,       
             PDHOY					DATE, 
             nMontoCOl				MONEY,
             FechaVigencia			DATE,
             BAPLICABONO			BIT,
             nCuotaExigible			INT,
			 bAmpliado				BIT,
			 bAplicaDctoPP			BIT
		)
       
	IF EXISTS (SELECT * 
				FROM ColocacAmpliado A WITH(NOLOCK)
					INNER JOIN PRODUCTO B WITH(NOLOCK)
						ON B.cCtaCod = A.cCtaCod
				WHERE cCtaCodAmp = @cCtaCod 
				AND B.nPrdEstado = 2002)
	BEGIN
		SET @bAmpliado = 1
	END

	IF @bAumentaIntereses = 0 AND @nMetodologiaCalendario = 2 AND @bAmpliado = 1
	BEGIN
		SET @bAmpliado = 0
	END

    --VERIFICANDO SI LA PERIODICIDAD ES MAYOR ALA MENSUAL
    SELECT 
	   @bCuoMayorMensual = 1 
    FROM ColocacEstado A WITH(NOLOCK)
    WHERE A.cCtaCod = @cCtaCod
	   AND nPrdEstado = 2002
	   AND nPeriodoFechaFija = 0
	   AND nPlazo> 30
	   AND nCuotas > 1

       --RECUPERAMOS DETALLE DE CALENDARIO 
	EXEC Colocaciones.FluGen_SelDatos_BasicosPago_SP @cCtaCod,@dHoy
-- select * from #DATOSPAGO
	--INSERTANDO EN TABLA TEMPORAL
	INSERT INTO  #DatosTemp 
		(cCtaCod,
        nNroCalen,
        nColocCalendApl, 
        nCuota,
        nPrdConceptoCod, 
        nMonto,
        nMontoPagado,
        nMontoEsp,
        nMontoPagadoEsp,
        nMontoBonoCE,
        nMontoDctoPP,
        nMontoPar,
		nMontoParPagado,
        PorPagar,
        PorPagarPar,
        DVENC,
        DPAGO,
        NCOLOCCALENDESTADO, 
        nColocCalendEstadoPar, 
        NNROPROXCUOTA,
        NDIASATRASO, 
        bMiVivienda ,
        NSALDOINICIAL,
        DFECHAINICIAL, 
        cMetLiq, 
        cMensaje, 
        nICFecha,
        nPrimeraCuotaVencer, 
        nSaldoCapital,
        nUltCuota,
        nPeriodoGracia, 
        nTipoDesembolso, 
        nICParcial,
        dVencProxCuota ,
        NTASAIC,
        NTASAIG,
        NMONTODESEMBOLSADO,
        nCalendDinamico,
        PDHOY, 
        nMontoCOl,
        FechaVigencia)
	SELECT 
		cCtaCod,
        nNroCalen,
        nColocCalendApl, 
        nCuota,
        nPrdConceptoCod, 
        nMonto,
        nMontoPagado,
        nMontoEsp,
        nMontoPagadoEsp,
        nMontoBonoCE,
        nMontoDctoPP,
        nMontoPar,
        nMontoParPagado,
        PorPagar,
        PorPagarPar,
        DVENC,
        DPAGO,
        NCOLOCCALENDESTADO, 
        nColocCalendEstadoPar, 
        NNROPROXCUOTA,
        NDIASATRASO, 
        bMiVivienda ,
        NSALDOINICIAL,
        DFECHAINICIAL,
        cMetLiq, 
        cMensaje, 
        nICFecha,
        nPrimeraCuotaVencer, 
        nSaldoCapital,
        nUltCuota,
        nPeriodoGracia, 
        nTipoDesembolso, 
        nICParcial,
        dVencProxCuota ,
        NTASAIC,
        NTASAIG,
        NMONTODESEMBOLSADO,
        nCalendDinamico,
        PDHOY, 
        nMontoCOl,
        FechaVigencia
	FROM #DATOSPAGO     

	--SELECT * FROM #DatosTemp order by nNroCalen,nColocCalendApl,nCuota --C1

	UPDATE #DatosTemp
		SET nMontoPar = 0,
			nMontoParPagado = 0
	WHERE NCOLOCCALENDESTADOPAR = 1

    --obteniendo codigo de producto
/*
	SELECT 
		@cCodProducto=ISNULL(b.nConsEquivalente, a.cSubProducto)  
	FROM ColocProductoComer A
		LEFT JOIN Constante b 
			ON a.cSubProducto =b.nConsValor 
				AND b.nConsCod =1052
	WHERE a.cCtaCod =@cCtaCod
 */            
	SELECT 
		@cCodProducto = cCredProductos, 
		@cNombreProducto = cDescripcion  
	FROM credproductos 
	WHERE cCredProductos = dbo.FN_GetcCredProducto(@cCtaCod) --ISNULL(@cCodProducto,SUBSTRING(@cCtaCod,6,3)) = cCredProductos 
       
	SELECT 
		@pnPrdEstado = nprdestado 
	FROM producto WITH(NOLOCK)
	WHERE cCtaCod =@cCtaCod 

	SELECT 
		@cOpeCod=cOpeCodNeg
       --FROM  COLOCACIONES.Gen_SelDatosOperacionTransaccion_FN( @pnCodTrans,@pnPrdEstado)    
	FROM NEGOCIO.TransaccionConfiguracion 
	WHERE nCodTrans = @pnCodTrans
		AND nEstProducto = @pnPrdEstado
   
	SELECT 
		@nCalPago = nCalPago,
        @bPuntualito =  CASE 
							WHEN bpuntualito =1 THEN 1 
                            ELSE 0 
						END ,
        @nCalenDin = nCalendDinamico
	FROM ColocacCred WITH(NOLOCK)
	WHERE cCtaCod =@cCtaCod 
       
	--obteniendo DOI
	SELECT 
		@cDOI=b.cPersIDnro  
	FROM ProductoPersona a WITH(NOLOCK)
		INNER JOIN PersID b WITH(NOLOCK)
			ON a.cPersCod=b.cPersCod 
	WHERE a.cCtaCod =@cCtaCod 
		AND a.nPrdPersRelac =20 
        AND b.cPersIDTpo = (SELECT 
								MIN(cpersidtpo) 
							FROM PersID WITH(NOLOCK)
							WHERE cPersCod =b.cPersCod)                   
             
       --INI:Validación puntualito
	DECLARE @nConceptoAplicaBP	INT,
			@nEstado			INT, 
            @nMonto				MONEY ,
            @dPago				DATE, 
            @nMontoPag			MONEY, 
            @nXPagarIC			MONEY
             
	UPDATE A 
	SET A.BAPLICABONO = 
		CASE 
			WHEN ncuota=nnroproxcuota THEN
				CASE 
					WHEN DVENC >=@dHoy AND PorPagar >0 THEN 1 
                    ELSE 0 
                END
			ELSE 0 
		END --SELECT *
	FROM #DatosTemp A
	WHERE A.nPrdConceptoCod NOT IN (1100) 
		AND @bPuntualito=1
   
	BEGIN --DESCUENTO POR PAGO PUNTUAL
		DECLARE @nDiasAtrasoMaximoPP INT = 0

		IF EXISTS(SELECT IdCampana FROM ColocCredCampana WITH(NOLOCK) WHERE cCtaCod = @cCtaCod AND idCampana = 167)
		BEGIN
			/*
				OJO: No olvidar las siguientes tiendas en caso desean modificar los días de atraso para pago puntual:
				- COLOCACIONES.fluGen_SelDatos_PagoCredito_SP
				- Colocaciones.FluPag_SelDctoPagoPuntual_SP 
				- Colocaciones.FluGen_SelDatos_BasicosPago_SP
			*/
			SET @nDiasAtrasoMaximoPP = 3
		END

		UPDATE A 
		SET A.bAplicaDctoPP = 
			CASE
				WHEN DATEDIFF(DAY, DVENC, @dHoy) <= @nDiasAtrasoMaximoPP AND nMontoDctoPP > 0 THEN 1 
				ELSE 0
			END --SELECT *
		FROM #DatosTemp A
		WHERE A.nPrdConceptoCod IN (1100)
	END

	SELECT 
		@nConceptoAplicaBP=min(nprdconceptocod)  --sELECT *
	FROM #DatosTemp 
	WHERE ncuota=nnroproxcuota 
		AND baplicabono=1
             
	UPDATE #DatosTemp 
		SET BAPLICABONO=0 
	WHERE NPRDCONCEPTOCOD NOT IN (@nConceptoAplicaBP) 
		AND ncuota=nnroproxcuota
             
	SELECT 
		@nMonto=SUM(NMONTO),
		@nMontoPag=SUM(NMONTOPAGADO) 
	FROM #DatosTemp 
    WHERE nCuota = NNROPROXCUOTA 

	SELECT 
		@dPago =
		 MIN(dpago) 
	FROM #DatosTemp 
	WHERE nCuota = NNROPROXCUOTA 
       
	SELECT 
		@nXPagarIC= PorPagar  --SELECT *
	FROM #DatosTemp 
	WHERE nCuota =NNROPROXCUOTA 
             AND nprdconceptocod=1100

	SELECT @nEstado=    
		CASE
			WHEN @dPago IS NULL THEN
				CASE 
					WHEN @nMontoPag > 0 THEN 0 
                    ELSE 1 
                END
            ELSE 0 
        END

	--FIN:Validación puntualito

	UPDATE A
		SET A.nCuotaExigible = @nCuotaExigible,
			A.bAmpliado = @bAmpliado			
	FROM #DatosTemp A

	--select * from #DatosTemp --c2

	--VERIFICANDO SI TIENE BONO
	SELECT TOP 1
		@bBonoBuenPagador = ISNULL( bBonoBP,0)
	FROM ColocGestionMontoHipotecario WITH(NOLOCK)
	WHERE cCtaCod = @cCtaCod
	ORDER BY dFechaActualiza DESC

	DECLARE @nCuotaRecup INT
	DECLARE @bCondRecup BIT
	IF EXISTS(SELECT 1 FROM CampanasRecupCred A WHERE A.cCtaCod = @cCtaCod AND bEliminado = 0 )
	BEGIN
		IF EXISTS (SELECT 1 FROM MOV WHERE nMovNro IN (SELECT nMovNro FROM CampanasRecupCred A WHERE A.cCtaCod = @cCtaCod AND bEliminado = 0 ) AND nMovFlag = 0)
		BEGIN
			SET @nCuotaRecup = 240 
			SET @bCondRecup = 0
		END
		ELSE
		BEGIN
			SELECT @nCuotaRecup = MAX(B.nCuota) FROM CampanasRecupCred A 
			INNER JOIN CampanasRecupCalendDet B ON A.idRecupCred = B.idRecupCred
			WHERE A.cCtaCod = @cCtaCod AND bEliminado = 0 
			SET @bCondRecup = 1
		END
	END
	ELSE
	BEGIN
		SET @nCuotaRecup = 240 
		SET @bCondRecup = 0
	END

	/* before metodología 2
	SELECT 
		a.nPrdConceptoCod,
		a.nCuota,
		a.nCuotaExigible,
		a.nUltCuota,
		a.dFechaInicial,
		d.nDiasGracia, 
		a.nMontoPagado,
		b.nMontoPagado as montopagadogracia,
		@dHoy,
		a.NSALDOINICIAL,a.nTasaIC,
		a.nMontoCOl,a.NTASAIG,
		DATEDIFF(D,a.dFechaInicial,@dHoy) as diffechas,
		(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
										WHEN DATEDIFF(D,a.dFechaInicial, @dHoy) > 0 
											THEN DATEDIFF(D,a.dFechaInicial, @dHoy) 
										ELSE 0 
									END),2)) as nIFecha,
		(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 
																												
																								ELSE 0 
																							 END),2) - a.nMontoPagado),

		CASE 
				WHEN a.nPrdConceptoCod = 1100 AND A.dVenc < @dHoy  
					THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado --todo lo vencido.
                WHEN a.nPrdConceptoCod = 1100 AND d.cCtaCod IS NULL AND a.nCuota = a.nPrimeraCuotaVencer and a.nPrimeraCuotaVencer =1 and DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia>0 
					THEN  --aún no vence la primera cuota pero si la gracia
						CASE 
							WHEN isnull(a.nTipoDesembolso,0) =1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
							ELSE ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.nMontoCOl ,a.nTasaIC,
								CASE 
									WHEN DATEDIFF(D,a.FechaVigencia,@dHoy) - a.nPeriodoGracia > 0 
										THEN DATEDIFF(D,a.FechaVigencia,@dHoy)- a.nPeriodoGracia
                                    ELSE 0 
                                END),2) - a.nMontoPagado   -- a.nMonto - a.nMontoPagado       --se debe calcular a la fechas, saldo capital inicial, TEM, 
                        END
                 WHEN a.nPrdConceptoCod =1100 AND a.nCuota = a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 and a.nPeriodoGracia>0  
					THEN 0 --falta vencer la primera cuota, pero aun no vence la gracia                                         
                 WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NOT NULL and ((a.nCuota= d.nCuota and DATEDIFF(DAY,a.dFechaInicial,@dHoy)-d.nDiasGracia > 0) or a.nCuota> d.nCuota)  -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
                            ELSE  
								(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
 --                           ELSE  
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 
																												
																								ELSE 0 
																							 END),2) - a.nMontoPagado - IIF(a.nCuota= d.nCuota, d.nigracia + (IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) -d.nDiasGracia > 0,(COLOCACIONES.Comun_CalculaIntFecha_FN(d.nigracia,a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy) -d.nDiasGracia)), 0)), 0))
                        END 
				 WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtaCod IS NULL  -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado, 2)
							WHEN @cCodProducto = '210'
								THEN  ROUND(a.nMonto - a.nMontoPagado, 2)                                              
                          ELSE  
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
 --                           ELSE  
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 
																												
																								ELSE 0 
																							 END),2) - a.nMontoPagado 
                        END          --se debe calcular a la fechas, saldo capital inicial, TEM,   
						
				WHEN a.nPrdConceptoCod =1100 AND a.nCuotaExigible = a.nUltCuota AND a.bAmpliado = 1 -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
                            ELSE  
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN 
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
	--						 ELSE 
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 																												
																								ELSE 0 
																							 END),2) - a.nMontoPagado 
                        END          --se debe calcular a la fechas, saldo capital inicial, TEM,      
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible = a.nUltCuota -- a.nPrimeraCuotaVencer 
					THEN round(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado    
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NOT NULL and a.nCuota = d.nCuota and DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0 -- a.nPrimeraCuotaVencer 
					THEN a.nMontoPagado * -1 --desaguio 					                                                                                                      
                WHEN a.nPrdConceptoCod =1100 AND a.nCuota > @nCuotaExigible and a.nCuotaExigible <> a.nUltCuota --a.nPrimeraCuotaVencer 
					THEN a.nMontoPagado * -1 --desaguio   					
				WHEN a.nPrdConceptoCod =1100 AND a.nCuotaExigible =a.nUltCuota AND a.bAmpliado = 1 --DESAGIO PARA AMPLIADOS
					THEN a.nMontoPagado * -1 --desaguio 
				WHEN a.nPrdConceptoCod = 1102 AND @cCtaCod = (SELECT cCtaCod FROM ColocacConvenio WHERE cCtaCod = @cCtaCod AND cPersCod = '1083400108553')
					THEN 0
                WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NULL AND ISNULL(a.nPrimeraCuotaVencer, a.nUltCuota) > 1)  
					OR (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NULL AND a.nPrimeraCuotaVencer = 1 AND DATEDIFF(DAY, a.FechaVigencia, @dHoy) - a.nPeriodoGracia > 0) 
					OR (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota AND @nCuotaExigible > d.nCuota)
					OR (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia > 0)
                    THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado --ya vencio la gracia
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0)
					THEN 
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)             
							 ELSE
								(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
										WHEN DATEDIFF(D,a.dFechaInicial, @dHoy) > 0 
											THEN DATEDIFF(D,a.dFechaInicial, @dHoy) 
										ELSE 0 
									END),2) - a.nMontoPagado)   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM,                     
                        END
				
                WHEN a.nPrdConceptoCod =1102 AND a.nCuota=a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 AND a.nPeriodoGracia>0  
					THEN   --falta vencer la primera cuota, pero aun no vence la gracia        
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                      
							 ELSE 
							 
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.nMontoCOl,a.NTASAIG,	CASE 
																										WHEN DATEDIFF(D,a.FechaVigencia,@dHoy)>0 
																											THEN DATEDIFF(D,a.FechaVigencia,@dHoy) 
																										ELSE 0 
																									END),2) - a.nMontoPagado   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM,                     
                        END --when a.nPrdConceptoCod =1102  and a.nPrimeraCuotaVencer <>1 then a.nMonto - a.nMontoPagado+ a.nMontoPar - a.nMontoParPagado  --todo                                 
                        --INCLUYE INTERES CORRIDO
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota AND @nCuotaExigible <= d.nCuota)
					THEN
					a.nMontoPagado  * -1
				WHEN a.nPrdConceptoCod = 1102 AND a.nCuota > a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer = 1 AND DATEDIFF(DAY, a.FechaVigencia, @dHoy) - a.nPeriodoGracia <= 0 AND a.nPeriodoGracia > 0  
					AND ISNULL(a.nTipoDesembolso,0) = 0
					THEN   --falta vencer la primera cuota, pero ya realizo pagos en las siguientes cuotas      
					a.nMontoPagado  * -1           
                ELSE 0
			END as monto,
			CASE 
				WHEN a.nPrdConceptoCod = 1100 AND A.dVenc < @dHoy  
					THEN 1
                WHEN a.nPrdConceptoCod = 1100 AND d.cCtaCod IS NULL AND a.nCuota = a.nPrimeraCuotaVencer and a.nPrimeraCuotaVencer =1 and DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia>0 
					THEN 2
                 WHEN a.nPrdConceptoCod =1100 AND a.nCuota = a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 and a.nPeriodoGracia>0  
					THEN 3     
                 WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NOT NULL and ((a.nCuota= d.nCuota and DATEDIFF(DAY,a.dFechaInicial,@dHoy)-d.nDiasGracia > 0) or a.nCuota> d.nCuota)  -- a.nPrimeraCuotaVencer 
					THEN 4
				 WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NULL  -- a.nPrimeraCuotaVencer 
					THEN 5
				WHEN a.nPrdConceptoCod =1100 AND a.nCuotaExigible = a.nUltCuota AND a.bAmpliado = 1 -- a.nPrimeraCuotaVencer 
					THEN 6 
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible = a.nUltCuota -- a.nPrimeraCuotaVencer 
					THEN 7
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NOT NULL and a.nCuota = d.nCuota and DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0 -- a.nPrimeraCuotaVencer 
					THEN 8
                WHEN a.nPrdConceptoCod =1100 AND a.nCuota > @nCuotaExigible and a.nCuotaExigible <> a.nUltCuota --a.nPrimeraCuotaVencer 
					THEN 9
				WHEN a.nPrdConceptoCod =1100 AND a.nCuotaExigible =a.nUltCuota AND a.bAmpliado = 1 --DESAGIO PARA AMPLIADOS
					THEN 10
				WHEN a.nPrdConceptoCod = 1102 AND @cCtaCod = (SELECT cCtaCod FROM ColocacConvenio WHERE cCtaCod = @cCtaCod AND cPersCod = '1083400108553')
					THEN 11
                WHEN (a.nPrdConceptoCod = 1102 AND b.cCtaCod IS NULL AND ISNULL(a.nPrimeraCuotaVencer, a.nUltCuota) > 1)  
					OR (a.nPrdConceptoCod = 1102 AND b.cCtaCod IS NULL AND a.nPrimeraCuotaVencer = 1 AND DATEDIFF(DAY, a.FechaVigencia, @dHoy) - a.nPeriodoGracia > 0) 
					OR (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota AND @nCuotaExigible > d.nCuota)
					OR (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia > 0)
                    THEN 12
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0)
					THEN 13
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota AND @nCuotaExigible <= d.nCuota)
					THEN
					17
       WHEN a.nPrdConceptoCod =1102 AND a.nCuota=a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 AND a.nPeriodoGracia>0  
					THEN 14
				WHEN a.nPrdConceptoCod = 1102 AND a.nCuota > a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer = 1 AND DATEDIFF(DAY, a.FechaVigencia, @dHoy) - a.nPeriodoGracia <= 0 AND a.nPeriodoGracia > 0  
					AND ISNULL(a.nTipoDesembolso,0) = 0
					THEN 15
                ELSE 16
			END
	FROM #DatosTemp a
		LEFT JOIN #DatosTemp b
			on b.cCtaCod = a.cCtaCod
			and b.nNroCalen = a.nNroCalen
			and b.nColocCalendApl = a.nColocCalendApl
			and b.nCuota = a.nCuota
			and b.nPrdConceptoCod = 1102
		LEFT JOIN ColocCalendInteresInteresGracia d
			on d.cCtaCod = b.cCtaCod
			and d.nNroCalen = b.nNroCalen
			and d.nDiasGracia > 0
	WHERE a.nCuota >=	CASE 
							WHEN EXISTS(SELECT * FROM #DatosTemp x WHERE x.NDIASATRASO>0)
								THEN  a.nNroProxCuota 
							ELSE a.nCuotaExigible
						END
             AND a.nColocCalendApl =1
			 AND a.nPrdConceptoCod in (1100, 1102)
	ORDER BY a.nCuota ASC 
	*/

	SELECT 
		A.nNroProxCuota, 
        a.cCtaCod,
        a.nNroCalen, 
        a.nCuota,
        a.dVenc,
        a.nMontoDesembolsado,
        a.dVencProxCuota,
        a.nUltCuota,
        a.nCalendDinamico,
        a.cMensaje,
        a.nICFecha,
        A.NDIASATRASO,
        A.bMiVivienda,
        pdHoy=@dHoy,
        a.nTasaIC ,
        a.nTasaIG ,
        a.nPrimeraCuotaVencer,
        a.nSaldoInicial,
        a.dFechaInicial,
        a.nPrdConceptoCod,
        DeudaProxCuota = 
			CASE 
				WHEN  a.nCuota =a.nNroProxCuota  
					THEN 
						CASE 
							WHEN a.nPrdConceptoCod =1100 
								THEN 
									ROUND(a.nMonto - a.nMontoPagado,2) 
																--- 
																--		CASE 
																--			WHEN a.dVenc>=@dHoy 
																--				THEN 
																--					CASE 
																--						WHEN @bPuntualito=1 
																--							THEN
																--								CASE 
																--									WHEN (a.PorPagar=0 and nMontoBonoCE >=0) 
																--										THEN 0 
																--									ELSE a.nMontoBonoCE 
																--								END
																--						ELSE a.nMontoBonoCE 
																--					END
																--			ELSE 0 
																--		END  
																+ a.nMontoPar - a.nMontoParPagado 
							ELSE 
								ROUND(IIF(a.nMonto < 0, 0, a.nMonto) - a.nMontoPagado ,2)  
																	---	CASE 
																	--		WHEN a.dVenc>=@dHoy AND @bPuntualito=1 AND @nEstado=0 
																	--			THEN
																	--				CASE 
																	--					WHEN @nXPagarIC > 0 OR a.PorPagar =0  
																	--						THEN 0 
																	--					ELSE 
																	--						CASE 
																		
																	--							WHEN BAPLICABONO=1 
																	--								THEN a.nMontoBonoCE 
																	--							ELSE 0 
																	--						END
																	--			   END
																	--			ELSE 0 
																	--	END  
																	+ a.nMontoPar - a.nMontoParPagado 
						END
				ELSE 0 							
			END , 
		MontoCredi =
			CASE 
				WHEN  a.nCuota =a.nNroProxCuota  
					THEN 
						CASE 
							WHEN a.nPrdConceptoCod =1100 
								THEN 
									--ROUND(a.nMonto - a.nMontoPagado,2) 
																--- 
									CASE 
										WHEN a.dVenc>=@dHoy 
											THEN 
												CASE 
													WHEN @bPuntualito=1 
														THEN
															CASE 
																WHEN (a.PorPagar=0 and a.nMontoBonoCE >=0) 
																	THEN 0 
																ELSE a.nMontoBonoCE 
															END
													ELSE a.nMontoBonoCE 
												END
										ELSE 0 
									END  
																--+ a.nMontoPar - a.nMontoParPagado 
							ELSE 
								--ROUND(a.nMonto - a.nMontoPagado ,2)  -
								CASE 
									WHEN a.dVenc>=@dHoy AND @bPuntualito=1 AND @nEstado=0 
										THEN
											CASE 
												WHEN @nXPagarIC > 0 OR a.PorPagar =0  
													THEN 0 
												ELSE 
													CASE 
																		
														WHEN a.BAPLICABONO =1 
															THEN a.nMontoBonoCE 
														ELSE 0 
													END
											END
										ELSE 0 
								END  
																	--+ a.nMontoPar - a.nMontoParPagado 
						END
				ELSE 0 							
			END,
		MontoDctoPP = CASE 
						WHEN a.nCuota = a.nNroProxCuota AND a.nPrdConceptoCod = 1100 
							THEN a.nMontoDctoPP
						ELSE 0
					END,
		DeudaVencida=
			CASE 
				WHEN  a.dVenc <= @dHoy  -- <
					THEN  ROUND(IIF(a.nMonto < 0, 0, a.nMonto) - a.nMontoPagado,2)+  a.nMontoPar - a.nMontoParPagado - 
						CASE --si justo cae el día de pago, entonces se aplica el dcto x pp
							WHEN a.bAplicaDctoPP = 1 THEN a.nMontoDctoPP
							ELSE 0
						END -
						CASE 
							WHEN a.dVenc=@dHoy AND @bPuntualito=1 
								THEN 
									CASE 
										WHEN a.BAPLICABONO=1 
											THEN a.nMontoBonoCE 
                                        ELSE 0 
                                    END
                            ELSE 
								 	CASE 
										WHEN a.dVenc>=@dHoy 
										--AND nCuota = nUltCuota AND nUltCuota = nCuotaExigible 
										AND @bPuntualito=0 AND a.nPrdConceptoCod = 1100
											THEN a.nMontoBonoCE 																					
										ELSE 0 
									END
							
                         END
                ELSE 0 
			END ,  ----se cambio lo vencido x lo vencido mas lo pendiente(<=)
		bCuotaVencida=
			CASE 
				WHEN  a.dVenc <=@dHoy 
					THEN 1 
                ELSE 0 
   END ,--se cambio lo vencido x lo vencido mas lo pendiente(<=)
		PrePago=
			CASE 				
				WHEN a.nCuota <= a.nPrimeraCuotaVencer +  1 
								--CASE 
								--	WHEN @bBonoBuenPagador =1
								--		THEN A.nCuotaExigible +1
								--	ELSE a.nPrimeraCuotaVencer +  1 
								-- END
					THEN ROUND(IIF(a.nMonto < 0, 0, a.nMonto) - a.nMontoPagado,2) + a.nMontoPar - a.nMontoParPagado 
                ELSE 0 
            END, 
                                  -- case when @bPuntualito =0 then  a.nMontoBonoCE  else 0 end else 0 end)  
		DeudaCancelacion=
			CASE 
				WHEN a.nPrdConceptoCod in (1000,1010) 
					THEN IIF(@nMetodologiaCalendario = 1 and a.nCuota < a.nCuotaExigible and  a.nMonto < 0 and a.nPrdConceptoCod = 1000, 0, a.nMonto) - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado 
																	  -	CASE 
																			WHEN a.dVenc>=@dHoy AND a.nCuota = a.nUltCuota AND a.nUltCuota = a.nCuotaExigible AND @bPuntualito=0
																				THEN a.nMontoBonoCE 																					
																			ELSE 0 
																		END  --todo
                WHEN a.nPrdConceptoCod = 1111 
					THEN   a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado  --todo
				WHEN a.nPrdConceptoCod = 1102 AND @cCtaCod = (SELECT cCtaCod FROM ColocacConvenio WITH(NOLOCK) WHERE cCtaCod = @cCtaCod AND cPersCod = '1083400108553') -- convenio arcijael no se le otorga gracia
					THEN 0
                WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NULL AND ISNULL(a.nPrimeraCuotaVencer, a.nUltCuota) > 1)  
					OR (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NULL AND a.nPrimeraCuotaVencer = 1 AND DATEDIFF(DAY, a.FechaVigencia, @dHoy) - a.nPeriodoGracia > 0) 
                    THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado --ya vencio la gracia
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota and a.ncuota < @nCuotaExigible ) --si mi cuota ya tiene atraso 
						-- se cobra tal cual el calendario
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota and a.ncuota >= @nCuotaExigible and DATEDIFF(D,e.dFechaInicial, @dHoy) - d.nDiasGracia > 0 ) -- si mi cuota es mayor igual a mi exigible, es mayor a la cuota con gracia y ya paso el periodo de gracia.
						-- se calcula el valor a la fecha del IIGracia y se resta al valor calculado original, el resultado se resta al concepto de gracia.
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado - (c.nIIGracia - IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) > 0 ,(COLOCACIONES.Comun_CalculaIntFecha_FN(c.nigracia, a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy))), 0)) 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia > 0) --si mi cuota es la cuota exigible y el cuota que se aplica la gracia
						-- se calcula los dias despues del periodo de gracia y se calcula el IIGracia a la fecha y se resta al valor calculado original, el resultado se resta al concepto de gracia.
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado - (c.nIIGracia - IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) - d.nDiasGracia > 0 ,((COLOCACIONES.Comun_CalculaIntFecha_FN(c.nigracia,a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy) - d.nDiasGracia))), 0)) 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0)
					THEN 
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)           
							 ELSE
								(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
										WHEN DATEDIFF(D,a.dFechaInicial, @dHoy) > 0 
											THEN DATEDIFF(D,a.dFechaInicial, @dHoy) 
										ELSE 0 
									END),2) - a.nMontoPagado)   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM,                     
                        END
                WHEN a.nPrdConceptoCod =1102 AND a.nCuota=a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 AND a.nPeriodoGracia>0  
					THEN   --falta vencer la primera cuota, pero aun no vence la gracia        
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                      
							 ELSE 
							 
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.nMontoCOl,a.NTASAIG,	CASE 
																										WHEN DATEDIFF(D,a.FechaVigencia,@dHoy)>0 
																											THEN DATEDIFF(D,a.FechaVigencia,@dHoy) 
																										ELSE 0 
																									END),2) - a.nMontoPagado   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM,                     
                        END --when a.nPrdConceptoCod =1102  and a.nPrimeraCuotaVencer <>1 then a.nMonto - a.nMontoPagado+ a.nMontoPar - a.nMontoParPagado  --todo                                 
                        --INCLUYE INTERES CORRIDO
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota AND @nCuotaExigible <= d.nCuota)
					THEN
					a.nMontoPagado  * -1
				WHEN a.nPrdConceptoCod = 1102 AND a.nCuota > a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer = 1 AND DATEDIFF(DAY, a.FechaVigencia, @dHoy) - a.nPeriodoGracia <= 0 AND a.nPeriodoGracia > 0  
					AND ISNULL(a.nTipoDesembolso,0) = 0
					THEN   --falta vencer la primera cuota, pero ya realizo pagos en las siguientes cuotas      
					a.nMontoPagado  * -1    
                WHEN a.nPrdConceptoCod =1119 
					THEN round(a.nmonto - a.nMontoPagado,2) + a.nMontoPar - a.nMontoParPagado 

                WHEN a.nPrdConceptoCod = 1100 AND A.dVenc < @dHoy  
					THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado --todo lo vencido.

			 WHEN a.nPrdConceptoCod =1100 
				AND a.nCuota = @nCuotaExigible  
				AND a.nCuotaExigible=a.nUltCuota 
				--AND bAmpliado = 0  -- 13.01.2020   jmlm ft. lgev
				AND ISNULL(a.nTipoDesembolso, 0) <>1 -- a.nPrimeraCuotaVencer 
				-- Cuando se paga ultima cuota y es mayor a periodicidad mensual
				THEN 
					   CASE 
						  WHEN @bCuoMayorMensual = 1 
							AND A.PDHOY < DATEADD(DAY, 1, EOMONTH(A.DVENC, -1))
							 THEN 
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN ( a.NSALDOINICIAL, a.nTasaIC,  CASE 
																							 WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 
																								THEN DATEDIFF(D,a.dFechaInicial,@dHoy) 
																							 ELSE 0 
																						  END),2) - a.nMontoPagado
						  ELSE
							ROUND(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado     
					   END  
                WHEN a.nPrdConceptoCod = 1100 
					AND d.cCtaCod IS NULL
					AND a.nCuota = a.nPrimeraCuotaVencer 
					and a.nPrimeraCuotaVencer = 1 
					and DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia>0 
					THEN  --aún no vence la primera cuota pero si la gracia
						CASE 
							WHEN isnull(a.nTipoDesembolso,0) =1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
							ELSE ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.nMontoCOl ,a.nTasaIC,
								CASE 
									WHEN DATEDIFF(D,a.FechaVigencia,@dHoy) - a.nPeriodoGracia > 0 
										THEN DATEDIFF(D,a.FechaVigencia,@dHoy)- a.nPeriodoGracia
                                    ELSE 0 
                                END),2) - a.nMontoPagado   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM, 
                        END
                 WHEN a.nPrdConceptoCod = 1100 
					AND a.nCuota = a.nPrimeraCuotaVencer  
					AND a.nPrimeraCuotaVencer =1 
					AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 and a.nPeriodoGracia>0  
					THEN 0 --falta vencer la primera cuota, pero aun no vence la gracia                                         
                 WHEN a.nPrdConceptoCod =1100 
					and a.nCuota = @nCuotaExigible  
					and a.nCuotaExigible <> a.nUltCuota
					and d.cCtaCod IS NOT NULL  
					and ((a.nCuota= d.nCuota and DATEDIFF(DAY,a.dFechaInicial,@dHoy)-d.nDiasGracia > 0) or a.nCuota> d.nCuota)  -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
                            ELSE  
								(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 
																												
																								ELSE 0 
																							 --END),2) - a.nMontoPagado - IIF(a.nCuota= d.nCuota, b.nMonto, 0))
																							 END),2) - a.nMontoPagado - IIF(a.nCuota= d.nCuota, d.nigracia + (IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) -d.nDiasGracia > 0,(COLOCACIONES.Comun_CalculaIntFecha_FN(d.nigracia,a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy) -d.nDiasGracia)), 0)), 0))
						END
				 WHEN a.nPrdConceptoCod =1100 
					and a.nCuota = @nCuotaExigible  
					and a.nCuotaExigible <> a.nUltCuota
					and d.cCtaCod IS NULL  -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado, 2)   
							WHEN @cCodProducto = '210'
								THEN  ROUND(a.nMonto - a.nMontoPagado, 2)                                           
                            ELSE  
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																											WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN
																												--CASE 
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																														DATEDIFF(D,a.dFechaInicial,@dHoy) -  CASE 
																																						  WHEN a.nCuotaExigible = 1 THEN a.nPeriodoGracia 
																																						  ELSE 0 
																																					   END
																												--END 

																											ELSE 0 
																										END),2) - a.nMontoPagado 
						END          --se debe calcular a la fechas, saldo capital inicial, TEM,      
				WHEN a.nPrdConceptoCod = 1100 
				AND a.nCuotaExigible = a.nUltCuota 
				AND a.bAmpliado = 1 -- Calculando interés ala fecha para ampliados 
									THEN   --que se trate de la primera cuota a vencer diferente a la primera
										CASE 
											WHEN ISNULL(a.nTipoDesembolso,0) = 1 
												THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
											ELSE  
												ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																															WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN 
																																--CASE
																																--	WHEN @cCodProducto = '210' THEN 1
																																--	ELSE 
																																	   DATEDIFF(D,a.dFechaInicial,@dHoy) 
																																--END 																																
																															ELSE 0 
																														END),2) - a.nMontoPagado 
										END          --se debe calcular a la fechas, saldo capital inicial, TEM, 
				
			 --WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and nCuotaExigible=nUltCuota --AND bAmpliado = 0 -- a.nPrimeraCuotaVencer 
				--THEN 
				--	   CASE 
				--		  WHEN @bCuoMayorMensual = 1 AND A.PDHOY < DATEADD(DAY, 1, EOMONTH(A.DVENC, -1))
				--			 THEN 
				--				ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,  CASE 
				--																			 WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 
				--																				THEN DATEDIFF(D,a.dFechaInicial,@dHoy) 
				--																			 ELSE 0 
				--																		  END),2) - a.nMontoPagado
				--		  ELSE
				--				 round(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado     
				--	   END                                                                
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NOT NULL and a.nCuota = d.nCuota and DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0 -- a.nPrimeraCuotaVencer 
					THEN a.nMontoPagado * -1 --desaguio                                                           
                WHEN a.nPrdConceptoCod =1100 AND a.nCuota > @nCuotaExigible and a.nCuotaExigible<>a.nUltCuota  --a.nPrimeraCuotaVencer 
					THEN a.nMontoPagado * -1 --desaguio          
				WHEN a.nPrdConceptoCod = 1100 AND a.nCuotaExigible= a.nUltCuota AND a.bAmpliado = 1 --DESAGIO PARA AMPLIADOS
					THEN a.nMontoPagado * -1 --desaguio                                                                       
                WHEN a.nPrdConceptoCod IN (1105,1104,1101,1115,1108,1107,1112) 
					THEN round(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado  --todo                      
              
                --WHEN a.nPrdConceptoCod IN (1289,1292,1293,1287,1294,1257,1295,12941) AND a.nCuota<=isnull(a.nPrimeraCuotaVencer,a.nUltCuota) --Verificar cuando el gasto ya esta pagado antes de la operacion
			 --WHEN a.nPrdConceptoCod IN (1289,1292,1293,1287,1294,1257,1295,12941) and a.NCOLOCCALENDESTADO = 0 AND a.nCuota<ISNULL(a.nCuotaExigible,a.nUltCuota) --Verificar cuando el gasto ya esta pagado antes de la operacion					 
				--	THEN
				--		ISNULL(round(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado ,0)                                                   
    --            WHEN a.nPrdConceptoCod =121030 and a.nCuota < a.nCuotaExigible --a.dVenc <@dHoy   
				--	THEN   round(a.nMonto - a.nMontoPagado,2) + a.nMontoPar - a.nMontoParPagado                              
                --WHEN a.nPrdConceptoCod like '12%' and a.nCuota <=isnull(a.nPrimeraCuotaVencer,a.nUltCuota) AND nPrdConceptoCod Not in(1289,1292,1293,1287,1294,1257,1295,121030,12941) 
			 WHEN a.nPrdConceptoCod like '12%' and a.nCuota < a.nCuotaExigible--,a.nUltCuota) AND nPrdConceptoCod Not in(1289,1292,1293,1287,1294,1257,1295,121030,12941) 
					THEN  (a.nMonto - a.nMontoPagado)+(a.nMontoPar-a.nMontoParPagado) 
			 WHEN  a.nPrdConceptoCod like '12%' and a.nCuotaExigible = a.nUltCuota
					THEN  (a.nMonto - a.nMontoPagado)+(a.nMontoPar-a.nMontoParPagado)
                ELSE 0
			END,
		ICCancelacion=  
			CASE 
				WHEN a.nPrdConceptoCod = 1100 AND A.dVenc < @dHoy  
					THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado --todo lo vencido.
                WHEN a.nPrdConceptoCod = 1100 AND d.cCtaCod IS NULL AND a.nCuota = a.nPrimeraCuotaVencer and a.nPrimeraCuotaVencer =1 and DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia>0 
					THEN  --aún no vence la primera cuota pero si la gracia
						CASE 
							WHEN isnull(a.nTipoDesembolso,0) =1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
							ELSE ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.nMontoCOl ,a.nTasaIC,
								CASE 
									WHEN DATEDIFF(D,a.FechaVigencia,@dHoy) - a.nPeriodoGracia > 0 
										THEN DATEDIFF(D,a.FechaVigencia,@dHoy)- a.nPeriodoGracia
                                    ELSE 0 
								END),2) - a.nMontoPagado   -- a.nMonto - a.nMontoPagado       --se debe calcular a la fechas, saldo capital inicial, TEM, 
                        END
                 WHEN a.nPrdConceptoCod =1100 AND a.nCuota = a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 and a.nPeriodoGracia>0  
					THEN 0 --falta vencer la primera cuota, pero aun no vence la gracia                                         
                 WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtaCod IS NOT NULL and ((a.nCuota= d.nCuota and DATEDIFF(DAY,a.dFechaInicial,@dHoy)-d.nDiasGracia > 0) or a.nCuota> d.nCuota)  -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
                            ELSE  
								(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 
																												
																								ELSE 0 
																							 --END),2) - a.nMontoPagado - IIF(a.nCuota= d.nCuota, b.nMonto, 0))
																							 END),2) - a.nMontoPagado - IIF(a.nCuota= d.nCuota, d.nigracia + (IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) -d.nDiasGracia > 0,(COLOCACIONES.Comun_CalculaIntFecha_FN(d.nigracia,a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy) -d.nDiasGracia)), 0)), 0))
                        END 
				 WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtaCod IS NULL  -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado, 2)  
							WHEN @cCodProducto = '210'
								THEN  ROUND(a.nMonto - a.nMontoPagado, 2)                                          
                            ELSE  
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 
																												
																								ELSE 0 
																							 END),2) - a.nMontoPagado 
 END          --se debe calcular a la fechas, saldo capital inicial, TEM,   
						
				WHEN a.nPrdConceptoCod =1100 AND a.nCuotaExigible = a.nUltCuota AND a.bAmpliado = 1 -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
                            ELSE  
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN 
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 																												
																								ELSE 0 
																							 END),2) - a.nMontoPagado 
 END          --se debe calcular a la fechas, saldo capital inicial, TEM,      
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible = a.nUltCuota -- a.nPrimeraCuotaVencer 
					THEN round(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado                                                               
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NOT NULL and a.nCuota = d.nCuota and DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0 -- a.nPrimeraCuotaVencer 
					THEN a.nMontoPagado * -1 --desaguio                                                                                                    
                WHEN a.nPrdConceptoCod =1100 AND a.nCuota > @nCuotaExigible and a.nCuotaExigible <> a.nUltCuota --a.nPrimeraCuotaVencer 
					THEN a.nMontoPagado * -1 --desaguio  					
				WHEN a.nPrdConceptoCod =1100 AND a.nCuotaExigible =a.nUltCuota AND a.bAmpliado = 1 --DESAGIO PARA AMPLIADOS
					THEN a.nMontoPagado * -1 --desaguio             
                ELSE 0
			END,
		IGCancelacion=
			CASE 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NULL AND ISNULL(a.nPrimeraCuotaVencer, a.nUltCuota) > 1)  
					OR (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NULL AND a.nPrimeraCuotaVencer = 1 AND DATEDIFF(DAY, a.FechaVigencia, @dHoy) - a.nPeriodoGracia > 0) 
					THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado --ya vencio la gracia
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota and a.ncuota < @nCuotaExigible ) --si mi cuota ya tiene atraso 
						-- se cobra tal cual el calendario
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota and a.ncuota >= @nCuotaExigible and DATEDIFF(D,e.dFechaInicial, @dHoy) - d.nDiasGracia > 0 ) -- si mi cuota es mayor igual a mi exigible, es mayor a la cuota con gracia y ya paso el periodo de gracia.
						-- se calcula el valor a la fecha del IIGracia y se resta al valor calculado original, el resultado se resta al concepto de gracia.
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado - (c.nIIGracia - IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) > 0 ,(COLOCACIONES.Comun_CalculaIntFecha_FN(c.nigracia, a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy))), 0)) 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia > 0) --si mi cuota es la cuota exigible y el cuota que se aplica la gracia
						-- se calcula los dias despues del periodo de gracia y se calcula el IIGracia a la fecha y se resta al valor calculado original, el resultado se resta al concepto de gracia.
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado - (c.nIIGracia - IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) - d.nDiasGracia > 0 ,((COLOCACIONES.Comun_CalculaIntFecha_FN(c.nigracia,a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy) - d.nDiasGracia))), 0)) 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0)
					THEN 
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                      
							 ELSE 
								(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
										WHEN DATEDIFF(D,a.dFechaInicial, @dHoy) > 0 
											THEN DATEDIFF(D,a.dFechaInicial, @dHoy) 
										ELSE 0 
									END),2) - a.nMontoPagado)  -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM,                     
                        END
                WHEN a.nPrdConceptoCod =1102 AND a.nCuota=a.nPrimeraCuotaVencer  and a.nPrimeraCuotaVencer =1 and DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 and a.nPeriodoGracia>0  
					THEN   --falta vencer la primera cuota, pero aun no vence la gracia
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) =1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
                             ELSE ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.nMontoCOl,a.NTASAIG,CASE 
																										WHEN DATEDIFF(D,a.FechaVigencia,@dHoy)>0 
																											THEN DATEDIFF(D,a.FechaVigencia,@dHoy) 
																										ELSE 0 
																									END),2) - a.nMontoPagado   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM,               
                        END  
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota AND @nCuotaExigible <= d.nCuota)
					THEN
						a.nMontoPagado  * -1
				WHEN a.nPrdConceptoCod =1102 AND a.nCuota>a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 AND a.nPeriodoGracia>0  
					and ISNULL(a.nTipoDesembolso,0) = 0
					THEN   --falta vencer la primera cuota, pero ya realizo pagos en las siguientes cuotas      
						a.nMontoPagado  * -1                                   
				ELSE 0
			END,
		IMoratorio=
			CASE 
				WHEN a.nPrdConceptoCod =1101 
					THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado 
            END,
		IntGastosFecha = 
		CASE 

				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NULL AND ISNULL(a.nPrimeraCuotaVencer, a.nUltCuota) > 1)  
					OR (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NULL AND a.nPrimeraCuotaVencer = 1 AND DATEDIFF(DAY, a.FechaVigencia, @dHoy) - a.nPeriodoGracia > 0) 
							THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado --ya vencio la gracia
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota and a.ncuota < @nCuotaExigible ) --si mi cuota ya tiene atraso 
						-- se cobra tal cual el calendario
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota and a.ncuota >= @nCuotaExigible and DATEDIFF(D,e.dFechaInicial, @dHoy) - d.nDiasGracia > 0 ) -- si mi cuota es mayor igual a mi exigible, es mayor a la cuota con gracia y ya paso el periodo de gracia.
						-- se calcula el valor a la fecha del IIGracia y se resta al valor calculado original, el resultado se resta al concepto de gracia.
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado - (c.nIIGracia - IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) > 0 ,(COLOCACIONES.Comun_CalculaIntFecha_FN(c.nigracia, a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy))), 0)) 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia > 0) --si mi cuota es la cuota exigible y el cuota que se aplica la gracia
						-- se calcula los dias despues del periodo de gracia y se calcula el IIGracia a la fecha y se resta al valor calculado original, el resultado se resta al concepto de gracia.
						THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado - (c.nIIGracia - IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) - d.nDiasGracia > 0 ,((COLOCACIONES.Comun_CalculaIntFecha_FN(c.nigracia,a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy) - d.nDiasGracia))), 0)) 
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota = d.nCuota AND DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0)
					THEN 
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                      
							 ELSE 
								(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
										WHEN DATEDIFF(D,a.dFechaInicial, @dHoy) > 0 
											THEN DATEDIFF(D,a.dFechaInicial, @dHoy) 
										ELSE 0 
									END),2) - a.nMontoPagado)   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM,                     
                        END
				WHEN a.nPrdConceptoCod =1102 AND a.nCuota = a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 AND a.nPeriodoGracia>0  
					THEN   --falta vencer la primera cuota, pero aun no vence la gracia        
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) =1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
							ELSE ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.nMontoCOl,a.NTASAIG,	CASE 
																										WHEN DATEDIFF(D,a.FechaVigencia,@dHoy)>0 
																											THEN DATEDIFF(D,a.FechaVigencia,@dHoy) 
																										ELSE 0 
																									END),2) - a.nMontoPagado   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM,                     
						END --when a.nPrdConceptoCod =1102  and a.nPrimeraCuotaVencer <>1 then a.nMonto - a.nMontoPagado+ a.nMontoPar - a.nMontoParPagado  --todo                                 
							--INCLUYE INTERES CORRIDO
				WHEN (a.nPrdConceptoCod = 1102 AND d.cCtaCod IS NOT NULL AND a.nCuota > d.nCuota AND @nCuotaExigible <= d.nCuota)
					THEN
						a.nMontoPagado  * -1
				WHEN a.nPrdConceptoCod =1102 AND a.nCuota>a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 AND a.nPeriodoGracia>0  
					and ISNULL(a.nTipoDesembolso,0) = 0
					THEN   --falta vencer la primera cuota, pero ya realizo pagos en las siguientes cuotas      
						a.nMontoPagado  * -1 
				WHEN a.nPrdConceptoCod =1119 
					THEN round(a.nmonto - a.nMontoPagado,2) + a.nMontoPar - a.nMontoParPagado 
				WHEN a.nPrdConceptoCod = 1100 AND a.dVenc < @dHoy  
					THEN a.nMonto - a.nMontoPagado + a.nMontoPar - a.nMontoParPagado --todo lo vencido.
                WHEN a.nPrdConceptoCod = 1100 AND d.cCtaCod IS NULL AND a.nCuota = a.nPrimeraCuotaVencer and a.nPrimeraCuotaVencer =1 and DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia>0 
					THEN  --aún no vence la primera cuota pero si la gracia
						CASE 
							WHEN isnull(a.nTipoDesembolso,0) =1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
							ELSE ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.nMontoCOl ,a.nTasaIC,
								CASE 
									WHEN DATEDIFF(D,a.FechaVigencia,@dHoy) - a.nPeriodoGracia > 0
										THEN  DATEDIFF(D,a.FechaVigencia,@dHoy)- a.nPeriodoGracia
                                    ELSE 0 
                  END),2) - a.nMontoPagado   -- a.nMonto - a.nMontoPagado         --se debe calcular a la fechas, saldo capital inicial, TEM, 
                        END
                 WHEN a.nPrdConceptoCod =1100 AND a.nCuota = a.nPrimeraCuotaVencer  AND a.nPrimeraCuotaVencer =1 AND DATEDIFF(DAY,a.FechaVigencia,@dHoy)-a.nPeriodoGracia<=0 and a.nPeriodoGracia>0  
					THEN 0 --falta vencer la primera cuota, pero aun no vence la gracia                                      
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NOT NULL and ((a.nCuota= d.nCuota and DATEDIFF(DAY,a.dFechaInicial,@dHoy)-d.nDiasGracia > 0) or a.nCuota> d.nCuota)  -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)                                          
                            ELSE  
								(ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 
																												
																								ELSE 0 
																							 END),2) - a.nMontoPagado - IIF(a.nCuota= d.nCuota, d.nigracia + (IIF(DATEDIFF(D,a.dFechaInicial,@dHoy) -d.nDiasGracia > 0,(COLOCACIONES.Comun_CalculaIntFecha_FN(d.nigracia,a.nTasaIC, DATEDIFF(D,a.dFechaInicial,@dHoy) -d.nDiasGracia)), 0)), 0))
                        END 
				 WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtaCod IS NULL  -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)   
							WHEN @cCodProducto = '210'
								THEN   ROUND(a.nMonto - a.nMontoPagado ,2)                                         
                            ELSE  
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN 
																								    --CASE 
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																										  DATEDIFF(D,a.dFechaInicial,@dHoy) 
																								    --END 
																												
																								ELSE 0 
																							 END),2) - a.nMontoPagado 
                        END          --se debe calcular a la fechas, saldo capital inicial, TEM,   
				WHEN a.nPrdConceptoCod =1100 AND a.nCuotaExigible =a.nUltCuota AND a.bAmpliado = 1 -- a.nPrimeraCuotaVencer 
					THEN   --que se trate de la primera cuota a vencer diferente a la primera
						CASE 
							WHEN ISNULL(a.nTipoDesembolso,0) = 1 
								THEN  ROUND(a.nICParcial - a.nMontoPagado ,2)    							                              
                            ELSE  
								ROUND(COLOCACIONES.Comun_CalculaIntFecha_FN(a.NSALDOINICIAL,a.nTasaIC,	CASE 
																								WHEN DATEDIFF(D,a.dFechaInicial,@dHoy)>0 THEN 
																								    --CASE
																												--	WHEN @cCodProducto = '210' THEN 1
																												--	ELSE 
																										  DATEDIFF(D,a.dFechaInicial, @dHoy)  
																								    --END 
																								ELSE 0 
																							 END),2) - a.nMontoPagado 
                        END          --se debe calcular a la fechas, saldo capital inicial, TEM,      
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible = a.nUltCuota -- a.nPrimeraCuotaVencer 
					THEN round(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado                          
				WHEN a.nPrdConceptoCod =1100 and a.nCuota = @nCuotaExigible  and a.nCuotaExigible <> a.nUltCuota and d.cCtacod IS NOT NULL and a.nCuota = d.nCuota and DATEDIFF(DAY,a.dFechaInicial, @dHoy) - d.nDiasGracia <= 0 -- a.nPrimeraCuotaVencer 
					THEN a.nMontoPagado * -1 --desaguio                               
                WHEN a.nPrdConceptoCod =1100 AND a.nCuota > @nCuotaExigible and a.nCuotaExigible <> a.nUltCuota --a.nPrimeraCuotaVencer 
					THEN a.nMontoPagado * -1 --desaguio   					
				WHEN a.nPrdConceptoCod =1100 AND a.nCuotaExigible = a.nUltCuota AND a.bAmpliado = 1 --DESAGIO PARA AMPLIADOS
					THEN a.nMontoPagado * -1 --desaguio                                                                                     
                 WHEN a.nPrdConceptoCod IN (1105,1104,1101,1115,1108,1107,1112) 
					THEN round(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado  --todo                      
                --WHEN a.nPrdConceptoCod IN (1289,1292,1293,1287,1294,1257,1295,12941) AND a.nCuota<=isnull(a.nPrimeraCuotaVencer,a.nUltCuota) --Verificar cuando el gasto ya esta pagado antes de la operacion
			 --WHEN a.nPrdConceptoCod IN (1289,1292,1293,1287,1294,1257,1295,12941) and a.NCOLOCCALENDESTADO = 0 AND a.nCuota<ISNULL(a.nCuotaExigible,a.nUltCuota) --Verificar cuando el gasto ya esta pagado antes de la operacion					 
				--	THEN
				--		ISNULL(round(a.nMonto - a.nMontoPagado,2)  + a.nMontoPar - a.nMontoParPagado ,0)                                                   
    --            WHEN a.nPrdConceptoCod =121030 and a.nCuota < a.nCuotaExigible --a.dVenc <@dHoy   
				--	THEN   round(a.nMonto - a.nMontoPagado,2) + a.nMontoPar - a.nMontoParPagado                              
                --WHEN a.nPrdConceptoCod like '12%' and a.nCuota <=isnull(a.nPrimeraCuotaVencer,a.nUltCuota) AND nPrdConceptoCod Not in(1289,1292,1293,1287,1294,1257,1295,121030,12941) 
			 WHEN a.nPrdConceptoCod like '12%' and a.nCuota < a.nCuotaExigible--,a.nUltCuota) AND nPrdConceptoCod Not in(1289,1292,1293,1287,1294,1257,1295,121030,12941) 
					THEN  a.nMonto - a.nMontoPagado 
			 WHEN  a.nPrdConceptoCod like '12%' and a.nCuotaExigible = a.nUltCuota
					THEN  a.nMonto - a.nMontoPagado 
                ELSE 0
			END
	INTO #datos                       
	FROM #DatosTemp a
		LEFT JOIN #DatosTemp b
			on b.cCtaCod = a.cCtaCod
			and b.nNroCalen = a.nNroCalen
			and b.nColocCalendApl = a.nColocCalendApl
			and b.nCuota = a.nCuota
			and b.nPrdConceptoCod = 1102
		LEFT JOIN ColocCalendInteresInteresGracia c WITH(NOLOCK)
			on c.cCtaCod = b.cCtaCod
			and c.nNroCalen = b.nNroCalen
			and c.nCuota = b.nCuota
		LEFT JOIN ColocCalendInteresInteresGracia d WITH(NOLOCK)
			on d.cCtaCod = b.cCtaCod
			and d.nNroCalen = b.nNroCalen
			and d.nDiasGracia > 0
		LEFT JOIN #DatosTemp e
			on e.cCtaCod = d.cCtaCod
			and e.nNroCalen = d.nNroCalen
			and e.nCuota = d.nCuota
			and e.nPrdConceptoCod = 1102
	WHERE a.nCuota >=	CASE 
							WHEN EXISTS(SELECT * FROM #DatosTemp x WHERE x.NDIASATRASO>0)
								THEN  a.nNroProxCuota 
							ELSE a.nCuotaExigible
						END
             AND a.nColocCalendApl =1
	ORDER BY a.nCuota ASC 

	--select * from #datos order by nCuota

	IF @nCalenDin = 1   
		BEGIN
			DECLARE @nIntFechaCalenDin MONEY
			EXEC COLOCACIONES.ObtieneInteresFecha_SP @cCtaCod,@nIntFechaCalenDin OUTPUT
			UPDATE #datos
				SET DeudaCancelacion		= @nIntFechaCalenDin,
					ICCancelacion			= @nIntFechaCalenDin,
					IntGastosFecha			= @nIntFechaCalenDin
					--DeudaCancelacion    = nSaldo + @nIntFechaCalenDin
			WHERE nCuota =1 
				AND nPrdConceptoCod = 1100		
			
			--SELECT @nIntFechaCalenDin nIntFechaCalenDin	
		END
             
	DECLARE @nCuota			INT, 
			@bUltimaCuota	BIT,
            @nMontoBono		MONEY,
            @nUltCuota		INT

	SELECT 
		@nUltCuota=MAX(nPrimeraCuotaVencer) 
	FROM #datos 
	WHERE cctacod=@cCtaCod 
       
	SELECT 
		@nCuota=MAX(ncuota) 
	FROM #datos 
	WHERE cctacod=@cCtaCod 

	SELECT 
		@bUltimaCuota =	CASE 
							WHEN @nCuota =@nUltCuota 
								THEN 1 
							ELSE 0 
						END 

	SELECT 
		@nMontoBono= MAX(nMontoBonoCE) 
	FROM #DatosTemp 
	WHERE cctacod=@cCtaCod 
       
	UPDATE #datos 
		SET deudacancelacion  =	CASE 
									WHEN  ncuota= nnroproxcuota AND nprdconceptocod=1100 
										THEN 
											CASE 
												WHEN deudacancelacion < 0 and dvenc <= @dHoy 
													THEN 0 
                                                ELSE deudacancelacion 
											END
                                    ELSE deudacancelacion 
								END 
    --INICIO ------------------------ REDONDEO MONTOS DEUDA CANCELACION

	  -- UPDATE #datos 
			--SET deudacancelacion =ROUND(DeudaCancelacion,2,0)
	
	--FIN ----------------------------REDONDEO MONTOS DEUDA CANCELACION   

	SELECT 
		t.cCtaCod, 
        t.nNroProxCuota, 
        t.nSaldo, 
        t.Moneda,
        t.nDiasAtraso ,
 VencProxCuota=t.dVencProxCuota,
        DOI=@cDOI,
        UltCuota=T.nUltCuota,
        T.CodigoCliente,
        Cliente=
			CASE 
				WHEN t.nPersPersoneria=1 
					THEN 
						ISNULL(dbo.FN_PatMatCasNom(1,t.nPersPersoneria, T.Cliente),'') +  ' ' + 
                        REPLACE(ISNULL(dbo.FN_PatMatCasNom(2,t.nPersPersoneria, T.Cliente),''),'-','') +  ' '  + 
                        REPLACE(ISNULL(dbo.FN_PatMatCasNom(3,t.nPersPersoneria, T.Cliente),''),'-','') + ', '  + 
                        ISNULL(dbo.FN_PatMatCasNom(4,t.nPersPersoneria, T.Cliente),'')
                ELSE
						ISNULL(dbo.FN_PatMatCasNom(1,t.nPersPersoneria, T.Cliente),'')
			END,
		DeudaProxCuota,
        DeudaImpaga=
			CASE 
				WHEN DeudaVencida>0 
					THEN DeudaVencida 
                ELSE DeudaProxCuota - BonoCredi - DctoPagoPuntual
            END,   
		PrePago=CASE WHEN DeudaCancelacion<=PrePago THEN 0 WHEN PrePago = 0 THEN 0 ELSE round(PrePago + 0.01,2) END,
		MontoColocado=t.nMontoDesembolsado,
        DeudaCancelacion,
		ICCancelacion,
		IGCancelacion,
		IntGastosFecha,
		--DeudaCancelacion=
		--	CASE 
		--		WHEN t.cmensaje='S' and t.nCalendDinamico=0 
		--			THEN DeudaCancelacion - ICCancelacion +  t.nicfecha
		--              ELSE DeudaCancelacion 
		--           END,                       
		NroCuotaImpMin=CASE WHEN DeudaVencida>0 THEN NroCuotaVencMin ELSE t.nNroProxCuota END,
		NroCuotaImpMax=CASE WHEN DeudaVencida>0 THEN NroCuotaVencMax ELSE t.nNroProxCuota END,
		EstadoCuenta,
		NombreProducto = @cNombreProducto,
		CodigoMoneda,
		ComportamientoPago,
		cOpeCod=@cOpeCod,
		NIMoratorio=IMoratorio,
		bBonoBP,
		bMiVivienda
	INTO #TBDatCredito
	FROM 
		(
			SELECT 
				a.cCtaCod,
                a.nMontoDesembolsado,
				a.dVencProxCuota,
                a.nUltCuota, 
                a.nCalendDinamico,
                a.cmensaje,
   a.nICFEcha,
                a.nNroProxCuota,    
                b.nSaldo,
                A.NDIASATRASO,
                CodigoCliente=d.cperscod,
                Cliente=d.cpersnombre,
                d.nPersPersoneria ,
                CodigoMoneda=CAST(SUBSTRING(a.cctacod,9,1) as int),
                Moneda=case when SUBSTRING(a.cctacod,9,1)='1' then 'SOLES' ELSE 'DOLARES' END,   
                DeudaProxCuota=SUM(a.DeudaProxCuota), 
                --DeudaVencida=SUM(DeudaVencida), 
				DeudaVencida=SUM(CASE WHEN @bCondRecup = 1 THEN (CASE WHEN a.nCuota <= @nCuotaRecup THEN DeudaVencida ELSE 0 END) ELSE DeudaVencida END), 
				BonoCredi = SUM(a.MontoCredi),
				DctoPagoPuntual = SUM(a.MontoDctoPP),
                PrePago=SUM(a.Prepago),
                DeudaCancelacion=SUM(a.DeudaCancelacion), -- IIF(SUM(IGCancelacion) < 0, SUM(IGCancelacion), 0),
                ICCancelacion= SUM(a.ICCancelacion),
                IGCancelacion= SUM(a.IGCancelacion),--IIF(SUM(IGCancelacion) < 0, 0, SUM(IGCancelacion)), desagio de gracia
				IntGastosFecha = IIF(@bAmpliado = 1 AND SUM(a.IntGastosFecha) < 0, 0, SUM(a.IntGastosFecha)) ,  --IIF(SUM(IGCancelacion) < 0, SUM(IGCancelacion), 0),
                NroCuotaVencMin=MIN(case when a.bCuotaVencida=1 then nCuota end),
                NroCuotaVencMax=MAX(case when a.bCuotaVencida=1 then nCuota end),
                EstadoCuenta=e.cConsDescripcion ,
                ComportamientoPago=COLOCACIONES.PAGO_SELTIPOCOMPORTAMIENTO_FN(A.cCtaCod, A.bMiVivienda, cc.nCalendDinamico, cc.IdCampana,@cCodProducto,cc.nDiasAtraso) ,
                IMoratorio=SUM(a.IMoratorio),
                ISNULL (G.bBonoBP,0) as bBonoBP,
            a.bMiVivienda AS bMiVivienda
			FROM #datos a
				INNER JOIN producto b WITH(NOLOCK)
					ON a.cctacod=b.cCtaCod 
                INNER JOIN ColocacCred cc WITH(NOLOCK)
					ON b.cCtaCod =cc.cCtaCod   
                INNER JOIN ProductoPersona c WITH(NOLOCK)
					ON b.cCtaCod =c.cCtaCod and c.nPrdPersRelac =20
                INNER JOIN persona d WITH(NOLOCK)
					ON c.cPersCod =d.cPersCod 
                INNER JOIN Constante e 
					ON b.nPrdEstado =e.nConsValor 
						AND e.nConsCod =3001
          LEFT JOIN ColocGestionMontoHipotecario G WITH(NOLOCK)
					ON G.cCtaCod = b.cCtaCod 
						AND G.dFechaActualiza=(SELECT MAX(dFechaActualiza) FROM ColocGestionMontoHipotecario WITH(NOLOCK) WHERE cCtaCod=b.cCtaCod) 
			GROUP BY 
				a.cCtaCod, 
                a.nMontoDesembolsado,
                a.dVencProxCuota,
                a.nUltCuota,
                a.nCalendDinamico,
                a.cmensaje,a.nICFEcha,
                a.nNroProxCuota,
                b.nsaldo,
                A.NDIASATRASO,
                d.cperscod,
                d.cpersnombre,
                d.nPersPersoneria,
                e.cConsDescripcion,
                a.bMiVivienda,
                cc.nCalendDinamico, 
                cc.IdCampana ,
                cc.nDiasAtraso,
                G.bBonoBP 
		) t
       --select * from #ColocCalendDet
             
	--IF @nCalenDin = 1   
	--BEGIN
	--	DECLARE @nIntFechaCalenDin MONEY
 --       EXEC COLOCACIONES.ObtieneInteresFecha_SP @cCtaCod,@nIntFechaCalenDin OUTPUT
	--	UPDATE #TBDatCredito
	--		SET ICCancelacion		= @nIntFechaCalenDin,
	--			DeudaCancelacion    = nSaldo + @nIntFechaCalenDin
	--END
	      
	DECLARE 
		@pnMontoBonoCalen   DECIMAL(18,2) = 0,
		@pnMontoBonoFecha   DECIMAL(18,2) = 0,
		@nDeudaCancela      DECIMAL(18,2) = 0,
		@pnMontoDctoCuotaPP   DECIMAL(18,2) = 0

	SELECT 
		@nDeudaCancela=ISNULL(DeudaCancelacion,0) 
	FROM #TBDatCredito

	-- ES CREDIEMPRENDE BY JHCC
	IF EXISTS ( SELECT 
					1 
				FROM ColocacCred A WITH(NOLOCK)
					INNER JOIN ColocProductoComer B WITH(NOLOCK)
						ON A.cCtaCod = B.cCtaCod 
                WHERE A.cCtaCod = @cCtaCod 
					AND A.IdCampana = 87 
                    AND LEFT(B.cSubProducto,3) ='211') AND @nDiasAtraso BETWEEN -31 AND 0 AND @bPagosAnticipados = 0
	BEGIN
		SET @bCrediemp = 1  
	END
	ELSE
	BEGIN
        SET @bCrediemp = 0
	END

       -- JHCC
	IF @bPuntualito = 1
	BEGIN
		EXEC COLOCACIONES.SelBonoCalenFechaPuntualito_SP @cCtaCod,@pnMontoBonoCalen OUT,@pnMontoBonoFecha OUT    
	END     

	IF @bCrediemp = 1 OR @bPuntualito = 1
	BEGIN
		INSERT INTO #DatosCrediemprende (nNroCalen, nNumeroCuota, nCapital, nInteresCompensatorio, nInteresMoratorio, nBonoCrediemprende, nUltima)
		
		--EXEC PA_RecuperaMontoCrediemprende @cCtaCod, @bPuntualito
		SELECT nNroCalen, nNumeroCuota, nCapital, nInteresCompensatorio, nInteresMoratorio, nBonoCrediemprende, nUltima FROM [DBO].[FN_RecuperaMontoCrediemprende] (@cCtaCod, @bPuntualito)

		SET @nBonoCalen = ISNULL((SELECT nBonoCrediemprende FROM #DatosCrediemprende), 0)
	END 

	--SELECT @pnMontoBonoCalen pnMontoBonoCalen ,@pnMontoBonoFecha pnMontoBonoFecha 
       
	IF EXISTS (SELECT B.cCtaCod
				FROM ColocacCred A WITH(NOLOCK)
					INNER JOIN ColocCalendDetPagoPuntual B WITH(NOLOCK)
						ON A.cCtaCod = B.cCtaCod AND A.nNroCalen = B.nNroCalen
                WHERE A.cCtaCod = @cCtaCod) AND @bAmpliado = 0
	BEGIN
		SET @bDctoPP = 1

		SELECT @pnMontoDctoCuotaPP = ISNULL(P.nMonto - P.nMontoPagado, 0)
		FROM ColocacCred A WITH(NOLOCK)
			INNER JOIN (SELECT M.cCtaCod, MIN(N.nCuota) AS nCuota
						FROM ColocacCred M WITH(NOLOCK)
							INNER JOIN ColocCalendario N WITH(NOLOCK) ON M.cCtaCod = N.cCtaCod AND M.nNroCalen = N.nNroCalen AND N.nColocCalendApl = 1
						WHERE M.cCtaCod = @cCtaCod AND N.nColocCalendEstado = 0
						GROUP BY M.cCtaCod
			) T ON A.cCtaCod = T.cCtaCod
			INNER JOIN ColocCalendDetPagoPuntual P WITH(NOLOCK)
				ON A.cCtaCod = P.cCtaCod AND A.nNroCalen = P.nNroCalen AND P.nCuota = T.nCuota
		WHERE A.cCtaCod = @cCtaCod

		UPDATE A
		SET
			A.DeudaCancelacion = A.DeudaCancelacion - IIF(A.NDIASATRASO <= @nDiasAtrasoMaximoPP, @pnMontoDctoCuotaPP, 0)
		FROM
			#TBDatCredito A
		WHERE 
		@nCuotaExigible = @nUltimaCuotaCalendario
	END
	ELSE
	BEGIN
        SET @bDctoPP = 0
		SET @pnMontoDctoCuotaPP = 0
	END

	--SELECT @pnMontoDctoCuotaPP pnMontoBonoCuotaPP

	DECLARE @NPLAZO INT        

	SELECT 
          @NPLAZO = CASE 
						WHEN A.nPlazo = 0 THEN 30
                ELSE A.nPlazo
                    END
	FROM ColocacEstado A WITH(NOLOCK)
	WHERE A.cCtaCod = @cCtaCod
		AND A.nPrdEstado = 2002
       
	--INICIO
	SET @pbAprobComisionCanc=IIF(EXISTS(SELECT 1 FROM ColocRegistroComisionCancelacion WITH(NOLOCK) WHERE cctacod=@cCtaCod AND nEstadoRegistro=0),1,0)
	SET @bAplicaCancelacionAnticipada = CASE WHEN @nCuotaExigible < @nUltimaCuotaCalendario THEN 1 ELSE 0 END 
	--FIN
    
	--select * from #TBDatCredito
		                                                                              
	SELECT 
		*,
		--CASE WHEN ICCancelacion > 0
		--	THEN 0
		--	ELSE
		--		ICCancelacion
		--END IntDesagio,
        @NPLAZO nPlazo,
        @pnMontoBonoCalen nMontoCuotaBP,
        @pnMontoBonoFecha nMontoFechaBP,
        @bPuntualito bPuntualito,
        @bCrediemp  bCrediemp,
        @nCalPago    CalPago,
        @AgenciaCredito NombreAgencia,
        ROUND((DeudaCancelacion - @pnMontoBonoFecha),2) 'DeudaCancelacionNeto',
		'DeudaImpagaNeta' = DeudaImpaga,
		@bAmpliado bAmpliado,
		dbo.CuotaAprobada(cCtaCod) as CuotaAprobada,
		@pbAprobComisionCanc pbAprobComisionCanc,
		@bAplicaCancelacionAnticipada bAplicaCancelacionAnticipada,
		@nBonoCalen nBonoCalen,
		@nCuotaExigible nCuotaExigible,
		@nMontoVencido nMontoVencido,
		@nMontoPago1CuotaNoVencida nMontoPago1CuotaNoVencida,
		@nMontoPago2CuotasNoVencidas nMontoPago2CuotasNoVencidas,
		@bCondRecup AS bCondRecup,
        @pnMontoDctoCuotaPP nMontoDctoCuotaPP,
        @bDctoPP  bDctoPP
		--@nMonto2CuotasNoVencidas nMonto2CuotasNoVencidas
	INTO #DatosPagosFinal 
	FROM #TBDatCredito	A

	
	DECLARE @cProductoExoItf	VARCHAR(MAX)

	SELECT 
		@cProductoExoItf= A.nConsSisValor 
	FROM ConstSistema A 
	WHERE A.nConsSisCod = 4415

	IF	NOT EXISTS(SELECT 1 FROM dbo.fn_Split(@cProductoExoItf,',') WHERE Items = @cCodProducto) OR EXISTS(SELECT cCtaCod FROM Colocaciones WITH(NOLOCK) WHERE cCtaCod = @cCtaCod AND nTipoCreditos IN (9))
	BEGIN
		UPDATE A
			SET DeudaImpagaNeta= A.DeudaImpaga + dbo.ITFImpuesto(A.DeudaImpaga),
				DeudaCancelacionNeto = DeudaCancelacionNeto + dbo.ITFImpuesto(A.DeudaCancelacionNeto)
		FROM #DatosPagosFinal A
	END

	SELECT * 
	FROM #DatosPagosFinal
	
	-- end JHCC 

	DROP TABLE #datos,#DATOSPAGO,#TBDatCredito,#DatosTemp,#DatosPagosFinal, #DatosCrediemprende

END ---/lóxica anterior 17/12/2020

END

