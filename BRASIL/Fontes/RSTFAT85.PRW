#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT85     บAutor  ณRenato Nogueira บ Data ณ  29/06/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio aba dados logํsticos		                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSTFAT85()

Local   oReport
Private cPerg 			:= "RFAT85"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

Ajusta()

oReport		:= ReportDef()
oReport:PrintDialog()

FreeObj(oReport)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณRenato Nogueira     บ Data ณ  22/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
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

oReport := TReport():New(cPergTit,"Relat๓rio dos dados logํsticos",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio dos dados logํsticos do produto")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Produtos",{"SB1"})

	TRCell():New(oSection,"B1COD"	  			 ,,"CODIGO"					,"@!"		   				,15  ,.F.,)
	TRCell():New(oSection,"B1DESC"			 	 ,,"DESCRICAO"				,"@!"		   				,50 ,.F.,)
	TRCell():New(oSection,"B1CODBAR"			 ,,"COD BAR"				,"@!" 			   			,15 ,.F.,)
	TRCell():New(oSection,"B5COMPR"				 ,,"COMPRIMENTO"			,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"B5LARG"				 ,,"LARGURA"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"B5ESPESS"			 ,,"ESPESSURA"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"B1PESO"				 ,,"PESO"					,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"B1COD141"			 ,,"COL 141"				,"@!" 			   			,15 ,.F.,)
	TRCell():New(oSection,"CB3DESCRI"			 ,,"COL TP EMB"				,"@!" 			   			,30 ,.F.,)
	TRCell():New(oSection,"CB3CODEMB"			 ,,"COL COD EMB"			,"@!" 			   			,3  ,.F.,)
	TRCell():New(oSection,"B5EAN141"			 ,,"COL QTEAN1"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"CB3XCOLAL"			 ,,"COL ALTURA"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"CB3XCOLLA"			 ,,"COL LARGUR"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"CB3XCOLPR"			 ,,"COL PROFUN"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"CB3VOLUME"			 ,,"COL VOLUME"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"CB3XCOLPE"			 ,,"COL PESO"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"B1COD142"			 ,,"COL 142"				,"@!" 			   			,15 ,.F.,)
	TRCell():New(oSection,"MTRCB3DESCRI"		 ,,"MTR TP EMB"				,"@!" 			   			,30 ,.F.,)
	TRCell():New(oSection,"MTRCODEMB"			 ,,"MTR COD EMB"			,"@!" 			   			,3  ,.F.,)
	TRCell():New(oSection,"MTRB5EAN142"			 ,,"MTR QTEAN2"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"MTRXCOLAL"			 ,,"MTR ALTURA"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"MTRXCOLLA"			 ,,"MTR LARGUR"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"MTRXCOLPR"			 ,,"MTR PROFUN"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"MTRVOLUME"			 ,,"MTR VOLUME"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"MTRXCOLPE"			 ,,"MTR PESO"				,"@E 999,999,999.99"  		,12 ,.F.,)
	TRCell():New(oSection,"B1GROUP"			 	 ,,"GRUPO"					,"@!"				  		,4 	,.F.,) 
	
	//Leandro Godoy - TKT 20220615012246
	TRCell():New(oSection,"B1DESENHO"		 	 ,,"DESENHO"				,"@!"				  		,20	,.F.,)
	TRCell():New(oSection,"B1LEGADO"		 	 ,,"COD LEGADO"				,"@!"				  		,15	,.F.,)
	TRCell():New(oSection,"B1TIPO"			 	 ,,"TIPO"					,"@!"				  		,2 	,.F.,)
	TRCell():New(oSection,"B1PESBRU"		 	 ,,"PESO BRUTO"				,"@!"				  		,11	,.F.,)
	TRCell():New(oSection,"B1MSBLQL"		 	 ,,"BLOQUEADO"				,"@!"				  		,11	,.F.,)
	TRCell():New(oSection,"B1XDESAT"		 	 ,,"DESATIVADO"				,"@!"				  		,11	,.F.,)
	
oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SB1")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrintบAutor  ณRenato Nogueira     บ Data ณ  22/07/14  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
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
Local aDados1[32] ////Leandro Godoy - TKT 20220615012246, valor antigo 26
Local cCodOpe	:= ""
Local lImprime	:= .F.
Local cHoraFim	:= ""
Local cOrdSep	:= ""         
Local nHours
Local nMinuts
Local nSeconds

	oSection1:Cell("B1COD")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("B1DESC")    		:SetBlock( { || aDados1[02] } )
	oSection1:Cell("B1CODBAR")    		:SetBlock( { || aDados1[03] } )
	oSection1:Cell("B5COMPR")    		:SetBlock( { || aDados1[04] } )
	oSection1:Cell("B5LARG")    		:SetBlock( { || aDados1[05] } )
	oSection1:Cell("B5ESPESS")    		:SetBlock( { || aDados1[06] } )
	oSection1:Cell("B1PESO")    		:SetBlock( { || aDados1[07] } )
	oSection1:Cell("B1COD141")    		:SetBlock( { || aDados1[08] } )
	oSection1:Cell("CB3DESCRI")    		:SetBlock( { || aDados1[09] } )
	oSection1:Cell("CB3CODEMB")    		:SetBlock( { || aDados1[10] } )
	oSection1:Cell("B5EAN141")    		:SetBlock( { || aDados1[11] } )
	oSection1:Cell("CB3XCOLAL")    		:SetBlock( { || aDados1[12] } )
	oSection1:Cell("CB3XCOLLA")    		:SetBlock( { || aDados1[13] } )
	oSection1:Cell("CB3XCOLPR")    		:SetBlock( { || aDados1[14] } )
	oSection1:Cell("CB3VOLUME")    		:SetBlock( { || aDados1[15] } )
	oSection1:Cell("CB3XCOLPE")    		:SetBlock( { || aDados1[16] } )
	oSection1:Cell("B1COD142")    		:SetBlock( { || aDados1[17] } )
	oSection1:Cell("MTRCB3DESCRI")   	:SetBlock( { || aDados1[18] } )
	oSection1:Cell("MTRCODEMB")    		:SetBlock( { || aDados1[19] } )
	oSection1:Cell("MTRB5EAN142")    	:SetBlock( { || aDados1[20] } )
	oSection1:Cell("MTRXCOLAL") 	   	:SetBlock( { || aDados1[21] } )
	oSection1:Cell("MTRXCOLLA")   	 	:SetBlock( { || aDados1[22] } )
	oSection1:Cell("MTRXCOLPR")   	 	:SetBlock( { || aDados1[23] } )
	oSection1:Cell("MTRVOLUME")  	  	:SetBlock( { || aDados1[24] } )
	oSection1:Cell("MTRXCOLPE") 	   	:SetBlock( { || aDados1[25] } )
	oSection1:Cell("B1GROUP") 	   		:SetBlock( { || aDados1[26] } )

//Leandro Godoy - TKT 20220615012246
	oSection1:Cell("B1DESENHO")	   		:SetBlock( { || aDados1[27] } )
	oSection1:Cell("B1LEGADO") 	   		:SetBlock( { || aDados1[28] } )
	oSection1:Cell("B1TIPO") 	   		:SetBlock( { || aDados1[29] } )
	oSection1:Cell("B1PESBRU") 	   		:SetBlock( { || aDados1[30] } )
	oSection1:Cell("B1MSBLQL") 	   		:SetBlock( { || aDados1[31] } )
	oSection1:Cell("B1XDESAT") 	   		:SetBlock( { || aDados1[32] } )

oReport:SetTitle("Produto - Dados logํsticos")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	
	If  Select(cAliasLif) > 0
		
		While (cAliasLif)->(!Eof())
			
			aDados1[01]	:=	(cAliasLif)->B1COD
			aDados1[02]	:=	(cAliasLif)->B1DESC
			aDados1[03]	:=	(cAliasLif)->B1CODBAR
			aDados1[04]	:= 	(cAliasLif)->B5COMPR
			aDados1[05]	:=	(cAliasLif)->B5LARG
			aDados1[06]	:=	(cAliasLif)->B5ESPESS
			aDados1[07]	:= 	(cAliasLif)->B1PESO
			aDados1[08]	:=	"1"+SUBSTR(ALLTRIM((cAliasLif)->B1CODBAR),1,12)+U_STEAN14F("1"+SUBSTR(ALLTRIM((cAliasLif)->B1CODBAR),1,12))
			aDados1[09]	:=	(cAliasLif)->CB3DESCRI
			aDados1[10]	:=	(cAliasLif)->CB3CODEMB
			aDados1[11]	:=	(cAliasLif)->B5EAN141
			aDados1[12]	:=	(cAliasLif)->CB3XCOLAL
			aDados1[13]	:=	(cAliasLif)->CB3XCOLLA
			aDados1[14]	:=	(cAliasLif)->CB3XCOLPR
			aDados1[15]	:=	(cAliasLif)->CB3VOLUME
			aDados1[16]	:=	(cAliasLif)->CB3XCOLPE
			aDados1[17]	:=	"2"+SUBSTR(ALLTRIM((cAliasLif)->B1CODBAR),1,12)+U_STEAN14F("2"+SUBSTR(ALLTRIM((cAliasLif)->B1CODBAR),1,12))
			aDados1[18]	:=	(cAliasLif)->MTRCB3DESCRI
			aDados1[19]	:=	(cAliasLif)->MTRCODEMB
			aDados1[20]	:=	(cAliasLif)->MTRB5EAN142
			aDados1[21]	:=	(cAliasLif)->MTRXCOLAL
			aDados1[22]	:=	(cAliasLif)->MTRXCOLLA
			aDados1[23]	:=	(cAliasLif)->MTRXCOLPR
			aDados1[24]	:=	(cAliasLif)->MTRVOLUME
			aDados1[25]	:=	(cAliasLif)->MTRXCOLPE
			aDados1[26]	:=	(cAliasLif)->B1GROUP

			//Leandro Godoy - TKT 20220615012246
			aDados1[27]	:=	(cAliasLif)->B1DESENHO
			aDados1[28]	:=	(cAliasLif)->B1LEGADO
			aDados1[29]	:=	(cAliasLif)->B1TIPO
			aDados1[30]	:=	(cAliasLif)->B1PESBRU
			aDados1[31]	:=	(cAliasLif)->B1MSBLQL
			aDados1[32]	:=	(cAliasLif)->B1XDESAT

			oSection1:PrintLine()
			aFill(aDados1,nil)
			
			(cAliasLif)->(dbskip())
			
		EndDo

		oReport:SkipLine()
		
	EndIf
	
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณRenato Nogueira บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(cCodOpe)
*-----------------------------*

