#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STESTR01	ºAutor  ³Renato Nogueira     º Data ³  10/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para listar detalhes dos produtos       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STESTR01()

Local oReport        

PutSx1("STESTR01", "01","Tipo?"      ,"","","mv_ch1","N",1,0,1,"C","",""  ,"","","mv_par01","Bloqueados","","","","Sem Custo","","","","","","","","","","","")
PutSx1("STESTR01", "02","Local de?"  ,"","","mv_ch2","C",2,0,0,"G","","90","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1("STESTR01", "03","Local ate?" ,"","","mv_ch3","C",2,0,0,"G","","90","","","mv_par03","","","","","","","","","","","","","","","","")                   
PutSx1("STESTR01", "04","Codigo de?" ,"","","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1("STESTR01", "05","Codigo ate?","","","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05","","","","","","","","","","","","","","","","")                   

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STESTR01","RELATÓRIO DE PRODUTOS","STESTR01",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de produtos.")

Pergunte("STESTR01",.F.)

oSection := TRSection():New(oReport,"CADASTRO DOS PRODUTOS",{"SB1"})

TRCell():New(oSection,"NEWCOD"    ,"SB1","CODIGO"       ,"@!",15)
TRCell():New(oSection,"OLDCOD"    ,"SB1","CODIGO LEGADO" ,"@!",15)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SB1")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local aDados[2]
Local _aDados	:= {}

oSection:Cell("NEWCOD"):SetBlock( { || aDados[1] } )
oSection:Cell("OLDCOD"):SetBlock( { || aDados[2] } )


oReport:SetTitle(IIf(mv_par01=1,"Produtos bloqueados","Produtos sem custo"))// Titulo do relatório

cQuery := " SELECT B1_COD, B1_XCODSTE " 
cQuery += " FROM " +RetSqlName("SB1")+ " B1 "
cQuery += " LEFT JOIN " +RetSqlName("SB2")+ " B2 " 
cQuery += " ON B1_COD=B2_COD AND B1_LOCPAD=B2_LOCAL "
cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B2.D_E_L_E_T_=' ' AND B1_LOCPAD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' "
cQuery += " AND B1_COD BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "

If mv_par01 = 1 //Produtos bloqueados

cQuery += " AND B1_MSBLQL = '1' GROUP BY B1_COD, B1_XCODSTE ORDER BY B1_COD "

Else

cQuery += " AND B2_CMFIM1 = 0 AND B2_QATU>0 AND B2_FILIAL='"+xFilial("SB2")+"' GROUP BY B1_COD, B1_XCODSTE ORDER BY B1_COD " 

EndIf

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

	aDados[1]	:=	(cAlias)->B1_COD
	aDados[2]	:=	(cAlias)->B1_XCODSTE

	oSection:PrintLine()
	aFill(aDados,nil)

	(cAlias)->(DbSkip())
	
EndDo                    

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport