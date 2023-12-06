#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT94     บAutor  ณRenato Nogueira บ Data ณ  10/09/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de custo por nota fiscal		                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT94()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT94"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Da Emissao:"	,"Da Emissao:"	 ,"Da Emissao:"			,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    ,""	 	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "At้ a Emissao:","At้ a Emissao:","At้ a Emissao:" 		,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    ,""	 	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")

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

	oReport := TReport():New(cPergTit,"RELATำRIO CUSTO POR NF",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio dos custos por NF")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SD2",{"SD2"})

	TRCell():New(oSection,"1_FILIAL"		,,"FILIAL"				,,02,.F.,)
	TRCell():New(oSection,"2_EMISSAO"		,,"EMISSAO"				,,10,.F.,)
	TRCell():New(oSection,"3_DOC"			,,"DOCUMENTO"			,,09,.F.,)
	TRCell():New(oSection,"4_SERIE"			,,"SERIE"				,,03,.F.,)
	TRCell():New(oSection,"5_CLIENTE"		,,"CLIENTE"				,,06,.F.,)
	TRCell():New(oSection,"6_LOJA"			,,"LOJA"				,,02,.F.,)
	TRCell():New(oSection,"7_CHAVE"			,,"CHAVE NFE"			,,44,.F.,)
	TRCell():New(oSection,"8_ITEM"			,,"ITEM"				,,02,.F.,)
	TRCell():New(oSection,"9_COD"			,,"CODIGO"				,,15,.F.,)
	TRCell():New(oSection,"10_CF"			,,"CFOP"				,,04,.F.,)
	TRCell():New(oSection,"11_QTD"			,,"QTDE"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"12_PRCVEN"		,,"PREวO"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"13_TOTAL"		,,"TOTAL"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"14_COMP"			,,"COMPONENTE"			,,15,.F.,)
	TRCell():New(oSection,"15_DESC"			,,"DESCRIวรO"			,,50,.F.,)
	TRCell():New(oSection,"16_ORIG"			,,"ORIGEM"				,,01,.F.,)
	TRCell():New(oSection,"17_QTD"			,,"QTD"					,"@E 999,999.99999",14)
	TRCell():New(oSection,"18_RECNO"		,,"RECNO"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"19_FILIAL"		,,"FILIAL"				,,02,.F.,)
	TRCell():New(oSection,"20_NFCOMP"		,,"NF COMP"				,,09,.F.,)
	TRCell():New(oSection,"21_SERIE"		,,"SERIE COMP"			,,03,.F.,)
	TRCell():New(oSection,"22_CUSTO"		,,"CUSTO"				,"@E 999,999.99999",14)

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

oSection1:Cell('1_FILIAL')  	:SetBlock( { || aDados1[01] } )
oSection1:Cell('2_EMISSAO')  	:SetBlock( { || aDados1[02] } )
oSection1:Cell('3_DOC')  		:SetBlock( { || aDados1[03] } )
oSection1:Cell('4_SERIE') 		:SetBlock( { || aDados1[04] } )
oSection1:Cell('5_CLIENTE')  	:SetBlock( { || aDados1[05] } )
oSection1:Cell('6_LOJA')  		:SetBlock( { || aDados1[06] } )
oSection1:Cell('7_CHAVE')  		:SetBlock( { || aDados1[07] } )
oSection1:Cell('8_ITEM') 		:SetBlock( { || aDados1[08] } )
oSection1:Cell('9_COD')  		:SetBlock( { || aDados1[09] } )
oSection1:Cell('10_CF') 		:SetBlock( { || aDados1[10] } )
oSection1:Cell('11_QTD') 		:SetBlock( { || aDados1[11] } )
oSection1:Cell('12_PRCVEN') 	:SetBlock( { || aDados1[12] } )
oSection1:Cell('13_TOTAL') 		:SetBlock( { || aDados1[13] } )
oSection1:Cell('14_COMP') 		:SetBlock( { || aDados1[14] } )
oSection1:Cell('15_DESC') 		:SetBlock( { || aDados1[15] } )
oSection1:Cell('16_ORIG') 		:SetBlock( { || aDados1[16] } )
oSection1:Cell('17_QTD') 		:SetBlock( { || aDados1[17] } )
oSection1:Cell('18_RECNO') 		:SetBlock( { || aDados1[18] } )
oSection1:Cell('19_FILIAL') 	:SetBlock( { || aDados1[19] } )
oSection1:Cell('20_NFCOMP') 	:SetBlock( { || aDados1[20] } )
oSection1:Cell('21_SERIE') 		:SetBlock( { || aDados1[21] } )
oSection1:Cell('22_CUSTO') 		:SetBlock( { || aDados1[22] } )

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
		
			aDados1[01]	:=  (cAliasLif)->D2_FILIAL
			aDados1[02]	:=  DTOC(STOD((cAliasLif)->D2_EMISSAO))
			aDados1[03]	:=  (cAliasLif)->D2_DOC
			aDados1[04]	:=  (cAliasLif)->D2_SERIE
			aDados1[05]	:=  (cAliasLif)->D2_CLIENTE
			aDados1[06]	:=	(cAliasLif)->D2_LOJA
			aDados1[07]	:= 	(cAliasLif)->F2_CHVNFE
			aDados1[08]	:= 	(cAliasLif)->D2_ITEM
			aDados1[09]	:=	(cAliasLif)->D2_COD
			aDados1[10]	:=	(cAliasLif)->D2_CF
			aDados1[11]	:=	(cAliasLif)->D2_QUANT
			aDados1[12]	:=	(cAliasLif)->D2_PRCVEN
			aDados1[13]	:=	(cAliasLif)->D2_TOTAL
			aDados1[14]	:=	(cAliasLif)->COD_COMP
			aDados1[15]	:=	(cAliasLif)->B1_DESC
			aDados1[16]	:=	(cAliasLif)->B1_ORIGEM
			aDados1[17]	:=	(cAliasLif)->QTD
			aDados1[18]	:=	(cAliasLif)->RECIMP
			aDados1[19]	:=	(cAliasLif)->COMP_FILIAL
			aDados1[20]	:=	(cAliasLif)->COMP_NF
			aDados1[21]	:=	(cAliasLif)->COMP_SERIE
			aDados1[22]	:=	(cAliasLif)->COMP_CUSTO

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

		cQuery := " SELECT D2_FILIAL, D2_EMISSAO, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, F2_CHVNFE, D2_ITEM, D2_COD, D2_CF, D2_QUANT, D2_PRCVEN, D2_TOTAL, " 
		cQuery += " NVL(COD_COMP,' ')COD_COMP, NVL(B1_DESC,' ')B1_DESC, NVL(B1_ORIGEM,' ')B1_ORIGEM, NVL(QTD,0)QTD, NVL(RECIMP,0)RECIMP,  "
		cQuery += " CASE WHEN NVL(RECIMP,0)=0 THEN ' ' ELSE (SELECT MAX(D1_FILIAL) FROM "+RetSqlName("SD1")+" SD1 WHERE SD1.R_E_C_N_O_ = RECIMP) END AS COMP_FILIAL,  "
		cQuery += " CASE WHEN NVL(RECIMP,0)=0 THEN ' ' ELSE (SELECT MAX(D1_DOC) FROM "+RetSqlName("SD1")+" SD1 WHERE SD1.R_E_C_N_O_ = RECIMP) END AS COMP_NF,  "
		cQuery += " CASE WHEN NVL(RECIMP,0)=0 THEN ' ' ELSE (SELECT MAX(D1_SERIE) FROM "+RetSqlName("SD1")+" SD1 WHERE SD1.R_E_C_N_O_ = RECIMP) END AS COMP_SERIE,  "
		cQuery += " CASE WHEN NVL(RECIMP,0)=0 THEN 0 ELSE (SELECT MAX(ROUND(D1_CUSTO/D1_QUANT,6)) FROM "+RetSqlName("SD1")+" SD1 WHERE SD1.R_E_C_N_O_ = RECIMP) END AS COMP_CUSTO  "
		cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
		cQuery += " INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_EMISSAO = D2_EMISSAO  "
		cQuery += " AND SF2.D_E_L_E_T_ = ' ' LEFT JOIN ( WITH ESTRUT(CODIGO,COD_PAI,COD_COMP,QTD,NIVEL) AS ( SELECT G1_COD PAI,G1_COD,G1_COMP,G1_QUANT,1 AS NIVEL FROM "+RetSqlName("SG1")+" SG1 WHERE SG1.G1_FILIAL = '01'  "
		cQuery += " AND SG1.D_E_L_E_T_ = ' ' UNION ALL SELECT CODIGO,G1_COD,G1_COMP,QTD*G1_QUANT,NIVEL + 1 FROM "+RetSqlName("SG1")+" SG1 INNER JOIN ESTRUT EST ON G1_COD = COD_COMP  "
		cQuery += " WHERE SG1.G1_FILIAL = '01' AND SG1.D_E_L_E_T_ = ' ') SELECT CODIGO,COD_COMP,B1_DESC,B1_ORIGEM,B1_UM,SUM(QTD)QTD, NVL((SELECT MAX(R_E_C_N_O_)DX_REC  "
		cQuery += " FROM "+RetSqlName("SD1")+" SD1 INNER JOIN (SELECT D1_COD DX_COD,MAX(D1_DTDIGIT)DX_DAT FROM "+RetSqlName("SD1")+" SD1 WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(D1_CF,1,1)='3' AND D1_QUANT>0  "
		cQuery += " AND D1_TIPO='N' AND D1_DTDIGIT < '"+DTOS(MV_PAR01)+"' AND SD1.D_E_L_E_T_ = ' ' GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_DAT=SD1.D1_DTDIGIT  "
		cQuery += " WHERE SD1.D1_FILIAL <> ' ' AND SD1.D1_COD=COD_COMP AND SUBSTR(SD1.D1_CF,1,1)='3' AND D1_DTDIGIT < '"+DTOS(MV_PAR01)+"' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' '  "
		cQuery += " GROUP BY SD1.D1_COD),0)RECIMP FROM ESTRUT INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = ' ' AND SB1.B1_COD = COD_COMP  "
		cQuery += " LEFT JOIN (SELECT G1_COD COD FROM "+RetSqlName("SG1")+" SG1_A WHERE SG1_A.D_E_L_E_T_ = ' ' AND SG1_A.G1_FILIAL = '01' GROUP BY G1_COD) SG1_A ON COD = COD_COMP "
		cQuery += " WHERE ESTRUT.CODIGO IN (SELECT D2_COD FROM "+RetSqlName("SD2")+" SD2 WHERE D2_FILIAL <> ' ' AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D2_CF = '7101'  "
		cQuery += " AND SD2.D_E_L_E_T_ = ' ') AND COD IS NULL GROUP BY CODIGO,COD_COMP,B1_DESC,B1_ORIGEM,B1_UM ORDER BY COD_COMP )SG1 ON D2_COD = CODIGO AND RECIMP <> 0  "
		cQuery += " WHERE D2_FILIAL <> ' ' AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D2_CF = '7101' AND SD2.D_E_L_E_T_ = ' ' ORDER BY 1,2,3,4,8  "
		

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()