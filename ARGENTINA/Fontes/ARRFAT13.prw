#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
#Include "MsOle.ch"
#INCLUDE "TOPCONN.CH"
#Include "Matr120.ch"

/*/{Protheus.doc} ARRFAT13
Resumo de Presupuestos a Monitorar

@author 	Jose C. Frasson 
@since  	07.05.2020
@version 	1.00
/*/

User Function ARRFAT13()
Private cAli 		:= GetNextAlias()
Private _cPerg 	 	:= PadR ("MTR120", Len (SX1->X1_GRUPO))

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
@since  	07.05.2020
@version 	1.00
@param 		cPerg, character, Nome do pergunte no SX1.
/*/

Static Function ReportDef()
Local oReport
Local oSection1         
Local cTitulo		:= "Pedidos en Abierto"
Local aOrdem		:= {}

PRIVATE nomeprog	:= "ARRFAT13"
   
Pergunte(_cPerg,.F.)
oReport:= TReport():New("ARRFAT13",cTitulo,_cPerg, {|oReport| ReportPrint(oReport,_cPerg)},cTitulo) 

oReport:SetPortrait()
oReport:SetLandsCape(.F.)
oReport:nEnvironment:= 2 //cliente
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 6
oReport:lBold 	:= .F.

/*
Aadd( aOrdem, STR0004 ) // "Por Numero"
Aadd( aOrdem, STR0005 ) // "Por Produto"
Aadd( aOrdem, STR0006 ) // "Por Fornecedor"
Aadd( aOrdem, STR0049 ) // "Por Previsao de Entrega "
*/

oSection1 := TRSection():New(oReport,STR0062,{"SC7","SA2","SB1","Z27"},aOrdem) //"Relacao de Pedidos de Compras"
oSection1 :SetTotalInLine(.F.)

