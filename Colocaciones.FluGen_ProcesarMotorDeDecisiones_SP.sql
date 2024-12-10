/******************************************************************************************************          
'      Copyright           :  CMAC ICA - 2016 / Todos los derechos reservados          
'      Nombre del PA       :  Colocaciones.FluGen_ProcesarMotorDeDecisiones_SP          
'      Descripción         :  PROCESA LAS REGLAS CORRESPONDIENTES EN BASE AL MOTOR DE DECISIONES          
'                
'      Autor / Fecha       :  LGEV  /   2016-11-07          
'      Aplicativo / Módulo :  SICMACI / Colocaciones       
'          
'      Control de Cambios  :             
'   Fecha Autor  Descripción                                         
        --------------------------------------------------------------------------------------          
  20/02/2017  JHCC  CORRECCIÓN EN EL LA CONVERSIÓN DE TIPO DE DATO          
  21/02/2017  JPPG  MAXIMO NUMERO DE CODEUDORES          
  22/02/2017  JPPG  CORRECCCION REGLA DESGRAVAMEN , INCIDENCIA REGLA N°14          
  27/02/2017  JPPG  Se corrige los duplicados para pago adelantado          
  27/03/2017  JPPG  Adecuaciones campaña credi ahorro 2017          
  27/03/2017  JPPG  Adecuaciones campaña dia de la madre 2017          
  10/05/2017  JPPG  Creación de variable 184 (Obtener el indicador de mora del analista)          
  26/05/2017  JPPG  Modificación de variable 182 (Obtener creditos sin garantia hipotecaria)          
  09/06/2017  JPPG  Modificación de variable 179 (En caso de no tener deuda en el mes de la fte ingreso tomara el siguiente mes)          
  28/06/2017  LGEV  Consideracion de nIdGrupo en Join para generacion de mensajes personalizados          
  19/07/2017  LGEV  Calculo de variables para la regla que valida créditos para trabajadores y meses de antiguedad          
                    Configuracion de Mensajes Restrictivos e informativos          
  17/07/2017  JPPG  Ampliar el valor del campo cPersNombre de la tabla temporal #RelPersonaEdad           
  19/07/2017  JPPG  Considerar 2 años maximo de condonocacion de morar para la campaña 133 y 134           
  19/07/2017  JPPG  Campaña 133 para clientes recurrentes debe evaluar el ultimo mes de rcc          
  21/07/2017  JPPG  Variable 173, se considera las garantias no registradas.          
  24/08/2017  JPPG  Variable 58, se actualiza el calculo de la variable segun a la regla 34 de alineasicmact          
  04/10/2017  LGEV Configuracion de gracia por producto          
  20/12/2017  JPPG  Cambios para campaña Escolar 2018 Indigo          
  15/03/2018  MFPE  Se corrige subquery para obtener los intervinientes que no cumplen la regla 41          
  11/04/2018  MFPE  Se corrige obtención del plazo para créditos unicuota con periodo fijo          
  22/08/2018  LFAM  Restriccion de creditos a trabajadores y familiares por productos          
  30/10/2019  JPPG  Requerimiento 29UBO2019 - Reserva de saldo para contratacion          
  13/01/2020  IPAL  Se agrega campaña escolar 2020 a lógica de variable bDetalleCampana          
  01/06/2020  JMLM  Adecuacion para Campaña Reconocemos tu Esfuerzo          
  25/06/2020  JURR  Se agrega campaña FAE          
  07/07/2020  LAMG  Se modifica regla de negocio 23 evaluando 6 meses calificacion externa el producto 320          
  09/09/2020  LAMG  Se considera tarifario especial para clientes recurrentes.          
  20-09-2020  RABC  Para la campaña navideña 2020, se consideran créditos que hayan sido reprogramados, como mínimo con una cuota pagada luego de la reprgramación y que no tengan atraso.           
  22/12/2020  JURR  Cambio FAE II       
  02/04/2021  RABC Se excluyen los créditos coberturados por el estado (FAE y REACTIVA).       
  19/05/2021  JURR Se agrega la relacion de madre por un cambio en el modulo de personas.      
  08/07/2021  RABC  Adecuación para campaña fiestas patrias 2021.      
  20/07/2021  RABC Identificación de fecha de evaluación válida.      
  22/09/2021  DDCC Adecuación de la constante 666 para excepciones      
  23/09/2021  IPAL  Adecuación para campaña Navideña 2021.      
  29/09/2021  Y117 Cambio al límite de sobretasa del seguro desgravamen.      29/10/2021  RABC Adecuación para exposición de PAE      
  19/01/2022  FAQF Se exonera validación de desgravamen para desembolso crediahorro por canal digital    
  31/01/2022  RAAF  Variable 527, se actualiza el calculo de la variable 167 edad del cliente (INDIGO).    
  28/01/2022  RAAF Variable 528, se valida el monto por exposición por producto personal directo '304'    
  14/03/2022  RABC  Adecuación para campaña escolar 2022.    
  25/04/2022  DDCC  Se elimina mensaje de la regla desaprobada cuando se usa la constante 666.     
  27/04/2022  IPAL Adecuación para CAMPAÑA DIA DE LA MADRE Y FIESTAS PATRIAS 2022.    
  16/05/2022  Y117 Cambio al límite de sobretasa del seguro desgravamen.    
  27/04/2022  PMMQ  Adecuación para Campaña CrediAhorro 2022    
  26/05/2022  Y117  Exoneracion de mora temporal.    
  01/09/2022  BECG  CAMPAÑA NAVIDEÑA 2022.    
  24/10/2022  IPAL Filtros de admisión.    
  15/12/2022  Y108 Se agrega nueva variable, Solicitud DPS    
  19/12/2022  IPAL Atención HC N° 260-2022-CMI-SGC      
  03/11/2022  Y127  Adecuacion para subdestino crediempresa.    
  16/01/2023  IPAL  Adecuación para CAMPAÑA ESCOLAR 2023.
  16/03/2023  IPAL  Mejora cálculo de zona para CAMPAÑA ESCOLAR 2023.  
  24/03/2023  LRFG Se agrega los tipos de relacion de ex familiares (parentesco de primer grado por disolucion de matrimonio) al calculo de limites  
  09/05/2023  OASG Adecuación para CAMPAÑA FIESTAS PATRIAS Y DÍA DE LA MADRE 2023.
  07/09/2023  EJTL Adecuacionen la tabla de colocreporte13info, para que solo tome el registro vigente.
  25/09/2024  IPAL Se migra código de agencia a tabla referencial. 
  01/10/2024  FAQF Se adecua regla Límite directores y trabajadores de acuerdo al reporte PA_Consulta_LimiteGlobal
  27/10/2024  IPAL Consideración código de empresa Caja Ica en SBS '00108'.
  26/11/2024  ANMA Se adecua regla requisitos para ser sujetos a credito para modificacion de campañas RCC

 Ejemplo de Ejecución:          
    
 exec COLOCACIONES.FluGen_ProcesarMotorDeDecisiones_SP @XMLParametros=N'<Parametros xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" cPersCodTitular="1081500320544" cPersCodConvenio="" nEtapa="15" bAplicaMicroseguro="0" nDiaPeriocidad="22" cCtaCod="" cPersIdNro="10499690" cCredProducto="302" nMoneda="1" cAgeCod="68" nDesemBN="0" nColocCondicion="2" nColocCondicion2="0" nCodDestino="4" nTipoCredito="3" nSubTipoCredito="302" nIdCampana="0" nCuotas="8" nPlazo="231" nTipoPeriodicidad="1" nPlazoGracia="0" nTasa="1.3490" nNumRefinanc="-1" nMonto="2407.00" CodSbsTit="0065166194" dUltFechaPagoCalen="2025-06-23" dFechaCaducFTE="2024-11-19" nMontoInCliFteSoles="0" nMontoInCliFteDolar="0.0000" nMontoCuotaInicial="317.87" MontoCuotaExcedente="0" nMontoCuota="317.87" nCodProyAsoc="0" bBonoBP="0" cLineaCred="019711302000065" nIdTasa="12416" nIdRegla="0" nTipoValidacion="0" cUserRegistro="DENM" dFechaRegistro="2024-11-04 19:58:13.930" dPersEval="2024-11-04 19:58:13.930" cNumFuente="00497910" nPersTipFte="1" bCanalDigital="1"><CreditosProcesar><CreditosProcesar cCtaCod="" nPrdEstado="" /></CreditosProcesar><GarantiaCredito><GarantiaCredito nNumGarant="0" nGravado="2407.00" nPorcentajeGarantia="100" nPorcentajeCobertura="100.00" nPorGravar100="0" /></GarantiaCredito><PersonaRelacionCred><PersonaRelacionCred cPersCod="1081500320544" nPrdPersRelac="20" /></PersonaRelacionCred><FIInDependiente /><FIIDependiente><FIIDependiente Moneda="1" nPersIngCli="1059.57" nPersIngCon="0.00" nPersOtrIng="0.00" nPersPagoCuotas="0.00" nRemBruta="0.00" nPersGastoFam="0.00" nDocLegales="0.00" nMandJudiciales="0.00" nCuotasSindicales="0.00" nFondosBienestar="0.00" nCuotasFinancieras="0.00" bSectorPublico="0" /><FIIDependiente Moneda="2" nPersIngCli="0.00" nPersIngCon="0.00" nPersOtrIng="0.00" nPersPagoCuotas="0.00" nRemBruta="0.00" nPersGastoFam="0.00" nDocLegales="0.00" nMandJudiciales="0.00" nCuotasSindicales="0.00" nFondosBienestar="0.00" nCuotasFinancieras="0.00" bSectorPublico="0" /></FIIDependiente><GruposEvaluacion><GrupoEvaluacion nIdGrupo="4" /></GruposEvaluacion><GruposReglaEvalua /></Parametros>'
*******************************************************************************************************/                 
ALTER PROCEDURE COLOCACIONES.FluGen_ProcesarMotorDeDecisiones_SP      
(          
       @XMLParametros XML
)          
AS      
BEGIN          
SET NOCOUNT ON           
      
      
BEGIN -- Creacion de Temporales            
      
    CREATE TABLE #DatosEntradaUnPivot
	(
		nIdVariable INT PRIMARY KEY,
		cSQLNombreColumna NVARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS,
		cSQLTipoDato NVARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		bSQLPermiteNulos BIT DEFAULT (1) NOT NULL,
		cSQLCollate NVARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		cValorCalculado VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS
	);

	CREATE TABLE #DatosEntrada (cNombreEmpresa VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS);

	CREATE TABLE #GrupoEvaluacion --DROP TABLE #GrupoEvaluacion          
	(
		nIdGrupo INT PRIMARY KEY,
		cDescripcion VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS,
		bActivo BIT
	);

	CREATE TABLE #ReglaCaso --DROP TABLE #ReglaCaso          
	(
		nOrden INT,
		nIdGrupo INT NOT NULL,
		nIdRegla INT NOT NULL,
		nIdCaso INT NOT NULL,
		cTipoEvaluacion CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		bResultado BIT DEFAULT (0)
	);
	ALTER TABLE #ReglaCaso ADD  PRIMARY KEY NONCLUSTERED(nIdGrupo,nIdRegla, nIdCaso, cTipoEvaluacion);  

	CREATE TABLE #ReglaCasoDetalle --DROP TABLE #ReglaCasoDetalle          
	(
		nIdRegla INT NOT NULL,
		nIdCaso INT NOT NULL,
		cTipoEvaluacion CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		nIdVariable INT NOT NULL,
		cSQLNombreColumna NVARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		cOperadorDeComparacion VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		cValorDeComparacion VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		cValorCalculado VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		nNodo INT NOT NULL,
		nNodoPadre INT NOT NULL,
		nIdVariableAfectacion INT NULL,
		bActivo BIT DEFAULT (0) NOT NULL
	);

	CREATE TABLE #IteracionCaso
	(
		nOrden INT NOT NULL,
		nIdRegla INT NOT NULL,
		nIdCaso INT NOT NULL
	);
	ALTER TABLE #IteracionCaso ADD  PRIMARY KEY NONCLUSTERED(nIdRegla, nIdCaso);

	CREATE TABLE #MensajeReglaConfig
	(
		nIdMensajeConfig INT NOT NULL PRIMARY KEY,
		nIdGrupo INT NOT NULL,
		nIdRegla INT NOT NULL,
		nIdCaso INT NOT NULL,
		nOrden INT NULL,
		cPlantillaMensaje VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		cMensaje VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		nTipoValidacion INT,
		bActivo BIT DEFAULT (0) NOT NULL
	);

	CREATE TABLE #MensajeDetalleConfig --   DROP TABLE Colocaciones.MensajeDetalleConfig          
	(
		nIdMensajeConfig INT NOT NULL,
		nIdVariable INT NOT NULL,
		nOrden INT,
		cValorCalculado VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS,
		bActivo BIT DEFAULT (0) NOT NULL
	);

	CREATE TABLE #VariablesMensaje
	(
		nIdVariable INT,
		cValorCalculado VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS
	);

	CREATE TABLE #ReglaCasoConfig
	(
		nIdRegla INT,
		nIdCaso INT,
		cTipoEvaluacion VARCHAR(5) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nIdVariable INT,
		cOperadorDeComparacion VARCHAR(50),
		cValorDeComparacion VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nNodo INT,
		nNodoPadre INT,
		nIdVariableAfectacion INT NULL,
		bActivo BIT,
		cUserRegistro CHAR(4),
		dFechaRegistro DATETIME
	)

	CREATE TABLE #ConsolAlineaRiesgoCrediticioDia
	(
		Fecha date NOT NULL,
		codAgencia varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		nTipoCreditos int,
		codProducto varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		Moneda varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		linea varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nSaldoCap money NOT NULL
	)

	CREATE TABLE #tipocreditos
	(
		nTipoCreditos INT,
		Saldos MONEY
	)

	CREATE TABLE #PersonaRelacionCred
	(
		cPersCod VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nPersRelac INT
	)

	CREATE TABLE #GarantiaCredito
	(
		nNumGarant BIGINT,
		nGravado DECIMAL(18, 2),
		nPorcentajeGarantia DECIMAL(18, 2),
		nPorcentajeCobertura DECIMAL(18, 2),
		nPorGravar100 DECIMAL(18, 2)
	)

	CREATE TABLE #RelPersonaEdad
	(
		cPersCod VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS,
		cPersNombre VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nPersRelac INT,
		cRelacion VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nDiasExc INT,
		nTipoEval INT
	)

	CREATE TABLE #FTeIndependiente
	(
		cNumFuente VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nMoneda INT,
		nPersFIVentas DECIMAL(18, 2),
		nPersFIRecupCtasXCobrar DECIMAL(18, 2),
		nPersFICostoVentas DECIMAL(18, 2),
		nPersFIEgresosOtros DECIMAL(18, 2),
		nPersIngFam DECIMAL(18, 2),
		nPersEgrFam DECIMAL(18, 2),
		nPersPagoCuotas DECIMAL(18, 2)
	)

	CREATE TABLE #FTeDependiente
	(
		cNumFuente VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nMoneda INT,
		nPersIngCli DECIMAL(18, 2),
		nPersIngCon DECIMAL(18, 2),
		nPersOtrIng DECIMAL(18, 2),
		nPersPagoCuotas DECIMAL(18, 2),
		nPersGastoFam MONEY,
		nRemBruta MONEY,
		nDocLegales MONEY,
		nMandJudiciales MONEY,
		nCuotasSindicales MONEY,
		nFondosBienestar MONEY,
		nCuotasFinancieras MONEY,
		bSectorPublico BIT
	)

	CREATE TABLE #PersonaRelacDiasatraso
	(
		cCtaCod VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
		cPersCod VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nPrdPersRelac INT,
		cRelacion VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nDiasatraso INT,
		cPersnombre VARCHAR(200) COLLATE SQL_Latin1_General_CP1_CI_AS
	)

	CREATE TABLE #CreditosProcesar
	(
		cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS,
		nPrdEstado INT,
		nCodProceso INT
	)
	
	DECLARE @CalificacionInt TABLE
	(
		cCalifInt VARCHAR(3),
		codigo INT
	)

	CREATE TABLE #ReglaNegEquiv
	(
		nIdRegla INT,
		nCodAlinea INT
	)

	CREATE TABLE #mumCredt (numCreditos INT);
	
	CREATE TABLE #ReglasExcep (nIdRegla INT);

	CREATE TABLE #TCreditosVigentes
	(
		cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL PRIMARY KEY,
		nDiasAtraso INT,
		bAmpliado BIT DEFAULT (0)
	);

	CREATE TABLE #CreditosNoCoberturados
	(
		[id] [int] NOT NULL,
		[cCtaCod] [varchar](18) collate SQL_Latin1_General_CP1_CI_AS NULL,
		[IdCampana] [int] NULL,
		[nSaldoCap] [money] NULL,
		[nMontoConG] [money] NULL,
		[nMontoSinG] [money] NULL,
		[cLineaCred] [varchar](15) NULL,
		[nPorcentajeCober] [money] NULL
	);

END          
      
BEGIN -- VARIABLES NO XML      
      
	DECLARE @nSaldoCubierto MONEY = 0      
      
END      
          
          
BEGIN --     Variables XML básicas para busqueda de información           
  DECLARE           
  @dFechaActual DATE = NULL,          
  @cPersCodTitular VARCHAR(13) = NULL,          
  @cCtaCod VARCHAR(18) = '',          
  @cCredProducto CHAR(3) = '',          
  @cPersIdNro VARCHAR(20) = NULL,          
  @cAgeCod VARCHAR(3) = NULL,          
  @nColocCondicion INT,          
  @nColocCondicion2 INT,          
  @nCodDestino INT,          
  @nSubDestinosId INT,    
  @nTipoCredito INT,          
  @nIdCampana INT,          
  @nCuotas INT,          
  @nPlazo INT,          
  @nNumRefinan INT,          
  @tipoCambio MONEY,          
  @nMoneda INT,          
  @nMonto MONEY,          
  @CodSbsTit  VARCHAR(15),          
  @dUltFechaPagoCalen DATE,          
  @dUltFechaPrecuota DATE,        
  @nRatio DECIMAL(18,2),          
  @nRatioLiquit DECIMAL(18,2),          
  @cCalifClient VARCHAR(5),          
  @nMontoInCliFteSoles DECIMAL(18,2),          
  @nMontoInCliFteDolar DECIMAL(18,2),          
  @nMontoCuota DECIMAL(18,2),          
  @nMontoCuotaInicial DECIMAL(18,2),          
  @bBonoBP BIT,          
  @nGastoCalen DECIMAL(18,2),          
  @nTipoFuente INT,          
  @cLineaCred VARCHAR(15),          
  @nIdTasa INT            ,           
  @nTasa DECIMAL(8,4),          
  @nPlazoGracia INT,          
  @nTipoPeriodicidad INT,          
  @cPersCodConvenio VARCHAR(13),          
  @nCodProyAsoc INT,          
  @nDesemBN BIT = 0,          
  @nSubTipoCredito INT ,          
  @cNumFuente varchar(10),          
  @nPersTipFte INT,          
  @dPersEval DATE,          
  @dFechaCaducFTE DATE,          
  @nEtapa INT,          
  @dFechaRCC DATE,          
  @bAplicaMicroseguro INT,          
  @nPeriodoDiaPago INT,          
  @cUser VARCHAR(4),          
  @nIndCasaPropia INT,          
  @nTCEA DECIMAL(18,2),          
  @cMensajeConfigFAE VARCHAR(MAX)= '',      
  @cMsjCumpleValidaciones_Reprog varchar(max) = '',      
  @bCanalDigital BIT = 0 --Caja Web o App Móvil,
          
	SELECT           
        @cPersCodTitular                  = C.Col.value('@cPersCodTitular','VARCHAR(18)'),          
        @cCtaCod                                = ISNULL(C.Col.value('@cCtaCod','VARCHAR(18)'), ''),          
        @cCredProducto                          = C.Col.value('@cCredProducto','VARCHAR(18)'),          
        @cPersIdNro                             = C.Col.value('@cPersIdNro','VARCHAR(20)'),          
        @cAgeCod                                = C.Col.value('@cAgeCod','VARCHAR(3)'),          
        @nColocCondicion                  = C.Col.value('@nColocCondicion','INT'),          
        @nColocCondicion2                 = C.Col.value('@nColocCondicion2','INT'),          
        @nCodDestino                      = C.Col.value('@nCodDestino','INT'),          
		@nSubDestinosId                      = C.Col.value('@nSubDestinosId','INT'),            
        @nTipoCredito                     = C.Col.value('@nTipoCredito','INT'),          
        @nIdCampana                             = C.Col.value('@nIdCampana','INT'),      
        @nCuotas                                = C.Col.value('@nCuotas','INT'),          
        @nPlazo                                        = C.Col.value('@nPlazo','INT'),          
        @nNumRefinan                      = C.Col.value('@nNumRefinanc','INT'),          
        @nMoneda                                = C.Col.value('@nMoneda','INT'),          
        @nMonto                                        = C.Col.value('@nMonto','MONEY'),          
        @CodSbsTit                              = C.Col.value('@CodSbsTit','VARCHAR(15)'),          
        @dUltFechaPagoCalen               = C.Col.value('@dUltFechaPagoCalen','DATE'),          
		@dUltFechaPrecuota = C.Col.value('@dUltFechaPrecuota','DATE'),          
        @nMontoInCliFteSoles       = C.Col.value('@nMontoInCliFteSoles','DECIMAL(18,2)'),          
        @nMontoInCliFteDolar       = C.Col.value('@nMontoInCliFteDolar','DECIMAL(18,2)'),          
        @nMontoCuota                      = C.Col.value('@nMontoCuota','DECIMAL(18,2)'),          
        @nMontoCuotaInicial               = C.Col.value('@nMontoCuotaInicial','DECIMAL(18,2)'),          
          
        @nGastoCalen                      = C.Col.value('@nGastoCalen','DECIMAL(18,2)'),          
        @bBonoBP                         = C.Col.value('@bBonoBP','BIT'),          
        @cLineaCred        = C.Col.value('@cLineaCred','VARCHAR(15)'),          
        @nIdTasa                               = C.Col.value('@nIdTasa','INT'),          
        @nTasa                                  = C.Col.value('@nTasa','DECIMAL(8,4)'),          
        @nPlazoGracia                     = C.Col.value('@nPlazoGracia','INT'),          
        @nTipoPeriodicidad               = C.Col.value('@nTipoPeriodicidad','INT'),          
        @cPersCodConvenio        = C.Col.value('@cPersCodConvenio','VARCHAR(13)'),          
        @nCodProyAsoc                     = C.Col.value('@nCodProyAsoc','INT'),          
        @nDesemBN                               = C.Col.value('@nDesemBN','BIT'),          
        @nSubTipoCredito                  = C.Col.value('@nSubTipoCredito','INT'),          
        @cNumFuente                             = C.Col.value('@cNumFuente','VARCHAR(10)'),          
        @nTipoFuente                      = C.Col.value('@nPersTipFte','INT'),          
        @dPersEval                              = C.Col.value('@dPersEval','DATE'),          
        @dFechaCaducFTE                         = C.Col.value('@dFechaCaducFTE','DATE'),          
        @nEtapa                                        = C.Col.value('@nEtapa','INT'),          
        @bAplicaMicroseguro               = C.Col.value('@bAplicaMicroseguro      ','INT'),          
        @nPeriodoDiaPago                  = C.Col.value('@nDiaPeriocidad    ','INT'),          
        @nRatio                                 = C.Col.value('@MontoCuotaExcedente','DECIMAL(18,2)'),          
        @cUser                      = C.Col.value('@cUserRegistro','VARCHAR(4)'),          
        @nIndCasaPropia                      = C.Col.value('@nIndCasaPropia','INT'),           
        @nTCEA = C.Col.value('@nTCEA','DECIMAL(18,2)'),         
        @bCanalDigital                       = C.Col.value('@bCanalDigital','BIT')       
	FROM @XMLParametros.nodes('Parametros') AS C(Col) 

	DECLARE @cAgeCodCredito VARCHAR(4) = (SELECT TOP 1 cAgeCod FROM Producto WITH(NOLOCK) WHERE cCtaCod = @cCtaCod)

END          
          
BEGIN --     Temporales de Configuracion          
          
       BEGIN -- Grupos de Evaluacion Válidos          
			 INSERT INTO #GrupoEvaluacion(nIdGrupo)          
             SELECT           
                    D.Detalle.value('@nIdGrupo','INT') AS nIdGrupo          
             FROM @XMLParametros.nodes('Parametros/GruposEvaluacion') AS C(Col)          
                    CROSS APPLY C.Col.nodes('GrupoEvaluacion') AS D(Detalle)          
          
             UPDATE A          
             SET           
                    A.cDescripcion = ISNULL(B.cDescripcion, ''),          
                    A.bActivo = ISNULL(B.bActivo, 0)          
             FROM #GrupoEvaluacion A           
                    LEFT JOIN Colocaciones.GrupoEvaluacion B         
                           ON A.nIdGrupo = B.nIdGrupo          
                 
             DELETE A--SELECT *          
			 FROM #GrupoEvaluacion A          
             WHERE A.bActivo = 0          
                       
             SELECT @nSubTipoCredito=nSubTipoCredito          
             FROM subTipoCredito          
             WHERE nTipoCredito=@nTipoCredito AND          
                    (nMontoEvaInicio<=@nMonto AND @nMonto<=nMontoEvafIN)          
                     
             SET @dFechaRCC = (SELECT CAST(nConsSisValor AS DATE) FROM ConstSistema with(nolock) WHERE nConsSisCod = 890)            
          
                       
			INSERT INTO #ReglaNegEquiv (nIdRegla,nCodAlinea)          
			VALUES   (9,2),(10,9),(11,10),(12,11),(13,12),(14,14),(15,19),(16,20),(17,21),(18,22),(19,23),(20,24),(21,25)          
                    ,(22,26),(23,27),(24,28),(25,29),(26,31),(27,33),(28,34),(29,35),(30,36),(31,37),(32,38),(33,39),(34,40)          
                    ,(35,41),(36,42),(37,43),(38,44),(39,45),(40,46)          
          
            IF (SELECT COUNT(1) FROM #GrupoEvaluacion) = 0          
				GOTO SALIR          
          
       END          
          
       BEGIN --Reglas Caso          
            INSERT INTO #ReglaCaso( nIdGrupo,nIdRegla, nIdCaso, cTipoEvaluacion)          
			SELECT            
				MIN(A.nIdGrupo) as nIdGrupo, C.nIdRegla, C.nIdCaso, C.cTipoEvaluacion          
			FROM #GrupoEvaluacion A
				INNER JOIN Colocaciones.ReglaGrupo B with (nolock)
					ON A.nIdGrupo = B.nIdGrupo
				INNER JOIN Colocaciones.ReglaCasoConfig C with (nolock)
					ON B.nIdRegla = C.nIdRegla
				INNER JOIN COLOCACIONES.Regla D with (nolock)
					ON D.nIdRegla = B.nIdRegla          
			WHERE B.bActivo = 1          
                    AND C.bActivo = 1          
                    AND D.bActivo=1          
			GROUP BY C.nIdRegla, C.nIdCaso, C.cTipoEvaluacion          
          
            --CASO ESPECIAL PARA REGLAS DEL GRUPO 4          
          INSERT INTO #ReglasExcep (nIdRegla)          
          SELECT   DISTINCT B.nIdRegla          
          FROM AlineaSicmact  A WITH (NOLOCK)          
          INNER JOIN #ReglaNegEquiv B          
               ON A.nCodAlinea=B.nCodAlinea          
          WHERE A.nCodAlinea IN (SELECT  ncodalinea FROM RegAlineaProducto with(nolock) WHERE ccodProducto = @cCredProducto and bActivo=1)           
               AND A.ncodalinea IN (SELECT  ncodalinea FROM RegAlineaAgencia with(nolock) WHERE cAgeCod = @cAgeCod and bActivo=1)           
          
          DELETE A --SELECT *          
          FROM #ReglaCaso A          
          WHERE A.nIdGrupo=4 AND A.nIdRegla NOT IN (SELECT nIdRegla FROM #ReglasExcep)          
          
          
          IF (SELECT COUNT(1) FROM #ReglaCaso) = 0          
				GOTO SALIR          
       END           
                 
       BEGIN --Insert de Iteraciones de casos por regla          
             INSERT INTO #IteracionCaso (nOrden, nIdRegla, nIdCaso)          
             SELECT           
				ROW_NUMBER() OVER( ORDER BY X.nIdRegla, X.nIdCaso ) As nOrden,           
				X.nIdRegla, X.nIdCaso          
             FROM (SELECT DISTINCT A.nIdRegla, A.nIdCaso FROM  #ReglaCaso A) X          
          
             UPDATE A          
             SET A.nOrden = B.nOrden          
             FROM #ReglaCaso A          
              INNER JOIN #IteracionCaso B          
                           ON A.nIdRegla = B.nIdRegla          
                                  AND A.nIdCaso = B.nIdCaso            
          
  END           
               
       BEGIN --Detalle de Variables (nTipo = 2) utilizados, luego se actualizará con el valor calculado para construir el mensaje          
          
             INSERT INTO #ReglaCasoDetalle (nIdRegla, nIdCaso, cTipoEvaluacion, nIdVariable, cSQLNombreColumna, cOperadorDeComparacion, cValorDeComparacion,           
                    cValorCalculado, nNodo, nNodoPadre, nIdVariableAfectacion, bActivo)          
             SELECT A.nIdRegla, A.nIdCaso, B.cTipoEvaluacion, B.nIdVariable, C.cSQLNombreColumna, B.cOperadorDeComparacion, B.cValorDeComparacion, 0 AS cValorCalculado,          
                    B.nNodo, B.nNodoPadre, B.nIdVariableAfectacion, B.bActivo          
             FROM #IteracionCaso A          
                    INNER JOIN Colocaciones.ReglaCasoConfig B  with(nolock)              
                        ON A.nIdRegla = B.nIdRegla          
						AND A.nIdCaso = B.nIdCaso          
                    INNER JOIN Colocaciones.Variable C    with(nolock)       
                        ON B.nIdVariable = C.nIdVariable          
             WHERE B.bActivo = 1          
                    AND C.nTipo = 2          
       END           
                 
       BEGIN --CONFIGURACION DE MENSAJES          
          
             --Mensaje          
             INSERT INTO #MensajeReglaConfig (nIdMensajeConfig, nIdGrupo, nIdRegla, nIdCaso, cPlantillaMensaje , nTipoValidacion,bActivo)          
             SELECT            
                    DISTINCT D.nIdMensajeConfig, A.nIdGrupo, C.nIdRegla, C.nIdCaso, D.cPlantillaMensaje , D.nTipoValidacion, D.bActivo          
             FROM #GrupoEvaluacion A          
                    INNER JOIN Colocaciones.ReglaGrupo B with (nolock)
						ON A.nIdGrupo = B.nIdGrupo
					INNER JOIN Colocaciones.ReglaCasoConfig C with (nolock)
						ON B.nIdRegla = C.nIdRegla
					INNER JOIN Colocaciones.MensajeReglaConfig D with (nolock)
						ON A.nIdGrupo = D.nIdGrupo
						   AND D.nIdRegla = B.nIdRegla
						   AND D.nIdCaso = C.nIdCaso          
             WHERE B.bActivo = 1          
                    AND C.bActivo = 1          
                    AND D.bActivo = 1             
          
             DELETE FROM #MensajeReglaConfig WHERE nIdGrupo=4 AND nIdRegla NOT IN  (SELECT nIdRegla FROM #ReglasExcep)          
                              
             UPDATE A          
             SET A.nOrden = B.nOrden --  SELECT *          
             FROM #MensajeReglaConfig A          
                    INNER JOIN (SELECT           
                                               ROW_NUMBER() OVER(ORDER BY nIdMensajeConfig ASC) As nOrden,          
                                               nIdMensajeConfig          
                                        FROM #MensajeReglaConfig ) B          
                           ON A.nIdMensajeConfig = B.nIdMensajeConfig               
          
                       
                                     
       END           
          
       BEGIN --INSERTANDO #PersonaRelacionCred Y #GarantiaCredito          
			INSERT INTO #PersonaRelacionCred(cPersCod,nPersRelac)          
			SELECT D.Detalle.value('@cPersCod', 'VARCHAR(13)') AS cPersCod,
					D.Detalle.value('@nPrdPersRelac', 'INT') AS nPersRelac
			FROM @XMLParametros.nodes('Parametros/PersonaRelacionCred') AS C(Col)
				CROSS APPLY C.Col.nodes('PersonaRelacionCred') AS D(Detalle)        
          
			INSERT INTO #GarantiaCredito(nNumGarant,nGravado,nPorcentajeGarantia,nPorcentajeCobertura,nPorGravar100)          
            SELECT D.Detalle.value('@nNumGarant', 'BIGINT') AS nNumGarant,
				   D.Detalle.value('@nGravado', 'DECIMAL(18,2)') AS nNumGarant,
				   D.Detalle.value('@nPorcentajeGarantia', 'DECIMAL(18,2)') AS nNumGarant,
				   D.Detalle.value('@nPorcentajeCobertura', 'DECIMAL(18,2)') AS nNumGarant,
				   D.Detalle.value('@nPorGravar100', 'DECIMAL(18,2)') AS nNumGarant
			FROM @XMLParametros.nodes('Parametros/GarantiaCredito') AS C(Col)
				CROSS APPLY C.Col.nodes('GarantiaCredito') AS D(Detalle)   
       END          
          
     BEGIN --INSERTANDO FUENTE DE INGRESO          
          INSERT INTO #FTeIndependiente          
          SELECT           
			   @cNumFuente as cNumFuente          
               ,T2.col.value('@Moneda','INT') as Moneda          
               ,T2.col.value('@nPersFIVentas','DECIMAL(18,2)') as nPersFIVentas          
               ,T2.col.value('@nPersFIRecupCtasXCobrar','DECIMAL(18,2)') as nPersFIRecupCtasXCobrar          
               ,T2.col.value('@nPersFICostoVentas','DECIMAL(18,2)') as nPersFICostoVentas          
               ,T2.col.value('@nPersFIEgresosOtros','DECIMAL(18,2)') as nPersFIEgresosOtros          
               ,CONVERT(DECIMAL(18,2),REPLACE(T2.col.value('@nPersIngFam','VARCHAR(25)'),',','.')) as nPersIngFam          
               ,CONVERT(DECIMAL(18,2), REPLACE( T2.col.value('@nPersEgrFam','VARCHAR(25)'),',','.')) as nPersEgrFam                         
               ,T2.col.value('@nPersPagoCuotas','DECIMAL(18,2)') as nPersPagoCuotas          
          FROM @XMLParametros.nodes('/Parametros/FIInDependiente') T(c)                 
                CROSS APPLY T.c.nodes('FIInDependiente')  as T2(col)          
                    
          INSERT INTO #FTeDependiente          
          SELECT           
          -- T.c.value('@cNumFuente','VARCHAR(20)') as cNumFuente          
               @cNumFuente as cNumFuente          
               ,T2.col.value('@Moneda','INT') as Moneda          
               ,T2.col.value('@nPersIngCli','DECIMAL(18,2)') as nPersIngCli          
               ,T2.col.value('@nPersIngCon','DECIMAL(18,2)') as nPersIngCon          
               ,T2.col.value('@nPersOtrIng','DECIMAL(18,2)') as nPersOtrIng          
               ,T2.col.value('@nPersPagoCuotas','DECIMAL(18,2)') as nPersPagoCuotas          
			   ,T2.col.value('@nRemBruta','MONEY') AS nRemBruta          
			   ,T2.col.value('@nPersGastoFam','MONEY') AS  nPersGastoFam          
               ,T2.col.value('@nDocLegales','MONEY') AS nDocLegales          
               ,T2.col.value('@nMandJudiciales','MONEY') AS nMandJudiciales          
               ,T2.col.value('@nCuotasSindicales','MONEY') AS  nCuotasSindicales          
               ,T2.col.value('@nFondosBienestar','MONEY') AS nFondosBienestar          
               ,T2.col.value('@nCuotasFinancieras','MONEY') AS nCuotasFinancieras          
               ,T2.col.value('@bSectorPublico','BIT') AS bSectorPublico          
          FROM @XMLParametros.nodes('/Parametros/FIIDependiente') T(c)                 
                CROSS APPLY T.c.nodes('FIIDependiente')  as T2(col)          
          
       END          
          
       BEGIN --INSERTANDO CREDITO A PROCESAR          
           INSERT INTO #CreditosProcesar          
           SELECT           
               T2.col.value('@cCtaCod','VARCHAR(18)') as cCtaCod          
               ,T2.col.value('@nPrdEstado','INT') as nPrdEstado          
               ,@nColocCondicion2 as nCodProceso--,T.c.value('@nCodProceso','INT') as nCodProceso          
          FROM @XMLParametros.nodes('/Parametros/CreditosProcesar') T(c)                 
                CROSS APPLY T.c.nodes('CreditosProcesar')  as T2(col)          
                    
       END          
          
       --Variables exclusivas para mensajes          
       INSERT INTO #VariablesMensaje(nIdVariable)          
	   SELECT B.nIdVariable          
       FROM #MensajeReglaConfig A          
             INNER JOIN Colocaciones.MensajeDetalleConfig B  with(nolock)        
                ON A.nIdMensajeConfig = B.nIdMensajeConfig          
             INNER JOIN Colocaciones.Variable C  with(nolock)         
				ON B.nIdVariable = C.nIdVariable          
       WHERE B.bActivo = 1           
             AND C.nTipo = 3          
          
                                
	   -- Atributos          
       INSERT INTO #DatosEntradaUnPivot (nIdVariable, cSQLNombreColumna, cSQLTipoDato, bSQLPermiteNulos, cSQLCollate, cValorCalculado)          
       SELECT DISTINCT B.nIdVariable, B.cSQLNombreColumna, B.cSQLTipoDato, B.bSQLPermiteNulos, B.cSQLCollate, ''          
       FROM #ReglaCasoDetalle A          
             INNER JOIN Colocaciones.Variable B  with(nolock)         
			    ON A.nIdVariable = B.nIdVariable          
          
    -- Atributos de Afectacion            
              
    INSERT INTO #DatosEntradaUnPivot (nIdVariable, cSQLNombreColumna, cSQLTipoDato, bSQLPermiteNulos, cSQLCollate, cValorCalculado)          
    SELECT DISTINCT B.nIdVariableAfectacion, C.cSQLNombreColumna, C.cSQLTipoDato, C.bSQLPermiteNulos, C.cSQLCollate, ''          
    FROM #ReglaCasoDetalle A          
		  INNER JOIN Colocaciones.ReglaCasoConfig B  with(nolock)            
               ON A.nIdRegla = B.nIdRegla          
               AND A.nIdCaso = B.nIdCaso          
          INNER JOIN Colocaciones.Variable C  with(nolock)        
               ON B.nIdVariableAfectacion = C.nIdVariable          
    WHERE B.bActivo = 1          
          AND C.nTipo = 2          
          AND B.nIdVariableAfectacion NOT IN ( select nIdVariable from #DatosEntradaUnPivot )          
          
    INSERT INTO @CalificacionInt VALUES ('E',7)          
    INSERT INTO @CalificacionInt VALUES ('D',6)          
    INSERT INTO @CalificacionInt VALUES ('C',5)          
    INSERT INTO @CalificacionInt VALUES ('B',4)          
    INSERT INTO @CalificacionInt VALUES ('A',3)          
    INSERT INTO @CalificacionInt VALUES ('AA',2)          
    INSERT INTO @CalificacionInt VALUES ('AAA',1)          
          
INSERT INTO #TCreditosVigentes (cCtaCod, nDiasAtraso, bAmpliado)          
 SELECT           
  A.cCtaCod,           
  C.nDiasAtraso,          
  CASE          
     WHEN D.cCtaCodAmp IS NOT NULL THEN 1          
     ELSE 0          
  END           
 FROM Producto A  WITH (NOLOCK)        
  INNER JOIN ProductoPersona B WITH (NOLOCK) ON A.cCtaCod = B.cCtaCod AND B.nPrdPersRelac = 20          
  INNER JOIN ColocacCred C WITH (NOLOCK) ON A.cCtacod = C.cCtaCod           
  LEFT JOIN ColocacAmpliado D WITH (NOLOCK) ON D.cCtaCod = @cCtaCod AND D.cCtaCodAmp = A.cCtaCod           
 WHERE           
  B.cPersCod = @cPersCodTitular          
  AND A.nPrdEstado IN (2020, 2021, 2022, 2030, 2031, 2032)          
                         
END           
          
BEGIN --     Declaracion de Variables          
          
       --Variables de Tipo Atributo          
       DECLARE          
             @bCasoSinCaracteristica                 BIT = 1,           
             @nCantSolicitudesPendientes             INT  = 0,          
             @nCantCreditosPendientes               INT = 0,          
             @nCantCondonacionesEnRecuperaciones INT = 0,          
             @nCantExoneracionxCampanaxPeriodoDeTiempo INT = 0,          
             @nPersPersoneria                        INT = 0,          
             @bAhorroCuentaSueldoValido        BIT = 0,          
             @nCantCredTitularCony                   INT = 0,          
             @nCantCredConyugueTit                   INT = 0,          
             @nGarantizadosAval                      INT = 0,          
             @nCredtsAtrasoAmp             INT = 0,          
             @nNumCredtPorctMercado                  INT = 0,          
             @cAgeCodGrupo                           VARCHAR(5),          
             @bCredOtraAgencia                       INT=0,          
             @nMontoMaxDirecTrab                     DECIMAL(18,2),          
             @nMontoCredVigDirecTrab           DECIMAL(18,2),          
             @nNumCredClient                         INT=0,          
             @nNumCredHipotClient              INT=0,          
             @nNumCredDesctoClient                   INT=0,          
             @nNumCredCMIClient                      INT=0,          
             @nSaldoColocMercado                     DECIMAL(18,2),          
             @nSaldoColocCofiGas                    DECIMAL(18,2),          
             @nSaldoCartera                                 DECIMAL(18,2),          
             @cPersCodConyugue                       VARCHAR(15)='',          
             @cNumDOITit                             VARCHAR(15)='',          
             @cNumDOIConyugue                        VARCHAR(15)='',     
             --@CodSbsTit                  VARCHAR(15)='',          
 @CodSbsConyugue                         VARCHAR(15)='',          
             @nMaxNumIfis                            INT=0,          
             @nNumPartCodeudor                       INT=0,          
             @nMontoTotalDeuda                       DECIMAL(18,2),          
             @nRegPolizaInd                                 INT,          
             @nRegPolizaGlob                         INT,          
             @nRegPreAprob                           BIT,          
             @nRegGarantFisica            BIT,          
       @cNombreGarantExc                       VARCHAR(50),          
       @nPorcentMercado                       DECIMAL(18,2),          
           @nSueldoNetoClient                      DECIMAL(18,2),          
             @cMensajeReg27                                 VARCHAR(150)='',          
             @bRecurrente                 INT=0          
                
       --Variables de Tipo Mensaje          
    DECLARE           
             @cCtaCodReajusteRecup VARCHAR(1000),          
             @cCtaCodExoIntGas VARCHAR(1000),          
             @cMensajeNegocioh6m        VARCHAR(MAX) ='',           
             @cMensajeh6m         VARCHAR(MAX) ='',          
             @cMsjLimGloIndCredDirTra   VARCHAR(1000) = '',          
             -- Determinamos la Agencia y el producto              
             @cAgeDescOA                VARCHAR(100)  ='',            
             @cCredDescOA               VARCHAR(100)   ='',             
             @cCtaCodOA                 VARCHAR(100)  ='',          
             @cCampana                  VARCHAR(500) = ''          
          
          
END           
          
BEGIN --Calculo de Indicador de Casa Propia          
 DECLARE @nCasaPropiaoAval INT=0          
 DECLARE @bCasaPropiaoAval BIT=0            
 SELECT @nCasaPropiaoAval=COUNT(B.nIdTipoRegistro)          
    FROM PersGarantia A INNER JOIN garantias B WITH(NOLOCK) ON A.cNumGarant = B.cNumGarant           
 WHERE A.cPersCod = @cPersCodTitular AND A.nRelacion = 1 AND B.nTipoColateralID = 18 AND B.nIdTipoRegistro IN (1,2) AND B.cFlag = '1'          
                          
    IF ISNULL(@nCasaPropiaoAval,0)=0          
    BEGIN          
            SELECT @nCasaPropiaoAval=COUNT(PD.cCondicion)          
            FROM PERSONA P  with(nolock)         
            INNER JOIN PersonaDomicilio PD with(nolock) ON P.cPersCod=PD.cPersCod            
            WHERE (P.cPersCod=@cPersCodTitular AND PD.cCondicion=1)          
    END          
          
    IF ISNULL(@nCasaPropiaoAval,0)=0 and @nIdCampana NOT IN (141,148)          
    BEGIN          
            SELECT @nCasaPropiaoAval=COUNT(PD.cCondicion)          
            FROM PERSONA P with(nolock)     
                    INNER JOIN PersonaDomicilio PD with(nolock) ON P.cPersCod=PD.cPersCod            
            WHERE PD.cCondicion=1 AND P.cPersCod IN          
            (          
                    SELECT B.cPersCod          
                FROM #GarantiaCredito      A          
                        INNER JOIN PersGarantia B with(nolock)         
                            ON A.nNumGarant=B.cNumGarant          
                    WHERE B.cPersCod<>@cPersCodTitular  and b.nRelacion = 1          
            )          
    END          
 IF (@nCasaPropiaoAval >0)          
    BEGIN          
  SET @bCasaPropiaoAval = 1          
    END          
END          
          
BEGIN --     Calculo de Variables TIPO ATRIBUTO          
          
    BEGIN --Fecha Actual          
                       
             SET @dFechaActual = (SELECT CONVERT(DATE, nConsSisValor,103)  FROM ConstSistema  with(nolock) WHERE nConsSisCod = 16)          
                       
SET @nNumRefinan=(CASE WHEN @nNumRefinan=0 THEN -1 ELSE @nNumRefinan END)          
          
             SELECT @tipoCambio = nValFijo           
             FROM TipoCambio WHERE DateDiff(day,dFecCamb, @dFechaActual) = 0          
              
             SELECT @cAgeCodGrupo=ISNULL(cAgeGrupo,cAgeCod)           
             FROM Agencias WHERE cAgeCod=@cAgeCod          
          
          
             SELECT @cPersCodConyugue=cPersCod FROM #PersonaRelacionCred WHERE nPersRelac=21          
                       
       IF ISNULL(@cPersCodConyugue,'')<>''          
             BEGIN          
                 SELECT @cPersCodConyugue=ISNULL(cPersRelacPersCod,'')           
                 FROM PersRelaciones  WITH (NOLOCK)          
                 WHERE cPersCod=@cPersCodTitular AND nPersRelac=0          
             END          
          
             SELECT TOP 1 @cNumDOITit = cPersIDnro           
             FROM PersID WITH (NOLOCK)          
             WHERE cPersCod = @cPersCodTitular           
             ORDER BY cpersidtpo ASC          
          
             SELECT TOP 1 @cNumDOIConyugue = cPersIDnro           
             FROM PersID WITH (NOLOCK)          
             WHERE cPersCod = @cPersCodConyugue           
             ORDER BY cpersidtpo ASC          
          
          IF ltrim(rtrim(ISNULL(@cNumDOIConyugue,'')))<>''            
          BEGIN          
               SELECT @CodSbsConyugue=Cod_Sbs            
               FROM dbrcc.dbo.rcctotalult rtu   WITH (NOLOCK)            
               WHERE Cod_Doc_Id=@cNumDOIConyugue or Cod_Doc_Trib=@cNumDOIConyugue          
          END          
          
    INSERT INTO #mumCredt          
          EXEC PA_CondicionCredito @cPersCodTitular          
          
          SET @bRecurrente=isnull((SELECT numCreditos FROM #mumCredt),0)          
                       
       END           
          
 UPDATE A          
    SET A.cValorCalculado = CONVERT(VARCHAR, @dFechaActual )          
    FROM #DatosEntradaUnPivot A          
    WHERE nIdVariable = 152          
       
 declare @xData xml = ''      
 exec Colocaciones.FluCre_CalculaSumaPorcentajeSinCoberturaXml_SP @cPersCodTitular, @xData  output      
      
 insert into #CreditosNoCoberturados      
 SELECT       
 xmlcol.value('@id','int'),      
 xmlcol.value('@cCtaCod','varchar (18)'),      
 xmlcol.value('@IdCampana','int'),      
 xmlcol.value('@nSaldoCap','money'),      
 xmlcol.value('@nMontoConG','money'),      
 xmlcol.value('@nMontoSinG','money'),      
 xmlcol.value('@cLineaCred','varchar(15)'),      
 xmlcol.value('@nPorcentajeCober','money')      
    FROM @xData.nodes('CreditosCoberturados/Credito') As xmlTable(xmlcol)      
    WHERE xmlcol.value('@cCtaCod','varchar (18)') <> ''      
          
    BEGIN -- [nIdVariable = 3] Variable por defecto para Casos sin caracteristica          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 3)          
             BEGIN          
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR, IIF(@nIdCampana = 161, 0, @bCasoSinCaracteristica) )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 3                 
              END          
       END           
          
    BEGIN -- [nIdVariable = 4] Cantidad de solicitudes pendientes de atencion          
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 4)          
          BEGIN          
                    SELECT          
                           @nCantSolicitudesPendientes  = COUNT(A.nCodSolicitud)          
                    FROM ColocSolicitudPersona A WITH (NOLOCK)          
                           INNER JOIN ColocSolicitud B WITH(INDEX(PK_Solicitud))            
                                  ON A.nCodSolicitud = B.nCodSolicitud          
                    WHERE A.cPersCod = @cPersCodTitular           
                           AND A.nPrdPersRelac = 20            
                           AND B.nEstado IN (1, 3, 4, 5)          
          
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR, @nCantSolicitudesPendientes )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 4          
        END          
       END           
          
    BEGIN -- [nIdVariable = 5] Cantidad de Créditos Pendientes en Estado Solicitado, Sugerido o Aprobado          
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 5)     
             BEGIN          
                    SELECT          
                           @nCantCreditosPendientes = @nCantCreditosPendientes + COUNT(P.cCtaCod)           
                    FROM Producto P WITH (NOLOCK)          
                           INNER JOIN ProductoPersona PP WITH (NOLOCK)          
                                  ON PP.cCtaCod = P.cCtaCod          
                                        AND PP.nPrdPersRelac = 20          
                    WHERE P.nPrdestado IN (2001, 2002, 2000)           
                           AND PP.cPersCod = @cPersCodTitular          
                           AND P.cCtaCod <> @cCtaCod          
                           AND NOT EXISTS (          
                                               SELECT          
                                                      cCtaCod          
                                               FROM ColocacCred WITH (NOLOCK)          
                WHERE cCtaCod = P.cCtaCod          
                                                      AND IdCampana = 49)  -- Por Calendario de Cofigas           
                 
          
                    SELECT          
                           @nCantCreditosPendientes = @nCantCreditosPendientes + COUNT(P.cCtaCod)           
                    FROM ColocRefinanciacionTramite P WITH (NOLOCK)          
               INNER JOIN ProductoPersonaRefinanciacion PP WITH (NOLOCK)          
                                  ON PP.cCtaCod = P.cCtaCod          
                                        AND PP.nNumRefinanciacion = P.nNumRefinanciacion          
                                        AND PP.bOriginal = P.bOriginal          
                                        AND PP.nPrdPersRelac = 20          
                    WHERE P.nPrdestado IN (2001, 2002, 2000)           
                           AND PP.cPersCod = @cPersCodTitular          
                           AND P.cCtaCod <> @cCtaCod          
                           AND P.bOriginal = 0          
                           AND NOT EXISTS (          
                                                  SELECT   
                                                         cCtaCod          
               FROM ColocacCred WITH (NOLOCK)          
    WHERE cCtaCod = P.cCtaCod          
                          AND IdCampana = 49)  -- Por Calendario de Cofigas                
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR, @nCantCreditosPendientes )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 5          
             END              
       END           
          
    BEGIN -- [nIdVariable = 6] Cantidad de reajustes de Deuda de crédto en Recuperaciones          
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 6)          
             BEGIN                  
                    SELECT           
						@nCantCondonacionesEnRecuperaciones  = COUNT(1)          
                    FROM MovColdet MC   WITH (NOLOCK)          
                           INNER JOIN MOV  M   WITH (NOLOCK)          
                                  ON MC.nMovNro = M.nMovNro          
                           INNER JOIN Producto P   WITH (NOLOCK)          
                                  ON MC.cCtaCod = P.cCtaCod          
							INNER JOIN ProductoPersona PP WITH (NOLOCK)          
                                  ON P.cCtaCod = PP.cCtaCod           
                                        AND PP.nPrdPersRelac =20          
                    WHERE PP.cPersCod  = @cPersCodTitular          
					AND MC.cOpeCod IN ('130602','130600','130601','130603')          
                           AND M.nMovFlag = 0          
                    GROUP BY  PP.cPersCod          
          
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR, @nCantCondonacionesEnRecuperaciones)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 6          
          END              
       END           
          
    BEGIN -- [nIdVariable = 7] Exoneraciones por Campaña de Descuento según perio de tiempo determinado          
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 7)          
             BEGIN            
                    SELECT           
                           @nCantExoneracionxCampanaxPeriodoDeTiempo  = COUNT(1)          
                    FROM MovColdet MC   WITH (NOLOCK)          
                           INNER JOIN MOV  M   WITH (NOLOCK)          
                                  ON MC.nMovNro = M.nMovNro            
                           INNER JOIN Producto P WITH (NOLOCK)          
                                  ON MC.cCtaCod = P.cCtaCod          
                           INNER JOIN ProductoPersona PP WITH (NOLOCK)     
                                  ON P.cCtaCod = PP.cCtaCod           
                                        AND PP.nPrdPersRelac =20          
                    WHERE PP.cPersCod  = @cPersCodTitular          
                           AND CONVERT(DATE,LEFT(M.cMovNro, 8)) >= '2014-07-01' --ingresan a partir del mes de Julio 2014          
                           AND M.nMovFlag = 0          
                           AND DATEADD(YEAR, 2, CONVERT(DATE,LEFT(M.cMovNro, 8))) > @dFechaActual  --No es sujeto de crédito en un periodo de 02 años          
                           AND MC.cOpeCod='101310'          
                           AND (mc.nPrdConceptoCod IN ('1100','1101')         
                          OR mc.nPrdConceptoCod IN (SELECT a.nPrdConceptoCod FROM ColocTExoDetGas a with(nolock)  WHERE a.bConEstado=1 ))         
                    GROUP BY PP.cPersCod          
          
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR, @nCantExoneracionxCampanaxPeriodoDeTiempo)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 7          
             END              
       END           
          
    BEGIN -- [nIdVariable = 8] Codigo de Producto           
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 8)          
             BEGIN          
                        SELECT @cCredProducto  = (CASE WHEN ISNULL(@cCredProducto,'')='' AND ISNULL(@cCtaCod,'')<>'' THEN dbo.FN_GetcCredProducto(@cCtaCod) ELSE @cCredProducto END)          
          
                        UPDATE A          
                        SET A.cValorCalculado = CONVERT(VARCHAR, @cCredProducto)          
      FROM #DatosEntradaUnPivot A          
 WHERE nIdVariable = 8          
             END            
       END           
          
    BEGIN -- [nIdVariable = 9] Agencia          
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 9)          
             BEGIN          
          
                    UPDATE A          
                   SET A.cValorCalculado = CONVERT(VARCHAR(1000), ISNULL(@cAgeCod, ''))          
        FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 9          
             END        
       END           
          
    BEGIN -- [nIdVariable = 10] Personeria          
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 10)          
             BEGIN          
                    SET @nPersPersoneria = (SELECT ISNULL(nPersPersoneria, 0) FROM Persona WHERE cPersCod = @cPersCodTitular)          
          
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR, @nPersPersoneria)          
                    FROM #DatosEntradaUnPivot A          
      WHERE nIdVariable = 10          
             END              
       END           
          
    BEGIN -- [nIdVariable = 11] Validacion de ahorro cuenta sueldo          
     IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 11)          
             BEGIN          
                    SET @bAhorroCuentaSueldoValido  =          
  (SELECT           
                       CASE           
                                                             WHEN COUNT(1) >= 1 THEN 1          
    ELSE 0          
   END           
                                                                          FROM ITFExoneracionCta a       WITH (NOLOCK)          
                                                                         INNER JOIN ProductoPersona b     WITH (NOLOCK)          
                                                                                       ON a.cCtaCod = b.cCtaCod          
                                                                                 INNER JOIN producto c   WITH (NOLOCK)          
          ON a.cCtaCod = c.cCtaCod          
                                                                          WHERE a.nExoTpo = 3          
                                                                                 AND b.cPersCod = @cPersCodTitular           
                                                                                 AND b.nPrdPersRelac = 10          
                                                                                 AND c.nPrdEstado IN (1000, 1200, 1100)           
                                                                                 AND SUBSTRING(A.CCTACOD, 9, 1) = '1')          
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR, @bAhorroCuentaSueldoValido)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 11          
             END              
       END           
          
 BEGIN -- [nIdVariable = 12] Moneda          
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 12)          
             BEGIN          
                       
                    UPDATE A          
             SET A.cValorCalculado = @nMoneda          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 12          
          
             END          
       END          
          
    BEGIN -- [nIdVariable = ( 15 , 16)]          
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (15,16))          
             BEGIN            
                    SELECT    @nCantCredTitularCony = COUNT (pp.cperscod)            
                    FROM producto p       WITH (NOLOCK)          
                    INNER join productopersona pp WITH (NOLOCK)          
                    ON p.cctacod = pp.cctacod                
                    WHERE p.nprdestado in (2020,2021,2022,2030,2031,2032,2201,2205,2202)                
                    and nPrdPersRelac = 21 and pp.cperscod =@cPersCodTitular AND SUBSTRING(pp.cctacod,6,3) not in ('216','301','302','303','320','305','306')           
                              
  SELECT    @nCantCredConyugueTit = COUNT (pp.cperscod)            
                    FROM producto p       WITH (NOLOCK)
					INNER join productopersona pp        WITH (NOLOCK)          
                    on p.cctacod = pp.cctacod                
                    WHERE p.nprdestado in (2020,2021,2022,2030,2031,2032,2202)                
                    and nPrdPersRelac = 20 and pp.cperscod =@cPersCodConyugue          
                    and SUBSTRING(pp.cctacod,6,3) not in ('216','301','302','303','320','305','306')                 
          
          
                    UPDATE A          
                    SET A.cValorCalculado = (CASE WHEN nIdVariable=15 THEN @nCantCredTitularCony ELSE  @nCantCredConyugueTit END)          
     FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN ( 15 , 16)          
             END          
       END          
          
    BEGIN -- [nIdVariable = (17,18,19,21,22,23,25,27,28,89,93,144,125,126,163,168)          
           IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (17,18,19,21,22,23,25,27,28,89,93,114,125,126,163,168))           
           BEGIN          
          
                    SELECT @cCalifClient=dbo.GetCalificacionCliente(@cPersCodTitular)          
          
                    IF @cCalifClient=''          
                    BEGIN           
                           EXEC PA_SetCalificacionCliente @cPersCodTitular,@cCalifClient OUTPUT          
                    END          
          
                    SET @cCalifClient=(CASE WHEN LEN(@cCalifClient) > 0 Then  Substring(@cCalifClient,1,PATINDEX('% %',@cCalifClient)) ELSE '' END   )          
          
                        UPDATE A          
                        SET A.cValorCalculado = (CASE WHEN nIdVariable=17 THEN @nColocCondicion           
                                                                              WHEN nIdVariable=18 THEN @nColocCondicion2          
                                                                              WHEN nIdVariable=19 THEN @nCodDestino           
                                                                              WHEN nIdVariable=21 THEN @nIdCampana           
                                                                              WHEN nIdVariable=22 THEN @nCuotas           
                     WHEN nIdVariable=202 THEN @nCuotas           
                                                                              WHEN nIdVariable=23 THEN @nPlazo           
                                                                              WHEN nIdVariable=25 THEN @nNumRefinan           
         WHEN nIdVariable=27 THEN @nPlazoGracia           
                                                                              WHEN nIdVariable=28 THEN @nTipoCredito                                                                                   
                                                                              END)          
                        FROM #DatosEntradaUnPivot A          
                        WHERE nIdVariable IN (17,18,19,21,22,23,25,27,28,202)          
          
                        UPDATE A          
                 SET A.cValorCalculado = SUBSTRING(@cCalifClient,1,3)          
                        FROM #DatosEntradaUnPivot A          
                        WHERE nIdVariable =93          
          
                        UPDATE A          
                        SET A.cValorCalculado = @nTasa          
                        FROM #DatosEntradaUnPivot A          
                        WHERE nIdVariable =114          
                                  
                        UPDATE A          
                        SET A.cValorCalculado = @nTipoPeriodicidad          
                        FROM #DatosEntradaUnPivot A          
                        WHERE nIdVariable =125          
          
                        UPDATE A          
                        SET A.cValorCalculado = @nMonto          
                        FROM #DatosEntradaUnPivot A          
                        WHERE nIdVariable IN(126,203)          
          
          
                       UPDATE A          
                        SET A.cValorCalculado = ISNULL(@nRatio,0)          
                        FROM #DatosEntradaUnPivot A          
                        WHERE nIdVariable =89          
          
   UPDATE A          
        SET A.cValorCalculado = (CASE WHEN nIdVariable=141 THEN @nPlazoGracia          
                                                                WHEN nIdVariable=163 THEN @bAplicaMicroseguro          
                                                                WHEN nIdVariable=168 THEN @nPeriodoDiaPago          
            END)          
                        FROM #DatosEntradaUnPivot A          
                        WHERE nIdVariable IN(141,163,168)          
          
          
           END          
       END          
          
    BEGIN -- [nIdVariable = 20]          
           IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =20)          
           BEGIN           
                 DECLARE @TAmp TABLE           
                 (           
                             nId                      INT IDENTITY(1,1) PRIMARY KEY ,           
                             cCtaCod                  VARCHAR(18),           
                             bPagoAdelantado   BIT,           
                             nCuotas                  DECIMAL(10,2),           
                             nCuotasPagadas    DECIMAL(10,2),           
                             nPorcentaje       DECIMAL(10,2),           
                             nCuotasPorcentaje DECIMAL(10,2),           
                             bPorcentajeEsMayor BIT DEFAULT(0),           
                             bValida                  BIT DEFAULT(0)           
            )            
          
                 DECLARE @N INT = 1,@cCtaCodPivot VARCHAR(18)          
          
                 CREATE TABLE #TCalenEval          
                 (          
							cCtaCod           VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,          
							 nNroCalen  INT NOT NULL,          
                             nCuota            INT NOT NULL,          
                             nColocCalendEstado INT NOT NULL,          
                             dVenc             DATE NOT NULL,          
                             dPago             DATE NOT NULL,          
                            nDiasAtraso INT NOT NULL,          
                             nMovNro           INT NULL          
                 );          
                 ALTER TABLE #TCalenEval ADD  PRIMARY KEY NONCLUSTERED (cCtaCod, nNroCalen, nCuota);          
          
                 INSERT @TAmp (cCtaCod, bPagoAdelantado )          
                 SELECT cCtaCod,0           
                 FROM #CreditosProcesar           
                 WHERE nCodProceso=1          
          
                           
          
                 WHILE @N <= (SELECT MAX(nId) FROM @TAmp )           
               BEGIN          
                    SET @cCtaCodPivot = (SELECT cCtaCod FROM @TAmp WHERE nId = @N)          
                              
                     INSERT INTO #TCalenEval (cCtaCod, nNroCalen, nCuota, nColocCalendEstado, dVenc, dPago, nDiasAtraso, nMovNro)          
                    EXEC Colocaciones.FluGen_SelCuotasCreditoEval_SP @cCtaCodPivot                             
                              
                     SET @N = @N + 1          
               END          
          
    --ACTUALIZANDO CUOTAS PAGADAS DE CADA CREDITO          
        UPDATE A          
               SET A.nCuotas = Y.nCuotas, A.nCuotasPagadas = Y.nCuotasPagadas            
               FROM @TAmp A          
                    INNER JOIN (          
                                               SELECT A.cCtaCod, COUNT(1) AS nCuotas, SUM(CASE WHEN B.nColocCalendEstado = 1 THEN 1 ELSE 0 END)  AS nCuotasPagadas          
                                               FROM @TAmp A          
                                               INNER JOIN #TCalenEval B          
                                                          ON A.cCtaCod = B.cCtaCod
												GROUP BY A.cCtaCod          
                                               )  Y          
       ON A.cCtaCod = Y.cCtaCod          
                                     
               UPDATE A          
               SET A.nCuotasPorcentaje =           
                     CASE          
    WHEN @nTipoCredito <> 4 AND @cCredProducto NOT IN ('302','216') THEN A.nCuotas * 0.3          
                               ELSE A.nCuotas * 0.2           
                     END           
               FROM @TAmp A          
                       
              UPDATE A          
        SET A.bValida =           
                     CASE          
              WHEN @nTipoCredito = 4 OR @cCredProducto IN ('302','216') THEN           
                       CASE           
                                        WHEN  nCuotasPagadas >=  ROUND(nCuotasPorcentaje,0) THEN 1          
                ELSE 0          
                                  END                    
                               WHEN @nTipoCredito = 3    OR @nCodDestino = 1 THEN                                                  
                                          CASE          
                                               WHEN  nCuotasPagadas < 6 THEN 0          
                                               ELSE 1          
                                          END           
                          WHEN @nCodDestino = 2 AND @nSubDestinosId IN (0,2,3,4,5,6) THEN                                                                                                
                                          CASE           
                                                          WHEN nCuotasPagadas >= 6 AND nCuotasPagadas >=  ROUND(nCuotasPorcentaje,0) THEN 1          
                                               ELSE 0          
                                          END                           
                     END          
               FROM @TAmp A                
                       
                 UPDATE A          
                 SET A.cValorCalculado = (SELECT COUNT(1) FROM @TAmp WHERE bValida = 0 )          
                 FROM #DatosEntradaUnPivot A          
 WHERE nIdVariable =20            
          
          
                 DROP TABLE #TCalenEval          
           END          
       END          
          
    BEGIN -- [nIdVariable = 24]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =24)          
             BEGIN           
                     SELECT PP.cPersCoD AS Codigo ,PER.CPERSNOMBRE as Nombres , COUNT(DISTINCT (PP1.cPersCod)) AS [Garantizados]              
                     INTO #GARANTIZA          
                    FROM PRODUCTO P     WITH (NOLOCK)          
                             INNER JOIN PRODUCTOPERSONA PP   WITH (NOLOCK)          
                                    ON P.cCtaCod = PP.cCtaCod                 
                             INNER JOIN #PersonaRelacionCred X           
                                     ON PP.cPersCod =X.cPersCod           
                             INNER JOIN  PRODUCTOPERSONA PP1     WITH (NOLOCK)           
                                    ON P.cCtaCod = PP1.cCtaCod                  
                             INNER JOIN Persona PE       WITH (NOLOCK)          
                                    ON pp.cPersCod = PE.cPersCod                    
                             INNER JOIN  Persona PER    WITH (NOLOCK)          
                                    ON PP.cPersCod = PER.cPersCod                   WHERE NPRDESTADO IN(2000,2001,2020,2021,2022,2030,2032,2031,2201,2205)              
   AND X.nPersRelac=25          
                             AND pp.nPrdPersRelac = 25              
AND pp1.nPrdPersRelac = 20              
                             AND PE.nPersPersoneria = 1              
                      GROUP BY PP.cPersCoD,PER.CPERSNOMBRE           
          
                      SET @nGarantizadosAval=(SELECT max(Garantizados) FROM #GARANTIZA)          
          
                      SET @cNombreGarantExc=(SELECT TOP 1 Nombres FROM #GARANTIZA)           
                      SET @cNombreGarantExc=ISNULL(@cNombreGarantExc,'')          
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@nGarantizadosAval,0)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =24          
                                                  
                     DROP TABLE #GARANTIZA          
    END          
       END          
          
    BEGIN -- [nIdVariable = 26]          
		IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =26)
		BEGIN
			SELECT @nCredtsAtrasoAmp = COUNT(P.cCtaCod)
			FROM Producto P WITH (NOLOCK)
				INNER JOIN ProductoPersona PP WITH (NOLOCK)
					ON PP.cCtaCod = P.cCtaCod
					   AND PP.nPrdPersRelac = 20
				INNER JOIN ColocacCred C WITH (NOLOCK)
					ON C.cCtaCod = P.cCtaCod
				INNER JOIN Persona Per WITH (NOLOCK)
					ON PP.cPersCod = Per.cPersCod
			WHERE P.nPrdEstado in ( 2020, 2021, 2022, 2030, 2031, 2032 )
				  AND PP.cPersCod IN (
										 SELECT cPersCod
										 FROM #PersonaRelacionCred
										 WHERE nPersRelac IN ( 20, 21, 22, 23, 24, 25 )
									 )
				  AND C.nDiasAtraso >= CASE
										   --PAGADIARIO PERMITE 1 DIA DE ATRASO EN SOLICITUD Y SUGERENCIA          
										   WHEN (@nColocCondicion2 <> 1)
												AND dbo.FN_GetcCredProducto(P.cCtaCod) = '210' then
											   2
										   ELSE
											   1
									   END
			UPDATE A
			SET A.cValorCalculado = @nCredtsAtrasoAmp
			FROM #DatosEntradaUnPivot A
			WHERE nIdVariable = 26
		END   
    END          
          
    BEGIN -- [nIdVariable = 29]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =29)          
        BEGIN           
                     DECLARE @nSaldoCapTotalMercado MONEY          
                               ,@nPorc           DECIMAL(18,2)          
          
    DECLARE @TotalColocMercado TABLE(          
                             codAgencia    varchar(2) NOT NULL,          
          nSaldoCap      money NOT NULL,          
                             nSaldoCapMercado money NOT NULL          
                      )          
          
                    TRUNCATE TABLE #ConsolAlineaRiesgoCrediticioDia

                    SET @nPorc=0.5          
          
                    INSERT INTO #ConsolAlineaRiesgoCrediticioDia          
                    SELECT Fecha, codAgencia, nTipoCreditos, codProducto, Moneda, linea, nSaldoCap           
                     FROM ConsolAlineaRiesgoCrediticio          
                    WHERE Fecha>=DATEADD(day,-1,@dFechaActual) and Fecha<  @dFechaActual          
          
                    INSERT INTO @TotalColocMercado          
                    SELECT codAgencia, SUM(case when Moneda = 1 then nSaldoCap else nSaldoCap * @tipoCambio end)          
                               ,SUM(case when Moneda = 1 then nSaldoCap else nSaldoCap * @tipoCambio end)           
                     FROM #ConsolAlineaRiesgoCrediticioDia          
                    GROUP BY codAgencia          
                    
      UPDATE @TotalColocMercado           
     set           
      nSaldoCap = nSaldoCap + (case when @nMoneda = '1' then @nMonto else @nMonto * @tipoCambio end), nSaldoCapMercado = nSaldoCapMercado + (case when @nMoneda= '1' then @nMonto else @nMonto * @tipoCambio end)          
     WHERE codAgencia = @cAgeCod          
          
                    UPDATE @TotalColocMercado set nSaldoCapMercado =(select SUM(nSaldoCap) from @TotalColocMercado where codAgencia in ('01','18','41'))          
                    where codAgencia in ('01','18','41')          
          
                    IF @cAgeCod NOT IN ('01','18','41')          
                              UPDATE @TotalColocMercado set nSaldoCapMercado = 0 where codAgencia in ('18','41')          
                    IF @cAgeCod = '01'          
                              UPDATE @TotalColocMercado set nSaldoCapMercado = 0 where codAgencia in ('18','41')          
                    IF @cAgeCod = '18'          
                          UPDATE @TotalColocMercado set nSaldoCapMercado = 0 where codAgencia in ('01','41')          
                    IF @cAgeCod = '41'          
                              UPDATE @TotalColocMercado set nSaldoCapMercado = 0 where codAgencia in ('01','18')          
          
                    
                    
                     --Agrupo Agencias Chincha, Pueblo Nuevo          
                    UPDATE @TotalColocMercado set nSaldoCapMercado =  (select SUM(nSaldoCap) from @TotalColocMercado           
                                               where codAgencia in ('02','23')       
                          ) where codAgencia in ('02','23')          
          
                    IF @cAgeCod NOT IN('02','23')          
                  UPDATE @TotalColocMercado set nSaldoCapMercado = 0 where codAgencia in ('23')          
                    IF @cAgeCod = '02'          
                           UPDATE @TotalColocMercado set nSaldoCapMercado = 0 where codAgencia in ('23')          
     IF @cAgeCod = '23'          
                           UPDATE @TotalColocMercado set nSaldoCapMercado = 0 where codAgencia in ('02')          
                              
                    
                     SELECT @nSaldoCapTotalMercado = (select SUM(nSaldoCap) from @TotalColocMercado)          
                    SELECT @nNumCredtPorctMercado = coalesce(COUNT(*),0)           
                     FROM @TotalColocMercado          
                    WHERE nSaldoCapMercado > @nPorc * @nSaldoCapTotalMercado and codAgencia = @cAgeCod          
                              
                     SELECT @nPorcentMercado=convert(varchar(999), nSaldoCapMercado * 100 / @nSaldoCapTotalMercado)           
                     FROM @TotalColocMercado --SE UTILIZA PARA CONSTRUIR MENSAJE VARIABLE (80)          
                    SET @nPorcentMercado=ISNULL(@nPorcentMercado,0)          
          
                    UPDATE A          
                    SET A.cValorCalculado = @nNumCredtPorctMercado          
                    FROM #DatosEntradaUnPivot A          
     WHERE nIdVariable =29          
               END          
		END          
          
    BEGIN -- [nIdVariable = (30,31)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (30,31))          
		BEGIN              
          TRUNCATE TABLE #ConsolAlineaRiesgoCrediticioDia          
          TRUNCATE TABLE #tipocreditos           
          
                    INSERT INTO #ConsolAlineaRiesgoCrediticioDia              
                     SELECT Fecha, codAgencia, nTipoCreditos, codProducto, Moneda, linea, nSaldoCap           
                     FROM ConsolAlineaRiesgoCrediticio    WITH (NOLOCK)          
                    WHERE Fecha>=DATEADD(day, -1, @dFechaActual) and Fecha< @dFechaActual          
          
                    INSERT INTO #tipocreditos           
                     SELECT NTipoCreditos, coalesce(sum(case when Moneda = 1 then nSaldoCap else nSaldoCap * @tipoCambio end), 0) as Saldos                 
                     FROM #ConsolAlineaRiesgoCrediticioDia              
                     GROUP BY nTipoCreditos              
          
        UPDATE #tipocreditos           
                     SET           
                     Saldos = Saldos + (CASE WHEN @nMoneda = '1' THEN @nMonto ELSE @nMonto * @tipoCambio END)              
                     WHERE nTipoCreditos = @nTipoCredito              
          
     UPDATE A          
                SET A.cValorCalculado = ISNULL((CASE WHEN nIdVariable =30 THEN           
                                                                     (SELECT coalesce(SUM (saldos), 0) FROM #tipocreditos           
                                                                      WHERE nTipoCreditos = @nTipoCredito)          
                                                            ELSE           
                                                                     (SELECT COALESCE(SUM (saldos),0) from #tipocreditos)            
            END ),0)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN (30,31)          
               END          
    END          
          
    BEGIN -- [nIdVariable = (32,33)]          
           IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(32,33))          
             BEGIN           
                     TRUNCATE TABLE #ConsolAlineaRiesgoCrediticioDia             
                     TRUNCATE TABLE #tipocreditos          
          
                    INSERT INTO #ConsolAlineaRiesgoCrediticioDia          
                    SELECT Fecha, codAgencia, nTipoCreditos, codProducto, Moneda, linea, nSaldoCap from ConsolAlineaRiesgoCrediticio          
                    WHERE Fecha>=DATEADD(day, -1, @dFechaActual) and Fecha<@dFechaActual         
                         
                     INSERT INTO #tipocreditos          
                    SELECT 0 as nTipoCreditos, coalesce(sum(case when Moneda = 1 then nSaldoCap else nSaldoCap * @tipoCambio end), 0) as Saldos                        
          FROM #ConsolAlineaRiesgoCrediticioDia          
          
                    UPDATE #tipocreditos SET Saldos = Saldos + (CASE WHEN @nMoneda = '1' THEN @nMonto ELSE @nMonto * @tipoCambio END)           
                         
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL((CASE WHEN nIdVariable =32 THEN           
                                                                     ((SELECT SUM(case when Moneda = 1 then nSaldoCap else nSaldoCap * @tipoCambio end)                                                                                                       
  
                                                                           FROM #ConsolAlineaRiesgoCrediticioDia WHERE codProducto in ('202','102')) +           
                                                                       (CASE WHEN @nMoneda = '1' THEN @nMonto ELSE @nMonto * @tipoCambio END)           
                                                                     )          
                                                            ELSE           
                                                                     (SELECT COALESCE(SUM (saldos),0) from #tipocreditos)            
                                                             END ),0)          
        FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN (32,33)          
          
               END          
 END          
          
    BEGIN -- [nIdVariable = (34,35)]          
           IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(34,35))          
             BEGIN           
                    TRUNCATE TABLE #ConsolAlineaRiesgoCrediticioDia          
                    TRUNCATE TABLE #tipocreditos          
          
                    INSERT INTO #ConsolAlineaRiesgoCrediticioDia          
                    SELECT Fecha, codAgencia, nTipoCreditos, codProducto, Moneda, linea, nSaldoCap           
                     FROM ConsolAlineaRiesgoCrediticio          
                    WHERE Fecha>=DATEADD(day, -1, @dFechaActual) and Fecha< @dFechaActual          
          
                    INSERT INTO #tipocreditos          
                    SELECT 0 as nTipoCreditos, coalesce(sum(case when Moneda = 1 then nSaldoCap else nSaldoCap * @tipoCambio end), 0) as Saldos                            
                     FROM #ConsolAlineaRiesgoCrediticioDia          
          
                UPDATE #tipocreditos SET Saldos = Saldos + (case when @nMoneda= '1' then @nMonto ELSE @nMonto * @tipoCambio end)          
          
          
                    UPDATE A          
              SET A.cValorCalculado = ISNULL((CASE WHEN nIdVariable =34 THEN           
                                         ((SELECT SUM(case when Moneda = 1 then nSaldoCap else nSaldoCap * @tipoCambio end)                
                                                                           FROM #ConsolAlineaRiesgoCrediticioDia WHERE nTipoCreditos =4) +           
                                             (CASE WHEN @nMoneda = '1' THEN @nMonto ELSE @nMonto * @tipoCambio END)           
                             )          
       WHEN nIdVariable =35 THEN           
        (SELECT COALESCE(SUM (saldos),0) from #tipocreditos)            
          END ),0)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN (34,35)          
          
             END          
       END          
          
    BEGIN -- [nIdVariable = (36,37)]          
          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (36,37))          
             BEGIN           
                              
                    TRUNCATE TABLE #ConsolAlineaRiesgoCrediticioDia          
                              
                    INSERT INTO #ConsolAlineaRiesgoCrediticioDia                
                    SELECT Fecha, codAgencia, nTipoCreditos, codProducto, Moneda, linea, nSaldoCap           
                    FROM ConsolAlineaRiesgoCrediticio  WITH (NOLOCK)              
     WHERE Fecha>=DATEADD(day, -1, @dFechaActual) and Fecha< @dFechaActual          
          
          
                    SELECT Moneda, SUM(CASE WHEN Moneda = 1 THEN nSaldoCap ELSE nSaldoCap * @tipoCambio END) AS Saldos                
  INTO #Moneda                
                    FROM #ConsolAlineaRiesgoCrediticioDia                
                    GROUP BY Moneda             
          
                    UPDATE #Moneda set Saldos = Saldos + (case when @nMoneda = '1' then @nMonto else @nMonto* @tipoCambio end)                
                    WHERE Moneda = @nMoneda            
          
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL((CASE WHEN nIdVariable =36 THEN           
                                                                     ((SELECT SUM(case when Moneda = 1 then nSaldoCap else nSaldoCap * @tipoCambio end)                                                                                                        
 
                                                                           FROM #ConsolAlineaRiesgoCrediticioDia WHERE nTipoCreditos =4) +           
                                                                      (CASE WHEN @nMoneda = '1' THEN @nMonto ELSE @nMonto * @tipoCambio END)           
                                                                     )          
                   WHEN nIdVariable =37 THEN           
                                                                     (select coalesce(SUM (saldos),0) from #Moneda WHERE Moneda =@nMoneda )            
                                                  END ),0)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN (36,37)          
          
                    DROP TABLE #Moneda                
               END          
       END          
                 
    BEGIN -- [nIdVariable = (38,39,40)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(38,39,40))          
               BEGIN          
                    UPDATE A          
                    SET A.cValorCalculado = (SELECT count(cPersCod)          
                            FROM FN_ListaCodigosTrabajadoresFamiliares(@cPersCodTitular,1))          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =38          
        
              UPDATE A          
                    SET A.cValorCalculado = (CONVERT(DECIMAL(18,2),(SELECT nConsSisValor FROM ConstSistema WHERE nConsSisCod = 460)) + @nMonto)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =39          
          
                    UPDATE A          
                    SET A.cValorCalculado = (Select X.Patrimonio_mes           
 from colocreporte13info X          
                                                               where cPeriodo=(SELECT MAX(cPeriodo) FROM colocreporte13info WHERE cVigencia='1')          
															   and x.cVigencia = '1'          
                           )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =40          
          
  END         
       END          
          
    BEGIN -- [nIdVariable = (41,42,43,44,45,46)]          
           IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (41,42,43,44,45,46))          
               BEGIN          
                                     
               --NOTA : LOS CREDITOS A AMPLIAR O REFINANCIAR NO DEBEN CONTABILIZARSE (FALTA IMPLEMENTAR)          
          
                    SELECT a.cCtaCod,              
                                     ISNULL(E.cAgeGrupo,E.cAgeCod) cAgeCodM,          
                                     E.cAgeDescripcion,                
                                     D.nTipoCreditos,                                     
                                     a.nSaldo,          
                                     b.cPersCod,              
                                     b.nPrdPersRelac,              
                                     d.dVigencia,              
                                     F.cCredProductos AS cCredProductos,          
                                     1 as bValidoOtrasAgencias,          
                                     1 as bValidoNumCRed,          
                                   F.cDescripcion AS cDesProducto          
            INTO #TbCreVigPro              
                    FROM Producto a     WITH (NOLOCK)          
 INNER JOIN ProductoPersona b    WITH (NOLOCK)          
        ON a.cCtaCod=b.cCtaCod               
            INNER JOIN Colocaciones d    WITH (NOLOCK)          
                           ON a.cCtaCod=d.cCtaCod             
                    INNER JOIN AGENCIAS E      WITH (NOLOCK)          
                           ON E.cAgeCod=a.cAgeCod         
                  INNER JOIN CredProductos F  with(nolock)        
                           ON F.cCredProductos=dbo.FN_GetcCredProducto(A.cCtaCod)          
                    WHERE b.cPersCod=@cPersCodTitular              
                           AND b.nPrdPersRelac=20            
                           AND a.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2101,2104,2106,2107,2201,2205)              
                           AND NOT EXISTS (SELECT cCtaCod FROM ColocacCred with(nolock) WHERE cCtaCod=a.cCtaCod AND cRFA IN ('rfa','vch'))                
         AND a.cCtaCod NOT IN (SELECT B.cCtaCod FROM #CreditosNoCoberturados B)         
                              
                     --No consideramos a los créditos ('302','216','210','301','207') ya que estos pueden solicitarse en cualquier Agencia (Angel Anicama)              
                     --Tambien se debe descartar a los Pignoraticios ('305','306')              
                     UPDATE #TbCreVigPro SET bValidoOtrasAgencias=0          
                    WHERE cCredProductos IN ('302','216','210','301','207','305','306')               
          
                    --No se toman en consideracion para contabilizar cantidad de creditos del cliente          
                    UPDATE #TbCreVigPro SET bValidoNumCRed=0          
               WHERE cCredProductos IN ('302','216','121','221', '305','306')          
             
                     --Luego elegimos al crédito con mayor antiguedad ya que ese determina su inicio en la CMACICA              
                     UPDATE #TbCreVigPro SET bValidoOtrasAgencias=0 WHERE dVigencia<>(SELECT MIN(dVigencia) FROM #TbCreVigPro)              
                               
                    IF (@cCredProducto = '302')          
     BEGIN          
      SET @nNumCredClient=(SELECT COUNT(1) FROM #TbCreVigPro WHERE bValidoNumCRed=1 and cCredProductos != '302')          
     END          
     ELSE          
     BEGIN          
      SET @nNumCredClient=(SELECT COUNT(1) FROM #TbCreVigPro WHERE bValidoNumCRed=1)          
      SET @nNumCredClient = @nNumCredClient + 1 -- (+1) PORQUE SE TOMA EL CUENTA EL QUE SE ESTA PROPONIENDO          
     END          
          
             SET @nNumCredHipotClient=(SELECT COUNT(1) FROM #TbCreVigPro WHERE bValidoNumCRed=1 AND nTipoCreditos=4 AND @nPersPersoneria=1)          
            SET @nNumCredDesctoClient=(SELECT COUNT(1) FROM #TbCreVigPro WHERE bValidoNumCRed=1 AND cCredProductos NOT IN ('323','301'))          
                    SET @nNumCredCMIClient=(SELECT COUNT(1) FROM #TbCreVigPro WHERE bValidoNumCRed=1 AND nTipoCreditos=4 AND cCredProductos ='320')          
          
          
                    IF (@cCredProducto NOT IN ('302','216','210','301','207','320') AND (SELECT COUNT(1) FROM #TbCreVigPro WHERE bValidoOtrasAgencias=1 AND cAgeCodM<>@cAgeCodGrupo)>=1  )          
                    BEGIN          
                SET @bCredOtraAgencia=1          
          
                               SELECT TOP 1 @cCredDescOA=UPPER(cDesProducto)          
                                          ,@cAgeDescOA=UPPER(cAgeDescripcion)          
                                          ,@cCtaCodOA=cCtaCod          
                           FROM #TbCreVigPro          
          
                    END          
          
          
                    SELECT @nMontoCredVigDirecTrab = Sum(a.nSaldo)          
                    FROM Producto a WITH (NOLOCK)          
                           INNER JOIN ProductoPersona b        WITH (NOLOCK)          
                                     ON a.cCtaCod = b.cCtaCod and nPrdPersRelac = 20          
                           LEFT JOIN ColocProductoComer c WITH (NOLOCK)          
                               on a.cCtaCod=c.cCtaCod          
                           WHERE b.cPersCod = @cPersCodTitular          
                               AND Isnull(c.cSubProducto,SUBSTRING(a.cCtaCod,6,3)) = '320'          
                               AND a.nPrdEstado in (2020,2021,2022,2030,2031,2032)          
                      AND a.cCtaCod not in (select cCtaCodAmp from ColocacAmpliado with(nolock) where cCtaCod = @cCtaCod)          
          
          
          
                UPDATE A          
                    SET A.cValorCalculado =( CASE           
            WHEN nIdVariable=41 THEN IIF(@nIdCampana IN (161), 0, @bCredOtraAgencia)          
                                                WHEN nIdVariable=43 THEN @nNumCredClient           
            WHEN nIdVariable=44 THEN @nNumCredHipotClient + IIF(@nPersPersoneria=1,1,0)          
            WHEN nIdVariable=45 THEN @nNumCredDesctoClient + IIF(@cCredProducto IN ('323','301') and @nColocCondicion<>4,1,0) --no se considera (+1) cuando es ampliado          
            WHEN nIdVariable=46 THEN @nNumCredCMIClient + IIF(@cCredProducto = '320' and @nColocCondicion<>4,1,0)           
                                            END)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN(41,43,44,45,46)          
          
                      UPDATE A          
                    SET A.cValorCalculado = ISNULL(@nMontoCredVigDirecTrab,0) + @nMonto          
                                                        
                     FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =42          
          
          
                    DROP TABLE #TbCreVigPro          
               END          
       END          
              
    BEGIN -- [nIdVariable = (47,48,49,50)]          
       IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (47,48,49,50))          
               BEGIN          
                      UPDATE A          
 SET A.cValorCalculado = (CASE WHEN nIdVariable=47 THEN (SELECT nConsSisValor FROM ConstSistema WHERE nConsSisCod=6151)           
                                                               WHEN nIdVariable=48 THEN  (SELECT nConsSisValor FROM ConstSistema	with(nolock)  WHERE nConsSisCod=6152)           
                                                               WHEN nIdVariable=49 THEN  (SELECT nConsSisValor FROM ConstSistema	with(nolock)  WHERE nConsSisCod=6153)           
                                                               WHEN nIdVariable=50 THEN  (SELECT nConsSisValor FROM ConstSistema	with(nolock)  WHERE nConsSisCod=6154)  END)          
                        FROM #DatosEntradaUnPivot A          
                        WHERE nIdVariable IN (47,48,49,50)          
                            
                
              END          
       END              
          
    BEGIN -- [nIdVariable = (51)]          
       IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (51))          
               BEGIN          
                    SELECT @nMontoMaxDirecTrab =  nMontoEvaFin          
                    FROM CredProductos  WITH (NOLOCK)          
                    WHERE cCredProductos = '320'          
          
                    UPDATE A          
                    SET A.cValorCalculado = @nMontoMaxDirecTrab          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =51          
                              
                               
               END          
       END          
          
    BEGIN -- [nIdVariable = (52)]          
       IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (52))          
                 BEGIN          
                 DECLARE @nMontoCreditos money          
                    SELECT  @nMontoCreditos = coalesce(sum(pr.nSaldo * case when substring(pp.cCtaCod, 9, 1)='1' then 1 else @tipoCambio end),0)          
                    from Persona p  WITH (NOLOCK)          
                    inner join ProductoPersona pp WITH (NOLOCK)          
                    on p.cPersCod = pp.cPersCod and nPrdPersRelac = 20          
                    and p.cPersCod = @cPersCodTitular          
                    inner join Producto pr WITH (NOLOCK)          
                    on pp.cCtaCod = pr.cCtaCod          
                    where pr.nPrdEstado in (2002,2020,2021,2022,2030,2031,2032,2101,2104)          
                    and pr.cCtaCod not in (select cCtaCodAmp as cCtaCod from ColocacAmpliado with(nolock) where cCtaCod=@cCtaCod          
         union          
                                              select cCtaCodRef from ColocacRefinanc where cCtaCod=@cCtaCod)          
          
          
                    UPDATE A          
                    SET A.cValorCalculado = @nMontoCreditos          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =52          
                              
                               
               END          
       END          
                     
    BEGIN -- [nIdVariable = (53,54)]          
		IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(53,54)) 
		BEGIN
			DECLARE @TotalColocMercadoLP TABLE
			(
				codAgencia VARCHAR(2) NOT NULL,
				linea VARCHAR(1) NOT NULL,
				nSaldoCap MONEY NOT NULL,
				nSaldoCapMercado MONEY NOT NULL
			)

			TRUNCATE TABLE #ConsolAlineaRiesgoCrediticioDia

			INSERT INTO #ConsolAlineaRiesgoCrediticioDia (Fecha, codAgencia, nTipoCreditos, codProducto, Moneda, linea, nSaldoCap)
			SELECT Fecha,
				   codAgencia,
				   nTipoCreditos,
				   codProducto,
				   Moneda,
				   linea,
				   nSaldoCap
			from ConsolAlineaRiesgoCrediticio WITH (NOLOCK)
			WHERE Fecha >= DATEADD(DAY, -1, @dFechaActual)
				  and Fecha < @dFechaActual

			INSERT INTO @TotalColocMercadoLP (codAgencia, linea, nSaldoCap, nSaldoCapMercado)
			SELECT codAgencia,
				   linea,
				   SUM(   case
							  when Moneda = 1 then
								  nSaldoCap
							  else
								  nSaldoCap * @tipoCambio
						  end
					  ),
				   SUM(   case
							  when Moneda = 1 then
								  nSaldoCap
							  else
								  nSaldoCap * @tipoCambio
						  end
					  )
			FROM #ConsolAlineaRiesgoCrediticioDia
			GROUP BY codAgencia,
					 linea

			--Agrego el monto del crédito LP     
			UPDATE @TotalColocMercadoLP
			set nSaldoCap = nSaldoCap + (case
											 when @nMoneda = '1' then
												 @nMonto
											 else
												 @nMonto * @tipoCambio
										 end
										),
				nSaldoCapMercado = nSaldoCapMercado + (case
														   when @nMoneda = '1' then
															   @nMonto
														   else
															   @nMonto * @tipoCambio
													   end
													  )
			WHERE codAgencia = @cAgeCod
				  and @nMoneda = '2' --VERIFICAR          


			SET @nSaldoColocMercado =
			(
				SELECT SUM(   case
								  when SUBSTRING(P.cctacod, 9, 1) = '1' then
									  nSaldo
								  else
									  nSaldo * @tipoCambio
							  end
						  )
				FROM Producto P WITH (NOLOCK)
					INNER JOIN Colocaciones COL WITH (NOLOCK)
						ON P.cCtaCod = COL.cCtaCod
				WHERE P.nPrdEstado in ( 2020, 2021, 2022, 2030, 2031, 2032, 2201, 2205, 2101, 2104, 2106, 2107 )
					  AND DATEDIFF(day, COL.dVigencia, COL.dVenc) > 1097
			)


			UPDATE A
			SET A.cValorCalculado = ISNULL(   (CASE
												   WHEN nIdVariable = 53 THEN
													   @nSaldoColocMercado
												   WHEN nIdVariable = 54 THEN
												   (
													   select SUM(nSaldoCap) from @TotalColocMercadoLP
												   )
											   END
											  ),
											  0
										  )
			FROM #DatosEntradaUnPivot A
			WHERE nIdVariable IN ( 53, 54 )


		END
	END

    BEGIN -- [nIdVariable = (55,56)]
		IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(55,56))          
        BEGIN
			IF @nIdCampana IN (49)
			BEGIN
				SELECT @nSaldoColocCofiGas = SUM(   case
														when SUBSTRING(P.cctacod, 9, 1) = '1' then
															nSaldo
														else
															nSaldo * @tipoCambio
													end
												)
				FROM Producto P WITH (NOLOCK)
					INNER JOIN ColocacCred COL WITH (NOLOCK)
						ON P.cCtaCod = COL.cCtaCod
				WHERE P.nPrdEstado in ( 2020, 2021, 2022, 2030, 2031, 2032, 2201, 2205, 2101, 2104, 2106, 2107 )
					  AND COL.IdCampana = 49

				SELECT @nSaldoCartera = SUM(   case
												   when SUBSTRING(P.cctacod, 9, 1) = '1' then
													   ISNULL(P.nSaldo, 0)
												   WHEN SUBSTRING(P.cctacod, 9, 1) = '2' then
													   ISNULL(P.nSaldo * @tipoCambio, 0)
											   END
										   )
				FROM Producto P WITH (NOLOCK)
				WHERE P.nPrdEstado in ( 2020, 2021, 2022, 2030, 2031, 2032, 2201, 2205, 2101, 2104, 2106, 2107 )
					  AND NOT EXISTS
				(
					select cctacod
					from colocaccred WITH (NOLOCK)
					where cctacod = P.cctacod
						  and crfa in ( 'rfa', 'vch' )
				)

				UPDATE A
				SET A.cValorCalculado = (CASE
											 WHEN nIdVariable = 55 THEN
												 @nSaldoColocCofiGas
											 WHEN nIdVariable = 56 THEN
												 @nSaldoCartera
										 END
										)
				FROM #DatosEntradaUnPivot A
				WHERE nIdVariable IN ( 55, 56 )
			END
			ELSE
			BEGIN
				UPDATE A
				SET A.cValorCalculado = 0
				FROM #DatosEntradaUnPivot A
				WHERE nIdVariable IN ( 55, 56 )
			END

			

		END      
    END          
          
    BEGIN -- [nIdVariable = (57,58)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(57,58))          
             BEGIN           
                     DECLARE @bExisteCajaRCCTit          INT=0          
              ,@bExisteCajaRCCConyu   INT=0          
                               ,@bExisteCajaTitular      INT=0          
                      ,@bExisteCajaConyugue   INT=0          
                               ,@nEnt   INT=0          
                               ,@nEntDuplicadas    INT=0          
                               ,@nEntTarjCons            INT=0          
                               ,@bIncluyeCaja            BIT          
 ,@bIncluyeCajaConyuge   BIT           
                               ,@numCtaExcep             INT=0          
                               ,@nLiberaRegla            INT=0          
                               ,@bValidaRango BIT          
                        ,@nMontoMIn DECIMAL(18,2)          
           ,@nMontoMax DECIMAL(18,2)          
          
                    IF @CodSbsTit<>''          
                           BEGIN          
                           SELECT @nEnt=Can_Ents          
                           FROM dbrcc.dbo.rcctotalult rtu  WITH (NOLOCK)          
                           WHERE Cod_Sbs=@CodSbsTit          
                    END          
          
          
                    SELECT @nMaxNumIfis=nConsSisValor FROM ConstSistema with(nolock) WHERE nConsSisCod=455            
                              
                    IF EXISTS (select cCredProducto from ColocProductoMaximoEntidades with(nolock) where cCredProducto = @cCredProducto and bEstado = 1)          
                    BEGIN          
                     SELECT           
                                  @bValidaRango = bAplicaRangoMonto,          
                                  @nMontoMIn = nRangoMontoMinimo,          
                                  @nMontoMax=nRangoMontoMaximo          
                           FROM           
                                  ColocProductoMaximoEntidades where cCredProducto = @cCredProducto and bEstado = 1          
          
                           IF @bValidaRango = 1           
                           BEGIN          
                                  IF @nmonto BETWEEN @nMontoMIn AND @nMontoMax          
                                  BEGIN          
                                        SELECT           
                                               @nMaxNumIfis = nNumEnt - bIncluyeCmac          
                                        FROM          
                                               ColocProductoMaximoEntidades           
                                        WHERE          
                                               cCredProducto = @cCredProducto          
                                  END          
                           END          
                           ELSE          
                           BEGIN          
                                  SELECT           
                                        @nMaxNumIfis = nNumEnt - bIncluyeCmac          
                                  FROM          
                  ColocProductoMaximoEntidades           
                                  WHERE          
                                       cCredProducto = @cCredProducto                    
                           END          
         END          
          
                    --SI titular tiene a CMACICA como IFI en RCC                      
      SET @bExisteCajaRCCTit=case when (select COUNT(rtdu.Cod_Sbs)          
                                               from dbrcc.dbo.RccTotalDetUlt rtdu   WITH (NOLOCK)          
                                               where rtdu.Cod_Sbs =@CodSbsTit and rtdu.Cod_Emp='00108'          
                                               and ((Cod_Cuenta like '14_[13456]%') OR (Cod_Cuenta like '7[12]_[12345]%') Or (Cod_Cuenta like '81_302%')))>=1           
                                               then 1 else 0 end               
                                                  --SI titular ya tiene credito en la CMAC                                                                  
      SET @bExisteCajaTitular=CASE WHEN (select count(P.cCtaCod) from Producto P  WITH (NOLOCK)              
                                                          JOIN ProductoPersona PP WITH (NOLOCK)          
                            on P.cCtaCod=PP.cCtaCod and PP.cPersCod=@cPersCodTitular and nPrdPersRelac=20              
         AND P.nPrdEstado in (2020,2021,2022,2030,2031,2032,2201,2205,2101,2104,2106,2107,2202,2206))>=1           
                                                              THEN 1 ELSE 0 END               
          
                  --Para que no cuente doble a la CMACICA como entidad del titular            
                     SELECT @nEnt=@nEnt - @bExisteCajaRCCTit + @bExisteCajaTitular            
                     SET @bIncluyeCaja=CASE WHEN  (@bExisteCajaTitular)>=1 THEN  CAST(1 AS BIT) ELSE CAST(0 AS BIT) END             
          
                      --Obteniendo detalle de entidades del titular para validar que no se duplique con las del conyuge          
                    SELECT DISTINCT COD_SBS,Cod_Emp           
                     INTO #DetEntTit          
         FROM dbrcc.dbo.RccTotalDetUlt rtdu  WITH (NOLOCK)          
                WHERE rtdu.Cod_Sbs = @CodSbsTit          
          
                    IF LTRIM(RTRIM(@CodSbsConyugue))<>''            
                     BEGIN            
                           SELECT @nEnt=@nEnt+ Can_Ents  FROM dbrcc.dbo.rcctotalult rtu   WHERE Cod_Sbs=@CodSbsConyugue          
          
                           --SI Conyuge tiene a cmacica como IFI en RCC                      
            SET @bExisteCajaRCCConyu=CASE WHEN (select COUNT(rtdu.Cod_Sbs) from dbrcc.dbo.RccTotalDetUlt rtdu     WITH (NOLOCK)          
                                                   where rtdu.Cod_Sbs =@CodSbsConyugue and    rtdu.Cod_Emp='00108'                
       and ((Cod_Cuenta like '14_[13456]%') OR (Cod_Cuenta like '7[12]_[12345]%') Or (Cod_Cuenta like '81_302%'))              
                                                                           )>=1 THEN 1 ELSE 0 END           
                     END          
                    --Si Conyuge ya tiene credito en la CMAC          
                    SET @bExisteCajaConyugue =  CASE WHEN (SELECT count(P.cCtaCod) from Producto P     WITH (NOLOCK)          
                                                               JOIN ProductoPersona PP WITH (NOLOCK)          
                                                                     on P.cCtaCod=PP.cCtaCod and PP.cPersCod=@cPersCodConyugue and nPrdPersRelac=20              
                                                               AND P.nPrdEstado in (2020,2021,2022,2030,2031,2032,2201,2205,2101,2104,2106,2107,2202,2206)) >=1 then 1 else 0 end                 
                               
          
                    --para que no cuente doble a la CMACICA como entidad del titular            
                     SELECT @nEnt= @nEnt - @bExisteCajaRCCConyu + IIf(@bExisteCajaTitular>0,0,@bExisteCajaConyugue)              
                     SET @bIncluyeCajaConyuge=CASE WHEN  (@BEXISTECAJACONYUGUE)>=1 THEN  CAST(1 AS BIT) ELSE CAST(0 AS BIT) END              
                           
                      --Obteniendo detalle de entidades del Conyuge, para validar que no se duplique con las del titular          
                    SELECT DISTINCT COD_SBS,Cod_Emp           
                     INTO #DetEntCony          
                    From dbrcc.dbo.RccTotalDetUlt rtdu   WITH (NOLOCK)            
                     Where rtdu.Cod_Sbs = @CodSbsConyugue                  
                      
       --Verificando entidades duplicadas en titular y conyuge              
                     SELECT @nEntDuplicadas = COUNT(a.cod_sbs)           
                     FROM #DetEntTit A           
                    INNER JOIN #DetEntCony b ON a.cod_emp = b.cod_emp              
          
                    SET @nEnt = @nEnt - @nEntDuplicadas          
       
                              
                    --Validando si producto maneja un maximo de entidades diferenciado(tabla ColocProductoMaximoEntidades)          
                    --Verificando si maximo incluye a la cmac o no.          
                    IF  Exists (select cCredProducto from ColocProductoMaximoEntidades where cCredProducto = @cCredProducto and bEstado = 1)          
                    BEGIN  --LFAM 09-08-2017 valida nro de entidades diferenciado          
                           IF @bValidaRango = 1           
                           BEGIN          
                                  IF @nmonto between @nMontoMIn and @nMontoMax  --valida nro de entidades diferenciado para un rango especifico          
                                  BEGIN          
                                        IF (@bIncluyeCaja = 1 or @bIncluyeCajaConyuge = 1) --si entidades incluyen la caja. se debe quitar, porque el limite no considera a la caja          
                                               set @nEnt = @nEnt - 1                                    
                                  END              
                                  ELSE --si no valida nro de entidades diferenciado(aplica 4 ent.incluyendo la cmac, segun politica)          
                                  BEGIN          
                            IF (@bIncluyeCaja = 0 and @bIncluyeCajaConyuge = 0) --se cliente no tiene a la cmac como entidad, se le agrega una entidad.          
                                               set @nEnt = @nEnt + 1                
END                   
                           END         
                           ELSE --valida nro de entidades diferenciado          
                           BEGIN          
                                  IF (@bIncluyeCaja = 1 or @bIncluyeCajaConyuge = 1) --si entidades incluyen la caja. se debe quitar, porque el limite no considera a la caja          
                                         SET @nEnt = @nEnt - 1                             
                           END          
                    END          
                    ELSE  --si no valida nro de entidades diferenciado(aplica 4 ent.incluyendo la cmac, segun politica)          
                BEGIN          
                           IF (@bIncluyeCaja = 0 and @bIncluyeCajaConyuge = 0) --se cliente no tiene a la cmac como entidad, se le agrega una entidad.          
                                  set @nEnt = @nEnt + 1                
                    END                
                              
                     --Validacion de entidad por tarjeta de consumo          
                 IF( @nTipoCredito = 10 or  @nTipoCredito = 11 or  @nTipoCredito = 12 or  @nTipoCredito = 13)          
                 BEGIN          
                           SET @nEntTarjCons = CASE WHEN (SELECT COUNT(rtdu.Cod_Sbs)           
                                                                                          FROM DBRCC.dbo.RccTotalDetUlt rtdu  WITH (NOLOCK)             
                                                                                         WHERE rtdu.Cod_Sbs IN (@CodSbsTit,@CodSbsConyugue)          
                                                                                           AND (Cod_Cuenta like '14[12]1[01][123]02%' OR     -- Créditos Vigentes Tarjetas de Crédito (CC,GE,ME,PE,ME,CO)          
                                                                                                     Cod_Cuenta like '72[12]5%')                  -- Responsabilidad por löneas de crédito no utilizadas y créditos concedidos no desembolsados          
                               )>=1 then 1           
                                               ELSE 0           
                                                                   END           
                                             
                           SET @nMaxNumIfis = @nMaxNumIfis + @nEntTarjCons          
         End           
                    
          
                 -- DALH / No se considera N° entidad mientras  Cod_Cuenta  like '29_1070%'                      
            SET @numCtaExcep =  (SELECT COUNT(ENT)           
                      FROM           
                                                    (SELECT COUNT(DISTINCT(rtdu.COD_EMP)) AS 'ENT' from           
                                                    dbrcc.dbo.RccTotalDetUlt rtdu WITH (NOLOCK)          
                                                    INNER JOIN dbrcc.dbo.RccTotalDetUlt C WITH (NOLOCK)          
                                ON  C.Cod_Sbs= rtdu.Cod_Sbs  AND C.Cod_Cuenta like '29_1070%'  AND C.COD_EMP= rtdu.COD_EMP           
            WHERE rtdu.Cod_Sbs IN (@CodSbsTit,@CodSbsConyugue)          
               GROUP BY rtdu.COD_EMP          
                                                    HAVING COUNT(rtdu.COD_cuenta)<=1          
                                                    )A          
                                   )          
            
                                       
            IF @numCtaExcep > 0          
            BEGIN          
               SET @nEnt = @nEnt - @numCtaExcep          
            END          
                         
               --Liberacion de IFIS según Constancia de Cancelación de Deuda.          
               IF @cCtaCod<>''          
               BEGIN          
                    SELECT @nLiberaRegla=SUM(ISNULL(nValorLib,0))         
                    FROM ColocLiberacionRegla   WITH (NOLOCK)          
                    WHERE nCodAlinea=34          
                           AND nEstado=1          
                           AND cCtaCod=@cCtaCod          
                     
                     SET @nEnt=@nEnt-ISNULL(@nLiberaRegla,0)          
               END          
          
    IF NOT EXISTS (SELECT 1 FROM RRHH A with(nolock)           
      INNER JOIN (SELECT MAX(B.cUltimaActualizacion) cUltimaActualizacion,B.cPersCod FROM RRHH B with(nolock) WHERE B.cPersCod = @cPersCodTitular GROUP BY B.cPersCod) C          
      ON A.cPersCod = C.cPersCod AND A.cUltimaActualizacion = C.cUltimaActualizacion          
      WHERE A.nRHEstado NOT LIKE '8%')          
    BEGIN          
     IF ( @nIdCampana IN (SELECT IdCampana FROM colocaciones.DesembolsoRapidoCampana with(nolock) WHERE bEstado = 1 AND bCliPref = 1 AND IdCampana != 148) AND @nEtapa = 15)               
     BEGIN          
      SET @nMaxNumIfis = 1          
     END          
               
     IF ( @nEtapa = 15 AND (SELECT COUNT(cPersCod)          
                    FROM RRHH with(nolock)       
                    WHERE cPersCod = @cPersCodTitular AND LEFT(crhcod , 1) = 'E'           
     AND nRHEstado NOT LIKE '8%' ) > 0 )                   
     BEGIN          
      SET @nMaxNumIfis = 3          
     END          
    END          
          
    IF (@nIdCampana IN (140,152,161,162, 185))          
    BEGIN          
     SET @nMaxNumIfis = 99          
    END          
          
    DECLARE @TablaRespuestaNuevaIFIS TABLE          
    (          
      nTipo INT,          
      nValCaja INT,          
      nValCliente INT        
    )          
    DECLARE @dNuevaMetRSE DATE          
    SET @dNuevaMetRSE = CONVERT(DATE,(SELECT nConsSisValor FROM ConstSistema with(nolock) WHERE nConsSisCod=8502),103)          
          
    IF (@dNuevaMetRSE < @dFechaActual)          
    BEGIN           
     DECLARE @nIdCampanaProv VARCHAR(5)          
               
     SELECT @nIdCampanaProv = CASE WHEN @nEtapa = 15 AND @cCredProducto = 320 THEN           
           (SELECT TOP 1 A.IdCampana FROM COLOCACIONES.CreditosEnLineaPersona A with(nolock) WHERE A.cPersIDnro = @cPersIdNro AND A.cTipCli = '4' ORDER  BY  A.IdCampana DESC)           
           ELSE @nIdCampana END          
               
     INSERT INTO @TablaRespuestaNuevaIFIS (nTipo,nValCaja,nValCliente)          
     EXEC COLOCACIONES.FluCre_SelValidarNumeroEntidades_SP @cCtaCod,'',@cPersIdNro,@nColocCondicion,4,@nIdCampanaProv,@cCredProducto,@nMonto,0,@nTipoCredito,@nColocCondicion2,@cNumDOIConyugue           
               
     SELECT @nMaxNumIfis = C.nValCaja , @nEnt = C.nValCliente FROM @TablaRespuestaNuevaIFIS C WHERE C.nTipo = 1          
          
    END          
            IF (@nIdCampana IN (161))          
    BEGIN          
     SET @nMaxNumIfis = 99          
    END          
              
  UPDATE A          
               SET A.cValorCalculado = (CASE WHEN nIdVariable=57 THEN @nMaxNumIfis          
        WHEN nIdVariable=58 THEN @nEnt END)          
               FROM #DatosEntradaUnPivot A          
               WHERE nIdVariable IN(57,58)          
          
          
          
               DROP TABLE #DetEntTit,#DetEntCony          
          
           END          
       END          
              
 BEGIN -- [nIdVariable = (59,60)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(59,60))          
BEGIN           
                               
   SELECT PP.cPersCoD AS Codigo, PER.CPERSNOMBRE as Nombres, COUNT(DISTINCT (PP1.cPersCod)) AS numCodeudor           
                    INTO #ParticipCodeu          
                    FROM PRODUCTO P  WITH (NOLOCK)           
                           INNER JOIN PRODUCTOPERSONA PP  WITH (NOLOCK)        
                                  ON P.cCtaCod = PP.cCtaCod             
                           INNER JOIN PRODUCTOPERSONA PP1 WITH (NOLOCK)              
                                  ON P.cCtaCod = PP1.cCtaCod                
                           INNER JOIN Persona PE WITH (NOLOCK)           
                                  ON pp.cPersCod = PE.cPersCod                  
                           INNER JOIN  Persona PER WITH (NOLOCK)          
                                  ON PP.cPersCod = PER.cPersCod                 
                    WHERE PP.CPERSCOD IN (SELECT cPersCod FROM #PersonaRelacionCred WHERE nPersRelac=22)          
                           AND NPRDESTADO IN(2000,2001,2020,2021,2022,2030,2032,2031,2201,2205)            
                           AND pp.nPrdPersRelac = 22            
                           AND pp1.nPrdPersRelac = 20            
                           AND PE.nPersPersoneria = 1            
                    GROUP BY PP.cPersCoD,PER.CPERSNOMBRE            
          
          
                    SET @nNumPartCodeudor = (SELECT MAX(numCodeudor) FROM #ParticipCodeu)          
             SET @nNumPartCodeudor=ISNULL(@nNumPartCodeudor,0)          
          
 UPDATE A          
     SET A.cValorCalculado = (CASE WHEN nIdVariable=59 THEN (SELECT  CONVERT(INT,nParamValor) FROM ColocParametro WHERE nParamVar = '102741')          
                                              WHEN nIdVariable=60 THEN @nNumPartCodeudor END)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN(59,60)          
          
              DROP TABLE #ParticipCodeu          
          
   END          
       END          
          
    BEGIN -- [nIdVariable = (61,62)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(61,62))          
             BEGIN           
                     CREATE TABLE #CUENTA (          
                                  cCtacod                 VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,             
                                  nPrdEstado       INT,          
                                  cDescripEstado          VARCHAR(500),          
                                  dPRDESTADO       DATE,          
                                  nPrdPersRelac     VARCHAR(5)      COLLATE SQL_Latin1_General_CP1_CI_AS,             
                                  cDescripcionRel    VARCHAR(500),          
                                  bFiador                 BIT          
                                  )          
            
          
                    INSERT INTO  #CUENTA(cCtacod ,nPrdEstado,cDescripEstado ,dPRDESTADO,nPrdPersRelac,cDescripcionRel,bFiador )          
                    SELECT P.cCtaCod ,P.nPrdEstado,C.cConsDescripcion ,P.dPrdEstado ,PP.nPrdPersRelac,D.cConsDescripcion,0          
                    FROM ProductoPersona PP WITH (NOLOCK)          
                    INNER JOIN PRODUCTO P WITH (NOLOCK)          
                           ON PP.cCtaCod=P.cCtaCod          
					INNER JOIN PERSONA PER WITH (NOLOCK)          
                           ON PER.cPersCod =PP.cPersCod          
                    INNER JOIN PersID ID WITH (NOLOCK)          
                           ON ID.cPersCod=PER.cPersCod          
                    INNER JOIN Constante C WITH (NOLOCK)          
                           ON P.nPrdEstado=C.nConsValor          
                    INNER JOIN Constante D WITH (NOLOCK)          
     ON PP.nPrdPersRelac=D.nConsValor          
                    WHERE P.nPrdEstado IN (2201,2202,2203,2204,2205,2206)          
                    AND PP.nPrdPersRelac IN (20)          
     AND PP.cPersCod=@cPersCodTitular         
                    AND C.nConsCod=3001          
                    AND D.nConsCod=3002          
                    AND NOT EXISTS (SELECT cCtaCod FROM colocExceptuadoReglaJudCast CE  WITH (NOLOCK)           
     WHERE CE.cCtaCod =PP.cCtaCod AND CE.cPersCod =PP.cPersCod           
                                                AND CE.nPrdPersRelac=PP.nPrdPersRelac )          
          
                    INSERT INTO #CUENTA(cCtacod,nPrdEstado,cDescripEstado,dPRDESTADO,nPrdPersRelac,cDescripcionRel,bFiador )          
                    SELECT A.cCtaCod,A.nPrdEstado,C.cConsDescripcion,A.dPrdEstado,B.nPrdPersRelac,D.cConsDescripcion,1          
                    FROM PRODUCTO A WITH (NOLOCK)          
                           INNER JOIN ProductoPersona B        WITH (NOLOCK)          
                               ON A.cCtaCod=B.cCtaCod          
                           INNER JOIN Constante C WITH (NOLOCK)          
                               ON A.nPrdEstado=C.nConsValor          
                           INNER JOIN Constante D WITH (NOLOCK)          
                               ON B.nPrdPersRelac=D.nConsValor          
                    WHERE B.cPersCod IN (SELECT cPersCod FROM #PersonaRelacionCred WHERE nPersRelac=25)          
                           AND B.nPrdPersRelac IN (20,21,22,23,24,25)          
                           AND A.nPrdEstado IN (2201,2202,2203,2204,2205,2206)          
                           AND C.nConsCod=3001          
                           AND D.nConsCod=3002          
          
          
                    DELETE FROM #CUENTA WHERE nPrdEstado IN (2203,2204) AND bFiador=1 AND DATEDIFF(DAY,dPRDESTADO,@dFechaActual)>=730          
          
IF @nIdCampana IN (132,140,152,162, 185)          
         BEGIN          
        DELETE FROM #CUENTA           
                     WHERE nPrdEstado IN (2203,2204)           
                               AND bFiador=0           
              AND CONVERT(NVARCHAR(MAX),dPRDESTADO,112)<>CONVERT(NVARCHAR(MAX),DATEADD(YEAR,-2,@dFechaActual),112)          
                               AND DATEDIFF(DAY,dPRDESTADO,@dFechaActual)>730          
                    END          
          
          
                   UPDATE A          
     SET A.cValorCalculado = (CASE           
            WHEN nIdVariable=61 THEN IIF(@nIdCampana IN (161), 0, (SELECT COUNT(1) FROM #CUENTA WHERE bFiador=0))          
                                                WHEN nIdVariable=62 THEN IIF(@nIdCampana IN (161), 0, (SELECT COUNT(1) FROM #CUENTA WHERE bFiador=1))          
           END)          
                  FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN(61,62)          
          
                    DROP TABLE #CUENTA          
             END          
      END          
          
    BEGIN -- [nIdVariable = 63]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =63)          
             BEGIN           
                     DECLARE @nMesesHorizonte    INT          
                              ,@cFecha             VARCHAR(8)          
          
                    SELECT @nMesesHorizonte=CONVERT(INT,nConsSisValor) FROM ConstSistema with(nolock) WHERE nConsSisCod =6155          
                    SELECT @cFecha=CONVERT(VARCHAR(8),(DATEADD(MONTH,-(@nMesesHorizonte),@dFechaActual)),112)          
          
                    IF @nIdCampana IN (125,128,129,130)          
                    BEGIN          
                           SET @cFecha = CONVERT(VARCHAR(8),(DATEADD(MONTH,-(36),@dFechaActual)),112) -- 3 años maximo para la campaña          
                    END          
                    IF @nIdCampana IN (133,134)          
                    BEGIN          
      SET @cFecha = CONVERT(VARCHAR(8),(DATEADD(MONTH,-(24),@dFechaActual)),112) -- 2 años maximo para la campaña 133          
                    END          
          
                    IF @nIdCampana IN (SELECT IdCampana FROM colocaciones.DesembolsoRapidoCampana with(nolock) WHERE bEstado = 1 AND bCliPref = 1 AND IdCampana != 148)          
     BEGIN          
      SET @cFecha = CONVERT(VARCHAR(8),(DATEADD(MONTH,-(12),@dFechaActual)),112) -- 1 años maximo para la campaña 136          
                    END          
          
     IF @nIdCampana IN (141,148)          
                    BEGIN          
      --SET @cFecha = CONVERT(VARCHAR(8),(DATEADD(MONTH,-(1),@dFechaActual)),112) -- 1 mes maximo para la campaña 141          
      SET @cFecha = CONVERT(VARCHAR(8),(dateadd(d,-day(@dFechaRCC) + 1,@dFechaRCC)),112)          
                    END          
          
     IF @nIdCampana IN (140,152,162, 185)          
     BEGIN          
      SET @cFecha = CONVERT(VARCHAR(8),(DATEADD(MONTH,-(0),@dFechaActual)),112) -- 1 años maximo para la campaña 136          
                    END    
    
     IF @nIdCampana IN (191,195)    
     BEGIN    
      SET @cFecha = CONVERT(VARCHAR(8), (DATEADD(MONTH, -(1), @dFechaActual)), 112) -- 1 mes maximo para campaña    
     END    
          
     --[01] Identificando todos los créditos relacionados          
                    SELECT a.cPersIDnro,          
                              b.cPersCod,          
                              c.cCtaCod,          
                              c.nPrdEstado          
                       INTO #ProductoTotal          
                      FROM PersID a  WITH (NOLOCK)        
                      INNER JOIN ProductoPersona b   WITH (NOLOCK)          
                           ON a.cPersCod=b.cPersCod                                     
                      INNER JOIN Producto c   WITH (NOLOCK)          
                           ON b.cCtaCod=c.cCtaCod          
                   WHERE B.cPersCod=@cPersCodTitular AND b.nPrdPersRelac=20          
          
          
                      --[02] Identificando todas las operaciones de condonación          
                    SELECT A.cCtaCod,          
                               B.nCredEstado,          
                               B.cOpeCod,          
                               B.nDiasMora,          
                               B.nMovNro,          
                               CONVERT(DATE,LEFT(cMovNro,8),112) dFecha,          
             d.nTipoCreditos          
          INTO #Movimientos          
                    FROM #ProductoTotal a          
                               INNER JOIN MovCol b WITH (NOLOCK)          
                                     ON a.cCtaCod=b.cCtaCod          
                               INNER JOIN Colocaciones d   WITH (NOLOCK)          
                  ON a.cCtaCod=d.cCtaCod          
                               INNER JOIN Mov c    WITH (NOLOCK)          
                                     ON b.nMovNro=c.nMovNro          
                                          AND c.nMovFlag in (0)          
                          AND LEFT(cMovNro,8)>=@cFecha          
        INNER JOIN MovColDet E WITH (NOLOCK)    
         ON E.nMovNro = B.nMovNro    
          AND E.cOpeCod = B.cOpeCod    
          AND E.cCtaCod = B.cCtaCod    
          AND E.nNroCalen = B.nNroCalen    
      WHERE (B.cOpeCod IN('100918') AND ((E.nPrdConceptoCod IN (1101, 1119) AND SUBSTRING(C.cMovNro, 1, 8) < '20200317') OR (E.nPrdConceptoCod NOT IN (1101, 1119))))    
       OR b.cOpeCod IN(          
                                               --'100918',   -- CONDONACION DE MORA Y GASTOS          
                                               '130602',   -- CANCELACION DE CREDITO CASTIGADO CONDONACION          
                    '105051', -- CONDONACIÓN DE INTERÉS Y OTRO POR ÓRGANOS RESOLUTORIOS.          
                                               '101310',   -- DESCUENTO POR CAMPAÑA (EXONERACION)          
                                               '101311',   -- DESCUENTO POR CAMPAÑA (EXONERACION) CAPITAL VENCIDO          
                                               '101312',   -- DESCUENTO POR CAMPAÑA (EXONERACION) CAPITAL REFINANCIADO          
                                               '101313',   -- DESCUENTO POR CAMPAÑA (EXONERACION) CAPITAL VIGENTE          
                                               '130602',   -- CANCELACION DE CREDITO CASTIGADO CONDONACION          
                                               '130600',   -- CANCELACION DE CREDITO          
                                               '130601',   -- CANCELACION DE CREDITO JUDICIAL          
                                               '130603'           -- CANCELACIÓN DE VENCIDOS       
                                               )    
                              
            --[03] Actualizando el estado de los créditos antiguos          
                      UPDATE a          
                           SET a.nCredEstado=b.nPrdEstado -- SELECT *          
                      FROM #Movimientos a           
                           INNER JOIN ColocacEstado b WITH (NOLOCK)          
                               ON a.cCtaCod=b.cCtaCod           
                                     AND b.dPrdEstado=(SELECT MAX(x.dPrdEstado) FROM ColocacEstado x WITH (NOLOCK) WHERE x.cCtaCod=b.cCtaCod AND x.dPrdEstado<=a.dFecha)          
                      WHERE a.nCredEstado IS NULL          
          
 --[04] Si el crédito se encontraba vigente no se considerará la "Condonación de Mora y Gastos"          
                      DELETE FROM #Movimientos WHERE (cOpeCod='100918' AND nCredEstado IN (2020,2030))          
          
       IF (SELECT COUNT(1)FROM #Movimientos) > 0 and @nIdCampana IN (SELECT IdCampana FROM colocaciones.DesembolsoRapidoCampana WHERE bEstado = 1 AND bCliPref = 1 AND IdCampana != 148)          
      BEGIN          
          DECLARE @dFechaUltCred DATE          
          SET @dFechaUltCred = (select max(ce.dPrdEstado) from persona pe  with(nolock) join PersID pei with(nolock) on pe.cPersCod=pei.cPersCod          
          join ProductoPersona pp with(nolock) on pe.cPersCod=pp.cPersCod and pp.nPrdPersRelac = 20          
 join ColocacEstado ce WITH (NOLOCK) on pp.cCtaCod=ce.cCtaCod and ce.nPrdEstado = 2020          
          where pei.cPersIDnro =  @cPersIDnro and ce.dPrdEstado = (select min(dPrdEstado) from ColocacEstado WITH (NOLOCK) where cCtaCod = pp.cCtaCod and nPrdEstado = 2020))          
                       
          IF @dFechaUltCred IS NOT NULL          
          IF @dFechaUltCred >= (select max(dFecha) from #Movimientos)          
          TRUNCATE TABLE #Movimientos          
                       
      END          
          
     DELETE A FROM #Movimientos A INNER JOIN MovColDet B with(nolock) ON A.nMovNro = B.nMovNro AND A.cCtaCod = B.cCtaCod           
     WHERE B.nPrdConceptoCod IN           
     (          
      124350, --GASTO POR NOTIFICACION CMAC ICA (>=5 DIAS ATRASO)           
      124359, --GASTO POR NOTIFICACION CMAC ICA (>=5 DIAS ATRASO)          
   124360, --GASTO POR NOTIFICACION CMAC ICA (>=5 DIAS ATRASO)           
      124361, --GASTO POR NOTIFICACION CMAC ICA (>=8 DIAS ATRASO)          
      124362, --GASTO POR NOTIFICACION CMAC ICA (>=31 DIAS ATRASO)          
      124363 --GASTO POR NOTIFICACION CMAC ICA (>=61 DIAS ATRASO)          
     )          
          
                    UPDATE A          
                    SET A.cValorCalculado = IIF(@nIdCampana IN(132,140,152,161,162, 185),0, (SELECT COUNT(1) FROM #Movimientos ))          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =63          
          
           DROP TABLE #ProductoTotal,#Movimientos          
             END          
       END          
          
    BEGIN -- [nIdVariable = 64]            
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =64)            
    BEGIN             
            
          CREATE TABLE #MontoTalDeudaD(            
                               cPerscod        VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS            
                               ,nMonto         DECIMAL(18,2)            
                           )                 
                                       
                     CREATE TABLE #CFAplicaExposicionD (            
     cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS            
     ,nAplicaExposicionCred INT DEFAULT(0)            
                               );            
                                                                    
            
                    IF (@cCtaCod)<>''            
                           BEGIN            
                               INSERT INTO #MontoTalDeudaD            
                               EXEC PA_ObtieneMontoDeudaTotal @cCtaCod                 
                           END            
                    ELSE            
          BEGIN                                        
            
  INSERT INTO #CFAplicaExposicionD (cCtaCod, nAplicaExposicionCred)       
                           SELECT             
                                    A.cCtaCod,             
                                    SUM(CASE             
                                                      WHEN nTipoColateralID IN  (3, 4, 5, 6, 7, 8, 9) THEN 1            
                                                      ELSE 0            
                                           END) AS nAplicaExposicionCred            
                           FROM Producto A WITH (NOLOCK)          
                                    INNER JOIN ColocGarantia B      WITH (NOLOCK)            
                                           ON A.cCtaCod = B.cCtaCod             
                                    INNER JOIN Garantias C     WITH (NOLOCK)            
                                           ON B.cNumGarant = C.cNumGarant             
                           WHERE SUBSTRING(A.cCtaCod,6,3)  IN ('121','221')            
                                    AND A.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)            
       GROUP BY A.cCtaCod             
              
                                
                           IF @cCredProducto IN ('121','221')            
                           BEGIN          
               
        SELECT PP.cPersCod,P.nSaldo,P.cCtaCod      
        INTO #CRED_121_221      
        FROM Producto P  WITH (NOLOCK)               
        JOIN ProductoPersona PP WITH (NOLOCK)            
        ON P.cCtaCod = PP.cCtaCod          
                                AND PP.nPrdPersRelac = 20                                  
                                    LEFT JOIN #CFAplicaExposicionD A            
                                           ON P.cCtaCod = A.cCtaCod             
                                    WHERE PP.cPersCod = @cPersCodTitular             
                                           AND P.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)                        
                                           AND SUBSTRING(p.cctacod,6,3)  in ('121','221')            
        AND A.nAplicaExposicionCred = 1            
        AND P.cCtaCod NOT IN (SELECT cCtaCodRen as cCtaCod FROM ColocRenovacion x with(nolock) WHERE x.cCtaCod=@cCtaCod)       
              
         SELECT       
         @nSaldoCubierto = ISNULL(SUM(Case When SubString(A.cCtaCod,9,1)='1' then A.nMontoConG Else A.nMontoConG*@tipoCambio End),0)      
         FROM #CreditosNoCoberturados A      
         WHERE A.cCtaCod IN (SELECT C.cCtaCod FROM #CRED_121_221 C)      
         AND A.IdCampana IN (160,164)      
                                    INSERT INTO #MontoTalDeudaD(cPerscod,nMonto)          
        SELECT A.cPersCod,                                      
                                          nSaldo = SUM(CASE WHEN @nMoneda='1'       
              THEN (CASE WHEN Substring(A.cCtaCod,9,1)='1'       
                THEN A.nSaldo             
                ELSE A.nSaldo*@tipoCambio             
                                                                                                                                                       END)          
                                                         ELSE (CASE WHEN SUBSTRING(A.cCtaCod,9,1)='1'       
                THEN A.nSaldo/@tipoCambio             
                                                                ELSE A.nSaldo             
                                                                                                                                                                                        END)                        
                                                         END) - @nSaldoCubierto      
        FROM #CRED_121_221 A            
        GROUP BY A.cPersCod            
                           END               
                           ELSE                 
                           BEGIN      
       SELECT A.*      
       INTO #CRED_NO_121_221      
    FROM      
       (      
          SELECT PP.cPersCod,P.nSaldo,P.cCtaCod      
   FROM Producto P    WITH (NOLOCK)          
                                         INNER JOIN ProductoPersona PP       WITH (NOLOCK)          
                                     ON P.cCtaCod = PP.cCtaCod          
                                                                       AND PP.nPrdPersRelac = 20          
               WHERE PP.cPersCod = @cPersCodTitular          
                                                      AND P.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)          
             AND SUBSTRING(p.cctacod,6,3) NOT IN ('121','221','241','302','216')          
        AND P.cCtaCod NOT IN (SELECT cCtaCodAmp as cCtaCod FROM ColocacAmpliado WHERE cCtaCod = @cCtaCod UNION       
                                                                                                     SELECT cCtaCodRef FROM ColocacRefinanc WHERE cCtaCod=@cCtaCod)             
          
                                           UNION           
        SELECT B.cPersCod,A.nMontoAsig nSaldo,A.cLineaCod cCtaCod      
        FROM LineaCredito A     WITH (NOLOCK)            
         INNER JOIN LineaCreditoPersona B  WITH (NOLOCK) ON A.cLineaCod = B.cLineaCod AND B.nLinPersRelac = 20      
         WHERE B.cPersCod = @cPersCodTitular            
         AND A.nLinEstado IN (2020)      
        ) A      
          
                                           SELECT           
         @nSaldoCubierto = ISNULL(SUM(Case When SubString(A.cCtaCod,9,1)='1' then A.nMontoConG Else A.nMontoConG*@tipoCambio End),0)      
         FROM #CreditosNoCoberturados A      
         WHERE A.cCtaCod IN (SELECT C.cCtaCod FROM #CRED_NO_121_221 C)      
         AND A.IdCampana IN (160,164)      
                                INSERT INTO #MontoTalDeudaD(cPerscod,nMonto)            
        SELECT X.cPersCod, ISNULL(SUM(nSaldo), 0) nSaldo            
                                FROM (SELECT A.cPersCod,                          
                                                 nSaldo = ISNULL(SUM(CASE WHEN @nMoneda='1'       
                  THEN (CASE WHEN SUBSTRING(A.cCtaCod,9,1)='1'       
                    THEN A.nSaldo          
                                                                                ELSE A.nSaldo*@tipoCambio             
      END)          
                          ELSE (CASE WHEN SUBSTRING(A.cCtaCod,9,1)='1'       
                    THEN A.nSaldo/@tipoCambio             
                                                                                ELSE A.nSaldo             
                                               END)          
                                                                        END), 0) - @nSaldoCubierto      
         FROM #CRED_NO_121_221 A           
                                     GROUP BY A.cPersCod) X            
                                    GROUP BY X.cPersCod          
                           END              
          
                    END          
                              
                     SET @nMontoTotalDeuda=(SELECT SUM(nMonto) FROM #MontoTalDeudaD)          
          
                      SET @nMontoTotalDeuda = (CASE WHEN @nMoneda=1 then ROUND(isnull(@nMontoTotalDeuda,0)/@tipoCambio,2) else ROUND(isnull(@nMontoTotalDeuda,0),2) end) + (CASE WHEN @nMoneda=1 THEN ROUND(@nMonto/@tipoCambio,2) ELSE @nMonto END)          
  
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@nMontoTotalDeuda,0)           
                     FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =64          
          
                    DROP TABLE #MontoTalDeudaD          
                    DROP TABLE #CFAplicaExposicionD          
             END          
       END          
          
    BEGIN -- [nIdVariable = (65,66,67)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (64,65,66,67))          
             BEGIN           
          
    SET @nRegPolizaInd =(CASE WHEN @cCtaCod<>'' THEN            
                     (CASE WHEN (SELECT COUNT(1) FROM CambioValorSegDesg WHERE cCtaCod =@cCtaCod AND nEstado <>2)>0 THEN 1 ELSE 0 END)          
                                        ELSE 0 END)           
                                                                  
    SET @nRegPolizaGlob=(CASE WHEN @cCtaCod<>'' THEN            
                                        (CASE WHEN (SELECT COUNT(1) FROM PolizaGlobalDesg WHERE cCtaCod =@cCtaCod )>0 THEN 1 ELSE 0 END)          
                                                          ELSE 0 END)                          
          
    IF (@bCanalDigital = 1)      
    BEGIN      
     SET @nRegPolizaInd = 1      
     SET @nRegPolizaGlob = 1      
    END      
      
    IF (@cCtaCod <>'')          
    BEGIN          
     IF EXISTS (select 1 from PolizaEndoso WITH(NOLOCK) where cCtaCod = @cCtaCod and nTipoGastoSegCom = 1 and nEstado = 1)          
     BEGIN          
      SET @nRegPolizaInd = 1          
      SET @nRegPolizaGlob = 1          
     END          
          
     IF(EXISTS (select 1 from COLOCACIONES.COLOCEXONERACIONSEGUROS WITH(NOLOCK) where cCtaCod=@cCtaCod and nTipoSeguro=1 and nEstado=1))          
     BEGIN          
      SET @nRegPolizaInd = 1          
      SET @nRegPolizaGlob = 1          
     END          
    END        
            
    --DECLARE @nEdadDesgravamen INT = (SELECT ISNULL(       
    --  CASE       
    --   WHEN MONTH(@dFechaActual) < MONTH( B.dPersNacCreac)  THEN DATEDIFF(YEAR, B.dPersNacCreac, @dFechaActual) - 1      
    --   ELSE DATEDIFF(YEAR, B.dPersNacCreac, @dFechaActual)       
    --  END, 0)      
    ---- SELECT *      
    --FROM Persona B      
    --WHERE B.cPersCod = @cPersCodTitular)      
             
    UPDATE A          
    SET A.cValorCalculado = CASE WHEN @nIdCampana IN (136) THEN 35000      
           --WHEN @nEdadDesgravamen >= 71 THEN 1    
           ELSE ( SELECT CONVERT(MONEY, nConsSisValor ) FROM ConstSistema WHERE nConsSisCod =3063) END          
    FROM #DatosEntradaUnPivot A          
    WHERE nIdVariable =65          
                                                  
    UPDATE A          
 SET A.cValorCalculado = (CASE WHEN nIdVariable=66 THEN  @nRegPolizaInd          
           WHEN nIdVariable=67 THEN  @nRegPolizaGlob          
           END)          
    FROM #DatosEntradaUnPivot A          
    WHERE nIdVariable IN (66,67)          
                              
              END          
       END          
          
    BEGIN -- [nIdVariable = 70]          
    IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =70)          
             BEGIN           
      DECLARE @NESTADO          INT          
                               ,@ncobertura    DECIMAL(5,2)          
                              
                    SELECT @ncobertura = NPORCCOBERTURA, @NESTADO = NESTADO          
                    FROM colocExcepGarant      WITH (NOLOCK)          
    WHERE CCTACOD = @cCtaCod          
                           AND NNUMREF = @nNumRefinan          
                           AND NCODTIPVAL = 38          
          
                    IF @NESTADO = 2           
                    BEGIN          
                           UPDATE colocExcepGarant          
                           SET NESTADO = 1          
                           WHERE CCTACOD = @cCtaCod          
                                  AND NNUMREF = @nNumRefinan          
                                  AND NCODTIPVAL = 38          
                    END          
          
                    SET @ncobertura=ISNULL(@ncobertura,0)          
          
          
                    UPDATE A          
                    SET A.cValorCalculado = @ncobertura          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =70          
             END          
       END          
                     
    BEGIN -- [nIdVariable = 71]          
           IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =71)          
             BEGIN           
     DECLARE @nValLimiSinHip   INT=0          
          
                    SET @nValLimiSinHip=CASE WHEN (SELECT COUNT(1)          
                          FROM colocExcepGarant          
                                                         WHERE CCTACOD = @cCtaCod          
                                                               AND NNUMREF = @nNumRefinan          
                                                               AND NCODTIPVAL = 39)>1 THEN 1 ELSE 0 END          
                              
     UPDATE colocExcepGarant          
                    SET NESTADO = 1          
                    WHERE CCTACOD = @cCtaCod          
                               AND NNUMREF = @nNumRefinan          
                               AND NCODTIPVAL = 39          
                               AND NESTADO=2          
          
                    UPDATE A          
           SET A.cValorCalculado = @nValLimiSinHip           
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =71          
             END          
       END          
          
    BEGIN -- [nIdVariable = (72,73)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (72,73))          
             BEGIN           
                     DECLARE @nNumGarantFF INT          
          
             SET @nRegPreAprob= CASE WHEN @cCtaCod<>''          
                                                      THEN           
                                                          CASE WHEN ( SELECT COUNT(1) FROM ColocPreAprobacion with(nolock) WHERE cCtaCod=@cCtaCod)>0 THEN 1 ELSE 0 END          
                                                      ELSE 0 END          
          
                    SELECT @nNumGarantFF=COUNT(cg.nNumGarant)          
                    FROM #GarantiaCredito cg                  
                     INNER JOIN garantias g WITH (NOLOCK)          
                           ON cg.nNumGarant=g.cNumGarant             
                     INNER JOIN  GARANTIA.TiposColaterales GTIPO  WITH (NOLOCK)          
                           ON g.nTipoColateralID=GTIPO.nTipoColateralID             
                     WHERE GTIPO.cTipoGarantCod='G1'           
    AND GTIPO.nTipoColateralID NOT IN(10)          
          
                    SET @nRegGarantFisica= CASE WHEN ISNULL(@nNumGarantFF,0)>0 THEN 1 ELSE 0 END          
          
                    UPDATE A          
                    SET A.cValorCalculado = CASE WHEN nIdVariable=72 THEN @nRegPreAprob          
                             WHEN nIdVariable=73 THEN @nRegGarantFisica END          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN (72,73)          
             END          
       END          
          
    BEGIN -- [nIdVariable = 74]          
    IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =74)          
          BEGIN           
               DECLARE @nRegGarant2Rango INT          
          
               SELECT @nRegGarant2Rango=COUNT(1)           
               FROM #GarantiaCredito cg           
                     INNER JOIN GARANTIA.OtrosGravamen gh WITH (NOLOCK)          
                           ON cg.nNumGarant=gh.cNumGarant          
                         
               UPDATE A          
               SET A.cValorCalculado = CASE WHEN ISNULL(@nRegGarant2Rango,0)>0 THEN 1 ELSE 0 END           
    FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable =74          
          END          
    END          
           
    BEGIN -- [nIdVariable = 75]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =75)          
             BEGIN           
                               
                    DECLARE @nSolTasaExp INT          
          
                    SELECT @nSolTasaExp=COUNT(1)          
                    FROM ColocLineaCredito CL       WITH (NOLOCK)          
                           JOIN ColocLineaCreditoTasas CLT WITH (NOLOCK)          
                                  ON CLT.nLineaCredId=CL.nLineaCredId                
                           JOIN ColocacTasas C     WITH (NOLOCK)          
                                  ON C.nColocacTasaId=CLT.nColocacTasaId                
						   JOIN ColocLineaCreditoEspecial E WITH (NOLOCK)          
                                  ON E.nLineaCredId=CL.nLineaCredId              
                           JOIN ColocLineaCreditoPersMov PM WITH (NOLOCK)          
                                  ON PM.nColocLineaCredPersona=E.nColocLineaCredPersona              
                           JOIN ColocLineaCredPersona LP WITH (NOLOCK)          
                                  ON LP.nColocLineaCredPersona=PM.nColocLineaCredPersona                       
                    WHERE PM.nEstado                        = 2                    
                           and LP.cCtaCod        = @cCtaCod            
              and substring(CL.cLineaCred,7,3)  = @cCredProducto          
                           and CL.bEstado                          = 1          
      and C.nTipoTasa                   = 1                 
                           and CL.nTipoLineaCreditos  = 3          
                       and C.nColocacTasaMontoMin <= @nMonto and @nMonto<= C.nColocacTasaMontoMax            
                           AND LP.nColocLineaCredPersona =(SELECT MAX(nColocLineaCredPersona) FROM ColocLineaCredPersona WHERE cCtaCod=LP.cCtaCod)          
                           AND CL.bLineaCredExcepcional=1          
          
          
          
  UPDATE A          
                    SET A.cValorCalculado = (CASE WHEN @cCtaCod=''           
                                                               THEN           
    CASE WHEN ISNULL(@nSolTasaExp,0)>0 THEN 1 ELSE 0 END          
                                                               ELSE          
0 END)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =75          
              END          
       END          
          
    BEGIN -- [nIdVariable = (76,77)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (76,77))          
             BEGIN           
                     DECLARE @nPlazoFijoEsp        INT          
                               ,@nPlazoCapTrabEsp  INT          
                    ,@nNuevoPlazoEsp    INT          
               
          SELECT @nPlazoCapTrabEsp = nPlazoFin/30 FROM TipoCredProductosDest WHERE cCredProductos=@cCredProducto AND nCodDestino=1               
                     SET @nPlazoCapTrabEsp = COALESCE(@nPlazoCapTrabEsp, CASE WHEN @nPlazoCapTrabEsp=0 then 18 else @nPlazoCapTrabEsp end)                
          
                    SELECT @nPlazoFijoEsp = ROUND(nPlazoFin/30,0) from TipoCredProductosDest where cCredProductos=@cCredProducto and nCodDestino=2               
          
                    SELECT @nNuevoPlazoEsp=max(O.nPlazoFin)            
                     FROM PromocionCreditoOferta O     WITH (NOLOCK)          
                     inner join PromocionCredito P     WITH (NOLOCK)          
  on O.nPromocionCred=P.nPromoCred              
                     WHERE P.IdCampana=@nIdCampana And 1 in(select items from dbo.fn_Split(sDestinos,','))              
                               
                     SET @nNuevoPlazoEsp=coalesce(@nNuevoPlazoEsp/30,0)           
                 
                     IF @nNuevoPlazoEsp > 0               
                     BEGIN              
                            SET @nPlazoCapTrabEsp=@nNuevoPlazoEsp              
        END           
          
          
                    UPDATE A          
                  SET A.cValorCalculado = CASE WHEN nIdVariable=76 THEN ISNULL(@nPlazoCapTrabEsp,0)          
                                                            WHEN nIdVariable=77 THEN ISNULL(@nPlazoFijoEsp,0) END          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN (76,77)          
             END          
       END          
              
    BEGIN -- [nIdVariable = 79]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =75)          
             BEGIN           
                     UPDATE A          
                    SET A.cValorCalculado = (SELECT CONVERT(INT,nParamValor) from COLOCPARAMETRO WHERE nParamVar = '102740')          
     FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =79          
             END          
       END          
              
    BEGIN -- [nIdVariable = (81,82,83,84)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (81,82,83,84))          
             BEGIN           
                     DECLARE @bDesemParcial    INT          
              DECLARE @nCondicionCliTabla TABLE (nCondicionCli INT)           
                     DECLARE @nCondicionCli    INT          
                               ,@nDiasExcMax   INT          
                               ,@nDiasExcPerm  INT          
                               ,@nDiasFalt     INT          
          
                    INSERT INTO @nCondicionCliTabla EXEC PA_CondicionCredito @cPersCodTitular          
          
                    IF EXISTS(SELECT nCondicionCli FROM @nCondicionCliTabla)          
                    BEGIN          
                           SET @nCondicionCli = 2           
                     END          
              ELSE           
                     BEGIN          
       SET @nCondicionCli = 1          
                    END          
          
                    SELECT @bDesemParcial=COUNT(1)          
                    FROM Producto a WITH (NOLOCK)          
         INNER JOIN ColocacCred b   WITH (NOLOCK)          
                           ON a.cCtaCod=b.cCtaCod            
                               AND b.nTipoDesembolso=1          
                    INNER JOIN ColocCalendario c WITH (NOLOCK)          
                           ON b.cCtaCod=c.cCtaCod          
                               AND b.nNroCalen=c.nNroCalen          
                 AND c.nColocCalendApl=0          
    AND c.nColocCalendEstado=0          
                               AND c.nCuota>1          
                    WHERE a.nPrdEstado IN (2020)          
                               AND a.cCtaCod=@cCtaCod          
                                                   
                     SELECT           
                               A.cPersCod,           
                               B.cPersNombre,          
             A.nPersRelac ,          
                               B.dPersNacCreac          
INTO #PersonasEval          
                    FROM #PersonaRelacionCred A          
               INNER JOIN Persona B      WITH (NOLOCK)          
                                     ON B.cPersCod = A.cPersCod           
                     WHERE B.nPersPersoneria =1          
                               AND A.nPersRelac IN (20,21,22,23,24,25)              
          
                    INSERT INTO #RelPersonaEdad          
                    SELECT A.cPersCod,A.cPersNombre,A.nPersRelac,C.cConsDescripcion AS cRelacion          
                 ,DATEDIFF(DAY,@dFechaActual, DATEADD(MONTH,(12 * B.nAnios + ISNULL(B.nMeses,0)),A.dPersNacCreac)),B.nCodEtapa AS ntipoEval          
                    FROM #PersonasEval A          
                           INNER JOIN COLOCACIONES.ProductoValidadEdad B   WITH (NOLOCK)        
                               ON B.nPrdPersRelac = A.nPersRelac                    
                           INNER JOIN Constante C  WITH (NOLOCK)          
                               ON C.nConsValor=A.nPersRelac          
                    WHERE B.cCredProducto = @cCredProducto          
                    AND B.bEstado = 1          
                 AND B.nCodEtapa = 1          
                    AND B.ncondicion = @nCondicionCli          
              AND C.nConsCod=3002          
                    AND DATEDIFF(DAY,@dFechaActual, DATEADD(MONTH,(12 * B.nAnios + ISNULL(B.nMeses,0)),A.dPersNacCreac)) > 0          
                       
                    INSERT INTO #RelPersonaEdad           
                     SELECT  A.cPersCod,A.cPersNombre,A.nPersRelac,C.cConsDescripcion AS cRelacion          
                               ,DATEDIFF(DAY, DATEADD(MONTH,(12 * B.nAnios + ISNULL(B.nMeses,0)),A.dPersNacCreac),@dFechaActual),B.nCodEtapa AS ntipoEval          
                    FROM #PersonasEval A          
              INNER JOIN COLOCACIONES.ProductoValidadEdad B   WITH (NOLOCK)          
                               ON B.nPrdPersRelac = A.nPersRelac                    
                           INNER JOIN Constante C WITH(NOLOCK)         
                               ON C.nConsValor=A.nPersRelac                  
                    WHERE B.cCredProducto = @cCredProducto          
                           AND B.bEstado = 1          
                           AND B.nCodEtapa = 2          
                           AND B.ncondicion = @nCondicionCli          
                           AND C.nConsCod=3002          
                           AND DATEDIFF(DAY, DATEADD(MONTH,(12 * B.nAnios + ISNULL(B.nMeses,0)),A.dPersNacCreac),@dFechaActual) > 0          
                              
                    INSERT INTO #RelPersonaEdad          
                    SELECT A.cPersCod,A.cPersNombre,A.nPersRelac,C.cConsDescripcion AS cRelacion          
                           ,DATEDIFF(DAY, DATEADD(MONTH,(12 * B.nAnios + ISNULL(B.nMeses,0)),A.dPersNacCreac),@dUltFechaPagoCalen),B.nCodEtapa AS ntipoEval          
           FROM #PersonasEval A          
                           INNER JOIN COLOCACIONES.ProductoValidadEdad B   WITH (NOLOCK)          
                                  ON B.nPrdPersRelac = A.nPersRelac                 
                INNER JOIN Constante C          
                               ON C.nConsValor=A.nPersRelac                  
                    WHERE B.cCredProducto = @cCredProducto          
                           AND B.bEstado = 1          
          AND B.nCodEtapa = 3          
                           AND B.ncondicion = @nCondicionCli          
                           AND C.nConsCod=3002          
                           AND DATEDIFF(DAY, DATEADD(MONTH,(12 * B.nAnios + ISNULL(B.nMeses,0)),A.dPersNacCreac),@dUltFechaPagoCalen) >= 0          
                              
     DELETE #RelPersonaEdad WHERE nTipoEval = 2 AND cPersCod IN (SELECT CONVERT(VARCHAR(MAX),nConsSisValor) FROM ConstSistema with(nolock) WHERE nConsSisCod = 7209)               
               
                    SET @nDiasFalt=(SELECT nDiasExc FROM #RelPersonaEdad WHERE nTipoEval=1)          
                    SET @nDiasExcMax=(SELECT CASE WHEN @nIdCampana IN ('140','152','162', '185') THEN 0 ELSE max(nDiasExc) END FROM #RelPersonaEdad WHERE nTipoEval=2)          
                    SET @nDiasExcPerm=(SELECT CASE WHEN @nIdCampana IN ('140','152','162', '185') THEN 0 ELSE max(nDiasExc) END FROM #RelPersonaEdad WHERE nTipoEval=3)          
          
                    UPDATE A          
                    SET A.cValorCalculado = CASE WHEN nIdVariable=83 THEN          
                                                               CASE WHEN ISNULL(@bDesemParcial,0)>0 THEN 1 ELSE 0 END          
                                                           WHEN nIdVariable=81 THEN ISNULL(@nDiasFalt,0)          
WHEN nIdVariable=82 THEN ISNULL(@nDiasExcMax,0)          
                             WHEN nIdVariable=84 THEN ISNULL(@nDiasExcPerm,0)      
                                                            END          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN(81,82,83,84)          
          
                    DROP TABLE #PersonasEval          
             END          
       END          
                 
    BEGIN -- [nIdVariable = 87]          
            IF EXISTS(SELECT 1 FROM #DatosEntradaUnPivot WHERE nIdVariable=87)          
            BEGIN          
                UPDATE A           
                        SET A.cValorCalculado = @nDesemBN          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable=87          
            END          
    END                           
          
    BEGIN -- [nIdVariable = (88,90,91,92,161)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (88,90,91,92,161))          
            BEGIN           
     DECLARE @PorcentajeFT              DECIMAL(12,4)          
      ,@nDeudaRCCFecFteIng      MONEY          
      ,@nDeudaRCCActual         MONEY          
                        ,@pbApruebaA              INT          
                        ,@pbApruebaB              INT          
                        ,@bApruebaCiclo6A         INT          
                        ,@bApruebaCiclo6B         INT          
                        ,@cCalifEscolar2017       VARCHAR(10)          
          
                CREATE TABLE #FuenteIngresoConcol          
                (          
                        nMontoFte           MONEY          
                        ,nMontoFteLiquit MONEY          
                )          
          
                INSERT INTO #FuenteIngresoConcol (nMontoFte,nMontoFteLiquit)          
                SELECT nMonto=(nPersFIVentas+nPersFIRecupCtasXCobrar+nPersIngFam)-(nPersFICostoVentas+nPersFIEgresosOtros+nPersEgrFam  + nPersPagoCuotas ) *(CASE WHEN nMoneda=1 THEN 1.00 ELSE @tipoCambio END),          
                                nMontoLiq=((nPersFIVentas+nPersFIRecupCtasXCobrar+nPersIngFam)-(nPersFICostoVentas+nPersFIEgresosOtros+nPersPagoCuotas ))*(CASE WHEN nMoneda=1 THEN 1.00 ELSE @tipoCambio END)          
                FROM #FTeIndependiente          
                              
                    INSERT INTO #FuenteIngresoConcol (nMontoFte,nMontoFteLiquit)        
        SELECT nMonto=(CASE           
                                    WHEN (@cCredProducto = '301'  AND  bSectorPublico = 1 )          
                                            THEN ((nRemBruta -nDocLegales-nMandJudiciales-nCuotasSindicales )* (SELECT  nConsSisValor  FROM ConstSistema WHERE nConsSisCod = 4001)) - nFondosBienestar - nCuotasFinancieras           
                                    ELSE           
                               ( nPersIngCli+nPersIngCon+nPersOtrIng)-(nPersGastoFam + nPersPagoCuotas)           
                                    END)*(CASE WHEN nMoneda=1 THEN 1.00 ELSE @tipoCambio END),          
                     nMontoLiq=((nPersIngCli+nPersIngCon+nPersOtrIng)-(nPersPagoCuotas) )*(CASE WHEN nMoneda=1 THEN 1.00 ELSE @tipoCambio END)          
                FROM #FTeDependiente          
          
          
                SET @nDeudaRCCFecFteIng=0          
                SET @nDeudaRCCActual=0          
          
                DECLARE @dFechaRccFte     DATE          
                SET @dFechaRccFte=EOMONTH(@dPersEval)         
          
       IF @dFechaRccFte > @dFechaRCC          
                        BEGIN set @dFechaRccFte = @dFechaRCC END          
          
              SET @nDeudaRCCFecFteIng = isnull((select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet with(nolock) where Cod_Sbs = @CodSbsTit and dFecha = @dFechaRccFte          
               and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)          
          
                SET @nDeudaRCCActual = isnull((select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet with(nolock) where Cod_Sbs = @CodSbsTit and dFecha = @dFechaRCC          
                                                            and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)       
          
          
                IF ISNULL(@CodSbsConyugue,'') <> ''          
                BEGIN          
set @nDeudaRCCFecFteIng = ISNULL(@nDeudaRCCFecFteIng,0) + isnull((select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet with(nolock) where Cod_Sbs = @CodSbsConyugue and dFecha = @dFechaRccFte          
                                                                    and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)          
          
                        set @nDeudaRCCActual = ISNULL(@nDeudaRCCActual,0) + isnull((select sum(Val_Saldo) from DBRCC..RccTotalDet where Cod_Sbs = @CodSbsConyugue and dFecha = @dFechaRCC          
                                        and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)          
                end          
          
          
                SET @PorcentajeFT = (SELECT TOP 1 nCuotaExcedente          
                                                    FROM TipoCreditoCuotaExcedente A  WITH (NOLOCK)          
WHERE A.bEstado = 1          
        AND nTipoCreditos =@nTipoCredito                                                                             
                         ORDER BY nTipoCreditos ASC)          
          
                IF EXISTS (SELECT cCredProductos FROM ProductoCuotaExcedente      WITH (NOLOCK) WHERE cCredProductos = @cCredProducto)          
                BEGIN          
                            SELECT @PorcentajeFT = nCuotaExcedente          
                            FROM ProductoCuotaExcedente WITH (NOLOCK)          
                            WHERE cCredProductos = @cCredProducto          
                END          
                IF (@cCredProducto = '301'           
                            AND (SELECT nTipoSector          
                                            FROM PersTpo with(nolock)          
                                            WHERE cPersCod = (          
                                                        SELECT cPersCodInst          
                                                        FROM ColocSolicitud  with(nolock)        
                                                    WHERE nCodSolicitud =           
                                                            (SELECT MAX(nCodSolicitud)          
                                                            FROM ColocSolicitud with(nolock)          
                        WHERE cCtaCod = @cCtaCod)          
                                                        )          
                                            ) = 2          
                        )          
BEGIN          
SET @PorcentajeFT = (SELECT nConsSisValor FROM ConstSistema with(nolock) WHERE nConsSisCod = 4002)          
   END          
                              
                    IF EXISTS (SELECT cCodCtaCre FROM COLOCDExcCreGen   WITH (NOLOCK) WHERE cCodCtaCre = @cCtaCod AND nCodTipVal = 3)          
                BEGIN          
                        SET @PorcentajeFT = 100          
                END          
          
          
                IF @nIdCampana = 130          
                BEGIN          
                        IF (SELECT COUNT(1) FROM ProductoPersona a  WITH (NOLOCK) inner join Producto b WITH (NOLOCK) on a.cCtaCod=b.cCtaCod           
          WHERE cPersCod = @cPersCodTitular and a.nPrdPersRelac = 20 and (b.nPrdEstado in (2020,2021,2022,2030,2031,2032,2201,2202,2205,2206))) > 0          
    BEGIN          
                            IF LEFT(@cCalifClient,2) = 'AA'       
                                    BEGIN          
                                        SET @PorcentajeFT = 0.95          
                                    END          
          END          
          
                        SET @pbApruebaA=0          
                        SET @pbApruebaB=0          
                        SET @bApruebaCiclo6A=0          
                        SET @bApruebaCiclo6B=0          
          
                        IF (@nPlazo <= 549 and @nCuotas > 1) or (@nPlazo <= 120 and @nCuotas = 1)          
                   BEGIN          
                                IF left(@cCalifClient,2) = 'AA'       
                                BEGIN          
                   IF @nColocCondicion <> 1          
                                        BEGIN          
                                                    IF (@nDeudaRCCFecFteIng + (@nDeudaRCCFecFteIng * 0.2) >= @nDeudaRCCActual)          
                                                    BEGIN          
                                                        SET @PorcentajeFT = 0.95          
                                set @pbApruebaA = 1          
                            END          
                                        END          
                                END          
                            IF LTRIM(RTRIM(@cCalifClient)) IN ('A','B')           
                                BEGIN          
                                            IF @nColocCondicion <> 1          
         BEGIN          
                                                    IF ((@nDeudaRCCFecFteIng < @nDeudaRCCActual) or (@nDeudaRCCActual > 100000)) and (@dFechaActual >= @dFechaCaducFTE)          
                                                        BEGIN          
                                                            SET @pbApruebaB = 0          
                                                        END          
       ELSE          
                                                        BEGIN              
                                                            SET @pbApruebaB = 1          
                                 END          
          
                                            END          
          
                                END          
          
                        END          
                    IF @nColocCondicion <> 1 AND @pbApruebaA = 0 AND @pbApruebaB = 0          
                        BEGIN          
                            IF (SELECT COUNT(1) FROM ProductoPersona a WITH (NOLOCK) inner join Producto b WITH (NOLOCK) on a.cCtaCod=b.cCtaCod where cPersCod = @cPersCodTitular and a.nPrdPersRelac = 20 and (b.nPrdEstado in (2020,2021,2022,2030,2031,2032
  
    
    
    
    
        
    
    
    
    
    
    
    
    
    
,2201,2202,2205,2206))) = 0          
                            BEGIN          
                                    IF LEFT(@cCalifClient,2) = 'A' OR LEFT(@cCalifClient,2) = 'B'          
                                    BEGIN          
                                            SET @PorcentajeFT = 1          
                                END          
                            END          
                        END          
                END          
          
    IF @nIdCampana = 149          
                BEGIN          
     SET @PorcentajeFT = 0.85          
    END          
          
                IF LEFT(@cCalifClient,2) = 'AA'           
                    begin          
                                     
                                    IF (@nDeudaRCCFecFteIng + (@nDeudaRCCFecFteIng * 0.2) < @nDeudaRCCActual)          
                                    BEGIN          
                                        SET @bApruebaCiclo6A = 0          
                                    END          
                                    IF (@nPlazo > 549)          
                                    BEGIN          
                                        SET @bApruebaCiclo6A = 0          
                                    END          
                                    ELSE          
                                        SET @bApruebaCiclo6A = 1          
                      
                    END          
                    IF LTRIM(RTRIM(@cCalifClient)) in ('A','B')         
                    begin          
                                    if ((@nDeudaRCCFecFteIng < @nDeudaRCCActual) or (@nDeudaRCCActual > 100000)) and (@dFechaActual >= @dFechaCaducFTE)          
                      begin                                                    
                                        SET @bApruebaCiclo6B = 0                 
          end          
                                    if (@nPlazo > 549)          
                begin       
                                     SET @bApruebaCiclo6B = 0                 
       end          
                    else          
                                        SET @bApruebaCiclo6B = 1                 
                    end          
          
                IF @nColocCondicion > 1    AND @bApruebaCiclo6A = 0 AND @bApruebaCiclo6B = 0          
                BEGIN          
                        declare @dFecMaxCancelacion date          
                        declare @cCalifIntFecCan varchar(15)          
                        IF (select count(1) from ProductoPersona a WITH (NOLOCK)     
       inner join Producto b WITH (NOLOCK) on a.cCtaCod=b.cCtaCod     
       where cPersCod = @cPersCodTitular and a.nPrdPersRelac = 20 and (b.nPrdEstado in (2020,2021,2022,2030,2031,2032,2201,2202,2205,2206))) = 0          
                   BEGIN          
                                SET @dFecMaxCancelacion = (select       
               max(b.dPrdEstado)       
               from ProductoPersona a WITH (NOLOCK)       
               inner join Producto b WITH (NOLOCK) on a.cCtaCod=b.cCtaCod       
               where cPersCod = @cPersCodTitular       
               and a.nPrdPersRelac = 20       
               and (b.nPrdEstado in (2050,2203,2204)))          
                                IF @dFecMaxCancelacion is not null and @dFecMaxCancelacion >= DATEADD(MM,-6,@dFechaActual)          
                                BEGIN          
                                    SET @cCalifIntFecCan = isnull((select case when ci.cCalEsp2 = '' then (case when ci.cCalEsp1 = '' then ci.cCalInt          
                                                                                                                                                                    else ci.cCalEsp1 end)          
                                                                                                                            else ci.cCalEsp2 end          
                         from NORMA3780.ci_DataFinalCalInt ci          
                                                                        where ci.cPersCod=@cPersCodTitular          
                                                                        and ci.dFecha=(select MAX(dfecha) from NORMA3780.ci_DataFinalCalInt a1 where a1.cPersCod=ci.cPersCod and a1.dFecha<=@dFecMaxCancelacion)          
                                                                        ),'')          
          
                                    IF @cCalifIntFecCan <> ''          
                                    BEGIN          
                                            IF (select codigo from @CalificacionInt where cCalifInt = @cCalifClient) > (select codigo from @CalificacionInt where cCalifInt = @cCalifIntFecCan)          
                                            BEGIN          
        SET @cCalifEscolar2017 = @cCalifIntFecCan          
                    END          
                                    END          
                                end          
                        end          
         END          
                                     
                                             
                    UPDATE A          
                SET A.cValorCalculado =(CASE WHEN @nColocCondicion>1 AND ISNULL(@cCalifEscolar2017,'') <> '' THEN @cCalifEscolar2017 ELSE @cCalifClient end)          
      FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =161          
          
                SET @nRatioLiquit=@nMontoCuota/(SELECT SUM(nMontoFteLiquit) FROM #FuenteIngresoConcol)          
          
                UPDATE A          
                SET A.cValorCalculado =  @nTipoPeriodicidad          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =88          
          
      
                UPDATE A          
          SET A.cValorCalculado = CASE WHEN nIdVariable=90 THEN ISNULL(CONVERT(DECIMAL(18,2),@nRatioLiquit),0)          
                                                        WHEN nIdVariable=91 THEN ISNULL(CONVERT(DECIMAL(18,2),@PorcentajeFT),0)*100          
                                                        END          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable IN(90,91)          
          
                UPDATE A          
                SET A.cValorCalculado =  (SELECT CONVERT(DECIMAL(18,2),nParamValor) FROM ColocParametro WHERE nParamVar=CASE WHEN @cCredProducto='406' THEN 3089 ELSE 3090 END)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =92          
          
                DROP TABLE #FuenteIngresoConcol          
            END          
    END          
          
    BEGIN -- [nIdVariable = (96,97)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (96,97))          
            BEGIN           
                    DECLARE  @nMontoMaxCuotaDescPlan DECIMAL(18,2)          
                             
        SET @nSueldoNetoClient=@nMontoInCliFteSoles   + (@nMontoInCliFteDolar*ISNULL(@tipoCambio,0))          
                SET @nMontoMaxCuotaDescPlan=(SELECT CONVERT(DECIMAL(18,2),nParamValor) from COLOCPARAMETRO WHERE nParamVar = '3053')          
          
                UPDATE A          
                SET A.cValorCalculado = (CASE WHEN nIdVariable=96 THEN ISNULL(@nSueldoNetoClient,0)          
                                                        WHEN nIdVariable=97 THEN ISNULL(@nSueldoNetoClient,0)*ISNULL(@nMontoMaxCuotaDescPlan,0)          
                                                        END)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable in (96,97)          
          
            END          
    END          
          
    BEGIN -- [nIdVariable = 98]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =98)          
 BEGIN           
                    UPDATE A          
                SET A.cValorCalculado = @nMontoCuota          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =98          
            END          
    END          
          
    BEGIN -- [nIdVariable = 99]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =99)          
            BEGIN           
                    DECLARE @numCredcuentaSueld  INT          
          
                SELECT @numCredcuentaSueld=COUNT(a.cctacod)          
                FROM ITFExoneracionCta a WITH (NOLOCK)          
                INNER JOIN ProductoPersona b        WITH (NOLOCK)          
                        ON a.cCtaCod =b.cCtaCod           
                    INNER JOIN producto c     WITH (NOLOCK)          
                        ON a.cCtaCod =c.cCtaCod           
                    WHERE a.nExoTpo =3 and b.cPersCod =@cPersCodTitular           
                        AND b.nPrdPersRelac =10          
                        AND c.nPrdEstado in (1000,1200,1100)          
                        AND SUBSTRING (A.CCTACOD,9,1)='1'          
          
                UPDATE A          
                SET A.cValorCalculado = CASE WHEN ISNULL(@numCredcuentaSueld,0)>0 THEN 1 ELSE 0 END          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =99          
            END          
    END          
          
    BEGIN -- [nIdVariable = 100]          
          
        IF EXISTS(SELECT 1 FROM #DatosEntradaUnPivot WHERE nIdVariable=100)          
                       
        BEGIN          
            --SET @dFechaActual = '2015-08-24'          
            CREATE TABLE #TCreditos          
                    (          
                            cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,                  
                            bPagoAnticipado BIT DEFAULT(0) NOT NULL,          
                            nNroCalendDesemb INT NULL,          
                            nNroCalenActual INT NULL,          
                            nCuotaAux INT NULL          
             );          
          
            CREATE TABLE #TCalendarios          
                    (          
    cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,          
                            nNroCalen INT NOT NULL,          
                            nCuota INT NOT NULL,          
                            nColocCalendEstado INT NULL,          
                       dVenc DATE NULL,          
                            dPago DATE NULL,          
                            nDiasAtraso INT NULL          
                    );          
            ALTER TABLE #TCalendarios ADD  PRIMARY KEY NONCLUSTERED (cCtaCod, nNroCalen, nCuota);          
          
            CREATE TABLE #TPagoAnticipado          
                    (          
                            cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,          
                            nNroCalen INT NOT NULL,          
          nCuota INT NOT NULL,          
                            dVenc DATE NOT NULL,          
                            dPago Date NULL,          
                            nDiasAtraso INT NOT NULL,          
    nMovNro INT NOT NULL          
                    );          
            ALTER TABLE #TPagoAnticipado ADD  PRIMARY KEY NONCLUSTERED (cCtaCod, nNroCalen, nCuota);          
          
            CREATE TABLE #TCalenFinal          
                    (          
                            cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,          
                            nNroCalen INT NOT NULL,          
                            nCuota INT NOT NULL,          
                            dVenc DATE NOT NULL,          
        dPago DATE NULL,          
                            nDiasAtraso INT  NULL,          
                            nMovNro INT NULL          
                    );          
            ALTER TABLE #TCalenFinal ADD  PRIMARY KEY NONCLUSTERED (cCtaCod, nNroCalen, nCuota);          
          
            CREATE TABLE #OpeTpo          
                    (          
                            cOpecod VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL PRIMARY KEY,          
                            cOpeDesc VARCHAR(120) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,          
      nTipoOpe INT NOT NULL          
                    );          
          
            DECLARE @cCtaCodRefAnt NVARCHAR(18)          
            DECLARE @DFECHACREDITORefAnt DATE          
            DECLARE @NNROCALENDRefAnt INT          
            DECLARE @estadoCreditoRefAnt INT          
          
            SET NOCOUNT ON          
                 
          
                    INSERT INTO #OpeTpo(cOpecod, cOpeDesc, nTipoOpe )          
                    SELECT MC.cOpeCod, MC.cOpeDesc, 1          
                    FROM OpeTpo MC      WITH (NOLOCK)          
           WHERE MC.cOpeCod NOT LIKE '99%'          
                            AND (MC.cOpeCod LIKE '100[2-7]%' OR MC.cOpeCod LIKE '13%' or MC.cOpeCod LIKE '102%'          
                        or MC.cOpeCod  in ('121000','121001','121010','121011','126300','126301','120002','121101','121102','121111','121112','126101',          
                                            '126102','126111','126112','120003','126201','126202','126211','126212','120004','122000','122100')          
                                    or MC.cOpeCod like '1212%')          
                            AND MC.cOpeCod NOT LIKE '1002[23][0-5]%' AND MC.cOpeCod NOT LIKE '100[2-7]17%' AND MC.cOpeCod NOT LIKE '1301%'          
                            AND MC.cOpeCod NOT LIKE '13021[0-3]%'    AND MC.cOpeCod NOT LIKE '13041%'      AND MC.cOpeCod NOT LIKE '13[145789]%'          
                            AND MC.cOpeCod NOT LIKE '130[567]%'      AND MC.cOpeCod NOT LIKE '136[^123]%'          
          
          
            --IDENTIFICANDO CREDITOS REFINANCIADOS DEL CLIENTE          
                 
                    SELECT TOP 1           
                            @cCtaCodRefAnt=COALESCE(re.CCTACOD,CR.cCtaCod)          
                            ,@estadoCreditoRefAnt=P.nPrdEstado           
                            ,@DFECHACREDITORefAnt=P.dPrdEstado          
        FROM  ProductoPersona PP   WITH (NOLOCK)                        
                            INNER JOIN PRODUCTO P  WITH (NOLOCK)          
                                ON PP.cCtaCod=P.cCtaCod          
                                        AND PP.nPrdPersRelac=20          
                                        AND P.nPrdEstado=2050          
                            INNER JOIN ColocacRefinanc CR     WITH (NOLOCK)          
                                ON P.cCtaCod=CR.cCtaCod          
                                        AND cr.nEstado=3          
                            INNER JOIN PersID PID  WITH (NOLOCK)          
                                ON PP.cPersCod=PID.cPersCod          
                            INNER JOIN Constante C WITH (NOLOCK)          
  ON P.nPrdEstado=C.nConsValor          
                                        AND C.nConsCod=3001          
                            LEFT JOIN RelCuentas RE   WITH (NOLOCK)          
                        ON CR.cCtaCod=RE.cCtaCodAnt          
                    WHERE PID.cPersIDnro=@cNumDOITit --VERIFICAR SI EL DOC DEL TITULAR          
                    GROUP BY coalesce(re.CCTACOD,CR.cCtaCod)          
                            ,P.nPrdEstado          
                            ,P.dPrdEstado          
                    ORDER BY P.dPrdEstado DESC          
          
            ------------- OBTENIEDO MESES EXACTOS TRANSCURRIDOS --------------          
                                     
                DECLARE @nAñoCred INT,@nMesCred INT, @nDiaCred INT          
 DECLARE @Dias INT,@Meses INT=0 , @Años INT=0 ,@MesesT INT=0          
                    DECLARE @AñoFin int          
                    DECLARE @MesFin int          
                    DECLARE @DiaFin int          
          
                    SET @AñoFin=YEAR(@dFechaActual)          
                    SET @MesFin=MONTH(@dFechaActual)          
                    SET @DiaFin=DAY(@dFechaActual)          
                       
                    SELECT           
                            @nAñoCred=YEAR(@DFECHACREDITORefAnt),          
                            @nMesCred=MONTH(@DFECHACREDITORefAnt),          
                            @nDiaCred=DAY(@DFECHACREDITORefAnt)          
                       
                    IF @DiaFin - @nDiaCred >= 0           
                            BEGIN          
                                SET @Dias = @DiaFin - @nDiaCred          
                            END          
        --Si no, calcula la suma en días, desde el día de Inicio a fin de mes, mas los días de Fin, y le resta uno al mes de Fin.-          
                    ELSE          
                            BEGIN          
                                SET @Dias = (day(dateadd(mm,1,cast((str(@nAñoCred)+ '/' + str(@nMesCred) +'/01'  ) as datetime)) - 1 )- @nDiaCred) + @DiaFin          
                                SET @MesFin = @MesFin - 1          
                            END          
          
                    --Lo mismo con el mes.          
                    IF @MesFin - @nMesCred >= 0           
                            BEGIN          
                            SET @Meses = @MesFin - @nMesCred          
                            END          
                    ELSE          
       BEGIN          
                        SET @Meses = (@MesFin - @nMesCred) + 12          
                                SET @AñoFin = @AñoFin - 1          
                            END          
          
                    SET @Años = @AñoFin - @nAñoCred          
                    SET @MesesT=@Meses          
                    IF(@Años>0)          
                            begin           
                                set @mesesT=@Años*12+@Meses          
      end          
          
            ------------------------------------------------------------------          
          
            IF(@MesesT<=(select nConsSisValor from ConstSistema where nConsSisCod=5018))          
            BEGIN          
            --IDENTIFICANDO CALENDARIO DE DESEMBOLSO          
                    IF EXISTS( SELECT 1 FROM ColocacRefinanc WHERE (cCtaCod=@cCtaCodRefAnt AND cCtaCodRef=@cCtaCodRefAnt))          
                            BEGIN          
                                SELECT @NNROCALENDRefAnt=nNroCalen           
                                FROM ColocRefinanciacionTramite   WITH (NOLOCK)          
                                WHERE cCtaCod=@cCtaCodRefAnt           
                    AND bOriginal=0          
          
                                INSERT INTO #TCreditos (cCtaCod, bPagoAnticipado, nNroCalendDesemb , nNroCalenActual, nCuotaAux )          
                                SELECT P.cCtaCod, 0, @NNROCALENDRefAnt, C.nNroCalen, 0           
                                FROM Producto P  WITH (NOLOCK)            
                                        INNER JOIN ColocacCred C WITH (NOLOCK)          
            ON C.cCtaCod=P.cCtaCod           
                                WHERE P.cCtaCod = @cCtaCodRefAnt          
                END          
                    ELSE          
                            BEGIN          
               INSERT INTO #TCreditos (cCtaCod, bPagoAnticipado, nNroCalendDesemb , nNroCalenActual, nCuotaAux )          
SELECT P.cCtaCod, 0, C.nNroCalen, C.nNroCalen, 0         
                    FROM Producto P    WITH (NOLOCK)          
                            INNER JOIN ColocacCred C WITH (NOLOCK)          
                                                ON C.cCtaCod=P.cCtaCod                                    WHERE P.cCtaCod = @cCtaCodRefAnt          
                            END          
          
        --IDENTIFICANDO SI EL CREDITO HA TENIDO PAGOS ANTICIPADOS          
                    UPDATE A          
   SET A.bPagoAnticipado = 1           
                    FROM #TCreditos A          
                            INNER JOIN ColocPagoAdelantado B WITH (NOLOCK)          
                                ON A.cCtaCod = B.cCtaCod           
          
          
            --INSERTANDO ULTIMO CALENDARIO    (TODAS LAS CUOTAS)          
                    INSERT INTO #TCalendarios (cCtaCod, nNroCalen, nCuota, nColocCalendEstado, dVenc, dPago)                               
                    SELECT A.cCtaCod, B.nNroCalen, B.nCuota, B.nColocCalendEstado, B.dVenc, ISNULL(CASE WHEN B.nColocCalendEstado = 0 THEN @dFechaActual ELSE B.dPago  END, @dFechaActual ) AS dPago          
                    FROM #TCreditos A          
                            INNER JOIN ColocCalendario B      WITH (NOLOCK)          
                                ON A.cCtaCod = B.cCtaCod           
                                        AND A.nNroCalenActual = B.nNroCalen           
                                        AND B.nColocCalendApl = 1            
          
            --INSERTANDO CALENDARIOS ANTERIORES     (SOLO CUOTAS PAGADAS)          
                    INSERT INTO #TCalendarios (cCtaCod, nNroCalen, nCuota, nColocCalendEstado, dVenc, dPago)                 
                    SELECT C.cCtaCod, C.nNroCalen, C.nCuota, C.nColocCalendEstado, C.dVenc, ISNULL(C.dPago, @dFechaActual) AS dPago          
                    FROM ColocCalendario C  WITH (NOLOCK)          
                            INNER JOIN #TCreditos D          
                                ON C.cCtaCod = D.cCtaCod           
                                        AND C.nColocCalendApl = 1           
                    WHERE C.nNroCalen BETWEEN D.nNroCalendDesemb AND D.nNroCalenActual - 1 AND C.nColocCalendEstado = 1          
                    ORDER BY C.cCtaCod, C.nNroCalen, C.nCuota           
          
          
            --ACTUALIZANDO DIAS DE ATRASO          
                    UPDATE #TCalendarios           
                    SET nDiasAtraso = (CASE WHEN DATEDIFF(DAY,dVenc,dPago) > 0 THEN DATEDIFF(DAY,dVenc,dPago) ELSE 0 END )          
          
                    SELECT DISTINCT D.cCtaCod, E.nNroCalen, E.nNroCuota, CC.dVenc,cc.dPago, F.nDiasAtraso, D.nMovNroPago            
                    INTO #TPagoAnticipadoPre          
                    FROM           
                            (                
                            SELECT A.cCtaCod, B.nMovNro, MAX(C.nMovNro) AS nMovNroPago          
                            FROM #TCreditos A           
                                INNER JOIN ColocPagoAdelantado B WITH (NOLOCK)          
                                        ON A.cCtaCod = B.cCtaCod           
                                INNER JOIN MovCol (NOLOCK) C                
                                        ON B.cCtaCod = C.cCtaCod /*AND C.cOpeCod LIKE '100[2-7]%'*/           
                                                AND C.nMovNro < B.nMovNro           
                                INNER JOIN #OpeTpo O          
    ON C.cOpeCod = O.cOpecod           
                            WHERE a.bPagoAnticipado = 1                 
                            GROUP BY A.cCtaCod, B.nMovNro               
) D          
                            INNER JOIN MovColDet (NOLOCK) E             
                                ON D.cCtaCod = E.cCtaCod AND D.nMovNroPago = E.nMovNro /*AND E.cOpeCod LIKE '100[2-7]%'*/          
                            INNER JOIN #OpeTpo O          
                                ON E.cOpeCod = O.cOpecod           
                    INNER JOIN #TCalendarios F          
                    ON D.cCtaCod = F.cCtaCod           
                                        AND E.nNroCalen = F.nNroCalen       
AND E.nNroCuota = F.nCuota          
                            INNER JOIN ColocCalendario CC     WITH (NOLOCK)          
ON E.cCtaCod = CC.cCtaCod           
               AND E.nNroCalen = CC.nNroCalen           
                                        AND CC.nColocCalendApl = 1           
                                        AND E.nNroCuota = CC.nCuota                 
          
          
                    DELETE  c FROM          
                            #TPagoAnticipadoPre a           
                            inner join           
                                (select max(nmovnropago) as nmovnropagomax ,min(nmovnropago) as nmovnropagomin ,cctacod,nNroCalen, nNroCuota from #TPagoAnticipadoPre group by cctacod,nNroCalen, nNroCuota ) b           
                        on b.cCtaCod = a.cCtaCod           
                                        and a.nNroCalen = b.nNroCalen and a.nNroCuota = b.nNroCuota          
                                        and  nmovnropagomax <> nmovnropagomin          
                            inner join #TPagoAnticipadoPre c on a.cctacod = c.cctacod and c.nnrocuota = a.nnrocuota and a.nNroCalen = c.nNroCalen and c.nMovNroPago <> b.nmovnropagomin          
          
            --INSERTANDO PAGO ANTICIPADO          
                    INSERT INTO #TPagoAnticipado (cCtaCod, nNroCalen, nCuota, dVenc,dPago, nDiasAtraso, nMovNro)          
                    SELECT cCtaCod, nNroCalen, nNroCuota, dVenc,dPago, nDiasAtraso, nMovNroPago FROM #TPagoAnticipadoPre          
          
                    --SELECT DISTINCT D.cCtaCod, E.nNroCalen, E.nNroCuota, CC.dVenc,cc.dPago, F.nDiasAtraso, D.nMovNroPago            
                    --FROM           
                    --     (                
                    --     SELECT A.cCtaCod, B.nMovNro, MAX(C.nMovNro) AS nMovNroPago          
                    --     FROM #TCreditos A           
                    --           INNER JOIN ColocPagoAdelantado B WITH (NOLOCK)          
                    --                  ON A.cCtaCod = B.cCtaCod           
                    --           INNER JOIN MovCol (NOLOCK) C                
                    --                  ON B.cCtaCod = C.cCtaCod /*AND C.cOpeCod LIKE '100[2-7]%'*/           
                    --                         AND C.nMovNro < B.nMovNro           
                    --           INNER JOIN #OpeTpo O          
                    --                  ON C.cOpeCod = O.cOpecod           
                    --     WHERE a.bPagoAnticipado = 1                 
                    --     GROUP BY A.cCtaCod, B.nMovNro               
                    --     ) D          
        --     INNER JOIN MovColDet (NOLOCK) E             
                    --           ON D.cCtaCod = E.cCtaCod AND D.nMovNroPago = E.nMovNro /*AND E.cOpeCod LIKE '100[2-7]%'*/          
                    --     INNER JOIN #OpeTpo O          
    --           ON E.cOpeCod = O.cOpecod           
                    --     INNER JOIN #TCalendarios F          
                    --           ON D.cCtaCod = F.cCtaCod           
                    --                  AND E.nNroCalen = F.nNroCalen           
    --                  AND E.nNroCuota = F.nCuota          
                    --     INNER JOIN ColocCalendario CC     WITH (NOLOCK)          
                --           ON E.cCtaCod = CC.cCtaCod           
                    --                  AND E.nNroCalen = CC.nNroCalen           
                    --                  AND CC.nColocCalendApl = 1           
     --                  AND E.nNroCuota = CC.nCuota                        
          
                    --INSERTANDO DATA FINAL DE CALENDARIOS          
                            INSERT INTO #TCalenFinal(cCtaCod, nNroCalen, nCuota, dVenc,dPago, nDiasAtraso, nMovNro)           
                        SELECT A.cCtaCod, A.nNroCalen, A.nCuota,  A.dVenc,a.dPago, A.nDiasAtraso, NULL nMovNro          
                            FROM #TCalendarios A         
    LEFT JOIN #TPagoAnticipado B           
                                        ON A.cCtaCod = B.cCtaCod           
                                                AND A.nNroCalen = B.nNroCalen           
                                                AND A.nCuota = B.nCuota            
                            WHERE B.cCtaCod IS NULL OR B.nDiasAtraso > 0          
                 UNION ALL          
                            SELECT T.cCtaCod, T.nNroCalen, T.nCuota, T.dVenc,t.dPago, T.nDiasAtraso, T.nMovNro           
                            FROM           
                                (          
                                SELECT           
 ROW_NUMBER() OVER(PARTITION BY A.cCtaCod, A.nNroCalen, A.nMovNro ORDER BY A.nCuota ASC) AS ROW,           
                                        A.cCtaCod,           
                                        A.nNroCalen,           
                                   A.nCuota,           
              A.dVenc,           
                                        A.dPago,          
                                        0 AS nDiasAtraso,           
                                        A.nMovNro           
                                FROM #TPagoAnticipado A           
                                WHERE A.nDiasAtraso = 0          
                                ) T          
                            WHERE T.ROW = 1               
          
                            --SELECT cCtaCod,nNroCalen,nCuota,dVenc,dPago,nDiasAtraso,nMovNro          
                    DELETE          
                            FROM #TCalenFinal             
                            where nDiasAtraso<=0          
                 
                    END          
            ELSE          
                    BEGIN          
                            --SELECT cCtaCod,nNroCalen,nCuota,dVenc,dPago,nDiasAtraso,nMovNro          
                            DELETE          
                            FROM #TCalenFinal             
                            where nDiasAtraso<=0          
                    END          
          
                              
                 
            SET NOCOUNT OFF          
          
            --ACTUALIZANDO LA VARIABLE          
            IF EXISTS (SELECT 1 FROM #TCalenFinal)          
            BEGIN          
                    UPDATE A           
                            SET A.cValorCalculado = (SELECT MAX(nDiasAtraso) FROM #TCalenFinal)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable=100         
            END          
            ELSE          
            BEGIN          
                    UPDATE A           
                            SET A.cValorCalculado = 0          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable=100          
            END          
            
          
DROP TABLE #TCreditos          
            DROP TABLE #TCalendarios          
DROP TABLE #TPagoAnticipado          
            DROP TABLE #TCalenFinal          
            DROP TABLE #OpeTpo          
          
        END          
    END          
          
    BEGIN -- [nIdVariable = 101,102,103]          
        IF EXISTS(SELECT 1 FROM #DatosEntradaUnPivot WHERE nIdVariable in (101,102,103))          
  BEGIN          
          --VARIABLE 103          
                    IF @nTipoCredito IN (10,11,12)          
                    BEGIN          
                  UPDATE A           
                                  SET A.cValorCalculado = (  SELECT mesesValNego           
 FROM subTipoCredito           
               WHERE nTipoCredito = @nTipoCredito )          
                           FROM #DatosEntradaUnPivot A          
                           WHERE nIdVariable= 103          
                    END          
      IF @nTipoCredito = 13          
                    BEGIN          
                           UPDATE A           
                            SET A.cValorCalculado = (  SELECT mesesValNego          
                                                                                 FROM subTipoCredito  with(nolock)         
                                                                                 WHERE nTipoCredito = @nTipoCredito           
                                                                                       AND nSubTipoCredito = @nSubTipoCredito)          
                           FROM #DatosEntradaUnPivot A          
                           WHERE nIdVariable= 103          
                                     
                    END          
                    --VARIABLE 102          
                    DECLARE @nAñoNac INT,@nMesNac INT, @nDiaNac INT          
                    SELECT           
                @Dias =0,          
                           @Meses =0 ,           
        @Años =0 ,          
                          @MesesT =0,          
                           @AñoFin =0,            
                           @MesFin =0,          
                           @DiaFin =0          
          
                    SET @AñoFin=YEAR(@dFechaActual)          
                    SET @MesFin=MONTH(@dFechaActual)          
                    SET @DiaFin=DAY(@dFechaActual)          
          
                              
                    IF(EXISTS(SELECT cPersCod FROM PersID with(nolock)  WHERE cPersIDnro=@cNumDOITit ))          
                    BEGIN          
                                     
                           SELECT @nAñoNac=Z.nAñoNac,@nMesNac=Z.nMesNac,@nDiaNac=Z.nDiaNac FROM           
                           (          
                           SELECT           
                                 nAñoNac = CASE WHEN C.cPersCod IS NULL THEN YEAR(dPersNacCreac) ELSE YEAR(dPersFechAct) END,          
                                  nMesNac = CASE WHEN C.cPersCod IS NULL THEN MONTH(dPersNacCreac) ELSE MONTH(dPersFechAct) END,          
                                  nDiaNac = CASE WHEN C.cPersCod IS NULL THEN DAY(dPersNacCreac) ELSE DAY(dPersFechAct) END          
                           FROM           
                                  PERSONA A    WITH (NOLOCK)          
                                  JOIN PersID B WITH (NOLOCK)          
                                     ON A.cPersCod=B.cPersCod           
                                  LEFT JOIN PersonaJur C with(nolock)  ON C.cPersCod = a.cPersCod          
                                  LEFT JOIN PersonaNat D with(nolock)  ON D.cPersCod = a.cPersCod          
                                  WHERE B.cPersIDnro=@cNumDOITit) Z          
                    END          
                    ELSE          
         BEGIN           
                            SELECT @nAñoNac = YEAR(dFecNac), @nMesNac= MONTH(dfecnac), @nDiaNac= DAY(dfecnac) from PersonaPot PP  with(nolock)           
                            INNER JOIN PersPotId id with(nolock)  on PP.nCodPersona = id.nCodPersona where id.cNroDocumento = @cNumDOITit            
                    END          
                          
     UPDATE A           
SET A.cValorCalculado = IIF(@nAñoNac = '', '0001-01-01', CONCAT(@nAñoNac, '-', RIGHT(CONCAT('00',@nMesNac),2), '-', RIGHT(CONCAT('00',@nDiaNac),2)))          
         --CASE WHEN ISNULL(@nAñoNac,'') = '' THEN 0 ELSE 1 END          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable= 102          
                              
                            
                    --VARIABLE 101          
          
                    --Comprueba si el día es menor o igual al de fin.          
                    IF @DiaFin - @nDiaNac >= 0           
       BEGIN          
               SET @Dias = @DiaFin - @nDiaNac          
                    END          
                    --Si no, calcula la suma en días, desde el día de Inicio a fin de mes, mas los días de Fin, y le resta uno al mes de Fin.-          
                    ELSE          
         BEGIN          
                          SET @Dias = (day(dateadd(mm,1,cast((str(@nAñoNac)+ '/' + str(@nMesNac) +'/01'  ) as datetime)) - 1 )- @nDiaNac) + @DiaFin          
                           SET @MesFin = @MesFin - 1          
                    END          
          
                  --Lo mismo con el mes.          
                    IF @MesFin - @nMesNac >= 0           
                    BEGIN          
                           SET @Meses = @MesFin - @nMesNac          
                    END          
                    ELSE          
                    BEGIN          
                           SET @Meses = (@MesFin - @nMesNac) + 12          
                           SET @AñoFin = @AñoFin - 1          
                    END          
          
                    SET @Años = @AñoFin - @nAñoNac          
                    SET @MesesT=@Meses          
                    if(@Años>0)          
                    begin           
                           set @mesesT=@Años*12+@Meses          
                    end          
                    UPDATE A           
                                  SET A.cValorCalculado = ISNULL( @mesesT,0)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable= 101          
               
             END          
          
          
       END          
              
    BEGIN -- [nIdVariable = (104,105)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (104,105))          
             BEGIN          
                    DECLARE @nIngNetoSum DECIMAL(18,2)          
                  DECLARE @ConsolFte TABLE          
                    (          
                           nMonto   DECIMAL(18,2)          
               ,nMoneda       INT          
 )          
                              
                     IF @nTipoFuente=1          
                           BEGIN          
                               INSERT INTO @ConsolFte          
                               SELECT (nPersIngCli+nPersIngCon+nPersOtrIng),nMoneda          
                               FROM #FTeDependiente          
                END          
                    ELSE          
                           BEGIN          
                   INSERT INTO @ConsolFte          
                               SELECT (((nPersFIVentas + nPersFIRecupCtasXCobrar-nPersFICostoVentas)+nPersFIEgresosOtros)+nPersIngFam),nMoneda          
                               FROM #FTeIndependiente          
                           END          
          
                    UPDATE A          
                    SET nMonto=nMonto* @tipoCambio          
                    FROM @ConsolFte A          
                    WHERE nMoneda=2          
          
                    SELECT @nIngNetoSum=SUM(nMonto)          
                    FROM @ConsolFte          
          
                              
                     UPDATE A          
                    SET A.cValorCalculado = (CASE WHEN A.nIdVariable=104 THEN           
                                                    (SELECT CONVERT(DECIMAL(18,2),nConsSisValor) FROM ConstSistema WHERE nConsSisCod=361)          
                                                 WHEN A.nIdVariable=105 THEN ISNULL(@nIngNetoSum,0)          
                                                                     END)          
     FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable IN(104,105)          
             END          
       END          
          
    BEGIN -- [nIdVariable = (109)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =109)          
             BEGIN          
                    INSERT INTO #PersonaRelacDiasatraso          
  SELECT PP.CCTACOD, PP.CPERSCOD, NPRDPERSRELAC, CCONSDESCRIPCION, CC.NDIASATRASO, CPERSNOMBRE            
                     FROM PRODUCTO P WITH (NOLOCK)          
                               INNER JOIN PRODUCTOPERSONA PP WITH (NOLOCK)          
                                     ON P.CCTACOD = PP.CCTACOD            
                               INNER JOIN COLOCACCRED CC WITH (NOLOCK)          
                 ON P.CCTACOD = CC.CCTACOD            
                               INNER JOIN PERSONA PER WITH (NOLOCK)          
                                    ON PP.CPERSCOD = PER.CPERSCOD            
                               INNER JOIN CONSTANTE CTE ON NPRDPERSRELAC = CTE.NCONSVALOR AND NCONSCOD = 3002            
                     WHERE PP.CPERSCOD IN (SELECT CPERSCOD FROM #PersonaRelacionCred WHERE nPersRelac IN (20,21,22,23,24,25))            
                           AND NPRDPERSRELAC IN (20,21,22,23,24,25) AND NPRDESTADO IN (2020, 2021, 2022, 2030, 2031, 2032, 2201, 2202, 2205, 2206)           
                           AND NDIASATRASO > CASE            
                                                          WHEN (@nColocCondicion2 <> 1) AND dbo.FN_GetcCredProducto(P.cCtaCod) = '210' THEN 1           
                                                          ELSE 0            
                                                      END   --PRODUCTO PAGADIARIO PERMITE MAXIMO 1 DIA DE ATRASO EN LA ETAPA DE SUGERENCIA          
          
                           AND PP.CCTACOD NOT IN (SELECT CCTACOD FROM RECHAZOCREDITOPERSONASRELACIONADAS)            
                           AND PP.CPERSCOD NOT IN (SELECT CPERSCOD FROM RECHAZOCREDITOPERSONASRELACIONADAS WHERE NTIPO=2)             
          
          
   UPDATE A          
                    SET A.cValorCalculado = (SELECT COUNT(1) FROM #PersonaRelacDiasatraso)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =109          
             END          
     END          
          
    BEGIN -- [nIdVariable = (111)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =111)          
		BEGIN
			----------Verificamos que no se seleccione una de las lineas especiales de una campaña con promocion---------          
			DECLARE @NCOUNT INT = 0

			DECLARE @LineasCreditoProm NVARCHAR(MAX);

			SELECT @LineasCreditoProm = 
				STUFF((
					SELECT ',' + CAST(slineas AS NVARCHAR(MAX))
					FROM PromocionCreditoOferta PO WITH (NOLOCK)
						INNER JOIN PromocionCredito P WITH (NOLOCK)
							ON PO.nPromocionCred = P.nPromoCred
					WHERE ISNULL(P.IdCampana, -1) != ISNULL(@nIdCampana, 0)
					FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

			SELECT @NCOUNT = COUNT(1)
			FROM dbo.fn_Split(@LineasCreditoProm, ',') AS SplitResult
			WHERE SplitResult.items = @cLineaCred;



			----------Verificamos que no se seleccione una de las lineas especiales de una campaña especial---------          
			IF @NCOUNT = 0
			BEGIN
				DECLARE @LineasCredito NVARCHAR(MAX);

				SELECT @LineasCredito = 
					STUFF((
						SELECT ',' + CAST(CA.cLineasCredito AS NVARCHAR(MAX))
						FROM CampanasDetalle CA
						WHERE ISNULL(CA.IdCampana, -1) != ISNULL(@nIdCampana, 0)
						FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

				SELECT @NCOUNT = COUNT(1)
				FROM dbo.fn_Split(@LineasCredito, ',') AS SplitResult
				WHERE SplitResult.items = @cLineaCred;
			END

			UPDATE A
			SET A.cValorCalculado = @NCOUNT
			FROM #DatosEntradaUnPivot A
			WHERE nIdVariable = 111

		END      
     END          
            
    BEGIN -- [nIdVariable = (112,115,116)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(112,115,116,127))          
             BEGIN      
                      DECLARE @bTieneCampana   INT          
                               ,@bGarantiaReal BIT          
                               ,@nTasaMinCampE DECIMAL(5,4)          
                               ,@nTasaMaxCampE DECIMAL(5,4)          
      ,@bValidaTasaCampanaAmpliado INT          
                               ,@cCtaCodAnt    VARCHAR(18)          
                               ,@nTasaIntAnt   DECIMAL(5,4)          
                               ,@nuevaTasaIntAnt   DECIMAL(5,4)          
               ,@sCalifIntAnt  VARCHAR(5)          
                               ,@ncontValidaDeterioroCalificacion  INT          
                               ,@ndeterioro    INT          
                               ,@nGraciaMaxima INT          
                              
                     CREATE TABLE #CampaNavid2017          
                    (          
                           nCuotaMin      INT          
                           ,nCuotaMax  INT          
                           ,nPlazoMin  INT          
                           ,nPlazoMax  INT          
                           ,nTasaMin    DECIMAL(5,4)          
                           ,nTasaMax      DECIMAL(5,4)          
                    )          
                              
     IF (@nIdCampana IN (155, 158, 161, 165, 174, 177, 181, 182, 189, 191, 195))          
     BEGIN           
  DECLARE @nTipoCliente INT --3:A Sola Firma, 2:Sin Casa Propia, 1:Con Casa Propia          
  IF(@nIndCasaPropia = 2)          
  BEGIN          
   SET @nTipoCliente = 3          
  END          
  ELSE          
  BEGIN          
   SET @nTipoCliente = IIF(@bCasaPropiaoAval = 1,1,2)                
  END          
          
  SELECT cProductos,clineascredito,ctasas,ntipocliente,bgarantiareal,ntasaxMonto AS nTasaMin,5 AS nTasaMax          
  INTO #CampanaDetalle3          
  FROM CampanasDetalle           
  WHERE IdCampana=@nIdCampana          
  AND @cCredProducto IN (Select Items  from dbo.fn_Split(cProductos,','))          
  AND @cLineaCred IN (Select Items  from dbo.fn_Split(cLineasCredito,','))          
  AND @nIdTasa IN (Select CONVERT(INT,Items)  from dbo.fn_Split(ctasas,','))          
  AND nTipoCliente = @nTipoCliente          
  AND (bInmueblePropio = @bCasaPropiaoAval OR @nIdCampana = 161)          
  AND @nMonto BETWEEN nfiltroMontoMin AND nfiltroMontoMax          
  AND @nPlazo BETWEEN nfiltroPlazoMin AND nfiltroPlazoMax          
  AND cTipAplicacion = '1'          
          
  IF EXISTS (SELECT 1 FROM #CampanaDetalle3)          
  BEGIN          
   SELECT @bTieneCampana= COUNT(1)           
   FROM #CampanaDetalle3          
  END          
  ELSE          
  BEGIN          
   SET @bTieneCampana = 0          
  END          
                
  SELECT TOP 1 @nTasaMinCampE=nTasaMin          
   ,@nTasaMaxCampE=nTasaMax          
  FROM #CampanaDetalle3           
  DROP TABLE #CampanaDetalle3          
     END          
     ELSE          
     BEGIN          
        
      SET @nGraciaMaxima=30          
      IF @nIdCampana=125          
      BEGIN          
          SET @nGraciaMaxima=90          
      END          
          
      SET @bValidaTasaCampanaAmpliado=1          
             
       SET @bGarantiaReal =CASE WHEN (SELECT COUNT(1) FROM GARANTIAS A          
                 INNER JOIN #GarantiaCredito B          
                   ON A.cNumGarant=B.nNumGarant          
                WHERE A.nTipoColateralID IN (3,4,5,6,7,8,9,10,11,12,13,14,15,16,17))>0 THEN 1 ELSE 0 END          
                         
       SELECT cProductos,clineascredito,ctasas,ntipocliente,bgarantiareal            
           ,nTasaMin12M,nTasaMax12M,nTasaMin18M,nTasaMax18M,nTasaMin24M,nTasaMax24M,nTasaMin48M,nTasaMax48M          
      INTO #CampanaDetalle2          
      FROM CampanasDetalle           
       WHERE IdCampana=@nIdCampana          
          AND @cCredProducto IN (Select Items  from dbo.fn_Split(cProductos,','))          
          AND @cLineaCred IN (Select Items  from dbo.fn_Split(cLineasCredito,','))          
          AND @nIdTasa IN (Select Items  from dbo.fn_Split(ctasas,','))          
          AND (nTipoCliente IS NULL OR nTipoCliente=CASE WHEN SUBSTRING(@cCalifClient,1,1)='A' THEN 2 ELSE 1 END)          
          AND (bGarantiaReal IS NULL OR bGarantiaReal=@bGarantiaReal)          
          
      IF (@nColocCondicion2=1)          
      BEGIN          
          SET @cCtaCodAnt = (SELECT TOP 1 A.cCtaCod from #CreditosProcesar a inner join COLOCACIONES b with(nolock)  on a.cCtaCod=b.cCtaCod  order by b.dVigencia desc)          
          SET @nTasaIntAnt = (select nTasaInteres from ProductoTasaInteres with(nolock)  where cCtaCod = @cCtaCodAnt and nPrdTasaInteres = 1)          
          SET @sCalifIntAnt = (select case when ci.cCalEsp2 = '' then (case when ci.cCalEsp1 = '' then ci.cCalInt           
                                else ci.cCalEsp1 end)           
                                else ci.cCalEsp2 end           
                      from NORMA3780.ci_DataFinalCalInt ci   with(nolock)         
                      where ci.cPersCod=@cPersCodTitular          
                     and ci.dFecha=(select MAX(dfecha) from NORMA3780.ci_DataFinalCalInt a1 with(nolock)           
     inner join ProductoPersona c1 with(nolock)  on a1.cPersCod=c1.cPersCod and c1.nPrdPersRelac=20          
                                  inner join COLOCACIONES b1 with(nolock)  on c1.cCtaCod=b1.cCtaCod          
                                  where a1.dFecha<=b1.dVigencia and b1.cCtaCod = @cCtaCodAnt) -- cuenta anterior a ampliar          
                 )          
          SET @nuevaTasaIntAnt = @nTasaIntAnt          
          IF (select codigo from @CalificacionInt where cCalifInt=@sCalifIntAnt) < (select codigo from @CalificacionInt where cCalifInt=@cCalifClient)          
          BEGIN          
           SET @ncontValidaDeterioroCalificacion = 1          
           SET @ndeterioro = (select codigo from @CalificacionInt where cCalifInt=@cCalifClient) - (select codigo from @CalificacionInt where cCalifInt=@sCalifIntAnt)          
           SET @nuevaTasaIntAnt = @nTasaIntAnt          
           WHIle @ncontValidaDeterioroCalificacion <= @ndeterioro          
         BEGIN          
             SET @nuevaTasaIntAnt = @nuevaTasaIntAnt + 0.2          
             SET @ncontValidaDeterioroCalificacion = @ncontValidaDeterioroCalificacion + 1          
           END          
          END          
          
          IF @nTasa >= @nuevaTasaIntAnt          
          BEGIN          
           SET @bValidaTasaCampanaAmpliado = 0          
          END          
      END          
          
          
      SELECT @bTieneCampana= COUNT(1)           
       FROM #CampanaDetalle2          
          
      INSERT INTO #CampaNavid2017 (nCuotaMin,nCuotaMax,nPlazoMin,nPlazoMax,nTasaMin  ,nTasaMax    )          
      SELECT x.CuotaMin,x.CuotaMax,x.nPlazoMin,x.nPlazoMax,x.nTasaMin,x.nTasaMax          
      FROM (          
          SELECT  0 as CuotaMin,12 as CuotaMax,0 nPlazoMin,366 nPlazoMax, nTasaMin12M as nTasaMin,nTasaMax12M  as nTasaMax          
          FROM #CampanaDetalle2          
          UNION ALL          
          SELECT  12 as CuotaMin,18 as CuotaMax,366,549, nTasaMin18M ,nTasaMax18M           
          FROM #CampanaDetalle2          
          UNION ALL          
          SELECT  18 as CuotaMin,24 as CuotaMax,549,732, nTasaMin24M,nTasaMax24M           
          FROM #CampanaDetalle2          
          UNION ALL          
          SELECT  24 as CuotaMin,48 as CuotaMax,732,1464, nTasaMin48M,nTasaMax48M           
          FROM #CampanaDetalle2 ) x          
  WHERE x.nPlazoMax IS NOT NULL          
          
                              
          
      SELECT TOP 1 @nTasaMinCampE=nTasaMin          
,@nTasaMaxCampE=nTasaMax          
      FROM #CampaNavid2017           
       WHERE ((nCuotaMin<@nCuotas AND @nCuotas<=nCuotaMax)          
           OR (nPlazoMin<@nPlazo AND @nPlazo<=(nPlazoMax + (CASE WHEN @nTipoPeriodicidad<>1 THEN 0 ELSE @nGraciaMaxima END) ) )           
           AND @bValidaTasaCampanaAmpliado=1)          
      DROP TABLE #CampanaDetalle2,#CampaNavid2017          
     END          
                    UPDATE A          
                    SET A.cValorCalculado = CASE WHEN ISNULL(@bTieneCampana,0)>0 THEN 1 ELSE 0 END          
               FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =112          
          
          
                    UPDATE A          
                    SET A.cValorCalculado = (CASE WHEN ISNULL(@nTasaMinCampE,0)=0 THEN @nTasa ELSE @nTasaMinCampE END )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =115          
          
                              
                     UPDATE A          
                    SET A.cValorCalculado = (CASE WHEN ISNULL(@nTasaMaxCampE,0)=0 THEN @nTasa ELSE @nTasaMaxCampE END )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =116          
          
                              
       END          
    END          
            
    BEGIN -- [nIdVariable = 117,118)]          
             IF EXISTS(SELECT 1 FROM #DatosEntradaUnPivot WHERE nIdVariable IN (117,118))          
             BEGIN          
          
          
                    DECLARE @nEsTrabajador INT;          
                    DECLARE @temp TABLE           
                    (          
                           cCtaCod    VARCHAR(20) ,          
                           nMontoCol  MONEY ,          
nPrdEstado INT ,          
                           nPlazo     INT ,          
                           nCuotas    INT          
            )          
                    SELECT @nEsTrabajador = COUNT(cPersCod)          
                    FROM RRHH  with(nolock)         
                    WHERE cPersCod = @cPersCodTitular          
  AND LEFT(crhcod , 1) = 'E'          
               AND nRHEstado IN ( 201 , 301 , 302 , 401 , 402 , 403 , 404 , 405 , 406 , 501 , 502 , 503 , 601 );          
                              
                    UPDATE A           
             SET A.cValorCalculado = @nEsTrabajador          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable=117          
          
                    IF @nEsTrabajador> 0          
                    BEGIN          
                           INSERT INTO @temp          
                EXEC PA_ObtenCreditosTitular @cPersCodTitular;          
                    END          
          
               UPDATE A           
                           SET A.cValorCalculado = (SELECT COUNT(1)          
    FROM @temp          
                                                                   WHERE cCtaCod LIKE '108__320%')          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable=118          
          
             END          
       END          
          
    BEGIN -- [nIdVariable = 120]          
             IF EXISTS(SELECT 1 FROM #DatosEntradaUnPivot WHERE nIdVariable=120)          
             BEGIN          
                    IF EXISTS(SELECT Items FROM dbo.fn_Split( (SELECT nConsSisValor FROM ConstSistema WHERE nConsSisCod = 542),',') WHERE Items = '01') AND           
                           (SELECT nConsSisValor  from ConstSistema with(nolock)  where nConsSisCod =541 ) = '0'          
                    BEGIN          
                           UPDATE A           
           SET A.cValorCalculado = 1          
                           FROM #DatosEntradaUnPivot A          
                           WHERE nIdVariable=120          
                    END          
                    ELSE          
                    BEGIN          
                        UPDATE A           
                                  SET A.cValorCalculado = 0          
                           FROM #DatosEntradaUnPivot A          
  WHERE nIdVariable=120          
                    END          
                                                  
   END          
       END          
          
    BEGIN -- [nIdVariable = 121,122,123]          
             IF EXISTS(SELECT 1 FROM #DatosEntradaUnPivot WHERE nIdVariable IN (121,170)) AND @nIdCampana NOT IN (161)          
             BEGIN          
          
                    DECLARE @nValidacion INT =0          
          
                    EXEC PA_ValidacionHorizonte6Meses           
                           @cPersCodTitular,        
          @cCredProducto,           
                 @nColocCondicion,          
                           @nColocCondicion2,          
                           @nMonto,           
                           @nMoneda,          
                @nIdCampana,          
                           @nValidacion OUTPUT,          
                           @cMensajeNegocioh6m OUTPUT, --13/03/18 reversion de cambio          
                           @cMensajeh6m OUTPUT           
          
                                            
                           UPDATE A           
                                  SET A.cValorCalculado =  @nValidacion                                                                            
                           FROM #DatosEntradaUnPivot A          
                           WHERE nIdVariable = 121                     
          
                           UPDATE A           
                                SET A.cValorCalculado =  CASE WHEN ISNULL(@cMensajeNegocioh6m ,'') = ''THEN 0 ELSE 1 END          
                           FROM #DatosEntradaUnPivot A          
                           WHERE nIdVariable = 170              
                           --UPDATE A           
                           --     SET A.cValorCalculado =  @cMensajeNegocioh6m          
                           --FROM #DatosEntradaUnPivot A          
                           --WHERE nIdVariable IN (123)          
                        
             END          
       END          
          
    BEGIN -- [nIdVariable = (127)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =127)          
             BEGIN          
  DECLARE @cCtaCodAntX     VARCHAR(10)          
                           ,@CambioCalif INT          
                           ,@codigoant  INT          
                           ,@CodigActual INT          
          
               IF (@nColocCondicion2=1)          
              BEGIN          
            SET @cCtaCodAnt = (SELECT TOP 1 A.cCtaCod from #CreditosProcesar a inner join COLOCACIONES b WITH (NOLOCK) on a.cCtaCod=b.cCtaCod  order by b.dVigencia desc)          
                           SET @sCalifIntAnt = (select case when ci.cCalEsp2 = '' then (case when ci.cCalEsp1 = '' then ci.cCalInt           
                                            else ci.cCalEsp1 end)           
                      else ci.cCalEsp2 end           
                                                                           from NORMA3780.ci_DataFinalCalInt ci WITH (NOLOCK)          
                                     where ci.cPersCod=@cPersCodTitular          
                                                                          and ci.dFecha=(select MAX(dfecha) from NORMA3780.ci_DataFinalCalInt a1  WITH (NOLOCK)          
                                                       inner join ProductoPersona c1 WITH (NOLOCK)          
                                                                                                                                       on a1.cPersCod=c1.cPersCod and c1.nPrdPersRelac=20          
       inner join COLOCACIONES b1 WITH (NOLOCK)      
                                        on c1.cCtaCod=b1.cCtaCod          
                                                                                                                           where a1.dFecha<=b1.dVigencia and b1.cCtaCod = @cCtaCodAnt) -- cuenta anterior a ampliar          
                                            )          
       END          
                              
               END          
                 SET @CodigActual = (SELECT codigo FROM @CalificacionInt WHERE cCalifInt=@cCalifClient)           
                SET @codigoant =(SELECT codigo FROM @CalificacionInt WHERE cCalifInt=@cCtaCodAntX)          
             
                               
SET @CambioCalif=ISNULL(@CodigActual,0)-ISNULL(@codigoant,0)          
          
                    UPDATE A          
      SET A.cValorCalculado = CASE WHEN @nColocCondicion2<>0 THEN 0 ELSE ISNULL(@CambioCalif,0) END           
                     FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =127          
     END          
          
    BEGIN -- [nIdVariable = (124,128)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(124,128))          
             BEGIN          
                    DECLARE @bTasaEspecial bit          
          
                    UPDATE A          
                    SET A.cValorCalculado = CASE WHEN (SELECT     COUNT(1)          
                                                              FROM dbo.CampanasDetalle WITH (NOLOCK)          
                                                              WHERE IdCampana = @nIdCampana          
                                                 AND (cLineasCredito IS NULL OR   @cLineaCred IN (Select Items  from dbo.fn_Split(cLineasCredito,',')))          
                                                                     AND (@nIdTasa IS NULL or @nIdTasa IN (Select Items from dbo.fn_Split(ctasas,',')) )          
                                                        )>0 THEN 1 ELSE 0 END          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =124          
          
          
                    SET @bTasaEspecial = IIF(EXISTS (SELECT c.nColocacTasaId FROM ColocLineaCredito a WITH (NOLOCK)          
                                                                          inner join ColocLineaCreditoTasas b WITH (NOLOCK)          
                  ON a.nLineaCredId=b.nLineaCredId          
                    inner join ColocacTasas c WITH (NOLOCK)          
                                                                                 ON b.nColocacTasaId=c.nColocacTasaId          
        WHERE a.cLineaCred = @cLineaCred and b.nColocacTasaId = @nIdTasa          
                                      and c.nTpoClienteInicial is not null          
                                               ),1,0)          
                              
               UPDATE A          
                    SET A.cValorCalculado = @bTasaEspecial          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =128          
             END          
 END          
          
    BEGIN -- [nIdVariable = 129]          
          IF EXISTS(SELECT 1 FROM #DatosEntradaUnPivot WHERE nIdVariable IN (129))          
          BEGIN

			DECLARE @cTipoLimGloIndDirTra INT,
					@CodEmpleado CHAR(13)

			declare @cListaProdExcluidos varchar(200) --LFAM 22-08-18          
			DECLARE @nRet INTEGER; --LFAM 22-08-18 se movio declaracion de variable, 0:OK 1:sobrepasa lim. ind. 2: sobrepasa lim. Glo. 3:Bloqueado          
			DECLARE @nMontoInflar MONEY = 0
			DECLARE @nMontoCreditoEnlinea DECIMAL(18, 2)
			DECLARE @nMontoReservadoRH DECIMAL(18, 2)
			DECLARE @nMontoReservadoConsumo DECIMAL(18, 2)
			DECLARE @dFechaVigenciaPrestamos DATE

			SELECT @nMontoCreditoEnlinea = nConsSisValor -- SELECT *
			FROM ConstSistema with (nolock)
			WHERE nConsSisCod = 1310

			SELECT @dFechaVigenciaPrestamos = CONVERT(DATE, nConsSisValor) --SELECT *
			FROM ConstSistema with (nolock)
			WHERE nConsSisCod = 1315

			IF (@nMontoCreditoEnlinea > 0)
			BEGIN
				SET @nMontoCreditoEnlinea
					= @nMontoCreditoEnlinea - isnull(
											  (
												  SELECT SUM(a.nsaldo)
												  FROM producto a WITH (NOLOCK)
													  INNER JOIN colocaciones.AUDResulCreditosEnLinea b WITH (NOLOCK)
														  ON a.cCtaCod = b.cctacod
													  INNER JOIN colocaciones c WITH (NOLOCK)
														  ON c.cCtaCod = a.cCtaCod
												  WHERE b.cMensajeError = ''
														AND a.nPrdEstado not in ( 2003, 2080, 2050 )
														AND SUBSTRING(a.cctacod, 6, 3) = '320'
														AND C.dVigencia >= @dFechaVigenciaPrestamos
											  ),
											  0
													)
			END

			IF @nMontoCreditoEnlinea < 0
			BEGIN
				SET @nMontoCreditoEnlinea = 0
			END

			SELECT @nMontoReservadoRH = DBO.FN_GetReservaGDH('')
			SELECT @nMontoReservadoConsumo = DBO.FN_GetReservaNegocio('')
			SELECT @nMontoInflar = nConsSisValor --SELECT *
			FROM ConstSistema with (nolock)
			WHERE nConsSisCod = 7070

			IF @cCredProducto = '320'
			BEGIN
				SET @cTipoLimGloIndDirTra = 1
			END
			ELSE
			BEGIN
				IF EXISTS
				(
					SELECT cperscod
					FROM rrhh with (nolock)
					WHERE LEFT(crhcod, 1) IN ( 'E', 'D' )
						  AND nrhestado = 201
						  AND cperscod = @cPersCodTitular
				)
				BEGIN
					SET @cTipoLimGloIndDirTra = 1
				END
			END

			--VERIFICANDO SI ES PARIENTE DE TRABAJADOR O DIRECTOR.          
			IF EXISTS
			(
				SELECT a.cPersCod
				FROM rrhh a WITH (NOLOCK)
					INNER JOIN PersRelaciones b WITH (NOLOCK)
						on a.cPersCod IN ( b.cPersCod, b.cPersRelacPersCod )
						   AND LEFT(a.crhcod, 1) in ( 'E', 'D' )
				WHERE a.nRHEstado = 201
					  AND @cPersCodTitular IN ( b.cPersCod, b.cPersRelacPersCod )
					  AND b.npersrelac IN ( 0, 1, 2, 3, 4, 11, 12, 15, 16, 17, 19, 20, 21, 22, 24, 28, 29, 30, 31 )
			)
			BEGIN
				SET @cTipoLimGloIndDirTra = 1

				SELECT @CodEmpleado = cPersCod
				FROM persrelaciones
				WHERE cpersrelacperscod = @cPersCodTitular

			END
			ELSE
			BEGIN
				SET @cMsjLimGloIndCredDirTra = ''
			END

			IF @cTipoLimGloIndDirTra = 1
			BEGIN
				IF @CodEmpleado = ''
				BEGIN
					SET @CodEmpleado = @cPersCodTitular;
				END;

				--LFAM 2018-08-22 validando productos restringidos para familiares de trabajadores          
				--Obteniendo listas de productos restringidos          
				CREATE TABLE #TProductos (cCodProd char(3) collate SQL_Latin1_General_CP1_CI_AS);

				SELECT @cListaProdExcluidos = nConsSisValor
				FROM ConstSistema with (nolock)
				WHERE nConsSisCod = 10136

				INSERT INTO #TProductos
				SELECT iTems
				FROM dbo.fn_split(@cListaProdExcluidos, ',')

				--Identificando el producto solicitado           
				If isnull(@cCtaCod, '') <> ''
				Begin
					Select @cCredProducto = substring(cSubProducto, 1, 3)
					From ColocProductoComer with (nolock)
					where cctacod = @cCtaCod
				End

				IF exists
				(
					select cCodProd
					from #TProductos
					where cCodProd = @cCredProducto
						  AND @nIdcampana NOT IN ( 161 )
				)
				BEGIN
					set @cMsjLimGloIndCredDirTra
						= 'El producto seleccionado se encuentra restringido para familiares de trabajadores'
					set @nRet = 3
					drop table #TProductos
				END
				ELSE --LFAM 22-08-2018 Si no tiene restriccion por producto            
				BEGIN

					CREATE TABLE #Regidores
					(
						nId INT IDENTITY(1, 1),
						cPersCod VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS
					)
					CREATE TABLE #Total
					(
						CodEmpleado varchar(13) collate SQL_Latin1_General_CP1_CI_AS,
						CodPariente varchar(13) collate SQL_Latin1_General_CP1_CI_AS,
						nTipo int
					)

					INSERT INTO #Regidores
					(
						cPersCod
					)
					SELECT DISTINCT
						X.cPersCod
					FROM
					(
						SELECT ROW_NUMBER() OVER (PARTITION BY A.cPersCod ORDER BY A.dRHCargoFecha DESC) nOrden,
							   A.cPersCod,
							   A.cRHCargoCod,
							   A.cRHCargoCodOficial
						FROM RHCargos A with (nolock)
					) X
					WHERE X.nOrden = 1
						  AND (
								  X.cRHCargoCod = '008004'
								  OR X.cRHCargoCodOficial = '008004'
							  )

					INSERT INTO #Total
					(
						CodEmpleado,
						CodPariente,
						nTipo
					)
					SELECT DISTINCT
						A.cPersCod,
						A.cPersCod,
						1 AS nNivel
					FROM RRHH A with (nolock)
						LEFT JOIN #Regidores B
							ON A.cPersCod = B.cPersCod
					WHERE LEFT(A.cRHCod, 1) IN ( 'E', 'D' )
						  AND A.nRHEstado = 201
						  AND DATEDIFF(DAY, GETDATE(), A.dIngreso) <= 0
						  AND B.cPersCod IS NULL

					--INSERTANDO RELACION DE FAMILIARES DE TRABAJADORES(Tipo 2: Familiar de Trabajador)          
					INSERT INTO #Total
					(
						CodEmpleado,
						CodPariente,
						nTipo
					)
					SELECT DISTINCT
						A.cperscod CodEmpleado,
						B.cpersrelacperscod CodPariente,
						2
					FROM RRHH A with (nolock)
						INNER JOIN PersRelaciones B with (nolock)
							ON A.cPersCod = B.cPersCod
							   AND B.nPersRelac IN ( 0, 1, 2, 3, 4, 11, 12, 15, 16, 17, 19, 20, 21, 22, 24, 28, 29, 30, 31 )
							   AND ISNULL(B.cPersRelacPersCod, '') <> ''
							   AND ISNULL(B.cPersCod, '') <> ''
						LEFT JOIN #Regidores C
							ON A.cPersCod = C.cPersCod
						LEFT JOIN #Total D
							ON D.CodEmpleado = A.cPersCod
							   AND D.CodPariente = B.cPersRelacPersCod
					WHERE left(A.crhcod, 1) in ( 'E', 'D' )
						  and A.nrhestado = 201
						  and DATEDIFF(DAY, GETDATE(), A.dIngreso) <= 0
						  AND C.cPersCod IS NULL
						  AND D.CodEmpleado IS NULL

					--INSERTANDO RELACION DE FAMILIARES DE TRABAJADORES(Tipo 2: Familiar de Trabajador)          
					/*Insert Into #Total (CodEmpleado, CodPariente, nTipo)          
			  SELECT DISTINCT A.cperscod CodEmpleado,          
				B.cPersCod CodPariente,          
				2           
			  FROM RRHH A with(nolock)          
			   INNER JOIN PersRelaciones B  with(nolock)          
				ON A.cPersCod = B.cPersRelacPersCod           
				AND B.nPersRelac IN (0, 1, 2, 3, 4, 11, 12, 15, 16, 17, 19, 20, 21, 22, 24, 28, 29, 30, 31)           
				AND ISNULL(B.cPersRelacPersCod, '') <> ''          
				AND ISNULL(B.cPersCod, '') <> ''          
			   LEFT JOIN #Regidores C          
				ON A.cPersCod = C.cPersCod           
			   LEFT JOIN #Total D          
				 ON D.CodEmpleado = A.cPersCod          
				 AND D.CodPariente = B.cPersCod          
			  WHERE left(A.crhcod,1) in ('E','D')           
				and A.nrhestado=201          
				and DATEDIFF(DAY, GETDATE() , A.dIngreso)<=0            
				AND C.cPersCod IS NULL          
				AND D.CodEmpleado IS NULL          
				  */
					-- alineando a PA_Consulta_LimiteGlobal 2024-10-01

					-- alineando a PA_Consulta_LimiteGlobal 2024-10-01
					SELECT 'Ad. Extraordinario' AS 'cctacod',
						   C.cPersCod as CodEmpleado,
						   B.CodEmpleado as CodPariente,
						   null as 'nprdestado',
						   C.nMontoSaldo as nMontoSaldo
					INTO #TBL_AdelantoSueldo
					FROM RRHH.RHConceptosPeriodicos C with (nolock)
						LEFT JOIN Persona A with (nolock)
							ON A.cPersCod = C.cPersCod
						INNER JOIN #Total B
							ON A.cPersCod = B.CodPariente
					WHERE C.nEstado <> 1

					--SELECCION DEL TIPO DE CAMBIO            
					DECLARE @Tc MONEY;
					SELECT TOP 1
						@Tc = nvalfijo
					FROM tipocambio
					ORDER BY dfeccamb DESC;

					--verificando la moneda del monto solicitado          
					IF @nMoneda = '2'
					BEGIN
						SET @nmonto = ROUND(@nmonto * @Tc, 2);
					END;


					--Hallando saldo capital total para cada Trabajador - Director          
					SELECT R.Codempleado,
						   R.Saldo
					INTO #FinalMontos
					FROM
					(
						SELECT T.Codempleado,
							   Saldo = SUM(T.SaldoTC)
						FROM
						(
							SELECT DISTINCT
								p.cctacod,
								T.Codempleado,
								t.CodPariente,
								p.nprdestado,
								SaldoTC = CASE
											  WHEN SUBSTRING(p.cctacod, 9, 1) = '1' THEN
												  p.nsaldo
											  ELSE
												  p.nsaldo * @Tc
										  END
							FROM Producto p WITH (NOLOCK)
								INNER JOIN
								(
									SELECT MAX(cperscod) cperscod,
										   cctacod
									FROM productopersona WITH (NOLOCK)
									WHERE nprdpersrelac = 20
									GROUP BY cctacod
								) pp
									ON pp.cctacod = p.cctacod
								INNER JOIN #Total t
									ON t.CodPariente = pp.cperscod
							WHERE p.nprdestado IN ( 2020, 2021, 2022, 2030, 2031, 2032, 2201, 2205, 2101, 2104, 2106, 2107 )
								  AND SUBSTRING(p.cctacod, 6, 3) NOT IN ( '121', '221' )
								  AND NOT EXISTS
									(
										SELECT cctacod
										FROM colocaccred WITH (NOLOCK)
										WHERE cctacod = p.cctacod
											  AND crfa IN ( 'rfa', 'vch' )
									)
							/*UNION          
				 SELECT DISTINCT          
				   p.cctacod,          
				   T.Codempleado,          
				   t.CodPariente,          
				   p.nprdestado,          
				   SaldoTC = CASE          
				 WHEN SUBSTRING(p.cctacod, 9, 1) = '1'          
						THEN ce.nmonto          
						ELSE ce.nmonto * @Tc          
					   END          
				 FROM Producto p WITH (NOLOCK)          
				   INNER JOIN          
				 (          
				   SELECT MAX(cperscod) cperscod,          
					 cctacod          
				   FROM productopersona      WITH (NOLOCK)          
				   WHERE nprdpersrelac = 20          
				   GROUP BY cctacod          
				 ) pp ON pp.cctacod = p.cctacod          
				   INNER JOIN #Total t ON t.CodPariente = pp.cperscod          
				   INNER JOIN colocacestado ce WITH (NOLOCK) ON p.cctacod = ce.cctacod          
							  AND ce.nprdestado = 2002          
				 WHERE p.nprdestado = 2002          
				   AND SUBSTRING(p.cctacod, 6, 3) NOT IN('121', '221')          
				   AND NOT EXISTS          
				 (          
				   SELECT cctacod          
				   FROM colocaccred with (nolock)         
				   WHERE cctacod = p.cctacod          
					AND crfa IN('rfa', 'vch')          
				 )*/
							-- alineando a PA_Consulta_LimiteGlobal 2024-10-01     
							union -- SE AGREGA ADELANTO DE SUELDO.
							select cctacod,
								   CodEmpleado,
								   CodPariente,
								   nprdestado,
								   SUM(nMontoSaldo)
							from #TBL_AdelantoSueldo
							group by cctacod,
									 CodEmpleado,
									 CodPariente,
									 nprdestado
						) T
						GROUP BY T.Codempleado
					) R
					ORDER BY R.Saldo DESC;

					DROP TABLE #TBL_AdelantoSueldo

					-------------Declarando Variables          
					DECLARE @LimGlo DECIMAL(6, 4); --% limite Global          
					DECLARE @LimInd DECIMAL(6, 4); --%limite individual          
					DECLARE @patrimonio MONEY;
					DECLARE @saldoInd MONEY; --saldo capital colocado individual          
					DECLARE @saldoGlo MONEY; --saldo capital colocado global          
					DECLARE @ValorInd DECIMAL(18, 2); --monto de limite individual respecto del patrimonio          
					DECLARE @ValorLimiteGlo DECIMAL(18, 2); --monto de limite global respecto del patrimonio             
					DECLARE @SaldoCapitalTotal DECIMAL(18, 2); -- monto total de capital colocado (saldo capital global mas monto de credio a desembolsar)                
					DECLARE @nUmbral DECIMAL(6, 4); --% de umbral para envio de alertas por correo.          
					DECLARE @ValorUmbral DECIMAL(18, 2); --monto de umbral para alertas respecto del patrimonio          
					DECLARE @bIndBLoqueo BIT; --LFAM 27/08/2014 se agrega indicador de bloqueo para cuando gerencia decida bloquear el otorgamiento de creditos a trabajadores.          
					DECLARE @nDisponibleGlobal DECIMAL(18, 2); --LFAM 08/09/2014 Monto disponible para prestamo.           
					--LFAM 12/06/2013 --Validacion para creditos ampliados y refinanciados,           
					--hallando el monto a cancelar del credito ampliado a refinanciado          
					DECLARE @nMontoCredAmp MONEY,
							@nMontoCredRef MONEY,
							@nMontoCancelar MONEY;
					SET @nMontoCredAmp = 0;
					SET @nMontoCredRef = 0;

					IF EXISTS (SELECT cctacodamp FROM ColocacAmpliado WHERE cCtaCod = @cCtaCod)
					BEGIN
						SELECT @nMontoCredAmp = SUM(nsaldo)
						FROM producto WITH (NOLOCK)
						WHERE cctacod IN (
											 SELECT cctacodamp
											 FROM ColocacAmpliado with (nolock)
											 WHERE cCtaCod = @cCtaCod
										 );
					END;

					IF EXISTS
					(
						SELECT cCtaCodRef
						FROM ColocacRefinanc with (nolock)
						WHERE cCtaCod = @cCtaCod
					)
					BEGIN
						SELECT @nMontoCredRef = SUM(nsaldo)
						FROM producto WITH (NOLOCK)
						WHERE cctacod IN (
											 SELECT DISTINCT
												 cctacodref
											 FROM ColocacRefinanc with (nolock)
											 WHERE cCtaCod = @cCtaCod
										 );
					END;
					SET @nMontoCancelar = @nMontoCredAmp + @nMontoCredRef;
					----------------------          

					SET @nRet = 0;

					--hallando % de limites individual y global para prestamos a trabajadores y sus familiares          
					SELECT @LimGlo = nLimGlo,
						   @LimInd = nLimInd,
						   @nUmbral = nUmbral,
						   @bIndBLoqueo = bIndBloqueo
					FROM LimiteGlobInd
					WHERE cvigencia = '1';

					--Hallando Patrimonio          
					SELECT TOP 1
						@patrimonio = isnull(patrimonio_mes, 0) - isnull(reserva_facult, 0) --LFAM 03/05/2014          
					FROM colocreporte13info
					WHERE cVigencia = 1
					ORDER BY cperiodo DESC;

					--Hallando Limite Individual           
					IF EXISTS (SELECT * FROM #FinalMontos WHERE Codempleado = @CodEmpleado)
					BEGIN
						SELECT @saldoind = saldo
						FROM #FinalMontos
						WHERE Codempleado = @CodEmpleado; --@cperscod          

						SET @ValorInd = ROUND(@patrimonio * @LimInd, 2);
						IF @ValorInd < (@saldoind + @nMonto - @nMontoCancelar)
						BEGIN
							SET @nRet = 1;
						END;
					END;
					ELSE
						SET @nRet = 0;

					--Hallando Limite Global           
					SELECT @saldoGlo = SUM(saldo)
					FROM #FinalMontos;

					SET @ValorLimiteGlo = ROUND(@patrimonio * @LimGlo, 2);
					SET @saldoGlo
						= @saldoGlo + ISNULL(@nMontoInflar, 0) + ISNULL(@nMontoCreditoEnlinea, 0)
						  + ISNULL(@nMontoReservadoConsumo, 0) + ISNULL(@nMontoReservadoRH, 0)
					SET @SaldoCapitalTotal = @saldoGlo + @nMonto - @nMontoCancelar;
					--LFAM 08/09/14 Hallando disponible           
					SET @nDisponibleGlobal = @ValorLimiteGlo - @saldoGlo;
					
					IF @ValorLimiteGlo < @SaldoCapitalTotal
					BEGIN
						SET @nRet = 2;
					END;

					--LFAM 27/08/2014 se agrega indicador de bloqueo para cuando gerencia decida bloquear el otorgamiento de creditos a trabajadores.              
					IF isnull(@bIndBLoqueo, 0) = 1
					BEGIN
						SET @nRet = 3;
					END;

					BEGIN
						IF @nRet = 1
							SET @cMsjLimGloIndCredDirTra
								= 'La Operación excede el Límite Indivual para prestamos a directores, trabajadores y sus familiares';
						IF @nRet = 2
							IF @nDisponibleGlobal > 0
							BEGIN
								SET @cMsjLimGloIndCredDirTra
									= 'La Operación excede el Límite Global para prestamos a directores, trabajadores y sus familiares, el saldo disponible es: S/. '
									  + STR(@nDisponibleGlobal, 11, 2);
							END;
							ELSE
							BEGIN
								SET @cMsjLimGloIndCredDirTra
									= 'La Operación excede el Límite Global para prestamos a directores, trabajadores y sus familiares, el saldo disponible es: S/. 0.00';
							END;
						IF @nRet = 3
							SET @cMsjLimGloIndCredDirTra
								= 'Los prestamos a directores, trabajadores y sus familiares, se encuentran bloqueados por orden de Gerencia';
					END;

					DROP TABLE #Regidores,
							   #Total
				END --LFAM 22-08-2018 FIN CONDICION DE RESTRICCION POR PRODUCTO          
			END

			UPDATE A
			SET A.cValorCalculado = ISNULL(@nRet, 0)
			FROM #DatosEntradaUnPivot A
			WHERE nIdVariable = 129

		END         
    END          
          
    BEGIN -- [nIdVariable = (131)]          
       IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =131)          
             BEGIN          
          
                    UPDATE A          
                    SET A.cValorCalculado = (SELECT COUNT(1)          
                                                          FROM Producto a  WITH (NOLOCK)          
                                 INNER JOIN ProductoPersona b WITH (NOLOCK)          
                                                               ON a.cCtaCod=b.cCtaCod            
                                                          WHERE a.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2101,2104,2106,2107,2201,2205)           
                                                                AND  dbo.FN_GetcCredProducto(A.cCtaCod)='204'          
                                                                AND NOT EXISTS (SELECT cCtaCod FROM ColocacCred WITH (NOLOCK) WHERE cCtaCod=a.cCtaCod AND cRFA IN ('rfa','vch'))            
                                                                AND b.cPersCod = @cPersCodTitular            
                                                                AND b.nPrdPersRelac = 20  )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =131          
             END          
      END          
             
    BEGIN -- [nIdVariable = (132)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =132)          
             BEGIN          
                    DECLARE @cCtaCodAmpp          VARCHAR(18)          
                ,@nMontoColAMP      DECIMAL(18,2)          
                               ,@nLimitMontoAmp    DECIMAL(18,2)          
          
    SELECT P.cCtaCod,          
                           round((case when substring(p.cctacod,9,1) = '2' then C.nMontoCol * @tipoCambio else C.nMontoCol End),2) nMontoCol,          
                           P.nPrdEstado,          
                           C.dVigencia,          
                           C.dVenc          
                    INTO #TBCredMaxHist          
                    FROM Producto P  WITH (NOLOCK)        
           INNER JOIN ProductoPersona PP WITH (NOLOCK) ON PP.cCtaCod=P.cCtaCod AND PP.nPrdPersRelac=20          
      INNER JOIN ColocacEstado CE WITH (NOLOCK) ON P.cCtaCod = CE.cCtaCod AND CE.nPrdEstado = 2002          
                           INNER JOIN Colocaciones C WITH (NOLOCK) ON P.cCtaCod = C.cCtaCod          
                    WHERE PP.cPersCod = @cPersCodTitular          
                    AND (P.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2050))          
                    and SUBSTRING(P.cCtaCod,6,3) NOT IN ('302','216', '301', '306', '305')          
          
                    SELECT @cCtaCodAmpp=A.cCtaCod           
         FROM #CreditosProcesar A          
                    INNER JOIN COLOCACIONES B with(nolock)         
                          ON A.cCtaCod=B.cCtaCod          
                    ORDER BY dVigencia DESC          
          
          
                    IF SUBSTRING(@cCtaCodAmpp,6,1) = '1' or substring(@cCtaCodAmpp,6,1) = '2'          
          BEGIN           
                                     Select top 1 @nMontoColAMP = nMontoCol          
                                   From #TBCredMaxHist            
                                     where substring(cCtaCod,6,1) in (1,2)            
                                     order by nMontoCol desc          
                               END          
          
                    IF SUBSTRING(@cCtaCodAmpp,6,1) = '3' or substring(@cCtaCodAmpp,6,1) = '4'          
                           BEGIN           
                               Select top 1 @nMontoColAMP = nMontoCol          
  From #TBCredMaxHist            
                   where substring(cCtaCod,6,1) = substring(@cCtaCodAmpp,6,1)           
                               order by nMontoCol desc          
                           END          
          
                    SET @nLimitMontoAmp=      ROUND(ISNULL(@nMontoColAMP,0) + ISNULL(@nMontoColAMP,0) * (CASE WHEN @cCalifClient IN ('AAA','AA') THEN 1.0          
   WHEN @cCalifClient IN ('A','B') THEN 0.75          
                  WHEN @cCalifClient IN ('C') THEN 0.50          
                                                                      END) ,2)          
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@nLimitMontoAmp,0)          
               FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =132          
          
                    DROP TABLE #TBCredMaxHist          
            END          
       END          
          
    BEGIN -- [nIdVariable = (134,135,136,137,138,139,140,141,143,144,145,148,149)]           
  IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (134,135,136,137,138,139,140,142,143,144,145,148,149))          
  BEGIN    
                       
  declare @cDescripcion varchar(80)          
  declare @nMontoEvaInicio money, @nMontoEvaFin money, @nMontoEvaInicioTCF money, @nMontoEvaFinTCF money           
  declare @nPlazoIni int, @nPlazoFin int, @nNumCuotasIni int, @nNumCuotasFin int, @nGraciaIni int, @nGraciaFin int, @cMoneda int           
  declare @nPlazoIniDestino int, @nPlazoFinDestino int , @ncodproy int           
  declare @nPatEfe money          
  DECLARE @montodispAsoci as money          
  declare @dPatEfe varchar(6)          
  declare @bEsRef int          
  declare @nMontoMaxCredisueldo money          
  declare @ntiposector int          
  declare @ntotalcred int          
  Declare @cperscod varchar(13)          
  declare @nNuevoPlazo Int          
  DECLARE @nCondicionConfig  INT          
          
  -- para entidades publicas y privadas.           
  set @nTipoSector=1          
  set @nMontoMaxCredisueldo=0          
  IF @cCredProducto ='301'          
  BEGIN               
   SELECT @nTipoSector=nTipoSector          FROM PersTpo with(nolock)  where cPersCod = @cPersCodConvenio and nPersTipo = 1          
   SELECT @nMontoMaxCredisueldo=nValFin FROM ColDDesMonPro with(nolock)  where nCodTipVal=3 and ncredproducto=301 and ncodvalida=@ntiposector and ncodmoneda=1          
  END          
          
  SELECT    
   @cDescripcion = cDescripcion,          
    
   @nMontoEvaInicio = nMontoEvaInicio, @nMontoEvaFin = nMontoEvaFin, @nMontoEvaInicioTCF = nMontoEvaInicioTCF, @nMontoEvaFinTCF = nMontoEvaFinTCF,          
   @nPlazoIni = nPlazoIni, @nPlazoFin = nPlazoFin, @nNumCuotasIni = nNumCuotasIni, @nNumCuotasFin = nNumCuotasFin,          
   @nGraciaIni = nGraciaIni, @nGraciaFin = nGraciaFin, @cMoneda = cMoneda         
  FROM CredProductos where cCredProductos = @cCredProducto          
                
  IF(@cCredProducto = 201 and @nCodDestino = 2)    
  BEGIN    
   IF(@nSubDestinosId in (1))    
   BEGIN    
    SELECT             
     @nGraciaIni = ISNULL(0, 0),            
     @nGraciaFin = ISNULL(360, 0)            
    FROM TipoCredProductosDest             
    WHERE cCredProductos = @cCredProducto            
    AND nCodDestino = 2 --@nCodDestino    
   END    
    
   IF(@nSubDestinosId in (2,3,4,5,6))    
   BEGIN    
    SELECT             
     @nGraciaIni = ISNULL(0, 0),            
     @nGraciaFin = ISNULL(90, 0)            
    FROM TipoCredProductosDest             
    WHERE cCredProductos = @cCredProducto            
    AND nCodDestino = 2 --@nCodDestino     
   END    
  END    
  ELSE    
  BEGIN    
   SELECT           
    @nGraciaIni = ISNULL(nGraciaIni, 0),          
    @nGraciaFin = ISNULL(nGraciaFin, 0)          
   FROM TipoCredProductosDest           
   WHERE cCredProductos = @cCredProducto          
    AND nCodDestino = @nCodDestino     
  END    
          
  SET @nGraciaIni = COALESCE(@nGraciaIni, 0)          
  SET @nGraciaFin = COALESCE(@nGraciaFin, 0)    
          
          
  if @cCredProducto = '207'          
  BEGIN          
   SELECT @bEsRef = CASE WHEN  @nColocCondicion2=8 THEN 1 ELSE 0 END           
   SET @bEsRef = coalesce(@bEsRef, 0)          
   IF @bEsRef > 0          
   BEGIN          
    set @nGraciaIni = 0          
   END          
  END          
          
  IF @cCredProducto = '901'--VALIDA MONTO MAXIMO A INSTITUCIONES FINANCIERAS          
  BEGIN          
   set @dPatEfe = substring(replace(CONVERT(varchar, CONVERT(date, @dFechaActual, 112)), '-', ''), 1, 6)          
   SELECT TOP 1 @nPatEfe = patrimonio_mes from ColocReporte13Info with(nolock)  where cPeriodo <> @dPatEfe ORDER BY cPeriodo DESC          
   set @nMontoEvaInicio = 0          
   set @nMontoEvaFin = 0.05 * @nPatEfe          
   set @nMontoEvaInicioTCF = 0          
   set @nMontoEvaFinTCF = 0.05 * @nPatEfe / @tipoCambio          
  END          
                          
                          
  -- ===== PRODUCTO (JORNALITO - FACILITO)  =======          
  IF @cCredProducto = '321'              
  BEGIN    
   DECLARE @nValoresJF NVARCHAR(20)          
   CREATE TABLE #montoCredito          
   (          
    nId       INT IDENTITY(1,1),          
    nMonto    NVARCHAR(10)          
   );          
                       
                       
   SELECT @nValoresJF=nConsSisValor FROM ConstSistema WHERE nConsSisCod=5072          
   INSERT INTO #montoCredito(nMonto) SELECT ITEMS FROM dbo.fn_Split(@nValoresJF,',')          
                                    
                       
   --VERIFICANDO SI ES NUEVO O RECURRENTE          
   IF  (@bRecurrente=0)          
   BEGIN    
    SELECT @nMontoEvaFin= CONVERT(money,nmonto) FROM #montoCredito WHERE nId=1 -- 1 :NUEVO , 2:RECURRENTE, 3:RECURRENTE CON CASA PROPIA          
    SELECT @nPlazoFin=CONVERT(INT,nConsSisValor) FROM ConstSistema WHERE nConsSisCod=5073          
   END          
   ELSE          
   BEGIN    
                  
    IF EXISTS(SELECT PD.cCondicion FROM PERSONA P  with(nolock)        
       LEFT JOIN PersonaDomicilio PD  with(nolock)         
        ON P.cPersCod=PD.cPersCod      
       WHERE    
        (P.cPersCod=@cPersCodTitular AND PD.cCondicion=1)    
        OR (P.cPersCod IN (SELECT cPersCod FROM #PersonaRelacionCred WHERE  nPersRelac=25) AND PD.cCondicion=1))          
    BEGIN          
     SELECT @nMontoEvaFin=CONVERT(money,nmonto) FROM #montoCredito WHERE nId=3          
    END          
    ELSE          
    BEGIN          
     SELECT @nMontoEvaFin=CONVERT(money,nmonto) FROM #montoCredito WHERE nId=2          
    END          
                                     
    SELECT @nPlazoFin=CONVERT(INT,nConsSisValor) FROM ConstSistema with(nolock)  WHERE nConsSisCod=5074          
  END    
   DROP TABLE #montoCredito          
  END    
                         
  IF (@cCredProducto = 201 and @nCodDestino = 2)    
  BEGIN    
   IF(@nSubDestinosId in (1))    
   BEGIN    
    SELECT @nPlazoIniDestino = coalesce(0, 0), @nPlazoFinDestino = coalesce(2928, 0) from TipoCredProductosDest            
    WHERE cCredProductos = @cCredProducto and nCodDestino = 2 --@nCodDestino    
   END    
                             
   IF(@nSubDestinosId in (2,3,4,5,6))    
   BEGIN    
    SELECT @nPlazoIniDestino = coalesce(30, 0), @nPlazoFinDestino = coalesce(1830, 0) from TipoCredProductosDest            
    WHERE cCredProductos = @cCredProducto and nCodDestino = 2 --@nCodDestino     
   END    
  END    
  ELSE    
  BEGIN    
   SELECT @nPlazoIniDestino = coalesce(nPlazoIni, 0), @nPlazoFinDestino = coalesce(nPlazoFin, 0) from TipoCredProductosDest          
   WHERE cCredProductos = @cCredProducto and nCodDestino = @nCodDestino          
  END    
              
  SET @nPlazoIniDestino = coalesce(@nPlazoIniDestino, 0)          
  SET @nPlazoFinDestino = coalesce(@nPlazoFinDestino, 0)          
                       
               
  IF @nColocCondicion > 1          
  BEGIN          
   SET @nCondicionConfig=2          
  END          
                 
  SELECT @nNuevoPlazo=max(O.nPlazoFin)          
  FROM PromocionCreditoOferta O  with(nolock)           
   inner join PromocionCredito P  with(nolock)         
    on O.nPromocionCred=P.nPromoCred          
  WHERE P.IdCampana=@nIdCampana And @nCodDestino in(select items from dbo.fn_Split(sDestinos,','))           
          
  SET @nNuevoPlazo=coalesce(@nNuevoPlazo,0)          
              
  IF @nNuevoPlazo > 0 And @nCodDestino=1          
  BEGIN         
   Set @nPlazoFinDestino=@nNuevoPlazo          
  End                      
          
  IF @cCredProducto='212'          
  BEGIN          
   set @ntotalcred= dbo.Get_CondicionMe(@cPersCodTitular)          
   if  @ntotalcred = 0          
   begin          
    set @nColocCondicion =1          
   end          
  END           
                 
  If EXISTS(Select nCredProducto  from ColDDesMonPro WITH (NOLOCK) where nCredProducto=@cCredProducto and nCodTipVal=1)          
  begin          
   Select          
    @nPlazoIniDestino=CDmp.nValIni,          
    @nPlazoFinDestino=CDmp.nValFin          
   From ColDDesMonPro CDmp   WITH (NOLOCK)          
    Inner join ColMDesMonPro CMmo WITH (NOLOCK)          
     ON CDmp.nCodTipVal=CMmo.nCodTipVal          
   Where CMmo.nCodTipVal=1 and nCodMoneda=(Case when bIndAplMon=1 then @nMoneda else nCodMoneda End)          
    and nCodValida =@nCodDestino    
  end    
          
  If EXISTS(Select nCredProducto  from ColDDesMonPro WITH(NOLOCK) where nCredProducto=@cCredProducto and nCodTipVal=2)          
  begin           
   Select           
    @nMontoEvaInicio=CDmp.nValIni,          
    @nMontoEvaFin=CDmp.nValFin          
   From ColDDesMonPro CDmp   WITH (NOLOCK)          
    Inner join ColMDesMonPro CMmo WITH (NOLOCK)          
     ON CDmp.nCodTipVal=CMmo.nCodTipVal          
   Where CMmo.nCodTipVal=2 and nCodMoneda=(Case when bIndAplMon=1 then @nMoneda else nCodMoneda End)          
    and nCodValida=@nColocCondicion          
  end          
                 
  If EXISTS(Select nCredProducto  from ColDDesMonPro with(nolock)  where nCredProducto=@cCredProducto and nCodTipVal=4)          
  begin          
   Select          
    @nMontoEvaInicio=ISNULL((CASE WHEN bIndAplMon=1 THEN (CASE @nMoneda WHEN 1 THEN CDmp.nValIni END) END),0),           
    @nMontoEvaFin= ISNULL((CASE WHEN bIndAplMon=1 THEN (CASE @nMoneda WHEN 1 THEN  CDmp.nValFin END) END) ,0),          
    @nMontoEvaInicioTCF=ISNULL((CASE WHEN bIndAplMon=1 THEN (CASE @nMoneda WHEN 2 THEN  CDmp.nValIni END)END),0),          
    @nMontoEvaFinTCF=ISNULL((CASE WHEN bIndAplMon=1 THEN (CASE @nMoneda WHEN 2 THEN  CDmp.nValFin END)END),0)          
   From ColDDesMonPro CDmp   WITH (NOLOCK)          
     Inner join ColMDesMonPro CMmo WITH (NOLOCK)          
     ON CDmp.nCodTipVal=CMmo.nCodTipVal          
   Where CMmo.nCodTipVal=4 and nCodMoneda=(Case when bIndAplMon=1 then @nMoneda else nCodMoneda End)          
  end          
          
                          
  --Alineamiento Asociaciones Grupos          
  IF @cCredProducto ='208'          
  BEGIN                             
   set @montodispAsoci = (SELECT DBO.GetponibleSaldoProy(@nCodProyAsoc,@nMoneda,@tipoCambio) Monto )          
               
   IF @nMoneda =1          
   BEGIN set @nMontoEvaFin =@montodispAsoci END          
   ELSE          
   BEGIN set @nMontoEvaFinTCF=@montodispAsoci  END          
  END          
  --Asociaciones o Grupos          
          
          
  DECLARE @nTipoColateral INT       
  DECLARE @nPlazoCampaña INT          
  DECLARE @nMontoIniCamp MONEY          
  DECLARE @nMontoFinCamp MONEY          
  DECLARE @nMontoIniDolCamp MONEY          
  DECLARE @nMontoFinDolCamp MONEY          
                
  SELECT  @nTipoColateral = A.nTipoColateralID           
  FROM Garantias A          
   INNER JOIN #GarantiaCredito b          
    ON cNumGarant=b.nNumGarant          
  ORDER BY B.nGravado          
          
          
              
  SELECT    
   @nPlazoCampaña=nPlazoMax,@nMontoIniCamp=nMontoMin,          
   @nMontoFinCamp=nMontoMax,@nMontoIniDolCamp=nMontoMinDol,          
   @nMontoFinDolCamp=nMontoMaxDol          
  FROM CampanasDetalle CA WITH (NOLOCK)          
  WHERE IdCampana=@nIdCampana           
   AND @cCredProducto IN(Select Items From dbo.fn_Split(cProductos,','))          
   AND (nCondicion =@nColocCondicion OR nCondicion IS NULL)          
   AND (@nTipoColateral IN(Select Items From dbo.fn_Split(cTipoColaterales,',')) OR cTipoColaterales Is NULL)          
                 
  SET @nPlazoCampaña=COALESCE(@nPlazoCampaña,0)          
  SET @nMontoIniCamp=COALESCE(@nMontoIniCamp,0)          
  SET @nMontoFinCamp=COALESCE(@nMontoFinCamp,0)          
  SET @nMontoIniDolCamp=COALESCE(@nMontoIniDolCamp,0)          
  SET @nMontoFinDolCamp=COALESCE(@nMontoFinDolCamp,0)          
                 
  SET @nPlazoFinDestino= (CASE WHEN ISNULL(@nPlazoCampaña,0)>@nPlazoFinDestino AND ISNULL(@nPlazoCampaña,0)>0 THEN @nPlazoCampaña ELSE @nPlazoFinDestino END  )          
  SET @nMontoEvaInicio=(CASE WHEN  ISNULL(@nMontoIniCamp,0)<ISNULL(@nMontoEvaInicio,0) AND ISNULL(@nMontoIniCamp,0)>0 THEN  ISNULL(@nMontoIniCamp,0) ELSE ISNULL(@nMontoEvaInicio,0) END)          
  SET @nMontoEvaFin=(CASE WHEN ISNULL(@nMontoFinCamp,0)> @nMontoEvaFin AND ISNULL(@nMontoFinCamp,0)>0 THEN  ISNULL(@nMontoFinCamp,0) ELSE @nMontoEvaFin END)          
  SET @nMontoEvaInicioTCF=(CASE WHEN ISNULL(@nMontoIniDolCamp,0)<@nMontoEvaInicioTCF  AND ISNULL(@nMontoIniDolCamp,0)>0 THEN  ISNULL(@nMontoIniDolCamp,0) ELSE @nMontoEvaInicioTCF END)          
  SET @nMontoEvaFinTCF=(CASE WHEN ISNULL(@nMontoFinDolCamp,0)>@nMontoEvaFinTCF AND  ISNULL(@nMontoFinDolCamp,0)>0 THEN ISNULL(@nMontoFinDolCamp,0) ELSE @nMontoEvaFinTCF END )          
  SET @nPlazoFin=(CASE WHEN ISNULL(@nPlazoCampaña,0)>0  THEN @nPlazoCampaña ELSE @nPlazoFin END  )          
          
  IF @nIdCampana = 123 and @cCredProducto in ('204','311') and @nColocCondicion <> 1 and @nColocCondicion2 = 0 and @nMonto between 5000.01 and 10000.00          
  BEGIN          
   if (SELECT COUNT(1) FROM ProductoPersona a WITH (NOLOCK)     
     inner join Producto b WITH (NOLOCK) on a.cCtaCod=b.cCtaCod     
     where cPersCod = @cPersCodTitular and a.nPrdPersRelac = 20 and b.nPrdEstado in (2020,2021,2022,2030,2031,2032,2201,2202,2205,2206)) > 0          
   BEGIN          
    SET @nMontoEvaFin=@nMonto+1          
   END          
  END    
      
  IF @nIdCampana IN (191,195)    
  BEGIN    
   IF @cCredProducto = '201'    
   BEGIN    
    SET @nMontoEvaInicio = 300    
    SET @nMontoEvaFin = 40000    
   END    
    
   IF @cCredProducto = '204'    
   BEGIN    
    SET @nMontoEvaInicio = 0    
    SET @nMontoEvaFin = 15000    
   END    
  END    
          
  UPDATE A          
  SET A.cValorCalculado = (CASE WHEN @nMoneda=1 THEN @nMontoEvaInicio ELSE @nMontoEvaInicioTCF END)          
  FROM #DatosEntradaUnPivot A          
  WHERE nIdVariable = 134          
          
  UPDATE A          
  SET A.cValorCalculado = (CASE WHEN @nMoneda=1 THEN @nMontoEvaFin ELSE @nMontoEvaFinTCF END)          
  FROM #DatosEntradaUnPivot A          
  WHERE nIdVariable = 135          
          
          
  UPDATE A          
   SET A.cValorCalculado = (CASE WHEN nIdVariable=136 THEN @nPlazoIni           
          WHEN nIdVariable=137 THEN (CASE WHEN ISNULL(@nPlazoFin,0)=0 THEN @nPlazo+1 ELSE @nPlazoFin END)          
          WHEN nIdVariable=138 THEN @nNumCuotasIni          
          WHEN nIdVariable=139 THEN (CASE WHEN ISNULL(@nNumCuotasFin,0)=0 THEN @nCuotas+1 ELSE @nNumCuotasFin END)          
          WHEN nIdVariable=140 THEN (CASE WHEN @cMoneda=3 THEN @nMoneda ELSE @cMoneda END)          
          WHEN nIdVariable=142 THEN @nGraciaIni          
          WHEN nIdVariable=143 THEN (CASE WHEN ISNULL(@nGraciaFin,0)=0 THEN @nPlazoGracia+1 ELSE @nGraciaFin END)          
          WHEN nIdVariable=144 THEN ISNULL(@nTipoSector,0)          
          WHEN nIdVariable=148 THEN ISNULL(@nPlazoIniDestino,0)    
          WHEN nIdVariable=149 THEN (CASE WHEN ISNULL(@nPlazoFinDestino,0)=0 THEN @nPlazo+1 ELSE ISNULL(@nPlazoFinDestino,0) END)    
         END)          
  FROM #DatosEntradaUnPivot A          
  WHERE nIdVariable IN (136,137,138,139,140,142,143,144,148,149)          
                              
  UPDATE A          
  SET A.cValorCalculado = @nMontoMaxCredisueldo          
  FROM #DatosEntradaUnPivot A          
  WHERE nIdVariable = 145          
          
  END          
    END          
            
    BEGIN -- [nIdVariable = (146)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =146)          
             BEGIN          
                    DECLARE @bMinorista  BIT          
                    SET @bMinorista=0          
          
                    IF @nTipoCredito in (2,3,4,13) and @cCredProducto not in ('121','221','302','303','305','306','102','202')             
                    BEGIN          
                           SET @bMinorista=1          
                    END          
                
                     UPDATE A          
                    SET A.cValorCalculado = @bMinorista          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =146          
             END          
       END          
              
    BEGIN -- [nIdVariable = (147)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =147)          
         BEGIN          
                    --VALIDANDO COMPORTAMIENTO DE PAGO          
                    DECLARE @bComportamiento    BIT          
              
                    CREATE TABLE #THorizonte           
                    (          
                           cCtaCod  VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS,          
  nPrdEstado            INT,          
            nAtrasoPromedio         NUMERIC(10,2),          
                    nAtrasoMaximo           INT,          
                           nAtrasoUltimasCuotas    INT          
                    )          
                    CREATE TABLE #TDataTitular          
                    (          
                           cPersCod       VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS,          
                           cDOI           VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,          
                           nTipo    TINYINT,          
                           PRIMARY KEY (cPersCod, cDOI)          
                    );          
                              
                    CREATE TABLE #TFechasDOI          
                    (          
        cDOI      VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,          
                  dFecha  DATE,          
                           nTipo   TINYINT PRIMARY KEY (DFECHA,CDOI)          
                    );          
          
                    CREATE TABLE #TCalificacionExterna          
       (          	                      
                           Cod_Doc_Id   VARCHAR(11) COLLATE SQL_Latin1_General_CP1_CI_AS,          
                           Cod_Doc_Trib VARCHAR(11) COLLATE SQL_Latin1_General_CP1_CI_AS,          
                           dFecha       DATE,          
                           NCALIFSF            INT,          
               nCalif_0            DECIMAL(5, 2),          
                           nCalif_1            DECIMAL(5, 2),          
                 nCalif_2            DECIMAL(5, 2),          
     nCalif_3            DECIMAL(5, 2),          
                           nCalif_4            DECIMAL(5, 2)       
                    );          
          
                              
                    CREATE TABLE #TFechas(dFecha DATE PRIMARY KEY);          
          
                    DECLARE                                     
                           @dFechaIni          DATE = '',          
                           @nMesesCalifSBS     INT = 0          
                              
                    SET @dFechaIni = @dFechaRCC          
                    SET @nMesesCalifSBS = (SELECT nConsSisValor FROM ConstSistema with(nolock)  WHERE nConsSisCod = 2010)          
          
                    INSERT INTO #TDataTitular(cPersCod, cDOI, nTipo)          
                    SELECT B.cPersCod, B.cPersIDnro,           
                           CASE WHEN LEN(RTRIM(LTRIM(B.cPersIDnro))) > 8 THEN 2 ELSE 1 END          
                    FROM PersID B          
                    WHERE B.cPersCod = @cPersCodTitular            
                           AND B.cPersIDTpo = (          
                                  SELECT MIN(cpersidtpo)          
                                  FROM PersID  with(nolock)         
                                  WHERE cPersCod = B.cPersCod          
                                  )          
                              
                    WHILE DATEDIFF(MONTH, @dFechaIni, @dFechaRCC) <= (@nMesesCalifSBS - 1)          
                    BEGIN          
                           INSERT INTO #TFechas (dFecha)          
                           VALUES (@dFechaIni)          
          
                           SET @dFechaIni = DATEADD(ms, - 3, DATEADD(mm, DATEDIFF(mm, 0, @dFechaIni), 0))          
                    END              
          
          
                    INSERT INTO #TFechasDOI (cDOI, dFecha , nTipo)          
                    SELECT DISTINCT A.cDOI, B.dFecha, A.nTipo          
                    FROM #TDataTitular A          
               CROSS JOIN #TFechas B          
          
                    INSERT INTO #TCalificacionExterna (Cod_Doc_Trib, Cod_Doc_Id, dFecha, NCALIFSF, nCalif_0, nCalif_1, nCalif_2, nCalif_3, nCalif_4)          
                    SELECT           
                           Cod_Doc_Trib, Cod_Doc_Id, B.dFecha,            
                           CASE           
        WHEN A.Calif_4 > 0 THEN 4          
                                  WHEN A.Calif_3 > 0 THEN 3          
                                  WHEN A.Calif_2 > 0 THEN 2          
                 WHEN A.Calif_1 > 0 THEN 1          
       ELSE 0          
                           END,          
                           A.Calif_0, A.Calif_1, A.Calif_2, A.Calif_3, A.Calif_4          
                    FROM [DBRCC].DBO.RCCTOTAL A  WITH (NOLOCK)          
                           INNER JOIN #TFechasDOI B           
                                  ON A.FEC_REP = B.dFecha  AND A.Cod_Doc_Id = B.cDOI AND B.nTipo = 1          
          
                    INSERT INTO #TCalificacionExterna(Cod_Doc_Trib, Cod_Doc_Id, dFecha, NCALIFSF, nCalif_0, nCalif_1, nCalif_2, nCalif_3, nCalif_4)          
                    SELECT Cod_Doc_Trib, Cod_Doc_Id, B.dFecha,           
                           CASE           
                                  WHEN A.Calif_4 > 0 THEN 4          
                                  WHEN A.Calif_3 > 0 THEN 3          
                                  WHEN A.Calif_2 > 0 THEN 2          
                                  WHEN A.Calif_1 > 0 THEN 1          
                                  ELSE 0          
                           END,          
       A.Calif_0, A.Calif_1, A.Calif_2, A.Calif_3, A.Calif_4          
                    FROM [DBRCC].DBO.RCCTOTAL A  WITH (NOLOCK)          
  INNER JOIN #TFechasDOI B           
                                  ON A.Fec_Rep = B.dFecha AND A.Cod_Doc_Trib = B.CDOI AND B.nTipo = 2          
          
          
              IF (@nColocCondicion <> 1)          
                    BEGIN            
                           INSERT INTO #THorizonte(cCtaCod, nPrdEstado, nAtrasoPromedio, nAtrasoMaximo, nAtrasoUltimasCuotas)          
  EXEC COLOCACIONES.ComportamientoPago_sobreendeudamiento @cPersCodTitular, @cCredProducto, @nColocCondicion, @nColocCondicion2           
                    END          
                    SET @bComportamiento=0          
          
          
                    IF (@nColocCondicion = 1)          
                 BEGIN          
                           IF NOT EXISTS(SELECT 1 FROM #TCalificacionExterna WHERE NCALIFSF > 0)          
                                  BEGIN SET @bComportamiento=1 END  --aprueba          
                           ELSE          
                                  BEGIN SET @bComportamiento=0 END  --desaprueba          
                    END                    
                    ELSE           
                    BEGIN          
                           IF NOT EXISTS(SELECT 1 FROM #THorizonte )          
                                  BEGIN SET @bComportamiento=1 END --aprueba          
                           ELSE          
                                  BEGIN SET @bComportamiento=0 END          
                    END          
          
                    UPDATE A          
                    SET A.cValorCalculado = @bComportamiento          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =147          
          
                    DROP TABLE #THorizonte,#TDataTitular,#TFechas,#TFechasDOI,#TCalificacionExterna          
             END          
     END          
          
    BEGIN -- [nIdVariable = (150)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =150)          
        BEGIN    
            DECLARE @NESTAEXCEPTUADA        INT         
                    ,@NESTAEXCEPTUADAHIST   INT          
                    ,@bCalifExtEvalHorizon  INT          
          
            DECLARE @CALIFICACIONEXTERNA TABLE (
	cCodSBS VARCHAR(10),
    Cod_Doc_Id VARCHAR(11),          
    Cod_Doc_Trib VARCHAR(11),          
    dFecha DATE,          
    NCALIFSF INT,          
    nCalif_0 DECIMAL(5, 2),          
    nCalif_1 DECIMAL(5, 2),          
    nCalif_2 DECIMAL(5, 2),          
    nCalif_3 DECIMAL(5, 2),          
    nCalif_4 DECIMAL(5, 2)          
   )          
          
            DECLARE @RELACIONES TABLE (          
    cPersCod VARCHAR(13),          
    nPrdPersRelac INT,          
    cDOI VARCHAR(20),          
    ntipo TINYINT,          
    PRIMARY KEY (          
     cPersCod,          
      nPrdPersRelac,          
      cDOI          
      )          
   )          
          
            DECLARE @FECHAS TABLE (DFECHA DATE PRIMARY KEY)          
          
            CREATE TABLE #FECHASDOI (          
                CDOI VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,           
                DFECHA DATE,          
    ntipo TINYINT PRIMARY KEY (DFECHA,CDOI)          
            )          
          
          
            DECLARE @nMesesCalifRegla  INT          
                    ,@FechaRCCRegl     DATE          
     ,@DFechaIniRegl    DATE          
          
          
   SELECT @NESTAEXCEPTUADA = COUNT(1)          
            FROM REGVALIDACION WITH (NOLOCK)          
            WHERE CCTACOD = @CCTACOD          
    AND NCODALINEA = 27          
    AND NESTADOVALID = 3          
                                              
          
            SELECT @NESTAEXCEPTUADAHIST = COUNT(1)          
            FROM REGVALIDACIONEST   WITH (NOLOCK)          
            WHERE CCTACOD = @CCTACOD          
                    AND NCODALINEA = 27          
          
          
            INSERT INTO @RELACIONES (cPersCod,nPrdPersRelac,cDOI,ntipo)          
            SELECT a.cPersCod,          
                a.nPersRelac,          
    b.cPersIDnro,          
    CASE           
     WHEN len(b.cPersIDnro) > 8          
       THEN 2          
     ELSE 1          
                END          
   FROM #PersonaRelacionCred a          
    INNER JOIN PersID b WITH (NOLOCK)          
     ON a.cPersCod = b.cPersCod          
   WHERE  A.nPersRelac IN (20, 25, 21, 23, 22, 24)          
    AND b.cpersidtpo = (          
       SELECT min(cpersidtpo)          
       FROM PersID      WITH (NOLOCK)          
       WHERE cperscod = a.cperscod          
                            )          
                 
 IF @NESTAEXCEPTUADA > 0 OR @NESTAEXCEPTUADAHIST > 0          
            BEGIN           
    SET @bCalifExtEvalHorizon = 1           
            END    
    
   BEGIN -- Obtener número de meses a evaluar    
        
    DECLARE @nMesesCalifDefault INT = (SELECT CONVERT(INT, nConsSisValor) FROM ConstSistema with(nolock)   WHERE nConsSisCod = 425)    
    
    --para recurrentes evalua solo calif en el ultimo mes en el SF     
    IF @nColocCondicion IN (2,4)    
     SET @nMesesCalifRegla = 1    
    ELSE    
     SET @nMesesCalifRegla = @nMesesCalifDefault    
    
    -- Filtro admisión    
    DECLARE @dFechaFinFiltroAdmi DATE = (SELECT CONVERT(DATE, nConsSisValor) FROM ConstSistema with(nolock)  WHERE nConsSisCod = 469)    
        
    IF (@dFechaActual <= @dFechaFinFiltroAdmi AND @CCREDPRODUCTO NOT IN ('301') )    
    BEGIN    
     IF @nColocCondicion IN (2,4)    
      SET @nMesesCalifRegla = 3    
     ELSE    
      SET @nMesesCalifRegla = 12    
    END    
    
    -- Producto    
    IF @CCREDPRODUCTO IN ('320')     
    BEGIN    
     SET @nMesesCalifRegla = @nMesesCalifDefault    
    END    
    
    -- Campañas    
    
    IF @nIdCampana = 125 AND @nColocCondicion <> 1          
      AND (SELECT COUNT(1) FROM ProductoPersona a WITH (NOLOCK)          
       inner join Producto b WITH (NOLOCK)          
         ON a.cCtaCod=b.cCtaCod           
       WHERE cPersCod = @cPersCodTitular and a.nPrdPersRelac = 20           
            and ((b.nPrdEstado in (2020,2021,2022,2030,2031,2032,2201,2202,2205,2206)) or (b.nPrdEstado in (2050,2203,2204) and CAST(b.dPrdEstado AS DATE) > CAST(DATEADD(d,-30,GETDATE()) AS DATE) ))) > 0    
    BEGIN    
     SET @nMesesCalifRegla = 3          
    END          
          
    IF @nIdCampana IN (132,140,152,161,162, 185)          
    BEGIN    
     SET @nMesesCalifRegla = 1          
    END    
        
    -- Crédito en línea    
    IF @nEtapa = 15  AND ((  SELECT COUNT(cPersCod)          
           FROM RRHH          
           WHERE cPersCod = @cPersCodTitular AND LEFT(crhcod , 1) = 'E'           
           AND nRHEstado NOT LIKE '8%') > 0)          
    BEGIN          
     SET @nMesesCalifRegla = 6    
    END    
    
    IF @nIdCampana IN (191)--195    
    BEGIN    
     IF (@nColocCondicion = 1)    
      SET @nMesesCalifRegla = 12    
     ELSE    
      SET @nMesesCalifRegla = 6    
    END  
	
	IF @nIdCampana IN (195)--195    
    BEGIN    
      SET @nMesesCalifRegla = 6    
    END 
    
   END    
       
   IF @nMesesCalifRegla > 0          
            BEGIN    
    SELECT @FechaRCCRegl = CAST(NCONSSISVALOR AS DATE)          
    FROM CONSTSISTEMA  with(nolock)          
    WHERE NCONSSISCOD = 890          
          
    SET @DFechaIniRegl = @FechaRCCRegl          
          
    IF @nIdCampana IN (161)    
    BEGIN          
     INSERT INTO @FECHAS (DFECHA)          
     VALUES (CONVERT(DATE,'20200229'))          
    END          
    ELSE          
    BEGIN          
     WHILE DATEDIFF(MONTH, @DFechaIniRegl, @FechaRCCRegl) <= (@nMesesCalifRegla - 1)          
     BEGIN          
      INSERT INTO @FECHAS (DFECHA)          
      VALUES (@DFechaIniRegl)          
          
      SET @DFechaIniRegl = DATEADD(ms, - 3, DATEADD(mm, DATEDIFF(mm, 0, @DFechaIniRegl), 0))          
     END          
    END          
          
                INSERT INTO #FECHASDOI ( DFECHA,CDOI,NTIPO)          
                SELECT DISTINCT B.DFECHA, A.cDOI,A.ntipo          
                FROM @RELACIONES A          
                CROSS JOIN @FECHAS B          
          
    INSERT INTO @CALIFICACIONEXTERNA (Cod_Doc_Trib,Cod_Doc_Id,dFecha,NCALIFSF,nCalif_0,nCalif_1,nCalif_2,nCalif_3,nCalif_4)          
                SELECT Cod_Doc_Trib,          
     Cod_Doc_Id,          
     b.dFecha,              
                    CASE           
      WHEN A.Calif_4 > 0          
       THEN 4          
                        WHEN A.Calif_3 > 0          
                            THEN 3          
                        WHEN A.Calif_2 > 0          
       THEN 2          
                        WHEN A.Calif_1 > 0          
                            THEN 1          
      ELSE 0          
                    END,          
                    A.Calif_0,A.Calif_1,A.Calif_2,A.Calif_3,A.Calif_4          
                FROM [DBRCC].DBO.RCCTOTAL A  WITH (NOLOCK)          
                    INNER JOIN #FECHASDOI B ON A.FEC_REP = B.DFECHA          
      AND Cod_Doc_Id = B.CDOI          
      AND ntipo = 1          
                WHERE LTRIM(RTRIM(B.CDOI)) <> ''          
          
                INSERT INTO @CALIFICACIONEXTERNA (Cod_Doc_Trib,Cod_Doc_Id,dFecha,NCALIFSF,nCalif_0,nCalif_1,nCalif_2,nCalif_3,nCalif_4)          
                SELECT Cod_Doc_Trib,Cod_Doc_Id,b.dFecha,               
     CASE           
      WHEN A.Calif_4 > 0          
        THEN 4          
      WHEN A.Calif_3 > 0          
        THEN 3          
      WHEN A.Calif_2 > 0          
        THEN 2          
                        WHEN A.Calif_1 > 0          
                                    THEN 1          
                        ELSE 0          
                    END,         
                    A.Calif_0,          
     A.Calif_1,          
                    A.Calif_2,          
     A.Calif_3,          
                    A.Calif_4          
                FROM [DBRCC].DBO.RCCTOTAL A  WITH (NOLOCK)          
     INNER JOIN #FECHASDOI B ON A.FEC_REP = B.DFECHA          
      AND Cod_Doc_Trib = B.CDOI          
      AND ntipo = 2          
                WHERE LTRIM(RTRIM(B.CDOI)) <> ''          
             
   END        
   
   BEGIN  -- REGLAS DE CAMPAÑA 
      CREATE TABLE #CampanaRCC_CPP (            
            cCodSBS VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS,     
            dFecha DATE,
            nCalifSBS INT,
		    nMontoMM MONEY, -- Membresía en tarjetas de crédito y Mantenimiento de cuenta 500
		    nMontoSD MONEY  -- Sobregiros y/o deudas directas en IFIs 100
        )

      DECLARE @bApruebaCampana BIT = 0,
	          @nCantidadCPP int

	  IF @nIdCampana IN (195) 
	     --VALIDA QUE SOLO PERMITA NORMAL EN EL ULTIMO RCC
	     AND NOT EXISTS(SELECT cCodSBS FROM @CALIFICACIONEXTERNA A 
                        WHERE A.dFecha = @FechaRCCRegl AND NCALIFSF > 0)
		 --VALIDA QUE TENGAN NORMAL LOS INTERVINIENTES MENOS (20,21)
		 AND NOT EXISTS(SELECT cCodSBS FROM @CALIFICACIONEXTERNA A
	                    INNER JOIN @RELACIONES B ON B.cDOI IN (A.Cod_Doc_Id,A.Cod_Doc_Trib)	
                        WHERE B.nPrdPersRelac NOT IN (20,21) --SIN
	                    AND A.NCALIFSF > 0)
		 --VALIDA QUE SOLO EXISTA HASTA CPP
		 AND NOT EXISTS(SELECT cCodSBS FROM @CALIFICACIONEXTERNA A
	                    INNER JOIN @RELACIONES B ON B.cDOI IN (A.Cod_Doc_Id,A.Cod_Doc_Trib)	
                        WHERE A.NCALIFSF > 1)
	  BEGIN
	     SELECT @nCantidadCPP = isnull(COUNT(1),0)
         FROM @CALIFICACIONEXTERNA A
	        INNER JOIN @RELACIONES B ON B.cDOI IN (A.Cod_Doc_Id,A.Cod_Doc_Trib)	
         WHERE B.nPrdPersRelac IN (20,21) --SOLO TITULAR Y CONYUGUE/CONVIVIENTE
	           AND A.NCALIFSF = 1

	     IF @nCantidadCPP = 0
		    BEGIN 
			   SELECT @bApruebaCampana = 1
		    END 
		 IF @nCantidadCPP = 1
		    BEGIN
			   INSERT INTO #CampanaRCC_CPP(cCodSBS,dFecha,nCalifSBS,nMontoMM,nMontoSD)
			   SELECT cCodSBS,dFecha,NCALIFSF,0,0 FROM @CALIFICACIONEXTERNA A
	              INNER JOIN @RELACIONES B ON B.cDOI IN (A.Cod_Doc_Id,A.Cod_Doc_Trib)	
               WHERE B.nPrdPersRelac IN (20,21) --SOLO TITULAR Y CONYUGUE/CONVIVIENTE
	                 AND A.NCALIFSF = 1

			   UPDATE AA SET AA.nMontoMM = BB.MONTO
		       FROM #CampanaRCC_CPP AA
		       INNER JOIN (-- menores a 500
		                   select A.cCodSBS,
		                   	   A.dFecha,		     
		                          SUM(B.Val_Saldo) AS MONTO		            	   
		                   from #CampanaRCC_CPP A 
		                   INNER JOIN DBRCC.dbo.rcctotaldet B 
		                              ON A.cCodSBS = B.Cod_Sbs
		                   		   AND B.dFecha = A.dFecha
		                   	WHERE nCalifSBS = 1 AND (
		                   	         B.Cod_Cuenta like '14_10[23]0209%'
		                   	      OR B.Cod_Cuenta like'52_201%')		
                           group by A.cCodSBS,A.dFecha
               ) BB ON AA.cCodSBS = BB.cCodSBS
				AND AA.dFecha = BB.dFecha

               UPDATE AA SET AA.nMontoSD = BB.MONTO
		       FROM #CampanaRCC_CPP AA
		       INNER JOIN (-- menores a 100
		                   select A.cCodSBS,
		                   	   A.dFecha,		     
		                          SUM(B.Val_Saldo) AS MONTO		            	   
		                   from #CampanaRCC_CPP A 
		                   INNER JOIN DBRCC.dbo.rcctotaldet B 
		                              ON A.cCodSBS = B.Cod_Sbs
		                   		   AND B.dFecha = A.dFecha
		                   	WHERE nCalifSBS = 1 AND (
		                   	         B.Cod_Cuenta like '14_113060[129]%'
		            	          OR B.Cod_Cuenta like '14_11[0123]04%'
		            	          OR B.Cod_Cuenta like '14_10[237]04%'
		            	          OR B.Cod_Cuenta like '14_102060[129]%'
		            	          OR B.Cod_Cuenta like '14_10[34]06%'
		            	          OR B.Cod_Cuenta like '14_11206%'
		            	          OR B.Cod_Cuenta like '14_113060[129]%')		
                           group by A.cCodSBS,A.dFecha
               ) BB ON AA.cCodSBS = BB.cCodSBS
				AND AA.dFecha = BB.dFecha

			   IF EXISTS (SELECT 1 FROM #CampanaRCC_CPP WHERE nMontoMM <= 500 AND nMontoSD <= 100)
			   BEGIN
			      SELECT @bApruebaCampana = 1
			   END
			END
		  

	  END
	  
   END   

   SET @bCalifExtEvalHorizon = 1    
       
            IF EXISTS (SELECT Cod_Doc_Id  FROM @CALIFICACIONEXTERNA           
                                        WHERE (@CCREDPRODUCTO IN ('302', '216','305', '306')                
          AND @nIdCampana NOT IN (161) AND NCALIFSF>1)              
          OR (@CCREDPRODUCTO NOT IN ('302', '216','305', '306')               
          AND @nIdCampana NOT IN (161) AND NCALIFSF>=1)               
          OR (@nIdCampana IN (161) AND NCALIFSF > 1)) AND  @bApruebaCampana = 0       
            BEGIN           
                                               
    SET @bCalifExtEvalHorizon = 0          
    IF  @nMesesCalifRegla > 1          
    BEGIN           
     SET @cMensajeReg27 = ' LOS ULTIMOS ' + CONVERT(VARCHAR(2),@nMesesCalifRegla) + ' MESES.'          
    END          
    ELSE          
    BEGIN           
     set @cMensajeReg27 = ' EL ULTIMO MES.'           
    END          
                                      
    SET @cMensajeReg27  = 'ALGUNO DE LOS MIEMBROS DE ESTE CREDITO NO CUENTA CON CALIFICACION ' + CASE WHEN @cCredProducto IN ('302', '216','305', '306') OR @nIdCampana IN (161) THEN   'HASTA CPP EN ' ELSE 'NORMAL EN' END + @cMensajeReg27          
   END    
    
   UPDATE A          
            SET A.cValorCalculado = @bCalifExtEvalHorizon          
            FROM #DatosEntradaUnPivot A          
            WHERE nIdVariable =150    
          
            DROP TABLE #FECHASDOI    
        END          
 END          
          
    BEGIN -- [nIdVariable = 153]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =153)          
            BEGIN           
                    UPDATE A          
                SET A.cValorCalculado = (          
                        Select CASE WHEN COUNT(a.cPersIDnro)> 1 THEN 1 ELSE 0 END           
                            From Persid a WITH (NOLOCK)          
                           inner join persona b WITH (NOLOCK)          
         on a.cPersCod = b.cperscod          
                                Where a.cPersCod = @cPersCodTitular and a.cpersidtpo = 2          
                           and  b.nPersPersoneria <> 1           
         )          
     FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =153          
            END          
    END          
           
    BEGIN -- [nIdVariable = (156)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =156)          
            BEGIN          
        DECLARE @RegPolizaendoso     BIT          
          
                SET @RegPolizaendoso=0          
          
                IF EXISTS (SELECT 1 FROM PolizaEndoso with(nolock)  WHERE cCtaCod=@cCtaCod  AND nTipoGastoSegCom = 1 and nEstado = 1)          
                BEGIN          
                        SET @RegPolizaendoso=1          
                END          
          
                UPDATE A          
                SET A.cValorCalculado = @RegPolizaendoso          
                FROM #DatosEntradaUnPivot A       
                WHERE nIdVariable =156          
            END          
    END          
          
    BEGIN -- [nIdVariable = (157)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =157)          
            BEGIN          
                DECLARE @nDiasTranscEvalFte INT     
          
                SET @nDiasTranscEvalFte= DATEDIFF(d,@dPersEval,@dFechaActual)          
                SET @nDiasTranscEvalFte=ISNULL(@nDiasTranscEvalFte,0)       
                              
                    UPDATE A          
                SET A.cValorCalculado = @nDiasTranscEvalFte          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =157          
            END          
    END          
          
    BEGIN -- [nIdVariable = (158)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =158)          
            BEGIN        
                DECLARE @bReglaExceptuada INT          
                SET @bReglaExceptuada=0          
          
                SELECT @bReglaExceptuada=count(1)           
                    FROM RegValidacion          
                WHERE cCtacod=@cCtaCod AND nCodAlinea=44          
                        AND nNumRefinanciacion= (SELECT MAX(nNumRefinanciacion) FROM RegValidacion WHERE cCtacod=@cCtaCod)          
                        and nEstadoValid=3          
                                        
                    UPDATE A          
                SET A.cValorCalculado =(case when @bReglaExceptuada>0 then 1 else 0 end)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =158          
            END          
    END          
          
    BEGIN -- [nIdVariable = (159)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =159)          
            BEGIN                         
                                             
                    UPDATE A          
                SET A.cValorCalculado =(SELECT COUNT(1) FROM ProductoPersona a WITH (NOLOCK)          
                                                    INNER JOIN Producto b WITH (NOLOCK) on a.cCtaCod=b.cCtaCod          
                             INNER JOIN MovCol c WITH (NOLOCK) on a.cCtaCod=c.cCtaCod          
                                                    INNER JOIN Mov d WITH (NOLOCK) on c.nMovNro=d.nMovNro          
              WHERE cPersCod = @cPersCodTitular and a.nPrdPersRelac = 20           
                AND c.cOpeCod in ('100910', '100912', '100914', '100917', '100919') and d.nMovFlag = 0          
                                                    AND b.nPrdEstado in (2020,2021,2022,2030,2031,2032,2201,2202,2205,2206))          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =159          
            END          
    END          
          
    BEGIN -- [nIdVariable = (160)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =160)          
            BEGIN             
                                             
                    UPDATE A          
                SET A.cValorCalculado =(SELECT COUNT(1) FROM ProductoPersona a WITH (NOLOCK)          
                                                    inner join Producto b WITH (NOLOCK) on a.cCtaCod=b.cCtaCod          
                                                    inner join MovCol c WITH (NOLOCK) on a.cCtaCod=c.cCtaCod          
                                                    inner join Mov d WITH (NOLOCK) on c.nMovNro=d.nMovNro          
                                                    where cPersCod = @cPersCodTitular and a.nPrdPersRelac = 20           
                                                    and b.nPrdEstado in (2030,2031,2032))          
                FROM #DatosEntradaUnPivot A          
         WHERE nIdVariable =160          
          
                              
            END          
    END          
          
    BEGIN -- [nIdVariable = (162)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =162) 
            BEGIN            
                DECLARE @ValidCampEsp     int                    
          
                set @ValidCampEsp=0          
          
                IF @nIdCampana = 129          
                BEGIN          
                            SET @ValidCampEsp = 1          
                END          
                ELSE IF @nIdCampana = 130 AND @nColocCondicion2 = 1          
                BEGIN          
     IF left(@cCalifClient,2) = 'AA'          
                            BEGIN          
                                    SET @ValidCampEsp = 1          
                            END          
                END          
                                            
                    UPDATE A          
                SET A.cValorCalculado =@ValidCampEsp          
                FROM #DatosEntradaUnPivot A          
        WHERE nIdVariable =162          
      END          
    END          
          
    BEGIN -- [nIdVariable = (164,165,166)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(164,165,166))          
            BEGIN            
                DECLARE @nNumMicroseguros INT          
                SELECT @nNumMicroseguros=COUNT(cNroCertificado)           
                    FROM Microseguro.Microseguro           
                    WHERE cPersCodTitular=@cPersCodTitular           
                        AND nEstadoCertificado=2020           
          
                SET @nNumMicroseguros=ISNULL(@nNumMicroseguros,0)-(CASE WHEN @nColocCondicion2=1 THEN 1 ELSE 0 END)           
          
                UPDATE A          
                SET A.cValorCalculado =(SELECT CONVERT(INT,nConsSisValor) FROM ConstSistema WHERE nConsSisCod=732)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =164          
          
                UPDATE A          
                SET A.cValorCalculado =@nNumMicroseguros          
  FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =165          
          
                UPDATE A          
                SET A.cValorCalculado =(SELECT CONVERT(INT,nConsSisValor) FROM ConstSistema WHERE nConsSisCod=711)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =166          
          
          
          END          
    END          
                
    BEGIN -- [nIdVariable = (167,527)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (167,527))     
            BEGIN          
    Declare @nEdadClient      INT          
                                                  
                    SELECT @nEdadClient= DATEDIFF(YEAR,(SELECT CONVERT(DATE,DPERSNACCREAC) FROM PERSONA WHERE CPERSCOD=@cPersCodTitular),@dFechaActual)          
          
                UPDATE A          
                SET A.cValorCalculado =ISNULL(@nEdadClient,0)          
                FROM #DatosEntradaUnPivot A          
       WHERE nIdVariable IN (167,527)    
            END          
    END          
          
    BEGIN -- [nIdVariable = (169)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (170, 204, 169))          
            BEGIN          
                              
    CREATE TABLE #CampanaDataVigencia          
    (          
     nIdCampana INT          
     ,Fechas VARCHAR(50)        
    )          
          
                CREATE TABLE #CampanaVigencia          
                        (          
                            nIdCampana                INT          
 ,dFechaVigencia    DATE          
            ,dFechaCaducidad   DATE          
                        )          
          
          
                DECLARE @nIndicacorVigCampana   INT          
                set @nIndicacorVigCampana=0          
                                                  
                    INSERT INTO #CampanaDataVigencia          
     SELECT SUBSTRING(Items,1,CHARINDEX('-',Items)-1)          
                            ,SUBSTRING(Items,CHARINDEX('-',Items)+1,LEN(Items))          
                FROM dbo.fn_Split((SELECT nConsSisValor FROM ConstSistema WHERE nConsSisCod=9035 ),',')           
          
          
                INSERT INTO #CampanaVigencia          
              SELECT nIdCampana          
                            ,CONVERT(DATE,(SUBSTRING(Fechas,1,CHARINDEX('|',Fechas)-1)))          
                            ,CONVERT(DATE,(SUBSTRING(Fechas,CHARINDEX('|',Fechas)+1,LEN(Fechas))))          
                FROM #CampanaDataVigencia          
          
                SELECT @nIndicacorVigCampana=COUNT(nIdCampana)          
                FROM #CampanaVigencia           
                    WHERE nIdCampana=@nIdCampana          
                        AND (dFechaVigencia<=@dFechaActual AND @dFechaActual<=dFechaCaducidad)          
          
         
    -- OPTIMUS          
    DECLARE           
     @dFechaVigencia DATE = '0001-01-01',          
     @dFechaCaducidad DATE = '0001-01-01'          
          
      SELECT           
     @dFechaVigencia = dFechaVigencia,          
     @dFechaCaducidad = dFechaCaducidad          
                FROM #CampanaVigencia           
                WHERE nIdCampana=@nIdCampana          
                        --AND (dFechaVigencia<=@dFechaActual AND @dFechaActual<=dFechaCaducidad)          
          
                UPDATE A          
                SET A.cValorCalculado =ISNULL(@dFechaVigencia,'0001-01-01')          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable = 170          
          
                UPDATE A          
                SET A.cValorCalculado =ISNULL(@dFechaCaducidad,'0001-01-01')          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable = 204          
               
                UPDATE A          
                SET A.cValorCalculado =ISNULL(@nIndicacorVigCampana,0)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =169          
            END          
    END          
            
    BEGIN -- [nIdVariable = (171)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =171)          
            BEGIN          
                DECLARE @nVigenciaEval     INT = 0          
          
                IF EXISTS(SELECT 1 FROM COLOCACIONES.DesembolsoRapidoPersona with(nolock)  WHERE cPersCod = @cPersCodTitular AND IdCampana = @nIdCampana AND cTipCli = '2')           
                BEGIN          
                        SELECT @nVigenciaEval = DATEDIFF(DAY,EOMONTH(dPersEval), @dFechaRCC) FROM COLOCACIONES.DesembolsoRapidoPersona with(nolock)  WHERE cPersCod = @cPersCodTitular AND IdCampana = @nIdCampana AND cTipCli = '2'          
                        IF @cCalifClient IN ('A','B')          
                        BEGIN          
                                SET @nVigenciaEval = @nVigenciaEval + 30          
                        END          
                END          
                ELSE          
                BEGIN          
     SELECT @nVigenciaEval = IIF(@dPersEval < '1900-01-01',0,DATEDIFF(DAY,EOMONTH(@dPersEval), @dFechaRCC))          
                END          
          
                UPDATE A          
                SET A.cValorCalculado =ISNULL(@nVigenciaEval,0)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =171          
            END          
END          
      
    BEGIN -- [nIdVariable = (172)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =172)          
            BEGIN          
                              
 Declare @nTipClientDM     INT=0          
         
                SELECT @nTipClientDM = CONVERT(INT,cTipCli) FROM COLOCACIONES.DesembolsoRapidoPersona          
                WHERE cPersCod = @cPersCodTitular          
                AND IdCampana = @nIdCampana          
         
                --SELECT @nTipClientDM=COUNT(A.cCtaCod)          
                --FROM PRODUCTO A          
                        --INNER JOIN ProductoPersona B                
                        --    ON A.cCtaCod=B.cCtaCod          
                --WHERE B.cPersCod=@cPersCodTitular AND B.nPrdPersRelac=20          
                        --AND A.nPrdEstado IN (2050,2203,2204)           
                                    
                    UPDATE A          
    SET A.cValorCalculado =ISNULL(@nTipClientDM,0)           
                    --=(CASE WHEN @nColocCondicion='3' THEN 1 WHEN @nTipClientDM>0 THEN 2 ELSE 3 END)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =172          
            END          
    END          
          
    BEGIN -- [nIdVariable = (173)]--2:Sola firma, 1:Con casa propia, 0:Sin casa propia          
  IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =173)          
            BEGIN          
                            
    IF(@nIndCasaPropia = 2)          
    BEGIN          
     UPDATE A          
     SET A.cValorCalculado =2          
     FROM #DatosEntradaUnPivot A          
     WHERE nIdVariable =173          
    END          
    ELSE          
    BEGIN          
     UPDATE A          
     SET A.cValorCalculado =IIF(@bCasaPropiaoAval=1,1,0)          
     FROM #DatosEntradaUnPivot A          
     WHERE nIdVariable =173          
    END          
            END          
    END          
          
    BEGIN -- [nIdVariable = (174)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =174)          
            BEGIN          
                UPDATE A          
                SET A.cValorCalculado = CASE WHEN @nCuotas = 1 AND @nTipoPeriodicidad = 0 THEN @nPeriodoDiaPago ELSE  @nPlazo - @nPlazoGracia END          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =174          
            END          
    END          
          
    BEGIN -- [nIdVariable = (175)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =175)          
            BEGIN          
                DECLARE @nMontoMax18 DECIMAL(18,2)          
                SELECT @nMontoMax18 = nMontoMax          
                FROM           
                        COLOCACIONES.DesembolsoRapidoPersonaRangoEspecial A  with(nolock)         
                        INNER JOIN COLOCACIONES.DesembolsoRapidoPersona B with(nolock)  ON A.cPersIDnro = B.cPersIDnro AND A.cTipCli = B.cTipCli AND A.cPersIDTpo = B.cPersIDTpo          
                WHERE           
                        A.IdCampana = @nIdCampana           
                        AND A.cFiltro = 1          
                        AND A.cPersIDnRO = @cPersIdNro           
        AND A.cPersIDTpo = 1          
          
                UPDATE A          
                SET A.cValorCalculado = @nMontoMax18          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =175          
     END          
    END          
          
    BEGIN -- [nIdVariable = (176)]          
IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =176)          
            BEGIN          
                DECLARE @nMontoMax12 DECIMAL(18,2)          
                SELECT @nMontoMax12 = nMontoMax          
            FROM           
COLOCACIONES.DesembolsoRapidoPersonaRangoEspecial A   with(nolock)         
                        INNER JOIN COLOCACIONES.DesembolsoRapidoPersona B with(nolock)  ON A.cPersIDnro = B.cPersIDnro AND A.cTipCli = B.cTipCli AND A.cPersIDTpo = B.cPersIDTpo          
                WHERE           
                        A.IdCampana = @nIdCampana           
                        AND A.cFiltro = 0          
                        AND A.cPersIDnRO = @cPersIdNro           
       AND A.cPersIDTpo = 1          
          
                UPDATE A          
                SET A.cValorCalculado = @nMontoMax12          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =176          
  END          
    END          
          
    BEGIN -- [nIdVariable = (177)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =177)          
            BEGIN          
                DECLARE @nPlazoMax18 INT          
                SELECT @nPlazoMax18 = nCuotasMax          
                FROM           
 COLOCACIONES.DesembolsoRapidoPersonaRangoEspecial A  with(nolock)         
                        INNER JOIN COLOCACIONES.DesembolsoRapidoPersona B with(nolock)  ON A.cPersIDnro = B.cPersIDnro AND A.cTipCli = B.cTipCli AND A.cPersIDTpo = B.cPersIDTpo          
                WHERE           
                        A.IdCampana = @nIdCampana           
                        AND A.cFiltro = 1          
                        AND A.cPersIDnRO = @cPersIdNro           
                        AND A.cPersIDTpo = 1          
        
                UPDATE A          
                SET A.cValorCalculado = @nPlazoMax18          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =177          
            END          
    END          
          
    BEGIN -- [nIdVariable = (178)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =178)          
            BEGIN          
                DECLARE @nPlazoMax12 INT          
                SELECT @nPlazoMax12 = nCuotasMax          
                FROM           
    COLOCACIONES.DesembolsoRapidoPersonaRangoEspecial A   with(nolock)        
                        INNER JOIN COLOCACIONES.DesembolsoRapidoPersona B  with(nolock)  ON A.cPersIDnro = B.cPersIDnro AND A.cTipCli = B.cTipCli AND A.cPersIDTpo = B.cPersIDTpo                    WHERE           
        A.IdCampana = @nIdCampana           
                        AND A.cFiltro = 0          
                        AND A.cPersIDnRO = @cPersIdNro           
                        AND A.cPersIDTpo = 1          
          
               UPDATE A          
                SET A.cValorCalculado = @nPlazoMax12          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =178          
            END          
    END          
          
    BEGIN -- [nIdVariable = (179)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =179)          
            BEGIN          
                DECLARE @nDeudaRCCFecFteIng179 MONEY          
                DECLARE @nDeudaRCCActual179 MONEY          
                DECLARE @nFechaRCCFecFetIng DATE          
                DECLARE @nIncrementoDeuda BIT = 0          
               
                IF(@nIdCampana IN (SELECT IdCampana FROM colocaciones.DesembolsoRapidoCampana with(nolock)  WHERE bEstado = 1 AND bCliPref = 1 AND IdCampana != 148))          
                BEGIN          
                                     
                        SELECT           
                                @nFechaRCCFecFetIng = CASE           
                                                                                WHEN cTipCli ='1' THEN (          
                                                                                                    SELECT eomonth(MIN(E.dPrdEstado)) FROM  ColocacEstado E  WITH (NOLOCK)         
                         INNER JOIN           
                                                                                                    (          
                                                        SELECT MIN(D.dPrdEstado) AS dPrdEstado,A.cCtaCod           
                                                                                     FROM ColocFteIngreso A WITH(NOLOCK)          
                                                                                                        INNER JOIN PRODUCTO B WITH(NOLOCK) ON A.cCtaCod = B.cCtaCod          
                                                                                                INNER JOIN PRODUCTOPERSONA C WITH(NOLOCK) ON C.cCtaCod = B.cCtaCod           
                                                                                      INNER JOIN ColocacEstado D WITH(NOLOCK) ON D.cCtaCod = C.cCtaCod           
                                                                                                        WHERE CONVERT(DATE,A.dPersEval) = CONVERT(DATE,M.dPersEval)          
                         AND C.nPrdPersRelac = 20           
                                                                                                        AND D.nPrdEstado = 2020          
            AND C.cPersCod = @cPersCodTitular           
                                                                                                     GROUP BY A.cCtaCod          
                    )F ON F.cCtaCod = E.cCtaCod AND F.dPrdEstado = E.dPrdEstado)          
                                                                                WHEN cTipCli ='2' THEN eomonth(M.dFechaRcc)           
                                                                                WHEN cTipCli ='3' THEN eomonth(M.dFechaRcc)           
                                                                END          
                        FROM COLOCACIONES.DesembolsoRapidoPersona M with(nolock)  WHERE M.cPersCod = @cPersCodTitular AND M.IdCampana = @nIdCampana          
                                     
                        IF @nFechaRCCFecFetIng > @dFechaRCC          
                        BEGIN          
           SET @nFechaRCCFecFetIng = @dFechaRCC          
                        END          
          
                        SET @nDeudaRCCActual179 = isnull((select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet  with(nolock)          
                                                                where Cod_Sbs = @CodSbsTit and dFecha = @dFechaRCC and Cod_Emp <> '00108'          
                                                                and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)          
          
            SET @nDeudaRCCActual179 = @nDeudaRCCActual179 + isnull((SELECT sum(nSaldo) FROM Producto A WITH (NOLOCK) INNER JOIN ProductoPersona B WITH (NOLOCK) ON A.cCtaCod=B.cCtaCod AND B.nPrdPersRelac = 20          
                                                                                            WHERE B.cPersCod = @cPersCodTitular AND A.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205,2101,2104,2106,2107,2202,2206)          
                                                                                                    AND SUBSTRING(A.cCtaCod,6,1) <> '4'),0)          
                        IF @nFechaRCCFecFetIng = @dFechaRCC          
                        BEGIN          
                                SET @nDeudaRCCFecFteIng179 = @nDeudaRCCActual179;          
                        END          
            ELSE          
                        BEGIN          
                                IF (select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet with(nolock)  where Cod_Sbs = @CodSbsTit and dFecha = @nFechaRCCFecFetIng          
                                                    and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%') > 0          
                                BEGIN          
                                    SET @nDeudaRCCFecFteIng179 = isnull((select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet with(nolock)  where Cod_Sbs = @CodSbsTit and dFecha = @nFechaRCCFecFetIng          
                              and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)          
                                END          
                                ELSE          
                                BEGIN          
                        SET @nDeudaRCCFecFteIng179 = isnull((select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet with(nolock)  where Cod_Sbs = @CodSbsTit and dFecha = EOMONTH (dateadd(day,1,@nFechaRCCFecFetIng))          
                                                    and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)          
                                END          
                        END          
                                     
                        IF @CodSbsConyugue is not null and @CodSbsConyugue <> ''          
                        BEGIN          
                                SET @nDeudaRCCActual179 = @nDeudaRCCActual179 + isnull((select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet with(nolock)  where Cod_Sbs = @CodSbsConyugue and dFecha = @dFechaRCC and Cod_Emp <> '00108'          
        and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)          
          
                                SET @nDeudaRCCActual179 = @nDeudaRCCActual179 + isnull((SELECT sum(nSaldo) FROM Producto A WITH (NOLOCK) INNER JOIN ProductoPersona B WITH (NOLOCK) ON A.cCtaCod=B.cCtaCod AND B.nPrdPersRelac = 20          
                                                                                                    WHERE B.cPersCod = @cPersCodConyugue AND A.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205,2101,2104,2106,2107,2202,2206)          
             AND SUBSTRING(A.cCtaCod,6,1) <> '4'),0)          
          
                                IF @nFechaRCCFecFetIng = @dFechaRCC          
                                BEGIN          
                         SET @nDeudaRCCFecFteIng179 = @nDeudaRCCActual179;          
                                END          
    ELSE          
                                BEGIN          
                                    SET @nDeudaRCCFecFteIng179 = @nDeudaRCCFecFteIng179 + isnull((select sum(Val_Saldo) from DBRCC.dbo.RccTotalDet with(nolock)  where Cod_Sbs = @CodSbsConyugue and dFecha = @nFechaRCCFecFetIng          
                                                                        and Tip_Credito not in ('13') and Cod_Cuenta LIKE '14_[13456]%'),0)          
       END          
                        END          
          
            SELECT           
                               @nDeudaRCCFecFteIng179 = CASE           
                                                                                WHEN cTipCli ='1' THEN @nDeudaRCCFecFteIng179          
                                                                                WHEN cTipCli ='2' THEN nMontoRcc          
                                                                                WHEN cTipCli ='3' THEN nMontoRcc          
                      END          
                        FROM COLOCACIONES.DesembolsoRapidoPersona with(nolock)  WHERE cPersCod = @cPersCodTitular AND IdCampana = @nIdCampana          
          
                        IF (SELECT CONVERT(INT,cTipCli) FROM COLOCACIONES.DesembolsoRapidoPersona with(nolock)          
                                WHERE cPersCod = @cPersCodTitular AND IdCampana = @nIdCampana) = 1          
                        BEGIN          
       IF @nIdCampana = 149           
       BEGIN          
        IF (@nDeudaRCCFecFteIng179 < @nDeudaRCCActual179)          
        BEGIN          
         SET @nIncrementoDeuda = 1          
        END          
       END          
       ELSE          
       BEGIN          
        IF (@nDeudaRCCFecFteIng179 + (@nDeudaRCCFecFteIng179*0.2)) < @nDeudaRCCActual179          
        BEGIN          
                                    SET @nIncrementoDeuda = 1          
        End              
       END                                           
                        END          
                        ELSE          
                        BEGIN          
       IF (@nDeudaRCCFecFteIng179 < @nDeudaRCCActual179)          
                            BEGIN          
        SET @nIncrementoDeuda = 1          
       End           
                        END                 
                END          
             
                UPDATE A          
                SET A.cValorCalculado = @nIncrementoDeuda          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =179          
            END          
END          
          
    BEGIN -- [nIdVariable = (180)]          
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =180)          
            BEGIN          
                UPDATE A          
                SET A.cValorCalculado = @nMonto          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable =180          
            END          
    END          
          
    BEGIN -- [nIdVariable = (181)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =181)          
             BEGIN          
                    UPDATE A          
                    SET A.cValorCalculado = @nCuotas          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =181          
         END          
     END          
          
    BEGIN -- [nIdVariable = (182)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =182)      
   BEGIN           
          
             CREATE TABLE #MontoTalDeudaS      
    (          
     cPerscod VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS,      
     nMonto DECIMAL(18,2)      
    )      
          
    CREATE TABLE #CFAplicaExposicionS      
    (      
     cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS,      
     nAplicaExposicionCred INT DEFAULT(0)      
    );      
          
    IF (@cCtaCod)<>''      
    BEGIN      
     INSERT INTO #MontoTalDeudaS      
     EXEC PA_ObtieneMontoDeudaTotal @cCtaCod      
    END      
    ELSE      
    BEGIN      
     INSERT INTO #CFAplicaExposicionS (cCtaCod, nAplicaExposicionCred)      
     SELECT      
     A.cCtaCod,      
     SUM(CASE      
      WHEN nTipoColateralID IN  (3, 4, 5, 6, 7, 8, 9) THEN 1      
      ELSE 0      
     END) AS nAplicaExposicionCred          
    FROM Producto A WITH (NOLOCK)          
    INNER JOIN ColocGarantia B WITH (NOLOCK)      
    ON A.cCtaCod = B.cCtaCod      
    INNER JOIN Garantias C WITH (NOLOCK)      
    ON B.cNumGarant = C.cNumGarant      
    WHERE SUBSTRING(A.cCtaCod,6,3) IN ('121','221')      
    AND A.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)      
    GROUP BY A.cCtaCod      
            
    IF @cCredProducto IN ('121','221')      
    BEGIN      
     INSERT INTO #MontoTalDeudaS(cPerscod,nMonto)      
     SELECT       
     PP.cPersCod,      
     nSaldo = SUM(CASE       
         WHEN @nMoneda='1' THEN (CASE       
               WHEN Substring(P.cCtaCod,9,1)='1' THEN P.nSaldo      
               ELSE P.nSaldo*@tipoCambio      
               END)      
         ELSE (CASE       
           WHEN SUBSTRING(P.cCtaCod,9,1)='1'       
           THEN P.nSaldo/@tipoCambio      
           ELSE P.nSaldo      
           END)      
         END)      
     FROM Producto P  WITH (NOLOCK)      
     JOIN ProductoPersona PP WITH (NOLOCK)      
     ON P.cCtaCod = PP.cCtaCod      
     AND PP.nPrdPersRelac = 20      
     LEFT JOIN #CFAplicaExposicionS A      
     ON P.cCtaCod = A.cCtaCod      
     WHERE PP.cPersCod = @cPersCodTitular      
     AND P.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)      
     AND SUBSTRING(p.cctacod,6,3)  in ('121','221')      
     AND A.nAplicaExposicionCred = 1    
     AND P.cCtaCod NOT IN (SELECT       
           cCtaCodRen as cCtaCod       
           FROM ColocRenovacion x       
           WHERE x.cCtaCod=@cCtaCod)      
     GROUP BY PP.cPersCod          
    END             
    ELSE               
    BEGIN      
     INSERT INTO #MontoTalDeudaS(cPerscod,nMonto)      
     SELECT       
     X.cPersCod,       
     ISNULL(SUM(nSaldo), 0) nSaldo      
     FROM (SELECT       
       PP.cPersCod,                
       nSaldo = ISNULL(SUM(CASE       
            WHEN @nMoneda='1'       
            THEN (CASE       
              WHEN SUBSTRING(P.cCtaCod,9,1)='1'       
              THEN P.nSaldo           
              ELSE P.nSaldo*@tipoCambio      
              END)      
            ELSE (CASE       
              WHEN SUBSTRING(P.cCtaCod,9,1)='1'       
              THEN P.nSaldo/@tipoCambio      
              ELSE P.nSaldo      
              END)      
            END), 0)      
       FROM Producto P    WITH (NOLOCK)      
       INNER JOIN ProductoPersona PP WITH (NOLOCK)      
       ON P.cCtaCod = PP.cCtaCod      
       AND PP.nPrdPersRelac = 20      
       WHERE PP.cPersCod = @cPersCodTitular      
       AND P.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)      
       AND SUBSTRING(p.cctacod,6,3) NOT IN ('121','221','241','302','216')      
       AND P.cCtaCod NOT IN (SELECT       
             cCtaCodAmp as cCtaCod       
             FROM ColocacAmpliado  with(nolock)      
             WHERE cCtaCod = @cCtaCod          
             UNION      
             SELECT       
             cCtaCodRef       
             FROM ColocacRefinanc  with(nolock)      
             WHERE cCtaCod=@cCtaCod)      
       GROUP BY PP.cPersCod      
       UNION      
       SELECT      
       B.cPersCod,      
       nSaldo = ISNULL(SUM(CASE      
            WHEN @nMoneda ='1'      
            THEN (CASE      
              WHEN SUBSTRING(A.cLineaCod, 9, 1) = '1'      
              THEN A.nMontoAsig      
              ELSE A.nMontoAsig * @tipoCambio      
              END)      
            ELSE      
            (CASE      
             WHEN SUBSTRING(A.cLineaCod, 9, 1) = '1'      
             THEN A.cLineaCod/@tipoCambio      
             ELSE A.cLineaCod      
             END)      
            END), 0)      
        FROM LineaCredito A WITH (NOLOCK)      
        INNER JOIN LineaCreditoPersona B  WITH (NOLOCK)      
        ON A.cLineaCod = B.cLineaCod      
      AND  B.nLinPersRelac = 20      
        WHERE B.cPersCod = @cPersCodTitular      
        AND A.nLinEstado IN (2020)      
        GROUP BY B.cPersCod) X          
     GROUP BY X.cPersCod      
    END              
          
             END          
                              
   SET @nMontoTotalDeuda=(SELECT SUM(nMonto) FROM #MontoTalDeudaS)      
         
   SET @nMontoTotalDeuda = (CASE       
          WHEN @nMoneda=2       
          then ROUND(isnull(@nMontoTotalDeuda,0)/@tipoCambio,2)       
          else ROUND(isnull(@nMontoTotalDeuda,0),2) end) + (CASE       
                       WHEN @nMoneda=2       
                       THEN ROUND(@nMonto/@tipoCambio,2)       
                       ELSE @nMonto END)      
      
   SELECT       
   @nSaldoCubierto = ISNULL(SUM(Case When @nMoneda=1  then A.nMontoConG Else A.nMontoConG*@tipoCambio End),0)      
   FROM #CreditosNoCoberturados A      
          
   UPDATE A      
   SET A.cValorCalculado = ISNULL(@nMontoTotalDeuda,0) - @nSaldoCubierto      
    FROM #DatosEntradaUnPivot A      
   WHERE nIdVariable =182      
          
   DROP TABLE #MontoTalDeudaS          
   DROP TABLE #CFAplicaExposicionS      
   END                   
     END          
          
    BEGIN -- [nIdVariable = (183)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =183)          
             BEGIN          
          
                    UPDATE A          
                    SET A.cValorCalculado =           
                 (          
                           SELECT COUNT(1) FROM          
          (          
                                  SELECT A.cCtaCod,DBO.FN_GetcCredProducto(A.cCtaCod) as cCredProductos          
                                  FROM           
                                        Producto A  WITH (NOLOCK)        
                                        INNER JOIN ProductoPersona B WITH (NOLOCK) ON A.cCtaCod = B.cCtaCod          
                                        --INNER JOIN ColocProductoComer C ON A.cCtaCod = C.cCtaCod          
                                        --INNER JOIN CredProductos D ON D.cCredProductos = C.cSubProducto          
                                  WHERE           
                                        B.cPersCod = @cPersCodConyugue          
                   AND B.nPrdPersRelac = 20          
                                        AND A.nPrdEstado in (2020,2021,2022,2030,2031,2032,2201,2205,2202)              
                          ) Z            
                           INNER JOIN CredProductos D WITH (NOLOCK) ON D.cCredProductos = Z.cCredProductos          
                           WHERE D.cCredProductos NOT IN ('306','305','301','302','216','320','241')          
                    )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =183          
             END          
     END          
          
    BEGIN -- [nIdVariable = (184)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =184)          
             BEGIN          
   DECLARE @cMensaje184 VARCHAR(500)          
                    EXEC COLOCACIONES.FluCredSol_ValidaSolProductoxAnalist @cCredProducto,1,@cUser,@cAgeCod,@cPersIdNro,@nIdCampana,@cMensaje184 OUTPUT          
          UPDATE A          
                    SET A.cValorCalculado = @cMensaje184          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =184          
             END          
     END          
          
    BEGIN -- [nIdVariable = (185, 186)]           
             IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (185, 186))          
             BEGIN          
                    DECLARE           
                        @bEsDirector BIT = 0,          
                           @nMesesAntiguedadEnRRHH INT = 0          
          
           SELECT          
                           @bEsDirector = CASE WHEN COUNT(1) > 0 THEN 1 ELSE 0 END           
                     FROM rrhh          
                    WHERE cPersCod = @cPersCodTitular          
                       AND cRHCod LIKE '[D]%'          
                       AND nRHEstado = 201          
                       AND dCese IS NULL          
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@bEsDirector, 0)          
                   FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 185          
          
                    SELECT          
                           @nMesesAntiguedadEnRRHH = DATEDIFF(MONTH, dIngreso, @dFechaActual )           
                     FROM rrhh          
                    WHERE cPersCod = @cPersCodTitular          
   AND cRHCod LIKE '[ED]%'          
   --AND nRHEstado = 201          
                       --AND dCese IS NULL          
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@nMesesAntiguedadEnRRHH, 0)          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 186          
             END          
       END           
          
    BEGIN -- [nIdVariable = (187)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 187)          
             BEGIN          
                    DECLARE           
                           @nMonedaConfigCampana INT          
          
                    SET @nMonedaConfigCampana = (SELECT ISNULL(IdMoneda, 0) FROM Campanas WHERE IdCampana = @nIdCampana)          
          
                    UPDATE A          
 SET A.cValorCalculado = ISNULL(@nMonedaConfigCampana, 0) -- SELECT  *           
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 187          
             END          
     END          
        
    BEGIN -- [nIdVariable = (189)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 189)          
             BEGIN          
                    DECLARE           
                           @nCantReprogVigentesCampana INT,            
         @nCtAnDiasAtraso INT = 0            
            
     DECLARE @CuentaReprogramacion TABLE          
     (          
      cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS          
     )          
               
     INSERT INTO @CuentaReprogramacion          
                    SELECT          
                           B.cCtaCod          
                    FROM ProductoPersona a  WITH (NOLOCK)        
         INNER JOIN Producto b  WITH (NOLOCK)        
                                  ON a.cCtaCod = b.cCtaCod          
                           INNER JOIN MovCol c  WITH (NOLOCK)        
                                 ON a.cCtaCod = c.cCtaCod          
                           INNER JOIN Mov d  WITH (NOLOCK)        
                                  ON c.nMovNro = d.nMovNro          
                    WHERE cPersCod = @cPersCodTitular          
                    AND a.nPrdPersRelac = 20          
                    AND ((c.cOpeCod IN ('100910', '100912', '100914', '100919')           
                           AND d.nMovFlag = 0)           
                           OR (c.cOpeCod IN ('100917')           
                           AND d.nMovFlag = 0          
                           AND b.cCtaCod IN (          
                                                      SELECT          
                                                            x.cCtacod          
                                                      FROM ColocAutorizacion x with(nolock)          
                                                      WHERE x.nTipo in (4,5,6))))           
                    AND b.nPrdEstado IN (2020, 2021, 2022, 2030, 2031, 2032, 2201, 2202, 2205, 2206)          
          
     IF (@nIdCampana IN (SELECT IdCampana FROM colocaciones.DesembolsoRapidoCampana with(nolock)  WHERE bEstado = 1 AND bCliPref = 1 AND IdCampana != 148))          
     BEGIN          
          
      SELECT A.* INTO #MOVCOL FROM MOVCOL A with(nolock)          
      INNER JOIN @CuentaReprogramacion C ON A.cCtaCod = C.cCtaCod          
          
      SELECT * INTO #MOV           
      FROM MOV B with(nolock)  WHERE B.nMovNro IN (SELECT DISTINCT nMovNro FROM #MOVCOL)          
          
      DELETE FROM C          
      FROM          
       #MOVCOL A          
       INNER JOIN #MOV B ON A.nMovNro = B.nMovNro          
       INNER JOIN @CuentaReprogramacion C ON C.cCtaCod = A.cCtaCod          
      WHERE          
       DATEDIFF(DAY, CONVERT(DATE,SUBSTRING(B.cMovNro,1,8)) ,@dFechaActual) <= 180          
       AND B.nMovFlag = 0          
       AND B.cOpeCod NOT LIKE '99%'          
       AND (          
         B.cOpeCod LIKE '100[2-7]%'           
         OR B.cOpeCod LIKE '13%'           
         OR B.cOpeCod LIKE '102%'          
         OR B.cOpeCod  in ('121000','121001','121010','121011','126300','126301','120002','121101','121102','121111','121112','126101','126102','126111','126112','120003','126201','126202','126211','126212','120004','122000','122100')          
         OR B.cOpeCod like '1212%'          
        )          
       AND B.cOpeCod NOT LIKE '1002[23][0-5]%'           
       AND B.cOpeCod NOT LIKE '100[2-7]17%'           
       AND B.cOpeCod NOT LIKE '1301%'          
       AND B.cOpeCod NOT LIKE '13021[0-3]%'          
       AND B.cOpeCod NOT LIKE '13041%'          
       AND B.cOpeCod NOT LIKE '13[145789]%'          
       AND B.cOpeCod NOT LIKE '130[567]%'         
       AND B.cOpeCod NOT LIKE '136[^123]%'           
       AND            
       (            
         (@nIdCampana = 165 AND (SELECT COUNT(cCtacod) FROM ColocAutorizacion with(nolock)  WHERE cCtacod = C.cCtaCod AND nEstadoAuto = 2 AND nestreprog = 1) = 0)            
                OR            
         (@nIdCampana <> 165 )            
        )         
     END          
               
     SELECT @nCantReprogVigentesCampana = COUNT(1) FROM @CuentaReprogramacion          
            
      IF @nIdCampana IN (165) and @nCantReprogVigentesCampana > 0 --campaña navideña 2020            
      BEGIN            
    select @nCtAnDiasAtraso = count(b.cCtaCod) from @CuentaReprogramacion a inner join ColocacCred b WITH(NOLOCK) on a.cCtaCod = b.cCtaCod WHERE b.nDiasAtraso > 0         
        
   IF @nCtAnDiasAtraso = 0          
      BEGIN          
          
      SELECT          
         a.*, cast(0 as bit) bPagosPostRepro          
      INTO #T from @CuentaReprogramacion a          
       inner join ColocacCred b with(nolock)  on a.cCtaCod = b.cCtaCod          
      WHERE b.nDiasAtraso < 1          
          
      update a          
      set a.bPagosPostRepro = COLOCACIONES.FN_VerificaPagosPostRepro(a.cCtaCod)          
      --select *           
      from #T a          
  --SELECT COUNT(*) FROM #T WHERE bPagosPostRepro = 0        
      SET @nCantReprogVigentesCampana = (SELECT COUNT(1) FROM #T WHERE bPagosPostRepro = 0)          
        
      END              
     END            
          
   UPDATE A            
   SET A.cValorCalculado = ISNULL(@nCantReprogVigentesCampana, 0) -- SELECT  *           
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable = 189          
        END          
     END          
          
    BEGIN -- [nIdVariable = (191)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 191)          
             BEGIN          
                    DECLARE           
                           @bRecurrenteCompraDeuda INT = 0          
          
                    SELECT          
                           @bRecurrenteCompraDeuda = CASE WHEN COUNT(1)> 0 THEN 1 ELSE 0 END           
                    FROM ProductoPersona a WITH (NOLOCK)         
                           INNER JOIN Producto b WITH (NOLOCK)         
                                  ON a.cCtaCod = b.cCtaCod          
                    WHERE cPersCod = @cPersCodTitular          
                    AND a.nPrdPersRelac = 20          
                    AND ((b.nPrdEstado IN (2020, 2021, 2022, 2030, 2031, 2032, 2201, 2202, 2205, 2206))           
                           OR (b.nPrdEstado IN (2050, 2203, 2204)           
                           AND CAST(b.dPrdEstado AS DATE) > DATEADD(d, -30, @dFechaActual)))          
          
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@bRecurrenteCompraDeuda, 0) -- SELECT  *           
FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 191          
             END          
     END          
          
    BEGIN -- [nIdVariable = (192)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =192)          
             BEGIN          
          
                    UPDATE A          
                    SET A.cValorCalculado = (SELECT COUNT(1)          
                      FROM Producto a  WITH (NOLOCK)          
                                                            INNER JOIN ProductoPersona b WITH (NOLOCK)          
                                                               ON a.cCtaCod=b.cCtaCod            
                                                          WHERE a.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2101,2104,2106,2107,2201,2205)           
                                                                AND  dbo.FN_GetcCredProducto(A.cCtaCod)= @cCredProducto          
                                                                AND NOT EXISTS (SELECT cCtaCod FROM ColocacCred with(nolock)  WHERE cCtaCod=a.cCtaCod AND cRFA IN ('rfa','vch'))            
                                                                AND b.cPersCod = @cPersCodTitular            
                                                                AND b.nPrdPersRelac = 20  )          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable =192          
             END          
      END          
            
    BEGIN -- [nIdVariable = (443)]            
        IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =443)            
             BEGIN            
          
    UPDATE A            
                SET A.cValorCalculado = 1         
                FROM #DatosEntradaUnPivot A            
                WHERE nIdVariable =443           
          
     IF EXISTS(SELECT 1 FROM COLOCACIONES.DesembolsoRapidoPersona with(nolock)  WHERE cPersCod = @cPersCodTitular AND IdCampana = @nIdCampana AND cTipCli = '3')             
     BEGIN          
      UPDATE A            
      SET A.cValorCalculado = 0          
      FROM #DatosEntradaUnPivot A            
      WHERE nIdVariable =443           
     END          
          
             END            
      END           
         
          
             
          
 BEGIN -- [nIdVariable = (194, 195, 196)]            
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (194, 195, 196))          
             BEGIN          
                           
                    DECLARE           
                           @nCantCredVigJudCast INT = 0,          
                           @nCantCredCancJudCast INT = 0,          
              @dFechaUltCancelacion DATE = '1900-01-01',          
                           @nDiasCancJudCast INT = 0          
          
                    SELECT           
                           @nCantCredVigJudCast = COUNT(1)          
                    FROM ProductoPersona pp  WITH (NOLOCK)        
                 INNER JOIN Producto p  WITH (NOLOCK)        
                                  ON pp.cCtaCod = p.cCtaCod          
                    WHERE pp.nPrdPersRelac IN (20, 25)           
                           AND pp.cPersCod = @cPersCodTitular          
                           AND P.nprdestado IN (2201, 2202, 2205, 2206)          
                           AND NOT EXISTS (          
                                                      SELECT          
                                                            cctacod          
                                                      FROM colocExceptuadoReglaJudCast ct with(nolock)           
    WHERE ct.cctacod = pp.cCtaCod      
                                                            AND ct.cPersCod = pp.cPersCod          
                                                            AND ct.nPrdPersRelac = pp.nPrdPersRelac)                               
           
          
                    SELECT           
       -- @nDiasCanc = ISNULL(DATEDIFF(DAY, MAX( P.dPrdEstado ), @dFechaActual), 0)             
                           @nCantCredCancJudCast = COUNT(1),          
                           @dFechaUltCancelacion = MAX(P.dPrdEstado)          
                    FROM ProductoPersona pp WITH (NOLOCK)         
                           INNER JOIN Producto p  WITH (NOLOCK)        
           ON pp.cCtaCod = p.cCtaCod          
                    WHERE pp.nPrdPersRelac IN (20, 25)           
                          AND pp.cPersCod = @cPersCodTitular          
                           AND P.nprdestado IN (2204, 2203)           
                           AND NOT EXISTS (          
                                                      SELECT          
                cctacod          
                                                      FROM colocExceptuadoReglaJudCast ct  with(nolock)         
                                                      WHERE ct.cctacod = pp.cCtaCod          
                                                            AND ct.cPersCod = pp.cPersCod          
                                                            AND ct.nPrdPersRelac = pp.nPrdPersRelac)                               
                              
                                            
                    SET @nDiasCancJudCast =    CASE            
                                                            WHEN @nCantCredCancJudCast > 0 THEN ISNULL(DATEDIFF(DAY, @dFechaUltCancelacion, @dFechaActual), 0)          
                                                            ELSE 0          
                                                      END           
          
          
                    UPDATE A          
                    SET A.cValorCalculado =           
         CASE          
         WHEN A.nIdVariable = 194 THEN @nCantCredVigJudCast          
                                  WHEN A.nIdVariable = 195 THEN @nCantCredCancJudCast          
                      WHEN A.nIdVariable = 196 THEN @nDiasCancJudCast          
                           END           
                    FROM #DatosEntradaUnPivot A          
            WHERE A.nIdVariable IN (194, 195, 196)          
             END          
      END          
                                                                                            
    BEGIN -- [nIdVariable = (197)]          
          IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 197)          
             BEGIN          
          
                    DECLARE           
                           @nCantDeudaCastigada INT = 0          
                       
                    SELECT           
       @nCantDeudaCastigada  = COUNT(1)           
                   FROM Producto P WITH (NOLOCK)          
                           INNER JOIN ProductoPersona pp   WITH (NOLOCK)        
                                  ON p.cCtaCod = pp.cCtaCod           
                                        AND pp.nPrdPersRelac = 20 --AND pp.nPrdPersRelac = 28          
                           INNER JOIN PersID Pid   with(nolock)         
                                  ON pid.cPersCod = pp.cPersCod           
       WHERE pid.cPersIDnro = @cPersIdNro           
                     AND nPrdEstado IN (2202, 2204, 2206) --creditos castigados                   
                 
                    IF LEN(@cPersIdNro) < 11          
                    BEGIN                  
    --SI ES PERSONA NATURAL          
                           SELECT           
                                  @nCantDeudaCastigada  = @nCantDeudaCastigada  + COUNT(1)          
                           FROM DBRCC.dbo.RccTotalULT A  with(nolock)         
                                  INNER JOIN DBRCC.dbo.RccTotalDetUlt B   with(nolock)         
     ON A.Cod_Sbs =B.Cod_Sbs          
                                               AND A.Fec_Rep=B.dFecha           
                           WHERE A.Cod_Doc_Id = @cPersIdNro AND           
                                  (B.Cod_Cuenta LIKE '14[12]6%'           
                                  OR B.Cod_Cuenta LIKE '81[12]3%')          
        AND Cod_Emp NOT IN ('00108','00125','00344','00347','00352','00373','00385') --NO SE DEBE CONSIDERAR A LA CMACICA          
                                     
                    END          
          
                    IF LEN(@cPersIdNro) >= 11          
                    BEGIN                         
          --SI ES PERSONA JURIDICA          
                    SELECT           
                    @nCantDeudaCastigada  = @nCantDeudaCastigada  + COUNT(1)          
                           FROM DBRCC.dbo.RccTotalULT A with(nolock)           
                           INNER JOIN DBRCC.dbo.RccTotalDetUlt B   with(nolock)        
                                  ON A.Cod_Sbs =B.Cod_Sbs          
                                               AND A.Fec_Rep=B.dFecha           
                            WHERE A.Cod_Doc_Trib = @cPersIdNro          
                                  AND (B.Cod_Cuenta LIKE '14[12]6%'           
                                  OR B.Cod_Cuenta LIKE '81[12]3')          
                                  AND Cod_Emp NOT IN ('00108','00125','00344','00347','00352','00373','00385')--NO SE DEBE CONSIDERAR A LA CMACICA          
                    END                           
          
                    SET @nCantDeudaCastigada  = COALESCE(@nCantDeudaCastigada , 0)          
          
                    UPDATE A          
                    SET A.cValorCalculado = @nCantDeudaCastigada  -- SELECT *          
                    FROM #DatosEntradaUnPivot A          
                    WHERE nIdVariable = 197          
             END          
      END          
          
 BEGIN -- [nIdVariable = (198)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 198)          
             BEGIN          
                              
    DECLARE @cNumGarant BIGINT          
    DECLARE @nMonedaGarantia INT          
    DECLARE @nTipoCambioGar DECIMAL(18,4)          
    DECLARE @nMontoLimite DECIMAL(18,2)          
    DECLARE @nCapitalCoberturado DECIMAL(18,2)          
    DECLARE @nMontoxCubrir DECIMAL(18,2)          
    DECLARE @nDisponible DECIMAL(18,2)          
    DECLARE @nDisponibleTc DECIMAL(18,2)          
    DECLARE @nMontoCubrir DECIMAL(18,2)          
    DECLARE @nPorcenajeGarantia DECIMAL(18,2)          
          
    CREATE TABLE #CoberturaGarantia          
    (          
     NumCreditos INT,          
     Cobertura DECIMAL(18,2),          
     nRealizacion DECIMAL(18,2),          
     nPorGravar DECIMAL(18,2),          
     CapitalCoberturado DECIMAL(18,2),          
     CapitalLimite DECIMAL(18,2),          
     CapitalLimiteME DECIMAL(18,2),          
     nPorGravar100 DECIMAL(18,2),          
     nTipoColateralID INT,          
     cTipoGarantCod VARCHAR(20)          
    )          
          
    SELECT @cNumGarant = nNumGarant FROM #GarantiaCredito          
    SELECT @nMonedaGarantia= nMoneda FROM Garantias WHERE cNumGarant = @cNumGarant          
          
    INSERT INTO #CoberturaGarantia(NumCreditos,Cobertura,nRealizacion,nPorGravar,CapitalCoberturado,CapitalLimite,CapitalLimiteME,nPorGravar100,nTipoColateralID,cTipoGarantCod)          
    exec Garantia.FluCre_SelDatosCoberturaGarantia_SP @nIdCampana,@cCredProducto,0,0,0,'','','',@cNumGarant,0,0,@cPersCodTitular,'',@nPlazo,@nCuotas          
          
    IF(@nMoneda=@nMonedaGarantia)          
    BEGIN          
     SET @nTipoCambioGar = 1          
    END          
    ELSE          
    BEGIN          
     SET @nTipoCambioGar = @tipoCambio          
    END          
          
    IF(@nMoneda=1)          
    BEGIN          
     SELECT @nMontoLimite = CapitalLimite,@nCapitalCoberturado = CapitalCoberturado FROM #CoberturaGarantia          
    END          
    ELSE          
    BEGIN          
     SELECT @nMontoLimite = CapitalLimiteME,@nCapitalCoberturado = CapitalCoberturado/@tipoCambio FROM #CoberturaGarantia          
    END          
          
    SET @nMontoxCubrir = @nMonto          
    IF (@nMontoLimite>0)          
    BEGIN          
     IF(@nMontoLimite - @nCapitalCoberturado <@nMontoxCubrir)          
     BEGIN          
      SET @nMontoxCubrir = @nMontoLimite - @nCapitalCoberturado;          
     END          
     IF @nMontoxCubrir < 0           
     BEGIN          
      SET @nMontoxCubrir = 0          
     END          
    END          
          
    IF(SELECT NumCreditos FROM #CoberturaGarantia) = 0          
    BEGIN          
     SELECT @nDisponible = nRealizacion * Cobertura/100 FROM #CoberturaGarantia          
     IF(@nMoneda= 2)          
     BEGIN          
      SELECT @nDisponibleTc = (nRealizacion * Cobertura/100)/@nTipoCambioGar FROM #CoberturaGarantia          
     SET @nMontoCubrir = CASE WHEN @nDisponibleTc > @nMontoxCubrir THEN @nMontoxCubrir * @nTipoCambioGar ELSE @nDisponibleTc * @nTipoCambioGar END          
      SET @nPorcenajeGarantia = (@nMontoCubrir / @nTipoCambioGar * 100) / @nMonto          
     END          
     ELSE          
     BEGIN          
      SELECT @nDisponibleTc = (nRealizacion * Cobertura/100)/@nTipoCambioGar FROM #CoberturaGarantia          
      SET @nMontoCubrir = CASE WHEN @nDisponibleTc > @nMontoxCubrir THEN @nMontoxCubrir / @nTipoCambioGar ELSE @nDisponibleTc / @nTipoCambioGar END          
      SET @nPorcenajeGarantia = (@nMontoCubrir * @nTipoCambioGar * 100) / @nMonto          
     END          
    END          
    ELSE          
    BEGIN          
     SELECT @nDisponible = nPorGravar100 * Cobertura/100 FROM #CoberturaGarantia          
     IF(@nMoneda= 2)          
     BEGIN          
      SELECT @nDisponibleTc = (nPorGravar100 * Cobertura/100)/@nTipoCambioGar FROM #CoberturaGarantia          
      SET @nMontoCubrir = CASE WHEN @nDisponibleTc > @nMontoxCubrir THEN @nMontoxCubrir * @nTipoCambioGar ELSE @nDisponibleTc * @nTipoCambioGar END          
      SET @nPorcenajeGarantia = (@nMontoCubrir / @nTipoCambioGar * 100) / @nMonto          
     END          
     ELSE          
     BEGIN          
      SELECT @nDisponibleTc = (nPorGravar100 * Cobertura/100)/@nTipoCambioGar FROM #CoberturaGarantia          
      SET @nMontoCubrir = CASE WHEN @nDisponibleTc > @nMontoxCubrir THEN @nMontoxCubrir / @nTipoCambioGar ELSE @nDisponibleTc / @nTipoCambioGar END          
      SET @nPorcenajeGarantia = (@nMontoCubrir * @nTipoCambioGar * 100) / @nMonto          
     END          
    END          
    DROP TABLE #CoberturaGarantia          
          
    UPDATE A          
                SET A.cValorCalculado = CASE WHEN @cNumGarant = '1' THEN 1 ELSE           
           (CASE WHEN @nMontoCubrir <= 0 THEN 0           
           WHEN @nMontoCubrir < @nMonto - 10 THEN 0           
           ELSE 1 END)          
           END          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable = 198          
             END          
     END            
           
BEGIN -- [nIdVariable = (199)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable = 199)          
             BEGIN          
    DECLARE @bValidaDesembolsosPorDia BIT                  
    EXEC PA_ValidaDesembolsosPorDia @cCtaCod, @dFechaActual, @bValidaDesembolsosPorDia OUTPUT          
    SET @bValidaDesembolsosPorDia = 1          
    UPDATE A          
                SET A.cValorCalculado = @bValidaDesembolsosPorDia          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable = 199          
             END          
     END               
          
 BEGIN -- [nIdVariable = (200,201)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (200,201))          
             BEGIN          
    DECLARE @nDiasAtrasoMaxRecurrente INT          
    DECLARE @nDiasAtrasoMaxAmp INT          
    DECLARE @nMensaje201 VARCHAR(500)          
          
    SET @nDiasAtrasoMaxRecurrente = (SELECT nConsSisValor FROM ConstSistema WHERE nConsSisCod = 2026)          
    SET @nDiasAtrasoMaxAmp = (SELECT nConsSisValor FROM ConstSistema WHERE nConsSisCod = 975)          
              
    UPDATE A          
     SET A.cValorCalculado = 0           
     FROM #DatosEntradaUnPivot A          
     WHERE nIdVariable IN (200)          
    UPDATE A          
     SET A.cValorCalculado = ''           
     FROM #DatosEntradaUnPivot A          
     WHERE nIdVariable IN (201)          
          
    IF EXISTS(SELECT cCtacod FROM #TCreditosVigentes WHERE nDiasAtraso > CASE WHEN bAmpliado = 1 THEN @nDiasAtrasoMaxAmp ELSE @nDiasAtrasoMaxRecurrente END )          
    BEGIN           
       SET @nMensaje201 = 'Los siguientes créditos no cumplen la condición de días de atraso:'          
          
       SELECT           
       @nMensaje201 = @nMensaje201 + CHAR(13) + CONVERT(VARCHAR, A.cCtaCod) + ' con ' + CONVERT(VARCHAR, A.nDiasAtraso) + ' día(s) de atraso'          
       FROM #TCreditosVigentes A          
       WHERE nDiasAtraso >           
       CASE           
       WHEN bAmpliado = 1 THEN @nDiasAtrasoMaxAmp           
       ELSE @nDiasAtrasoMaxRecurrente           
       END          
       ORDER BY cCtaCod          
                 
     UPDATE A          
      SET A.cValorCalculado = 1           
      FROM #DatosEntradaUnPivot A          
      WHERE nIdVariable IN (200)          
     UPDATE A          
      SET A.cValorCalculado = @nMensaje201          
      FROM #DatosEntradaUnPivot A          
      WHERE nIdVariable IN (201)          
    END           
             END          
     END               
           
 BEGIN -- [nIdVariable = (231)]          
  DECLARE @nRefOtrasEntid INT = 0          
          
  IF (@nIdCampana = 161)          
  BEGIN          
             
   -- Persona Natural          
   SELECT           
    @nRefOtrasEntid = COUNT(1)          
   FROM          
    DBRCC.dbo.RccTotalULT B  with(nolock)          
    INNER JOIN DBRCC.dbo.RccTotalDetUlt C  with(nolock)         
     ON B.Cod_Sbs = C.Cod_Sbs          
     AND CONVERT(DATE, B.Fec_Rep) = CONVERT(DATE, C.dFecha)          
   WHERE           
    LEN(@cPersIdNro) < 11          
    AND B.Cod_Doc_Id = @cPersIdNro          
    AND C.Cod_Cuenta LIKE '14[12]4%'          
    AND C.Cod_Emp NOT IN ('00108')          
          
   -- Persona Juridica          
   SELECT           
    @nRefOtrasEntid = COUNT(1)          
   FROM          
    DBRCC.dbo.RccTotalULT B    with(nolock)       
    INNER JOIN DBRCC.dbo.RccTotalDetUlt C   with(nolock)     
     ON B.Cod_Sbs = C.Cod_Sbs          
     AND CONVERT(DATE, B.Fec_Rep) = CONVERT(DATE, C.dFecha)          
    WHERE           
     LEN(@cPersIdNro) >= 11          
     AND B.Cod_Doc_Trib = @cPersIdNro          
     AND C.Cod_Cuenta LIKE '14[12]4%'          
     AND C.Cod_Emp NOT IN ('00108')          
  END          
          
  UPDATE A          
  SET A.cValorCalculado = @nRefOtrasEntid          
  FROM #DatosEntradaUnPivot A          
  WHERE nIdVariable IN (231)          
          
 END           
        
 BEGIN -- [nIdVariable = (242)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (242))          
             BEGIN             
     UPDATE A          
      SET A.cValorCalculado = @nTipoFuente          
      FROM #DatosEntradaUnPivot A          
      WHERE nIdVariable IN (242)          
             END          
     END               
               
 BEGIN -- [nIdVariable = (359)]          
         IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (359))          
             BEGIN          
    IF EXISTS(SELECT 1 FROM COLOCACIONES.DesembolsoRapidoPersona with(nolock)  WHERE cPersCod = @cPersCodTitular AND IdCampana = @nIdCampana AND cTipCli = '1')           
    BEGIN          
     DECLARE @CntCredHipo MONEY          
     SELECT @CntCredHipo = COUNT(1)          
        FROM           
                           Producto P   WITH (NOLOCK)          
                           INNER JOIN ProductoPersona PP WITH (NOLOCK) ON P.cCtaCod = PP.cCtaCod          
                                  AND PP.nPrdPersRelac = 20          
                    WHERE           
        PP.cPersCod = @cPersCodTitular          
                           AND P.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)          
                           AND SUBSTRING(p.cctacod,6,3) NOT IN ('121','221','241','302','216')          
                           AND P.cCtaCod NOT IN (SELECT cCtaCodAmp as cCtaCod FROM ColocacAmpliado with(nolock)   WHERE cCtaCod = @cCtaCod          
                                             UNION          
                                                                   SELECT cCtaCodRef FROM ColocacRefinanc with(nolock)  WHERE cCtaCod=@cCtaCod)          
                           AND P.cCtaCod IN (          
                                                            SELECT B.cCtaCod FROM ColocGarantia B WITH (NOLOCK)          
                                                 INNER JOIN Garantias C WITH (NOLOCK) ON B.cNumGarant = C.cNumGarant           
                                                            WHERE B.cCtaCod = P.cCtaCod          
             AND C.nTipoColateralID IN (3,4,5,6,7,8,9)          
                                                      )          
          
          
      UPDATE A          
      SET A.cValorCalculado = CASE WHEN @CntCredHipo > 0 THEN 150000 ELSE 100000 END          
      FROM #DatosEntradaUnPivot A          
      WHERE nIdVariable IN (359)          
    END          
    ELSE          
    BEGIN          
      UPDATE A          
      SET A.cValorCalculado = 100000           
      FROM #DatosEntradaUnPivot A          
      WHERE nIdVariable IN (359)          
    END          
             END          
     END             
              
 BEGIN -- [nIdVariable = (375)]          
  IF  EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (375))          
  BEGIN          
   UPDATE A          
   SET A.cValorCalculado = CASE WHEN @cLineaCred IN (select items from dbo.fn_Split((SELECT nConsSisValor FROM ConstSistema with(nolock)  WHERE nConsSisCod = 9081),',')) THEN '1' ELSE '0' END          
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable IN (375)          
  END          
 END          
          
 BEGIN -- [nIdVariable = (376)]          
  IF  EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (376))          
  BEGIN          
   UPDATE A          
   SET A.cValorCalculado = CASE WHEN (@dFechaActual > (SELECT CONVERT(DATE, nConsSisValor,103)  FROM ConstSistema with(nolock)  WHERE nConsSisCod = 9082)) THEN '0' ELSE '1' END          
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable IN (376)            
  END          
 END           
          
 BEGIN -- [nIdVariable = (377)]          
  IF  EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (377))          
  BEGIN          
   --UPDATE A          
   --SET A.cValorCalculado = CASE WHEN (SELECT COUNT(1) FROM COLOCACIONES.DesembolsoRapidoPersona WHERE cPersIDnro = @cPersIdNro AND IdCampana = @nIdCampana) > 0 THEN '1' ELSE '0' END          
   --FROM #DatosEntradaUnPivot A          
   --WHERE nIdVariable IN (377)          
          
   UPDATE A          
   SET A.cValorCalculado = CASE WHEN @nColocCondicion = 1 OR @nIdCampana = 162 THEN '1' ELSE '0' END          
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable IN (377)          
  END          
 END              
          
 BEGIN -- [nIdVariable = (387)]          
  DECLARE @TablaCalifSF387 TABLE (UltimaCalif INT,cCalSisF INT)          
  DECLARE @nMeses INT = 12          
  IF (@nIdCampana = 161)          
  BEGIN          
   INSERT INTO @TablaCalifSF387          
   SELECT              
     CASE           
      WHEN A.Calif_4 > 0          
        THEN 4          
      WHEN A.Calif_3 > 0          
        THEN 3          
      WHEN A.Calif_2 > 0          
        THEN 2          
    WHEN A.Calif_1 > 0          
        THEN 1          
      ELSE 0          
      END,CASE           
      WHEN A.Calif_4 > 0          
        THEN 4          
      WHEN A.Calif_3 > 0          
        THEN 3          
      WHEN A.Calif_2 > 0          
        THEN 2          
    WHEN A.Calif_1 > 0          
   THEN 1          
      ELSE 0          
      END          
   FROM [DBRCC].DBO.RCCTOTAL A  WITH (NOLOCK)          
   WHERE CONVERT(DATE,A.FEC_REP) = CONVERT(DATE, '20200229')          
    AND Cod_Doc_Id = @cPersIdNro          
          
   INSERT INTO @TablaCalifSF387          
   SELECT              
     CASE           
      WHEN A.Calif_4 > 0          
 THEN 4          
      WHEN A.Calif_3 > 0          
        THEN 3          
      WHEN A.Calif_2 > 0          
        THEN 2          
    WHEN A.Calif_1 > 0          
        THEN 1          
      ELSE 0          
      END,CASE           
      WHEN A.Calif_4 > 0          
        THEN 4          
      WHEN A.Calif_3 > 0          
        THEN 3          
      WHEN A.Calif_2 > 0          
        THEN 2          
    WHEN A.Calif_1 > 0          THEN 1          
      ELSE 0          
      END          
   FROM [DBRCC].DBO.RCCTOTAL A  WITH (NOLOCK)          
   WHERE CONVERT(DATE,A.FEC_REP) = CONVERT(DATE, '20200229')          
    AND Cod_Doc_Trib = @cPersIdNro          
          
  END           
  ELSE          
  BEGIN          
   IF @cPersIdNro <> ''          
   INSERT INTO @TablaCalifSF387 EXEC PA_ObtenCalifHistSF @cPersIdNro,@nMeses          
          
  END          
          
  UPDATE A          
  SET A.cValorCalculado = ISNULL((SELECT TOP 1 ISNULL(cCalSisF,0) FROM @TablaCalifSF387),0) --  SELECT *          
  FROM #DatosEntradaUnPivot A          
  WHERE nIdVariable IN (387)          
          
 END           
           
 BEGIN -- [nIdVariable = (396)]          
  IF  EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (396))          
  BEGIN             
   DECLARE @nMontoMaxTipCli DECIMAL(18,2)          
   SELECT @nMontoMaxTipCli = nMontoMax FROM COLOCACIONES.DesembolsoRapidoPersonaRangoEspecial WHERE cPersIDnro = @cPersIdNro AND IdCampana = @nIdCampana and cFiltro = case when @nIndCasaPropia = 2 then 2 else IIF(@bCasaPropiaoAval=1,1,0) end          
          
   UPDATE A          
   SET A.cValorCalculado = CASE WHEN @nMontoMaxTipCli IS NULL THEN 0 ELSE @nMontoMaxTipCli END          
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable IN (396)            
  END          
 END     
          
 BEGIN -- [nIdVariable = (423)]          
  IF  EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (423))          
  BEGIN          
   UPDATE A          
   SET A.cValorCalculado = CASE WHEN (SELECT COUNT(1) FROM Producto a WITH (NOLOCK)          
                           INNER JOIN ProductoPersona b        WITH (NOLOCK)          
                                     ON a.cCtaCod = b.cCtaCod and nPrdPersRelac = 20          
                           LEFT JOIN ColocProductoComer c WITH (NOLOCK)          
                               on a.cCtaCod=c.cCtaCod          
                           WHERE b.cPersCod = @cPersCodTitular          
                               AND Isnull(c.cSubProducto,SUBSTRING(a.cCtaCod,6,3)) = '302'          
                               AND a.nPrdEstado in (2020,2021,2022,2030,2031,2032)) > 0 THEN '1' ELSE '0' END          
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable IN (423)             
  END          
 END           
           
 BEGIN -- [nIdVariable = (430)]          
  IF  EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (430))          
  BEGIN          
            
   DECLARE @nCreditosReactivaFAE INT = 0        
        
 SELECT         
  @nCreditosReactivaFAE = COUNT(A.cCtaCod)        
 FROM         
  ProductoPersona A     WITH (NOLOCK)    
  INNER JOIN ColocCredCampana B  WITH (NOLOCK)      
   ON B.cCtaCod = A.cCtaCod        
   AND ISNULL(B.IdCampana, 0) IN (160,161,164,168)        
  INNER JOIN Producto C  WITH (NOLOCK)      
   ON C.cCtaCod = A.cCtaCod        
  INNER JOIN PersID D    WITH (NOLOCK)    
   ON D.cPersCod = A.cPersCod        
 WHERE        
  A.nPrdPersRelac = 20        
  AND C.nPrdEstado IN (2020, 2021, 2022, 2030, 2031, 2032)        
  AND D.cPersIDnro = @cPersIdNro        
  AND (ISNULL(B.IdCampana, 0) IN (160,164) OR (ISNULL(B.IdCampana, 0) IN (161,168) AND D.cPersIDnro NOT IN ('48207419','77216982')))        
 GROUP BY A.cCtaCod        
        
 SET @nCreditosReactivaFAE = ISNULL(@nCreditosReactivaFAE, 0)        
        
   IF EXISTS(SELECT 1 FROM Colocaciones.CampanaValPersona A WITH(NOLOCK) WHERE A.IdCampana = 161 AND A.cPersIDnro = @cPersIdNro         
  AND A.nCuotas  = ROUND((((YEAR(@dUltFechaPagoCalen) - YEAR(@dFechaActual)) * 12.0) +(MONTH(@dUltFechaPagoCalen) - MONTH(@dFechaActual))+ ((DAY(@dUltFechaPagoCalen) - DAY(@dFechaActual)) / 30.0)),1)         
  AND A.nPeriodoGracia = ROUND((((YEAR(@dUltFechaPrecuota) - YEAR(@dFechaActual)) * 12.0) +(MONTH(@dUltFechaPrecuota) - MONTH(@dFechaActual))+ ((DAY(@dUltFechaPrecuota) - DAY(@dFechaActual)) / 30.0)),1)        
     AND A.nMoneda = @nMoneda AND A.nMonto = @nMonto AND A.nTasa = @nTCEA AND A.nTasa = (IIF(LEFT(@cLineaCred, 4) = '0230', 12.50, 15.00))  AND @nCreditosReactivaFAE = 0)          
  BEGIN          
    UPDATE A          
    SET A.cValorCalculado = 1          
    FROM #DatosEntradaUnPivot A          
    WHERE nIdVariable IN (430)          
   END          
   ELSE          
   BEGIN           
          
    UPDATE A          
    SET A.cValorCalculado = 0          
    FROM #DatosEntradaUnPivot A          
    WHERE nIdVariable IN (430)          
          
    IF NOT EXISTS(SELECT 1 FROM Colocaciones.CampanaValPersona A with(nolock)  WHERE A.IdCampana = 161 AND A.cPersIDnro = @cPersIdNro)          
    BEGIN          
     SET @cMensajeConfigFAE = 'No existe registro de la configuración para el cliente con DOI: '+ @cPersIdNro          
    END          
    ELSE          
    BEGIN          
     IF @nCreditosReactivaFAE > 0        
  BEGIN        
  SET @cMensajeConfigFAE = CONCAT('El cliente identificado con DOI: ', @cPersIdNro, ' cuenta con créditos garantizados en el marco del programa REACTIVA o FAE ya desembolsados.')        
  END        
  ELSE        
  IF NOT EXISTS(SELECT 1 FROM Colocaciones.CampanaValPersona A with(nolock)  WHERE A.IdCampana = 161 AND A.cPersIDnro = @cPersIdNro AND A.nTasa = (IIF(LEFT(@cLineaCred, 4) = '0230', 12.50, 15.00)))          
     BEGIN          
        SET @cMensajeConfigFAE =  CONCAT('La línea de crédito seleccionada no es la correcta, debe seleccionar aquella línea de crédito con código: ',           
      (SELECT TOP 1                 
       IIF(A.nTasa = 12.50 , '0230', '0231')          
      FROM           
       Colocaciones.CampanaValPersona A           
      WHERE           
      A.IdCampana = 161           
      AND A.cPersIDnro = @cPersIdNro))          
     END          
     ELSE          
     BEGIN          
      SET @cMensajeConfigFAE = CONCAT('El cliente identificado con DOI: ', @cPersIdNro, ' no cumple con las siguiente(s) característica(s):',           
      (SELECT           
       TOP 1          
       CONCAT(          
       IIF(A.nCuotas  = ROUND((((YEAR(@dUltFechaPagoCalen) - YEAR(@dFechaActual)) * 12.0) +(MONTH(@dUltFechaPagoCalen) - MONTH(@dFechaActual))+ ((DAY(@dUltFechaPagoCalen) - DAY(@dFechaActual)) / 30.0)),1), '', CONCAT('el plazo debe ser ', CONVERT(VARCHAR
  
    
    
    
    
      
      
      
        
(MAX), FORMAT(A.nCuotas, 'N1')) ,         
    ' meses y no ', CONVERT(VARCHAR(MAX), FORMAT(ROUND((((YEAR(@dUltFechaPagoCalen) - YEAR(@dFechaActual)) * 12.0) +(MONTH(@dUltFechaPagoCalen) - MONTH(@dFechaActual))+ ((DAY(@dUltFechaPagoCalen) - DAY(@dFechaActual)) / 30.0)),1), 'N1')), ' meses; ')),   
  
    
    
    
    
      
      
      
      
       
       IIF(A.nPeriodoGracia = ROUND((((YEAR(@dUltFechaPrecuota) - YEAR(@dFechaActual)) * 12.0) +(MONTH(@dUltFechaPrecuota) - MONTH(@dFechaActual))+ ((DAY(@dUltFechaPrecuota) - DAY(@dFechaActual)) / 30.0)),1), '', CONCAT('El período de gracia debe ser ', 
	   CONVERT(VARCHAR(MAX), FORMAT(A.nPeriodoGracia, 'N1')),         
    ' meses y no  ', CONVERT(VARCHAR(MAX), FORMAT(ROUND((((YEAR(@dUltFechaPrecuota) - YEAR(@dFechaActual)) * 12.0) +(MONTH(@dUltFechaPrecuota) - MONTH(@dFechaActual))+ ((DAY(@dUltFechaPrecuota) - DAY(@dFechaActual)) / 30.0)),1), 'N1')), ' meses; ')),     
  
    
    
    
    
      
      
      
      
       IIF(A.nMoneda = @nMoneda, '', CONCAT('La moneda debe ser en ', (select S.cConsDescripcion from constante S with(nolock)  where S.nConsCod = 1011 AND S.nConsValor = A.nMoneda), ' y no ', (select       
                                             S.cConsDescripcion       
                                             from constante S with(nolock)        
                                             where S.nConsCod = 1011       
                                             AND S.nConsValor = @nMoneda), '; ')),          
       IIF(A.nMonto = @nMonto, '', CONCAT('El monto del prestamo debe ser ', CONVERT(VARCHAR(MAX), A.nMonto), ' y no ', CONVERT(VARCHAR(MAX), @nMonto), '; ')),           
       IIF(A.nTasa = @nTCEA , '', CONCAT('La tasa de costos efectivo anual debe ser ', CONVERT(VARCHAR(MAX), A.nTasa), ' y no ', CONVERT(VARCHAR(MAX), @nTCEA),'; ')))          
      FROM           
       Colocaciones.CampanaValPersona A   with(nolock)         
      WHERE           
     A.IdCampana = 161           
      AND A.cPersIDnro = @cPersIdNro))          
          
    SET @cMensajeConfigFAE = LEFT(@cMensajeConfigFAE, DATALENGTH(@cMensajeConfigFAE) - 2)          
     END          
    END           
   END             
  END          
 END           
          
 BEGIN -- [nIdVariable = (487)]      
  IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN (487))      
            BEGIN      
      
    DECLARE @nIdVariable171 int = 0      
    declare @nCumpleValidaciones_Reprog int = 0      
   SELECT @nIdVariable171 = ISNULL(@nVigenciaEval,0) FROM #DatosEntradaUnPivot A WHERE nIdVariable =171          
      
    EXEC Colocaciones.FluCre_VerificarClientesCreditos_Cuenta_810937_SP @nIdVariable171,@cPersCodTitular,@nColocCondicion,@nIdCampana,@nCumpleValidaciones_Reprog out,@cMsjCumpleValidaciones_Reprog out      
             
    UPDATE A          
                SET A.cValorCalculado =ISNULL(@nCumpleValidaciones_Reprog,0)          
                FROM #DatosEntradaUnPivot A          
                WHERE nIdVariable = 487        
      
   END      
 END      
        
 BEGIN -- [nIdVariable = (542)]    
  IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(542))    
  BEGIN    
   DECLARE @bCumpleZona BIT = 1    
    
   -- Por agencia de usuario logueado    
   SELECT @bCumpleZona = 0    
   -- SELECT *    
   FROM ZonaAgencia B    
    INNER JOIN Zona C ON B.cCodZona = C.cCodZona    
   WHERE    
    B.cCodAge = @cAgeCod    
    AND RIGHT(C.cDesZona, 1) IN ('3', '5')    
    
   -- Por agencia de crédito    
   SELECT    
    @bCumpleZona = 0    
   -- SELECT *    
   FROM ZonaAgencia B    
    INNER JOIN Zona C ON B.cCodZona = C.cCodZona    
   WHERE     
	B.cCodAge = @cAgeCodCredito
    AND RIGHT(C.cDesZona, 1) IN ('3', '5')    
    
   UPDATE A          
   SET A.cValorCalculado = CONVERT(VARCHAR, @bCumpleZona)          
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable = 542    
  END    
 END    
    
 BEGIN -- [nIdVariable = (543)]    
  IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(543))    
  BEGIN    
   DECLARE @nNumCredProgGob INT = 0    
    
   SELECT @nNumCredProgGob = COUNT(P.cCtaCod)    
   FROM ProductoPersona PP WITH(NOLOCK)    
    INNER JOIN Producto P  WITH(NOLOCK)    
     ON PP.cCtaCod = P.cCtaCod    
    INNER JOIN COLOCACIONES.FondoCredito FC WITH(NOLOCK)    
     ON FC.cCtaCod = P.cCtaCod    
   WHERE    
    PP.cPersCod = @cPersCodTitular AND PP.nPrdPersRelac = 20    
    AND P.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2101,2104,2106,2107,2201,2205,2202,2206) -- se incluye castigados    
    AND FC.nEstado = 2    
    
   UPDATE A          
   SET A.cValorCalculado = CONVERT(VARCHAR, @nNumCredProgGob)          
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable = 543    
  END    
 END    
    
 BEGIN -- [nIdVariable = (555)]    
  IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable IN(555))    
  BEGIN            
   DECLARE @nEstadodps INT = 0    
    
   SELECT @nEstadodps=nEstado         
   FROM COLOCACIONES.RespuestaDetalleDPS WITH (NOLOCK)          
   WHERE cCtaCod = @cCtaCod       
    
   UPDATE A          
   SET A.cValorCalculado =@nEstadodps          
   FROM #DatosEntradaUnPivot A          
   WHERE nIdVariable = 555    
  END    
 END     
      
END          
           
BEGIN --     Calculo de Variables TIPO MENSAJE        
      
 BEGIN -- [nIdVariable = (488)]      
  IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable IN (488))      
            BEGIN      
    UPDATE A          
                SET A.cValorCalculado = ISNULL(@cMsjCumpleValidaciones_Reprog, '')      
                FROM #VariablesMensaje A          
                WHERE nIdVariable = 488      
      
   END      
 END        
                 
       BEGIN -- [nIdVariable = 13]          
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 13)          
           BEGIN          
                    SET @cCtaCodReajusteRecup = ''          
          
                    SELECT           
                          @cCtaCodReajusteRecup = @cCtaCodReajusteRecup + MC.cCtaCod +  ','          
                    FROM movcol MC      WITH (NOLOCK)          
                           INNER JOIN MOV  M   WITH (NOLOCK)          
                                  ON MC.nMovNro = M.nMovNro          
                           INNER JOIN Producto P WITH (NOLOCK)          
                                  ON MC.cCtaCod = P.cCtaCod          
                           INNER JOIN ProductoPersona PP       WITH (NOLOCK)          
      ON P.cCtaCod = PP.cCtaCod           
                                        AND PP.nPrdPersRelac =20          
                    WHERE PP.cPersCod  =@cPersCodTitular          
                           AND M.cOpeCod IN ('130602','130600','130601','130603')          
                           AND M.nMovFlag = 0          
                              
                    IF LEN(@cCtaCodReajusteRecup) > 0          
                           SET @cCtaCodReajusteRecup = SUBSTRING(@cCtaCodReajusteRecup, 1, LEN(@cCtaCodReajusteRecup) - 1)                   
                              
          
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR(1000), @cCtaCodReajusteRecup)          
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable = 13          
          
             END              
       END           
          
       BEGIN -- [nIdVariable = 14]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 14)          
             BEGIN          
                    SET @cCtaCodExoIntGas = ''          
          
                    SELECT           
                           @cCtaCodExoIntGas  = @cCtaCodExoIntGas + MC.cCtaCod + ','          
                    FROM MovColdet MC   WITH (NOLOCK)          
                           INNER JOIN MOV  M   WITH (NOLOCK)          
          ON MC.nMovNro = M.nMovNro          
                           INNER JOIN Producto P WITH (NOLOCK)          
                                  ON MC.cCtaCod = P.cCtaCod          
                           INNER JOIN ProductoPersona PP WITH (NOLOCK)          
                                  ON P.cCtaCod = PP.cCtaCod           
                                        AND PP.nPrdPersRelac =20          
                    WHERE PP.cPersCod  = @cPersCodTitular          
                           AND CONVERT(DATE,LEFT(M.cMovNro, 8)) >= '2014-07-01' --ingresan a partir del mes de Julio 2014          
                   AND M.nMovFlag = 0          
                           AND DATEADD(YEAR, 2, CONVERT(DATE,LEFT(M.cMovNro, 8))) > @dFechaActual  --No es sujeto de crédito en un periodo de 02 años         
AND MC.cOpeCod='101310'          
                           AND (mc.nPrdConceptoCod IN ('1100','1101')          
                                  OR mc.nPrdConceptoCod IN (SELECT a.nPrdConceptoCod FROM ColocTExoDetGas a WHERE a.bConEstado=1 ))          
          
                    IF LEN(@cCtaCodExoIntGas) > 0          
                           SET @cCtaCodExoIntGas = SUBSTRING(@cCtaCodExoIntGas, 1, LEN(@cCtaCodExoIntGas) - 1)          
                       
                    UPDATE A          
                    SET A.cValorCalculado = CONVERT(VARCHAR(1000), @cCtaCodExoIntGas)          
            FROM #VariablesMensaje A          
             WHERE nIdVariable = 14          
             END              
       END           
                 
       BEGIN -- [nIdVariable = 78]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 78)          
             BEGIN                         
                                      
                    UPDATE A          
                    SET A.cValorCalculado = @cNombreGarantExc          
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable = 78          
                    
    END          
       END          
          
       BEGIN -- [nIdVariable = 80]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 78)          
             BEGIN            
                    UPDATE A          
                    SET A.cValorCalculado = @nPorcentMercado          
                    FROM #VariablesMensaje A          
              WHERE nIdVariable = 80          
             END          
     END          
                 
       BEGIN -- [nIdVariable = (85,86)]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable IN (85,86))          
             BEGIN            
                              
                    UPDATE A          
                    SET A.cValorCalculado = (CASE WHEN nIdVariable=85 THEN           
                                                                     ISNULL((SELECT top 1 cPersNombre FROM #RelPersonaEdad X WHERE nTipoEval=(SELECT MIN(nTipoEval) FROM #RelPersonaEdad) ORDER BY nPersRelac ),'')          
                                                    WHEN nIdVariable=86 THEN           
                                                                     ISNULL((SELECT top 1 cRelacion FROM #RelPersonaEdad  Z WHERE nTipoEval=(SELECT MIN(nTipoEval) FROM #RelPersonaEdad) ORDER BY nPersRelac ),'')          
                                                            END)          
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable IN (85,86)          
             END          
     END          
          
       BEGIN -- [nIdVariable = 95]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 95)          
             BEGIN          
                    UPDATE A          
                    SET A.cValorCalculado = (SELECT CONVERT(DECIMAL(18,2),nParamValor) from COLOCPARAMETRO WHERE nParamVar = '3053')          
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable =95          
             END          
     END          
           
       BEGIN -- [nIdVariable = 106,107,108]           
          IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable IN(106,107,108))          
          BEGIN               
               UPDATE A          
               SET A.cValorCalculado = CASE           
                                 WHEN A.nIdVariable = 106 THEN ISNULL(@cCredDescOA,'')          
                                                      WHEN A.nIdVariable = 107 THEN ISNULL(@cAgeDescOA,'')          
                                                      WHEN A.nIdVariable = 108 THEN ISNULL(@cCtaCodOA,'')          
                                               END          
               FROM #VariablesMensaje A          
               WHERE nIdVariable IN(106,107,108)          
          END          
    END          
         
 BEGIN -- [nIdVariable = 110]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 110)          
             BEGIN          
                    DECLARE @PersRelacAtraso VARCHAR(500)          
                    set @PersRelacAtraso=''          
          
                    SELECT @PersRelacAtraso = @PersRelacAtraso +('La persona ' + cPersnombre + ' está vinculada al crédito ' + cCtaCod + ' como ' + cRelacion + ' con ' +  convert(varchar(5),nDiasatraso) +' dia(s) de atraso.' ) + CHAR(13)          
                    FROM #PersonaRelacDiasatraso          
                              
                    UPDATE A          
                    SET A.cValorCalculado = @PersRelacAtraso          
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable = 110          
             END          
     END          
          
       BEGIN -- [nIdVariable = 122,123]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable IN (122,123))          
             BEGIN          
                    
                    UPDATE A          
                           SET A.cValorCalculado = @cMensajeh6m          
             FROM #VariablesMensaje A          
                    WHERE nIdVariable = 122          
          
                 UPDATE A          
    SET A.cValorCalculado = @cMensajeNegocioh6m          
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable = 123          
             END          
     END          
            
       BEGIN -- [nIdVariable = 130]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 130)          
             BEGIN                   
                              
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@cMsjLimGloIndCredDirTra,'')          
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable = 130          
             END          
     END          
            
       BEGIN -- [nIdVariable = 133]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 133)          
             BEGIN                   
                            
                    UPDATE A          
                    SET A.cValorCalculado = (SELECT cConsDescripcion FROM Constante WHERE nConsCod=1011 AND nConsValor=@nMoneda)          
            FROM #VariablesMensaje A          
                    WHERE nIdVariable = 133          
             END          
     END          
          
       BEGIN -- [nIdVariable = 151]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 151)          
             BEGIN                         
                              
                    UPDATE A          
                    SET A.cValorCalculado = @cMensajeReg27          
                    FROM #VariablesMensaje A          
                 WHERE nIdVariable = 151     
             END          
     END          
          
       BEGIN -- [nIdVariable = 188]           
             IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 188)          
             BEGIN                         
                              
                    UPDATE A          
                    SET A.cValorCalculado = (SELECT cConsDescripcion FROM Constante WHERE nConsCod=1011 AND nConsValor = @nMonedaConfigCampana)          
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable = 188          
             END          
     END          
            
       BEGIN -- [nIdVariable = (190)]          
         IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 190)          
             BEGIN          
          
                    SET @cCampana = (SELECT ISNULL(cDescripcion, '') FROM Campanas WHERE IdCampana = @nIdCampana)          
          
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@cCampana, '') -- SELECT  *           
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable = 190          
             END          
     END          
          
       BEGIN -- [nIdVariable = (193)]          
         IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 193)          
             BEGIN          
          
             DECLARE           
                    @cProductoSolicitado VARCHAR(200) = ''          
          
                    SET @cProductoSolicitado = (SELECT ISNULL(cDescripcion, '') FROM CredProductos WHERE cCredProductos = @cCredProducto)          
          
 UPDATE A          
                    SET A.cValorCalculado = ISNULL(@cProductoSolicitado, '') -- SELECT  *           
                    FROM #VariablesMensaje A          
                    WHERE nIdVariable = 193          
             END          
     END          
           
 BEGIN -- [nIdVariable = (431)]          
         IF EXISTS(SELECT nIdVariable FROM #VariablesMensaje WHERE nIdVariable = 431)          
             BEGIN          
          
                       
                    UPDATE A          
                    SET A.cValorCalculado = ISNULL(@cMensajeConfigFAE, '') -- SELECT  *           
                 FROM #VariablesMensaje A          
      WHERE nIdVariable = 431          
             END          
     END          
END      
    
    
  BEGIN -- [nIdVariable = (528)]          
   IF EXISTS(SELECT nIdVariable FROM #DatosEntradaUnPivot WHERE nIdVariable =528)          
    
    BEGIN    
    --select 'PRUEBA'    
     CREATE TABLE #MontoTotalProducto    
     (          
      cPersCodTitular VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS,      
      nMontoSol DECIMAL(18,2),    
     )      
         
     CREATE TABLE #AplicaMontoExposicion    
     (      
      cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS,      
      bMontoExpoPersonalDirecto INT DEFAULT(0),    
     );    
    
     BEGIN    
      INSERT INTO #AplicaMontoExposicion (cCtaCod, bMontoExpoPersonalDirecto/*, nSaldo*/)      
      SELECT A.cCtaCod,    
      SUM(CASE    
       WHEN nTipoColateralID IN (18) THEN 1    
       ELSE 0    
       END) AS bMontoExpoPersonalDirecto    
    
      --SUM(ISNULL(A.nSaldo,0))    
      FROM Producto A WITH (NOLOCK)    
      INNER JOIN ColocGarantia CG WITH (NOLOCK)    
      ON A.cCtaCod = CG.cCtaCod    
      INNER JOIN Garantias Gar WITH (NOLOCK)    
      ON CG.cNumGarant = Gar.cNumGarant    
      --INNER JOIN ProductoPersona B WITH (NOLOCK)    
      --ON A.cCtaCod=B.cCtaCod AND B.nPrdPersRelac = 20    
      --INNER JOIN #MontoTotalProducto C WITH (NOLOCK)    
      --ON C.cPersCodTitular=B.cPersCod    
      WHERE /*B.cPersCod = C.cPersCodTitular AND*/ A.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)    
      AND A.cAgeCod IN ('304')    
      AND SUBSTRING (A.cCtaCod,9,1) IN ('1')    
      --IN (2020,2021,2022,2030,2031,2032,2201,2205,2101,2104,2106,2107,2202,2206)    
      --AND A.cCtaCod NOT IN (SELECT cPersCodTitular FROM #MontoTotalProducto)),0) + (SELECT nMontoSol FROM #MontoTotalProducto)) > 100000.00    
      GROUP BY A.cCtaCod    
    
      IF @cCredProducto IN ('304')    
      BEGIN    
      INSERT INTO #MontoTotalProducto(cPersCodTitular,nMontoSol)    
      SELECT    
      PP.cPersCod,    
      nSaldo = SUM(CASE    
         WHEN @nMoneda='1' THEN (CASE    
             WHEN Substring(P.cCtaCod,9,1)='1' THEN P.nSaldo    
             ELSE P.nSaldo*@tipoCambio    
             END)    
         ELSE (CASE    
          WHEN SUBSTRING(P.cCtaCod,9,1)='1'    
          THEN P.nSaldo/@tipoCambio    
          ELSE P.nSaldo    
          END)    
         END)    
      FROM Producto P  WITH (NOLOCK)    
      JOIN ProductoPersona PP WITH (NOLOCK)    
      ON P.cCtaCod = PP.cCtaCod    
      AND PP.nPrdPersRelac = 20    
      LEFT JOIN #AplicaMontoExposicion A    
      ON P.cCtaCod = A.cCtaCod    
      WHERE PP.cPersCod = @cPersCodTitular    
      AND PP.cPersCod = @cPersCodTitular AND P.nPrdEstado IN (2020,2021,2022,2030,2031,2032,2201,2205)    
      AND SUBSTRING(p.cctacod,6,3) IN ('304')    
      AND A.bMontoExpoPersonalDirecto = 1    
      AND P.cCtaCod NOT IN (SELECT    
      cCtaCodRen AS cCtaCod    
      FROM ColocRenovacion X    
      WHERE X.cCtaCod=@cCtaCod)    
      GROUP BY PP.cPersCod    
    
      END    
     END    
    
     SET @nMontoTotalDeuda=(SELECT SUM(nMontoSol) FROM #MontoTotalProducto)    
     SET @nMontoTotalDeuda = (CASE    
     WHEN @nMoneda=2    
     THEN ROUND(ISNULL(@nMontoTotalDeuda,0)/@tipoCambio,2)    
     ELSE ROUND(ISNULL(@nMontoTotalDeuda,0),2) END) + (CASE    
      WHEN @nMoneda=2    
      THEN ROUND(@nMonto/@tipoCambio,2)    
      ELSE @nMonto END)    
    
     SELECT    
     @nSaldoCubierto = ISNULL(SUM(CASE WHEN @nMoneda=1 THEN A.nMontoConG ELSE A.nMontoConG*@tipoCambio END),0)    
     FROM #CreditosNoCoberturados A    
    
     UPDATE A    
     SET A.cValorCalculado = ISNULL(@nMontoTotalDeuda,0) - @nSaldoCubierto    
     FROM #DatosEntradaUnPivot A    
     WHERE nIdVariable =528    
         
     DROP TABLE #MontoTotalProducto    
     DROP TABLE #AplicaMontoExposicion    
         
           END            
      END     
          
--select * from #DatosEntradaUnPivot          
--SELECT * FROM #VariablesMensaje          
          
BEGIN --Agregando Campos Validos e insertando los valores de los datos de entrada          
          
       DECLARE           
             @cSqlQuery NVARCHAR(MAX) = '',          
             @cColumnas NVARCHAR(MAX) = ''          
      
       SELECT           
             @cSqlQuery = @cSqlQuery +           
                    N'ALTER TABLE #DatosEntrada ' +          
                    N'ADD ' +           
                    cSQLNombreColumna + N' ' +           
                    cSQLTipoDato +           
                    CASE           
                           WHEN ISNULL(cSQLCollate, '') <> '' THEN   N' COLLATE ' + cSQLCollate          
                           ELSE ' '           
                    END +          
            CASE          
                           WHEN bSQLPermiteNulos = 1 THEN N' NULL'          
                           ELSE N' NOT NULL'           
                    END +          
                    N' ; '          
       FROM #DatosEntradaUnPivot          
       ORDER BY nIdVariable --Ojo es el mismo orden          
          
       --SELECT @cSqlQuery cSqlQuery          
            
                             
       EXECUTE sp_executesql @cSqlQuery          
               
          
       ----------------------------------------------------------------------------------------          
      
      
       SELECT           
             @cColumnas =  COALESCE(@cColumnas + '[' + cSQLNombreColumna + '],', '')          
       FROM #DatosEntradaUnPivot          
       ORDER BY nIdVariable --Ojo es el mismo orden          
          
       SET @cColumnas = LEFT(@cColumnas, LEN(@cColumnas) - 1)             
          
       SET @cSqlQuery = N'          
       INSERT INTO #DatosEntrada( cNombreEmpresa, ' + @cColumnas + ')' +          
       'SELECT ''CMACICA S.A.'', ' + @cColumnas +           
       'FROM          
 (SELECT cSQLNombreColumna, cValorCalculado          
             FROM #DatosEntradaUnPivot) AS SourceTable          
       PIVOT          
       ( MIN(cValorCalculado)          
       FOR cSQLNombreColumna IN (' + @cColumnas + ')          
       ) AS PivotTable;'          
          
       EXECUTE sp_executesql @cSqlQuery          
    
END          
          
BEGIN --========= ASIGNANDO VALORES CALCULADOS =========          
          
    UPDATE A          
    SET A.cValorCalculado = B.cValorCalculado          
    FROM #ReglaCasoDetalle A          
           INNER JOIN #DatosEntradaUnPivot B          
                 ON A.nIdVariable = B.nIdVariable           
          
END          
          
EXEC Colocaciones.FluGen_EjecutarMotorDecisiones_SP          
          
--Detalle Mensaje                                 
INSERT INTO #MensajeDetalleConfig (nIdMensajeConfig, nIdVariable, nOrden, cValorCalculado)          
SELECT           
       A.nIdMensajeConfig,          
       B.nIdVariable,          
       ROW_NUMBER() OVER(PARTITION BY A.nIdMensajeConfig ORDER BY B.nIdVariable ASC) AS nOrden,          
       CASE          
             WHEN Z.nTipo = 2 THEN  ISNULL(C.cValorCalculado,(SELECT cValorCalculado FROM #DatosEntradaUnPivot WHERE nIdVariable=Z.nIdVariable))          
             WHEN Z.nTipo = 3 THEN  D.cValorCalculado          
       END            
FROM #MensajeReglaConfig A          
       INNER JOIN Colocaciones.MensajeDetalleConfig B  with(nolock)         
             ON A.nIdMensajeConfig = B.nIdMensajeConfig          
       INNER JOIN Colocaciones.Variable Z  with(nolock)         
             ON B.nIdVariable = Z.nIdVariable          
       LEFT JOIN #ReglaCasoDetalle C          
             ON C.nIdRegla = A.nIdRegla          
                    AND C.nIdCaso = A.nIdCaso          
                    AND C.nIdVariable = B.nIdVariable          
                    AND Z.nTipo = 2          
       LEFT JOIN #VariablesMensaje D          
             ON B.nIdVariable = D.nIdVariable          
     AND Z.nTipo = 3          
WHERE B.bActivo = 1           
      
EXEC Colocaciones.FluGen_MensajePersonalizado_SP          
          
SALIR:          
    --SELECT           
          -- @cPersCodTitular     cPersCodTitular     ,          
          -- @cCtaCod                    cCtaCod                    ,          
          -- @cPersIdNro          cPersIdNro          ,          
          -- @cAgeCod                    cAgeCod                              
          
--select * from #ReglaCaso          
                  
SELECT A.nOrden          
  ,A.nIdGrupo          
       ,A.nIdRegla          
       ,A.nIdCaso          
       ,C.cDescripcion          
  ,A.bResultado AS bAplicaRegla          
       ,B.bResultado As bAprueba          
       ,cMensaje=(CASE WHEN A.bResultado=0 THEN '' ELSE  ISNULL(D.cMensaje,'') END)          
       ,D.nTipoValidacion          
    INTO #CONSOLIDADO          
FROM #ReglaCaso A          
    INNER JOIN #ReglaCaso B          
          ON A.nIdRegla=B.nIdRegla          
            AND A.nIdCaso=B.nIdCaso          
    INNER JOIN Colocaciones.Regla C  with(nolock)         
          ON C.nIdRegla=A.nIdRegla          
    LEFT JOIN #MensajeReglaConfig D          
          ON A.nIdGrupo = D.nIdGrupo          
               AND D.nIdRegla=A.nIdRegla          
               AND D.nIdCaso=A.nIdCaso          
WHERE A.cTipoEvaluacion='C' AND B.cTipoEvaluacion='V'          
         
    UPDATE A          
          SET A.bAplicaRegla=0          
            ,A.bAprueba=0          
FROM #CONSOLIDADO A          
WHERE A.nIdRegla=26          
          

    UPDATE A          
          SET A.bAplicaRegla=0          
               ,A.bAprueba=0          
    FROM #CONSOLIDADO A          
    INNER JOIN #ReglaNegEquiv B          
          ON A.nIdRegla=B.nIdRegla          
    INNER JOIN RegValidacion C          
          ON C.nCodAlinea=B.nCodAlinea          
    WHERE C.cCtacod=@cCtaCod AND nNumRefinanciacion=@nNumRefinan AND @nEtapa=3 AND C.nEstadoValid=3          
          
	SELECT nOrden,A.nIdGrupo,A.nIdRegla,nIdCaso,A.cDescripcion,bAplicaRegla,bAprueba,cMensaje, nTipoValidacion --,B.nIdGrupo,B.nIdRegla,C.nIdRegla,C.cDescripcion          
    INTO #ReglaNoAplica          
    FROM #CONSOLIDADO A                  
    WHERE nIdRegla NOT IN (select nIdRegla from #CONSOLIDADO WHERE bAplicaRegla=1)          
          
    SELECT nIdGrupo,nIdRegla,nIdCaso,cDescripcion,bAplicaRegla,bAprueba,cMensaje, nTipoValidacion            
    INTO #ReglasDesaprobadas          
    FROM #CONSOLIDADO  A       
    WHERE bAplicaRegla=1 AND bAprueba=0          
              
    UPDATE A          
          SET A.cMensaje=''          
    FROM #ReglaNoAplica A          
    WHERE bAplicaRegla=0          
              
    UPDATE A          
 SET A.cMensaje=''          
    FROM #CONSOLIDADO A          
    WHERE A.nIdRegla NOT IN (SELECT nIdRegla FROM #ReglasDesaprobadas)          
          
    DECLARE @ApruebaRegla40AlineaSict INT          
    SELECT @ApruebaRegla40AlineaSict=SUM(CASE WHEN bAprueba=1 THEN 1 ELSE 0 END ) FROM #CONSOLIDADO WHERE nIdRegla=34          
    set @ApruebaRegla40AlineaSict=isnull(@ApruebaRegla40AlineaSict,0)          
        
  /********************* EXCEPCION POR CONSTANTE *****************************/      
      
   DECLARE @cConstSistemaExcep VARCHAR(MAX)=''      
 SELECT @cConstSistemaExcep = RTRIM( LTRIM( nConsSisValor )) From constsistema Where nConsSisCod = 666      
      
 DECLARE @tbExcep TABLE      
 (      
  cPersCod VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS,      
  cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS,      
  nIdRegla INT NOT NULL,      
  nIdCaso INT NOT NULL      
 )      
      
 INSERT INTO @tbExcep (cPersCod, cCtaCod, nIdRegla, nIdCaso)      
 SELECT      
  CASE      
   WHEN LEN(LEFT(RTRIM( LTRIM( Items )), CHARINDEX(',', RTRIM( LTRIM( Items ))) - 1)) = 13      
   THEN LEFT(RTRIM( LTRIM( Items )), CHARINDEX(',', RTRIM( LTRIM( Items ))) - 1)      
   ELSE  NULL      
  END,      
  CASE      
   WHEN LEN(LEFT(RTRIM( LTRIM( Items )), CHARINDEX(',', RTRIM( LTRIM( Items ))) - 1)) = 18      
   THEN LEFT(RTRIM( LTRIM( Items )), CHARINDEX(',', RTRIM( LTRIM( Items ))) - 1)      
   ELSE  NULL      
  END,      
  LEFT(RIGHT(RTRIM( LTRIM( Items )), LEN(RTRIM( LTRIM( Items ))) - CHARINDEX(',', RTRIM( LTRIM( Items )))), CHARINDEX(',', RIGHT(RTRIM( LTRIM( Items )), LEN(RTRIM( LTRIM( Items ))) - CHARINDEX(',', RTRIM( LTRIM( Items ))))) - 1),      
  RIGHT(RIGHT(RTRIM( LTRIM( Items )), LEN(RTRIM( LTRIM( Items ))) - CHARINDEX(',', RTRIM( LTRIM( Items )))), LEN(RIGHT(RTRIM( LTRIM( Items )), LEN(RTRIM( LTRIM( Items ))) - CHARINDEX(',', RTRIM( LTRIM( Items ))))) - CHARINDEX(',', RIGHT(RTRIM( LTRIM( Items )), LEN(RTRIM( LTRIM( Items ))) - CHARINDEX(',', RTRIM( LTRIM( Items ))))))      
 FROM      
  dbo.fn_Split(@cConstSistemaExcep, ';') A      
 WHERE      
  ISNULL(@cConstSistemaExcep, '') <> '' -- No vacíos      
  AND LEN(RTRIM( LTRIM( A.Items ))) - LEN(REPLACE(RTRIM( LTRIM( A.Items )), ',', '')) = 2 -- Debe contener almenos 3 datos      
      
      
  /****************************************************************************/      
      
      
IF @nEtapa = 15           
BEGIN          
 INSERT INTO #Regla (nIdGrupo,nIdRegla,nIdCaso,cDescripcion,bAplicaRegla,bAprueba,cMensaje,cExcepcion,nTipoValidacion)          
 SELECT           
  nIdGrupo,          
  A.nIdRegla,          
  A.nIdCaso,          
  A.cDescripcion,          
  bAplicaRegla,          
  bAprueba=(CASE WHEN A.nIdRegla=34 AND @ApruebaRegla40AlineaSict>0 THEN 1 WHEN isnull(D.cPersCod , '') <> '' or isnull(D.cCtaCod , '') <> ''   then 1   ELSE A.bAprueba END),          
  cMensaje = (CASE  WHEN isnull(D.cPersCod , '') <> '' or isnull(D.cCtaCod , '') <> ''  then ''    ELSE cMensaje END)   ,                
  cExcepcion=(CASE WHEN C.cCondiValid=1 THEN 'No permite Excepción' WHEN C.cCondiValid=2 THEN 'Permite Excepción' ELSE '' END),           
  nTipoValidacion          
 FROM           
  (          
   SELECT           
    nIdGrupo,nIdRegla,nIdCaso,cDescripcion,bAplicaRegla,bAprueba,cMensaje, nTipoValidacion          
   FROM           
    #ReglaNoAplica A          
   WHERE           
    nIdCaso=(SELECT MIN(nIdCaso) FROM #ReglaNoAplica WHERE nIdRegla=A.nIdRegla)          
   UNION ALL          
   SELECT           
    nIdGrupo,nIdRegla,nIdCaso,cDescripcion,bAplicaRegla,bAprueba,cMensaje, nTipoValidacion           
   FROM           
    #ReglasDesaprobadas A          
   WHERE           
    nIdCaso=(SELECT MIN(nIdCaso) FROM #ReglasDesaprobadas WHERE nIdRegla=A.nIdRegla)          
   UNION ALL          
   SELECT           
    nIdGrupo,nIdRegla,nIdCaso,cDescripcion,bAplicaRegla,bAprueba,cMensaje, nTipoValidacion           
   FROM           
    #CONSOLIDADO A          
   WHERE           
    bAplicaRegla=1           
    AND nIdRegla NOT IN (SELECT nIdRegla FROM #ReglasDesaprobadas)          
    AND nIdCaso=(SELECT MIN(nIdCaso) FROM #CONSOLIDADO WHERE nIdRegla=A.nIdRegla AND bAplicaRegla=A.bAplicaRegla)          
  ) A           
  LEFT JOIN #ReglaNegEquiv B ON A.nIdRegla=B.nIdRegla          
  LEFT JOIN AlineaSICMACT C WITH(NOLOCK) ON C.nCodAlinea=B.nCodAlinea      
  LEFT JOIN @tbExcep D ON  D.nIdCaso = A.nIdCaso and D.nIdRegla = A.nIdRegla   and  (   D.cCtaCod = isnull(@cCtaCod , '') OR D.cPersCod = isnull(@cPersCodTitular , '') )      
 ORDER BY           
  A.nIdRegla          
          
END          
ELSE          
BEGIN          
	SELECT 
		nIdGrupo,
		A.nIdRegla,
		A.nIdCaso,
		A.cDescripcion,
		bAplicaRegla,
		bAprueba = (CASE
						WHEN A.nIdRegla = 34
							AND @ApruebaRegla40AlineaSict > 0 THEN
							1
						WHEN isnull(D.cPersCod, '') <> ''
							or isnull(D.cCtaCod, '') <> '' then
							1
						ELSE
							A.bAprueba
					END
					),
		cMensaje = (CASE
						WHEN isnull(D.cPersCod, '') <> ''
							or isnull(D.cCtaCod, '') <> '' then
							''
						ELSE
							cMensaje
					END
					),
		cExcepcion = (CASE
							WHEN C.cCondiValid = 1 THEN
								'No permite Excepción'
							WHEN C.cCondiValid = 2 THEN
								'Permite Excepción'
							ELSE
								''
						END
					),
		nTipoValidacion
	FROM
		(
			-- Regla que no aplica
			SELECT nIdGrupo,
				   nIdRegla,
				   nIdCaso,
				   cDescripcion,
				   bAplicaRegla,
				   bAprueba,
				   cMensaje,
				   nTipoValidacion
			FROM #ReglaNoAplica A
			WHERE nIdCaso =
				(
					SELECT MIN(nIdCaso) FROM #ReglaNoAplica WHERE nIdRegla = A.nIdRegla
				)
			UNION ALL
			-- Regla que desaprueba
			SELECT nIdGrupo,
				   nIdRegla,
				   nIdCaso,
				   cDescripcion,
				   bAplicaRegla,
				   bAprueba,
				   cMensaje,
				   nTipoValidacion
			FROM #ReglasDesaprobadas A
			WHERE nIdCaso =
				(
					SELECT MIN(nIdCaso) FROM #ReglasDesaprobadas WHERE nIdRegla = A.nIdRegla
				)
			UNION ALL
			-- Regla que aprueba
			SELECT nIdGrupo,
				   nIdRegla,
				   nIdCaso,
				   cDescripcion,
				   bAplicaRegla,
				   bAprueba,
				   cMensaje,
				   nTipoValidacion
			FROM #CONSOLIDADO A
			WHERE bAplicaRegla = 1
				  AND nIdRegla NOT IN (
										  SELECT nIdRegla FROM #ReglasDesaprobadas
									  )
				  AND nIdCaso =
				  (
					  SELECT MIN(nIdCaso)
					  FROM #CONSOLIDADO
					  WHERE nIdRegla = A.nIdRegla
							AND bAplicaRegla = A.bAplicaRegla
				  )
		) A
		LEFT JOIN #ReglaNegEquiv B
			ON A.nIdRegla = B.nIdRegla
		LEFT JOIN AlineaSICMACT C WITH (NOLOCK)
			ON C.nCodAlinea = B.nCodAlinea
		LEFT JOIN @tbExcep D
			ON D.nIdCaso = A.nIdCaso
			   and D.nIdRegla = A.nIdRegla
			   and (
					   D.cCtaCod = isnull(@cCtaCod, '')
					   OR D.cPersCod = isnull(@cPersCodTitular, '')
				   )
	ORDER BY A.nIdRegla        
END          
DROP TABLE  #GrupoEvaluacion, #IteracionCaso, #ReglaCasoDetalle, #DatosEntradaUnPivot, #MensajeReglaConfig, #MensajeDetalleConfig, #VariablesMensaje,#ReglaCasoConfig,#tipocreditos,#PersonaRelacionCred          
DROP TABLE #ReglasExcep,#FTeIndependiente,#FTeDependiente,#PersonaRelacDiasatraso,#CreditosProcesar,#CONSOLIDADO,#DatosEntrada,#ReglaCaso,#ConsolAlineaRiesgoCrediticioDia,#GarantiaCredito,#RelPersonaEdad          
DROP TABLE #ReglaNegEquiv,#mumCredt,#ReglaNoAplica,#ReglasDesaprobadas,#TCreditosVigentes          
          
SET NOCOUNT OFF          
END 
