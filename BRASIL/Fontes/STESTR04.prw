#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STESTR04	ºAutor  ³Renato Nogueira     º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para listar as notas em aberto nos      º±±
±±º          ³romaneios                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STESTR04()

Local oReport        

PutSx1("STESTR04", "01","Data de?"  ,"","","mv_ch1","D",8,0,0,"G","",		,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1("STESTR04", "02","Data ate?" ,"","","mv_ch2","D",8,0,0,"G","",		,"","","mv_par02","","","","","","","","","","","","","","","","")                   

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STESTR04","RELATÓRIO DE NOTAS/ROMANEIO","STESTR04",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de notas em aberto nos romaneios.")

Pergunte("STESTR04",.F.)

oSection := TRSection():New(oReport,"RELAÇÃO DE NOTAS",{"PD2"})

TRCell():New(oSection,"FILIAL"    ,"PD2","FILIAL"      		,"@!",02)
TRCell():New(oSection,"CODROM"    ,"PD2","ROMANEIO"       	,"@!",10)
TRCell():New(oSection,"NFS"    	  ,"PD2","NOTA FISCAL"      ,"@!",9)
TRCell():New(oSection,"SERIES"    ,"PD2","SERIE"     		,"@!",3)
TRCell():New(oSection,"CLIENT"    ,"PD2","CLIENTE"     		,"@!",6)
TRCell():New(oSection,"LOJCLI"    ,"PD2","LOJA"     		,"@!",2)
TRCell():New(oSection,"REGIAO"    ,"PD2","REGIAO"     		,"@!",3)
TRCell():New(oSection,"STATUS"    ,"PD2","STATUS"     		,"@!",1)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("PD1")
oSection:Setnofilter("PD2")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local aDados[8]
Local _aDados	:= {}

oSection:Cell("FILIAL")  :SetBlock( { || aDados[1] } )
oSection:Cell("CODROM")  :SetBlock( { || aDados[2] } )
oSection:Cell("NFS")	 :SetBlock( { || aDados[3] } )
oSection:Cell("SERIES")  :SetBlock( { || aDados[4] } )
oSection:Cell("CLIENT")  :SetBlock( { || aDados[5] } )
oSection:Cell("LOJCLI")  :SetBlock( { || aDados[6] } )
oSection:Cell("REGIAO")  :SetBlock( { || aDados[7] } )
oSection:Cell("STATUS")  :SetBlock( { || aDados[8] } )

oReport:SetTitle("Lista de notas em aberto por romaneio")// Titulo do relatório

cQuery := " SELECT PD2_FILIAL, PD2_CODROM, PD2_NFS, PD2_SERIES, PD2_CLIENT, PD2_LOJCLI, PD2_REGIAO, PD2_STATUS "
cQuery += " FROM " +RetSqlName("PD2")+ " PD2 "
cQuery += " LEFT JOIN " +RetSqlName("PD1")+ " PD1 " 
cQuery += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM "
cQuery += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' ' AND PD2_STATUS=0 AND PD2_FILIAL='"+xFilial("PD2")+"' "
cQuery += " AND PD1_DTEMIS BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'  "

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

	aDados[1]	:=	(cAlias)->PD2_FILIAL
	aDados[2]	:=	(cAlias)->PD2_CODROM
	aDados[3]	:=	(cAlias)->PD2_NFS
	aDados[4]	:=	(cAlias)->PD2_SERIES
	aDados[5]	:=	(cAlias)->PD2_CLIENT
	aDados[6]	:=	(cAlias)->PD2_LOJCLI
	aDados[7]	:=	(cAlias)->PD2_REGIAO
	aDados[8]	:=	(cAlias)->PD2_STATUS

	oSection:PrintLine()
	aFill(aDados,nil)

	(cAlias)->(DbSkip())
	
EndDo                    

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport