#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATB5     บAutor  ณGiovani Zago    บ Data ณ  18/09/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio geral realinhamento dos planetas                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSTFATB5()
	
	Local   oReport
	Private cPerg 			:= "RFATB5"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private _aRelT	        := {}
	Private cPergTit 		:= cAliasLif
	
	If !(__cUserId $ Getmv("ST_FATB5",,"000000/000645/000294")+"000000/000645")
		
		MsgInfo("usuario sem acesso")
		Return()
	EndIf
	
	
	
	PutSx1(cPerg, "01", "Do Ano:" 	,"Da Ano: ?" 	,"Da Ano: ?" 		,"mv_ch1","C",4,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Do Mes:" 	,"Do Mes: ?" 	,"Do Mes: ?" 			,"mv_ch2","C",2,0,0,"G","",'' ,"","","mv_par02","","","","","","","","","","","","","","","","")
	
	
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
	Local oSec01
	Local oSec02
	Local oSec03
	Local oSec05
	Local oSec06
	Local oSec07
	Local oSec08
	Local oSec09
	Local oSec10
	Local oSec11
	
	oReport := TReport():New(cPergTit,"RELATำRIO GERAL ",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio GERAL")
	
	Pergunte(cPerg,.f.)
	
	oSection := TRSection():New(oReport,"GERAL" ,{"SC6"})
	oSec01	 := TRSection():New(oReport,"S00001 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00001',"A3_NOME")),{"SC5"})
	oSec02	 := TRSection():New(oReport,"S00002 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00002',"A3_NOME")),{"SC5"})
	oSec03	 := TRSection():New(oReport,"S00003 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00003',"A3_NOME")),{"SC5"})
	oSec05	 := TRSection():New(oReport,"S00005 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00005',"A3_NOME")),{"SC5"})
	oSec06	 := TRSection():New(oReport,"S00006 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00006',"A3_NOME")),{"SC5"})
	oSec07	 := TRSection():New(oReport,"S00007 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00007',"A3_NOME")),{"SC5"})
	oSec08	 := TRSection():New(oReport,"S00008 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00008',"A3_NOME")),{"SC5"})
	oSec09	 := TRSection():New(oReport,"S00009 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00009',"A3_NOME")),{"SC5"})
	oSec10	 := TRSection():New(oReport,"S00010 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00010',"A3_NOME")),{"SC5"})
	oSec11	 := TRSection():New(oReport,"S00011 - "+ Alltrim(Posicione("SA3",1,xFilial("SA3")+'S00011',"A3_NOME")),{"SC5"})
	
	
	
	
	
	TRCell():New(oSection,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSection,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSection,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSection,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSection,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSection,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSection,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSection,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSection,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSection,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSection,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	TRCell():New(oSec01,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec01,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec01,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec01,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec01,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec01,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec01,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec01,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec01,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec01,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec01,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	TRCell():New(oSec02,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec02,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec02,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec02,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec02,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec02,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec02,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec02,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec02,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec02,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec02,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	TRCell():New(oSec03,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec03,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec03,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec03,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec03,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec03,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec03,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec03,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec03,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec03,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec03,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	
	TRCell():New(oSec05,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec05,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec05,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec05,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec05,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec05,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec05,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec05,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec05,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec05,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec05,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	TRCell():New(oSec06,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec06,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec06,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec06,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec06,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec06,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec06,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec06,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec06,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec06,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec06,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	TRCell():New(oSec07,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec07,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec07,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec07,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec07,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec07,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec07,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec07,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec07,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec07,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec07,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	TRCell():New(oSec08,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec08,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec08,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec08,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec08,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec08,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec08,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec08,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec08,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec08,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec08,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	TRCell():New(oSec09,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec09,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec09,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec09,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec09,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec09,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec09,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec09,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec09,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec09,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec09,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	TRCell():New(oSec10,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec10,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec10,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec10,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec10,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec10,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec10,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec10,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec10,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec10,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec10,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	
	TRCell():New(oSec11,"01",,"VENDEDOR"			,,06,.F.,)
	TRCell():New(oSec11,"02",,"NOME"				,,06,.F.,)
	TRCell():New(oSec11,"03",,"SUPERVISOR" 		,,02,.F.,)
	TRCell():New(oSec11,"04",,"NOME" 				,,30,.F.,)
	TRCell():New(oSec11,"05",,"OBJETIVO" 			,"@E 999,999,999.99",3)
	TRCell():New(oSec11,"06",,"CAPTACAO"			,"@E 999,999,999.99",3)
	TRCell():New(oSec11,"07",,"REALIZADO %"		,"@E 999.99",3)
	TRCell():New(oSec11,"08",,"FATURAMENTO"		,"@E 999,999,999.99",3)
	TRCell():New(oSec11,"09",,"DEVOLUCAO"			,"@E 999,999.99",3)
	TRCell():New(oSec11,"10",,"FAT.-DEVOL."		,"@E 999,999,999.99",3)
	TRCell():New(oSec11,"11",,"REALIZADO %"		,"@E 999.99",3)
	
	oSection:SetPageBreak(.T.)
	
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
	Local oSec01	:= oReport:Section(2)
	Local oSec02	:= oReport:Section(3)
	Local oSec03	:= oReport:Section(4)
	Local oSec05	:= oReport:Section(5)
	Local oSec06	:= oReport:Section(6)
	Local oSec07	:= oReport:Section(7)
	Local oSec08	:= oReport:Section(8)
	Local oSec09	:= oReport:Section(9)
	Local oSec10	:= oReport:Section(10)
	Local oSec11	:= oReport:Section(11)
	Local nX		:= 0
	Local _aTot		:= {}
	Local aDados[2]
	Local aDados1[99]
	Local aDados01[99]
	Local p		:= 0
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
	
	oSec01:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec01:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec01:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec01:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec01:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec01:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec01:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec01:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec01:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec01:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec01:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec02:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec02:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec02:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec02:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec02:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec02:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec02:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec02:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec02:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec02:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec02:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec03:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec03:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec03:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec03:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec03:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec03:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec03:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec03:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec03:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec03:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec03:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec05:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec05:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec05:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec05:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec05:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec05:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec05:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec05:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec05:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec05:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec05:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec06:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec06:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec06:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec06:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec06:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec06:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec06:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec06:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec06:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec06:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec06:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec07:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec07:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec07:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec07:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec07:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec07:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec07:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec07:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec07:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec07:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec07:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec08:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec08:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec08:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec08:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec08:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec08:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec08:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec08:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec08:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec08:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec08:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec09:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec09:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec09:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec09:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec09:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec09:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec09:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec09:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec09:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec09:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec09:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec10:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec10:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec10:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec10:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec10:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec10:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec10:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec10:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec10:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec10:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec10:Cell("11") :SetBlock( { || aDados01[11] } )
	
	oSec11:Cell("01") :SetBlock( { || aDados01[01] } )
	oSec11:Cell("02") :SetBlock( { || aDados01[02] } )
	oSec11:Cell("03") :SetBlock( { || aDados01[03] } )
	oSec11:Cell("04") :SetBlock( { || aDados01[04] } )
	oSec11:Cell("05") :SetBlock( { || aDados01[05] } )
	oSec11:Cell("06") :SetBlock( { || aDados01[06] } )
	oSec11:Cell("07") :SetBlock( { || aDados01[07] } )
	oSec11:Cell("08") :SetBlock( { || aDados01[08] } )
	oSec11:Cell("09") :SetBlock( { || aDados01[09] } )
	oSec11:Cell("10") :SetBlock( { || aDados01[10] } )
	oSec11:Cell("11") :SetBlock( { || aDados01[11] } )
	
	
	
	oReport:SetTitle("GERAL")
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	aFill(aDados01,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	Aadd(_aTot,{0,0,0,0})
	
	
	For p:=1 To Len(_aRelT)
		
		
		aDados1[01]	:= _aRelT[p,2]
		aDados1[02]	:= _aRelT[p,3]
		aDados1[03]	:= _aRelT[p,4]
		aDados1[04]	:= _aRelT[p,5]
		aDados1[05]	:= _aRelT[p,7]
		aDados1[06]	:= _aRelT[p,6]
		aDados1[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
		aDados1[08]	:= _aRelT[p,8]
		aDados1[09]	:= _aRelT[p,9]
		aDados1[10]	:= _aRelT[p,8] -  _aRelT[p,9]
		aDados1[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
		_aTot[1,1]+=_aRelT[p,7]
		_aTot[1,2]+=_aRelT[p,6]
		_aTot[1,3]+=_aRelT[p,8]
		_aTot[1,4]+=_aRelT[p,9]
		
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		
	Next p
	
	oSection1:PrintLine()
	aFill(aDados1,nil)
	
	aDados1[04]	:= 'TOTAL'
	aDados1[05]	:= _aTot[1,1]
	aDados1[06]	:= _aTot[1,2]
	aDados1[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados1[08]	:= _aTot[1,3]
	aDados1[09]	:= _aTot[1,4]
	aDados1[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados1[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSection1:PrintLine()
	aFill(aDados1,nil)
	//oSection:PrintTotal()
	oSection:Finish()
	
	//seq 0100000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec01:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00001'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec01:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec01:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec01:PrintLine()
	aFill(aDados01,nil)
	oSec01:Finish()
	
	// seq 0200000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec02:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00002'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec02:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec02:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec02:PrintLine()
	aFill(aDados01,nil)
	
	oSec02:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	// seq 0300000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec03:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00003'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec03:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec03:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec03:PrintLine()
	aFill(aDados01,nil)
	
	oSec03:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	// seq 0500000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec05:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00005'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec05:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec05:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec05:PrintLine()
	aFill(aDados01,nil)
	
	oSec05:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	// seq 0200000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec06:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00006'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec06:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec06:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec06:PrintLine()
	aFill(aDados01,nil)
	
	oSec06:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	// seq 0200000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec07:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00007'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec07:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec07:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec07:PrintLine()
	aFill(aDados01,nil)
	
	oSec07:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	// seq 0200000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec08:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00008'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec08:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec08:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec08:PrintLine()
	aFill(aDados01,nil)
	
	oSec08:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	// seq 0200000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec09:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00009'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec09:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec09:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec09:PrintLine()
	aFill(aDados01,nil)
	
	oSec09:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	// seq 0200000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec10:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00010'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec10:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec10:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec10:PrintLine()
	aFill(aDados01,nil)
	
	oSec10:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	// seq 0200000000000
	_aTot:={}
	Aadd(_aTot,{0,0,0,0})
	oSec11:Init()
	For p:=1 To Len(_aRelT)
		If _aRelT[p,4] = 'S00011'
			
			aDados01[01]	:= _aRelT[p,2]
			aDados01[02]	:= _aRelT[p,3]
			aDados01[03]	:= _aRelT[p,4]
			aDados01[04]	:= _aRelT[p,5]
			aDados01[05]	:= _aRelT[p,7]
			aDados01[06]	:= _aRelT[p,6]
			aDados01[07]	:= Round(((_aRelT[p,6]/_aRelT[p,7])*100),2)
			aDados01[08]	:= _aRelT[p,8]
			aDados01[09]	:= _aRelT[p,9]
			aDados01[10]	:= _aRelT[p,8] -  _aRelT[p,9]
			aDados01[11]	:= Round((((_aRelT[p,8] -  _aRelT[p,9])/_aRelT[p,7])*100),2)
			_aTot[1,1]+=_aRelT[p,7]
			_aTot[1,2]+=_aRelT[p,6]
			_aTot[1,3]+=_aRelT[p,8]
			_aTot[1,4]+=_aRelT[p,9]
			
			
			oSec11:PrintLine()
			aFill(aDados01,nil)
		EndIf
		
	Next p
	
	oSec11:PrintLine()
	aFill(aDados01,nil)
	
	aDados01[04]	:= 'TOTAL'
	aDados01[05]	:= _aTot[1,1]
	aDados01[06]	:= _aTot[1,2]
	aDados01[07]	:= Round(((_aTot[1,2]/_aTot[1,1])*100),2)
	aDados01[08]	:= _aTot[1,3]
	aDados01[09]	:= _aTot[1,4]
	aDados01[10]	:= _aTot[1,3] -  _aTot[1,4]
	aDados01[11]	:= Round((((_aTot[1,3] -  _aTot[1,4])/_aTot[1,1])*100),2)
	
	oSec11:PrintLine()
	aFill(aDados01,nil)
	
	oSec11:Finish()
	//fecha 0200000000000000000000000000000000000000000000000
	
	
	
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
	
	cQuery := " 	SELECT 'SP' AS EMP,
	cQuery += " SA3.A3_COD AS VEND,SA3.A3_NOME AS VENDN, VA3.A3_COD AS SUPER ,VA3.A3_NOME AS SUPERN ,
	cQuery += " NVL((SELECT nvl(SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END),0)
	cQuery += " FROM SC6010 SC6
	cQuery += " INNER JOIN(SELECT * FROM SC5010 )SC5
	cQuery += " ON SC6.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	cQuery += " INNER JOIN(SELECT * FROM SA1010 )SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD = SC6.C6_CLI
	cQuery += " AND SA1.A1_LOJA = SC6.C6_LOJA
	cQuery += " AND SA1.A1_FILIAL = ' '
	cQuery += " LEFT JOIN (SELECT * FROM PC1010) PC1
	cQuery += " ON C6_NUM = PC1.PC1_PEDREP
	cQuery += " AND PC1.D_E_L_E_T_ = ' '
	cQuery += " AND PC1.PC1_FILIAL = ' '
	cQuery += " WHERE  SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SC6.C6_FILIAL = '02'
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND PC1.PC1_PEDREP IS NULL
	cQuery += " AND  SC5.C5_VEND1 = SA3.A3_COD
	cQuery += " AND SUBSTR(SC5.C5_EMISSAO,1,6)  = '"+  MV_PAR01+MV_PAR02 +"'),0)
	cQuery += " AS CAPTACAO,
	
	cQuery += " NVL((SELECT SUM(ZZD.ZZD_VALOR)
	cQuery += " FROM ZZD010 ZZD WHERE  ZZD.D_E_L_E_T_ = ' '
	cQuery += " AND ZZD.ZZD_MES = '"+   MV_PAR02 +"'
	cQuery += " AND ZZD.ZZD_ANO = '"+  MV_PAR01  +"'
	cQuery += " AND ZZD.ZZD_FILIAL = '  '  AND ZZD.ZZD_VEND = SA3.A3_COD ),0)
	cQuery += " AS OBJETIVO,
	
	cQuery += " NVL((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
	cQuery += " FROM SF2010 SF2
	cQuery += " INNER JOIN(SELECT * FROM SD2010) SD2
	cQuery += " ON SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL
	cQuery += " AND SD2.D2_DOC = SF2.F2_DOC
	cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE
	cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " INNER JOIN(SELECT * FROM SA1010 ) SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '  '
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST <> 'EX'
	cQuery += " WHERE  SUBSTR(F2_EMISSAO,1,6) ='"+  MV_PAR01+MV_PAR02 +"'
	cQuery += " AND SF2.D_E_L_E_T_ = ' '
	cQuery += " AND SF2.F2_VEND1 = SA3.A3_COD
	cQuery += " AND SF2.F2_FILIAL = '02'),0)
	cQuery += " AS FATURAMENTO,
	
	cQuery += " NVL((SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += " FROM  SD1010  SD1
	cQuery += " INNER JOIN(SELECT * FROM   SA1010 )SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_TIPO = 'D'
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += " AND SA1.A1_FILIAL = '  '
	cQuery += " INNER JOIN(SELECT * FROM SF2010 )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += " AND SF2.F2_VEND1   =  SA3.A3_COD
	cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
	cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '04')
	cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) = '"+  MV_PAR01+MV_PAR02 +"' ),0)
	cQuery += " AS DEVOLUCAO
	
	cQuery += " FROM SA3010 SA3
	
	cQuery += " INNER JOIN(SELECT * FROM SA3010)VA3
	cQuery += " ON VA3.D_E_L_E_T_ = ' '
	cQuery += " AND VA3.A3_COD = SA3.A3_SUPER
	
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
	//cQuery += "  ORDER BY SA3.A3_SUPER
	
	cQuery += " UNION	SELECT 'AM' AS EMP,
	cQuery += " SA3.A3_COD AS VEND,SA3.A3_NOME AS VENDN, VA3.A3_COD AS SUPER ,VA3.A3_NOME AS SUPERN ,
	cQuery += " NVL((SELECT nvl(SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END),0)
	cQuery += " FROM SC6030 SC6
	cQuery += " INNER JOIN(SELECT * FROM SC5030 )SC5
	cQuery += " ON SC6.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	cQuery += " INNER JOIN(SELECT * FROM SA1030 )SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD = SC6.C6_CLI
	cQuery += " AND SA1.A1_LOJA = SC6.C6_LOJA
	cQuery += " AND SA1.A1_FILIAL = ' '
	cQuery += " LEFT JOIN (SELECT * FROM PC1030) PC1
	cQuery += " ON C6_NUM = PC1.PC1_PEDREP
	cQuery += " AND PC1.D_E_L_E_T_ = ' '
	cQuery += " AND PC1.PC1_FILIAL = ' '
	cQuery += " WHERE  SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SC6.C6_FILIAL = '01'
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND PC1.PC1_PEDREP IS NULL
	cQuery += " AND  SC5.C5_VEND1 = SA3.A3_COD
	cQuery += " AND SUBSTR(SC5.C5_EMISSAO,1,6)  = '"+  MV_PAR01+MV_PAR02 +"'),0)
	cQuery += " AS CAPTACAO,
	
	cQuery += " NVL((SELECT SUM(ZZD.ZZD_VALOR)
	cQuery += " FROM ZZD030 ZZD WHERE  ZZD.D_E_L_E_T_ = ' '
	cQuery += " AND ZZD.ZZD_MES = '"+   MV_PAR02 +"'
	cQuery += " AND ZZD.ZZD_ANO = '"+  MV_PAR01  +"'
	cQuery += " AND ZZD.ZZD_FILIAL = '  '  AND ZZD.ZZD_VEND = SA3.A3_COD ),0)
	cQuery += " AS OBJETIVO,
	
	cQuery += " NVL((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
	cQuery += " FROM SF2030 SF2
	cQuery += " INNER JOIN(SELECT * FROM SD2030) SD2
	cQuery += " ON SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL
	cQuery += " AND SD2.D2_DOC = SF2.F2_DOC
	cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE
	cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " INNER JOIN(SELECT * FROM SA1030 ) SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '  '
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST <> 'EX'
	cQuery += " WHERE  SUBSTR(F2_EMISSAO,1,6) ='"+  MV_PAR01+MV_PAR02 +"'
	cQuery += " AND SF2.D_E_L_E_T_ = ' '
	cQuery += " AND SF2.F2_VEND1 = SA3.A3_COD
	cQuery += " AND SF2.F2_FILIAL = '01'),0)
	cQuery += " AS FATURAMENTO,
	
	cQuery += " NVL((SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += " FROM  SD1030  SD1
	cQuery += " INNER JOIN(SELECT * FROM   SA1030 )SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_TIPO = 'D'
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += " AND SA1.A1_FILIAL = '  '
	cQuery += " INNER JOIN(SELECT * FROM SF2030 )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += " AND SF2.F2_VEND1   =  SA3.A3_COD
	cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
	cQuery += " AND  SD1.D1_FILIAL = '01'
	cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) = '"+  MV_PAR01+MV_PAR02 +"' ),0)
	cQuery += " AS DEVOLUCAO
	
	cQuery += " FROM SA3030 SA3
	
	cQuery += " INNER JOIN(SELECT * FROM SA3030)VA3
	cQuery += " ON VA3.D_E_L_E_T_ = ' '
	cQuery += " AND VA3.A3_COD = SA3.A3_SUPER
	
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
	
	
	//cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			
			If  (cAliasLif)->CAPTACAO <> 0 .Or.        (cAliasLif)->OBJETIVO <> 0  .Or. (cAliasLif)->FATURAMENTO <> 0 .Or. (cAliasLif)->DEVOLUCAO <> 0
				Aadd(_aRelT,{ (cAliasLif)->EMP,(cAliasLif)->VEND,Upper((cAliasLif)->VENDN),(cAliasLif)->SUPER,Upper((cAliasLif)->SUPERN),(cAliasLif)->CAPTACAO,(cAliasLif)->OBJETIVO,(cAliasLif)->FATURAMENTO,(cAliasLif)->DEVOLUCAO      })
			EndIf
			
			
			(cAliasLif)->(dbskip())
		End
	EndIf
	
	
	
	If Len(_aRelT) <= 0
		MsgInfo("Verifique os Parametros")
		Aadd(_aRelT,{ '','','','','',0,0,0,0})
	Else
		aSort(_aRelT,,,{|x,y| x[4]<y[4]})
	EndIf
	(cAliasLif)->(dbCloseArea())
Return()




