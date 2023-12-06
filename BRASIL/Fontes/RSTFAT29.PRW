#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT29     บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio GRUPO DE CLIENTE		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT29()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT29"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif


PutSx1(cPerg, "01", "Do Ano:" 	,"Da Ano: ?" 		,"Da Ano: ?" 		,"mv_ch1","C",4,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Ate Ano:" 	,"Ate Ano: ?" 		,"Ate Ano: ?" 		,"mv_ch2","C",4,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Do Mes:" 	,"Do Mes: ?" 	,"Do Mes: ?" 			,"mv_ch3","C",2,0,0,"G","",'' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Mes:"  ,"Ate Mes: ?" ,"Ate Mes: ?" 			,"mv_ch4","C",2,0,0,"G","",'' ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "Tipo "     ,"",""									,"mv_ch5","N",1,0,2,"C","","","","","mv_par05","Faturamento","","","","Capta็ใo","","","","","","","","","","","")


oReport		:= ReportDef()
 oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio GRUPO DE CLIENTE				                          บฑฑ
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

oReport := TReport():New(cPergTit,"RELATำRIO GRUPO DE CLIENTE",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de Comissใo")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Comissใo",{"SC5"})




Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio GRUPO DE CLIENTE				                          บฑฑ
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
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[5]
Local _cSta 	:= ''

TRCell():New(oSection,"GRUPO"	  	,,"GRUPO"		,,4,.F.,)
TRCell():New(oSection,"NOME"  		,,"NOME"	,,25,.F.,)
TRCell():New(oSection,Mv_Par01       	,,Mv_Par01			,"@E 99,999,999.99",14)
TRCell():New(oSection,Mv_Par02       	,,Mv_Par02		,"@E 99,999,999.99",14)
TRCell():New(oSection,'EVOLUCAO'       	,,'EVOLUCAO'			,"@E 99,999,999.99",14)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC5")




oSection1:Cell("GRUPO")    	:SetBlock( { || aDados1[01] } )
oSection1:Cell("NOME")  	:SetBlock( { || aDados1[02] } )
oSection1:Cell(Mv_Par01)  		:SetBlock( { || aDados1[03] } )
oSection1:Cell(Mv_Par02)       :SetBlock( { || aDados1[04] } )
oSection1:Cell('EVOLUCAO')  	:SetBlock( { || aDados1[05] } )


oReport:SetTitle("GRUPO DE CLIENTE")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
		aDados1[01]	:=	(cAliasLif)->GRUPO
		aDados1[02]	:= 	(cAliasLif)->DESCRICAO
		If Mv_par05 = 1
			aDados1[03]	:=  (cAliasLif)->DE  - (cAliasLif)->DEV_DE
			aDados1[04]	:= 	(cAliasLif)->ATE - (cAliasLif)->DEV_ATE
		Else
			aDados1[03]	:=  (cAliasLif)->DE
			aDados1[04]	:= 	(cAliasLif)->ATE
		EndIf
		aDados1[05]	:=  ((aDados1[04]*100)/aDados1[03])-100
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		
		
		(cAliasLif)->(dbskip())
		
	End
	
	
	
EndIf



oReport:SkipLine()




Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio GRUPO DE CLIENTE				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

Local cQuery     := ' '

If Mv_par05 = 1
	cQuery := " SELECT
	cQuery += " ACY_GRPVEN
	cQuery += ' "GRUPO" ,
	cQuery += " ACY_DESCRI
	cQuery += ' "DESCRICAO" ,
	
	cQuery += " (SELECT
	cQuery += " NVL(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM )	,0)
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD  = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
	cQuery += " AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN 
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'  
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'  
	cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,6)   BETWEEN '"+Mv_Par01+Mv_Par03+"'   AND '"+Mv_Par01+Mv_Par04+"' )
	cQuery += ' "DE" ,
	
	
	cQuery += " (SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_TIPO = 'D'
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
	cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
	cQuery += " AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN
	cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6)
	cQuery += " BETWEEN '"+Mv_Par01+Mv_Par03+"'   AND '"+Mv_Par01+Mv_Par04+"' )
	cQuery += ' "DEV_DE",
	
	
	cQuery += " (SELECT
	cQuery += " NVL(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM )	,0)
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD  = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " AND SA1.A1_GRPVEN <> 'ST' 
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
	cQuery += " AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN   
	cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')


	cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,6)  BETWEEN '"+Mv_Par02+Mv_Par03+"'   AND '"+Mv_Par02+Mv_Par04+"' )
	cQuery += ' "ATE" ,
	
	cQuery += " (SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_TIPO = 'D'
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
	cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
	cQuery += " AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN
	cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6)
	cQuery += " BETWEEN  '"+Mv_Par02+Mv_Par03+"'   AND '"+Mv_Par02+Mv_Par04+"' )
	cQuery += ' "DEV_ATE"
	
	
	cQuery += " FROM "+RetSqlName("ACY")+" ACY "
	cQuery += " WHERE ACY.D_E_L_E_T_ = ' '
	cQuery += " AND ACY.ACY_FILIAL = '"+xFilial("ACY")+"'"
	
	cQuery += " ORDER BY ACY_GRPVEN
	
Else
	
	cQuery += " SELECT ACY_GRPVEN
	cQuery += ' "GRUPO",
	cQuery += " ACY_DESCRI
	cQuery += ' "DESCRICAO",
	
	cQuery += " (SELECT
	cQuery += " nvl(SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END),0)
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC6.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD = SC6.C6_CLI
	cQuery += " AND SA1.A1_LOJA = SC6.C6_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	
	cQuery += " LEFT JOIN (SELECT * FROM PC1010) PC1
	cQuery += " ON C6_NUM = PC1.PC1_PEDREP
	cQuery += " AND PC1.D_E_L_E_T_ = ' '
	cQuery += " AND PC1.PC1_FILIAL = '"+xFilial("PC1")+"'"
	    /*
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
	cQuery += " AND SF4.D_E_L_E_T_ = ' '
	cQuery += " AND SF4.F4_DUPLIC = 'S'
	   */
	cQuery += " WHERE  SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SC6.C6_FILIAL = '02'
	cQuery += " AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST' 
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND PC1.PC1_PEDREP IS NULL
	cQuery += " AND SUBSTR(SC5.C5_EMISSAO,1,6)
	cQuery += " BETWEEN '"+Mv_Par01+Mv_Par03+"'   AND '"+Mv_Par01+Mv_Par04+"' )
	cQuery += ' "DE",
	
	cQuery += " (SELECT
	cQuery += " nvl(SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END),0)
	cQuery += " FROM "+RetSqlName("SC6")+"  SC6 "
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC6.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD = SC6.C6_CLI
	cQuery += " AND SA1.A1_LOJA = SC6.C6_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	
	cQuery += " LEFT JOIN (SELECT * FROM "+RetSqlName("PC1")+" )PC1 "
	cQuery += " ON C6_NUM = PC1.PC1_PEDREP
	cQuery += " AND PC1.D_E_L_E_T_ = ' '
	cQuery += " AND PC1.PC1_FILIAL = '"+xFilial("PC1")+"'"
	/*
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
	cQuery += " AND SF4.D_E_L_E_T_ = ' '
	cQuery += " AND SF4.F4_DUPLIC = 'S'
	*/
	cQuery += " WHERE  SC6.D_E_L_E_T_ = ' ' 
		cQuery += " AND SC6.C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SC6.C6_FILIAL = '02' 
   //	cQuery += " AND SC6.C6_OPER = '01'
	cQuery += " AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND PC1.PC1_PEDREP IS NULL
	cQuery += " AND SUBSTR(SC5.C5_EMISSAO,1,6)
	cQuery += " BETWEEN '"+Mv_Par02+Mv_Par03+"'   AND '"+Mv_Par02+Mv_Par04+"' )
	cQuery += ' "ATE"
	
	cQuery += " FROM ACY010 ACY
	cQuery += " WHERE  ACY.D_E_L_E_T_ = ' '
	cQuery += " AND ACY.ACY_FILIAL = '"+xFilial("ACY")+"'"
	cQuery += " ORDER BY  ACY_GRPVEN
	
	
EndIf




cQuery := ChangeQuery(cQuery)
//SELECT ACY_GRPVEN "GRUPO",ACY_DESCRI "DESCRICAO",(SELECT COALESCE(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM),0) FROM SD2010 SD2 INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_FILIAL = '  '  WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01') AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST <> 'EX' AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND SUBSTR(SD2.D2_EMISSAO,1,6) BETWEEN '201403' AND '201403' )  "DE",(SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  '  WHERE  SD1.D_E_L_E_T_ = ' ' AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '201403' AND '201403' )  "DEV_DE",(SELECT COALESCE(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM),0) FROM SD2010 SD2 INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_FILIAL = '  ' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST <> 'EX'  WHERE  SD2.D_E_L_E_T_ = ' ' AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01') AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND SUBSTR(SD2.D2_EMISSAO,1,6) BETWEEN '201403' AND '201403' )  "ATE",(SELECT COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) FROM SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  '  WHERE  SD1.D_E_L_E_T_ = ' ' AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') AND SA1.A1_GRPVEN = ACY.ACY_GRPVEN AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '201403' AND '201403' )  "DEV_ATE" FROM ACY010 ACY WHERE  ACY.D_E_L_E_T_ = ' ' AND ACY.ACY_FILIAL = '  '  ORDER BY  ACY_GRPVEN
If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

