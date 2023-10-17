/*      
----------------------------------------------------------------------------------------------------------------------      
PROPOSITO | STORE PROCEDURE  Que inserta la propuesta de crédito      
----------------------------------------------------------------------------------------------------------------------      
  
----------------------------------------------------------------------------------------------------------------------      
HISTORIAL DE FECHA      
      
  CAMBIOS RESPONSABLE   MOTIVO       
---------- ------------------- -------------------------------------------------------------------------------------      
    
EJEMPLO  :      
DECLARE @cMensajeError NVARCHAR(MAX),@nNroError int,@cCtaCod VARCHAR(18)='',@cCodSolicitud VARCHAR(20)      
EXEC COLOCACIONES.FluGenSol_InsPropuesta_SP       
''      
,@nNroError OUTPUT ,@cMensajeError OUTPUT, @cCtaCod OUTPUT,@cCodSolicitud OUTPUT      
SELECT @nNroError,@cMensajeError,@cCtaCod,@cCodSolicitud      
----------------------------------------------------------------------------------------------------------------------      
----------------------------------------------------------------------------------------------------------------------      
**/      
      
ALTER PROC COLOCACIONES.FluGenSol_InsPropuesta_SP      
(       
  @xPropuesta XML,      
  @nCodError INT = 0 OUTPUT,      
  @cCodError  VARCHAR(MAX) ='' OUTPUT ,      
  @cCtaCod VARCHAR(18)='' OUTPUT,      
  @cCodSolicitud VARCHAR(20)='' OUTPUT,      
  @nCodSolicitud BIGINT = 0 OUTPUT      
)      
AS      
BEGIN      
 SET NOCOUNT ON      
       
 DECLARE @bInsError BIT = 1      
 SET @nCodError = 0      
 SET @cCodError = ''      
 DECLARE           
    @cMovNumero     VARCHAR(25),     
    @dFechaSolicitud    DATETIME = GETDATE(),     
    @dFechaVisita    DATE,     
    @cCredProductoCta    VARCHAR(3),     
    @cNumPolizaMSAP     VARCHAR(12)='' ,     
    @cNumPolizaMSVS     VARCHAR(12)='' ,     
    @cNumPolizaSegD     VARCHAR(12)='' ,     
    @cNumPolizaSegA     VARCHAR(12)='' ,    
    @cUser      VARCHAR(4),      
    @cAgeCod     VARCHAR(2),      
    @nCodMoneda     INT,      
    @bPermiteInsertarActualizarSolicitud BIT      
      
 SET @dFechaSolicitud=CONVERT(DATETIME,(CONVERT(VARCHAR,(SELECT CONVERT(DATE,nConsSisValor,103) FROM ConstSistema (NOLOCK) WHERE nConsSisCod = 16)) + ' ' + CONVERT(VARCHAR(10),GETDATE(),108)))      
      
 DECLARE @nestado INT      
 DECLARE @cperscodanalista CHAR(13)      
 DECLARE @cCodModular VARCHAR(20)      
 DECLARE @ncondicion2 INT       
 DECLARE @cperscodanalistapar CHAR(13)      
 DECLARE @bAutoasigna BIT      
 DECLARE @nanaparalelo INT       
 DECLARE @nCodProyInmob INT      
 DECLARE @nSubProducto INT      
 DECLARE @nIDCanalDesembolso INT      
 DECLARE @nCodActividadAgropecuaria INT      
 DECLARE @nCodSubDestinoAgropecuario INT      
 DECLARE @cDescSubDestinoAgropecuario VARCHAR(100)      
 DECLARE @nIdCultivo INT      
 DECLARE @nTipoSegmento INT      
 DECLARE @bMicroseguroAP BIT      
 DECLARE @bMicroseguroVS BIT      
 DECLARE @bSegDesempleo BIT     
 DECLARE @bSegAgricola BIT    
 DECLARE @nIdSegAgricola BIGINT     
 DECLARE @nEstadoActual INT      
 DECLARE @bProspectoAgropecuario BIT  
 DECLARE @nCodClienteProspectoAgropecuario INT  
   
 DECLARE @cNumEva VARCHAR(8)      
 DECLARE @cNumFuente VARCHAR(8)      
 DECLARE @dPersEval DATE      
 DECLARE @nPersTipFte INT      
      
 DECLARE @nNumRefUnoUno INT = -1      
      
 DECLARE @cClasificacionGE VARCHAR(1)      
  
 declare @cXmlCalendario XML  
  
 DECLARE @bMultiriesgoComercial BIT   
 DECLARE @bMultiriesgoReconstruccion BIT  
      
 CREATE TABLE #ExcepcionesGarantia(      
  NNUMREF INT,      
  NPORCCOBERTURA DECIMAL(18,2) NULL,      
  DFECAUDITSOL DATETIME,      
  CUSERAUDITSOL VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS,      
  CAGECODAUDITSOL VARCHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS,      
  NCODTIPVAL INT      
 )      
      
 CREATE TABLE #GarantiasAsociadas(      
  cNumGarant BIGINT,      
  nMoneda INT,      
  nGravado MONEY,      
  nEstado INT,      
  nPorcentajeGarantia DECIMAL(5,2),      
  nPorcentajeCobertura DECIMAL(18,2),      
  nPorGravar DECIMAL(18,2),      
  nTipoCambio DECIMAL(18,4),      
  nRefinanciado INT,      
  nTipGarGlobalFlotante INT,      
  nIndGarCombinada INT,       
  cNumGarantCombinacion BIGINT,      
  nPersRelac INT,      
  bExcepSeguroBien BIT        
 )      
   
 -- GARANTIAS POR FUERA    
 CREATE TABLE #GarantiasPorFueraAsociadas    
 (    
 nGarantPfID BIGINT,    
 nMoneda INT,    
 nGravado MONEY,    
 cUserVB CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS,    
 cUltimaActualizacion VARCHAR(25) COLLATE SQL_Latin1_General_CP1_CI_AS,    
 nFlag INT,    
 nPersRelac INT    
 )    
      
 CREATE TABLE #ColocSolicitud      
 (      
  nCodsolicitud INT      
  ,ccodsolicitud VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,ncaptado INT      
  ,ncuotas INT      
  ,nmonto MONEY      
  ,nfrecpago INT      
  ,nTipoPeriodicidad INT      
  ,nDiasFrecuencia INT      
  ,nPlazo INT      
  ,nPeriodoFechaFija INT      
  ,ncondicion INT      
  ,ncondicion2 INT      
  ,nestado INT      
  ,ncalsbs INT      
  ,nmontosbs MONEY      
  ,nnumentsbs INT      
  ,dfechasbs DATETIME      
  ,nestadosbs INT      
  ,ndestino INT      
  ,nSubDestinosId INT     
 ,nTipoVivienda INT      
  ,idcampana INT      
  ,idcampanaNew INT      
  ,bCompraDeuda BIT      
  ,crfa CHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,ccodagebn VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,cperscodinst VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,nsubcategoriaconvenioId INT      
  ,ccodmodular VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,nsubproducto INT      
  ,scalif0 VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,scalif1 VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,scalif2 VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,scalif3 VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,scalif4 VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,cperscodcaptado VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,ntipocredito INT      
  ,cNumPoliza VARCHAR(12) COLLATE SQL_Latin1_General_CP1_CI_AS--CDLC MICROSEGURO 20/09/2010        
  ,cProyecto INT      
  ,nMontoVivienda MONEY      
  ,nMontoInicial MONEY      
  ,bBonoBP BIT       
  ,nMontoGastos MONEY       
  ,nCodProyInmob INT       
  ,nIdCanalDesembolso INT      
  ,nTEACampCD DECIMAL(10,4)         
  ,nAplicacion INT      
  ,nMontoCuota MONEY        
  ,dFechaPrimerPago DATETIME      
  ,nTEM MONEY  
  ,nTcea MONEY  
  ,nTemMin MONEY  
  ,nTemMax MONEY  
  ,nTemMinOriginal MONEY  
  ,nTemMaxOriginal MONEY       
  ,nTipoGracia INT      
  ,nDiasGracia INT      
  ,bProximoMes BIT      
  ,cLineaCred  VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,nTasaGracia DECIMAL(18,4)      
  ,cXmlCalendario XML      
  ,bAsumirGastosTasNot BIT      
  ,bCheckProc BIT      
  ,cOfiInfCod VARCHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,bPuntualito BIT      
  ,bReembolsoMiViv BIT      
  ,bMicroseguro BIT      
  ,bUnifDeuda BIT      
  ,nNumRefUnoUno INT      
  ,nValorObra MONEY      
  ,bProyectoCC BIT      
  ,dFechaPrimeraCuota DATETIME NULL      
  ,nMetodologiaCalendario INT      
  ,bAplicaDctoPP BIT      
  ,bSolaFirma BIT      
  ,bMicroseguroVS BIT      
  ,bMicroseguroOncologico BIT    
  ,bEscalNiv BIT      
  ,bSegDesempleo BIT     
  ,bSegAgricola BIT    
  ,nIdSegAgricola BIGINT    
  ,bMantieneEvaluacion BIT    
  ,bSegDesgravamen BIT    
  ,bSegDesgravamenDevolucion BIT    
  ,cPersCodClientePromotor VARCHAR(13)     
  ,bAnalistaxMora BIT    
  ,nTipoPropuesta INT    
 );       
         
 CREATE TABLE #ColocSolicitudEstado      
 (      
  nCodSolicitud INT      
  ,nestado INT      
  ,cperscodanalista CHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,nmonto DECIMAL(18,2)      
  ,nreasigna INT      
  ,nanaparalelo INT      
  ,cperscodanalistapar CHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,cMotivo VARCHAR(300) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,cObservacion VARCHAR(300) COLLATE SQL_Latin1_General_CP1_CI_AS      
 );      
      
 CREATE TABLE #CreditosProceso      
 (      
  cCtaCod VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,nEstado INT      
  ,dEstado DATETIME      
 ,nMonto MONEY      
  ,nSaldo MONEY      
  ,nTipPagInt INT      
  ,nNumCuoDis INT      
  ,nMonFecAmp MONEY      
  ,nIntComp MONEY       
  ,nIntMorat MONEY      
  ,nIntGracia MONEY      
  ,nIntSusp MONEY       
  ,nIntReprog MONEY      
  ,nIntGastos MONEY       
  ,nIntCofide MONEY       
  ,nIntCorrido MONEY      
 );      
      
 CREATE TABLE #ColocSolicitudPersona      
 (       
  nprdpersrelac INT      
  ,cpersCod CHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS      
 );      
      
 CREATE TABLE #ColocRegistroDependenciaHijo      
 (    
 cPersCodTitular CHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS,-->Cuenta del Titular    
 dFechaNacimiento DATETIME, -->Fecha de Nacimiento    
 cGenero VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS ,--> Genero de la Persona    
 cDependencia VARCHAR(50)COLLATE SQL_Latin1_General_CP1_CI_AS,    
 dFechaRegistro DATETIME,--> Fecha y Hora de la operacion    
 cUser VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS ,--> usuario que registró la operacion     
 );     
    
 CREATE TABLE #MontoHipotecario      
 (      
  nMontoVivienda DECIMAL(18,2),      
  nMontoInicial DECIMAL(18,2),      
  bBonoBP    BIT,      
  nGastosCierre   DECIMAL(18,2),      
  cTpoVIS VARCHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS,      
  nTipoBono INT,      
  nMontoBono MONEY,      
  nPresupuestoCons MONEY,      
  nValTerreno MONEY,      
  nMontoAdi MONEY,      
  bPrimeraVivienda BIT,      
  nMontoCompra MONEY,      
  nSaldoAmpliado MONEY,      
  nTipoVehiculo INT,      
  nBonoVerde MONEY      
 );      
       
 DECLARE @Bienes TABLE       
 (      
  cDetalle     NTEXT      
  ,cProveedor    VARCHAR(13) COLLATE SQL_Latin1_General_CP1_CI_AS      
  ,nPrecio     MONEY      
  ,nMoneda     INT      
  ,cExperienciaEquipo   NTEXT      
 );      
      
 DECLARE @Documentos TABLE (      
  cCtaCod VARCHAR(18),      
  nEtapa INT,      
  nCodSolicitud INT,      
  nTipoDocumento INT,      
  cTpoProducto INT,      
  cArchivo VARCHAR(255),      
  cRuta VARCHAR(MAX),      
  bArchivo VARBINARY(MAX),      
  bOpRiesgos BIT,      
  nCodDocumentos INT,      
  bInsertar BIT,      
  bEliminar BIT      
 )       
      
 DECLARE @EvaFiadorSolidario TABLE      
 (      
  nCodSolicitud INT,      
  cPersCodTitular VARCHAR(13),      
  cPersCodFiador VARCHAR(13),      
  nPersNroDependientes INT,      
  cPersEdadHijos VARCHAR(30),      
  nCondicionLegal INT,      
  cCondLegalOtros VARCHAR(30),      
  nEstadoVivienda INT,      
  cEstadoViviendaOtros VARCHAR(30),      
  nRelacionAvalTitular INT,      
  cRelacionAvalOtros VARCHAR(30),      
  nTipoActividad INT,      
  cActividadEconomica VARCHAR(50),      
  nFrecuenciaIngreso INT,      
  cDireccionNegocio VARCHAR(200),      
  cDepProvDistNegocio VARCHAR(200),      
  nTiempoActividad INT,      
  cCargo VARCHAR(50),      
  nIngresosAprox MONEY,      
  bConyugeLabora BIT,      
  cOcupacionConyuge VARCHAR(50),      
  nTiempoLaboral INT,      
  cReferenciasPersonales VARCHAR(2000),      
  cComentarioAnalista VARCHAR(2000)      
 )      
      
 CREATE TABLE #MotorResultado        
 (      
  nIdEjecucion BIGINT,      
  nIdObjeto INT,      
  cTimeEjecucion VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS      
 );      
       
 CREATE TABLE #Observaciones      
 (      
  bAprobacion BIT,      
  bComenAprob BIT,      
  dFecha DATETIME,      
  nTpo INT,      
  cObservacion VARCHAR(MAX),      
  cRespuesta VARCHAR(300),      
  cUser VARCHAR(4),      
  cAgeCod VARCHAR(2)      
 );      
      
 CREATE TABLE #DatosSolicitudOnline      
 (      
  UniqueId INT,      
  Fecha DATETIME,      
  Doi VARCHAR(20),      
  Telefono VARCHAR(200)      
 );      
      
 CREATE TABLE #FondoCredito      
 (      
  cCtaCod varchar(18) collate SQL_Latin1_General_CP1_CI_AS,      
  nCodProceso int,      
  nIdFondo int,      
  nIdInstrumento int,      
  nMontoNetoAnual money,      
  nTipoCredito int,      
  nPlazoTotal int,    
nPorcentaje decimal (18,2)    
 )    
    
 CREATE TABLE #VigenciaEvaluacion    
 (    
  cCtaCod varchar(18) collate SQL_Latin1_General_CP1_CI_AS,    
  nProceso INT,    
  nNumRefinanciacion INT,    
  cCtaCodOrig VARCHAR(18) COLLATE SQL_Latin1_General_CP1_CI_AS,    
  cNumEvaOrig VARCHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS    
 )  
  
  CREATE TABLE #DeudaComprada(      
  nCodIFI INT,      
  cNombreIfi VARCHAR(300),      
  nMoneda INT,      
  nMontoDesembolsado MONEY,  
  nSaldoCapitalTotal MONEY,  
  nSaldoCapitalCorriente MONEY,  
  dFecDesembolso DATETIME,  
  nDestino INT,  
  nTipoCred INT,  
  nModalidad INT,  
  nRelacion INT,  
  bRCC BIT,  
  cTipoIfi VARCHAR(30),  
  nCuotas int,  
  bEstado bit    
 )      
      
 INSERT INTO #ColocSolicitud       
 (      
  ncaptado      
  ,ncuotas      
  ,nmonto      
  ,nfrecpago      
  ,nTipoPeriodicidad      
  ,nDiasFrecuencia      
  ,nPlazo      
  ,nPeriodoFechaFija      
  ,ncondicion      
  ,ncondicion2      
  ,nestado      
  ,ncalsbs      
  ,nmontosbs      
  ,nnumentsbs      
  ,dfechasbs      
  ,nestadosbs      
  ,ndestino      
  ,nSubDestinosId    
  ,nTipoVivienda      
  ,idcampana --FALTA nEnviado , bEditado      
  ,idcampanaNew --NO ESTA EN TABLA      
  ,bCompraDeuda --NO ESTA EN TABLA      
  ,cRFA      
  ,ccodagebn       
  ,cPersCodInst      
  ,nSubCategoriaConvenioId      
  ,cCodModular      
  ,nsubproducto      
  ,sCalif0      
  ,sCalif1      
  ,sCalif2      
  ,sCalif3      
  ,sCalif4 -- FALTA bExpediente      
  ,cPersCodCaptado      
  ,nTipoCredito       
  ,cProyecto           
  ,nCodProyInmob      
  ,nIDCanalDesembolso      
  ,nTEACampCD --NO ESTA EN TABLA        
  ,nAplicacion      
  ,nMontoCuota        
  ,dFechaPrimerPago      
  ,nTEM  
  ,nTcea  
  ,nTemMin  
  ,nTemMax  
  ,nTemMinOriginal  
  ,nTemMaxOriginal      
  ,nTipoGracia      
  ,nDiasGracia       
  ,bProximoMes      
  ,cLineaCred      
  ,nTasaGracia      
  ,cXmlCalendario       
  ,bAsumirGastosTasNot --NO ESTA EN TABLA       
  ,cOfiInfCod --NO ESTA EN TABLA       
  ,bCheckProc --NO ESTA EN TABLA       
  ,bPuntualito      
  ,bReembolsoMiViv      
  ,bMicroseguro      
  ,bUnifDeuda --NO ESTA EN TABLA      
  ,nNumRefUnoUno      
  ,nValorObra      
  ,bProyectoCC      
  ,dFechaPrimeraCuota      
  ,nMetodologiaCalendario      
  ,bAplicaDctoPP --NO ESTÁ EN TABLA      
  ,bSolaFirma --NO ESTÁ EN TABLA      
  ,bMicroseguroVS      
  ,bSegDesempleo     
  ,bSegAgricola    
  ,nIdSegAgricola    
  ,bMicroseguroOncologico    
  ,bEscalNiv      
  ,bMantieneEvaluacion      
  ,bSegDesgravamen    
  ,bSegDesgravamenDevolucion    
  ,cPersCodClientePromotor    
  ,bAnalistaxMora    
  ,nTipoPropuesta    
 )      
      
 SELECT      
  T.Item.value('@nCaptado', 'INT')      
  ,T.Item.value('@nCuotas', 'INT')      
  ,T.Item.value('@nMonto', 'MONEY')      
  ,T.Item.value('@nFrecPago', 'INT')      
  ,T.Item.value('@nTipoPeriodicidad', 'INT')      
  ,T.Item.value('@nDiasFrecuencia', 'INT')      
  ,T.Item.value('@nPlazo', 'INT')      
  ,T.Item.value('@nPeriodoFechaFija', 'INT')      
  ,T.Item.value('@nCondicion', 'INT')      
  ,T.Item.value('@nCondicion2', 'INT')      
  ,T.Item.value('@nEstado', 'INT')       
  ,T.Item.value('@nCalSBS', 'INT')      
  ,T.Item.value('@nMontoSBS', 'DECIMAL(18,2)')      
  ,T.Item.value('@nNumEntSBS', 'INT')      
  ,T.Item.value('@dFechaSBS', 'DATETIME')      
  ,T.Item.value('@nEstadoSBS', 'INT')      
  ,T.Item.value('@nDestino', 'INT')    
  ,T.Item.value('@nSubDestinosId', 'INT')    
  ,T.Item.value('@nTipoVivienda', 'INT')      
  ,T.Item.value('@IdCampana', 'INT')      
  ,T.Item.value('@IdCampanaNew', 'INT')       
  ,T.Item.value('@bCompraDeuda', 'BIT')      
  ,T.Item.value('@cRFA', 'CHAR(3)')       
  ,T.Item.value('@cCodAgeBN', 'VARCHAR(10)')       
  ,T.Item.value('@cPersCodInst', 'VARCHAR(13)')      
  ,T.Item.value('@SubCategoriaConvenioId', 'INT')      
  ,T.Item.value('@cCodModular', 'VARCHAR(50)')      
  ,T.Item.value('@nSubProducto', 'INT')      
  ,T.Item.value('@sCalif0', 'VARCHAR(4)')      
  ,T.Item.value('@sCalif1', 'VARCHAR(4)')      
  ,T.Item.value('@sCalif2', 'VARCHAR(4)')      
  ,T.Item.value('@sCalif3', 'VARCHAR(4)')      
  ,T.Item.value('@sCalif4', 'VARCHAR(4)')      
  ,T.Item.value('@cPersCodCaptado', 'VARCHAR(13)')      
  ,T.Item.value('@nTipoCredito', 'INT')       
  ,T.Item.value('@cProyecto', 'INT')       
  ,T.Item.value('@nCodProyInmob', 'INT')      
  ,T.Item.value('@nIDCanalDesembolso', 'INT')       
  ,T.Item.value('@nTEACampCD','DECIMAL(10,4)')       
  ,T.Item.value('@nAplicacion', 'INT')       
  ,T.Item.value('@nMontoCuota','MONEY')     
  ,T.Item.value('@dFechaPrimerPago','DATETIME')      
  ,T.Item.value('@nTEM', 'MONEY')   
  ,T.Item.value('@nTcea', 'MONEY')  
  ,T.Item.value('@nTemMin', 'MONEY')  
  ,T.Item.value('@nTemMax', 'MONEY')  
  ,T.Item.value('@nTemOriginalMin', 'MONEY')   
  ,T.Item.value('@nTemOriginalMax', 'MONEY')       
  ,T.Item.value('@nTipoGracia', 'INT')      
  ,T.Item.value('@nDiasGracia', 'INT')      
  ,T.Item.value('@bProximoMes', 'BIT')      
  ,T.Item.value('@cLineaCred', 'VARCHAR(15)')      
  ,T.Item.value('@nTasaGracia','DECIMAL(18,4)')      
  ,T.Item.value('@cXmlCalendario','VARCHAR(MAX)')      
