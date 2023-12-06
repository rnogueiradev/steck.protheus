#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STESTR03	ºAutor  ³Renato Nogueira     º Data ³  19/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para os produtos obsoletos	          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STESTR03()

Local oReport        

PutSx1("STESTR03", "01","Codigo de?" ,"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1("STESTR03", "02","Codigo ate?","","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")                   
PutSx1("STESTR03", "03","Data de?"  ,"","","mv_ch3","D",8,0,0,"G","",		,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1("STESTR03", "04","Data ate?" ,"","","mv_ch4","D",8,0,0,"G","",		,"","","mv_par04","","","","","","","","","","","","","","","","")                   
PutSx1("STESTR03", "05","Somente sem movimentação?(S/N)"   ,"","","mv_ch5","C",1,0,0,"G","",""  ,"","","mv_par05","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STESTR03","RELATÓRIO DE PRODUTOS OBSOLETOS","STESTR03",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de produtos obsoletos.")

Pergunte("STESTR03",.F.)

oSection := TRSection():New(oReport,"CADASTRO DOS PRODUTOS",{"SB1"})

TRCell():New(oSection,"CODIGO"    ,"SB1","CODIGO"        			,"@!",15)
TRCell():New(oSection,"QTDE"      ,"SD3","QUANTIDADE"    	    	,PesqPict("SD3","D3_QUANT",12),)
TRCell():New(oSection,"SAIDAS"    ,"SD3","QUANTIDADE DE SAÍDAS"     ,PesqPict("SD3","D3_QUANT",12),)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SB1")
oSection:Setnofilter("SD3")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local aDados[3]
Local _aDados	:= {}

oSection:Cell("CODIGO")  :SetBlock( { || aDados[1] } )
oSection:Cell("QTDE")    :SetBlock( { || aDados[2] } )
oSection:Cell("SAIDAS")  :SetBlock( { || aDados[3] } )

oReport:SetTitle("Lista de produtos por endereço")// Titulo do relatório

cQuery := " SELECT B1_COD CODIGO, SUM(D3_QUANT) SAIDAS, COUNT(D3_COD) QTDE "
cQuery += " FROM " +RetSqlName("SB1")+ " B1 "
cQuery += " LEFT JOIN " +RetSqlName("SD3")+ " D3 " 
cQuery += " ON D3_COD=B1_COD AND D3_TM >= '500' AND D3.D_E_L_E_T_=' ' AND D3_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' "
cQuery += " WHERE B1.D_E_L_E_T_=' '  "
cQuery += " AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'  "

If mv_par05=="S"

cQuery += " HAVING COUNT(D3_COD)=0 "

EndIf 

cQuery += " GROUP BY B1_COD "
cQuery += " ORDER BY B1_COD "

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

	aDados[1]	:=	(cAlias)->CODIGO
	aDados[2]	:=	(cAlias)->SAIDAS
	aDados[3]	:=	(cAlias)->QTDE

	oSection:PrintLine()
	aFill(aDados,nil)

	(cAlias)->(DbSkip())
	
EndDo                    

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport