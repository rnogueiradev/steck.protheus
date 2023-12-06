#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
#Include "MsOle.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} streleic01
description
 Rotina que fará impressão do relatório de Mercadorias em Trânsito"
 Ticket: 20200228000761
@type function
@version 
@author Valdemir Jose
@since 04/11/2020
@return return_type, return_description
u_streleic01
/*/

User Function streleic01()

	Private cAli 		:= GetNextAlias()
	//Private nMoeda		:= 0
	Private cDtMoeda	:= ""
	
	/*
	If Empty(FunName()) .Or. Select("SX5") == 0
		RpcSetType(3)
		RpcSetEnv("01","01")
	EndIf
	*/	
	
	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*/{Protheus.doc} ReportDef
Colunas do relatório e parâmetros de definições em geral.
@author 	Jose C. Frasson 
@since  	29.03.2020
@version 	1.00
@param 		cPerg, character, Nome do pergunte no SX1.
/*/

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local _cPerg		:= "STRELEIC01"  
	Local cTitulo		:= "Relatório de Mercadorias em Trânsito"
	Private nomeprog	:= "STRELEIC01"

	dbSelectArea("SM2")
	dbSetOrder(1)

	If SM2->( dbSeek(dDatabase) )
		//nMoeda 		:= SM2->M2_MOEDA2
		cDtMoeda	:= DtoS(SM2->M2_DATA)		
	EndIf	

    AjustaSX1(_cPerg)
	Pergunte(_cPerg,.F.)
	
	oReport := TReport():New("STRELEIC01", cTitulo, _cPerg, {|oReport| ReportPrint(oReport, _cPerg)}, cTitulo) 
	
	oReport:SetPortrait()
	oReport:SetLandsCape(.F.)
	oReport:nEnvironment := 2	// Cliente
	oReport:SetTotalInLine(.F.)
	oReport:nFontBody	 := 10
	oReport:lBold 		 := .F.

	oSection1 := TRSection():New(oReport, cTitulo, {cAli})
	
	//Colunas do relatório
	TRCell():New(oSection1, "W6_HAWB"		, cAli, "Ref.Processo"			, /*Picture*/, 17, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W9_NOM_FOR"	, cAli, "Exportador"			, /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W6_IMPORVM"	, cAli, "Unidade Req"			, /*Picture*/, 52, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W9_MOE_FOB"	, cAli, "Moeda"					, /*Picture*/, 3,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W2_FOB_TOT"	, cAli, "Fatura USD/EURO"		, /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W2_PARID_U"	, cAli, "Taxa Conversão"		, /*Picture*/, 13, /*lPixel*/,/*{|| nMoeda }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W6_TOT_PRO"	, cAli, "Fatura Reais"			, /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W9_DT_EMIS"	, cAli, "Data Invoice"			, /*Picture*/, 8,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W6_DT_ETD"		, cAli, "Previsão Saída"		, /*Picture*/, 8,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W6_DT_ETD"		, cAli, "Confirmação Saída"		, /*Picture*/, 8,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W6_DT_ETA"		, cAli, "Previsão Chegada"		, /*Picture*/, 8,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W6_DT_ETA"		, cAli, "Confirmação Chegada"	, /*Picture*/, 8,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "W6_TIPODES"	, cAli, "Tipo de Declaracao"	, /*Picture*/, 8,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "JB_DESCR"		, cAli, "Descricao Tipo"		, /*Picture*/, 8,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1, "STATUS"		, cAli, "Status"				, /*Picture*/, 8,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

Return oReport

Static Function ReportPrint(oReport,_cPerg)

	Local oSection1 := oReport:Section(1)

	Pergunte(_cPerg,.F.)

	If Select(cAli) > 0
		(cAli)->( dbCloseArea() )
	EndIf	

	oSection1:BeginQuery()

	BeginSQL Alias cAli	
		COLUMN W9_DT_EMIS 	AS DATE
		COLUMN W6_DT_ETD 	AS DATE
		COLUMN W6_DT_ETA	AS DATE
		%noParser%
		SELECT 
			W6_HAWB, W9_NOM_FOR, W6_IMPORT W6_IMPORVM, W9_MOE_FOB, W2_FOB_TOT,
			NVL(
             	(SELECT CASE
            			WHEN W9_MOE_FOB = 'US$' THEN M2_MOEDA2
                        ELSE M2_MOEDA4
                    	END
              	FROM SM2010 M21
              	WHERE M21.D_E_L_E_T_ = ' '
                	AND M21.M2_DATA =  %Exp:cDtMoeda%),1) W2_PARID_U,
			(W6_FOB_TOT+W6_INLAND+W6_PACKING+W6_FRETEIN+W6_SEGINV+W6_OUTDESP-W6_DESCONT) W6_TOT_PRO, 
		    W9_DT_EMIS, W6_DT_ETD, W6_DT_ETA, W6_TIPODES, JB_DESCR, '' Status
		FROM %table:SW6% A
		INNER 	JOIN %table:SW2% 	B	ON ( A.W6_FILIAL=B.W2_FILIAL AND B.W2_PO_NUM=A.W6_PO_NUM AND B.%notDel% ) 
		INNER 	JOIN %table:SW9%	C	ON ( C.W9_FILIAL=A.W6_FILIAL AND C.W9_HAWB=A.W6_HAWB AND C.%notDel% ) 	
		LEFT	JOIN %table:SJB% 	SJB	ON ( JB_COD = W6_TIPODES AND SJB.%notDel% )
		WHERE A.%notDel%
			AND W9_DT_EMIS  BETWEEN %exp:MV_PAR01% 	AND %exp:MV_PAR02%
			AND W6_DT_ETD   BETWEEN %exp:MV_PAR03% 	AND %exp:MV_PAR04%
			AND W6_DT_ETA   BETWEEN %exp:MV_PAR05% 	AND %exp:MV_PAR06%
		ORDER BY W6_DT_ETD
	EndSQL
	
	oSection1:EndQuery()
	oSection1:Print()

Return

/*/{Protheus.doc} AjustaSX1
description
Cria arquivo de perguntas
@type function
@version 
@author Valdemir Jose
@since 04/11/2020
@param cPerg, character, param_description
@return return_type, return_description
/*/

Static Function AjustaSX1(cPerg)

	Local aAreaX1     := GetArea()
	Local _aRegistros := {}
	Local i           := 0
	Local j           := 0

	aAdd(_aRegistros,{cPerg, "01", "Data Invoice De ?"  ,"Data Invoice De ? "  ,"Data Invoice De ?" ,"mv_ch1","D",8,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(_aRegistros,{cPerg, "02", "Data Invoice Até ?" ,"Data Invoice Até ? " ,"Data Invoice Até ?","mv_ch2","D",8,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(_aRegistros,{cPerg, "03", "Data previsão saída De ?"  ,"Data previsão saída De ? "  ,"Data previsão saída De ?" ,"mv_ch3","D",8,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(_aRegistros,{cPerg, "04", "Data previsão saída Até ?" ,"Data previsão saída Até ? " ,"Data previsão saída Até ?","mv_ch4","D",8,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(_aRegistros,{cPerg, "05", "Data previsão chegada De ?"  ,"Data previsão chegada De ? "  ,"Data previsão chegada De ?" ,"mv_ch5","D",8,0,0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(_aRegistros,{cPerg, "06", "Data previsão chegada Até ?" ,"Data previsão chegada Até ? " ,"Data previsão chegada Até ?","mv_ch6","D",8,0,0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	_nCols := FCount()

	For i := 1 to Len(_aRegistros)
		aSize(_aRegistros[i],_nCols)
		If !dbSeek(_aRegistros[i,1] + _aRegistros[i,2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				FieldPut(j,If(_aRegistros[i,j] = Nil, "", _aRegistros[i,j] ))
			Next j
			MsUnlock()
		EndIf
	Next i

	RestArea( aAreaX1 )

Return
