#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} CORFAT06

Detalle de Facturas de Credito

@type 		function
@author 	Jose C. Frasson
@since 		02/09/2020
@version 	Protheus 12 - Faturamento

@history , ,

/*/
User Function CORFAT06() 
Private cAli 		:= GetNextAlias()

oReport := ReportDef()
oReport:PrintDialog()
Return

/*/{Protheus.doc} ReportDef

Colunas do relatório e parâmetros de definição em geral.

@type 		function
@author 	Jose C. Frasson
@since 		02/09/2020
@version 	Protheus 12 - Faturamento
/*/

Static Function ReportDef()
Local oReport
Local oSection1         

Local cPerg			:= "CORFAT06"  
Local cTitulo		:= "Facturas de Credito"

PRIVATE nomeprog	:= "CORFAT06"

u_COPutSX1(cPerg, "01",	"Fecha inicio ?",  	"MV_PAR01", "mv_ch1", "D", 08, 0, "G", /*cValid*/, /*cF3*/, /*cPicture*/, "", "", "", "", "", "Informe la fecha del inicio")
u_COPutSX1(cPerg, "02",	"Fecha hasta?",  	"MV_PAR02", "mv_ch2", "D", 08, 0, "G", /*cValid*/, /*cF3*/,	/*cPicture*/, "", "", "", "", "", "Informe la fecha hasta")

Pergunte(cPerg,.F.)
oReport:= TReport():New("CORFAT06",cTitulo,cPerg, {|oReport| ReportPrint(oReport,cPerg)},cTitulo) 
oReport:cFontBody := 'Courier New'
oReport:nFontBody := 10

oSection1 := TRSection():New(oReport,cTitulo,{cAli})

//TRCell():New(oSection1,"F1_XCOMPNF",	cAli,	'Prot.CONFIAR',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"F1_DOC",		cAli,	'Num.Doc',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"F1_SERIE",		cAli,	'Ser',/*Picture*/,,/*lPixel*/,/*{|| IF(ENT->FT_ENTRADA <> " ",CTOD(SUBSTR(ENT->FT_ENTRADA,7,2)+"/"+Substr(ENT->FT_ENTRADA,5,2)+"/"+Substr(ENT->FT_ENTRADA,1,4)),"")}*/)
TRCell():New(oSection1,"F1_FORNECE",	cAli,	'Cli/For',/*Picture*/,,/*lPixel*/,/*{|| IF(ENT->FT_ENTRADA <> " ",CTOD(SUBSTR(ENT->FT_EMISSAO,7,2)+"/"+Substr(ENT->FT_EMISSAO,5,2)+"/"+Substr(ENT->FT_EMISSAO,1,4)),"")}*/)
TRCell():New(oSection1,"F1_ESPECIE",	cAli,	'Esp',/*Picture*/,,/*lPixel*/,/*{|| IF(ENT->FT_ENTRADA <> " ",CTOD(SUBSTR(ENT->FT_EMISSAO,7,2)+"/"+Substr(ENT->FT_EMISSAO,5,2)+"/"+Substr(ENT->FT_EMISSAO,1,4)),"")}*/)
TRCell():New(oSection1,"F1_LOJA",		cAli,	'Lj',/*Picture*/,,/*lPixel*/,/*{|| IF(ENT->FT_ENTRADA <> " ",CTOD(SUBSTR(ENT->FT_EMISSAO,7,2)+"/"+Substr(ENT->FT_EMISSAO,5,2)+"/"+Substr(ENT->FT_EMISSAO,1,4)),"")}*/)
TRCell():New(oSection1,"A1_NOME",		cAli,	'Nombre',/*Picture*/,,/*lPixel*/,/*{|| IF(ENT->FT_ENTRADA <> " ",CTOD(SUBSTR(ENT->FT_EMISSAO,7,2)+"/"+Substr(ENT->FT_EMISSAO,5,2)+"/"+Substr(ENT->FT_EMISSAO,1,4)),"")}*/)
TRCell():New(oSection1,"F1_EMISSAO",	cAli,	'Fecha',/*Picture*/,,/*lPixel*/,/*{|| IF(ENT->FT_ENTRADA <> " ",CTOD(SUBSTR(ENT->FT_EMISSAO,7,2)+"/"+Substr(ENT->FT_EMISSAO,5,2)+"/"+Substr(ENT->FT_EMISSAO,1,4)),"")}*/)
TRCell():New(oSection1,"F1_VALMERC",	cAli,	'Valor Mercanc.',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"F1_VALBRUT",	cAli,	'Valor Total',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"F1_VALIMP1",	cAli,	'Vr. IVA',/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_COD",		cAli,	'Codigo',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_DESC",		cAli,	'Producto',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_QUANT",		cAli,	'Cantidad',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_VUNIT",		cAli,	'Vr.Unit.',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_TOTAL",		cAli,	'Vr.Total',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_TES",		cAli,	'TES',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_CF",			cAli,	'CFOP',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_NFORI",		cAli,	'NF.Orig.',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_SERIORI",	cAli,	'Ser.Orig.',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
Return(oReport)

Static Function ReportPrint(oReport,cPerg)
Local oSection1 := oReport:Section(1)

Pergunte(cPerg,.F.)

If Select(cAli) > 0
	(cAli)->(dbCloseArea())
EndIf	

oSection1:BeginQuery()

	BeginSQL Alias cAli
	
		%noParser%

		SELECT 
		    F1_TIPO,    /*/SUBSTR(F1_XCOMPNF,1,20) F1_XCOMPNF, /*/
		    F1_DOC, 
		    F1_SERIE, 	
		    F1_ESPECIE,
		    F1_FORNECE, 
		    A1_NOME, 
		    F1_LOJA, 
		    F1_EMISSAO, 
		    F1_VALMERC, 
		    F1_VALBRUT, 
		    F1_VALIMP1, 
		    D1_COD, 
		    B1_DESC, 
		    D1_QUANT, 
		    D1_VUNIT, 
		    D1_TOTAL, 
		    D1_TES, 
		    D1_CF, 
		    D1_NFORI, 
		    D1_SERIORI
		FROM %table:SF1% SF1
		INNER JOIN %table:SA1% SA1 ON ( A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA AND SA1.%notDel% )
		INNER JOIN %table:SD1% SD1 ON ( D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND SD1.%notDel% )
		INNER JOIN %table:SB1% SB1 ON ( B1_COD = D1_COD AND SB1.%notDel% )
		WHERE SF1.%notDel%
		AND F1_FILIAL 	= %Exp:xFilial("SF1")%
		AND F1_DTDIGIT 	BETWEEN %exp:MV_PAR01% 	AND %exp:MV_PAR02%
		AND F1_ESPECIE = 'NCC'
		ORDER BY 3,4
	
	EndSQL
	
oSection1:EndQuery()
oSection1:Print()	
Return
