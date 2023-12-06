#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STRELCODE ºAutor  ³Renato Nogueira    º Data ³  21/06/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este relatório tem por objetivo estabelecer o consumo médio º±±
±±º          ³dos códigos E                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STRELCODE()

Local oReport

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STRELCODE","RELATÓRIO DE CONSUMO CÓDIGOS E",,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de consumo médio dos últimos 3 meses dos códigos E.")

oSection := TRSection():New(oReport,"RELAÇÃO DE CONSUMOS",{"SD3"})

TRCell():New(oSection,"FILIAL" ,"SD3","FILIAL","@!",02)
TRCell():New(oSection,"CODIGO" ,"SD3","CODIGO","@!",15)
TRCell():New(oSection,"DESC"   ,"SD3","DESCRICAO","@!",30)
TRCell():New(oSection,"CONSUMO","SD3","CONSUMO MÉDIO","@E",2)
TRCell():New(oSection,"SALDO","SD3","SALDO ATUAL","@E",5)
TRCell():New(oSection,"QUANTAB","SD3","QUANTIDADE COMPRADA EM ABERTO","@E",2)
TRCell():New(oSection,"QUANT"  ,"SD3","QUANTIDADE DEFINIDA","@E",2)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SD3")

Return oReport

Static Function ReportPrint(oReport)

Local oSection		:= oReport:Section(1)
Local nX			:= 0
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP"
Local aDados[7]
Local dData3
Local cQuery1		:= 0
Local cAlias1		:= "QRYTEMP1"

oSection:Cell("CODIGO"):SetBlock( { || aDados[1] } )
oSection:Cell("DESC"):SetBlock( { || aDados[2] } )
oSection:Cell("CONSUMO"):SetBlock( { || aDados[3] } )
oSection:Cell("SALDO"):SetBlock( { || aDados[4] } )
oSection:Cell("QUANTAB"):SetBlock( { || aDados[5] } )
oSection:Cell("QUANT"):SetBlock( { || aDados[6] } )
oSection:Cell("FILIAL"):SetBlock( { || aDados[7] } )

oReport:SetTitle("Consumo médio")// Titulo do relatório

dData3	:= DaySub(DDATABASE,90)
/* Query antiga
cQuery := " SELECT D3_FILIAL, D3_COD, CEIL(SUM(D3_QUANT)/3) CONSUMO "
cQuery += " FROM " +RetSqlName("SD3") "
cQuery += " WHERE D_E_L_E_T_=' ' AND D3_COD LIKE 'E%' AND D3_TM='800' AND D3_FILIAL='01' AND D3_EMISSAO BETWEEN '"+DTOS(dData3)+"' AND '"+DTOS(DDATABASE)+"' "
cQuery += " GROUP BY D3_FILIAL, D3_COD " 
cQuery += " ORDER BY D3_COD "
*/
cQuery := " SELECT D3_FILIAL, D3_COD, SUM(CONSUMO) CONSUMO FROM( "
cQuery += " SELECT D3_FILIAL, D3_COD, CEIL(SUM(D3_QUANT)/3) CONSUMO "
cQuery += " FROM " +RetSqlName("SD3") "
cQuery += " WHERE D_E_L_E_T_=' ' AND D3_COD LIKE 'E%' AND D3_TM='800' AND D3_FILIAL='"+xFilial("SD3")+"' AND D3_EMISSAO BETWEEN '"+DTOS(dData3)+"' AND '"+DTOS(DDATABASE)+"' "
cQuery += " GROUP BY D3_FILIAL, D3_COD "
cQuery += " UNION "
cQuery += " SELECT '01',B1_COD,0 "
cQuery += " FROM " +RetSqlName("SB1") "
cQuery += " WHERE D_E_L_E_T_=' ' AND B1_COD LIKE 'E%' "
cQuery += " ORDER BY D3_COD)TAB_TEMP "
cQuery += " GROUP BY D3_FILIAL, D3_COD "
cQuery += " ORDER BY D3_COD "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

oReport:SetMeter(0)
aFill(aDados,nil)
oSection:Init()

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While !(cAlias)->(Eof())

	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+(cAlias)->D3_COD)

	cQuery1 := " SELECT C7_PRODUTO, SUM(C7_QUANT-C7_QUJE) SALDO "
	cQuery1 += " FROM " +RetSqlName("SC7") "
	cQuery1 += " WHERE D_E_L_E_T_=' ' AND C7_QUANT-C7_QUJE<>0 AND C7_PRODUTO LIKE 'E%' AND C7_PRODUTO = '"+(cAlias)->D3_COD+"' AND C7_FILIAL='"+xFilial("SC7")+"' "
	cQuery1 += " GROUP BY C7_PRODUTO "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
	
	dbSelectArea(cAlias1)
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	DbSeek(xFilial("SB2")+(cAlias)->D3_COD+"01")
		
	aDados[1]	:=	(cAlias)->D3_COD
	aDados[2]	:=	SB1->B1_DESC
	aDados[3]	:=	(cAlias)->CONSUMO
	aDados[4]	:=  SB2->B2_QATU
	aDados[5]	:=	(cAlias1)->SALDO
	aDados[6]	:=	0
	aDados[7]	:=	cFilAnt
	
	oSection:PrintLine()
	aFill(aDados,nil)
	
	(cAlias)->(DbSkip())
	
EndDo

oReport:SkipLine()

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

DbSelectArea(cAlias1)
(cAlias1)->(dbCloseArea())

Return oReport