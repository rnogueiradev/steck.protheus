#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATDA        | Autor | RENATO.OLIVEIRA           | Data | 07/04/2021  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATDA()

	Local   oReport
	Private cPerg 			:= "RFATDA"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

/*====================================================================================\
|Programa  | ReportDef       | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de produtos",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de acessos a fornecedor")

	Pergunte(cPerg,.F.)

	oSection1 := TRSection():New(oReport,"SB1",{"SB1"})

	TRCell():New(oSection1,"01"	  			 ,,"Código"									,,TamSx3("B1_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02"	  			 ,,"Descrição"								,,TamSx3("B1_DESC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"03"	  			 ,,"Cód. Barras"							,,TamSx3("B1_CODBAR")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"04"	  			 ,,"Custo"									,,TamSx3("B2_CMFIM1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"05"	  			 ,,"Tensão"									,,TamSx3("B1_XTENSAO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"06"	  			 ,,"Corrente"								,,TamSx3("B1_XCORREN")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"07"	  			 ,,"Composição"								,,TamSx3("B1_XCOMPOS")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"08"	  			 ,,"NCM"									,,TamSx3("B1_POSIPI")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"09"	  			 ,,"Origem"									,,20,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"10"	  			 ,,"Cest"									,,TamSx3("B1_CEST")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"11"	  			 ,,"País"									,,20,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"12"	  			 ,,"Garantia"								,,20,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"13"	  			 ,,"Comprimento"							,,TamSx3("B5_COMPR")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"14"	  			 ,,"Espessura"								,,TamSx3("B5_ESPESS")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"15"	  			 ,,"Largura"								,,TamSx3("B5_LARG")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"16"	  			 ,,"Peso liq."								,,TamSx3("B1_PESO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"17"	  			 ,,"Peso bru."								,,TamSx3("B1_PESBRU")[1],.F.,,,,,,,.T.)

	TRCell():New(oSection1,"18"	  			 ,,"EAN141 - Cód."								,,TamSx3("B1_XEAN141")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"19"	  			 ,,"EAN141 - Tam"								,,TamSx3("B1_XLARCOL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"20"	  			 ,,"EAN141 - Alt"								,,TamSx3("B1_XALTCOL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"21"	  			 ,,"EAN141 - Prof"								,,TamSx3("B1_XPRFCOL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"22"	  			 ,,"EAN141 - Peso"								,,TamSx3("B1_XPESCOL")[1],.F.,,,,,,,.T.)

	TRCell():New(oSection1,"23"	  			 ,,"EAN142 - Cód."								,,TamSx3("B1_XEAN142")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"24"	  			 ,,"EAN142 - Tam"								,,TamSx3("B1_XLARMAS")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"25"	  			 ,,"EAN142 - Alt"								,,TamSx3("B1_XALTMAS")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"26"	  			 ,,"EAN142 - Prof"								,,TamSx3("B1_XPRFMAS")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"27"	  			 ,,"EAN142 - Peso"								,,TamSx3("B1_XPESMAS")[1],.F.,,,,,,,.T.)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SC5")

Return oReport

/*====================================================================================\
|Programa  | ReportPrint     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local aDados1[99]
	Local aDados2[99]
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _nX

	oSection1:Cell('01')      :SetBlock( { || aDados1[01] } )
	oSection1:Cell('02')      :SetBlock( { || aDados1[02] } )
	oSection1:Cell('03')      :SetBlock( { || aDados1[03] } )
	oSection1:Cell('04')      :SetBlock( { || aDados1[04] } )
	oSection1:Cell('05')      :SetBlock( { || aDados1[05] } )
	oSection1:Cell('06')      :SetBlock( { || aDados1[06] } )
	oSection1:Cell('07')      :SetBlock( { || aDados1[07] } )
	oSection1:Cell('08')      :SetBlock( { || aDados1[08] } )
	oSection1:Cell('09')      :SetBlock( { || aDados1[09] } )
	oSection1:Cell('10')      :SetBlock( { || aDados1[10] } )
	oSection1:Cell('11')      :SetBlock( { || aDados1[11] } )
	oSection1:Cell('12')      :SetBlock( { || aDados1[12] } )
	oSection1:Cell('13')      :SetBlock( { || aDados1[13] } )
	oSection1:Cell('14')      :SetBlock( { || aDados1[14] } )
	oSection1:Cell('15')      :SetBlock( { || aDados1[15] } )
	oSection1:Cell('16')      :SetBlock( { || aDados1[16] } )
	oSection1:Cell('17')      :SetBlock( { || aDados1[17] } )
	oSection1:Cell('18')      :SetBlock( { || aDados1[18] } )
	oSection1:Cell('19')      :SetBlock( { || aDados1[19] } )
	oSection1:Cell('20')      :SetBlock( { || aDados1[20] } )
	oSection1:Cell('21')      :SetBlock( { || aDados1[21] } )
	oSection1:Cell('22')      :SetBlock( { || aDados1[22] } )
	oSection1:Cell('23')      :SetBlock( { || aDados1[23] } )
	oSection1:Cell('24')      :SetBlock( { || aDados1[24] } )
	oSection1:Cell('25')      :SetBlock( { || aDados1[25] } )
	oSection1:Cell('26')      :SetBlock( { || aDados1[26] } )
	oSection1:Cell('27')      :SetBlock( { || aDados1[27] } )

	oReport:SetTitle("Relatório de produtos")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection1:Init()
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	If  Select(cAliasLif) > 0

		While (cAliasLif)->(!Eof())

			SB1->(DbSeek(xFilial("SB1")+(cAliasLif)->B1_COD))

			aDados1[01]	:= (cAliasLif)->B1_COD
			aDados1[02]	:= (cAliasLif)->B1_DESC
			aDados1[03]	:= (cAliasLif)->B1_CODBAR
			aDados1[04]	:= (cAliasLif)->B2_CMFIM1
			aDados1[05]	:= (cAliasLif)->B1_XTENSAO
			aDados1[06]	:= (cAliasLif)->B1_XCORREN
			aDados1[07]	:= (cAliasLif)->B1_XCOMPOS
			aDados1[08]	:= (cAliasLif)->B1_POSIPI
			aDados1[09]	:= (cAliasLif)->B1_ORIGEM
			aDados1[10]	:= (cAliasLif)->B1_CEST
			aDados1[11]	:= (cAliasLif)->B1_XPAIS
			aDados1[12]	:= (cAliasLif)->B1_GARANT
			aDados1[13]	:= (cAliasLif)->B5_COMPR
			aDados1[14]	:= (cAliasLif)->B5_ESPESS
			aDados1[15]	:= (cAliasLif)->B5_LARG
			aDados1[16]	:= (cAliasLif)->B1_PESO
			aDados1[17]	:= (cAliasLif)->B1_PESBRU
			
			aDados1[18]	:= "1"+SUBSTR(ALLTRIM(SB1->B1_CODBAR),1,12)+U_STEAN14F("1"+SUBSTR(ALLTRIM(SB1->B1_CODBAR),1,12))
			aDados1[19]	:= POSICIONE("CB3",1,XFILIAL("CB3")+SB1->B1_XEMBCOL,"CB3_XCOLLA")
			aDados1[20]	:= POSICIONE("CB3",1,XFILIAL("CB3")+SB1->B1_XEMBCOL,"CB3_XCOLAL")
			aDados1[21]	:= POSICIONE("CB3",1,XFILIAL("CB3")+SB1->B1_XEMBCOL,"CB3_XCOLPR")
			aDados1[22]	:= 0

			aDados1[23]	:= "2"+SUBSTR(ALLTRIM(SB1->B1_CODBAR),1,12)+U_STEAN14F("2"+SUBSTR(ALLTRIM(SB1->B1_CODBAR),1,12))
			aDados1[24]	:= POSICIONE("CB3",1,XFILIAL("CB3")+SB1->B1_XEMBMAS,"CB3_XMTRLA")
			aDados1[25]	:= POSICIONE("CB3",1,XFILIAL("CB3")+SB1->B1_XEMBMAS,"CB3_XMTRAL")
			aDados1[26]	:= POSICIONE("CB3",1,XFILIAL("CB3")+SB1->B1_XEMBMAS,"CB3_XMTRPR")
			aDados1[27]	:= 0

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()

Return oReport

/*====================================================================================\
|Programa  | StQuery	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function StQuery()

	Local cQuery     := ' '
	Local nReg

	cQuery := " SELECT B1_COD, B1_DESC, B1_CODBAR, B2_CMFIM1, B1_XTENSAO, B1_XCORREN, 
	cQuery += " X5_DESCRI B1_XCOMPOS, B1_POSIPI, B1_ORIGEM, B1_CEST, B1_XPAIS, B1_GARANT,
	cQuery += " B5_COMPR, B5_ESPESS, B5_LARG, B1_PESO, B1_PESBRU
	cQuery += " FROM SB1010 B1
	cQuery += " LEFT JOIN SB2010 B2
	cQuery += " ON B2_FILIAL='02' AND B2_LOCAL=B1_LOCPAD AND B2_COD=B1_COD AND B2.D_E_L_E_T_=' ' 
	cQuery += " LEFT JOIN DA1010 DA1
	cQuery += " ON DA1_CODTAB='001' AND DA1_CODPRO=B1_COD
	cQuery += " LEFT JOIN SX5010 X5
	cQuery += " ON X5_TABELA='Z1' AND X5_CHAVE=B1_XCOMPOS AND X5.D_E_L_E_T_=' ' 
	cQuery += " LEFT JOIN SB5010 B5
	cQuery += " ON B5_COD=B1_COD AND B5.D_E_L_E_T_=' ' 
	cQuery += " WHERE B1.D_E_L_E_T_=' ' AND DA1.D_E_L_E_T_=' ' 
	cQuery += " AND B1_TIPO='PA'	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
