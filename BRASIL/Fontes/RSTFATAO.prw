#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATAN     บAutor  ณGiovani Zago    บ Data ณ  08/08/16     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Lista Avan็ada Comercial                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSTFATAO()
	
	Local   oReport
	Private cPerg 			:= "RFATAO"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	
	PutSx1(cPerg, "01", "Produto de:" 	,"Produto de:" 	 ,"Produto de:" 		 	,"mv_ch1","C",12,0,0,"G","",'SB1' ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Produto Ate:"	,"Produto Ate:"  ,"Produto Ate:"			,"mv_ch2","C",12,0,0,"G","",'SB1' ,"","","mv_par02","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "03", "Unicon de:" 	,"Produto de:" 	 ,"Produto de:" 			,"mv_ch3","C",06,0,0,"G","",' ' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "04", "Unicon Ate:"	,"Produto Ate:"  ,"Produto Ate:"			,"mv_ch4","C",06,0,0,"G","",' ' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	
	
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
	
	oReport := TReport():New(cPergTit,"RELATำRIO Lista Avan็ada",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio Lista Avan็ada")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Financeiro Serasa",{"SC6"})
	
	
	TRCell():New(oSection,"01",,"PRODUTO"	,,14,.F.,)
	TRCell():New(oSection,"02",,"OS"		,,06,.F.,)
	TRCell():New(oSection,"03",,"PEDIDO" 	,,09,.F.,)
	TRCell():New(oSection,"04",,"EMPENHADO"	,"@E 999,999.99",3)
	TRCell():New(oSection,"05",,"SEPARADO"		,"@E 999,999.99",3)
	TRCell():New(oSection,"06",,"SEM SEPARAR"		,"@E 999,999.99",3)
	TRCell():New(oSection,"07",,"TOTAL ENDERECO"		,"@E 999,999.99",3)
	TRCell():New(oSection,"08",,"ENDERECO"		,,14,.F.,)
	TRCell():New(oSection,"09",,"STATUS"		,,14,.F.,)
	
	
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")
	
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
	
	
	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
	
	
	oReport:SetTitle("Lista Avan็ada")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			If (cAliasLif)->PRODUTO = 'ZZZZZZTOTAL'
				aDados1[01]	:=  'TOTAL ENDERECO'
			ElseIf (cAliasLif)->PRODUTO = 'ZZZZZZZO'
				aDados1[01]	:=  'TOTAL ANALITICO'
			Else
				aDados1[01]	:=  (cAliasLif)->PRODUTO
			EndIf
			aDados1[02]	:=  (cAliasLif)->OS
			aDados1[03]	:=  (cAliasLif)->PEDIDO
			aDados1[04]	:=  (cAliasLif)->EMPENHADO
			aDados1[05]	:=   (cAliasLif)->SEPARADO
			aDados1[06]	:=  (cAliasLif)->SEM_SEPARAR
			aDados1[07]	:= (cAliasLif)->TOTAL_ENDERECO
			aDados1[08]	:= (cAliasLif)->ENDERECO
			aDados1[09]	:= (cAliasLif)->STATUS
			
			
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
	
	
	
	
	
	cQuery := " 	SELECT
	cQuery += " CB8_PROD
	cQuery += ' "PRODUTO",
	cQuery += " CB8_ORDSEP
	cQuery += ' "OS",
	cQuery += " CB8_PEDIDO
	cQuery += ' "PEDIDO",
	cQuery += " CB8_QTDORI
	cQuery += ' "EMPENHADO",
	cQuery += " CB8_QTDORI-CB8_SALDOS
	cQuery += ' "SEPARADO",
	cQuery += " CB8_SALDOS
	cQuery += ' "SEM_SEPARAR",
	cQuery += " 0
	cQuery += ' "TOTAL_ENDERECO",
	cQuery += " CB8_LCALIZ
	cQuery += ' "ENDERECO",
	cQuery += " CASE WHEN CB7.CB7_STATUS = '0' THEN '0-Inicio' ELSE
	cQuery += "  CASE WHEN CB7.CB7_STATUS = '1' THEN '1-Separando' ELSE
	cQuery += "   CASE WHEN CB7.CB7_STATUS = '2' THEN '2-Sep.Final' ELSE
	cQuery += "   CASE WHEN CB7.CB7_STATUS = '3' THEN '3-Embalando' ELSE
	cQuery += "   CASE WHEN CB7.CB7_STATUS = '4' THEN '4-Emb.Final' ELSE
	cQuery += "   CASE WHEN CB7.CB7_STATUS = '8' THEN '8-Embarcado' ELSE
	cQuery += "   CASE WHEN CB7.CB7_STATUS = '9' THEN '9-Embarque Finalizado' ELSE 'SEM NUMERACAO'
	cQuery += "   END END END END END END END
	cQuery += '   "STATUS"
	
	
	cQuery += " FROM CB8010 CB8
	
	cQuery += " INNER JOIN (SELECT * FROM CB7010 )CB7
	cQuery += "  ON CB7.D_E_L_E_T_ = ' '
	cQuery += "  AND CB7_PEDIDO = CB8_PEDIDO
	cQuery += "   AND CB7_ORDSEP  = CB8_ORDSEP
	cQuery += "   AND CB7.CB7_FILIAL = '02'
	
	cQuery += " WHERE CB8.D_E_L_E_T_ = ' '
	cQuery += " AND CB8.CB8_FILIAL = '02'
	cQuery += " AND CB8.CB8_PROD  BETWEEN '"+  MV_PAR01 +"' AND '"+  MV_PAR02 +"'
	cQuery += " AND CB7.CB7_STATUS <> '9' AND NOT EXISTS(SELECT * FROM SC9010 SC9 WHERE SC9.D_E_L_E_T_ = ' ' AND C9_PEDIDO = CB8_PEDIDO AND CB8_FILIAL = C9_FILIAL AND C9_ORDSEP = CB8_ORDSEP AND C9_PRODUTO = CB8_PROD AND C9_NFISCAL <> ' ')
	
	cQuery += " UNION
	
	cQuery += " SELECT
	cQuery += " 'ZZZZZZTOTAL'
	cQuery += ' "PRODUTO",
	cQuery += " ' '
	cQuery += ' "OS",
	cQuery += " ' '
	cQuery += ' "PEDIDO",
	cQuery += " SUM(CB8_QTDORI)
	cQuery += ' "EMPENHADO",
	cQuery += " SUM(CB8_QTDORI-CB8_SALDOS)
	cQuery += ' "SEPARADO",
	cQuery += " SUM(CB8_SALDOS)
	cQuery += ' "SEM_SEPARAR",
	cQuery += " 0
	cQuery += ' "TOTAL_ENDERECO",
	cQuery += " ' '
	cQuery += ' "ENDERECO",
	cQuery += " ' '
	cQuery += '  "STATUS"
	cQuery += " FROM CB8010 CB8
	cQuery += " INNER JOIN (SELECT * FROM CB7010 )CB7
	cQuery += "  ON CB7.D_E_L_E_T_ = ' '
	cQuery += "  AND CB7_PEDIDO = CB8_PEDIDO
	cQuery += "   AND CB7_ORDSEP  = CB8_ORDSEP
	cQuery += "   AND CB7.CB7_FILIAL = '02'
	cQuery += " WHERE CB8.D_E_L_E_T_ = ' '
	cQuery += " AND CB8.CB8_FILIAL = '02'
	cQuery += " AND CB8.CB8_PROD BETWEEN '"+  MV_PAR01 +"' AND '"+  MV_PAR02 +"'
	cQuery += " AND CB7.CB7_STATUS <> '9' AND NOT EXISTS(SELECT * FROM SC9010 SC9 WHERE SC9.D_E_L_E_T_ = ' ' AND C9_PEDIDO = CB8_PEDIDO AND CB8_FILIAL = C9_FILIAL AND C9_ORDSEP = CB8_ORDSEP AND C9_PRODUTO = CB8_PROD AND C9_NFISCAL <> ' ')
	
	cQuery += " GROUP BY  CB8_PROD
	
	
	cQuery += " UNION
	
	
	cQuery += " SELECT
	cQuery += " 	'ZZZZZZZO'
	cQuery += ' 	"PRODUTO"
	cQuery += " 	, ' '
	cQuery += ' 	"OS"
	cQuery += " 	, ' '
	cQuery += ' 	"PEDIDO"
	cQuery += " 	,
	cQuery += " (SELECT
	cQuery += " 	SUM(CB8_QTDORI)
	cQuery += " FROM
	cQuery += " 	CB8010 CB8
	cQuery += " 		INNER JOIN (SELECT
	cQuery += " 						*
	cQuery += " 					FROM
	cQuery += " 						CB7010
	cQuery += " 		)
	cQuery += " 		CB7
	cQuery += " 		ON CB7.D_E_L_E_T_ = ' '
	cQuery += " 		AND CB7_PEDIDO = CB8_PEDIDO
	cQuery += " 		AND CB7_ORDSEP = CB8_ORDSEP
	cQuery += " 		AND CB7.CB7_FILIAL = '02'
	cQuery += " WHERE
	cQuery += " 	CB8.D_E_L_E_T_ = ' '
	cQuery += " 	AND CB8.CB8_FILIAL = '02'
	cQuery += " 	AND CB8.CB8_PROD = BF_PRODUTO AND CB8_LCALIZ = BF_LOCALIZ
	cQuery += " 	AND CB7.CB7_STATUS <> '9' AND NOT EXISTS(SELECT * FROM SC9010 SC9 WHERE SC9.D_E_L_E_T_ = ' ' AND C9_PEDIDO = CB8_PEDIDO AND CB8_FILIAL = C9_FILIAL AND C9_ORDSEP = CB8_ORDSEP AND C9_PRODUTO = CB8_PROD AND C9_NFISCAL <> ' ')
	
	cQuery += " GROUP BY
	cQuery += " 	CB8_PROD
	cQuery += " 	,CB8_LCALIZ)
	cQuery += ' 	"EMPENHADO"
	cQuery += " 	,
	cQuery += " (SELECT
	cQuery += " 	SUM(CB8_QTDORI-CB8_SALDOS)
	cQuery += " FROM
	cQuery += " 	CB8010 CB8
	cQuery += " 		INNER JOIN (SELECT
	cQuery += " 						*
	cQuery += " 					FROM
	cQuery += " 						CB7010
	cQuery += " 		)
	cQuery += " 		CB7
	cQuery += " 		ON CB7.D_E_L_E_T_ = ' '
	cQuery += " 		AND CB7_PEDIDO = CB8_PEDIDO
	cQuery += " 		AND CB7_ORDSEP = CB8_ORDSEP
	cQuery += " 		AND CB7.CB7_FILIAL = '02'
	cQuery += " WHERE
	cQuery += " 	CB8.D_E_L_E_T_ = ' '
	cQuery += " 	AND CB8.CB8_FILIAL = '02'
	cQuery += " 	AND CB8.CB8_PROD = BF_PRODUTO AND CB8_LCALIZ = BF_LOCALIZ
	cQuery += " 	AND CB7.CB7_STATUS <> '9' AND NOT EXISTS(SELECT * FROM SC9010 SC9 WHERE SC9.D_E_L_E_T_ = ' ' AND C9_PEDIDO = CB8_PEDIDO AND CB8_FILIAL = C9_FILIAL AND C9_ORDSEP = CB8_ORDSEP AND C9_PRODUTO = CB8_PROD AND C9_NFISCAL <> ' ')
	
	cQuery += " GROUP BY
	cQuery += " 	CB8_PROD
	cQuery += " 	,CB8_LCALIZ)
	cQuery += ' 	 "SEPARADO"
	cQuery += " 	,
	cQuery += " (SELECT
	cQuery += " 	SUM(CB8_SALDOS)
	cQuery += " FROM
	cQuery += " 	CB8010 CB8
	cQuery += " 		INNER JOIN (SELECT
	cQuery += " 						*
	cQuery += " 					FROM
	cQuery += " 						CB7010
	cQuery += " 		)
	cQuery += " 		CB7
	cQuery += " 		ON CB7.D_E_L_E_T_ = ' '
	cQuery += " 		AND CB7_PEDIDO = CB8_PEDIDO
	cQuery += " 		AND CB7_ORDSEP = CB8_ORDSEP
	cQuery += " 		AND CB7.CB7_FILIAL = '02'
	cQuery += " WHERE
	cQuery += " 	CB8.D_E_L_E_T_ = ' '
	cQuery += " 	AND CB8.CB8_FILIAL = '02'
	cQuery += " 	AND CB8.CB8_PROD = BF_PRODUTO AND CB8_LCALIZ = BF_LOCALIZ
	cQuery += " 	AND CB7.CB7_STATUS <> '9' AND NOT EXISTS(SELECT * FROM SC9010 SC9 WHERE SC9.D_E_L_E_T_ = ' ' AND C9_PEDIDO = CB8_PEDIDO AND CB8_FILIAL = C9_FILIAL AND C9_ORDSEP = CB8_ORDSEP AND C9_PRODUTO = CB8_PROD AND C9_NFISCAL <> ' ')
	
	cQuery += " GROUP BY
	cQuery += " 	CB8_PROD
	cQuery += ' 	,CB8_LCALIZ) "SEM_SEPARAR"
	cQuery += ' 	, BF_QUANT "TOTAL_ENDERECO"
	cQuery += '	, BF_LOCALIZ "ENDERECO"
	cQuery += " 	, ' '
	cQuery += ' 	"STATUS"
	cQuery += " FROM
	cQuery += " 	SBF010 SBF
	cQuery += " WHERE
	cQuery += " 	SBF.D_E_L_E_T_ = ' '
	cQuery += " 	AND BF_PRODUTO BETWEEN '"+  MV_PAR01 +"' AND '"+  MV_PAR02 +"'
	cQuery += " 	AND BF_FILIAL = '02'
	cQuery += " 	AND BF_LOCAL = '03'
	
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()