Local cQuery     := ' '

	cQuery := " SELECT B1_COD B1COD, "
	cQuery += " B1_DESC B1DESC, "
	cQuery += " B1_CODBAR B1CODBAR, "
	cQuery += " B5_COMPR B5COMPR, "
	cQuery += " B5_LARG B5LARG, "
	cQuery += " B5_ESPESS B5ESPESS, "
	cQuery += " B1_PESO B1PESO, "
	cQuery += " B1_GRUPO B1GROUP, "

	//Leandro Godoy - TKT 20220615012246
	cQuery += " B1_XDESENH B1DESENHO, B1_XCODSTE B1LEGADO, B1_TIPO B1TIPO, B1_PESBRU B1PESBRU, "
	cQuery += " CASE B1_MSBLQL WHEN '1' THEN 'S' WHEN '2' THEN 'N' ELSE 'N' END AS B1MSBLQL, "
	cQuery += " CASE B1_XDESAT WHEN '1' THEN 'S' WHEN '2' THEN 'N' ELSE 'N' END AS B1XDESAT, "


	cQuery += " (SELECT CB3_DESCRI FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBCOL=CB3_CODEMB AND CB3_FILIAL='01') CB3DESCRI, "
	cQuery += " (SELECT CB3_CODEMB FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBCOL=CB3_CODEMB AND CB3_FILIAL='01') CB3CODEMB, "
	cQuery += " B5_EAN141 B5EAN141, "
	cQuery += " (SELECT CB3_XCOLAL FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBCOL=CB3_CODEMB AND CB3_FILIAL='01') CB3XCOLAL, "
	cQuery += " (SELECT CB3_XCOLLA FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBCOL=CB3_CODEMB AND CB3_FILIAL='01') CB3XCOLLA, "
	cQuery += " (SELECT CB3_XCOLPR FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBCOL=CB3_CODEMB AND CB3_FILIAL='01') CB3XCOLPR, "
	cQuery += " (SELECT CB3_VOLUME FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBCOL=CB3_CODEMB AND CB3_FILIAL='01') CB3VOLUME, "
	cQuery += " (SELECT CB3_XCOLPE FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBCOL=CB3_CODEMB AND CB3_FILIAL='01') CB3XCOLPE, "
	cQuery += " (SELECT CB3_DESCRI FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBMAS=CB3_CODEMB AND CB3_FILIAL='01') MTRCB3DESCRI, "
	cQuery += " (SELECT CB3_CODEMB FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBMAS=CB3_CODEMB AND CB3_FILIAL='01') MTRCODEMB, "
	cQuery += " B5_EAN142 MTRB5EAN142, "
	cQuery += " (SELECT CB3_XMTRAL FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBMAS=CB3_CODEMB AND CB3_FILIAL='01') MTRXCOLAL, "
	cQuery += " (SELECT CB3_XMTRLA FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBMAS=CB3_CODEMB AND CB3_FILIAL='01') MTRXCOLLA, "
	cQuery += " (SELECT CB3_XMTRPR FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBMAS=CB3_CODEMB AND CB3_FILIAL='01') MTRXCOLPR, "
	cQuery += " (SELECT CB3_VOLUME FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBMAS=CB3_CODEMB AND CB3_FILIAL='01') MTRVOLUME, "
	cQuery += " (SELECT CB3_XMTRPE FROM "+RetSqlName("CB3")+" B3 WHERE B1_XEMBMAS=CB3_CODEMB AND CB3_FILIAL='01') MTRXCOLPE "
	cQuery += " FROM "+RetSqlName("SB1")+" B1 "
	cQuery += " LEFT JOIN "+RetSqlName("SB5")+" B5 "
	cQuery += " ON B1_COD=B5_COD "
	cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B5.D_E_L_E_T_=' ' "
	cQuery += " AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += " AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += " AND B1_TIPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณAjusta    ณ Autor ณ Vitor Merguizo 		  ณ Data ณ 16/08/2012		ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	ณฑฑ
ฑฑณ          ณ no SX3                                                           	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe e ณ 																		ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Produto de ?  		       ","Produto de ?     		       ","Produto de ?       	       ","mv_ch1","C",15,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Produto ate ?     		   ","Produto ate ?    		       ","Produto ate ?      	       ","mv_ch2","C",15,0,0,"G",""                    ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})

//AjustaSx1(cPerg,aPergs)

Return