TRCell():New(oSection1,	"C7_NUM",		cAli,	u_xMyRetCpo("C7_NUM",2)/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"C7_FORNECE",	cAli,	u_xMyRetCpo("C7_FORNECE",2)/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"C7_LOJA",		cAli,	u_xMyRetCpo("C7_LOJA")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.T.)
TRCell():New(oSection1,	"A2_NOME",		cAli, 	u_xMyRetCpo("A2_NOME")/*Titulo*/,		/*Picture*/,100/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"A2_TEL",		cAli, 	u_xMyRetCpo("A2_TEL")/*Titulo*/,		/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"A2_FAX",		cAli, 	u_xMyRetCpo("A2_FAX")/*Titulo*/,		/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"A2_CONTATO",	cAli, 	u_xMyRetCpo("A2_CONTATO")/*Titulo*/,	/*Picture*/,100/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"C7_PRODUTO",	cAli, 	u_xMyRetCpo("C7_PRODUTO")/*Titulo*/,	/*Picture*/,50/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"B1_DESC",		cAli, 	u_xMyRetCpo("B1_DESC")/*Titulo*/,		/*Picture*/,100/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"C7_ITEM",		cAli, 	u_xMyRetCpo("C7_ITEM")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection1,	"C7_NUMSC",		cAli, 	u_xMyRetCpo("C7_NUMSC")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.T.)
TRCell():New(oSection1,	"B1_GRUPO",		cAli, 	u_xMyRetCpo("B1_GRUPO")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.T.)
TRCell():New(oSection1,	"C7_EMISSAO",	cAli, 	u_xMyRetCpo("C7_EMISSAO")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"C7_DATPRF",	cAli, 	u_xMyRetCpo("C7_DATPRF")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER",,,.T.)
TRCell():New(oSection1,	"C7_QUANT",		cAli, 	u_xMyRetCpo("C7_QUANT")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT",,,.T.) 
TRCell():New(oSection1,	"C7_UM",		cAli, 	u_xMyRetCpo("C7_UM")/*Titulo*/,			/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"C7_PRECO",		cAli, 	u_xMyRetCpo("C7_PRECO")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT",,,.T.)
TRCell():New(oSection1,	"C7_VLDESC",	cAli, 	u_xMyRetCpo("C7_VLDESC")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT",,,.T.)
TRCell():New(oSection1,	"C7_VALIPI",	cAli, 	u_xMyRetCpo("C7_VALIPI")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT",,,.T.)
TRCell():New(oSection1,	"C7_TOTAL",		cAli, 	u_xMyRetCpo("C7_TOTAL")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT",,,.T.)
TRCell():New(oSection1,	"C7_QUJE",		cAli, 	u_xMyRetCpo("C7_QUJE")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"C7_RESIDUO",	cAli, 	u_xMyRetCpo("C7_RESIDUO")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"C7_OBS",		cAli, 	u_xMyRetCpo("C7_OBS")/*Titulo*/,		/*Picture*/,300/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)

TRCell():New(oSection1,	"Z27_FACTUR",	cAli,	u_xMyRetCpo("Z27_FACTUR")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_MARCA",	cAli,	u_xMyRetCpo("Z27_MARCA")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_PEDFAT",	cAli,	u_xMyRetCpo("Z27_PEDFAT")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_EMBARQ",	cAli,	u_xMyRetCpo("Z27_EMBARQ")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_DESTIN",	cAli,	u_xMyRetCpo("Z27_DESTIN")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_PNETO",	cAli,	u_xMyRetCpo("Z27_PNETO")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_PBRUTO",	cAli,	u_xMyRetCpo("Z27_PBRUTO")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_VOLUME",	cAli,	u_xMyRetCpo("Z27_VOLUME")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_TOTAL",	cAli,	u_xMyRetCpo("Z27_TOTAL")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_LOCAL",	cAli,	u_xMyRetCpo("Z27_LOCAL")/*Titulo*/,		/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_NOTIFI",	cAli,	u_xMyRetCpo("Z27_NOTIFI")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_ORIGEN",	cAli,	u_xMyRetCpo("Z27_ORIGEN")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_PROCED",	cAli,	u_xMyRetCpo("Z27_PROCED")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)
TRCell():New(oSection1,	"Z27_INCOTE",	cAli,	u_xMyRetCpo("Z27_INCOTE")/*Titulo*/,	/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT",,,.F.)

//TRFunction():New(oSection1:Cell("C7_VALIPI"),	NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 
//TRFunction():New(oSection1:Cell("C7_TOTAL"),	NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
//TRFunction():New(oSection1:Cell("nSalRec"),		NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 

Return(oReport)

Static Function ReportPrint(oReport,_cPerg)
Local oSection1 := oReport:Section(1)

Pergunte(_cPerg,.F.)

If Select(cAli) > 0
	(cAli)->(dbCloseArea())
EndIf	

oSection1:BeginQuery()

	BeginSQL Alias cAli
	
		%noParser%

		SELECT DISTINCT 
			C7_NUM,
			C7_FORNECE,
			C7_LOJA,
			A2_NOME,
			A2_TEL,	
			A2_FAX,
			A2_CONTATO,
			C7_PRODUTO,
			B1_DESC,
			C7_ITEM,	
			C7_NUMSC,	
			B1_GRUPO,	
			C7_EMISSAO,
			C7_DATPRF,	
			C7_QUANT,	
			C7_UM,		
			C7_PRECO,	
			C7_VLDESC,	
			C7_VALIPI,	
			C7_TOTAL,	
			C7_QUJE,	
			C7_OBS,
			C7_RESIDUO,
			Z27_FACTUR,
			Z27_MARCA,	
			Z27_PEDFAT,
			Z27_EMBARQ,
			Z27_DESTIN,
			Z27_PNETO,	
			Z27_PBRUTO,
			Z27_VOLUME,
			Z27_TOTAL,	
			Z27_LOCAL,	
			Z27_NOTIFI,
			Z27_ORIGEN,
			Z27_PROCED,
			Z27_INCOTE
		FROM %table:SC7% SC7
		INNER 	JOIN %table:SA2% SA2 ON ( A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.%notDel% )
		INNER 	JOIN %table:SB1% SB1 ON ( B1_COD = C7_PRODUTO AND SB1.%notDel% )
		LEFT	JOIN %table:Z27% Z27 ON ( Z27_FILIAL = C7_FILIAL AND Z27_PEDCOM = C7_NUM AND Z27_FORNEC = C7_FORNECE AND Z27_LOJA = C7_LOJA AND Z27.%notDel% )
		WHERE SC7.%notDel%
		AND C7_FILIAL 	= %Exp:xFilial("SCJ")%
		AND C7_NUM		BETWEEN %exp:MV_PAR08% 	AND %exp:MV_PAR09%
		AND C7_EMISSAO 	BETWEEN %exp:MV_PAR03% 	AND %exp:MV_PAR04%
		AND C7_PRODUTO	BETWEEN %exp:MV_PAR01% 	AND %exp:MV_PAR02%
		ORDER BY 1

	EndSQL

oSection1:EndQuery()
oSection1:Print()	
Return