,T.Item.value('@bAsumirGastosTasNot','BIT')      
  ,T.Item.value('@cOfiInfCod','VARCHAR(2)')      
  ,T.Item.value('@bCheckProc','BIT')      
  ,T.Item.value('@bPuntualito', 'BIT')      
  ,T.Item.value('@bReembolsoMiViv', 'BIT')      
  ,T.Item.value('@bMicroseguro', 'BIT')      
  ,T.Item.value('@bUnificDeuda', 'BIT')      
  ,IIF(T.Item.value('@nNumRefUnoUno', 'INT') = 0, -1, T.Item.value('@nNumRefUnoUno', 'INT'))      
  ,T.Item.value('@nValorObra', 'MONEY')      
  ,T.Item.value('@bProyectoCC', 'BIT')      
  ,IIF(T.Item.value('dFechaPrimeraCuota[1]', 'DATE') = '1900-01-01', NULL, T.Item.value('dFechaPrimeraCuota[1]', 'DATE'))      
  ,T.Item.value('@nMetodologiaCalendario', 'INT')      
  ,T.Item.value('@bAplicaDctoPP', 'BIT')      
  ,T.Item.value('@bSolaFirma', 'BIT')      
  ,T.Item.value('@bMicroseguroVS', 'BIT')      
  ,T.Item.value('@bSegDesempleo', 'BIT')     
  ,T.Item.value('@bSegAgricola', 'BIT')    
  ,T.Item.value('@nIdSegAgricola', 'BIGINT')    
  ,T.Item.value('@bSegOncologico', 'BIT')    
  ,T.Item.value('@bEscalarNivelRecurrente', 'BIT')               
  ,T.Item.value('@bMantieneEvaluacion', 'BIT')      
  ,T.Item.value('@bSegDesgravamen', 'BIT')      
  ,T.Item.value('@bSegDesgravamenDevolucion', 'BIT')    
  ,T.Item.value('@cPersCodClientePromotor', 'VARCHAR(13)')      
  ,T.Item.value('@bAnalistaxMora','BIT')    
  ,T.Item.value('@nTipoPropuesta', 'INT')    
 FROM @xPropuesta.nodes('PropuestaDto') AS T(Item)      
      
 --OBTENIENDO LOS CÓDIGOS DE MONEDA       
 SELECT       
  @cUser = T.Item.value('@UsuarioOperacion', 'VARCHAR(4)'), -- NO HAY       
  @cAgeCod= T.Item.value('@CodigoAgenciaOperacion', 'VARCHAR(2)'),      
  @nCodMoneda = T.Item.value('@CodigoMoneda', 'INT'),      
  @ncondicion2 = T.Item.value('@nCondicion2', 'INT'),      
  @nCodActividadAgropecuaria = T.Item.value('@nCodActividadAgropecuaria', 'INT'),      
  @nCodSubDestinoAgropecuario = T.Item.value('@nCodSubDestinoAgropecuario', 'INT'),      
  @cDescSubDestinoAgropecuario = T.Item.value('@cDescSubDestinoAgropecuario', 'VARCHAR(100)'),      
  @nIdCultivo = T.Item.value('@nIdCultivo', 'INT'),      
  @nTipoSegmento = T.Item.value('@nTipoSegmento', 'INT'),      
  @bMicroseguroAP = T.Item.value('@bMicroseguro', 'BIT'),      
  @bMicroseguroVS = T.Item.value('@bMicroseguroVS', 'BIT'),      
  @bSegDesempleo = T.Item.value('@bSegDesempleo', 'BIT'),     
  @bSegAgricola = T.Item.value('@bSegAgricola', 'BIT'),    
  @nIdSegAgricola = T.Item.value('@nIdSegAgricola', 'BIGINT'),    
  @cCodModular = T.Item.value('@cCodModular', 'VARCHAR(50)'),      
  @nEstadoActual = T.Item.value('@nEstadoActualCredito', 'INT'),      
  @cClasificacionGE = T.Item.value('@cClasificacionGE', 'VARCHAR(1)'),      
  @nNumRefUnoUno = IIF(T.Item.value('@nNumRefUnoUno', 'INT') = 0, -1, T.Item.value('@nNumRefUnoUno', 'INT')),  
  @bProspectoAgropecuario = T.Item.value('@bProspectoAgropecuario','BIT'),  
  @nCodClienteProspectoAgropecuario = T .Item.value('@nCodClienteProspectoAgropecuario','INT')  
 FROM @xPropuesta.nodes('PropuestaDto') AS T(Item)      
      
 INSERT INTO @Documentos      
  (nEtapa, nTipoDocumento, cTpoProducto, cArchivo, cRuta, bArchivo, bOpRiesgos, nCodDocumentos, bInsertar, bEliminar)      
 SELECT       
        T.Item.value('@nEtapa', 'INT'),      
  T.Item.value('@nTipoDocumento', 'INT'),      
  T.Item.value('@cTpoProducto', 'INT'),      
  T.Item.value('@cArchivo', 'VARCHAR(200)'),      
  T.Item.value('@cRuta', 'VARCHAR(MAX)'),      
  T.Item.value('@bArchivo', 'VARBINARY(MAX)'),      
  IIF(T.Item.value('@bObservado', 'BIT') = 1,       
   2,       
   IIF(T.Item.value('bOpRiesgos[1]', 'char(1)') = '',       
    NULL,       
    T.Item.value('bOpRiesgos[1]', 'bit'))) AS bOpRiesgos,      
  T.Item.value('@nCodDocumentos','int'),      
  T.Item.value('@bInsertar','bit'),      
  T.Item.value('@bEliminar','bit')      
 FROM @xPropuesta.nodes('PropuestaDto/Documentos/Documento') AS T(Item)      
      
 --FIADOR SOLIDARIO      
 INSERT @EvaFiadorSolidario      
 SELECT       
  @nCodSolicitud,      
  T.Item.value('@cPersCodTitular', 'VARCHAR(13)'),      
  T.Item.value('@cPersCodFiador', 'VARCHAR(13)'),      
  T.Item.value('@nPersNroDependientes', 'INT'),      
  T.Item.value('@cPersEdadHijos', 'VARCHAR(30)'),      
  T.Item.value('@nCondicionLegal', 'INT'),      
  T.Item.value('@cCondLegalOtros', 'VARCHAR(30)'),      
  T.Item.value('@nEstadoVivienda', 'INT'),      
  T.Item.value('@cEstadoViviendaOtros', 'VARCHAR(30)'),      
  T.Item.value('@nRelacionAvalTitular', 'INT'),      
  T.Item.value('@cRelacionAvalOtros', 'VARCHAR(30)'),      
  T.Item.value('@nTipoActividad', 'INT'),      
  T.Item.value('@cActividadEconomica', 'VARCHAR(50)'),      
  T.Item.value('@nFrecuenciaIngreso', 'INT'),      
  T.Item.value('@cDireccionNegocio', 'VARCHAR(200)'),      
  T.Item.value('@cDepProvDistNegocio', 'VARCHAR(200)'),      
  T.Item.value('@nTiempoActividad', 'INT'),      
  T.Item.value('@cCargo', 'VARCHAR(50)'),      
  T.Item.value('@nIngresosAprox', 'MONEY'),      
  T.Item.value('@bConyugeLabora', 'BIT'),      
  T.Item.value('@cOcupacionConyuge', 'VARCHAR(50)'),      
  T.Item.value('@nTiempoLaboral', 'INT'),      
  T.Item.value('@cReferenciasPersonales', 'VARCHAR(2000)'),      
  T.Item.value('@cComentarioAnalista', 'VARCHAR(2000)')      
 FROM @xPropuesta.nodes('PropuestaDto/FiadorSolidario') AS T(Item)      
      
 SELECT       
  @cNumEva = T.Item.value('@cNumEva', 'VARCHAR(8)'),      
  @cNumFuente = T.Item.value('@cNumFuente', 'VARCHAR(8)'),      
  @dPersEval = T.Item.value('@dPersEval', 'DATE'),      
  @nPersTipFte = T.Item.value('@nPersTipFte', 'INT')      
 FROM @xPropuesta.nodes('PropuestaDto/Evaluacion') AS T(Item)      
 WHERE T.Item.value('@cNumEva', 'VARCHAR(8)') <> ''      
  
 select top 1  
  @cXmlCalendario = CST.cXmlCalendario  
 FROM #ColocSolicitud CST  
  
 select  
 @bMultiriesgoComercial = T.Item.value('@bMultiriesgoComercial', 'BIT'),  
 @bMultiriesgoReconstruccion = T.Item.value('@bMultiriesgoReconstruccion', 'BIT')  
 FROM @cXmlCalendario.nodes('Calendario') AS T(Item)  
      
 --cOLOCsOLICITUDeSTADO      
 INSERT INTO #ColocSolicitudEstado (      
  nCodSolicitud      
  ,nestado       
  ,cperscodanalista      
  ,nmonto       
  ,nreasigna      
  ,nanaparalelo      
  ,cperscodanalistapar      
  ,cMotivo      
,cObservacion      
  )      
 SELECT      
  @nCodSolicitud      
  ,T.Item.value('@nEstado', 'INT')       
  ,T.Item.value('@cPersCodAnalista', 'CHAR(13)')      
  ,T.Item.value('@nMonto', 'DECIMAL(18,2)')      
  ,T.Item.value('@nReasigna', 'INT')-- NO HAY      
  ,0  --T.Item.value('@nanaparalelo', 'INT') -- NO HAY       
  ,'' --T.Item.value('@cperscodanalistapar', 'CHAR(13)') -- NO HAY      
  ,T.Item.value('@cMotivo', 'VARCHAR(300)')      
  ,T.Item.value('@cObservacion', 'VARCHAR(300)')      
 FROM @xPropuesta.nodes('PropuestaDto/EstadoSolicitud/Estado') AS T(Item)      
      
 INSERT INTO #CreditosProceso      
 (      
  cCtaCod      
  ,nEstado      
  ,dEstado      
  ,nMonto       
  ,nSaldo      
  ,nTipPagInt      
  ,nNumCuoDis      
  ,nMonFecAmp      
  ,nIntComp      
  ,nIntMorat      
  ,nIntGracia       
  ,nIntSusp      
  ,nIntReprog      
  ,nIntGastos      
  ,nIntCofide      
  ,nIntCorrido      
 )      
 SELECT       
  T.Item.value('@cCtaCod', 'VARCHAR(18)')      
  ,T.Item.value('@nEstado', 'INT')      
  ,T.Item.value('@dEstado', 'DATETIME')      
  ,T.Item.value('@nMonto', 'MONEY')      
  ,T.Item.value('@nSaldo', 'MONEY')      
  ,IIF(T.Item.value('@nMonFecAmp', 'MONEY') <= 0 ,0 ,1)      
  ,0 --asumido por cliente (ya no hay num cuotas)      
  ,T.Item.value('@nMonFecAmp', 'MONEY')      
  ,T.Item.value('@nIntComp', 'MONEY')      
  ,T.Item.value('@nIntMorat', 'MONEY')      
  ,T.Item.value('@nIntGracia', 'MONEY')      
  ,T.Item.value('@nIntSusp', 'MONEY')       
  ,T.Item.value('@nIntReprog', 'MONEY')       
  ,T.Item.value('@nIntGastos', 'MONEY')       
  ,T.Item.value('@nIntCofide', 'MONEY')       
  ,T.Item.value('@nIntCorrido', 'MONEY')      
 FROM @xPropuesta.nodes('PropuestaDto') AS P(Prop)      
 CROSS APPLY P.Prop.nodes('CreditosProcesar/CreditoProcesar') AS T(Item)      
      
 INSERT INTO #ColocSolicitudPersona       
 (      
  nprdpersrelac      
  ,cPersCod      
 )      
 SELECT       
  T.Item.value('@nPrdPersRelac', 'INT')      
  ,T.Item.value('@cPersCod', 'CHAR(13)')      
 FROM @xPropuesta.nodes('PropuestaDto/PersonasRelacionadas/PersonaRelacionada') AS T(Item)      
 
   INSERT INTO #DeudaComprada       
 (        
 nCodIFI,  
 cNombreIfi,  
 nMoneda,  
 nMontoDesembolsado,  
 nSaldoCapitalTotal,  
 nSaldoCapitalCorriente,  
 dFecDesembolso,  
 nDestino,  
 nTipoCred,  
 nModalidad,  
 nRelacion,  
 bRCC,  
 cTipoIfi,  
 nCuotas,  
 bEstado  
 )      
 SELECT       
 T.Item.value('@nCodIfi', 'INT')      
 ,T.Item.value('@cNombreIfi', 'VARCHAR(300)')   
 ,T.Item.value('@nMoneda', 'INT')    
 ,T.Item.value('@nMontoDesembolsado', 'MONEY')    
 ,T.Item.value('@nSaldoCapitalTotal', 'MONEY')    
 ,T.Item.value('@nSaldoCapitalCorriente', 'MONEY')    
 ,T.Item.value('@dFecDesembolso', 'DATE')    
 ,T.Item.value('@nDestino', 'INT')    
 ,T.Item.value('@nTipoCred', 'INT')    
 ,T.Item.value('@nModalidad', 'INT')    
 ,T.Item.value('@nRelacion', 'INT')    
 ,T.Item.value('@bRCC', 'BIT')    
 ,T.Item.value('@cTipoIfi', 'VARCHAR(30)')   
 ,T.Item.value('@nCuotas', 'INT')   
 ,T.Item.value('@bEstado', 'BIT')    
    FROM @xPropuesta.nodes('PropuestaDto/DeudasIfiSeleccionadas/DeudasIfi') AS T(Item)  
      
 DECLARE @cPersCod CHAR (13) = (SELECT cPersCod FROM  #ColocSolicitudPersona where nprdpersrelac = 20)    
 DECLARE @cPersCodTitular CHAR (13)= (SELECT TOP 1 T.A.value('@cPersCod','CHAR(13)') FROM @xPropuesta.nodes('PropuestaDto/ListaHijo/Hijo') AS T(A))    
 DECLARE @dFechaRegistro DATETIME =  CONVERT(DATETIME,(CONVERT(VARCHAR,(SELECT CONVERT(DATE,nConsSisValor,103) FROM ConstSistema WHERE nConsSisCod = 16)) + ' ' + CONVERT(VARCHAR(10),GETDATE(),108)))    
     
 INSERT INTO #ColocRegistroDependenciaHijo    
 (      
  cPersCodTitular,-->Cuenta del Titular    
 dFechaNacimiento , -->Fecha de Nacimiento    
 cGenero,--> Genero de la Persona    
 cDependencia,    
 dFechaRegistro ,--> Fecha y Hora de la operacion    
 cUser--> usuario que registró la operacion     
 )      
 SELECT     
 @cPersCodTitular,     
 T.A.value('dFechaNacimientoHijo[1]','DATETIME'),     
 T.A. value ('@cGenero','VARCHAR(50)'),    
 T.A.value('@cDependencia','VARCHAR(50)'),    
 @dFechaRegistro,    
 @cUser    
 FROM @xPropuesta.nodes('PropuestaDto/ListaHijo/Hijo') AS T(A)     
    
 INSERT INTO #ExcepcionesGarantia(      
  NNUMREF,      
  NPORCCOBERTURA,      
  DFECAUDITSOL,      
  CUSERAUDITSOL,      
  CAGECODAUDITSOL,      
  NCODTIPVAL      
 )      
 SELECT          
  T.Item.value('@NNUMREF', 'INT'),      
        CASE      
            WHEN T.Item.value('NPORCCOBERTURA[1]', 'CHAR(1)') = ''      
            THEN NULL      
            ELSE T.Item.value('NPORCCOBERTURA[1]', 'DECIMAL(18,2)')      
        END AS NPORCCOBERTURA,      
  CASE      
            WHEN T.Item.value('DFECAUDITSOL[1]', 'CHAR(1)') = ''      
            THEN NULL      
            ELSE T.Item.value('DFECAUDITSOL[1]', 'DATETIME')      
        END AS DFECAUDITSOL,      
  T.Item.value('@CUSERAUDITSOL', 'VARCHAR(10)'),      
  T.Item.value('@CAGECODAUDITSOL', 'VARCHAR(3)'),      
  T.Item.value('@NCODTIPVAL', 'INT')      
 FROM @xPropuesta.nodes('PropuestaDto/ExcepcionesGarantia/ExcepcionGarantia') AS T(Item)      
     
 INSERT INTO #GarantiasAsociadas      
 (      
  cNumGarant,      
  nMoneda,      
  nGravado,      
  nEstado,      
  nPorcentajeGarantia,      
  nPorcentajeCobertura,      
  nPorGravar,      
  nTipoCambio,      
  nRefinanciado,      
  nTipGarGlobalFlotante,      
  nIndGarCombinada,       
  cNumGarantCombinacion,      
  nPersRelac,      
  bExcepSeguroBien       
 )      
 SELECT       
  X.value('@nNumGarant','BIGINT') as cNumGarant,      
  X.value('@nMoneda','INT') as nMoneda,      
  X.value('@nGravado','DECIMAL(18,2)') as nGravado,      
  X.value('@nEstado','INT') as nEstado,       
  X.value('@nPorcentajeGarantia','DECIMAL(5,2)') as nPorcentajeGarantia,      
  X.value('@nPorcentajeCobertura','DECIMAL(18,2)') as nPorcentajeCobertura,      
  X.value('@nPorGravar','DECIMAL(18,2)') as nPorGravar,      
  X.value('@ntipoCambio','DECIMAL(18,4)') as nTipoCambio,      
  X.value('@nNumRefUnoUno','INT') as nRefinanciado,      
  X.value('@nTipGlobalFlotante','INT') as nTipGarGlobalFlotante,      
  X.value('@nIndGarCombinada','INT') as nIndGarCombinada,       
  X.value('@cNumGarantCombinacion','BIGINT') as cNumGarantCombinacion,      
  X.value('@nPersRelac','INT') as nPersRelac,      
  X.value('@bExcepSeguroBien','BIT') as bExcepSeguroBien      
 FROM       
 @xPropuesta.nodes('PropuestaDto/GarantiaCredito/GarantiaCredito') as J(X)      
    
  -- GARANTIAS POR FUERA    
 DECLARE @cUserVB CHAR(4) = NULL    
 DECLARE @cUltimaActualizacion VARCHAR(25) =  DBO.FN_UltimaActualizacion(@cUser)    
 DECLARE @nFlag INT = 0 -- 0 : indica que no tiene visto bueno.    
    
 INSERT INTO #GarantiasPorFueraAsociadas      
 (      
   nGarantPfID,    
 nMoneda,    
 nGravado,    
 cUserVB,    
 cUltimaActualizacion,    
 nFlag,    
 nPersRelac    
 )      
 SELECT       
  GarPorFuera.value('@nGarantPfID','BIGINT') as cGarantPfID,      
  GarPorFuera.value('@nMoneda','INT') as nMoneda,      
  GarPorFuera.value('@nGravado','DECIMAL(18,2)') as nGravado,       
  @cUserVB,    
  @cUltimaActualizacion,    
  @nFlag,    
  GarPorFuera.value('@nPersRelac','INT') as nPersRelac    
 FROM       
 @xPropuesta.nodes('PropuestaDto/GarantiaCreditoPorFuera/GarantiaCreditoPorFuera') as J(GarPorFuera)      
      
 INSERT INTO #MontoHipotecario      
  (nMontoVivienda,       
  nMontoInicial,       
  bBonoBP,        
  nGastosCierre,      
  cTpoVIS,      
  nTipoBono,      
  nMontoBono,      
  nPresupuestoCons,      
  nValTerreno,      
  nMontoAdi,      
  bPrimeraVivienda,      
  nMontoCompra,      
  nSaldoAmpliado,      
  nTipoVehiculo,      
  nBonoVerde)      
 SELECT       
  T.Item.value('@nMontoVivienda','DECIMAL(18,2)'),      
  T.Item.value('@nMontoInicial','DECIMAL(18,2)'),      
  T.Item.value('@bBonoBP','BIT'),      
  T.Item.value('@nMontoGastos','DECIMAL(18,2)'),      
  T.Item.value('@nCodVis','VARCHAR(1)'),      
  T.Item.value('@nTipoBono','INT'),      
  T.Item.value('@nMontoBono','MONEY'),      
  T.Item.value('@nPresupuestoCons','MONEY'),      
  T.Item.value('@nValorTerreno','MONEY'),      
  T.Item.value('@nMontoAdicional','MONEY'),      
  T.Item.value('@bPrimeraVivienda','BIT'),      
  T.Item.value('@nMontoCompra','MONEY'),      
  T.Item.value('@nSaldoAmpliado','MONEY'),      
  T.Item.value('@nTipoVehiculo','INT'),      
  T.Item.value('@nMontoBonoVerde','MONEY')      
 FROM @xPropuesta.nodes('PropuestaDto/GestionMontoHipotecario') AS T (Item)      
       
 /*OBTENIENDO DATOS DE XML CDLC MICROLEASING 08/04/2011*/      
 INSERT INTO @Bienes (      
  cDetalle      
  ,cProveedor      
  ,nPrecio      
  ,nMoneda      
  ,cExperienciaEquipo      
  )      
 SELECT       
  T.Item.value('@cDetalle', 'VARCHAR(MAX)')      
  ,T.Item.value('@cProveedor', 'VARCHAR(13)')      
  ,T.Item.value('@nPrecio', 'DECIMAL(18,2)')      
  ,T.Item.value('@nMoneda', 'INT')      
  ,T.Item.value('@cExperienciaEquipo', 'VARCHAR(MAX)')      
 FROM @xPropuesta.nodes('ColocSolicitud/SolicitudDetalleMicroleasing') AS T(Item)      
      
 /*OBTENIENDO DATOS DE XML CDLC MICROLEASING 08/04/2011*/      
      
 INSERT INTO #MotorResultado(      
  nIdEjecucion      
  ,nIdObjeto      
  ,cTimeEjecucion)      
 SELECT      
  T.Item.value('@nIdEjecucion', 'BIGINT')      
  ,T.Item.value('@nIdObjeto', 'INT')      
  ,T.Item.value('@cTimeEjecucion', 'VARCHAR(100)')      
 FROM @xPropuesta.nodes('PropuestaDto/MotorResultados/MotorResultado') AS T (Item)      
      
 INSERT INTO #Observaciones(      
  bAprobacion,      
  bComenAprob,      
  dFecha,      
  nTpo,      
  cObservacion,      
  cRespuesta,      
  cUser,      
  cAgeCod      
 )      
 SELECT      
  T.Item.value('@bAprobacion', 'BIT')      
  ,T.Item.value('@bComenAprb', 'BIT')      
  ,@dFechaSolicitud      
  ,T.Item.value('@nTpo', 'INT')      
  ,T.Item.value('@cObservacion', 'VARCHAR(MAX)')      
  ,T.Item.value('@crespuesta', 'VARCHAR(300)')      
  ,T.Item.value('@cUser', 'VARCHAR(4)')      
  ,T.Item.value('@cAgeCod', 'VARCHAR(2)')      
 FROM @xPropuesta.nodes('PropuestaDto/Observaciones/Observacion') AS T (Item)      
      
 INSERT INTO #DatosSolicitudOnline      
 (      
  UniqueId,      
  Fecha,      
  Doi,      
  Telefono      
 )      
 SELECT      
  C.Item.value('@UniqueId','INT'),      
  C.Item.value('@Fecha','DATETIME'),      
  C.Item.value('@Doi','VARCHAR(20)'),      
  C.Item.value('@Telefono','VARCHAR(200)')      
 FROM @xPropuesta.nodes('PropuestaDto/DatosSolicitudOnline') AS C(Item)      
      
 SELECT       
  @nestado = nestado      
  ,@bAutoasigna = IIF(nreasigna = 1, 1, 0)      
  ,@nanaparalelo = nanaparalelo      
  ,@cperscodanalistapar = cperscodanalistapar      
 FROM #ColocSolicitudEstado (NOLOCK)       
       
SELECT       
  @nCodProyInmob = nCodProyInmob       
  ,@nSubProducto = nSubProducto      
  ,@nIDCanalDesembolso = nIdCanalDesembolso       
  ,@cCredProductoCta = RIGHT(nSubProducto,3)      
 FROM #ColocSolicitud (NOLOCK)      
      
 EXEC [sp_GeneraMovNro] @dFechaSolicitud,@cAgeCod,@cUser,@cMovNumero OUTPUT      
      
 --BEGIN TRANSACTION Operacion           
 BEGIN TRANSACTION                 
    BEGIN TRY       
      
 -- LLENADO VARIABLES     
 /*========================= NUMERO DE HIJOS  =====================*/       
  IF(RIGHT(@nSubProducto,3)  != 302)    
  BEGIN     
 IF((SELECT COUNT(*) FROM #ColocRegistroDependenciaHijo) != 0)    
 BEGIN     
  DELETE ColocRegistroDependenciaHijo WHERE cPersCodTitular = @cPersCod    
 END        
  END    
     
 --ACTUAL    
 INSERT INTO ColocRegistroDependenciaHijo (        
       cPersCodTitular      
       ,dFechaNacimiento      
       ,cGenero    
       ,cDependencia    
       ,dFechaRegistro    
       ,cUser    
       )      
 SELECT        
    cPersCodTitular           
    ,dFechaNacimiento      
    ,cGenero    
    ,cDependencia    
    ,dFechaRegistro    
    ,cUser    
 FROM #ColocRegistroDependenciaHijo    
    
 --HISTÓRICO DE HIJOS    
 INSERT INTO ColocRegistroDependenciaHijoHist (        
       cPersCodTitular      
       ,dFechaNacimiento      
       ,cGenero    
       ,cDependencia    
       ,dFechaRegistro    
       ,cUser    
       )      
 SELECT        
    cPersCodTitular    
    ,dFechaNacimiento      
    ,cGenero    
    ,cDependencia    
    ,dFechaRegistro    
    ,cUser    
 FROM #ColocRegistroDependenciaHijo    
    
 /*====================================================================*/    
    
 IF ISNULL(@cCtaCod,'') = ''      
 BEGIN      
  EXEC COLOCACIONES.GenCodCta_Unico_SP  @cAgeCod,@cCredProductoCta,@nCodMoneda,@cCtaCod OUTPUT            
      
  WHILE EXISTS(SELECT cCtaCod FROM Producto WITH(NOLOCK) WHERE cCtaCod= @cCtaCod)      
  BEGIN      
   EXEC COLOCACIONES.GenCodCta_Unico_SP  @cAgeCod,@cCredProductoCta,@cCredProductoCta,@cCtaCod OUTPUT          
  END      
      
  INSERT INTO Producto (cCtaCod, nTasaInteres, nSaldo, nPrdEstado, dPrdEstado, nTransacc)      
  SELECT @cCtaCod, nTEM, 0.00, 2000, @dFechaSolicitud, 0 FROM #ColocSolicitud     
    
  -- INSERTA cCtaCod en la tabla Seguro Agricola --    
    
  UPDATE MICROSEGURO.SeguroAgricola    
  SET cCtaCod = @cCtaCod    
  WHERE nSeguroAgricolaId = @nIdSegAgricola    
    
 END      
      
 IF ISNULL(@cCodSolicitud,'') = ''      
 BEGIN      
  EXEC COLOCACIONES.SolCredCod_SelCod_SP @cAgeCod,@cCredProductoCta,@nCodMoneda,@cCodSolicitud OUTPUT      
      
  WHILE EXISTS(SELECT cCodSolicitud FROM ColocSolicitud WITH(NOLOCK) WHERE cCodSolicitud= @cCodSolicitud)      
  BEGIN      
   EXEC COLOCACIONES.SolCredCod_SelCod_SP @cAgeCod,@cCredProductoCta,@nCodMoneda,@cCodSolicitud OUTPUT            
  END      
 END      
    
  IF(@nIdSegAgricola != 0)    
 BEGIN    
  UPDATE MICROSEGURO.SeguroAgricola        
  SET cCtaCod = @cCtaCod        
  WHERE nSeguroAgricolaId = @nIdSegAgricola      
 END    
      
 INSERT INTO #FondoCredito (cCtaCod,nCodProceso,nIdFondo,nIdInstrumento,nMontoNetoAnual,nTipoCredito,nPlazoTotal,nPorcentaje)      
 SELECT      
  @cCtaCod,      
  C.Item.value('@nCodProceso','INT'),      
  C.Item.value('@nIdFondo','INT'),      
  C.Item.value('@nIdInstrumento','INT'),      
  C.Item.value('@nMontoNetoAnual','MONEY'),      
  C.Item.value('@nTipoCredito','INT'),      
  x.nPlazo,    
  C.Item.value('@nPorcentajeCobertura','DECIMAL(18,2)') AS nPorcentaje    
 FROM @xPropuesta.nodes('PropuestaDto/FondoCredito') AS C(Item)      
  CROSS JOIN #ColocSolicitud x      
  WHERE x.idcampanaNew <> 176      
    
    
  INSERT INTO #FondoCredito (cCtaCod,nCodProceso,nIdFondo,nIdInstrumento,nMontoNetoAnual,nTipoCredito,nPlazoTotal,nPorcentaje)    
 SELECT     
  @cCtaCod,    
  x.ncondicion2,    
  C.Item.value('@nIdFondo','INT'),    
  NULL AS nIdInstrumento,    
  NULL AS nMontoNetoAnual,    
  NULL AS nTipoCredito,    
  x.nPlazo,    
  C.Item.value('@nPorcentajeCobertura','DECIMAL(18,2)') AS nPorcentaje    
   FROM @xPropuesta.nodes('PropuestaDto/FondoCredito') AS C(Item)      
   CROSS JOIN #ColocSolicitud x      
   WHERE x.idcampanaNew = 176     
  
  UPDATE #FondoCredito SET   
     nMontoNetoAnual = NULL,  
  nTipoCredito = NULL  
  WHERE nIdFondo = 6 AND cCtaCod = @cCtaCod -- IMPULSO MYPERU  
    
 INSERT INTO #VigenciaEvaluacion (cCtaCod,nProceso,nNumRefinanciacion,cCtaCodOrig,cNumEvaOrig)    
 SELECT     
  @cCtaCod,    
  x.ncondicion2,    
  x.nNumRefUnoUno,    
  C.Item.value('@cCtaCodOrig','VARCHAR(18)'),    
  C.Item.value('@cNumEvaOrig','VARCHAR(8)')    
 FROM @xPropuesta.nodes('PropuestaDto/VigenciaEvaluacion') AS C(Item)    
 CROSS JOIN #ColocSolicitud x    
      
 IF @nNumRefUnoUno > 0      
 BEGIN      
  IF EXISTS(SELECT cCtaCod FROM ColocRefinanciacionTramite WHERE cCtaCod = @cCtaCod AND nNumRefinanciacion = @nNumRefUnoUno AND bOriginal = 0 AND nPrdEstado NOT IN (2000, 2001))      
  BEGIN      
   SET @bInsError = 0      
      
   SELECT       
    TOP 1 @cCodError = 'El crédito N° ' + cCtaCod + ' se encuentra en estado: ' + B.cConsDescripcion      
   FROM       
    ColocRefinanciacionTramite A       
    INNER JOIN Constante B      
    ON B.nConsCod = 3001      
    AND B.nConsValor = A.nPrdEstado      
   WHERE       
    cCtaCod = @cCtaCod       
    AND A.nNumRefinanciacion = @nNumRefUnoUno      
    AND A.bOriginal = 0      
      
   RAISERROR (@cCodError, 11, 1);      
  END      
 END      
 ELSE      
 BEGIN      
IF EXISTS(SELECT cCtaCod FROM Producto WHERE cCtaCod = @cCtaCod AND nPrdEstado NOT IN (2000, 2001) AND @nNumRefUnoUno = -1)      
  BEGIN      
   SET @bInsError = 0      
      
   SELECT       
    TOP 1 @cCodError = 'El crédito N° ' + cCtaCod + ' se encuentra en estado: ' + B.cConsDescripcion      
   FROM       
    Producto A       
    INNER JOIN Constante B      
    ON B.nConsCod = 3001      
    AND B.nConsValor = A.nPrdEstado      
   WHERE       
    cCtaCod = @cCtaCod       
    AND @nNumRefUnoUno = -1      
      
   RAISERROR (@cCodError, 11, 1);      
  END      
 END      
      
 SELECT @cNumPolizaMSAP = A.cNumPoliza      
 FROM MICROSEGURO.Poliza A WITH(NOLOCK)      
 INNER JOIN ProductoConcepto B       
  ON B.nPrdConceptoCod = A.nPrdConceptoCod      
 WHERE A.bEstado = 1 AND B.nTipoGastoSegCom = 4 AND @bMicroseguroAP=1 AND b.nPrdConceptoCod = 121031        
      
 SELECT @cNumPolizaMSVS = A.cNumPoliza       
 FROM MICROSEGURO.Poliza A WITH(NOLOCK)      
 INNER JOIN ProductoConcepto B       
  ON B.nPrdConceptoCod = A.nPrdConceptoCod      
 WHERE A.bEstado = 1 AND B.nTipoGastoSegCom = 6 AND @bMicroseguroVS=1       
      
  SELECT @cNumPolizaSegD = A.cNumPoliza             
  FROM MICROSEGURO.Poliza A WITH(NOLOCK)            
  INNER JOIN ProductoConcepto B             
   ON B.nPrdConceptoCod = A.nPrdConceptoCod            
  WHERE A.bEstado = 1 AND B.nTipoGastoSegCom = 7 AND @bSegDesempleo=1     
    
    SELECT @cNumPolizaSegA = A.cNumPoliza             
  FROM MICROSEGURO.Poliza A WITH(NOLOCK)            
  INNER JOIN ProductoConcepto B             
   ON B.nPrdConceptoCod = A.nPrdConceptoCod            
  WHERE A.bEstado = 1 AND B.nTipoGastoSegCom = 10 AND @bSegAgricola=1                          
    
 IF NOT EXISTS(SELECT nCodSolicitud FROM ColocSolicitud WITH(NOLOCK) WHERE nCodSolicitud = @nCodSolicitud)      
  SET @bPermiteInsertarActualizarSolicitud = 1      
 ELSE       
  IF NOT EXISTS(SELECT * FROM #ColocSolicitudEstado WITH(NOLOCK) WHERE ISNULL(nreasigna, 0) = 1)      
   SET @bPermiteInsertarActualizarSolicitud = 1      
  ELSE       
   SET @bPermiteInsertarActualizarSolicitud = 0      
      
 -- END LLENANDO VARIABLES      
 IF (@bPermiteInsertarActualizarSolicitud = 1)      
 BEGIN       
      
 IF EXISTS(SELECT nCodSolicitud FROM ColocSolicitud WITH(NOLOCK) WHERE nCodSolicitud = @nCodSolicitud)      
 BEGIN      
      
  UPDATE CS      
  SET      
  CS.cCtaCod = IIF(@nestado=2,NULL, @cCtaCod), -- SOLO SI ES NO PRECALIFICA,      
  CS.bEditado = IIF(@nNumRefUnoUno > 0, 2, 0),      
  CS.ncaptado = CST.ncaptado,      
  CS.ncuotas = CST.ncuotas,       
  CS.nmonto = CST.nmonto,      
  CS.nfrecpago = CST.nfrecpago,      
  CS.nTipoPeriodicidad = CST.nTipoPeriodicidad,      
  CS.nDiasFrecuencia = CST.nDiasFrecuencia,      
  CS.nPeriodoFechaFija = CST.nPeriodoFechaFija,      
  CS.ncondicion = CST.ncondicion,      
  CS.ncondicion2 = CST.ncondicion2,      
  CS.nestado = @nestado, --IIF(@bAutoasigna=1, 4, CST.nestado),      
  CS.ncalsbs = CST.ncalsbs,      
  CS.nmontosbs = CST.nmontosbs,      
  CS.nnumentsbs = CST.nnumentsbs,      
  CS.dfechasbs = CST.dfechasbs,      
  CS.nestadosbs = CST.nestadosbs,      
  CS.ndestino = CST.ndestino,    
  CS.nSubDestinosId = CST.nSubDestinosId,      
  CS.nTipoVivienda = CST.nTipoVivienda,      
  CS.idcampana = (      
   CASE       
    WHEN (SUBSTRING(CONVERT(VARCHAR(10),CST.nsubproducto),1,3)='211') THEN 87             
    WHEN (SUBSTRING(CONVERT(VARCHAR(10),CST.nsubproducto),1,3)='401') THEN 57             
    WHEN (SUBSTRING(CONVERT(VARCHAR(10),CST.nsubproducto),1,3)='310') THEN 63      
    WHEN (CST.idcampana = 0) THEN NULL           
    ELSE CST.idcampana      
    END      
   ),      
  CS.crfa = CST.crfa,      
  CS.ccodagebn = CST.ccodagebn,      
  CS.cperscodinst = CST.cperscodinst,      
  CS.nSubCategoriaConvenioId = CST.nsubcategoriaconvenioId,      
  CS.ccodmodular = CST.ccodmodular,      
  CS.nsubproducto = CST.nsubproducto,      
  CS.scalif0 = CST.scalif0,      
  CS.scalif1 = CST.scalif1,      
  CS.scalif2 = CST.scalif2,      
  CS.scalif3 = CST.scalif3,      
  CS.scalif4 = CST.scalif4,      
  CS.cperscodcaptado = CST.cperscodcaptado,      
  CS.ntipocredito = CST.ntipocredito,      
  CS.nAplicacion = CASE WHEN @cAgeCod IN (SELECT Items FROM dbo.FN_Split((SELECT cConsDescripcion FROM Constante WHERE nConsCod = 2100 AND nConsValor = 3),',')) THEN CST.nAplicacion      
         WHEN (SELECT COUNT(*) FROM #DatosSolicitudOnline) > 0 THEN NULL ELSE CST.nAplicacion END, -- TENER EN CUENTA LA CONSTANTE DE LAS AGENCIAS PILOTO!!!!!!!!!!!!!      
  CS.nMontoCuota = CST.nMontoCuota,      
  CS.dFechaPrimerPago = CST.dFechaPrimerPago,      
  CS.nTEM = CST.nTEM,      
  CS.nTipoGracia = CST.nTipoGracia,      
  CS.nDiasGracia = CST.nDiasGracia,       
  CS.bProximoMes = CST.bProximoMes,      
  CS.bPuntualito = CST.bPuntualito,      
  CS.bReembolsoMiViv = CST.bReembolsoMiViv,      
  CS.cLineaCred = CST.cLineaCred,      
  CS.cXmlCalendario = CST.cXmlCalendario,    
  CS.cPersCodClientePromotor = CST.cPersCodClientePromotor,    
  CS.nTipoPropuesta = CST.nTipoPropuesta    
 FROM ColocSolicitud CS       
 INNER JOIN #ColocSolicitud CST (NOLOCK)       
  ON CST.nCodsolicitud=CS.nCodSolicitud      
 END      
 ELSE      
 BEGIN      
         
  INSERT INTO ColocSolicitud (      
   ccodsolicitud      
   ,cCtaCod      
   ,bEditado      
   ,ncaptado      
   ,ncuotas      
   ,nmonto      
   ,nfrecpago      
   ,nTipoPeriodicidad      
   ,nDiasFrecuencia      
   ,nPeriodoFechaFija      
   ,ncondicion      
   ,ncondicion2      
   ,nestado      
   ,ncalsbs      
   ,nmontosbs      
   ,nnumentsbs      
   ,dfechasbs      
   ,nestadosbs      
   ,ndestino      
   ,nSubDestinosId    
   ,nTipoVivienda      
   ,idcampana      
   ,crfa      
   ,ccodagebn      
   ,cperscodinst      
   ,nsubcategoriaconvenioId      
   ,ccodmodular      
   ,nsubproducto      
   ,scalif0      
   ,scalif1      
   ,scalif2      
   ,scalif3      
   ,scalif4      
   ,cperscodcaptado      
   ,ntipocredito       
   ,nAplicacion      
   ,nMontoCuota        
   ,dFechaPrimerPago      
   ,nTEM       
   ,nTipoGracia      
   ,nDiasGracia       
   ,bProximoMes      
   ,bPuntualito      
   ,bReembolsoMiViv      
   ,cLineaCred      
   ,cXmlCalendario    
   ,cPersCodClientePromotor    
   ,nTipoPropuesta    
   )      
  SELECT       
   @cCodSolicitud      
   ,IIF(@nestado=2,NULL, @cCtaCod) -- SOLO SI ES NO PRECALIFICA      
   ,IIF(@nNumRefUnoUno > 0, 2, 0)      
   ,ncaptado      
   ,ncuotas      
   ,nmonto      
   ,nfrecpago      
   ,nTipoPeriodicidad      
   ,nDiasFrecuencia      
 ,nPeriodoFechaFija      
   ,ncondicion      
   ,ncondicion2      
   ,@nestado --IIF(@bAutoasigna=1, 4, nestado)      
   ,ncalsbs      
   ,nmontosbs      
   ,nnumentsbs      
   ,dfechasbs      
   ,nestadosbs      
   ,ndestino      
   ,nSubDestinosId    
   ,nTipoVivienda      
   ,(      
    CASE       
     WHEN (SUBSTRING(CONVERT(VARCHAR(10),nsubproducto),1,3)='211') THEN 87      
     WHEN (SUBSTRING(CONVERT(VARCHAR(10),nsubproducto),1,3)='401') THEN 57      
     WHEN (SUBSTRING(CONVERT(VARCHAR(10),nsubproducto),1,3)='310') THEN 63      
     WHEN (idcampana = 0) THEN NULL           
     ELSE idcampana      
     END      
    )      
   ,crfa      
   ,ccodagebn      
   ,cperscodinst      
   ,nsubcategoriaconvenioId      
   ,ccodmodular      
   ,nsubproducto      
   ,scalif0      
   ,scalif1      
   ,scalif2      
   ,scalif3      
   ,scalif4      
   ,cperscodcaptado      
   ,ntipocredito      
   --,nCondicionAmpliacion      
   ,CASE WHEN @cAgeCod IN (SELECT Items FROM dbo.FN_Split((SELECT cConsDescripcion FROM Constante WHERE nConsCod = 2100 AND nConsValor = 3),',')) THEN nAplicacion       
      WHEN (SELECT COUNT(*) FROM #DatosSolicitudOnline) > 0 THEN NULL -- TENER EN CUENTA LA CONSTANTE DE LAS AGENCIAS PILOTO!!!!!!!!!!!!!      
      ELSE nAplicacion END      
   ,nMontoCuota        
   ,dFechaPrimerPago      
   ,nTEM       
   ,nTipoGracia      
   ,nDiasGracia       
   ,bProximoMes      
   ,bPuntualito      
   ,bReembolsoMiViv      
   ,cLineaCred      
   ,cXmlCalendario    
   ,cPersCodClientePromotor    
   ,nTipoPropuesta    
  FROM #ColocSolicitud (NOLOCK)      
      
  SET @nCodSolicitud= SCOPE_IDENTITY()      
 END      
 END      
      
 UPDATE #ColocSolicitud      
 SET      
 nCodsolicitud = @nCodSolicitud,      
 ccodsolicitud = ISNULL(@cCodSolicitud, ''),      
 cCtaCod = IIF(@nestado=2,NULL,ISNULL(@cCtaCod, ''))      
      
 UPDATE #ColocSolicitudEstado      
 SET      
 nCodsolicitud = @nCodSolicitud      
       
 IF (@bPermiteInsertarActualizarSolicitud = 1)      
 BEGIN      
      
 IF EXISTS(SELECT nCodSolicitud FROM colocsolicitudestado WITH(NOLOCK) WHERE nCodSolicitud = @nCodSolicitud)      
 BEGIN      
  --INSERCIONS      
  INSERT INTO colocsolicitudestado(nCodSolicitud,nEstado,cMovNro,dFechaSol,dFechaAsig,nMonto,cPersCodAnalista,cMotivo,cObservacion)      
  SELECT      
   CE1.nCodSolicitud,      
   @nestado,      
   dbo.FN_UltimaCambio(@cAgeCod,@cUser) cMovNro,      
   CE1.dFechaSol,      
   CE1.dFechaAsig,      
   CET.nMonto,      
   CE1.cPersCodAnalista,      
   ISNULL(CET.cmotivo,CE1.cMotivo),      
   ISNULL(IIF(LTRIM(RTRIM(CET.cobservacion))='',NULL,CET.cobservacion), CE1.cObservacion)      
  FROM       
   #ColocSolicitudEstado CET --ON CS.nCodSolicitud=CE.nCodSolicitud AND CE.nEstado=CS.nEstado      
   LEFT JOIN colocsolicitudestado CE WITH(NOLOCK)      
    ON CET.nCodSolicitud = CE.ncodsolicitud       
    AND CET.nEstado=CE.nEstado      
   INNER JOIN ColocSolicitud CS WITH(NOLOCK)       
    ON CS.nCodSolicitud = CET.nCodSolicitud      
   INNER JOIN colocsolicitudestado CE1 WITH(NOLOCK)      
    ON CE1.nCodSolicitud=CS.nCodSolicitud       
    AND CE1.nEstado=CS.nEstado      
  WHERE CET.nestado NOT IN(6,7)       
   AND ISNULL(CE.nCodSolicitud,'') = '' --AND ISNULL(CS.nEstado,'')='' --AND CS.nEstado=CE.nestado --AND CE.nEstado<>CS.nestado-- AND CE.nEstado=CS.nestado      
      
  UPDATE CE      
  SET       
  CE.cMovNro = dbo.FN_UltimaCambio(@cAgeCod,@cUser),       
  CE.dFechaAsig=CE1.dFechaAsig,      
  CE.cPersCodAnalista =CE1.cPersCodAnalista,      
  CE.dFechaVisita=CE1.dFechaVisita,      
  CE.nMonto=CET.nMonto,      
  CE.cMotivo=ISNULL(CET.cmotivo,CE1.cMotivo),      
  CE.cObservacion=ISNULL(IIF(LTRIM(RTRIM(CET.cobservacion))='',NULL,CET.cobservacion), CE1.cObservacion)      
  FROM       
  colocsolicitudestado CE WITH(NOLOCK)      
  INNER JOIN #colocsolicitudestado CET WITH(NOLOCK) ON CET.nCodSolicitud=CE.ncodsolicitud AND CET.nEstado=CE.nEstado      
  INNER JOIN ColocSolicitud CS WITH(NOLOCK) ON CS.nCodSolicitud=CET.nCodSolicitud      
  INNER JOIN colocsolicitudestado CE1 WITH(NOLOCK) ON CE1.nCodSolicitud=CS.nCodSolicitud AND CE1.nEstado=CS.nEstado      
  WHERE       
  CE.nCodSolicitud=@nCodSolicitud AND CET.nestado NOT IN (6,7)      
 END      
 ELSE      
 BEGIN      
        
  IF (@bAutoasigna=1)      
  BEGIN      
      
   INSERT INTO colocsolicitudestado (      
   ncodsolicitud      
   ,nestado      
   ,cmovnro      
   ,dfechasol      
   ,dfechaasig      
   ,cperscodanalista      
   ,dfechavisita      
   ,nmonto      
   ,cMotivo      
  ,cObservacion       
   )      
   SELECT       
   @nCodSolicitud      
   ,1      
   ,@cMovNumero      
   ,@dFechaSolicitud      
   ,NULL        
   ,NULL       
   ,@dFechaSolicitud      
   ,nmonto      
   ,cMotivo      
   ,cObservacion      
   FROM       
   #ColocSolicitudEstado WITH(NOLOCK)      
      
   INSERT INTO colocsolicitudestado (      
   ncodsolicitud      
   ,nestado      
   ,cmovnro      
   ,dfechasol      
   ,dfechaasig      
   ,cperscodanalista      
   ,dfechavisita      
   ,nmonto      
   ,cMotivo      
   ,cObservacion       
   )      
   SELECT       
   @nCodSolicitud      
   ,4      
   ,@cMovNumero      
   ,@dFechaSolicitud      
   ,NULL        
   ,NULL       
   ,@dFechaSolicitud      
   ,nmonto      
   ,cMotivo      
   ,cObservacion      
   FROM       
   #ColocSolicitudEstado WITH(NOLOCK)      
      
  END       
      
  INSERT INTO colocsolicitudestado (      
  ncodsolicitud      
  ,nestado      
  ,cmovnro      
  ,dfechasol      
  ,dfechaasig      
  ,cperscodanalista      
  ,dfechavisita      
  ,nmonto      
  ,cMotivo      
  ,cObservacion       
  )      
  SELECT @nCodSolicitud      
   ,nestado --  IIF(@bAutoasigna = 1 ,4,nestado)      
   ,@cMovNumero      
   ,@dFechaSolicitud      
   ,         
    CASE       
    WHEN @bAutoasigna = 1      
     THEN @dFechaSolicitud      
    ELSE      
      NULL      
    END          
   ,      
    CASE       
    WHEN @bAutoasigna = 1      
     THEN cperscodanalista      
    ELSE      
      NULL      
    END         
   ,                  
   @dFechaSolicitud      
   ,nmonto,      
   cMotivo,      
   cObservacion      
  FROM #ColocSolicitudEstado WITH(NOLOCK)      
          
 END      
          
 IF (@ncondicion2 = 8)      
 BEGIN      
      
  INSERT INTO ColocSolicitudRefinanciacion       
  (      
   cCodSolicitud,      
   cCtaCodRef,      
   bCapitalizacion,      
   nPorc,      
   nMonto,      
   nCapital,      
   nIComp,      
   nIMorat,      
   nIGracia,      
   nISusp,      
   nIReprog,      
   nIGastos,      
   nICofide,      
   cUltimaActualizacion,      
   nICorrido       
  )      
  SELECT       
   @cCodSolicitud,      
   cCtaCod,      
   1,      
   1,      
   nMonto,      
   nSaldo,      
   nIntComp,      
   nIntMorat,      
   nIntGracia,      
   nIntSusp,      
   nIntReprog,      
   nIntGastos,      
   nIntCofide,      
   CONCAT(FORMAT(@dFechaSolicitud,'yyyyMMddHHmmss'),@cUser),      
   nIntCorrido       
  FROM #CreditosProceso      
      
 END      
      
 IF EXISTS(SELECT nCodSolicitud FROM ColocSolicitudPersona WITH(NOLOCK) WHERE nCodSolicitud = @nCodSolicitud)      
 BEGIN      
        
  --DELETE      
  DELETE CSP FROM ColocSolicitudPersona CSP WITH(NOLOCK)      
  LEFT JOIN #ColocSolicitudPersona CSPT  WITH(NOLOCK)      
  ON CSP.cPersCod=CSPT.cpersCod AND CSP.nPrdPersRelac = CSPT.nprdpersrelac       
  WHERE ISNULL(CSPT.cPersCod, '') = '' AND CSPT.nprdpersrelac IN (20, 28, 41) AND CSP.nCodSolicitud = @nCodSolicitud      
        
  --INSERTAR      
  INSERT INTO ColocSolicitudPersona (nCodSolicitud, nPrdPersRelac, nCodPersona, cPersCod)      
  SELECT       
   @nCodSolicitud, CSPT.nprdpersrelac, 0, CSPT.cPersCod      
  FROM #ColocSolicitudPersona CSPT WITH(NOLOCK)      
  LEFT JOIN ColocSolicitudPersona CSP WITH(NOLOCK)      
  ON CSP.cPersCod=CSPT.cpersCod AND CSP.nPrdPersRelac = CSPT.nprdpersrelac AND CSP.nCodSolicitud = @nCodSolicitud      
  WHERE ISNULL(CSP.cPersCod, '') = '' AND CSPT.nprdpersrelac IN (20, 28, 41)      
        
 END      
 ELSE      
 BEGIN      
  -- INSERTANDO PERSONAS RELACIONADAS      
  INSERT INTO ColocSolicitudPersona (      
   nCodSolicitud      
   ,nPrdPersRelac      
   ,nCodPersona      
   ,cPersCod      
   )      
  SELECT       
   @nCodSolicitud      
   ,nprdpersrelac      
   ,0      
   ,cPersCod      
  FROM #ColocSolicitudPersona WITH(NOLOCK)      
  WHERE nprdpersrelac IN (20, 28, 41)      
      
 END      
        
        
 DECLARE @cPersCodUsuario VARCHAR(20)      
 SELECT       
  @cPersCodUsuario = rh.cPersCod       
 FROM rrhh rh WITH(NOLOCK)      
  INNER JOIN RHCargos c WITH(NOLOCK)      
  ON rh.cPersCod=c.cPersCod       
  AND c.dRHCargoFecha=(SELECT MAX(dRHCargoFecha) FROM RHCargos WITH(NOLOCK) WHERE cPersCod=rh.cPersCod)       
 WHERE cUser = @cUser      
  --MOVIDO A VISTA      
  --IF @CargoUsuario='006009'      
  --BEGIN      
  -- INSERT INTO ColocSolicitudPersona (      
  --   nCodSolicitud      
  --   ,nPrdPersRelac      
  --   ,nCodPersona      
  --   ,cPersCod      
  --   )      
  --   SELECT      
  --   @nCodSolicitud      
  --   ,41      
  --   ,0      
  --   ,@cPersCodUsuario      
  --END        
       
 /*========================= PEQUEÑAS EMPRESAS  =====================*/       
 IF EXISTS(SELECT nCodSolicitud FROM colocSubTipoCredito WITH(NOLOCK) WHERE nCodsolicitud = @nCodSolicitud)      
 BEGIN      
  DELETE colocSubTipoCredito WHERE nCodsolicitud = @nCodSolicitud      
 END      
 INSERT INTO colocSubTipoCredito       
 (      
  nCodsolicitud      
  ,cCtacod      
  ,nSubTipoCredito      
  ,dFechaRegistro      
 )      
 SELECT TOP 1       
  @nCodSolicitud,      
  IIF(@nestado=2, NULL, @cCtaCod), -- SOLO SI ES NO PRECALIFICA      
  nSubTipoCredito,      
  @dFechaSolicitud      
 FROM #ColocSolicitud A WITH(NOLOCK)      
  INNER JOIN subTipoCredito B WITH(NOLOCK)      
   ON A.ntipocredito = B.nTipoCredito      
 WHERE A.ntipocredito = 13 -- PEQUEÑAS EMPRESAS      
  AND (B.nMontoEvaInicio <= A.nmonto       
    AND A.nmonto <= B.nMontoEvaFin)      
 /*====================================================================*/      
         
      
 ----INSERTEAMOS EL REGISTRO DE MICROLEASING . CDLC 08/04/2011              
 --IF (SELECT COUNT(*) FROM @Bienes) > 0      
 --BEGIN      
 -- INSERT INTO MICROLEASING.SolicitudDetalleMicroleasing       
 --  (nCodSolicitud      
 --  ,cDetalle      
 --  ,cProveedor      
 --  ,nPrecio      
 --  ,nMoneda      
 --  ,cExperienciaEquipo)      
 -- SELECT       
 --  @nCodSolicitud      
 --  ,cDetalle      
 --  ,cProveedor      
 --  ,nPrecio      
 --  ,nMoneda      
 --  ,cExperienciaEquipo      
 -- FROM @Bienes       
 --END      
      
 ----/INSERTEAMOS EL REGISTRO DE MICROLEASING . CDLC 08/04/2011             
 ----------VALIDANDO VALOR DE LA  VIVIENDA -----------------------        
 IF EXISTS( SELECT * FROM ColocSolBuenPagador A WITH(NOLOCK) WHERE SUBSTRING(CONVERT(VARCHAR(6),@nSubProducto),1,3) IN (select DISTINCT SubProducto from ColocConfigHipotecario WITH(NOLOCK)))      
 BEGIN      
  DELETE ColocSolBuenPagador WHERE nCodSolicitud = @nCodSolicitud      
 END      
      
 INSERT INTO ColocSolBuenPagador      
  (nCodSolicitud,      
  nMontoVivienda,      
  nMontoInicial,      
  bBonoBP,      
  nGastosCierre,      
  cTpoVIS,      
  nTipoBono,      
  nMontoBono,      
  nPresupuestoCons,      
                nValTerreno,      
  nBonoVerde)      
 SELECT       
  @nCodSolicitud,      
  A.nMontoVivienda,      
  A.nMontoInicial,      
  A.bBonoBP,      
  A.nGastosCierre,      
  A.cTpoVIS,      
  A.nTipoBono,      
  A.nMontoBono,      
  A.nPresupuestoCons,      
  A.nValTerreno,      
  A.nBonoVerde      
 FROM #MontoHipotecario A (NOLOCK)      
 WHERE SUBSTRING(CONVERT(VARCHAR(6),@nSubProducto),1,3) IN (select DISTINCT SubProducto from ColocConfigHipotecario WITH(NOLOCK));      
        
  ------------------------------------------------------------------                  
 --INSERTAMOS  EL REGISTRO DE MICROSEGURO. cdlc 20/09/2010         
       
 IF EXISTS ( SELECT       
     A.cNumPoliza       
    FROM MICROSEGURO.MicroseguroSolicitudCredito A WITH(NOLOCK)     
    INNER JOIN MICROSEGURO.Poliza B       
     ON B.cNumPoliza = A.cNumPoliza       
    INNER JOIN ProductoConcepto C       
     ON C.nPrdConceptoCod = B.nPrdConceptoCod       
    WHERE C.nTipoGastoSegCom = 4 AND A.nCodSolicitud = @nCodSolicitud)        
 BEGIN      
  DELETE A      
  --SELECT A.cNumPoliza       
  FROM MICROSEGURO.MicroseguroSolicitudCredito A WITH(NOLOCK)       
  INNER JOIN MICROSEGURO.Poliza B       
   ON B.cNumPoliza = A.cNumPoliza       
  INNER JOIN ProductoConcepto C       
   ON C.nPrdConceptoCod = B.nPrdConceptoCod       
  WHERE C.nTipoGastoSegCom = 4 AND A.nCodSolicitud = @nCodSolicitud      
 END      
      
 IF RTRIM(LTRIM(@cNumPolizaMSAP)) <> ''      
 BEGIN      
         
  INSERT INTO MICROSEGURO.MicroseguroSolicitudCredito       
   (nCodSolicitud      
   ,cNumPoliza      
   ,cUltimaActualizacion)      
  VALUES       
   (@nCodSolicitud      
   ,@cNumPolizaMSAP      
   ,@cMovNumero)      
 END      
      
 IF EXISTS ( SELECT       
     A.cNumPoliza       
    FROM MICROSEGURO.MicroseguroSolicitudCredito A WITH(NOLOCK)       
    INNER JOIN MICROSEGURO.Poliza B       
     ON B.cNumPoliza = A.cNumPoliza       
    INNER JOIN ProductoConcepto C       
     ON C.nPrdConceptoCod = B.nPrdConceptoCod       
    WHERE C.nTipoGastoSegCom = 6 AND A.nCodSolicitud = @nCodSolicitud)        
 BEGIN      
  DELETE A      
  --SELECT A.cNumPoliza       
  FROM MICROSEGURO.MicroseguroSolicitudCredito A WITH(NOLOCK)       
  INNER JOIN MICROSEGURO.Poliza B       
   ON B.cNumPoliza = A.cNumPoliza       
  INNER JOIN ProductoConcepto C       
   ON C.nPrdConceptoCod = B.nPrdConceptoCod       
  WHERE C.nTipoGastoSegCom = 6 AND A.nCodSolicitud = @nCodSolicitud      
 END      
      
 IF RTRIM(LTRIM(@cNumPolizaMSVS)) <> ''      
 BEGIN      
         
  INSERT INTO MICROSEGURO.MicroseguroSolicitudCredito       
   (nCodSolicitud      
   ,cNumPoliza      
   ,cUltimaActualizacion)      
  VALUES       
   (@nCodSolicitud      
   ,@cNumPolizaMSVS      
   ,@cMovNumero)      
 END      
      
--INSERTAMOS  EL REGISTRO DE SEGURO DE DESEMPLEO          
 IF EXISTS ( SELECT             
     A.cNumPoliza             
    FROM MICROSEGURO.MicroseguroSolicitudCredito A WITH(NOLOCK)             
    INNER JOIN MICROSEGURO.Poliza B             
     ON B.cNumPoliza = A.cNumPoliza             
    INNER JOIN ProductoConcepto C             
     ON C.nPrdConceptoCod = B.nPrdConceptoCod             
    WHERE C.nTipoGastoSegCom = 7 AND A.nCodSolicitud = @nCodSolicitud)              
 BEGIN            
  DELETE A            
  --SELECT A.cNumPoliza             
  FROM MICROSEGURO.MicroseguroSolicitudCredito A WITH(NOLOCK)             
  INNER JOIN MICROSEGURO.Poliza B             
   ON B.cNumPoliza = A.cNumPoliza             
  INNER JOIN ProductoConcepto C             
   ON C.nPrdConceptoCod = B.nPrdConceptoCod             
  WHERE C.nTipoGastoSegCom = 7 AND A.nCodSolicitud = @nCodSolicitud            
 END            
            
 IF RTRIM(LTRIM(@cNumPolizaSegD)) <> ''            
 BEGIN            
               
  INSERT INTO MICROSEGURO.MicroseguroSolicitudCredito             
   (nCodSolicitud            
   ,cNumPoliza            
   ,cUltimaActualizacion)            
  VALUES             
   (@nCodSolicitud            
   ,@cNumPolizaSegD            
   ,@cMovNumero)            
 END    
    
--INSERTAMOS  EL REGISTRO DE SEGURO DE DESEMPLEO          
 IF EXISTS ( SELECT             
     A.cNumPoliza             
    FROM MICROSEGURO.MicroseguroSolicitudCredito A WITH(NOLOCK)             
    INNER JOIN MICROSEGURO.Poliza B             
     ON B.cNumPoliza = A.cNumPoliza             
    INNER JOIN ProductoConcepto C             
     ON C.nPrdConceptoCod = B.nPrdConceptoCod             
    WHERE C.nTipoGastoSegCom = 10 AND A.nCodSolicitud = @nCodSolicitud)              
 BEGIN            
  DELETE A            
  --SELECT A.cNumPoliza             
  FROM MICROSEGURO.MicroseguroSolicitudCredito A WITH(NOLOCK)             
  INNER JOIN MICROSEGURO.Poliza B             
   ON B.cNumPoliza = A.cNumPoliza             
  INNER JOIN ProductoConcepto C             
   ON C.nPrdConceptoCod = B.nPrdConceptoCod             
  WHERE C.nTipoGastoSegCom = 10 AND A.nCodSolicitud = @nCodSolicitud            
 END            
            
 IF RTRIM(LTRIM(@cNumPolizaSegA)) <> ''            
 BEGIN            
               
  INSERT INTO MICROSEGURO.MicroseguroSolicitudCredito             
   (nCodSolicitud            
   ,cNumPoliza            
   ,cUltimaActualizacion)            
  VALUES             
   (@nCodSolicitud            
   ,@cNumPolizaSegA            
   ,@cMovNumero)            
 END    
    
 IF EXISTS(SELECT TOP 1 cPersCod FROM TiendaCAVTCred WITH(NOLOCK) WHERE cCodSolicitud = @cCodSolicitud)      
 BEGIN      
  DELETE TiendaCAVTCred WHERE cCodSolicitud = @cCodSolicitud      
  UPDATE ColocSolicitud      
  SET      
   cPersCodInst = NULL      
  WHERE nCodSolicitud=@nCodSolicitud      
 END       
 --INSERTAMOS EL CONVENIO TIPO CAVT      
 IF LEFT(@cCodModular,4)='CAVT'      
 BEGIN        
  insert into TiendaCAVTCred (cPersCod, cCodSolicitud, cCtaCod)      
  values (SUBSTRING(@cCodModular,5,LEN(@cCodModular)-4), @cCodSolicitud, IIF(@nestado=2, NULL, @cCtaCod)) -- SOLO SI ES NO PRECALIFICA)      
      
  UPDATE ColocSolicitud      
  SET      
   cPersCodInst=SUBSTRING(@cCodModular,5,LEN(@cCodModular)-4)      
  WHERE nCodSolicitud=@nCodSolicitud      
 END      
      
 IF EXISTS(SELECT TOP 1 ncodproy FROM ColocSolProyectos WITH(NOLOCK) WHERE nCodSolicitud = @nCodSolicitud)      
 BEGIN      
  DELETE ColocSolProyectos WHERE nCodSolicitud = @nCodSolicitud      
 END      
 --/INSERTAMOS  EL REGISTRO DE MICROSEGURO. cdlc 20/09/2010           
 INSERT INTO ColocSolProyectos(nCodSolicitud,ncodproy)         
 SELECT       
  @nCodSolicitud,      
  A.cProyecto      
 FROM #ColocSolicitud A (NOLOCK)      
 WHERE A.cProyecto > 0        
         
  --INI LFAM 08/06/2013--Identificacion de Proyectos Inmobiliarios--      
      
  IF LEFT(@nSubProducto, 1) = 4      
  BEGIN      
   UPDATE ColocSolicitud      
   SET nCodProyInmob   = @nCodProyInmob      
   WHERE nCodSolicitud = @nCodSolicitud      
  END      
      
  --FIN LFAM 08/06/2013--Identificacion de Proyectos Inmobiliarios--       
          
  --INI LFAM 16/03/2015 Proyecto Cajeros corresponsales      
      
  IF @nIdCanalDesembolso > 0      
  BEGIN      
   UPDATE ColocSolicitud      
   SET nIdCanalDesembolso = @nIdCanalDesembolso      
   WHERE nCodSolicitud = @nCodSolicitud      
  END      
  --  COMMIT TRANSACTION Operacion           
        
      
  IF EXISTS (SELECT TOP 1 nCodSolicitud FROM ColocSolicitudVisita WITH(NOLOCK) WHERE nCodSolicitud = @nCodSolicitud)      
  BEGIN      
   DELETE ColocSolicitudVisita WHERE nCodSolicitud = @nCodSolicitud      
  END      
      
  IF (@nestado IN (3,4,5,6,7))      
  BEGIN      
   /******************** INICIO INSERTANDO LA PROGRAMACIÓN DEL CRÉDITO *******************/        
   INSERT INTO ColocSolicitudVisita      
    (nCodSolicitud, dFechaVisita, cmovNro)      
   VALUES      
    (@nCodSolicitud, @dFechaSolicitud, @cMovNumero)      
   /******************* FIN INSERTANDO LA PROGRAMACIÓN DEL CRÉDITO **********************/      
  END      
      
  /******************** INICIO MODIFICAR TABLA DE MOTOR DE RESULTADOS *******************/      
        
  --INSERTAR EN MOTOR RESULTADOS      
      
      
  INSERT INTO Colocaciones.MotorResultado      
   (      
   nIdEjecucion      
   ,nIdObjeto      
   ,nTipoCodigo      
   ,cCodigo      
   ,nColocCondicion2      
   ,nNumRefinanc      
   ,nIdGrupo      
   ,nIdRegla      
   ,nIdCaso      
   ,bAplica      
   ,bResultado      
   ,cMensaje      
   ,bExceptuado      
                        ,nTipoResultado      
   ,nTipoValidacion      
   ,dFechaRegistro      
   ,cUser      
   ,cAgeCodUser      
   )      
  SELECT      
    MR.nIdEjecucion      
   ,MR.nIdObjeto      
   ,2 AS nTipoCodigo      
   ,CONVERT(VARCHAR(100),@nCodsolicitud)      
   ,MR.nColocCondicion2      
   ,MR.nNumRefinanc      
   ,MR.nIdGrupo      
   ,MR.nIdRegla      
   ,MR.nIdCaso      
   ,MR.bAplica      
   ,MR.bResultado      
   ,MR.cMensaje      
   ,MR.bExceptuado      
                        ,MR.nTipoResultado      
   ,MR.nTipoValidacion      
   ,MR.dFechaRegistro      
   ,MR.cUser      
   ,MR.cAgeCodUser      
  FROM      
   Colocaciones.MotorResultado  MR WITH(NOLOCK)      
   INNER JOIN #MotorResultado tMR WITH(NOLOCK)      
   on MR.nIdEjecucion = tMR.nIdEjecucion       
   AND MR.nIdObjeto = tMR.nIdObjeto        
   AND MR.nTipoCodigo = 1        
   AND MR.cCodigo = tMR.cTimeEjecucion      
        
  --INSERTAR EN EL HISTORIAL DE MOTOR RESULTADOS      
      
  INSERT INTO Colocaciones.MotorResultadoHist      
   (      
   nId,      
   nIdEjecucion      
   ,nIdObjeto      
   ,nTipoCodigo      
   ,cCodigo      
   ,nColocCondicion2      
   ,nNumRefinanc      
   ,nIdGrupo      
   ,nIdRegla      
   ,nIdCaso      
   ,bAplica      
   ,bResultado      
   ,cMensaje      
   ,bExceptuado      
                        ,nTipoResultado      
   ,nTipoValidacion      
   ,dFechaRegistro      
   ,cUser      
   ,cAgeCodUser      
   ,nTipoOpe      
   ,dFechaOpe      
   )      
  SELECT      
  MR.nId      
   ,MR.nIdEjecucion      
   ,MR.nIdObjeto      
   ,2 AS nTipoCodigo      
   ,CONVERT(VARCHAR(100),@nCodsolicitud)      
   ,@ncondicion2      
   ,MR.nNumRefinanc      
   ,MR.nIdGrupo      
   ,MR.nIdRegla      
   ,MR.nIdCaso      
   ,MR.bAplica      
   ,MR.bResultado      
   ,MR.cMensaje      
   ,MR.bExceptuado      
                        ,MR.nTipoResultado      
   ,MR.nTipoValidacion      
   ,MR.dFechaRegistro      
   ,MR.cUser      
   ,MR.cAgeCodUser      
   ,1      
   ,GETDATE()      
  FROM      
   Colocaciones.MotorResultado MR WITH(NOLOCK)      
   INNER JOIN #MotorResultado tMR WITH(NOLOCK)      
   on MR.nIdEjecucion = tMR.nIdEjecucion       
   AND MR.nIdObjeto = tMR.nIdObjeto        
   AND MR.nTipoCodigo = 1        
   AND MR.cCodigo = tMR.cTimeEjecucion      
      
        
  /******************** FIN MODIFICAR TABLA DE MOTOR DE RESULTADOS *******************/      
      
  END      
       
  /******************************** INICIO AGROPECUARIO *********************************/      
  IF (@nCodActividadAgropecuaria <> 0)      
  BEGIN      
   DECLARE @cActivDescripcion VARCHAR(50)      
   SELECT       
    @cActivDescripcion = A.cDescripcionActiv       
   FROM       
    actividadesAgropecuarias A (NOLOCK)      
   WHERE       
    A.nCodActividad = @nCodActividadAgropecuaria      
         
   IF EXISTS(SELECT TOP 1 nCodActividadAgro FROM colocSolicitudProductoAgropecuario WITH(NOLOCK) WHERE cCodsolicitud = @cCodSolicitud)        
   BEGIN      
    UPDATE A      
    SET A.nCodActividadAgro = @nCodActividadAgropecuaria,      
     A.cDescripcionActiv = @cActivDescripcion,      
     A.nTipoSegmento = @nTipoSegmento,      
     A.nCodSubDestinoAgropecuario = @nCodSubDestinoAgropecuario,      
     A.cDescSubDestinoAgropecuario = @cDescSubDestinoAgropecuario,      
     A.nIdCultivo = @nIdCultivo      
    FROM colocSolicitudProductoAgropecuario A      
    WHERE cCodsolicitud = @cCodSolicitud      
   END      
   ELSE      
   BEGIN      
    INSERT INTO colocSolicitudProductoAgropecuario (cCodsolicitud, cCredProducto, nCodActividadAgro, cDescripcionActiv, nTipoSegmento, nCodSubDestinoAgropecuario, cDescSubDestinoAgropecuario, nIdCultivo)      
    VALUES (@cCodSolicitud,SUBSTRING(CONVERT(VARCHAR(6),@nSubProducto),1,3),@nCodActividadAgropecuaria,@cActivDescripcion, @nTipoSegmento, @nCodSubDestinoAgropecuario, @cDescSubDestinoAgropecuario, @nIdCultivo)      
   END      
      
  END      
    
  IF (@bProspectoAgropecuario = 1)  
  BEGIN   
     UPDATE FARMING.ClientesRegistrados SET cCtaCod = @cCtaCod   
     WHERE nClientesRegistradosId = @nCodClienteProspectoAgropecuario  
     AND cCtaCod IS NULL  
  END  
  /******************************** FIN AGROPECUARIO *********************************/       
      
      
 IF EXISTS (SELECT cCodSolicitud FROM COLOCACIONES.ColocProcedenciaSolCred WITH(NOLOCK) WHERE cCodSolicitud = @cCodSolicitud)        
 BEGIN      
  DELETE COLOCACIONES.ColocProcedenciaSolCred WHERE cCodSolicitud = @cCodSolicitud      
 END      
 --INICIO INSERTA LA PROCEDENCIA DE LA SOLICITUD DE CRÉDITO      
  INSERT INTO COLOCACIONES.ColocProcedenciaSolCred       
  (      
   cAgeCod,       
   cOfiInfCod,      
   bCheckProc,      
   cCodSolicitud,      
   cUser,      
   cUltimaActualizacion      
  )      
  SELECT       
   @cAgeCod,      
   cOfiInfCod,      
   bCheckProc,      
   @cCodSolicitud,      
   @cUser,      
   dbo.FN_UltimaActualizacionSist(@cUser)      
  FROM      
   #ColocSolicitud      
  WHERE      
   --EXISTS(SELECT cAgeCod FROM COLOCACIONES.OficinaInformativaXAge WITH(NOLOCK) WHERE cAgeCod = @cAgeCod)     
   EXISTS(SELECT A.cAgeCod FROM Agencias A WITH (NOLOCK)     
   INNER JOIN OficinasInformativas B WITH (NOLOCK) ON A.cAgeCod=B.cAgeDependencia    
   WHERE A.bActivo=1 AND B.bActivo=1 AND A.cAgeCod = @cAgeCod)                 
    
       
 /******************************** INICIO SEGUIMIENTO *********************************/      
 IF (@nestado IN (1,4,6,7))      
 BEGIN              
  DECLARE @cMotivo VARCHAR(300) ,@cObservacion VARCHAR(300)      
  SELECT       
   @cMotivo=cMotivo,      
   @cObservacion=cObservacion      
  FROM      
   #ColocSolicitudEstado WITH(NOLOCK)      
      
  IF EXISTS (SELECT 1 FROM #DatosSolicitudOnline)      
  BEGIN      
   INSERT INTO #ColocSolicitudPersona (nprdpersrelac ,cPersCod)      
   SELECT TOP 1 28, cCodAnalista FROM ColocSolicitudOnlineAnalistas WHERE cAgeCod = @cAgeCod ORDER BY cCodAnalista      
  END      
      
  EXEC COLOCACIONES.FluGenSol_InsSeguimientoPropCalif_SP     
   @nCodSolicitud,      
   @cUser,      
   @nestado,      
   @dFechaSolicitud,      
   @dFechaSolicitud,      
   @dFechaSolicitud,      
   @cMotivo,      
   @cObservacion,      
   @cCtaCod OUTPUT,      
   @cCodError OUTPUT      
           
 END      
        
 /******************************* FIN DE SEGUIMIENTO **********************************/      
        
    
 -- ACTUALIZACIÓN DE CUENTA PARA SEGMENTACIÓN DE ALERTA    
 DECLARE @nColocAlertaSegmentacionId int = 0    
 SELECT @nColocAlertaSegmentacionId = T.Item.value('@nColocAlertaSegmentacionId', 'INT')     
 FROM @xPropuesta.nodes('PropuestaDto') AS T(Item)    
    
 UPDATE A SET    
 A.cCtaCod = @cCtaCod --SELECT *    
 FROM COLOCACIONES.ColocAlertaSegmentacion A    
 WHERE A.nColocAlertaSegmentacionId = @nColocAlertaSegmentacionId    
 AND ISNULL(A.cCtaCod, '') = ''    
    
 --FIN INSERTA LA PROCEDENCIA DE LA SOLICITUD DE CRÉDITO    
     
 IF NOT EXISTS (SELECT idCampana FROM ColocCredCampana WITH(NOLOCK) WHERE nCodSolicitud = @nCodSolicitud)        
 BEGIN      
  INSERT INTO ColocCredCampana       
   (nCodSolicitud      
   ,cCtaCod      
   ,idCampana      
   ,nTEACredCompraDeuda      
   ,bCompraDeuda      
   ,bAsumirGastosTasNot      
   ,bUnificDeuda)      
  SELECT       
   @nCodSolicitud,      
   IIF(@nNumRefUnoUno >= 1, NULL, @cCtaCod),       
   ISNULL( A.idcampana,0),      
   iif(ISNULL(nTEACampCD,0)<>0,nTEACampCD,NULL),      
   bCompraDeuda,      
   bAsumirGastosTasNot,      
   bUnifDeuda      
  FROM #ColocSolicitud A WITH(NOLOCK)      
  --WHERE ISNULL( A.idcampanaNew,0) <> 0      
 END      
 ELSE      
 BEGIN --COLOCCREDCAMPANA      
   UPDATE CCC      
   SET      
    CCC.cCtaCod = IIF(@nNumRefUnoUno >= 1, NULL, @cCtaCod),      
    CCC.idcampana =ISNULL(CS.idcampana, 0),      
    CCC.nTEACredCompraDeuda = iif(ISNULL(CS.nTEACampCD,0) <> 0, CS.nTEACampCD, NULL),      
    CCC.bCompraDeuda = CS.bCompraDeuda,      
    CCC.bAsumirGastosTasNot = CS.bAsumirGastosTasNot,      
    CCC.bUnificDeuda = CS.bUnifDeuda      
   FROM       
   ColocCredCampana CCC WITH(NOLOCK)      
   INNER JOIN #ColocSolicitud CS WITH(NOLOCK)      
   ON CCC.nCodSolicitud = CS.nCodSolicitud      
 END --COLOCCREDCAMPANA      
      
 --INSERTANDO EN TABLA COLOCCREDCAMPANA (CAMPAÑAS)      
  
 /******************************** FLUJO TCEA Y TASA ESPECIAL **************************************/  
 BEGIN --SOLICITUD DEL CREDITO  
  
 --FLUJO NORMAL  
 IF NOT EXISTS (SELECT cCtaCod FROM ColocacEstado WHERE cCtaCod = @cCtaCod AND nPrdEstado = 2001)  
 BEGIN   
  UPDATE CE   
  SET CE.nTcea = CS.NTcea, CE.nTemMin = CS.nTemMin, CE.nTemMax = CS.nTemMax  
  FROM ColocacEstado CE  
  INNER JOIN #ColocSolicitud CS ON CE.cCtaCod = CS.cCtaCod  
  LEFT JOIN Producto P ON P.cCtaCod = CE.cCtaCod  
  WHERE CE.cCtaCod = @cCtaCod AND CE.nPrdEstado = 2000  
 END  
  
 --REFINANCIACION  
 IF NOT EXISTS (SELECT cCtaCod FROM ColocacEstadoRefinanciacion WHERE cCtaCod = @cCtaCod AND nPrdEstado = 2001)  
 BEGIN   
  UPDATE CER   
  SET CER.nTcea = CS.NTcea, CER.nTemMin = CS.nTemMin, CER.nTemMax = CS.nTemMax  
  FROM ColocacEstadoRefinanciacion CER  
  INNER JOIN #ColocSolicitud CS ON CER.cCtaCod = CS.cCtaCod  
  LEFT JOIN Producto P ON P.cCtaCod = CER.cCtaCod  
  WHERE CER.cCtaCod = @cCtaCod AND CER.nPrdEstado = 2000  
 END  
   
 END      
 /************************** FIN DE FLUJO TCEA Y TASA BLINDAJE **************************************/  
      
 /*********************** INICIO ENVIANDO EMAIL A CALL CENTER *******************************/      
      
 IF EXISTS ( SELECT * FROM #ColocSolicitud WITH(NOLOCK) WHERE ncaptado IN (3,4))      
 BEGIN      
      
  DECLARE @cUserEnvioCorreo VARCHAR(100);      
  DECLARE @cUserCopiaCorreo VARCHAR(150);      
  DECLARE @Serv VARCHAR(100);      
  DECLARE @cNombreCallCenter VARCHAR(300);      
  DECLARE @cEstado VARCHAR(100)      
  DECLARE @cNombreTitular VARCHAR(300);      
  DECLARE @cDoi VARCHAR(18)      
  DECLARE @cProfileCorreo VARCHAR(20)      
      
  SELECT @Serv = nConsSisValor  FROM ConstSistema WHERE nConsSisCod=86      
  SELECT @cProfileCorreo = nConsSisValor FROM ConstSistema WITH(NOLOCK) WHERE nConsSisCod=2104      
      
  SELECT       
   @cNombreTitular = A.cPersNombre,      
   @cDoi = C.cPersIDnro      
  FROM Persona A      
   INNER JOIN #ColocSolicitudPersona B WITH(NOLOCK)      
   ON A.cPersCod = B.cpersCod      
   INNER JOIN PersID C WITH(NOLOCK)      
   ON A.cPersCod = C.cPersCod      
  WHERE B.nprdpersrelac = 20         
      
  SELECT @cNombreCallCenter = A.cPersNombre      
  FROM Persona A WITH(NOLOCK)      
   INNER JOIN rrhh B WITH(NOLOCK)      
   ON A.cPersCod = B.cPersCod      
  WHERE B.cUser= @cUser      
      
  SELECT      
   @cEstado = C.cConsDescripcion      
  FROM Constante C WITH(NOLOCK)      
  WHERE nConsCod = 9068      
  AND nConsValor = @nestado      
      
  -----------------------------------------------------------------      
  DECLARE @TCargos TABLE (cRHCargoCod VARCHAR(6), nOrdenCorreo INT)      
  DECLARE @cAgeGrupo CHAR(2),@CorreoVentas VARCHAR(100)      
          
  SET @cAgeGrupo  = (SELECT cAgeGrupo FROM Agencias WITH(NOLOCK) WHERE cAgeCod = @cAgeCod )       
      
  INSERT INTO @TCargos (cRHCargoCod,nOrdenCorreo  )      
  VALUES ('004001',1),      
   ('004004',2),      
   ('003016',3),      
   ('003024',4),      
   ('002001',5),      
   ('002002',6),      
   ('002003',7),      
   ('002009',8)      
       
  SELECT       
   RH.cPersCod, UPPER(RH.cUser) AS cUser, RH.cAgenciaActual, dRHCargoFecha, RHC.cRHCargoCod,      
   ROW_NUMBER() OVER (PARTITION BY RH.cPersCod ORDER BY RHC.dRHCargoFecha DESC) AS nOrden      
  INTO #RRHHTemp      
  FROM RRHH RH WITH(NOLOCK)      
   INNER JOIN RHCargos RHC WITH(NOLOCK) ON RH.cPersCod = RHC.cPersCod       
  WHERE RH.nRHEstado IN (201) AND LEFT(cRHCod,1) = 'E' AND RH.dCese IS NULL       
  ORDER BY RH.cPersCod        
      
  DELETE FROM #RRHHTemp WHERE nOrden <> 1      
      
  SELECT @cUserEnvioCorreo= Z.cUser + @Serv      
  FROM(      
   SELECT TOP 1      
    ISNULL(RH.cUser,'') AS cUser,       
    ISNULL(T.nOrdenCorreo,0) AS nOrdenCorreo,      
    CASE RH.cAgenciaActual WHEN @cAgeCod THEN 1 ELSE 2 END   AS nOrdenAgeGrupo          
   FROM #RRHHTemp RH WITH(NOLOCK)      
    INNER JOIN @TCargos T ON T.cRHCargoCod = RH.cRHCargoCod          
   WHERE RH.cAgenciaActual  = @cAgeCod OR RH.cAgenciaActual  =  @cAgeGrupo         
   ORDER BY nOrdenAgeGrupo, T.nOrdenCorreo  ASC      
  ) Z      
  SELECT @CorreoVentas = C.nConsSisValor FROM ConstSistema C WHERE C.nConsSisCod=7001      
  DROP TABLE #RRHHTemp      
  DECLARE @CuerpoMsj VARCHAR(MAX)      
      
  SET  @CuerpoMsj=      
   N'<table border="1" cellspacing="0" cellpadding="0" style="border-collapse:collapse;border-style:none;">      
   <tr>      
   <td colspan="2" style="background-color:#F24B4B;padding:3pt 15pt;"><span style="background-color:#F24B4B;">      
   <div align="center" style="text-align:center;margin:0;"><font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Arial,sans-serif" color="white"><b>SOLICITUD POR ASIGNAR REGISTRADA</b></font></span></font>      
   </span></td>      
   </tr>      
   <tr>      
   <td style="background-color:#F24B4B;padding:3pt 15pt;"><span style="background-color:#F24B4B;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Arial,sans-serif" color="white"><b>Solicitud:</b></font></span></font>      
   </span></td>      
   <td style="padding:3pt;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Tahoma,sans-serif">' +@cCodSolicitud +'</font></span></font>      
   </td>      
   </tr>      
   <tr>      
   <td style="background-color:#F24B4B;padding:3pt 15pt;"><span style="background-color:#F24B4B;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Arial,sans-serif" color="white"><b>Fecha Solicitud</b></font></span></font>      
   </span></td>      
   <td style="padding:3pt;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Tahoma,sans-serif">' + FORMAT(@dFechaSolicitud, 'dd/MM/yyyy HH:mm:ss tt') +'</font></span></font>      
   </td>      
   </tr>      
   <tr>      
   <td style="background-color:#F24B4B;padding:3pt 15pt;"><span style="background-color:#F24B4B;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Arial,sans-serif" color="white"><b>Ingresado por:</b></font></span></font>      
   </span></td>      
   <td style="padding:3pt;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Tahoma,sans-serif">' + @cNombreCallCenter +'</font></span></font>      
   </td>      
   </tr>      
   <tr>      
   <td style="background-color:#F24B4B;padding:3pt 15pt;"><span style="background-color:#F24B4B;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Arial,sans-serif" color="white"><b>Estado:</b></font></span></font>      
   </span></td>      
   <td style="padding:3pt;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Tahoma,sans-serif">' +@cEstado +'</font></span></font>      
   </td>      
   </tr>      
   <tr>      
   <td style="background-color:#F24B4B;padding:3pt 15pt;"><span style="background-color:#F24B4B;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Arial,sans-serif" color="white"><b>Solicitante:</b></font></span></font>      
   </span></td>      
   <td style="padding:3pt;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Tahoma,sans-serif">' + @cNombreTitular +'</font></span></font>      
   </td>      
   </tr>      
   <tr>      
   <td style="background-color:#F24B4B;padding:3pt 15pt;"><span style="background-color:#F24B4B;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Arial,sans-serif" color="white"><b>DOI:</b></font></span></font>      
   </span></td>      
   <td style="padding:3pt;">      
   <font face="Times New Roman,serif" size="3"><span style="font-size:12pt;"><font face="Tahoma,sans-serif">' + @cDoi +'</font></span></font>      
   </td>      
   </tr>      
   </table>';      
         
  SET @cUserCopiaCorreo = @cUser + @Serv + @CorreoVentas      
      
   EXEC MSDB.[DBO].SP_SEND_DBMAIL                                   
   @PROFILE_NAME = @cProfileCorreo,                                  
   @SUBJECT = 'Solicitud de Crédito',                 
   @BODY = @CuerpoMsj,                
   @RECIPIENTS = @cUserEnvioCorreo ,       
   @COPY_RECIPIENTS = @cUserCopiaCorreo,                      
   @BLIND_COPY_RECIPIENTS = '',                                          
   @BODY_FORMAT='HTML',                        
   @IMPORTANCE = 'HIGH'       
 END      
 /************************ FIN ENVIANDO EMAIL A CALL CENTER *********************************/            
       
 BEGIN --INSERTAR REFINANCIACIONES      
  IF (@ncondicion2 = 8)      
  BEGIN      
   IF EXISTS(SELECT A.cCtaCod FROM ColocacRefinanc A       
      INNER JOIN  ColocacRefinancDet B       
       ON A.cCtaCod = B.cCtaCod       
       AND A.nEstado = B.nEstado       
       AND A.dEstado = B.dEstado       
      WHERE A.cCtaCod = @cCtaCod AND A.nEstado = 1 AND A.bRefinanciado = 0      
       AND A.dEstado = (SELECT MAX(dEstado) FROM ColocacRefinanc where cCtaCod = @cCtaCod) )      
   BEGIN      
    DELETE B FROM ColocacRefinanc A       
      INNER JOIN  ColocacRefinancDet B       
       ON A.cCtaCod = B.cCtaCod       
       AND A.nEstado = B.nEstado       
       AND A.dEstado = B.dEstado       
      WHERE A.cCtaCod = @cCtaCod AND A.nEstado = 1 AND A.bRefinanciado = 0      
       AND A.dEstado = (SELECT MAX(dEstado) FROM ColocacRefinanc where cCtaCod = @cCtaCod)       
   END      
      
   IF EXISTS(SELECT cCtaCod FROM ColocacRefinanc A       
      WHERE A.cCtaCod = @cCtaCod AND A.nEstado = 1 AND A.bRefinanciado = 0      
       AND A.dEstado = (SELECT MAX(dEstado) FROM ColocacRefinanc where cCtaCod = @cCtaCod))      
BEGIN      
    DELETE A FROM ColocacRefinanc A       
      WHERE A.cCtaCod = @cCtaCod AND A.nEstado = 1 AND A.bRefinanciado = 0      
       AND A.dEstado = (SELECT MAX(dEstado) FROM ColocacRefinanc where cCtaCod = @cCtaCod)      
   END      
      
   DECLARE @bCapitalizacion BIT = 1,      
     @nPorc FLOAT = 1,      
     @TCRef MONEY = (SELECT TOP 1 nValFijo  FROM TipoCambio  ORDER BY dFecCamb  DESC),      
     @nMontoRefTot Money        
   DECLARE @TABLA_COLOCACREFINAN AS TABLE (cCtaCod VARCHAR(25), cCtaCodRef VARCHAR(25), nEstado INT, dEstado DATETIME, nPorc FLOAT, nMontoRef FLOAT, bSustiDeudor BIT, bRFA BIT, nCalificacion INT)       
   DECLARE @TABLA_COLOCACREFINANDET AS TABLE (cCtaCod VARCHAR(25), cCtaCodRef VARCHAR(25), nEstado INT, dEstado DATETIME, nPrdConceptoCod  INT, nMonto FLOAT, nMontoPagado FLOAT)      
      
   INSERT INTO @TABLA_COLOCACREFINAN(cCtaCod,cCtaCodRef,nEstado,dEstado,nPorc,nMontoRef,bSustiDeudor)          
   SELECT         
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    1 AS nPorc,       
    R.nMonto AS nMontoRef,         
    0 AS bSustiDeudor           
   FROM #CreditosProceso R      
                                                
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,              1000 AS nPrdConceptoCod,            
    R.nSaldo AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R       
      
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    1100 AS nPrdConceptoCod,            
    R.nIntComp AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R          
      
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    1119 AS nPrdConceptoCod,            
    R.nIntCorrido AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R          
      
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    1101 AS nPrdConceptoCod,            
    R.nIntMorat AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R        
      
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    1102 AS nPrdConceptoCod,            
    R.nIntGracia AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R        
      
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    1104 AS nPrdConceptoCod,            
    R.nIntSusp AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R       
      
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    1103 AS nPrdConceptoCod,            
    R.nIntReprog AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R        
      
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    1299 AS nPrdConceptoCod,            
    R.nIntGastos AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R       
      
   INSERT INTO @TABLA_COLOCACREFINANDET (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)          
   SELECT       
    @cCtaCod AS cCtaCod,            
    R.cCtaCod AS cCtaCodRef,            
    1 AS nEstado,            
    @dFechaSolicitud AS dEstado,            
    124352 AS nPrdConceptoCod,            
    R.nIntCofide AS nMonto,          
    0.00 AS nMontoPagado          
   FROM #CreditosProceso R      
         
   DELETE FROM @TABLA_COLOCACREFINANDET WHERE nMonto = 0        
      
   SELECT          
   @nMontoRefTot =         
   SUM( CASE         
   WHEN @bCapitalizacion =1 then ROUND(capital*factor,2) + @nPorc * ( ROUND(interes*factor,2) + ROUND(gastos*factor,2)  )        
   ELSE ROUND(capital * factor,2)         
   END)                        
   FROM          
   (          
    SELECT           
     Factor = CASE         
     WHEN SUBSTRING(cCtaCod ,9,1) = SUBSTRING(cCtaCodRef,9,1) THEN 1           
     WHEN SUBSTRING(cCtaCod ,9,1) = '1' and SUBSTRING(cCtaCodRef,9,1)='2' THEN @TCRef           
     WHEN SUBSTRING(cCtaCod ,9,1) = '2' and SUBSTRING(cCtaCodRef,9,1)='1' THEN 1/@TCRef      
     END,                  
     capital = SUM(case when nPrdConceptoCod in (1000,1010) then nMonto else 0 end),          
     interes = SUM(case when nPrdConceptoCod not in (1000,1010) and nPrdConceptoCod not like '12%' then nMonto else 0 end),          
     gastos = SUM(case when nPrdConceptoCod like '12%' then nMonto else 0 end)          
    FROM  @TABLA_COLOCACREFINANDET          
    GROUP BY cCtaCod,cCtaCodRef           
   ) x       
      
   INSERT INTO ColocacRefinanc  (cCtaCod,cCtaCodRef,nEstado,dEstado,nPorc,nMontoRef,bSustiDeudor)             
   SELECT DISTINCT cCtaCod, cCtaCodRef, nEstado, dEstado, nPorc, nMontoRef, bSustiDeudor         
   FROM @TABLA_COLOCACREFINAN       
         
   INSERT INTO ColocacRefinancDet  (cCtaCod,cCtaCodRef,nEstado,dEstado,nPrdConceptoCod,nMonto,nMontoPagado)               
   SELECT cCtaCod, cCtaCodRef, nEstado, dEstado, nPrdConceptoCod, nMonto, nMontoPagado          
   FROM @TABLA_COLOCACREFINANDET        
         
   if @nNumRefUnoUno=-1      
   begin      
    UPDATE Colocaciones  SET nMontoCol  = @nMontoRefTot where cCtaCod = @cCtaCod           
    UPDATE ColocacEstado  SET nMonto = @nMontoRefTot where cCtaCod = @cCtaCod           
    UPDATE ColocacCred SET bRefCapInt = @bCapitalizacion where cCtaCod = @cCtaCod           
   end      
   else      
   begin      
    UPDATE colocrefinanciaciontramite  SET nMontoCol  = @nMontoRefTot,bRefCapInt = @bCapitalizacion where cCtaCod = @cCtaCod and nNumRefinanciacion=@nNumRefUnoUNo and bOriginal=0      
    UPDATE ColocacEstadoRefinanciacion   SET nMonto = @nMontoRefTot where cCtaCod = @cCtaCod      and nNumRefinanciacion=@nNumRefUnoUNo and bOriginal=0       
   end        
  END      
 END      
      
 BEGIN -- INSERTAR GESTION MONTO HIPOTECARIO    
    
  BEGIN -- INSERTANDO PORCENTAJE DE COBERTURA    
    
   BEGIN -- TABLAS    
    -- drop table #ColocCoberturaBonoHipotecario    
    CREATE TABLE #ColocCoberturaBonoHipotecario    
    (    
     nId INT IDENTITY(1, 1) PRIMARY KEY,    
     nRango INT,    
     nTipoVivienda INT,    
     nGrado INT,    
     nPorcentaje INT,    
     cProducto VARCHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS    
    )        
    
    INSERT #ColocCoberturaBonoHipotecario (cProducto, nRango, nTipoVivienda, nGrado, nPorcentaje)    
     VALUES    
      -- MI VIVIENDA - TECHO PROPIO    
       (404, 0, 0, 0, 70)    
    
      -- HIPOTECARIO MI VIVIENDA - CMV    
      -- Vivienda Tradicional    
      ,(406, 1, 1, 0, 40)    
      ,(406, 2, 1, 0, 40)    
      ,(406, 3, 1, 0, 30)    
      ,(406, 4, 1, 0, 30)    
      ,(406, 5, 1, 0, 30)    
    
      -- VIVIENDA SOSTENIBLE - GRADO 1     
      ,(406, 1, 3, 1, 50)    
      ,(406, 2, 3, 1, 50)    
      ,(406, 3, 3, 1, 40)    
      ,(406, 4, 3, 1, 40)    
      ,(406, 5, 3, 1, 40)    
      -- VIVIENDA SOSTENIBLE - GRADO 2    
      ,(406, 1, 3, 2, 60)    
      ,(406, 2, 3, 2, 60)    
      ,(406, 3, 3, 2, 50)    
      ,(406, 4, 3, 2, 50)    
      ,(406, 5, 3, 2, 50)    
      -- VIVIENDA SOSTENIBLE - GRADO 3    
      ,(406, 1, 3, 3, 70)    
      ,(406, 2, 3, 3, 70)    
      ,(406, 3, 3, 3, 60)    
      ,(406, 4, 3, 3, 60)    
      ,(406, 5, 3, 3, 60)    
        
    -- DROP TABLE #ValoresVivienda    
    CREATE TABLE #ValoresVivienda    
    (    
     nId INT IDENTITY(1, 1) PRIMARY KEY,    
     nDestino INT,    
     nMontoInicial MONEY,    
     nMontoFinal MONEY,    
     nRango INT    
    )    
        
    INSERT INTO #ValoresVivienda (nDestino, nMontoInicial, nMontoFinal)    
    SELECT Destino, MontoInicial, MontoFinal     
     FROM ColocConfigBonoHipotecario     
      WHERE Estado = 1 AND SubProducto = '406' AND TIPOBONO = 2 ORDER BY Destino, MontoInicial ASC    
    
    INSERT INTO #ValoresVivienda (nDestino, nMontoInicial, nMontoFinal)    
     SELECT 28, nMontoInicial, nMontoFinal FROM #ValoresVivienda WHERE nDestino = 6 ORDER BY nMontoInicial        
    
    --SELECT * FROM    
     UPDATE p SET nRango = 1 FROM    
    #ValoresVivienda p WHERE nId IN (1, 5, 9, 13)    
    
    --SELECT * FROM    
  UPDATE p SET nRango = 2 FROM    
    #ValoresVivienda p WHERE nId IN (2, 6, 10, 14)    
    
    --SELECT * FROM    
     UPDATE p SET nRango = 3 FROM    
    #ValoresVivienda p WHERE nId IN (3, 7, 11, 15)    
    
    --SELECT * FROM    
     UPDATE p SET nRango = 4 FROM    
    #ValoresVivienda p WHERE nId IN (4, 8, 12, 16)    
    
    DECLARE @nMontoFinal MONEY = (select MontoViviendaMaximo from ColocConfigHipotecario where SubProducto = '406' AND ValidaMontoVivienda = 1 and TipoBono = 0 and Destino = 6)    
        
    INSERT INTO #ValoresVivienda    
    SELECT 6 , MAX(nMontoFinal), @nMontoFinal, 5 from #ValoresVivienda UNION    
    SELECT 7 , MAX(nMontoFinal), @nMontoFinal, 5 from #ValoresVivienda UNION    
    SELECT 21, MAX(nMontoFinal), @nMontoFinal, 5 from #ValoresVivienda UNION    
    SELECT 28, MAX(nMontoFinal), @nMontoFinal, 5 from #ValoresVivienda    
   END    
    
   DECLARE @nPorcentaje INT    
    
   IF(SUBSTRING(@cCtaCod, 6, 3) = '404')    
    BEGIN    
     SELECT @nPorcentaje = nPorcentaje FROM #ColocCoberturaBonoHipotecario WHERE cProducto = '404'    
    END    
   ELSE IF (SUBSTRING(@cCtaCod, 6, 3) = '406')    
    BEGIN    
     DECLARE @nMonto MONEY    
       ,@nTipoVivienda INT    
       ,@nDestino INT    
       ,@nGrado INT    
        
     SELECT @nTipoVivienda = nTipoVivienda, @nDestino = ndestino FROM #ColocSolicitud    
     SELECT @nMonto = nMontoVivienda FROM #MontoHipotecario    
     SELECT @nGrado = nGrado FROM ColocProyectoInmob WHERE @nCodProyInmob = nCodProyecto    
    
     SET @nGrado = ISNULL(@nGrado, 0)    
    
     SELECT TOP 1 @nPorcentaje = p1.nPorcentaje FROM #ColocCoberturaBonoHipotecario p1    
      INNER JOIN #ValoresVivienda p2    
       ON p1.nRango = p2.nRango    
      WHERE     
       @nMonto > p2.nMontoInicial AND @nMonto <= p2.nMontoFinal AND    
       @nDestino = p2.nDestino AND    
       ((@nTipoVivienda = 3 and @nGrado = p1.nGrado) OR (@nTipoVivienda <> 3))    
    END    
  END    
    
  INSERT INTO ColocGestionMontoHipotecario (dFechaActualiza,cCtaCod,nValorVivienda,nCuotaInicial,nValorCompra,nPresupuestoCons,bPrimeraVivienda,nGastosCierre,bBonoBP, cTpoVIS, nTipoBono, nMontoBono, nValTerreno, nMontoAdi,nBonoVerde, nPorcCobertura)     
 
  
  
  
  
  
   SELECT    
    @dFechaSolicitud,    
    @cCtaCod,    
    GMH.nMontoVivienda,    
    GMH.nMontoInicial,    
    GMH.nMontoCompra,    
    GMH.nPresupuestoCons,    
    GMH.bPrimeraVivienda,    
    GMH.nGastosCierre,    
    GMH.bBonoBP,    
    GMH.cTpoVIS,    
    GMH.nTipoBono,    
    GMH.nMontoBono,    
    GMH.nValTerreno,    
    GMH.nMontoAdi,    
    GMH.nBonoVerde    
    ,@nPorcentaje    
   FROM #MontoHipotecario GMH WITH(NOLOCK)    
   WHERE SUBSTRING(CONVERT(VARCHAR(6),@nSubProducto),1,3) NOT IN ('205','307')    
 END    
      
 BEGIN-- INSERTA 0KMS      
  IF EXISTS(SELECT cCodSolicitud FROM TIPOPRODUCTO_0KMS WHERE cCodSolicitud = @cCodSolicitud)      
  BEGIN      
   DELETE TIPOPRODUCTO_0KMS WHERE cCodSolicitud = @cCodSolicitud      
  END      
  INSERT INTO TIPOPRODUCTO_0KMS (      
    cCodSolicitud      
    ,cCodPersona      
    ,nCuotaInicial      
    ,nValorVehiculo      
    ,nTipoVehiculo      
    ,dfechaactualiza)      
  SELECT      
   @cCodSolicitud,      
   (SELECT TOP 1 cpersCod FROM #ColocSolicitudPersona WHERE nprdpersrelac = 20) cPersCod,      
   GMH.nMontoInicial,      
   GMH.nMontoVivienda,      
   GMH.nTipoVehiculo,      
   @dFechaSolicitud      
  FROM #MontoHipotecario GMH WITH(NOLOCK)      
  WHERE SUBSTRING(CONVERT(VARCHAR(6),@nSubProducto),1,3) IN ('205','307')      
 END      
      
 BEGIN-- INSERTA COMERCIAL EMPRESARIAL PARA PROYECTOS INMOBILIARIOS      
        
  IF EXISTS(SELECT cCodSolicitud FROM CE_PROYECTOSINMOBILIARIOS_VALOROBRA WHERE cCodSolicitud = @cCodSolicitud)      
  BEGIN      
   DELETE CE_PROYECTOSINMOBILIARIOS_VALOROBRA WHERE cCodSolicitud = @cCodSolicitud      
  END      
  INSERT INTO CE_PROYECTOSINMOBILIARIOS_VALOROBRA(      
    cCodSolicitud      
    ,cCodPersona      
    ,nValorObra)      
  SELECT      
   @cCodSolicitud,      
   (SELECT TOP 1 cpersCod FROM #ColocSolicitudPersona WHERE nprdpersrelac = 20) cPersCod,      
   C.nValorObra      
  FROM       
   #ColocSolicitud C WITH(NOLOCK)      
  WHERE       
   SUBSTRING(CONVERT(VARCHAR(6),@nSubProducto),1,3) = '101'       
   AND c.ndestino IN (42, 43)      
 END      
 --<OBSERVACIONES>      
 DELETE FROM ColocCredObserv WHERE cCtaCod = @cCtaCod AND nTpo IN (5,6) AND @nNumRefUnoUno = -1      
 DELETE FROM ColocCredObservRefinanciacion WHERE cCtaCod = @cCtaCod and nNumRefinanciacion= @nNumRefUnoUno and bOriginal=0 AND nTpo IN (5,6)      
      
 INSERT INTO ColocCredObserv (nEstado, dFecha, nTpo, cCtaCod, cMovNro, cObservacion, crespuesta)      
 SELECT         
  IIF(O.bAprobacion = 0,1,2),      
  O.dFecha,      
  O.nTpo,      
  @cCtaCod,      
  @cMovNumero,      
  O.cObservacion,      
  IIF(O.bAprobacion = 0, NULL, O.cRespuesta)      
 FROM      
 #Observaciones O WITH(NOLOCK)      
 WHERE      
 @nNumRefUnoUno = -1      
      
 INSERT INTO ColocCredObservRefinanciacion (nEstado, dFecha, nTpo, cCtaCod, cMovNro, cObservacion, crespuesta, nNumRefinanciacion, bOriginal)      
 SELECT         
  IIF(O.bAprobacion = 0,1,2),      
  O.dFecha,      
  O.nTpo,      
  @cCtaCod,      
  @cMovNumero,      
  O.cObservacion,      
  IIF(O.bAprobacion = 0, NULL, O.cRespuesta),      
  @nNumRefUnoUno,      
  0      
 FROM      
 #Observaciones O WITH(NOLOCK)      
 WHERE      
 @nNumRefUnoUno <> -1      
 --</OBSERVACIONES>      
      
 --INSERTAR EN INFORME CREDITO NO MINORISTA      
 DECLARE @XMLDatosInfCredNoMinorista XML = ''      
      
 SELECT @XMLDatosInfCredNoMinorista = @xPropuesta.query('PropuestaDto/DatosInfCredNoMinoristaDTO')      
 SET @XMLDatosInfCredNoMinorista.modify('        
  replace value of (/DatosInfCredNoMinoristaDTO/@cCtaCod)[1]        
  with sql:variable("@cCtaCod")');      
      
 DECLARE @nCodInfRet INT      
 IF (ISNULL(RTRIM(LTRIM(CONVERT(VARCHAR(MAX),@XMLDatosInfCredNoMinorista))),'') <> '')      
 BEGIN      
  EXEC COLOCACIONES.FluCre_InsInfCreNoMin_SP @XMLDatosInfCredNoMinorista, @nCodInfRet OUTPUT, @cCodError OUTPUT      
 END      
 --INSERTAR EN INFORME CREDITO NO MINORISTA      
      
 --<INSERTAR VRU>      
      
 SELECT DISTINCT      
  nIDPersonaVinculo = T.Item.value('@nIDPersonaVinculo', 'INT'),      
  cPersCod = T.Item.value('@cPersCod', 'VARCHAR(13)'),      
  cCtaCod = @cCtaCod      
 INTO #Vinculados      
 FROM @xPropuesta.nodes('PropuestaDto/ListaDatosVinculados/DatosVinculado') AS T (Item)      
      
 DECLARE @bInsertarIDPers BIT = 0      
      
 --SI EXISTE VINCULOS SIN INSERTAR      
 SELECT @bInsertarIDPers = IIF(COUNT(nIDPersonaVinculo) > 0, 1, 0)      
 FROM       
  #Vinculados      
 WHERE nIDPersonaVinculo = 0      
      
 --SI EXISTE MÁS DE UN ID VÍNCULO (CONSOLIDAR ID VRU)       
 IF @bInsertarIDPers = 0      
  SELECT      
   @bInsertarIDPers = IIF(COUNT(DISTINCT nIDPersonaVinculo) > 1, 1, 0)      
  FROM      
   #Vinculados      
  WHERE      
   nIDPersonaVinculo <> 0      
   AND ISNULL(@cCtaCod, '') <> '' --CON CUENTA      
      
 IF @bInsertarIDPers = 1      
 BEGIN      
  DECLARE @nTipoCredito VARCHAR(6) ,      
    @cCredProducto VARCHAR(8)       
      
  SELECT      
   @cCredProducto = SUBSTRING(CONVERT(VARCHAR(6),nSubProducto),1,3),      
   @nTipoCredito = ntipocredito      
  FROM      
   #ColocSolicitud      
  --SUBSTRING(CONVERT(VARCHAR(6),@nSubProducto),1,3)      
  EXEC PA_InsRelacionesVRU @xPropuesta, @cUser, @cAgeCod, @cCtaCod, @cCredProducto, @nTipoCredito, @cClasificacionGE, 2      
 END      
 ELSE      
 BEGIN      
  IF (ISNULL(@cCtaCod, '') <> '') --Con cuenta - insertar en PersonaVinculoProducto si no existe (siempre pasará un solo id vru)      
  BEGIN      
   IF NOT EXISTS(SELECT 1 FROM #Vinculados A INNER JOIN PersonaVinculoProducto B ON A.nIDPersonaVinculo = B.nIDPersonaVinculo AND A.cPersCod = B.cPersCod AND A.cCtaCod = B.cCtaCod)      
   BEGIN      
    DECLARE @cModVru VARCHAR(25) = DBO.FN_ULTIMAACTUALIZACION(@cUser)      
    DECLARE @dFechaModVru DATETIME = GETDATE()      
      
 INSERT INTO PERSONAVINCULOPRODUCTO (nIDPersonaVinculo,cPersCod,cCtaCod,nFlagCancelado,nEstado,cCodUsuCrea,      
      dFechaCreacion,cCodUsuModi,dFechaModificacion,cUltimaActualizacion)      
    SELECT DISTINCT      
     T.nIDPersonaVinculo, T.cPersCod, T.cCtaCod, 0, 1, @cUser, @dFechaModVru, NULL, NULL, @cModVru      
    FROM #Vinculados T      
   END      
  END      
 END      
       
 --</INSERTAR VRU>      
      
 --<DOCUMENTOS RELACIONADOS>      
 BEGIN      
  UPDATE @Documentos      
  SET cCtaCod = @cCtaCod,      
   nCodSolicitud = @nCodSolicitud      
      
  DELETE CSD      
  FROM @Documentos D      
   INNER JOIN dbCmacIcaDocumentos.dbo.ColocSolicitudDocumentos CSD WITH(NOLOCK)      
    ON D.cCtacod = CSD.cCtaCod AND D.nEtapa = CSD.nEtapa      
     AND CSD.nCodSolicitud = D.nCodSolicitud AND CSD.nTpoDocumento = d.nTipoDocumento      
     AND CSD.cArchivo = D.cArchivo AND D.cRuta = CSD.cRuta      
     AND (D.nCodDocumentos = CSD.nCodDocumentos OR D.nCodDocumentos = 0)      
  WHERE D.bEliminar = 1      
      
  INSERT INTO dbCmacIcaDocumentos.dbo.ColocSolicitudDocumentos(nCodSolicitud, cCtaCod, nTpoDocumento, cTpoProducto, nEtapa, cArchivo, cMovNro, cRuta, bArchivo, bOpRiesgos)      
  SELECT      
   nCodSolicitud, cCtaCod, nTipoDocumento, cTpoProducto, nEtapa, cArchivo, @cMovNumero, cRuta, bArchivo, bOpRiesgos      
  FROM @Documentos D       
  WHERE bInsertar = 1      
      
 END      
 --</DOCUMENTOS RELACIONADOS>      
      
 --<FIADOR SOLIDARIO>      
 BEGIN      
  UPDATE @EvaFiadorSolidario      
  SET nCodSolicitud = @nCodSolicitud      
      
  IF EXISTS(SELECT nCodSolicitud FROM COLOCACIONES.EvaFiadorSolidario WHERE nCodSolicitud = @nCodSolicitud)      
  BEGIN      
   UPDATE A       
   SET A.cPersCodTitular = B.cPersCodTitular,      
    A.cPersCodFiador = B.cPersCodFiador,      
    A.nPersNroDependientes = B.nPersNroDependientes,      
    A.cPersEdadHijos = B.cPersEdadHijos,      
    A.nCondicionLegal = B.nCondicionLegal,      
    A.cCondLegalOtros = B.cCondLegalOtros,      
    A.nEstadoVivienda = B.nEstadoVivienda,      
    A.cEstadoViviendaOtros = B.cEstadoViviendaOtros,    
    A.nRelacionAvalTitular = B.nRelacionAvalTitular,      
    A.cRelacionAvalOtros = B.cRelacionAvalOtros,      
    A.nTipoActividad = B.nTipoActividad,      
    A.cActividadEconomica = B.cActividadEconomica,      
    A.nFrecuenciaIngreso = B.nFrecuenciaIngreso,      
    A.cDireccionNegocio = B.cDireccionNegocio,      
    A.cDepProvDistNegocio = B.cDepProvDistNegocio,      
    A.nTiempoActividad = B.nTiempoActividad,      
    A.cCargo = B.cCargo,      
    A.nIngresosAprox = B.nIngresosAprox,      
    A.bConyugeLabora = B.bConyugeLabora,      
    A.cOcupacionConyuge = B.cOcupacionConyuge,      
    A.nTiempoLaboral = B.nTiempoLaboral,      
    A.cReferenciasPersonales = B.cReferenciasPersonales,      
    A.cComentarioAnalista = B.cComentarioAnalista      
   FROM COLOCACIONES.EvaFiadorSolidario A      
    INNER JOIN @EvaFiadorSolidario B ON A.nCodSolicitud = B.nCodSolicitud AND ISNULL(B.cPersCodFiador, '') <> ''      
  END      
  ELSE      
  BEGIN      
   INSERT COLOCACIONES.EvaFiadorSolidario (nCodSolicitud, cPersCodTitular, cPersCodFiador, nPersNroDependientes, cPersEdadHijos, nCondicionLegal, cCondLegalOtros,       
             nEstadoVivienda, cEstadoViviendaOtros, nRelacionAvalTitular, cRelacionAvalOtros, nTipoActividad, cActividadEconomica,       
             nFrecuenciaIngreso, cDireccionNegocio, cDepProvDistNegocio, nTiempoActividad, cCargo, nIngresosAprox, bConyugeLabora,      
             cOcupacionConyuge, nTiempoLaboral, cReferenciasPersonales, cComentarioAnalista)      
   SELECT nCodSolicitud, cPersCodTitular, cPersCodFiador, nPersNroDependientes, cPersEdadHijos, nCondicionLegal, cCondLegalOtros,       
             nEstadoVivienda, cEstadoViviendaOtros, nRelacionAvalTitular, cRelacionAvalOtros, nTipoActividad, cActividadEconomica,       
             nFrecuenciaIngreso, cDireccionNegocio, cDepProvDistNegocio, nTiempoActividad, cCargo, nIngresosAprox, bConyugeLabora,      
             cOcupacionConyuge, nTiempoLaboral, cReferenciasPersonales, cComentarioAnalista      
   FROM @EvaFiadorSolidario A      
   WHERE ISNULL(A.cPersCodFiador, '') <> ''      
  END      
 END      
 --</FIADOR SOLIDARIO>      
      
 --<ASOCIAR EVALUACIÓN CREDITICIA>      
 IF (ISNULL(@cNumEva, '') <> '' AND ISNULL(@cCtaCod, '') <> '')      
 BEGIN      
  IF (@ncondicion2 = 8 AND @nNumRefUnoUno > 0)      
  BEGIN      
   IF NOT EXISTS (SELECT cNumFuente FROM ColocFteIngresoRefinanciacion WITH(NOLOCK) WHERE cCtaCod = @cCtaCod AND nNumRefinanciacion = @nNumRefUnoUno)        
   BEGIN        
    INSERT INTO ColocFteIngresoRefinanciacion(cNumFuente, cCtaCod, dPersEval, nNumRefinanciacion, bOriginal)        
    VALUES (@cNumFuente, @cCtaCod, @dPersEval, @nNumRefUnoUno, 0)        
   END        
   ELSE        
   BEGIN        
    UPDATE ColocFteIngresoRefinanciacion        
    SET cNumFuente = @cNumFuente, dPersEval = @dPersEval, nNumRefinanciacion = @nNumRefUnoUno, bOriginal = 0      
    WHERE cCtaCod = @cCtaCod  AND nNumRefinanciacion = @nNumRefUnoUno      
   END       
  END      
  ELSE      
  BEGIN      
   IF NOT EXISTS (SELECT cNumFuente FROM ColocFteIngreso WITH(NOLOCK) WHERE cCtaCod = @cCtaCod)        
   BEGIN        
    INSERT INTO ColocFteIngreso(cNumFuente, cCtaCod, dPersEval)        
    VALUES (@cNumFuente, @cCtaCod, @dPersEval)        
   END        
   ELSE        
   BEGIN        
    UPDATE ColocFteIngreso        
    SET cNumFuente = @cNumFuente, dPersEval = @dPersEval      
    WHERE cCtaCod = @cCtaCod        
   END      
  
   --Regulariza la vinculación del archivo excel de la evaluación al número de cuenta      
   UPDATE DBCMACICADOCUMENTOS.dbo.EvaExcel SET cCtaCod = @cCtaCod, cUltimaActualizacion = dbo.FN_UltimaActualizacion(@cUser) WHERE cNumEva = @cNumEva AND ISNULL(cCtaCod, '') = ''      
      
   BEGIN --Inserta la solicitud del sustento de cancelación      
    DECLARE @ColocSolicitudDocumentos TABLE(nCod INT IDENTITY(1,1) NOT NULL, nCodDocumentos INT, cRutaArchivo VARCHAR(MAX))      
    DECLARE @ColocLiberacionReglaAux TABLE(nCodRegLib INT, nCodDocumentos INT)      
      CREATE TABLE #ColocLiberacionRegla(      
     nCod INT IDENTITY(1,1) NOT NULL,      
     nCodRegLib int  NULL,      
     cCtaCod varchar(18) NULL,      
     nCodAlinea int NULL,      
     nCodDocumentos int NULL,      
     nEstado int NULL,      
     nValorLib int NULL,      
     cValorLib varchar(max) NULL,      
     cArchivo varchar(200) NULL,      
     cComenLib varchar(max) NULL,      
     dFechaAudit datetime NULL,      
     cAgeCodAudit varchar(3) NULL,      
     cUserAudit varchar(5) NULL      
    )      
      
    INSERT INTO #ColocLiberacionRegla      
     (cCtaCod, nCodAlinea, nEstado, nValorLib, cArchivo, cComenLib, dFechaAudit, cAgeCodAudit, cUserAudit)      
    SELECT      
     @cCtaCod, 34, 0, nNumEntidades, cNombreArchivo, cComentarioAnalista, GETDATE(), @cAgeCod, @cUser      
    FROM      
     DBCMACICADOCUMENTOS..EvaSustentoCancelacion      
    WHERE cNumEva = @cNumEva AND bMigrado = 0      
      
    INSERT INTO DBCMACICADOCUMENTOS..ColocSolicitudDocumentos      
     (nCodSolicitud, cCtaCod, nTpoDocumento, cTpoProducto, nEtapa, cArchivo, cMovNro, cRuta, bArchivo, bOpRiesgos)      
    OUTPUT inserted.nCodDocumentos, inserted.cRuta      
    INTO @ColocSolicitudDocumentos(nCodDocumentos, cRutaArchivo)      
    SELECT      
     0, @cCtaCod, 180, dbo.FN_GetcCredProducto(@cCtaCod), 4, cNombreArchivo, dbo.FN_UltimaCambio(@cAgeCod, @cUser), cRutaArchivo, bArchivo, null      
    FROM      
     DBCMACICADOCUMENTOS..EvaSustentoCancelacion      
    WHERE      
     cNumEva = @cNumEva AND bMigrado = 0      
      
    UPDATE C      
    SET C.nCodDocumentos = T.nCodDocumentos      
    FROM #ColocLiberacionRegla C      
     INNER JOIN @ColocSolicitudDocumentos T ON T.nCod = C.nCod      
      
    UPDATE A      
    SET A.nCodDocumentos = T.nCodDocumentos      
    FROM DBCMACICADOCUMENTOS..EvaSustentoCancelacion A      
     INNER JOIN @ColocSolicitudDocumentos T ON A.cRutaArchivo = T.cRutaArchivo      
    WHERE A.cNumEva = @cNumEva AND A.bMigrado = 0      
      
    INSERT INTO ColocLiberacionRegla      
     (cCtaCod, nCodAlinea, nCodDocumentos, nEstado, nValorLib, cValorLib)      
    OUTPUT inserted.nCodRegLib, inserted.nCodDocumentos      
    INTO @ColocLiberacionReglaAux      
    SELECT       
     C.cCtaCod, C.nCodAlinea, C.nCodDocumentos, C.nEstado, C.nValorLib, C.cValorLib      
    FROM       
     #ColocLiberacionRegla C      
      
    UPDATE C      
    SET C.nCodRegLib = T.nCodRegLib      
    FROM #ColocLiberacionRegla C      
    INNER JOIN @ColocLiberacionReglaAux T ON C.nCodDocumentos = T.nCodDocumentos      
      
    INSERT INTO ColocLiberacionReglaDet      
     (nCodRegLib, nEstado, cComenLib, dFechaAudit, cAgeCodAudit, cUserAudit)      
    SELECT      
     R.nCodRegLib, 0, R.cComenLib, R.dFechaAudit, R.cAgeCodAudit, R.cUserAudit      
    FROM #ColocLiberacionRegla R      
      
    UPDATE A --setear indicador migrado      
    SET A.bMigrado = 1      
    FROM DBCMACICADOCUMENTOS..EvaSustentoCancelacion A      
    WHERE A.cNumEva = @cNumEva AND A.bMigrado = 0      
              
    DELETE A      
    FROM DBCMACICADOCUMENTOS..ColocSolicitudDocumentos A      
     LEFT JOIN DBCMACICADOCUMENTOS..EvaSustentoCancelacion B      
      ON A.nCodDocumentos = B.nCodDocumentos      
    WHERE A.cCtaCod = @cCtaCod AND B.cNumEva IS NULL      
      
   END      
  END        
 END      
 --</ASOCIAR EVALUACIÓN CREDITICIA>      
      
 --<EXCEPCION DE GARANTIAS> --FALTA LOGICA PARA REFINANCIADOS      
 BEGIN      
  IF EXISTS (SELECT CCTACOD FROM colocExcepGarant WITH(NOLOCK) WHERE CCTACOD = @CCTACOD AND NNUMREF = @nNumRefUnoUno AND NCODTIPVAL IN (38, 39))      
  BEGIN      
   DELETE FROM colocExcepGarant        
    WHERE CCTACOD =@CCTACOD AND NNUMREF = @nNumRefUnoUno AND NCODTIPVAL IN (38, 39)      
  END      
  INSERT INTO colocExcepGarant (CCTACOD, NCODTIPVAL, NNUMREF, NPORCCOBERTURA, DFECAUDITSOL, CUSERAUDITSOL, CAGECODAUDITSOL, NESTADO)      
  SELECT       
   @cCtaCod,      
   NCODTIPVAL,      
   NNUMREF,      
   NPORCCOBERTURA,      
   DFECAUDITSOL,      
   CUSERAUDITSOL,       
   CAGECODAUDITSOL,       
   1         
  FROM #ExcepcionesGarantia WITH(NOLOCK)      
      
 END      
 --</EXCEPCION DE GARANTIAS>      
      
 --<GARANTIA>      
 BEGIN       
      
 IF EXISTS (SELECT cCtaCod FROM ColocGarantia WITH(NOLOCK) WHERE cCtaCod = @cCtaCod AND @nNumRefUnoUno = -1)      
 BEGIN      
  DELETE CG      
  FROM ColocGarantia CG         
  WHERE cCtaCod = @cCtaCod      
 END      
    
 -- GARANTIAS POR FUERA    
 IF EXISTS (SELECT cCtaCod FROM Colocaciones.ColocGarantiaPorFuera WITH(NOLOCK) WHERE cCtaCod = @cCtaCod and @nNumRefUnoUno = -1)    
 BEGIN    
 DELETE CGPF      
 FROM Colocaciones.ColocGarantiaPorFuera CGPF         
 WHERE cCtaCod = @cCtaCod      
 END    
      
 IF EXISTS (SELECT * FROM ColocGarantiaRefinanciacion WITH(NOLOCK) WHERE cCtaCod = @cCtaCod AND bOriginal = 0 AND nNumRefinanciacion = @nNumRefUnoUno)      
 BEGIN      
  DELETE ColocGarantiaRefinanciacion       
  WHERE cCtaCod = @cCtaCod       
  AND bOriginal=0       
  AND nNumRefinanciacion=@nNumRefUnoUno      
 END      
      
 INSERT INTO dbo.colocgarantia       
  (cnumgarant,       
cctacod,       
  nmoneda,       
  ngravado,       
  nestado,       
  nporcentajegarantia,       
  nporcentajecobertura,       
  nporgravar100,       
  ntipocambio,       
  ntipglobalflotante,       
  nindgarcombinada,       
  nnumgarantcombinacion,      
  nPersRelac,  
  nModAseg)       
 SELECT       
  TG.cNumGarant,      
  @cCtaCod,      
  TG.nMoneda,      
  TG.nGravado,      
  TG.nEstado,      
  TG.nPorcentajeGarantia,      
  TG.nPorcentajeCobertura,      
  TG.nPorGravar,      
  TG.nTipoCambio,      
  CASE       
   WHEN TG.nTipGarGlobalFlotante = 0 THEN NULL       
   ELSE TG.nTipGarGlobalFlotante       
  END,      
  CASE       
   WHEN TG.nIndGarCombinada = 0 THEN NULL       
   WHEN TG.nIndGarCombinada = 18 THEN 2       
   ELSE 1       
 END,          
  TG.cNumGarantCombinacion,      
  TG.nPersRelac,  
  CASE       
   WHEN @bMultiriesgoComercial = 1 THEN 1       
   WHEN @bMultiriesgoReconstruccion = 1 THEN 2  
  END  
 FROM       
 #GarantiasAsociadas TG WITH(NOLOCK)      
 WHERE       
 @nNumRefUnoUno = -1       
    
  -- GARANTIAS POR FUERA    
 INSERT INTO Colocaciones.ColocGarantiaPorFuera    
 (    
 nGarantPfID,    
 cCtaCod,    
 nMoneda,    
 nGravado,    
 cUsuarioVB,    
 cUltimaActualizacionVB,     
 nFlag,    
 nPersRelac    
 )    
 SELECT    
 X.nGarantPfID,    
 @cCtaCod,    
 X.nMoneda,    
 X.nGravado,    
 X.cUserVB,    
 X.cUltimaActualizacion,    
 X.nFlag,    
 X.nPersRelac    
 FROM #GarantiasPorFueraAsociadas X WITH(NOLOCK)    
 WHERE @nNumRefUnoUno = -1    
      
 INSERT INTO dbo.colocgarantiarefinanciacion       
  (cnumgarant,       
  nnumrefinanciacion,       
  boriginal,       
  cctacod,       
  nmoneda,       
  ngravado,       
  nestado,       
  nporcentajegarantia,       
  nporcentajecobertura,       
  nporgravar100,       
  ntipocambio,      
  nPersRelac)       
 SELECT       
  TG.cNumGarant,      
  TG.nRefinanciado,      
  0,      
  @cCtaCod,      
  TG.nMoneda,      
  TG.nGravado,      
  TG.nEstado,      
  TG.nPorcentajeGarantia,      
  TG.nPorcentajeCobertura,      
  TG.nPorGravar,      
  TG.nTipoCambio,      
  TG.nPersRelac      
 from       #GarantiasAsociadas TG WITH(NOLOCK)      
 where       
  @nNumRefUnoUno > 0      
       
 INSERT INTO ColExepSegCredito (cNumGarant,cCtaCod,cMovNro,nPrdConceptoCod)                        
 SELECT       
 TG.cNumGarant,      
 @cCtaCod,      
 dbo.Fn_selUltimaActualizacion(),      
 12941      
 FROM       
 #GarantiasAsociadas TG WITH(NOLOCK)       
 LEFT JOIN ColExepSegCredito CE WITH(NOLOCK)      
 ON CE.cCtaCod = @cCtaCod AND CE.cNumGarant = TG.cNumGarant AND CE.nPrdConceptoCod=12941      
 WHERE TG.bExcepSeguroBien = 1 AND CE.cCtaCod IS NULL      
      
 INSERT INTO garantia.historialestados       
 (cnumgarant,       
 dfechaestado,       
 ncodestado,       
 cultimaactualizacion)       
 SELECT       
 TG.cNumGarant,      
 @dFechaSolicitud,      
 2,      
 CONVERT(CHAR(8), @dFechaSolicitud, 112) + Replace(CONVERT(CHAR(8), Getdate(), 108), ':', '') + '1080000SICM'      
 FROM      
  garantias G WITH(NOLOCK)      
  INNER JOIN #GarantiasAsociadas TG WITH(NOLOCK)      
  ON TG.cNumGarant=G.cNumGarant      
 WHERE       
  G.nEstado=1      
      
 UPDATE  G      
 SET          
  G.nEstado = 2       
 FROM       
  garantias G      
  INNER JOIN  #GarantiasAsociadas TG       
  ON TG.cNumGarant=G.cNumGarant       
 WHERE       
  G.nEstado = 1      
    
 -- GARANTIAS POR FUERA    
 UPDATE GPF    
  SET GPF.nEstado = 2    
 FROM Garantia.GarantiasPorFuera GPF    
  INNER JOIN #GarantiasPorFueraAsociadas X    
  ON GPF.nGarantPfID=X.nGarantPfID    
 WHERE GPF.nEstado = 1    
      
 END      
 --</GARANTIA>      
      
 IF(@nEstadoActual = 2001)      
 BEGIN      
  EXEC COLOCACIONES.FluCre_UpdPropuestaSugerencia_SP @xPropuesta, @cCtaCod, @nCodError OUTPUT, @cCodError OUTPUT         
 END      
       
      
 IF EXISTS (SELECT 1 FROM #DatosSolicitudOnline)      
 BEGIN      
  UPDATE A      
  SET A.nEstado = 3,      
   A.cCodSolicitud = @cCodSolicitud      
  FROM ColocSolicitudOnline A      
   INNER JOIN #DatosSolicitudOnline B ON A.nId = B.UniqueId      
      
  INSERT INTO ColocSolicitudOnlineEstado (nIdSolicitud, nEstado, dEstado, cUltimaActualizacion)      
  SELECT UniqueId, 3, GETDATE(), dbo.FN_UltimaActualizacion(@cUser) FROM #DatosSolicitudOnline       
      
  UPDATE A      
  SET A.nEstado = 4      
  FROM ColocSolicitudOnline A      
   INNER JOIN #DatosSolicitudOnline B ON A.nId = B.UniqueId      
      
  INSERT INTO ColocSolicitudOnlineEstado (nIdSolicitud, nEstado, dEstado, cUltimaActualizacion)      
  SELECT UniqueId, 4, GETDATE(), dbo.FN_UltimaActualizacion(@cUser) FROM #DatosSolicitudOnline       
      
      
  DECLARE @cCodAnalista VARCHAR(13) = (SELECT TOP 1 cCodAnalista FROM ColocSolicitudOnlineAnalistas WHERE cAgeCod = @cAgeCod ORDER BY cCodAnalista)      
     
  UPDATE ColocSolicitudEstado      
   SET dFechaAsig = GETDATE(),      
   cPersCodAnalista = @cCodAnalista      
  WHERE nCodSolicitud = @nCodSolicitud AND nEstado = 6       
      
  INSERT INTO ColocSolicitudEstado(nCodSolicitud, nEstado, cMovNro, dFechaSol, dFechaAsig, cPersCodAnalista, dFechaVisita, nMonto, cMotivo, cObservacion)     
  SELECT      
   nCodSolicitud,      
   3,       
   dbo.FN_UltimaActualizacion(@cUser),      
   dFechaAsig,      
   dFechaAsig,      
   cPersCodAnalista,      
   dFechaVisita,      
   nMonto,      
   cMotivo,      
   cObservacion = 'Asignación automática a analista de redes sociales'      
  FROM ColocSolicitudEstado WHERE nCodSolicitud = @nCodSolicitud AND nEstado = 6      
      
  IF NOT EXISTS(SELECT 1 FROM ColocSolicitudPersona WHERE nCodSolicitud = @nCodSolicitud AND nPrdPersRelac = 28)      
  BEGIN      
   INSERT INTO ColocSolicitudPersona(nCodSolicitud, nPrdPersRelac, nCodPersona, cPersCod)      
   VALUES(@nCodSolicitud, 28, 0, @cCodAnalista)      
  END      
      
  -- LOS ANALISTAS SE INSERTAN DENTRO DEL COLOCACIONES.FluGenSol_InsSeguimientoPropCalif_SP      
  --INSERT INTO ProductoPersona (cCtaCod, cPersCod, nPrdPersRelac, bObligatorio, cObligatorio)      
  --VALUES  (@cCtaCod, @cCodAnalista, 28, NULL, NULL),      
  --  (@cCtaCod, @cCodAnalista, 38, NULL, NULL)      
      
      
  DECLARE @MsjCreditoOnline VARCHAR(500) = ''       
  DECLARE @To VARCHAR(20) = ''      
      
  SELECT @MsjCreditoOnline = 'Estimado, está pendiente la programación del crédito N° ' + @cCtaCod + ', el cual fue producto de una solicitud online registrada por Call Center.'      
  SELECT @To = (SELECT TOP 1 cUser + '@cmacica.com.pe' FROM rrhh WHERE cPersCod = @cCodAnalista AND dCese IS NULL)      
      
  EXEC MSDB.[DBO].SP_SEND_DBMAIL                                     
  @PROFILE_NAME ='Microseguros',                                    
  @SUBJECT = 'ALERTA POR REGISTRO DE CRÉDITO DERIVADO DE SOLICITUD ONLINE',                   
  @BODY = @MsjCreditoOnline,                  
  @RECIPIENTS = @To,                                  
  @COPY_RECIPIENTS = '',           
  @BLIND_COPY_RECIPIENTS = '',        
  @BODY_FORMAT='HTML',        
  @IMPORTANCE = 'HIGH'         
      
 END      
      
      
 IF @cCtaCod IS NULL OR @nestado = 2      
 BEGIN       
  SET @cCtaCod=''      
 END      
 IF @cCodSolicitud IS NULL      
 BEGIN      
  SET @cCodSolicitud=''      
 END      
 IF @nCodSolicitud IS NULL      
 BEGIN      
  SET @nCodSolicitud=0      
 END      
      
 UPDATE COLOCACIONES.PropuestaAvance      
 SET      
  bEstado = 0      
 WHERE cUsuarioOperacion = @cUser       
 AND cPersCod = (SELECT top 1 cpersCod FROM #ColocSolicitudPersona WITH(NOLOCK) WHERE nprdpersrelac=20)      
 AND bEstado = 1      
      
 DROP TABLE #ColocSolicitud,#MontoHipotecario,#ColocSolicitudEstado,#ColocSolicitudPersona,#ColocRegistroDependenciaHijo,#ExcepcionesGarantia,#GarantiasAsociadas,      
    #CreditosProceso,#MotorResultado,#Observaciones,#DatosSolicitudOnline, #FondoCredito, #VigenciaEvaluacion      
 COMMIT TRANSACTION       
 END TRY      
 BEGIN CATCH      
  IF @@TRANCOUNT > 0      
  BEGIN      
   ROLLBACK TRANSACTION      
  END      
        
  SET @cCtaCod = ''      
  SET @cCodSolicitud=''      
  SET @nCodSolicitud=0      
  SET @nCodError = ERROR_NUMBER()        
        
  IF @bInsError = 1      
  BEGIN      
   SET @cCodError = ('COLOCACIONES.FluGenSol_InsPropuesta_SP: ' + ERROR_MESSAGE())      
   EXEC General.InsErrorLog_SP @@ProcID      
  END      
      
  RAISERROR(@cCodError,11,1)      
 END CATCH      
 SET NOCOUNT OFF      
END
