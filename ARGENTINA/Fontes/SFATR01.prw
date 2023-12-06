#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
#Include "MsOle.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} RFISR03
Resumo de Presupuestos a Monitorar

@author 	Jose C. Frasson 
@since  	29.03.2020
@version 	1.00
/*/

User Function SFATR01()
Private cAli 		:= GetNextAlias()

If Empty(FunName()) .OR. Select("SX5") == 0
	RpcSetType(3)
	RpcSetEnv("01","00")
EndIf	

oReport := ReportDef()
oReport:PrintDialog()
Return
	
/*/{Protheus.doc} ReportDef

Colunas do relatório e parâmetros de definição em geral.

@author 	Jose C. Frasson 
@since  	29.03.2020
@version 	1.00
@param 		cPerg, character, Nome do pergunte no SX1.
/*/
Static Function ReportDef()
Local oReport
Local oSection1         

Local _cPerg		:= "SFATR01"  
Local cTitulo		:= "Presupuestos Pendiente"

PRIVATE nomeprog	:= "SFATR01"

/*
A=Aberto;B=Aprovado;C=Cancelado;D=Orcamento nao Orcado;F=Orcamento bloqueado
*/

u_ArPutSx1(	_cPerg, "01",	"Fecha de?",	"mv_par01", "mv_ch1", "D", 08, 0, "G", /*cValid*/, /*cF3*/, /*cPicture*/, /*def01*/, /*def02*/, /*def03*/, /*def04*/, /*def05*/, /*def06*/, 			 "Informe la fecha de")
u_ArPutSx1(	_cPerg, "02",	"Fecha hasta?",	"mv_par02", "mv_ch2", "D", 08, 0, "G", /*cValid*/, /*cF3*/, /*cPicture*/, /*def01*/, /*def02*/, /*def03*/, /*def04*/, /*def05*/, /*def06*/, 			 "Informe la fecha hasta")
u_ARPutSX1(	_cPerg, "03", 	"Estatus?",  	"MV_PAR03", "mv_ch3", "C", 01, 0, "C", /*cValid*/, /*cF3*/, /*cPicture*/, "A=Abierto", "B=Aprovado", "C=Cancelado", "D=Sen Valor", "T=Todos", "Informe lo Estatus de presupuesto")
   
Pergunte(_cPerg,.F.)
oReport:= TReport():New("SFATR01",cTitulo,_cPerg, {|oReport| ReportPrint(oReport,_cPerg)},cTitulo) 

oReport:SetPortrait()
oReport:SetLandsCape(.F.)
oReport:nEnvironment:= 2 //cliente
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 6
oReport:lBold 	:= .F.

oSection1 := TRSection():New(oReport,cTitulo,{cAli})

TRCell():New(oSection1,"CJ_NUM",		cAli,	'Numero',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CJ_EMISSAO",	cAli,	'Dt.Entrada',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CJ_CLIENTE",	cAli,	'Cliente',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CJ_LOJA",		cAli,	'Lj',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A1_NREDUZ",		cAli,	'Nombre',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CJ_XPROLIG",	cAli,	'Fecha',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CJ_XCVEND",		cAli,	'Vendedor',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CJ_XCVEND2",	cAli,	'Vend. Int',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"ZZY_DTINCL",	cAli,	'Dt Interc',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"ZZY_HORA",		cAli,	'Hr Interc',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"ZZY_ITEM",		cAli,	'Art',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"ZZY_OBS",		cAli,	'Obs',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"ZZY_RETORN",	cAli,	'Volver',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DIAS",			cAli,	'Dias',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"ESTATUS",		cAli,	'Estatus',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
Return(oReport)

Static Function ReportPrint(oReport,_cPerg)
Local oSection1 := oReport:Section(1)
Local cStatus	:= ""
Local aStatus 	:= {"A=Aberto","B=Aprovado","C=Cancelado","D=Sen Valor","T=Todos"}

Pergunte(_cPerg,.F.)

If Select(cAli) > 0
	(cAli)->(dbCloseArea())
EndIf	

cStatus	:= LEFT(aStatus[MV_PAR03],1)

If cStatus == "T"
	cStatus := "%" + "('A','B','C','D')" + "%" 
Else
	cStatus := "%" + "('" + cStatus + "')" + "%" 
Endif

oSection1:BeginQuery()

	BeginSQL Alias cAli
	
		%noParser%

		SELECT DISTINCT 
			CJ_NUM,
			CJ_EMISSAO,
			CJ_CLIENTE,
			CJ_LOJA,
			A1_NREDUZ,
			CJ_XCVEND,
			CJ_XCVEND2,
			CJ_XPROLIG,
			ZZY_DTINCL,
			ZZY_HORA,
			ZZY_ITEM,
			ZZY_OBS,
			ZZY_RETORN,
			NVL((SELECT TRUNC(SYSDATE-TO_DATE(SCJ.CJ_XPROLIG,'RRRR-MM-DD'),0) FROM DUAL WHERE SCJ.CJ_XPROLIG <>' '),0) AS DIAS,
			CASE 
				WHEN CJ_STATUS = 'A' THEN 'A - Abierto'
				WHEN CJ_STATUS = 'B' THEN 'B - Efectivado'
				WHEN CJ_STATUS = 'C' THEN 'C - Anulado'
				WHEN CJ_STATUS = 'D' THEN 'D - Sen Valor'
				WHEN CJ_STATUS = 'F' THEN 'F - Con Bloqueo'
			END AS ESTATUS
		FROM %table:SCJ% SCJ 
		INNER 	JOIN %table:SA1% SA1 ON ( A1_COD = CJ_CLIENTE AND A1_LOJA = CJ_LOJA AND SA1.%notDel% )
		LEFT	JOIN %table:ZZY% ZZY ON ( ZZY_FILIAL = CJ_FILIAL AND ZZY_NUM = CJ_NUM AND ZZY.%notDel% )
		WHERE SCJ.%notDel%
		AND CJ_FILIAL 	= %Exp:xFilial("SCJ")%
		AND CJ_EMISSAO 	BETWEEN %exp:MV_PAR01% 	AND %exp:MV_PAR02%
		AND CJ_STATUS	IN %exp:cStatus%
		ORDER BY 1

	EndSQL
	
oSection1:EndQuery()
oSection1:Print()	
Return