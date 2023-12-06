#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"


/*/{Protheus.doc} RSTFATAQ
(Consulta Movimentação de Estoque)

@author jefferson.carlos
@since 31/10/2016
@version MP11

/*/

User Function RSTFATAQ()
	
	Local   oReport
	Private cPerg 		:= "RFATAQ"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif
	
	
	PutSx1(cPerg, "01", "Da Emissao:"		,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch1","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Até a Emissao:"	,"Até a Emissao:"		,"Até a Emissao:" 		,"mv_ch2","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par02","","","","","","","","","","","","","","","","")
	
	
	oReport		:= ReportDef()
	 oReport:PrintDialog()
	
Return



/*/{Protheus.doc} RSTFATAQ
(Consulta Movimentação de Estoque)

@author jefferson.carlos
@since 31/10/2016
@version MP11

/*/


Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"Consulta Mov. Estoque",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Mov. Estoque")
	
	Pergunte(cPerg,.T.)
	
	oSection := TRSection():New(oReport,"Consulta Mov. Estoque",{"MOV"})
	
	
	
	TRCell():New(oSection,"01",,"TAB"				,,08,.F.,)
	TRCell():New(oSection,"02",,"FILIAL"			,,02,.F.,)
	TRCell():New(oSection,"03",,"DAT" 				,,10,.F.,)
	TRCell():New(oSection,"04",,"DOC" 			    ,,09,.F.,)
	TRCell():New(oSection,"05",,"ITEM_TM" 			,,03,.F.,)
	TRCell():New(oSection,"06",,"TES"  			,,03,.F.,)
	TRCell():New(oSection,"07",,"CF" 			    ,,03,.F.,)
	TRCell():New(oSection,"08",,"LOC" 			    ,,02,.F.,)
	TRCell():New(oSection,"09",,"COD"				,,15,.F.,)
	TRCell():New(oSection,"10",,"QTD_ENT"			,"@E 99999999.99",12)
	TRCell():New(oSection,"11",,"QTD_SAI"			,"@E 99999999.99",12)
	TRCell():New(oSection,"12",,"CUS_ENT"			,"@E 999,999.99999",14)
	TRCell():New(oSection,"13",,"CUS_SAI"			,"@E 999,999.99999",14)
	TRCell():New(oSection,"14",,"PRD_CONTA"		,,20,.F.,)
	TRCell():New(oSection,"15",,"CTB_CONTA"		,,20,.F.,)
	TRCell():New(oSection,"16",,"VLRDEB"		,"@E 99,999,999,999,999.99",17)
	TRCell():New(oSection,"17",,"VLRCRE"		,"@E 99,999,999,999,999.99",17)
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("MOV")
	
Return oReport


/*/{Protheus.doc} RSTFATAQ
(Consulta Movimentação de Estoque)

@author jefferson.carlos
@since 31/10/2016
@version MP11

/*/



Static Function ReportPrint(oReport)
	
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
	
	
	oReport:SetTitle("MOV")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
						
			aDados1[01]	:=  (cAliasLif)->TAB
			aDados1[02]	:=  (cAliasLif)->FILIAL
			aDados1[03]	:=  DTOC(STOD((cAliasLif)->DAT))
			aDados1[04]	:=  (cAliasLif)->DOC
			aDados1[05]	:=  (cAliasLif)->ITEM_TM
			aDados1[06]	:=	(cAliasLif)->TES
			aDados1[07]	:= (cAliasLif)->CF
			aDados1[08]	:= 	(cAliasLif)->LOC
			aDados1[09]	:= (cAliasLif)->COD
			aDados1[10]	:= 	(cAliasLif)->QTD_ENT
			aDados1[11]	:= 	(cAliasLif)->QTD_SAI
			aDados1[12]	:= 	(cAliasLif)->CUS_ENT
			aDados1[13]	:= 	(cAliasLif)->CUS_SAI
			aDados1[14]	:= 	(cAliasLif)->PRD_CONTA
			aDados1[15]	:= 	(cAliasLif)->CTB_CONTA
			aDados1[16]	:= 	(cAliasLif)->VLRDEB
			aDados1[17]	:= 	(cAliasLif)->VLRCRE			
			
			
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




/*/{Protheus.doc}RSTFATAQ
Gera Consulta no Banco de Dados

@since 31/10/2016
@version MP11
/*/



Static Function StQuery(_ccod)


	Local cQuery1     := ' '
	
	cQuery1 += " SELECT * FROM (SELECT 'SD1-ENT' TAB, D1_FILIAL FILIAL, D1_DTDIGIT DAT, D1_DOC DOC, D1_ITEM ITEM_TM, D1_TES TES,D1_CF CF, D1_LOCAL LOC, D1_COD COD, D1_QUANT QTD_ENT,0 QTD_SAI, D1_CUSTO CUS_ENT, 0 CUS_SAI, B1_CONTA PRD_CONTA, NVL(CTK_DEBITO,' ') CTB_CONTA, NVL(CTK_VLR01,0) VLRDEB, 0 VLRCRE "
	cQuery1 += " FROM "+RetSqlName("SD1")+" SD1 "
	cQuery1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = ' ' AND B1_COD = D1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery1 += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON F4_FILIAL = ' ' AND F4_CODIGO = D1_TES AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' "
	cQuery1 += " LEFT JOIN "+RetSqlName("CTK")+" CTK ON CTK_FILIAL = ' ' AND CTK_DATA = D1_DTDIGIT AND CTK_RECORI = SD1.R_E_C_N_O_ AND SUBSTR(CTK_DEBITO,1,3) = '114' AND CTK_TABORI = 'SD1' AND CTK_LOTE = '8810' AND CTK_DC <> '4' AND CTK.D_E_L_E_T_ = ' ' " 
	cQuery1 += " LEFT JOIN "+RetSqlName("CT2")+" CT2 ON CT2_FILIAL = ' ' AND CT2.D_E_L_E_T_ = '' AND CT2_DATA = D1_DTDIGIT " 
	cQuery1 += " WHERE "
	cQuery1 += " D1_FILIAL <> ' ' AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND SD1.D_E_L_E_T_ = ' ' "   
	
	//cQuery1 += " GROUP BY 'SD1-ENT',D1_FILIAL,D1_DTDIGIT,D1_DOC,D1_ITEM,D1_TES,D1_CF,D1_LOCAL,D1_COD,D1_QUANT,0,D1_CUSTO,0, B1_CONTA,CTK_DEBITO,CTK_VLR01, 0   "
	
	cQuery1 += " UNION ALL "
	cQuery1 += " SELECT 'SD2-SAI' TAB, D2_FILIAL FILIAL, D2_EMISSAO DAT, D2_DOC DOC, D2_ITEM ITEM_TM, D2_TES TES,D2_CF CF, D2_LOCAL LOC, D2_COD COD, 0 QTD_ENT, D2_QUANT QTD_SAI, 0 CUS_ENT, D2_CUSTO1 CUS_SAI, B1_CONTA PRD_CONTA, NVL(CTK_CREDIT,' ') CTB_CONTA, 0 VLRDEB, NVL(CTK_VLR01,0) VLRCRE "
	cQuery1 += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = ' ' AND B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery1 += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON F4_FILIAL = ' ' AND F4_CODIGO = D2_TES AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' "
	cQuery1 += " LEFT JOIN "+RetSqlName("CTK")+" CTK ON CTK_FILIAL = ' ' AND CTK_DATA = D2_EMISSAO AND CTK_RECORI = SD2.R_E_C_N_O_ AND SUBSTR(CTK_CREDIT,1,3) = '114' AND CTK_TABORI = 'SD2' AND CTK_LOTE = '8820' AND CTK_DC <> '4' AND CTK.D_E_L_E_T_ = ' ' "   
	cQuery1 += " LEFT JOIN "+RetSqlName("CT2")+" CT2 ON CT2_FILIAL = ' ' AND CT2.R_E_C_N_O_ = CTK_RECDES  AND CT2.D_E_L_E_T_ = '' " 
	
	cQuery1 += " WHERE "
	cQuery1 += " D2_FILIAL <> ' ' AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND SD2.D_E_L_E_T_ = ' ' "      
	
	//cQuery1 += " GROUP BY 'SD2-SAI',D2_FILIAL,D2_EMISSAO,D2_DOC,D2_ITEM,D2_TES,D2_CF,D2_LOCAL,D2_COD,0,D2_QUANT,0,D2_CUSTO1,B1_CONTA,CTK_CREDIT,0,CTK_VLR01"
	
	cQuery1 += " UNION ALL " 
	
	cQuery1 += " SELECT "
	cQuery1 += " 'SD3-ENT' TAB, D3_FILIAL FILIAL, D3_EMISSAO DAT, D3_DOC DOC, D3_TM ITEM_TM, '',D3_CF CF, D3_LOCAL LOC, D3_COD COD, D3_QUANT QTD_ENT, 0 QTD_SAI, D3_CUSTO1 CUS_ENT, 0 CUS_SAI, B1_CONTA PRD_CONTA, NVL(CTK_DEBITO,' ') CTB_CONTA, NVL(CTK_VLR01,0) VLRDEB, 0 VLRCRE "
	cQuery1 += " FROM "+RetSqlName("SD3")+" SD3 "
	cQuery1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = ' ' AND B1_COD = D3_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery1 += " LEFT JOIN "+RetSqlName("CTK")+" CTK ON CTK_FILIAL = ' ' AND CTK_DATA >= '20151101' AND CTK_RECORI = SD3.R_E_C_N_O_ AND SUBSTR(CTK_DEBITO,1,3) = '114' AND CTK_TABORI = 'SD3' AND CTK_LOTE = '8840' AND CTK_DC <> '4' AND CTK.D_E_L_E_T_ = ' ' "
	cQuery1 += " WHERE "
	cQuery1 += " D3_FILIAL <> ' ' AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND D3_TM < '500' AND D3_ESTORNO <> 'S' AND SD3.D_E_L_E_T_ = ' ' "  
	//cQuery1 += " GROUP BY 'SD3-ENT',D3_FILIAL , D3_EMISSAO , D3_DOC , D3_TM , '',D3_CF , D3_LOCAL , D3_COD , D3_QUANT , 0 , D3_CUSTO1 , B1_CONTA , CTK_DEBITO , CTK_VLR01,0   "  
	
	cQuery1 += " UNION ALL "         
	
	cQuery1 += " SELECT 'SD3-SAI' TAB,D3_FILIAL FILIAL, D3_EMISSAO DAT, D3_DOC DOC, D3_TM ITEM_TM, '',D3_CF CF, D3_LOCAL LOC, D3_COD COD, 0 QTD_ENT, D3_QUANT QTD_SAI, 0 CUS_ENT, D3_CUSTO1 CUS_SAI, B1_CONTA PRD_CONTA, NVL(CTK_CREDIT,' ') CTB_CONTA, 0 VLRDEB, NVL(CTK_VLR01,0) VLRCRE "
	cQuery1 += " FROM "+RetSqlName("SD3")+" SD3 "
	cQuery1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = ' ' AND B1_COD = D3_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery1 += " LEFT JOIN "+RetSqlName("CTK")+" CTK ON CTK_FILIAL = ' ' AND CTK_DATA >= '20151101' AND CTK_RECORI = SD3.R_E_C_N_O_ AND SUBSTR(CTK_CREDIT,1,3) = '114' AND CTK_TABORI = 'SD3' AND CTK_LOTE = '8840' AND CTK_DC <> '4' AND CTK.D_E_L_E_T_ = ' ' "
	cQuery1 += " WHERE "
	cQuery1 += " D3_FILIAL <> ' ' AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND D3_TM > '500' AND D3_ESTORNO <> 'S' AND SD3.D_E_L_E_T_ = ' '
	
	//cQuery1 += " GROUP BY 'SD3-SAI',D3_FILIAL , D3_EMISSAO , D3_DOC , D3_TM , '',D3_CF , D3_LOCAL , D3_COD , 0, D3_QUANT , 0 , D3_CUSTO1 , B1_CONTA , CTK_CREDIT , 0 ,CTK_VLR01 )XXX "
	cQuery1 += " )XXX "//ADD GIOVANI ZAGO 03/11/2017 ERRO NO RELATORIO
	cQuery1 += " ORDER BY FILIAL,COD,DAT "
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()
	
	
	
	
	
