#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ARRFAT08  บAutor  ณJefferson Carlos   บ Data ณ  21/02/19    บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Previsao de Vendas PA                          บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                       บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function ARRFAT08()				//U_ARRFAT08()
	*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFATC1A"
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := cPerg+cHora+cMinutos+cSegundos
	Private lXlsHeader  := .F.
	Private lXmlEndRow  := .F.
	Private cPergTit 	:= cAliasLif

	Private cAnoMes01	:= ""
	Private cAnoMes02	:= ""
	Private cAnoMes03	:= ""
	Private cAnoMes04	:= ""
	Private cAnoMes05	:= ""
	Private cAnoMes06	:= ""
	/*
	xPutSx1(cPerg, "01", "Produto de"		,"Produto de"		,"Produto de"		,"mv_ch1", "C", 15, 0, 0, "G", "", "SB1" 	,"","" ,"mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Produto ate"		,"Produto ate"		,"Produto ate"		,"mv_ch2", "C", 15, 0, 0, "G", "", "SB1" 	,"","" ,"mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Grupo de"			,"Grupo de"			,"Grupo de"			,"mv_ch3", "C", 15, 0, 0, "G", "", "SBM" 	,"","" ,"mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Grupo ate"		,"Grupo ate"		,"Grupo ate"		,"mv_ch4", "C", 15, 0, 0, "G", "", "SBM" 	,"","" ,"mv_par04","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "05", "Origem"			,"Origem"			,"Origem"			,"mv_ch5", "C", 01, 0, 0, "C", "", ""		,"","S","mv_par05","Comprado","","","","Importado","","","Fabricado","","","Todos","","","","","",,,)
	xPutSx1(cPerg, "06", "Local"			,"Local"			,"Local"			,"mv_ch6", "C", 02, 0, 0, "C", "", ""		,"","" ,"mv_par06","","","","","","","","","","","","","","","","",,,)
	*/
	oReport		:= ReportDef()

	oReport:PrintDialog()

	Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ ReportDef บAutor  ณJefferson Carlos   บ Data ณ  28/06/18   บฑฑ
	ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio de Previsao de Vendas PA                          บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Steck                                                       บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection
	Local nMeses := 0

	oReport := TReport():New(cPergTit,"Relat๓rio de Previsใo de Vendas PA",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um Relat๓rio de Previsใo de Vendas PA")

	Pergunte(cPerg,.T.)

	oSection := TRSection():New(oReport,"Relat๓rio de Previsใo de Vendas PA",{"SUA"})

	
	TRCell():New(oSection,"01",,"Produto"							,,06,.F.,)
	TRCell():New(oSection,"02",,"Descri็ใo Produto"					,,50,.F.,)
	TRCell():New(oSection,"03",,"Grupo" 							,,06,.F.,)
	TRCell():New(oSection,"04",,"Descri็ใo Grupo"			 		,,50,.F.,)
	TRCell():New(oSection,"05",,"FMR"								,,06,.F.,)
	TRCell():New(oSection,"06",,"Bloqueado"							,,06,.F.,)
	TRCell():New(oSection,"07",,"Previsใo de Vendas"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"08",,"Estoque de Seguran็a"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"09",,"Fat 06"	 						,"@E 99,999,999.99",14)
	TRCell():New(oSection,"10",,"Fat 05" 							,"@E 99,999,999.99",14)
	TRCell():New(oSection,"11",,"Fat 04" 							,"@E 99,999,999.99",14)
	TRCell():New(oSection,"12",,"Fat 03" 							,"@E 99,999,999.99",14)
	TRCell():New(oSection,"13",,"Fat 02" 							,"@E 99,999,999.99",14)
	TRCell():New(oSection,"14",,"Fat 01" 							,"@E 99,999,999.99",14)
	TRCell():New(oSection,"15",,"Fat 00" 							,"@E 99,999,999.99",14)
	TRCell():New(oSection,"16",,"M้dia Trimestre"					,"@E 99,999,999.99",14)
	TRCell():New(oSection,"17",,"Est. Disponivel"					,"@E 99,999,999.99",14)
	TRCell():New(oSection,"18",,"Custo 1a Moeda"					,"@E 99,999,999.99",14)
	

	oSection:SetHeaderSection(.T.)
	oSection:Setnofilter("SUA")

	Return oReport
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณReportPrintบAutor  ณJefferson Carlos   บ Data ณ  28/06/18   บฑฑ
	ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio de Previsao de Vendas PA                          บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Steck                                                       บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
	oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
	oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
	oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
	oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
	oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
	oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
	

	oReport:SetTitle("SUA")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery() },"Compondo Relat๓rio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		Do While (cAliasLif)->(!Eof())
			
					
			aDados1[01]	:=  (cAliasLif)->CODIGO			//Produto
			aDados1[02]	:=  (cAliasLif)->DESCRI			//Descri็ใo Produto
			aDados1[03]	:=  (cAliasLif)->CODGRP			//Grupo
			aDados1[04]	:=  (cAliasLif)->DESCGRP		//Descri็ใo Grupo
			aDados1[05]	:=	(cAliasLif)->CLAFMR			//FMR
			aDados1[06]	:= 	(cAliasLif)->BLOQ			//Bloqueado			                                                                                          
			aDados1[07]	:= 	Val((cAliasLif)->PRVVEN)	//Previsใo de Vendas
			aDados1[08]	:= 	(cAliasLif)->ESTSEG 		//Estoque de Seguran็a
			aDados1[09]	:= 	(cAliasLif)->QTD6
			aDados1[10]	:= 	(cAliasLif)->QTD5
			aDados1[11]	:= 	(cAliasLif)->QTD4
			aDados1[12]	:= 	(cAliasLif)->QTD3
			aDados1[13]	:= 	(cAliasLif)->QTD2
			aDados1[14]	:= 	(cAliasLif)->QTD1
			aDados1[15]	:= 	(cAliasLif)->QTD0
			aDados1[16]	:= 	(cAliasLif)->MEDIA			//M้dia Trimestre
			aDados1[17]	:= 	(cAliasLif)->SALDO			//Estoque Liquido
			aDados1[18]	:= 	(cAliasLif)->CUSTO			//Custo 1a Moeda
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		EndDo

		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
	Return oReport

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ StQuery   บAutor  ณJefferson Carlos   บ Data ณ  28/06/18   บฑฑ
	ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio de Previsao de Vendas PA                          บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Steck                                                       บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------*
Static Function StQuery()
	*-----------------------------*

	Local cQuery 	:= ""
	Local _cClaprod := ""
	Local _nX

	//DO CASE
		//CASE MV_PAR05 = 1
		//_cClaprod := 'C'
		//CASE MV_PAR05 = 2
		//_cClaprod := 'I'
		//CASE MV_PAR05 = 3
		//_cClaprod := 'F'
	//ENDCASE
	

	cQuery := " SELECT B1_COD CODIGO ,B1_DESC DESCRI ,B1_GRUPO CODGRP,BM_DESC DESCGRP,B1_ORIGEM ORIGEM,B1_XFMR CLAFMR , " + CRLF
	cQuery += " CASE WHEN B1_MSBLQL='1' THEN 'S' ELSE 'N' END  BLOQ, " + CRLF
	cQuery += " B1_ESTSEG ESTSEG,  " + CRLF
	cQuery += " B1_XPREMES PRVVEN, " + CRLF 
	cQuery += " NVL(FT6.QUANT	,0	)QTD6	, " + CRLF
	cQuery += " NVL(FT5.QUANT	,0	)QTD5	, " + CRLF
	cQuery += " NVL(FT4.QUANT	,0	)QTD4	, " + CRLF
	cQuery += " NVL(FT3.QUANT	,0	)QTD3	, " + CRLF
	cQuery += " NVL(FT2.QUANT	,0	)QTD2	, " + CRLF
	cQuery += " NVL(FT1.QUANT	,0	)QTD1	, " + CRLF
	cQuery += " NVL(FT0.QUANT	,0	)QTD0	, " + CRLF

	cQuery += " ROUND(	CASE WHEN (NVL(FT3.QUANT,0)+NVL(FT2.QUANT,0)+NVL(FT1.QUANT,0)) > 0 " + CRLF 
	cQuery += " 		THEN (NVL(FT3.QUANT,0)+NVL(FT2.QUANT,0)+NVL(FT1.QUANT,0)) / 3  " + CRLF
	cQuery += " 		ELSE 0 END	,2) MEDIA, " + CRLF

	cQuery += " NVL(B2_CM1,0) CUSTO,  " + CRLF

	cQuery += " NVL(B2_QATU,0)-NVL(B2_RESERVA,0)-NVL(B2_QEMP,0)-NVL(B2_QACLASS,0)-NVL(SDC.DCQTD,0) SALDO  " + CRLF

	
	cQuery += " FROM " + RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SBM") + " SBM ON B1_FILIAL=BM_FILIAL AND B1_GRUPO=BM_GRUPO AND SBM.D_E_L_E_T_!='*' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SB2") + " SB2 ON B2_FILIAL='"+cFilAnt+"' AND B2_COD=B1_COD AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_!='*' " + CRLF

	
	cQuery += " LEFT JOIN (	SELECT D2_COD CODIGO,SUM(D2_QUANT) QUANT " + CRLF
	cQuery += " 			FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 			INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL='"+cFilAnt+"' AND F4_CODIGO=D2_TES AND F4_ESTOQUE='S' AND F4_DUPLIC ='S' AND SF4.D_E_L_E_T_!='*' " + CRLF 
	cQuery += " 			WHERE D2_FILIAL='"+cFilAnt+"'  AND SUBSTR(D2_EMISSAO,1,6) = TO_CHAR(ADD_MONTHS(SYSDATE, -6),'YYYYMM')  AND D2_CLIENTE <> '033467' AND D2_SERIE <> 'R' AND D2_ESPECIE ='NF' AND SD2.D_E_L_E_T_!='*' " + CRLF
	cQuery += " 			GROUP BY D2_COD,SUBSTR(D2_EMISSAO,1,6))	FT6 ON B1_COD=FT6.CODIGO " + CRLF

	cQuery += " LEFT JOIN (	SELECT D2_COD CODIGO,SUM(D2_QUANT) QUANT " + CRLF
	cQuery += " 			FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 			INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL='"+cFilAnt+"' AND F4_CODIGO=D2_TES AND F4_ESTOQUE='S' AND F4_DUPLIC ='S' AND SF4.D_E_L_E_T_!='*' " + CRLF 
	cQuery += " 			WHERE D2_FILIAL='"+cFilAnt+"'  AND SUBSTR(D2_EMISSAO,1,6) = TO_CHAR(ADD_MONTHS(SYSDATE, -5),'YYYYMM')  AND D2_CLIENTE <> '033467' AND D2_SERIE <> 'R' AND D2_ESPECIE ='NF' AND SD2.D_E_L_E_T_!='*' " + CRLF
	cQuery += " 			GROUP BY D2_COD,SUBSTR(D2_EMISSAO,1,6))	FT5 ON B1_COD=FT5.CODIGO " + CRLF

	cQuery += " LEFT JOIN (	SELECT D2_COD CODIGO,SUM(D2_QUANT) QUANT " + CRLF
	cQuery += " 			FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 			INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL='"+cFilAnt+"' AND F4_CODIGO=D2_TES AND F4_ESTOQUE='S' AND F4_DUPLIC ='S' AND SF4.D_E_L_E_T_!='*' " + CRLF 
	cQuery += " 			WHERE D2_FILIAL='"+cFilAnt+"'  AND SUBSTR(D2_EMISSAO,1,6) = TO_CHAR(ADD_MONTHS(SYSDATE, -4),'YYYYMM')  AND D2_CLIENTE <> '033467' AND D2_SERIE <> 'R' AND D2_ESPECIE ='NF' AND SD2.D_E_L_E_T_!='*' " + CRLF
	cQuery += " 			GROUP BY D2_COD,SUBSTR(D2_EMISSAO,1,6))	FT4 ON B1_COD=FT4.CODIGO " + CRLF

	cQuery += " LEFT JOIN (	SELECT D2_COD CODIGO,SUM(D2_QUANT) QUANT " + CRLF
	cQuery += " 			FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 			INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL='"+cFilAnt+"' AND F4_CODIGO=D2_TES AND F4_ESTOQUE='S' AND F4_DUPLIC ='S' AND SF4.D_E_L_E_T_!='*' " + CRLF 
	cQuery += " 			WHERE D2_FILIAL='"+cFilAnt+"'  AND SUBSTR(D2_EMISSAO,1,6) = TO_CHAR(ADD_MONTHS(SYSDATE, -3),'YYYYMM')  AND D2_CLIENTE <> '033467' AND D2_SERIE <> 'R' AND D2_ESPECIE ='NF' AND SD2.D_E_L_E_T_!='*' " + CRLF
	cQuery += " 			GROUP BY D2_COD,SUBSTR(D2_EMISSAO,1,6))	FT3 ON B1_COD=FT3.CODIGO " + CRLF

	cQuery += " LEFT JOIN (	SELECT D2_COD CODIGO,SUM(D2_QUANT) QUANT " + CRLF
	cQuery += " 			FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 			INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL='"+cFilAnt+"' AND F4_CODIGO=D2_TES AND F4_ESTOQUE='S' AND F4_DUPLIC ='S' AND SF4.D_E_L_E_T_!='*' " + CRLF 
	cQuery += " 			WHERE D2_FILIAL='"+cFilAnt+"'  AND SUBSTR(D2_EMISSAO,1,6) = TO_CHAR(ADD_MONTHS(SYSDATE, -2),'YYYYMM')   AND D2_CLIENTE <> '033467' AND D2_SERIE <> 'R' AND D2_ESPECIE ='NF' AND SD2.D_E_L_E_T_!='*' " + CRLF
	cQuery += " 			GROUP BY D2_COD,SUBSTR(D2_EMISSAO,1,6))	FT2 ON B1_COD=FT2.CODIGO " + CRLF

	cQuery += " LEFT JOIN (	SELECT D2_COD CODIGO,SUM(D2_QUANT) QUANT " + CRLF
	cQuery += " 			FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 			INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL='"+cFilAnt+"' AND F4_CODIGO=D2_TES AND F4_ESTOQUE='S' AND F4_DUPLIC ='S' AND SF4.D_E_L_E_T_!='*' " + CRLF 
	cQuery += " 			WHERE D2_FILIAL='"+cFilAnt+"'  AND SUBSTR(D2_EMISSAO,1,6) = TO_CHAR(ADD_MONTHS(SYSDATE, -1),'YYYYMM')   AND D2_CLIENTE <> '033467' AND D2_SERIE <> 'R' AND D2_ESPECIE ='NF' AND SD2.D_E_L_E_T_!='*' " + CRLF
	cQuery += " 			GROUP BY D2_COD,SUBSTR(D2_EMISSAO,1,6))	FT1 ON B1_COD=FT1.CODIGO " + CRLF

	cQuery += " LEFT JOIN (	SELECT D2_COD CODIGO,SUM(D2_QUANT) QUANT " + CRLF
	cQuery += " 			FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 			INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL='"+cFilAnt+"' AND F4_CODIGO=D2_TES AND F4_ESTOQUE='S' AND F4_DUPLIC ='S' AND SF4.D_E_L_E_T_!='*' " + CRLF 
	cQuery += " 			WHERE D2_FILIAL='"+cFilAnt+"'  AND SUBSTR(D2_EMISSAO,1,6) = TO_CHAR(SYSDATE,'YYYYMM')   AND D2_CLIENTE <> '033467' AND D2_SERIE <> 'R' AND D2_ESPECIE ='NF' AND SD2.D_E_L_E_T_!='*' " + CRLF
	cQuery += " 			GROUP BY D2_COD,SUBSTR(D2_EMISSAO,1,6))	FT0 ON B1_COD=FT0.CODIGO " + CRLF

	cQuery += " LEFT JOIN (	SELECT DC_PRODUTO,SUM(DC_QUANT) DCQTD  " + CRLF
	cQuery += " 			FROM " + RetSqlName("SDC") + " SDC  " + CRLF
	cQuery += " 			WHERE DC_FILIAL='"+xFilial('SDC')+"' AND DC_LOCAL='01' AND DC_QUANT>0 AND SDC.D_E_L_E_T_!='*' " + CRLF 
	cQuery += " 			GROUP BY DC_PRODUTO) SDC ON B1_COD=SDC.DC_PRODUTO " + CRLF

	cQuery += " WHERE B1_FILIAL='"+xFilial('SB1')+"' " + CRLF

	cQuery += " AND B1_COD		BETWEEN	'"+mv_par01+"' AND '"+mv_par02+"' 
	cQuery += " AND B1_GRUPO	BETWEEN	'"+mv_par03+"' AND '"+mv_par04+"' 

