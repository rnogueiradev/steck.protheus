#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT89     บAutor  ณRenato Nogueira บ Data ณ  12/08/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio indicadores suframa - Analํtico	                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT89(_cParam)
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT89"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATำRIO INDICADORES SUFRAMA",/*cPerg*/,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de indicadores")

	//Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SD2",{"SD2"})

	TRCell():New(oSection,"D2_DOC"			,,"DOCUMENTO"				,,09,.F.,)
	TRCell():New(oSection,"D2_TOTAL"		,,"TOTAL"					,"@E 99,999,999.99",14)
	TRCell():New(oSection,"D2_QUANT"		,,"QUANT"					,"@E 99,999,999.99",14)
	TRCell():New(oSection,"D2_UM"			,,"UNIDADE"					,,02,.F.,)
	TRCell():New(oSection,"QTDEKG"			,,"QTDE KG"					,"@E 99,999,999.99",14)
	TRCell():New(oSection,"QTDEUN"			,,"QTDE UN"					,"@E 99,999,999.99",14)
	TRCell():New(oSection,"D2_CF"			,,"CFOP"					,,04,.F.,)
	TRCell():New(oSection,"B1_POSIPI"		,,"NCM"						,,08,.F.,)
	TRCell():New(oSection,"B1_TIPO"			,,"TIPO"					,,02,.F.,)
	TRCell():New(oSection,"B1_DESC"			,,"DESC"					,,240,.F.,)
	TRCell():New(oSection,"B1_CLAPROD"		,,"CLAPROD"					,,01,.F.,)
	TRCell():New(oSection,"B1_COD"			,,"CODIGO"					,,15,.F.,)
	TRCell():New(oSection,"B1_ZPROJAM"		,,"PROJETO"					,,04,.F.,)
	TRCell():New(oSection,"TIPO"			,,"TIPO"					,,50,.F.,)
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SD2")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]


	oSection1:Cell("D2_DOC") 	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("D2_TOTAL")	:SetBlock( { || aDados1[02] } )
	oSection1:Cell("D2_QUANT")	:SetBlock( { || aDados1[03] } )
	oSection1:Cell("D2_UM") 	:SetBlock( { || aDados1[04] } )
	oSection1:Cell("QTDEKG") 	:SetBlock( { || aDados1[05] } )
	oSection1:Cell("QTDEUN") 	:SetBlock( { || aDados1[06] } )
	oSection1:Cell("D2_CF") 	:SetBlock( { || aDados1[07] } )
	oSection1:Cell("B1_POSIPI") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("B1_TIPO") 	:SetBlock( { || aDados1[09] } )
	oSection1:Cell("B1_DESC") 	:SetBlock( { || aDados1[10] } )
	oSection1:Cell("B1_CLAPROD"):SetBlock( { || aDados1[11] } )
	oSection1:Cell("B1_COD") 	:SetBlock( { || aDados1[12] } )
	oSection1:Cell("B1_ZPROJAM"):SetBlock( { || aDados1[13] } )
	oSection1:Cell("TIPO") 		:SetBlock( { || aDados1[14] } )
	
	oReport:SetTitle("SD2")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())
		
			aDados1[01]	:=  (cAliasLif)->D2_DOC
			aDados1[02]	:=  (cAliasLif)->D2_TOTAL+(cAliasLif)->D2_ICMSRET
			aDados1[03]	:=  (cAliasLif)->D2_QUANT
			aDados1[04]	:=  (cAliasLif)->D2_UM
			aDados1[05]	:=  (cAliasLif)->QTDEKG
			aDados1[06]	:=	(cAliasLif)->QTDEUN
			aDados1[07]	:= 	(cAliasLif)->D2_CF
			aDados1[08]	:= 	(cAliasLif)->B1_POSIPI
			aDados1[09]	:=	(cAliasLif)->B1_TIPO
			aDados1[10]	:=	(cAliasLif)->B1_DESC
			aDados1[11]	:=	(cAliasLif)->B1_CLAPROD
			aDados1[12]	:=	(cAliasLif)->B1_COD
			aDados1[13]	:=	(cAliasLif)->B1_ZPROJAM
			aDados1[14]	:=	(cAliasLif)->TIPO

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

	Local cQuery     := ' '

		cQuery := " SELECT D2_DOC, D2_TOTAL, D2_ICMSRET, D2_QUANT, D2_UM " 
		cQuery += " ,(CASE WHEN D2_UM='UN' THEN D2_QUANT*B1.B1_PESO WHEN D2_UM='KG' THEN D2_QUANT END) QTDEKG "
		cQuery += " ,(CASE WHEN D2_UM='UN' THEN D2_QUANT WHEN D2_UM='KG' THEN D2_QUANT/B1.B1_PESO END) QTDEUN "
		cQuery += " ,D2_CF, B1_POSIPI, B1_TIPO, B1_DESC, B1_CLAPROD, B1_COD, B1_ZPROJAM, 'NACIONAL' AS TIPO "
		cQuery += " FROM "+RetSqlName("SD2")+" D2 LEFT JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO=D2_TES "
		cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 ON B1.B1_COD=D2.D2_COD WHERE D2.D_E_L_E_T_=' ' AND  F4.D_E_L_E_T_=' ' "
		cQuery += " AND D2.D2_COD=B1.B1_COD AND SUBSTR(D2_EMISSAO,1,6)='"+_cParam+"' AND F4_DUPLIC='S' AND F4_ESTOQUE='S' "
		cQuery += " AND D2_EST NOT IN ('EX','AM') AND B1_ZPROJAM<>' ' "
		cQuery += " UNION ALL "
		cQuery += " SELECT D2_DOC, D2_TOTAL, D2_ICMSRET, D2_QUANT, D2_UM "
		cQuery += " ,(CASE WHEN D2_UM='UN' THEN D2_QUANT*B1.B1_PESO WHEN D2_UM='KG' THEN D2_QUANT END) QTDEKG "
		cQuery += " ,(CASE WHEN D2_UM='UN' THEN D2_QUANT WHEN D2_UM='KG' THEN D2_QUANT/B1.B1_PESO END) QTDEUN "
		cQuery += " ,D2_CF, B1_POSIPI, B1_TIPO, B1_DESC, B1_CLAPROD, B1_COD, B1_ZPROJAM, 'LOCAL'    AS TIPO "
		cQuery += " FROM "+RetSqlName("SD2")+" D2 LEFT JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO=D2_TES "
		cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 ON B1.B1_COD=D2.D2_COD WHERE D2.D_E_L_E_T_=' ' AND  F4.D_E_L_E_T_=' ' "
		cQuery += " AND D2.D2_COD=B1.B1_COD AND SUBSTR(D2_EMISSAO,1,6)='"+_cParam+"' AND F4_DUPLIC='S' AND F4_ESTOQUE='S' "
		cQuery += " AND D2_EST='AM'               AND B1_ZPROJAM<>' ' "
		cQuery += " UNION ALL "
		cQuery += " SELECT D2_DOC, D2_TOTAL, D2_ICMSRET, D2_QUANT, D2_UM "
		cQuery += " ,(CASE WHEN D2_UM='UN' THEN D2_QUANT*B1.B1_PESO WHEN D2_UM='KG' THEN D2_QUANT END) QTDEKG "
		cQuery += " ,(CASE WHEN D2_UM='UN' THEN D2_QUANT WHEN D2_UM='KG' THEN D2_QUANT/B1.B1_PESO END) QTDEUN "
		cQuery += " ,D2_CF, B1_POSIPI, B1_TIPO, B1_DESC, B1_CLAPROD, B1_COD, B1_ZPROJAM, 'EXTERIOR' AS TIPO "
		cQuery += " FROM "+RetSqlName("SD2")+" D2 LEFT JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO=D2_TES "
		cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 ON B1.B1_COD=D2.D2_COD WHERE D2.D_E_L_E_T_=' ' AND  F4.D_E_L_E_T_=' ' "
		cQuery += " AND D2.D2_COD=B1.B1_COD AND SUBSTR(D2_EMISSAO,1,6)='"+_cParam+"' AND F4_DUPLIC='S' AND F4_ESTOQUE='S' "
		cQuery += " AND D2_EST='EX'               AND B1_ZPROJAM<>' ' "
		cQuery += " ORDER BY B1_ZPROJAM, TIPO "

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()