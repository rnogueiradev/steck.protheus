#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE PULALINHA chr(10)+chr(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RSTFAT54  ºAutor  ³Renato Nogueira     º Data ³  04/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório OTDS						                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT54()

Local   oReport
Private cPerg 			:= "RFAT54"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private cPergTit 		:= cAliasLif

PutSx1( cPerg, "01","Produto de:"			   					,"","","mv_ch1" ,"C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "02","Produto até:"			   					,"","","mv_ch2" ,"C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "03","Grupo de:"    			   					,"","","mv_ch3" ,"C",4,0,0,"G","","SBM" ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "04","Grupo Até:"   			   					,"","","mv_ch4" ,"C",4,0,0,"G","","SBM" ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "05","Data de?" 				   					,"","","mv_ch5" ,"D",8,0,0,"G","",""    ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "06","Data ate?"				   					,"","","mv_ch6" ,"D",8,0,0,"G","",""    ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "07","Grp Cli de?" 			   					,"","","mv_ch7" ,"C",6,0,0,"G","","ACY" ,"","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "08","Grp Cli ate?"			   					,"","","mv_ch8" ,"C",6,0,0,"G","","ACY" ,"","","mv_par08","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "09","Cliente de?" 			   					,"","","mv_ch9" ,"C",6,0,0,"G","","SA1" ,"","","mv_par09","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "10","Cliente ate?"								,"","","mv_ch10","C",6,0,0,"G","","SA1" ,"","","mv_par10","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "11","% menor ou igual a?"						,"","","mv_ch11","N",3,0,0,"G","","" 	 ,"","","mv_par11","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "12","Prod(P)Grp(G)Cli(C)GruCli(R)?"				,"","","mv_ch12","C",1,0,0,"G","","" 	 ,"","","mv_par12","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "13","Mostrar produtos sem fornecimento (S/N)?"	,"","","mv_ch13","C",1,0,0,"G","","" 	 ,"","","mv_par13","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "14","Analítico(A) Sintético (S)?"				,"","","mv_ch14","C",1,0,0,"G","","" 	 ,"","","mv_par14","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Renato Nogueira     º Data ³  04/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório OTDS						                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

Local oReport
Local oSection1
Local nX		:= 0
Local nY		:= 1
aDados2:= {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','' }}
oReport := TReport():New(cPergTit,"Relatório OTDS",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório OTDS")

Pergunte(cPerg,.F.)

oSection1 := TRSection():New(oReport,"Relatório OTDS",{"SC6"})

If mv_par14=="S" 

	If mv_par12=="G"
		TRCell():New(oSection1,"GRUPO "  		,,"Grupo   	"			,"@!",04,/*lPixel*/,{||aDados2[nY,25]})
		TRCell():New(oSection1,"DESGRUPO " 		,,"Descrição"			,"@!",20,/*lPixel*/,{||aDados2[nY,26]})
	ElseIf mv_par12=="P"
		TRCell():New(oSection1,"PRODUTO "  		,,"Produto  "			,"@!",15,/*lPixel*/,{||aDados2[nY,25]})
		TRCell():New(oSection1,"DESPROD "		,,"Descrição"			,"@!",50,/*lPixel*/,{||aDados2[nY,26]})
	ElseIf mv_par12=="C"
		TRCell():New(oSection1,"CLIENTE "  		,,"Produto  "			,"@!",06,/*lPixel*/,{||aDados2[nY,25]})
		TRCell():New(oSection1,"NOME "			,,"Descrição"			,"@!",40,/*lPixel*/,{||aDados2[nY,26]})
	ElseIf mv_par12=="R"
		TRCell():New(oSection1,"GRP CLIENTE "  	,,"Produto  "			,"@!",06,/*lPixel*/,{||aDados2[nY,25]})
		TRCell():New(oSection1,"DESCRICAO "		,,"Descrição"			,"@!",40,/*lPixel*/,{||aDados2[nY,26]})
	EndIf

Elseif mv_par14=="A"

	TRCell():New(oSection1,"PEDIDO "  		,,"Pedido  "			,"@!",06,/*lPixel*/,{||_cNum})
	TRCell():New(oSection1,"TIPO "			,,"Tipo"				,"@!",07,/*lPixel*/,{||_cTipo})
	TRCell():New(oSection1,"ITEM "			,,"Item"				,"@!",02,/*lPixel*/,{||_cItem})
	TRCell():New(oSection1,"QTDE "			,,"Qtde"				,"@!",02,/*lPixel*/,{||_nQtde})
	TRCell():New(oSection1,"PRODUTO "		,,"Produto"				,"@!",15,/*lPixel*/,{||_cProd})
	TRCell():New(oSection1,"CODGRP "		,,"Cod Grupo"			,"@!",45,/*lPixel*/,{||_cCodGrupo})
	TRCell():New(oSection1,"GRUPO "			,,"Grupo"				,"@!",45,/*lPixel*/,{||_cGrupo})
	TRCell():New(oSection1,"EMISSAO "		,,"Emissão"				,"@!",10,/*lPixel*/,{||_dEmis})
	TRCell():New(oSection1,"LIBFIN "		,,"Lib Fin."			,"@!",10,/*lPixel*/,{||_dLibFin})
	TRCell():New(oSection1,"DIASOF "		,,"Dias OF"				,"@E",03,/*lPixel*/,{||_nDiasOf})
	TRCell():New(oSection1,"DTOFLOG "		,,"Data oferta log"		,"@!",10,/*lPixel*/,{||_cDtOf})
	TRCell():New(oSection1,"DTENTREG "		,,"Data da entrega"		,"@!",10,/*lPixel*/,{||_dDtEntreg})
	TRCell():New(oSection1,"ENTREGUE "		,,"Entregue"			,"@!",01,/*lPixel*/,{||_cEnt})
	TRCell():New(oSection1,"SLDANT "		,,"Saldo na data"		,"@E 999,999,999,999,999",20,/*lPixel*/,{||_nSaldoAnt})

EndIf

If mv_par14=="S"
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Jan - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,01]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Jan - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,13]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Jan - % Atend  "	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,13]/aDados2[nY,1])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Fev - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,02]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Fev - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,14]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Fev - % Atend  "	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,14]/aDados2[nY,02])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Mar - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,03]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Mar - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,15]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Mar - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,15]/aDados2[nY,03])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Abr - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,04]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Abr - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,16]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Abr - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,16]/aDados2[nY,04])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Mai - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,05]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Mai - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,17]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Mai - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,17]/aDados2[nY,05])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Jun - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,06]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Jun - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,18]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Jun - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,18]/aDados2[nY,06])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Jul - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,07]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Jul - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,19]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Jul - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,19]/aDados2[nY,07])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Ago - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,08]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Ago - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,20]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Ago - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,20]/aDados2[nY,08])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Set - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,09]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Set - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,21]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Set - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,21]/aDados2[nY,09])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Out - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,10]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Out - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,22]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Out - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,22]/aDados2[nY,10])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Nov - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,11]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Nov - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,23]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Nov - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,23]/aDados2[nY,11])*100})
	
	TRCell():New(oSection1,"LINHASQTD "  	,,"Dez - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,12]})
	TRCell():New(oSection1,"ENTREGQRD "	    ,,"Dez - Entregues"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,24]})
	TRCell():New(oSection1,"PROCENT   "	    ,,"Dez - % Atend"	,"@E  999,99",06,/*lPixel*/,{||(aDados2[nY,24]/aDados2[nY,12])*100})
	
EndIf

oSection1:SetHeaderSection(.t.)
oSection1:Setnofilter("SC6")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrinºAutor  ³Renato Nogueira     º Data ³  04/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório OTDS						                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local _cSta 	:= ''
Local nY		:= 0
Private oSection1	:= oReport:Section(1)
Private aDados	:= {}
Private aDados2	:= {}
 

oReport:SetTitle("Relatório OTDS")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
oSection1:Init()


Processa({|| StQuery(  ) },"Compondo Relatorio")

If mv_par14=="S"
	For nY:=1 To Len(aDados)
		aDados2	:= {aDados[nY] }
		oSection1:PrintLine()
	Next
	
	aFill(aDados,nil)
EndIf

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StQuery	ºAutor  ³Renato Nogueira     º Data ³  04/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório OTDS						                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function StQuery()

Local cQuery	:= ""
Local nX		:= 0
Local lPrimeira	:= .T.

//Adiciona estrutura
aDados	:= {}

For nX:=1 To 12
	
	DO CASE
		
		CASE mv_par14=="S"
			
			cQuery := " SELECT "+PULALINHA
			If mv_par12=="G"
				cQuery += " BM_GRUPO AS CODIGO, "+PULALINHA
			ElseIf mv_par12=="P"
				cQuery += " B1_COD AS CODIGO, "+PULALINHA
			ElseIf mv_par12=="C"
				cQuery += " A1_COD AS CODIGO, "+PULALINHA
			ElseIf mv_par12=="R"
				cQuery += " A1_GRPVEN AS CODIGO, "+PULALINHA
			EndIf
			cQuery += " NVL(SUM(QTDLINHAS),0) LINHASQTD, NVL(SUM(ENTREGUE),0) ENTREGQTD, NVL(ROUND(SUM(ENTREGUE)/SUM(QTDLINHAS)*100,2),0) AS PERCENTUAL "+PULALINHA
			If mv_par12=="G"
				cQuery += " ,BM_DESC AS DESCRI  "+PULALINHA
			ElseIf mv_par12=="P"
				cQuery += " ,B1_DESC AS DESCRI  "+PULALINHA
			ElseIf mv_par12=="C"
				cQuery += " ,A1_NOME AS DESCRI  "+PULALINHA
			ElseIf mv_par12=="R"
				cQuery += " ,ACY_DESCRI AS DESCRI  "+PULALINHA
			EndIf
			cQuery += " FROM ( "+PULALINHA
			cQuery += " SELECT "+PULALINHA
			If mv_par12=="G"
				cQuery += " B1_GRUPO AS GRUPO, "+PULALINHA
			ElseIf mv_par12=="P"
				cQuery += " B1_COD AS COD, "+PULALINHA
			ElseIf mv_par12=="C"
				cQuery += " A1_COD AS CODIGO, "+PULALINHA
			ElseIf mv_par12=="R"
				cQuery += " A1_GRPVEN AS CODIGO, "+PULALINHA
			EndIf
			cQuery += " SUBSTR(C6_ZDTOL,5,2)||SUBSTR(C6_ZDTOL,1,4) AS DTEMIS, "+PULALINHA
			cQuery += " 1 AS QTDLINHAS, "+PULALINHA
			
		CASE mv_par14=="A"
			
			cQuery := " SELECT "+PULALINHA
			cQuery += " C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN, CASE WHEN C6_ZDTCLI>C6_ZDTOL THEN C6_ZDTCLI ELSE C6_ZDTOL END AS DATAOFERTA, "+PULALINHA
			cQuery += " CASE WHEN C5_XTIPF=1 THEN 'TOTAL' ELSE 'PARCIAL' END AS TIPO, "
			cQuery += " (SELECT BM_DESC FROM "+RetSqlName("SBM")+" BM1 WHERE BM1.D_E_L_E_T_=' ' AND B1_GRUPO=BM_GRUPO) AS DESGRP, "
			cQuery += " B1_GRUPO CODGRP, "
			cQuery += " C6_ZDTEMIS EMISSAO, C6_ZDTLIBF LIBFIN, C6_ZPROFL DIASOF, 'ANALISAR', C6_ZB2QATU SLDANT, "
			cQuery += " (CASE WHEN C5_XTIPO='2' THEN NVL((SELECT MAX(D2_EMISSAO) FROM "+RetSqlName("SD2")+" D2 WHERE D2.D_E_L_E_T_=' ' "
			cQuery += " AND C6.C6_FILIAL=D2.D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_PRODUTO=D2_COD AND C6_ITEM=D2_ITEMPV),0) "
			cQuery += " ELSE NVL((SELECT MAX(CB7_XDFEM) FROM "+RetSqlName("CB7")+" CB7 LEFT JOIN "+RetSqlName("CB8")+" CB8 "
			cQuery += " ON CB7.CB7_FILIAL=CB8.CB8_FILIAL AND CB7.CB7_ORDSEP=CB8.CB8_ORDSEP WHERE CB7.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' ' "
			cQuery += " AND C6.C6_FILIAL=CB7.CB7_FILIAL AND C6_NUM=CB7_PEDIDO AND CB8.CB8_PROD=C6.C6_PRODUTO AND CB8.CB8_ITEM=C6.C6_ITEM),0) END) AS DTENTREG, " 
			
	ENDCASE
	
	cQuery += " CASE WHEN C6_QTDVEN=NVL((SELECT SUM(D2_QUANT) FROM "+RetSqlName("SD2")+" D2 WHERE D2.D_E_L_E_T_=' ' "+PULALINHA
	cQuery += " AND C6.C6_FILIAL=D2.D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_PRODUTO=D2_COD AND C6_ITEM=D2_ITEMPV),0) AND "+PULALINHA
	cQuery += " CASE WHEN C6_ZDTCLI>C6_ZDTOL THEN C6_ZDTCLI ELSE C6_ZDTOL END "+PULALINHA
	cQuery += " >=(CASE WHEN C5_XTIPO='2' THEN NVL((SELECT MAX(D2_EMISSAO) FROM "+RetSqlName("SD2")+" D2 WHERE D2.D_E_L_E_T_=' ' "+PULALINHA
	cQuery += " AND C6.C6_FILIAL=D2.D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_PRODUTO=D2_COD AND C6_ITEM=D2_ITEMPV),0) "+PULALINHA
	cQuery += " ELSE NVL((SELECT MAX(CB7_XDFEM) FROM "+RetSqlName("CB7")+" CB7 LEFT JOIN "+RetSqlName("CB8")+" CB8 "+PULALINHA
	cQuery += " ON CB7.CB7_FILIAL=CB8.CB8_FILIAL AND CB7.CB7_ORDSEP=CB8.CB8_ORDSEP WHERE CB7.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' ' "+PULALINHA
	cQuery += " AND C6.C6_FILIAL=CB7.CB7_FILIAL AND C6_NUM=CB7_PEDIDO AND CB8.CB8_PROD=C6.C6_PRODUTO AND CB8.CB8_ITEM=C6.C6_ITEM),0) END) "+PULALINHA
	cQuery += " THEN 1 ELSE 0 END AS ENTREGUE "+PULALINHA
	cQuery += " FROM "+RetSqlName("SC6")+" C6 "+PULALINHA
	cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5 "+PULALINHA
	cQuery += " ON C6.C6_FILIAL=C5.C5_FILIAL AND C6.C6_NUM=C5.C5_NUM AND C6.C6_CLI=C5.C5_CLIENTE AND C6.C6_LOJA=C5.C5_LOJACLI "+PULALINHA
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "+PULALINHA
	cQuery += " ON B1.B1_COD=C6.C6_PRODUTO "+PULALINHA
	cQuery += " LEFT JOIN "+RetSqlName("SF4")+" F4 "+PULALINHA
	cQuery += " ON C6_TES=F4_CODIGO "+PULALINHA
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "+PULALINHA
	cQuery += " ON C6_CLI=A1_COD AND C6_LOJA=A1_LOJA  WHERE C6.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND F4.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' "+PULALINHA
	cQuery += " AND A1.D_E_L_E_T_=' ' AND (B1_TIPO='PA' OR B1_TIPO='PI') "+PULALINHA
	cQuery += " AND C6_ZDTOL<>' ' AND F4_ESTOQUE='S' AND F4_DUPLIC='S' AND C6_FILIAL='02' AND C6_ZDTOL<TO_CHAR(SYSDATE,'YYYYMMDD') "+PULALINHA
	cQuery += " AND C6_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "+PULALINHA
	cQuery += " AND B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+PULALINHA
	cQuery += " AND C6_ZDTOL BETWEEN '"+Year2Str(DDATABASE)+strzero(nx,2)+"01"+"' AND '"+Year2Str(DDATABASE)+strzero(nx,2)+"31"+"' "+PULALINHA
	cQuery += " AND C6_ZDTOL BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"'  "
	cQuery += " AND C6_CLI BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "+PULALINHA
	cQuery += " AND A1_GRPVEN BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "+PULALINHA
	cQuery += " AND B1_ZCODOL<>'X' "+PULALINHA //Eliminar X pois não controla
	cQuery += " AND C5_EMISSAO>='20140601' "+PULALINHA //Data que foi colocado no ar a oferta logística
	
	DO CASE
		
		CASE mv_par14=="S"
			
			cQuery += " ORDER BY C6_PRODUTO) AAA "+PULALINHA
			If mv_par12=="G"
				cQuery += " RIGHT JOIN "+RetSqlName("SBM")+" BM "+PULALINHA
				cQuery += " ON BM_GRUPO=GRUPO AND BM.D_E_L_E_T_=' ' "+PULALINHA
				cQuery += " WHERE BM_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+PULALINHA
			ElseIf mv_par12=="P"
				cQuery += " RIGHT JOIN "+RetSqlName("SB1")+" B1 "+PULALINHA
				cQuery += " ON B1_COD=COD AND B1.D_E_L_E_T_=' ' "+PULALINHA
				cQuery += " WHERE B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "+PULALINHA
			ElseIf mv_par12=="C"
				cQuery += " RIGHT JOIN "+RetSqlName("SA1")+" A1 "+PULALINHA
				cQuery += " ON A1_COD=CODIGO AND A1.D_E_L_E_T_=' '  "+PULALINHA
				cQuery += " WHERE A1_COD BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "+PULALINHA
			ElseIf mv_par12=="R"
				cQuery += " RIGHT JOIN "+RetSqlName("SA1")+" A1 "+PULALINHA
				cQuery += " ON A1_GRPVEN=CODIGO AND A1.D_E_L_E_T_=' '  "+PULALINHA
				cQuery += " INNER JOIN "+RetSqlName("ACY")+" ACY "+PULALINHA
				cQuery += " ON A1_GRPVEN=ACY_GRPVEN AND ACY.D_E_L_E_T_=' ' "+PULALINHA
				cQuery += " WHERE A1_GRPVEN BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "+PULALINHA
			EndIf
			cQuery += " HAVING NVL(ROUND(SUM(ENTREGUE)/SUM(QTDLINHAS)*100,2),0)<="+CVALTOCHAR(mv_par11)+" "+PULALINHA
			If mv_par13<>"S"
				cQuery += " AND NVL(SUM(QTDLINHAS),0)>0 "
			EndIf
			If mv_par12=="G"
				cQuery += " GROUP BY "+PULALINHA
				cQuery += " BM_GRUPO, BM_DESC "+PULALINHA
				cQuery += " ORDER BY "+PULALINHA
				cQuery += " BM_GRUPO "+PULALINHA
			ElseIf mv_par12=="P"
				cQuery += " GROUP BY "+PULALINHA
				cQuery += " B1_COD, B1_DESC "+PULALINHA
				cQuery += " ORDER BY "+PULALINHA
				cQuery += " B1_COD "+PULALINHA
			ElseIf mv_par12=="C"
				cQuery += " GROUP BY "+PULALINHA
				cQuery += " A1_COD, A1_NOME "+PULALINHA
				cQuery += " ORDER BY "+PULALINHA
				cQuery += " A1_COD "+PULALINHA
			ElseIf mv_par12=="R"
				cQuery += " GROUP BY "+PULALINHA
				cQuery += " A1_GRPVEN , ACY_DESCRI "+PULALINHA
				cQuery += " ORDER BY "+PULALINHA
				cQuery += " A1_GRPVEN "+PULALINHA
			EndIf
			
		CASE mv_par14=="A"
			
			cQuery += " ORDER BY C6_NUM, C6_ITEM "+PULALINHA
			
	ENDCASE
	
	//cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	
	//Count to nQtdReg
	
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			If mv_par14=="S"
				
				nPos	:= aScan(aDados,{|x| Upper(Alltrim(x[25]))==AllTrim((cAliasLif)->CODIGO)})
				If nPos==0
					AADD(aDados,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(cAliasLif)->CODIGO,(cAliasLif)->DESCRI})
					aDados[Len(aDados),nX]		:= (cAliasLif)->LINHASQTD
					aDados[Len(aDados),nX+12]	:= (cAliasLif)->ENTREGQTD
				Else
					aDados[nPos,nX]		:= (cAliasLif)->LINHASQTD
					aDados[nPos,nX+12]	:= (cAliasLif)->ENTREGQTD
				EndIf
				
			ElseIf mv_par14=="A"
				
				_cNum		:= (cAliasLif)->C6_NUM
				_cProd		:= (cAliasLif)->C6_PRODUTO
				_cItem		:= (cAliasLif)->C6_ITEM
				_cDtOf		:= DTOC(STOD((cAliasLif)->DATAOFERTA))
				_cEnt		:= IIf((cAliasLif)->ENTREGUE==1,"S","N")
				_cTipo		:= (cAliasLif)->TIPO
				_cCodGrupo	:= (cAliasLif)->CODGRP
				_cGrupo		:= (cAliasLif)->DESGRP
				_dEmis		:= DTOC(STOD((cAliasLif)->EMISSAO))
				_dLibFin	:= DTOC(STOD((cAliasLif)->LIBFIN))
				_nDiasOf	:= (cAliasLif)->DIASOF
				_dDtEntreg	:= DTOC(STOD((cAliasLif)->DTENTREG))
				_nSaldoAnt	:= (cAliasLif)->SLDANT
				_nQtde		:= (cAliasLif)->C6_QTDVEN
				
				oSection1:PrintLine()
				
			EndIf
			
			(cAliasLif)->(DbSkip())
			
		End
		
	EndIf
	
Next

Return()