//	If !(MV_PAR05 = 4)
	//	cQuery += " AND B1_TIPO='PA' " + CRLF
	//Endif

	//cQuery += " AND B1_TIPO IN ('PA','PI')

	_aTipos := {}

	If !Empty(MV_PAR07)
		
		MV_PAR07 := AllTrim(MV_PAR07)
		_aTipos := StrTokArr(MV_PAR07,",")
		
		cQuery += " AND B1_TIPO IN (

		For _nX:=1 To Len(_aTipos)
			cQuery += "'"+_aTipos[_nX]+"'"
			If !(_nX==Len(_aTipos))
				cQuery += ","
			EndIf

		Next
		
		cQuery += ")

	EndIf

	cQuery += " AND SB1.D_E_L_E_T_!='*' " + CRLF

	cQuery += " ORDER BY B1_COD " + CRLF

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	TcSetField(cAliasLif,"ESTSEG"	,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"QTD6"		,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"QTD5"		,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"QTD4"		,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"QTD3"		,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"QTD2"		,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"QTD1"		,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"QTD0"		,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"MEDIA"	,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])
	TcSetField(cAliasLif,"CUSTO"	,"N",TamSx3("B2_CM1"	)	[1],TamSx3("B2_CM1"		)[2])
	TcSetField(cAliasLif,"SALDO"	,"N",TamSx3("B2_QATU"	)	[1],TamSx3("B2_QATU"	)[2])

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPutSx1   บAutor  ณJefferson Carlos   บ Data ณ  28/06/18   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Previsao de Vendas PA                          บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                       บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme       == Nil, " ", cPyme       )
	cF3      := Iif( cF3         == NIl, " ", cF3         )
	cGrpSxg  := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01      == Nil, "" , cCnt01      )
	cHelp    := Iif( cHelp       == Nil, "" , cHelp       )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt := If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa  := If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa )
		cPerEng  := If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng )

		Reclock( "SX1", .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
		Replace X1_VAR01   With cVar01
		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA )
		lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG )

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Inverte   บAutor  ณJefferson Carlos   บ Data ณ  28/06/18   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Previsao de Vendas PA                          บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                       บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Inverte(cAnoMes)

Return(Substr(cAnoMes,5,2)+"/"+Substr(cAnoMes,1,4))
