#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRSTFAT49  บAutor  ณRenato Nogueira     บ Data ณ  22/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de separa็ใo			                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Expedi็ใo                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT49()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT49"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	PutSx1(cPerg, "01", "OS de:"	 					, "OS de:"	 		, "OS de:"	 		,"mv_ch1","C",6,0,0,"G","",'CB7'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "OS ate:"	 					, "OS ate:"	 		, "OS ate:"	 		,"mv_ch2","C",6,0,0,"G","",'CB7'    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Emissao de:" 					,"Emissao de: ?" 	,"Emissao de: ?"	,"mv_ch3","D",8,0,0,"G","",''    	 ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Emissao ate:" 					,"Emissao ate: ?" 	,"Emissao ate: ?"	,"mv_ch4","D",8,0,0,"G","",''    	 ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05","(S) Sint้tico ou (A) Analํtico?","(S) Sint้tico ou (A) Analํtico?","(S) Sint้tico ou (A) Analํtico?","mv_ch5","C",1,0,0,"G","",''    	 ,"","","mv_par05","","","","","","","","","","","","","","","","")

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

	oReport := TReport():New(cPergTit,"Relat๓rio de separa็ใo",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de separa็ใo")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Separa็ใo",{"CB7"})

	If mv_par05="S"
	
		TRCell():New(oSection,"FILIAL"	  			 ,,"FILIAL"				,"@!"			   		,2 ,.F.,)
		TRCell():New(oSection,"OPERADOR"			 ,,"OPERADOR"			,"@!" 			   		,6 ,.F.,)
		TRCell():New(oSection,"NOMEOPE"				 ,,"NOME DO OPERADOR"	,"@!" 			   		,20,.F.,)
		TRCell():New(oSection,"INTER"				 ,,"HORAS INTERVALO"	,"@!"				  	,12,.F.,)
		TRCell():New(oSection,"HORAS"				 ,,"HORAS CORRIDAS"		,"@!"				  	,12,.F.,)
		TRCell():New(oSection,"QTDE"				 ,,"QUANTIDADE"			,"@E 999,999,999.99"  	,12,.F.,)
		TRCell():New(oSection,"LINQTDE"				 ,,"QUANTIDADE LINHAS"	,"@E 999,999,999.99"  	,12,.F.,)
		TRCell():New(oSection,"PECQTDE"				 ,,"QUANTIDADE PECAS"	,"@E 999,999,999.99"  	,12,.F.,)
	
	Else
	
		TRCell():New(oSection,"FILIAL"	  			 ,,"FILIAL"				,"@!"			   		,2 ,.F.,)
		TRCell():New(oSection,"OPERADOR"			 ,,"OPERADOR"			,"@!" 			   		,6 ,.F.,)
		TRCell():New(oSection,"NOMEOPE"				 ,,"NOME DO OPERADOR"	,"@!" 			   		,20,.F.,)
		TRCell():New(oSection,"ORDSEP"  			 ,,"ORDEM DE SEPARACAO"	,"@!" 			   		,6 ,.F.,)
		TRCell():New(oSection,"PEDIDO"  			 ,,"PEDIDO"				,"@!" 			   		,6 ,.F.,)
		//TRCell():New(oSection,"EMISDT"			 ,,"DATA EMISSAO"		,"@!" 			   		,10,.F.,)
		//TRCell():New(oSection,"ITEM"	  			 ,,"ITEM"				,"@!" 			   		,2 ,.F.,)
		TRCell():New(oSection,"PRODUTO"	  			 ,,"PRODUTO"			,"@!" 			   		,15,.F.,)
		TRCell():New(oSection,"DESC"	  			 ,,"DESCRICAO"			,"@!" 			   		,50,.F.,)
		TRCell():New(oSection,"GRUPO"	  			 ,,"GRUPO"				,"@!" 			   		,10,.F.,)
		TRCell():New(oSection,"DESC_GRUPO"	  		 ,,"DESC GRUPO PROD OP"	,"@!" 			   		,30,.F.,)
		TRCell():New(oSection,"QTDE"				 ,,"QUANTIDADE"			,"@E 999,999,999.99"  	,12,.F.,)
		TRCell():New(oSection,"LCALIZ"	  			 ,,"LOCALIZACAO"		,"@!" 			   		,15,.F.,)
		TRCell():New(oSection,"INICIODT"			 ,,"DATA INICIO"		,"@!" 			   		,10,.F.,)
		TRCell():New(oSection,"H_INICIO"			 ,,"H_INICIO"			,"@!" 			   		,10,.F.,)
		TRCell():New(oSection,"INICIOHR"			 ,,"HORA INICIO"		,"@!" 			   		,10,.F.,)
		TRCell():New(oSection,"DIFERHR"			 	 ,,"DIFERENCA INICIO"	,"@!" 			   		,10,.F.,)
		TRCell():New(oSection,"FIMDT"				 ,,"FIM INICIO"			,"@!" 			   		,10,.F.,)
		TRCell():New(oSection,"FIMHR"				 ,,"HR FIM INICIO"		,"@!" 			   		,10,.F.,)
		//TRCell():New(oSection,"H_FIM"				 ,,"H_FIM"				,"@!" 			   		,10,.F.,)
		//TRCell():New(oSection,"DIAS"				 ,,"DIAS CORRIDOS"		,"999" 			   		,3 ,.F.,)
		//TRCell():New(oSection,"HORAS"				 ,,"HORAS CORRIDAS"		,"@!" 			   		,10,.F.,)
		//TRCell():New(oSection,"INTER"				 ,,"HORAS INTERVALOS"	,"@!" 			   		,10,.F.,)
	
		TRFunction():New(oSection:Cell("QTDE"),NIL,"SUM",,,,,.F.,.T.)
		
	EndIf

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("CB8")
	oSection:Setnofilter("CB7")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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
	Local aDados[8]
	Local aDados1[22]
	Local cCodOpe	:= ""
	Local lImprime	:= .F.
	Local cHoraFim	:= ""
	Local cOrdSep	:= ""
	Local nHours
	Local nMinuts
	Local nSeconds

	If mv_par05="S"
	
		oSection:Cell("FILIAL")    			:SetBlock( { || aDados[01] } )
		oSection:Cell("OPERADOR")  			:SetBlock( { || aDados[02] } )
		oSection:Cell("NOMEOPE")  				:SetBlock( { || aDados[03] } )
		oSection:Cell("HORAS")		  			:SetBlock( { || aDados[04] } )
		oSection:Cell("INTER")		  			:SetBlock( { || aDados[05] } )
		oSection:Cell("QTDE")		  			:SetBlock( { || aDados[06] } )
		oSection:Cell("LINQTDE")	  			:SetBlock( { || aDados[07] } )
		oSection:Cell("PECQTDE")	  			:SetBlock( { || aDados[08] } )
	
	Else
	
		oSection1:Cell("FILIAL")    			:SetBlock( { || aDados1[01] } )
		oSection1:Cell("OPERADOR")  			:SetBlock( { || aDados1[02] } )
		oSection1:Cell("NOMEOPE")  				:SetBlock( { || aDados1[03] } )
		oSection1:Cell("ORDSEP")       	   		:SetBlock( { || aDados1[04] } )
		oSection1:Cell("PEDIDO")	  			:SetBlock( { || aDados1[05] } )
//		oSection1:Cell("EMISDT")	  			:SetBlock( { || aDados1[06] } )
//		oSection1:Cell("ITEM")		  			:SetBlock( { || aDados1[07] } )
		oSection1:Cell("PRODUTO")	  			:SetBlock( { || aDados1[08] } )
		oSection1:Cell("DESCRICAO")           	:SetBlock( { || aDados1[09] } )
		oSection1:Cell("GRUPO")           		:SetBlock( { || aDados1[10] } )
		oSection1:Cell("DESC_GRUPO")        	:SetBlock( { || aDados1[22] } )
		oSection1:Cell("INICIODT")	  			:SetBlock( { || aDados1[11] } )
		oSection1:Cell("INICIOHR")	  			:SetBlock( { || aDados1[12] } )
		oSection1:Cell("FIMDT")		  			:SetBlock( { || aDados1[13] } )
		oSection1:Cell("FIMHR")	 	 			:SetBlock( { || aDados1[14] } )
		//oSection1:Cell("DIAS")	  			:SetBlock( { || aDados1[13] } )
		//oSection1:Cell("HORAS")		  		:SetBlock( { || aDados1[15] } )
		oSection1:Cell("QTDE")		  			:SetBlock( { || aDados1[16] } )
		oSection1:Cell("LCALIZ")	  			:SetBlock( { || aDados1[17] } )
		//oSection1:Cell("INTER")		  		:SetBlock( { || aDados1[18] } )
		//Chamado 005340 - Robson Mazzarotto
		oSection1:Cell("H_INICIO")	  			:SetBlock( { || aDados1[19] } )
		//oSection1:Cell("H_FIM")		  		:SetBlock( { || aDados1[20] } )
		oSection1:Cell("DIFERHR")	  			:SetBlock( { || aDados1[21] } )

	EndIf

	oReport:SetTitle("Separa็ใo")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	If mv_par05="S"
	
		Processa({|| StQuery() },"Compondo Relatorio")
	
		DbSelectArea(cAliasLif)
		(cAliasLif)->(DbGoTop())
	
		aDados[04]	:= 0
		aDados[05]	:= 0
		aDados[06]	:= 0
		aDados[07]	:= 0
		aDados[08]	:= 0
	
		If  Select(cAliasLif) > 0
		
			While (cAliasLif)->(!Eof())
			
				If !Empty(cCodOpe) .And. cCodOpe<>(cAliasLif)->CB7_CODOPE
					aDados[04]	:= SecsToHMS( aDados[04],@nHours,@nMinuts,@nSeconds)
					aDados[05]	:= SecsToHMS( aDados[05],@nHours,@nMinuts,@nSeconds)
					oSection1:PrintLine()
					aFill(aDados,nil)
					aDados[04]	:= 0
					aDados[05]	:= 0
					aDados[06]	:= 0
					aDados[07]	:= 0
					aDados[08]	:= 0
				Endif
			
				aDados[01]	:=	(cAliasLif)->CB8_FILIAL
				aDados[02]	:= 	(cAliasLif)->CB7_CODOPE
				aDados[03]	:=  (cAliasLif)->CB1_NOME
				aDados[04]	:=  aDados[04]+;
					Val(substr(ElapTime((cAliasLif)->CB8_XHINI,(cAliasLif)->CB8_XHFIM),7,2))+;
					(Val(substr(ElapTime((cAliasLif)->CB8_XHINI,(cAliasLif)->CB8_XHFIM),4,2))*60)+;
					(Val(SubStr(ElapTime((cAliasLif)->CB8_XHINI,(cAliasLif)->CB8_XHFIM),1,2))*3600)
			
				If Empty(AllTrim(cOrdSep)) .Or. AllTrim(cOrdSep)<>AllTrim((cAliasLif)->CB8_ORDSEP)
					aDados[05]	+= 0
				Else
					aDados[05]	:= aDados[05]+;
						Val(substr(ElapTime(cHoraFim,(cAliasLif)->CB8_XHINI),7,2))+;
						(Val(substr(ElapTime(cHoraFim,(cAliasLif)->CB8_XHINI),4,2))*60)+;
						(Val(SubStr(ElapTime(cHoraFim,(cAliasLif)->CB8_XHINI),1,2))*3600)
				EndIf
			
				If !Empty(AllTrim(cOrdSep))
					If AllTrim(cOrdSep)<>AllTrim((cAliasLif)->CB8_ORDSEP)
						aDados[06]	+= 1
					EndIf
				EndIf
			
				aDados[07]	+= 1
				aDados[08]	+= (cAliasLif)->CB8_QTDORI
			
				cOrdSep		:= (cAliasLif)->CB8_ORDSEP
				cHoraFim	:= (cAliasLif)->CB8_XHFIM
				cCodOpe		:= (cAliasLif)->CB7_CODOPE
				
				(cAliasLif)->(dbskip())
			
			EndDo
		
			aDados[04]	:= SecsToHMS( aDados[04],@nHours,@nMinuts,@nSeconds)
			aDados[05]	:= SecsToHMS( aDados[05],@nHours,@nMinuts,@nSeconds)
			oSection1:PrintLine()
			aFill(aDados,nil)
			oReport:SkipLine()
		
		EndIf
	
	Else
	
		Processa({|| StQuery() },"Compondo Relatorio")
	
		DbSelectArea(cAliasLif)
		(cAliasLif)->(DbGoTop())
	
		If  Select(cAliasLif) > 0
		
			While (cAliasLif)->(!Eof())
			
				aDados1[01]	:=	(cAliasLif)->CB8_FILIAL
				aDados1[02]	:= 	(cAliasLif)->CB7_CODOPE
				aDados1[03]	:=  (cAliasLif)->CB1_NOME
				aDados1[04]	:= 	(cAliasLif)->CB8_ORDSEP
				aDados1[05]	:=  (cAliasLif)->CB8_PEDIDO
				aDados1[06]	:=	DTOC(STOD((cAliasLif)->CB7_DTEMIS))
				aDados1[07]	:= 	(cAliasLif)->CB8_ITEM
				aDados1[08]	:=  (cAliasLif)->CB8_PROD
				aDados1[09]	:=	(cAliasLif)->B1_DESC
				aDados1[10]	:=  (cAliasLif)->B1_GRUPO
				aDados1[11]	:=  DTOC(STOD((cAliasLif)->CB8_XDTINI))
				aDados1[12]	:=  (cAliasLif)->CB8_XHINI
				aDados1[13]	:=	DTOC(STOD((cAliasLif)->CB8_XDTFIM))
				aDados1[14]	:= 	(cAliasLif)->CB8_XHFIM
				//aDados1[13]	:=  (cAliasLif)->DIAS
				aDados1[15]	:=  ElapTime((cAliasLif)->CB8_XHINI,(cAliasLif)->CB8_XHFIM)
				aDados1[16]	:=  (cAliasLif)->CB8_QTDORI
				aDados1[17]	:=  (cAliasLif)->CB8_LCALIZ
			
				If Empty(AllTrim(cOrdSep)) .Or. AllTrim(cOrdSep)<>AllTrim((cAliasLif)->CB8_ORDSEP)
					aDados1[18]	:= ""
					aDados1[19]	:=  (cAliasLif)->HINICIO
				Else
					aDados1[18]	:=  ElapTime(cHoraFim,(cAliasLif)->CB8_XHINI)
					aDados1[19]	:= ""
				EndIf
			
				
				If Empty(AllTrim(cOrdSep)) .Or. AllTrim(cOrdSep)<>AllTrim((cAliasLif)->CB8_ORDSEP)
				
				aDados1[20]	:=  (cAliasLif)->HFIM
				aDados1[21]	:=  ElapTime((cAliasLif)->HINICIO,(cAliasLif)->CB8_XHINI)
				else
				aDados1[20]	:=  (cAliasLif)->HFIM
				aDados1[21]	:=  ""
				
				endif
				
				aDados1[22]  := Posicione("SBM",1,xFilial('SBM')+Posicione("SB1",1,xFilial('SB1')+Posicione("SC2",1,xFilial('SC2')+(cAliasLif)->CB8_OP,"C2_PRODUTO"),"B1_GRUPO"),"BM_DESC")
						
				cOrdSep		:= (cAliasLif)->CB8_ORDSEP
				cHoraFim	:= (cAliasLif)->CB8_XHFIM
			
				oSection1:PrintLine()
				aFill(aDados1,nil)
			
				(cAliasLif)->(dbskip())
			
			EndDo

			oReport:SkipLine()
		
		EndIf
	
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

	If mv_par05="S"
	
		cQuery := " SELECT CB8_FILIAL, CB8_ORDSEP, CB8_PEDIDO, CB8_ITEM, CB8_PROD, CB8_XDTINI, CB8_XHINI, CB8_QTDORI "
		cQuery += " CB8_XDTFIM, CB8_XHFIM, CB8_XDTFIM-CB8_XDTINI DIAS, CB7_DTEMIS, CB7_CODOPE, CB1_NOME, CB8_QTDORI, CB8_LCALIZ "
		cQuery += " FROM "+RetSqlName("CB8")+" CB8 "
		cQuery += " LEFT JOIN "+RetSqlName("CB7")+" CB7 "
		cQuery += " ON CB7_FILIAL=CB8_FILIAL AND CB7_ORDSEP=CB8_ORDSEP AND CB7_PEDIDO=CB8_PEDIDO "
		cQuery += " LEFT JOIN "+RetSqlName("CB1")+" CB1 "
		cQuery += " ON CB1_FILIAL=CB8_FILIAL AND CB1_CODOPE=CB7_CODOPE "
		cQuery += " WHERE CB8.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' AND CB1.D_E_L_E_T_=' ' AND CB8_FILIAL='"+xFilial("CB7")+"' "
		cQuery += " AND CB8_ORDSEP BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND CB8_XDTINI BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
		cQuery += " AND CB8_XDTINI<>' ' AND CB8_XDTFIM<>' ' AND CB8_XHINI<>' ' AND CB8_XHFIM<>' ' "
		cQuery += " ORDER BY CB7_CODOPE, CB8_FILIAL, CB8_ORDSEP, CB8_PEDIDO, CB8_XHINI, CB8_LCALIZ, CB8_PROD, CB8_ITEM "
	
	Else
	
		cQuery := " SELECT CB8_FILIAL, CB8_ORDSEP, CB8_PEDIDO, CB8_ITEM, CB8_PROD, B1_DESC, B1_GRUPO,CB8_XDTINI, CB8_XHINI, "
		cQuery += " CB8_XDTFIM, CB8_XHFIM, CB8_XDTFIM-CB8_XDTINI DIAS, CB7_DTEMIS, CB7_CODOPE, CB1_NOME, CB8_QTDORI, CB8_LCALIZ, "
		cQuery += " substr(CB7.CB7_HRINIS,1,2)||':'||substr(CB7.CB7_HRINIS,3,2)||':'||substr(CB7.CB7_HRINIS,5,2) AS HINICIO, "
		cQuery += " substr(CB7.CB7_HRFIMS,1,2)||':'||substr(CB7.CB7_HRFIMS,3,2)||':'||substr(CB7.CB7_HRFIMS,5,2) AS HFIM, "
		cQuery += " CB8_OP "
		cQuery += " FROM "+RetSqlName("CB8")+" CB8 "
		cQuery += " LEFT JOIN "+RetSqlName("CB7")+" CB7 "
		cQuery += " ON CB7_FILIAL=CB8_FILIAL AND CB7_ORDSEP=CB8_ORDSEP AND CB7_PEDIDO=CB8_PEDIDO "
		cQuery += " LEFT JOIN "+RetSqlName("CB1")+" CB1 "
		cQuery += " ON CB1_FILIAL=CB8_FILIAL AND CB1_CODOPE=CB7_CODOPE "
		cQuery += " LEFT JOIN "+RetSqlName("SB1")+" SB1 "
		cQuery += " ON B1_COD=CB8_PROD "
		cQuery += " WHERE CB8.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' AND CB1.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' AND CB8_FILIAL='"+xFilial("CB7")+"' "
		cQuery += " AND CB8_ORDSEP BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND CB8_XDTINI BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
		cQuery += " AND CB8_XDTINI<>' ' AND CB8_XDTFIM<>' ' AND CB8_XHINI<>' ' AND CB8_XHFIM<>' ' "
		cQuery += " ORDER BY CB7_CODOPE, CB8_FILIAL, CB8_ORDSEP, CB8_PEDIDO, CB8_XHINI, CB8_LCALIZ, CB8_PROD, CB8_ITEM "
	
	EndIf

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function SecsToHMS( nSecsToHMS , nHours , nMinuts , nSeconds , cRet )

	Local nRet	:= 0
	
	DEFAULT nSecsToHMS	:= 0
	DEFAULT cRet		:= "H"
	
	nHours		:= SecsToHrs( nSecsToHMS )
	nMinuts		:= SecsToMin( nSecsToHMS )
	nSeconds	:= ( HrsToSecs( nHours ) + MinToSecs( nMinuts ) )
	nSeconds	:= ( nSecsToHMS - nSeconds )
	nSeconds	:= Int( nSeconds )
	nSeconds	:= Mod( nSeconds , 60 )
	
	IF ( cRet $ "Hh" )
		nRet := nHours
	ElseIF ( cRet $ "Mm" )
		nRet := nMinuts
	ElseIF ( cRet $ "Ss" )
		nRet := nSeconds
	EndIF
	
	nRet	:= CVALTOCHAR(nHours)+":"+CVALTOCHAR(nMinuts)+":"+CVALTOCHAR(nSeconds)

Return( nRet )

Static Function SecsToHrs( nSeconds )

	Local nHours
	
	nHours	:= ( nSeconds / 3600 )
	nHours	:= Int( nHours )

Return( nHours )

Static Function SecsToMin( nSeconds )

	Local nMinuts
	
	nMinuts		:= ( nSeconds / 60 )
	nMinuts		:= Int( nMinuts )
	nMinuts		:= Mod( nMinuts , 60 )

Return( nMinuts )

Static Function HrsToSecs( nHours )
Return( ( nHours * 3600 ) )

Static Function MinToSecs( nMinuts )
Return( ( nMinuts * 60 ) )
