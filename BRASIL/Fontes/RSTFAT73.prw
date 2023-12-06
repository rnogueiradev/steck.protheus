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
±±ºDesc.     ³Relatório OTDS - Por pedido				                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT73()

Local   oReport
Private cPerg 			:= "RFAT73"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private cPergTit 		:= cAliasLif

PutSx1( cPerg, "01","Produto de:"			   					,"","","mv_ch1" ,"C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "02","Produto até:"			   					,"","","mv_ch2" ,"C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "03","Grupo de:"    			   				,"","","mv_ch3" ,"C",4,0,0,"G","","SBM" ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "04","Grupo Até:"   			   				,"","","mv_ch4" ,"C",4,0,0,"G","","SBM" ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "05","Data de?" 				   					,"","","mv_ch5" ,"D",8,0,0,"G","",""    ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "06","Data ate?"				   					,"","","mv_ch6" ,"D",8,0,0,"G","",""    ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "07","Grp Cli de?" 			   					,"","","mv_ch7" ,"C",6,0,0,"G","","ACY" ,"","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "08","Grp Cli ate?"			   					,"","","mv_ch8" ,"C",6,0,0,"G","","ACY" ,"","","mv_par08","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "09","Cliente de?" 			   					,"","","mv_ch9" ,"C",6,0,0,"G","","SA1" ,"","","mv_par09","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "10","Cliente ate?"								,"","","mv_ch10","C",6,0,0,"G","","SA1" ,"","","mv_par10","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "11","Analítico(A) Sintético (S)?"			,"","","mv_ch11","C",1,0,0,"G","","" 	 ,"","","mv_par11","","","","","","","","","","","","","","","","")
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
oReport := TReport():New(cPergTit,"Relatório OTDS - Pedido",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório OTDS - Pedido")

Pergunte(cPerg,.F.)

oSection1 := TRSection():New(oReport,"Relatório OTDS - Pedido",{"SC6"})

If mv_par11=="S"

	TRCell():New(oSection1,"PEDIDOS "  		,,"Pedido  "			,"@!",15,/*lPixel*/,{||aDados2[nY,25]})
	TRCell():New(oSection1,"PEDIDO  "  		,,"Pedidos "			,"@!",50,/*lPixel*/,{||aDados2[nY,26]})
	
	TRCell():New(oSection1,"LINHASQTD "  	    ,,"Jan - Linhas"	,"@E 999,999,999,999,999",20,/*lPixel*/,{||aDados2[nY,01]})
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
	
Elseif mv_par11=="A"

	TRCell():New(oSection1,"PEDIDO "  		,,"Pedido  "			,"@!",06,/*lPixel*/,{||_cNum})
	TRCell():New(oSection1,"TIPO "			,,"Tipo"				,"@!",07,/*lPixel*/,{||_cTipo})
	TRCell():New(oSection1,"SITUACAO"		,,"Entregue"			,"@!",03,/*lPixel*/,{||_cSit})

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
Local nX			:= 0
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP0"
Local _cSta 		:= ''
	Local ny		:= 0
Private oSection1	:= oReport:Section(1)
Private aDados	:= {}
Private aDados2	:= {}
Private nY			:= 0

oReport:SetTitle("Relatório OTDS - Pedido")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
oSection1:Init()


Processa({|| StQuery(  ) },"Compondo Relatorio")

If mv_par11=="S"
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
		
		CASE mv_par11=="S"
		
			cQuery := " SELECT 'PEDIDOS' AS CODIGO, SUM(CONTADOR) AS LINHASQTD, "+PULALINHA
			cQuery += " SUM(SITUACAO) AS ENTREGQTD, ROUND(SUM(SITUACAO)/SUM(CONTADOR)*100,2) PERCENT "+PULALINHA
			cQuery += " FROM ( "+PULALINHA
			cQuery += " SELECT NUM, TIPO, CASE WHEN NAOENTREGUE>0 THEN 0 ELSE 1 END AS SITUACAO, CONTADOR "+PULALINHA
			cQuery += " FROM ( "+PULALINHA
			
			
		CASE mv_par11=="A"
			
			cQuery := " SELECT NUM, TIPO, CASE WHEN NAOENTREGUE>0 THEN 0 ELSE 1 END AS SITUACAO, CONTADOR "+PULALINHA //0 não entregue e 1 entregue
			cQuery += " FROM ( "+PULALINHA
			
	ENDCASE
	
	cQuery += " SELECT NUM, TIPO, SUM(NAOENTREGUE) NAOENTREGUE, 1 AS CONTADOR "+PULALINHA
	cQuery += " FROM ( "+PULALINHA
	cQuery += " SELECT C6_NUM NUM, CASE WHEN C5_XTIPF=1 THEN 'TOTAL' ELSE 'PARCIAL' END AS TIPO, "+PULALINHA
	cQuery += " CASE WHEN C6_QTDVEN=NVL((SELECT SUM(D2_QUANT) FROM "+RetSqlName("SD2")+" D2 WHERE D2.D_E_L_E_T_=' ' "+PULALINHA
	cQuery += " AND C6.C6_FILIAL=D2.D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_PRODUTO=D2_COD AND C6_ITEM=D2_ITEMPV),0) AND "+PULALINHA
	cQuery += " CASE WHEN C6_ZDTCLI>C6_ZDTOL THEN C6_ZDTCLI ELSE C6_ZDTOL END "+PULALINHA
	cQuery += "  >=(CASE WHEN C5_XTIPO='2' THEN NVL((SELECT MAX(D2_EMISSAO) FROM "+RetSqlName("SD2")+" D2 WHERE D2.D_E_L_E_T_=' ' "+PULALINHA
	cQuery += " AND C6.C6_FILIAL=D2.D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_PRODUTO=D2_COD AND C6_ITEM=D2_ITEMPV),0) "+PULALINHA
	cQuery += " ELSE NVL((SELECT MAX(CB7_XDFEM) FROM "+RetSqlName("CB7")+" CB7 LEFT JOIN "+RetSqlName("CB8")+" CB8 "+PULALINHA
	cQuery += " ON CB7.CB7_FILIAL=CB8.CB8_FILIAL AND CB7.CB7_ORDSEP=CB8.CB8_ORDSEP WHERE CB7.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' ' "+PULALINHA
	cQuery += " AND C6.C6_FILIAL=CB7.CB7_FILIAL AND C6_NUM=CB7_PEDIDO AND CB8.CB8_PROD=C6.C6_PRODUTO AND CB8.CB8_ITEM=C6.C6_ITEM),0) END) "+PULALINHA
	cQuery += " THEN 0 ELSE 1 END AS NAOENTREGUE "+PULALINHA
	cQuery += " FROM "+RetSqlName("SC6")+" C6 "+PULALINHA
	cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5 "
	cQuery += " ON C6.C6_FILIAL=C5.C5_FILIAL AND C6.C6_NUM=C5.C5_NUM AND C6.C6_CLI=C5.C5_CLIENTE AND C6.C6_LOJA=C5.C5_LOJACLI "
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery += " ON B1.B1_COD=C6.C6_PRODUTO "
	cQuery += " LEFT JOIN "+RetSqlName("SF4")+" F4 "
	cQuery += " ON C6_TES=F4_CODIGO "
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "
	cQuery += " ON C6_CLI=A1_COD AND C6_LOJA=A1_LOJA  WHERE C6.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND F4.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' "
	cQuery += " AND A1.D_E_L_E_T_=' ' AND (B1_TIPO='PA' OR B1_TIPO='PI') "
	cQuery += " AND C6_ZDTOL<>' ' AND F4_ESTOQUE='S' AND F4_DUPLIC='S' AND C6_FILIAL='02' AND C6_ZDTOL<TO_CHAR(SYSDATE,'YYYYMMDD') "
	cQuery += " AND C6_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "+PULALINHA
	cQuery += " AND B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+PULALINHA
	cQuery += " AND C6_ZDTOL BETWEEN '"+Year2Str(DDATABASE)+strzero(nx,2)+"01"+"' AND '"+Year2Str(DDATABASE)+strzero(nx,2)+"31"+"' "+PULALINHA
	cQuery += " AND C6_ZDTOL BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"'  "
	cQuery += " AND C6_CLI BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "+PULALINHA
	cQuery += " AND A1_GRPVEN BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "+PULALINHA
	cQuery += " AND B1_ZCODOL<>'X' "+PULALINHA //Eliminar X pois não controla
	cQuery += " AND C5_EMISSAO>='20140601' "+PULALINHA //Data que foi colocado no ar a oferta logística
	cQuery += " ORDER BY C6_NUM, C6_ITEM "
	cQuery += " ) GROUP BY NUM, TIPO "
	cQuery += " ) "

	If mv_par11=="S"
		cQuery += " ) "
	EndIF		
	
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
			
			If mv_par11=="S"
				
				nPos	:= aScan(aDados,{|x| Upper(Alltrim(x[25]))==AllTrim((cAliasLif)->CODIGO)})
				If nPos==0
					AADD(aDados,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(cAliasLif)->CODIGO,(cAliasLif)->CODIGO})
					aDados[Len(aDados),nX]		:= (cAliasLif)->LINHASQTD
					aDados[Len(aDados),nX+12]	:= (cAliasLif)->ENTREGQTD
				Else
					aDados[nPos,nX]		:= (cAliasLif)->LINHASQTD
					aDados[nPos,nX+12]	:= (cAliasLif)->ENTREGQTD
				EndIf
				
			ElseIf mv_par11=="A"
				
				_cNum		:= (cAliasLif)->NUM
				_cTipo		:= (cAliasLif)->TIPO
				_cSit		:= IIf((cAliasLif)->SITUACAO==1,"SIM","NAO")
				
				oSection1:PrintLine()
				
			EndIf
			
			(cAliasLif)->(DbSkip())
			
		End
		
	EndIf
	
Next

Return()