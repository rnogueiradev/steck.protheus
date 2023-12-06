#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STSLDPRD   ºAutor  ³Renato Nogueira     º Data ³  08/11/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este relatorio tem por objetivo imprimir uma lista dos      º±±
±±º          ³saldos dos códigos selecionados		                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STSLDPRD()

Local oReport

PutSx1("STSLDPRD", "01","Produto de?" ,"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1("STSLDPRD", "02","Produto ate?","","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1("STSLDPRD", "03","Tipo de?" ,"","","mv_ch3","C"	,2,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1("STSLDPRD", "04","Tipo ate?" ,"","","mv_ch4","C"	,2,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1("STSLDPRD", "05","Local de?" ,"","","mv_ch5","C"	,2,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1("STSLDPRD", "06","Local ate?" ,"","","mv_ch6","C"	,2,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")


oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STSLDPRD","RELATORIO DE SALDO DISPONIVEL","STSLDPRD",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório com os saldos dos códigos.")

Pergunte("STSLDPRD",.F.)

oSection := TRSection():New(oReport,"RELATORIO DE SALDOS POR PRODUTO",{"SB2"})

TRCell():New(oSection,"FILIAL" 	     ,"SB2","FILIAL"            ,"@!",2)
TRCell():New(oSection,"PRODUTO"      ,"SB2","PRODUTO"     		,"@!",15)
TRCell():New(oSection,"SALDO"   	 ,"SB2","SALDO DISPONÍVEL"  ,"@E 999,999.99",20)
TRCell():New(oSection,"LOCAL"   	 ,"SB2","LOCAL"  ,"@!",2)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SB2")

Return oReport

Static Function ReportPrint(oReport)

Local oSection				:= oReport:Section(1)
Local nX					:= 0
Local cQuery 				:= ""
Local cAlias 				:= "QRYTEMP"
Local aDados[4]

oSection:Cell("FILIAL"):SetBlock( { || aDados[1] } )
oSection:Cell("PRODUTO"):SetBlock( { || aDados[2] } )
oSection:Cell("SALDO"):SetBlock( { || aDados[3] } )
oSection:Cell("LOCAL"):SetBlock( { || aDados[4] } )

oReport:SetTitle("SALDO DISPONÍVEL")// Titulo do relatório

cQuery := " SELECT B2_FILIAL FILIAL, B2_COD CODIGO, B2_LOCAL LOCALL "
cQuery += " FROM " +RetSqlName("SB2")+" B2 "
cQuery += " LEFT JOIN " +RetSqlName("SB1")+" B1 "
cQuery += " ON B2_COD=B1_COD "
cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B2.D_E_L_E_T_=' ' AND B2_FILIAL='"+xFilial("SB2")+"' AND B2_LOCAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += " AND B2_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "

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
	
	_nSaldoItem	:=	u_versaldo((cAlias)->CODIGO)
	
	aDados[1]	:=	(cAlias)->FILIAL
	aDados[2]	:=	(cAlias)->CODIGO
	aDados[3]	:=	_nSaldoItem
	aDados[4]	:=	(cAlias)->LOCALL
	
	oSection:PrintLine()
	
	aFill(aDados,nil)
	
	(cAlias)->(DbSkip())
	
EndDo

oReport:SkipLine()

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport