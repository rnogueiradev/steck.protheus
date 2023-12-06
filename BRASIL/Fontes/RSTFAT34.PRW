#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "Tbiconn.ch"
#include "rptdef.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  RSTFAT34     ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio Produtos em transito	                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
*-----------------------------*
User Function RSTFAT34(lJobAuto)
	*-----------------------------*
	Local   oReport
	Local  	nX				:= 0
	Private cPerg 			:= "RFAT34"
//	Private cTime           := Time()
//	Private cHora           := SUBSTR(cTime, 1, 2)
//	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
//	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg//+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private _cTitulo        := "Relatorio Produtos em transito"
	Private cPergTit 		:= cAliasLif
	Private cPastaRel 		:= "\arquivos\"
	Private carquivo_       := 	"RSTFAT34"
	Private cAnexo			:= ""
	Private cPara 			:= SuperGetMV("ST_RSFAT34",.F.,"henrique.youssef@steck.com.br;rafael.rivani@steck.com.br;david.junior@steck.com.br")

	Default lJobAuto 	:= .F.

	If lJobAuto



		For nX := 1 To 2 //Roda 2 x
			If nX == 1
				//Cria as definiÁıes do relatÛrio
				oReport := ReportDef()

				MV_PAR01 := Space(06)
				MV_PAR02 := Replicate("Z",15)
				MV_PAR03 := Space(04)
				MV_PAR04 := Replicate("Z",04)
				MV_PAR05 := 1

				//Define um nome do arquivo dentro da Protheus Data - pasta 'x_arquivos'
				cAnexo := carquivo_ + dToS(dDataBase) + StrTran(Time(), ":", "-") + ".xls"

				//Define para o relatÛrio n„o mostrar na tela, o Device 4 (Planilha), define o arquivo, e define para imprimir

				oReport:lPreview:= .F.
				oReport:SetTpPlanilha({.F., .F., .T., .F.})
				oReport:setFile(cPastaRel+cAnexo)

				oReport:nDevice			:= 4 	//1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
				oReport:nEnvironment	:= 1 // 1 -Server / 2- Cliente
				oReport:nRemoteType		:= NO_REMOTE
				oReport:cDescription 	:= _cTitulo
				oReport:cFile 			:= cPastaRel+cAnexo
				oReport:lParamPage 		:= .F.
				

				oReport:Print(.F.)

			Else
				If File(cPastaRel+cAnexo)
					//Cria as definiÁıes do relatÛrio
					//oReport := ReportDef()

					_cEmail     := cPara
					_cArq       := cAnexo
					_aAttach    := {}
					_cCopia 	:= ""
					_cAssunto   := "[WFPROTHEUS] - " + Alltrim(_cTitulo)
					cMsg		:= ""
					aadd( _aAttach  , _cArq )


					cMsg := '<html><head><title>stkSales</title></head>
					cMsg += '<body>
					cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
					cMsg += '<br><br>Ol· <b></b>,<br><br> ' //cMsg += '<br><br>Ol· <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
					cMsg += 'VocÍ est· recebendo o '+ Alltrim(_cTitulo) +' da Steck!<br>
					cMsg += 'Obrigado!<br><br>'
					cMsg += 'Atenciosamente,<br>
					cMsg += 'Steck Ind˙stria ElÈtrica Ltda
					cMsg += '</body></html>'

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,cPastaRel)  //n„o funcionou

					cParada := ""
					//oReport:PrintDialog()
				EndIf
			EndIf
		Next nX
	Else
		//	Private _cMes01 		:= mesextenso(Month(Date()))
		//	Private _cMes02 		:= mesextenso(Month(Date())+1)
		//	Private _cMes03 		:= mesextenso(Month(Date())+2)
		//	Private _cMes04 		:= mesextenso(Month(Date())+3)

		//	Private _cxMes01 		:=  cvaltochar(Year (Date()))+strzero(Month(Date()),2,0)
		//	Private _cxMes02 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+1)+'01',cvaltochar(Year (Date()))+strzero(Month(Date())+1,2,0))
		//	Private _cxMes03 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+2)+Iif(Month(Date()) = 12,'02','01'),cvaltochar(Year (Date()))+strzero(Month(Date())+2,2,0))
		//	Private _cxMes04 		:=  Iif(Month(Date())=12,cvaltochar(Year (Date())+3)+Iif(Month(Date()) = 12,'03',Iif(Month(Date()) = 11,'02','01')),cvaltochar(Year (Date()))+strzero(Month(Date())+3,2,0))

		PutSx1(cPerg, "01", "Do Produto:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C",15,0,0,"G","",'SB1'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
		PutSx1(cPerg, "02", "Ate Produto:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C",15,0,0,"G","",'SB1'    ,"","","mv_par02","","","","","","","","","","","","","","","","")
		PutSx1(cPerg, "03", "Do Grupo:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 5,0,0,"G","",'SBM' ,"","","mv_par03","","","","","","","","","","","","","","","","")
		PutSx1(cPerg, "04", "Ate Grupo:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 5,0,0,"G","",'SBM' ,"","","mv_par04","","","","","","","","","","","","","","","","")
		PutSx1(cPerg, "05", "Tipo  :"			,"Tipo   :"			,"Tipo    :"        ,"mv_ch5","N", 1,0,0,"C","",''    ,'','',"mv_par05","Completo","","","","C/F","","","","","","","","","","")


		oReport		:= ReportDef()
		oReport:PrintDialog()
	EndIf
Return
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ReportDef    ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio COMISSAO				                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
	*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELAT”RIO Produtos em transito",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir· imprimir um relatÛrio de Produtos em transito")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Produtos em transito",{"SC5"})


	TRCell():New(oSection,"CODIGO"	  			 ,,"CODIGO"		,,15,.F.,)
	TRCell():New(oSection,"DESCRICAO"  			 ,,"DESCRICAO"	,,35,.F.,)
	TRCell():New(oSection,"ABC"  			 	 ,,"ABC"	,,2,.F.,)
	TRCell():New(oSection,"FMR"  			     ,,"FMR"	,,2,.F.,)
	TRCell():New(oSection, "MEDIATRIM" 			 ,, "MEDIA TRIM"						,"@E 99,999,999.99",14)
	TRCell():New(oSection,"BLOQ"     			 ,,"BLOQ"		,"@!",3)
	TRCell():New(oSection,'GRUPO'  				 ,,'GRUPO'		,,6,.F.,)
	TRCell():New(oSection,"DESCGRUP"  		 	 ,,"DESCGRUP"	,,35,.F.,)
	//TRCell():New(oSection,'FALTA'  			 ,,'FALTA'		,"@E 99,999,999.99",14)
	//TRCell():New(oSection,"RESERVA"	   		 ,,"RESERVA"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"ESTOQUE"  			 ,,"ESTOQUE"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"ESTOQUE98"  			 ,,"ESTOQUE 98"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"CARTEIRA"     		 ,,"CARTEIRA"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"CARTEIRA_CREDITO"     ,,"CARTEIRA CREDITO"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"CARTCREDEX"    		 ,,"CARTEIRA CREDITO EX"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"FALTA_REAL"       	 ,,"FALTA REAL 02"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"FTREAL01"       		 ,,"FALTA REAL 01"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"TRANSITO_MES"       	 ,,"TRANSITO MES"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"TRANSITO_PROXIMO_MES" ,,"TRANSITO PROXIMO MES"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"FALTA_TRANSITO"       ,,"ESTOQUE COM TRANSITO"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"COBERTURA_TRANSITO"   ,,"COBERTURA COM TRANSITO"		,"@E 99,999,999.99",14)

	TRCell():New(oSection,"FATUR_DENTRO_MES"     ,,"FATURAMENTO DENTRO MES"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"PREVISAO_VENDAS"      ,,"PREVISAO DE VENDAS"			,"@E 99,999,999,999",14)
	TRCell():New(oSection,"ESTOQUE_SEGURANCA"    ,,"ESTOQUE DE SEGURANCA"		,"@E 99,999,999.99",14)

//	TRCell():New(oSection, _cMes01  			 ,, _cMes01 		,"@E 99,999,999.99",14)
//	TRCell():New(oSection, _cMes02 			 	 ,, _cMes02 		,"@E 99,999,999.99",14)
//	TRCell():New(oSection, _cMes03   			 ,, _cMes03 		,"@E 99,999,999.99",14)
//	TRCell():New(oSection, _cMes04  			 ,, _cMes04 		,"@E 99,999,999.99",14)

	TRCell():New(oSection, "SALDOAM"  			 ,, "SALDO PEDIDO AM"		,"@E 99,999,999.99",14)
	TRCell():New(oSection, "EMBARQUEAM"  		 ,, "ESTOQUE COM SALDO PEDIDO AM" 		,"@E 99,999,999.99",14)

	//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
	TRCell():New(oSection,"CUNI",,"C UNIT 1a M "			,PesqPict("SB2","B2_CMFIM1")     ,TamSX3("B2_CMFIM1 ")   [1]+2)
	TRCell():New(oSection,"CTOTAL",,"CUSTO TOTAL "			,PesqPict("SB2","B2_CMFIM1")     ,TamSX3("B2_CMFIM1 ")    [1]+2)
	//<< Ticket 20191118000027 - Everson Santana - 19.11.2019

	//TRCell():New(oSection,"MEDIA"     			 ,,"MEDIA"		,"@E 99,999,999.99",14)

	//oSection:Cell("MEDIA"):Hide()

	//Qtd.Ped.	Qtd.Emb.	Qtd.Entr.	Saldo

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ReportPrint  ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio Produtos em transito	                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
	Local aDados1[99]
	Local _cSta 	:= ''
	Local _cMediaTrim	:= 0


	oSection1:Cell("CODIGO")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("DESCRICAO")  			:SetBlock( { || aDados1[02] } )
	oSection1:Cell('GRUPO')  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("DESCGRUP")       		:SetBlock( { || aDados1[04] } )
//	oSection1:Cell( _cMes01 )  				:SetBlock( { || aDados1[05] } )
//	oSection1:Cell( _cMes02 )				:SetBlock( { || aDados1[06] } )
//	oSection1:Cell( _cMes03 )				:SetBlock( { || aDados1[07] } )
	//oSection1:Cell('FALTA')     			:SetBlock( { || aDados1[08] } )
	//oSection1:Cell("RESERVA")     			:SetBlock( { || aDados1[09] } )
	oSection1:Cell("ESTOQUE")				:SetBlock( { || aDados1[10] } )
	oSection1:Cell("CARTEIRA")      		:SetBlock( { || aDados1[11] } )
	oSection1:Cell("CARTEIRA_CREDITO")		:SetBlock( { || aDados1[12] } )
	oSection1:Cell("FALTA_REAL")     		:SetBlock( { || aDados1[13] } )
	oSection1:Cell("FALTA_TRANSITO")		:SetBlock( { || aDados1[14] } )
	oSection1:Cell("TRANSITO_MES")			:SetBlock( { || aDados1[15] } )
	oSection1:Cell("TRANSITO_PROXIMO_MES")	:SetBlock( { || aDados1[16] } )
	//oSection1:Cell("MEDIA")					:SetBlock( { || aDados1[17] } )
	oSection1:Cell("ABC")					:SetBlock( { || aDados1[18] } )
	oSection1:Cell("FMR")					:SetBlock( { || aDados1[19] } )
//	oSection1:Cell( _cMes04 )				:SetBlock( { || aDados1[20] } )
	oSection1:Cell( "COBERTURA_TRANSITO" )	:SetBlock( { || aDados1[21] } )
	oSection1:Cell( "BLOQ" )				:SetBlock( { || aDados1[22] } )
	oSection1:Cell( "SALDOAM" )				:SetBlock( { || aDados1[23] } )
	oSection1:Cell( "EMBARQUEAM" )			:SetBlock( { || aDados1[24] } )
	oSection1:Cell( "MEDIATRIM" )			:SetBlock( { || aDados1[25] } )
	oSection1:Cell("ESTOQUE98")				:SetBlock( { || aDados1[26] } )
	oSection1:Cell("FTREAL01")				:SetBlock( { || aDados1[27] } )
	oSection1:Cell("CARTCREDEX")			:SetBlock( { || aDados1[28] } )
	oSection1:Cell("FATUR_DENTRO_MES")		:SetBlock( { || aDados1[29] } )
	oSection1:Cell("PREVISAO_VENDAS")		:SetBlock( { || aDados1[30] } )
	oSection1:Cell("ESTOQUE_SEGURANCA")		:SetBlock( { || aDados1[31] } )
	//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
	oSection1:Cell("CUNI")					:SetBlock( { || aDados1[32] } )
	oSection1:Cell("CTOTAL")				:SetBlock( { || aDados1[33] } )
	//<< Ticket 20191118000027 - Everson Santana - 19.11.2019

	oReport:SetTitle("Produtos em transito")// Titulo do relatÛrio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	Dbselectarea("SB3")
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			_cMediaTrim	:= 0

			SB3->(DbSetOrder(1))
			If SB3->(Dbseek(xfilial("SB3")+ (cAliasLif)->CODIGO  ))
				_cMediaTrim  := (&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2))+;
					&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2))+;
					&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)))/3
			EndIf

			aDados1[01]	:=	(cAliasLif)->CODIGO
			aDados1[02]	:= 	(cAliasLif)->DESCRICAO
			aDados1[03]	:=  (cAliasLif)->GRUPO
			aDados1[04]	:= 	(cAliasLif)->DESCGRUP
			//aDados1[05]	:=  (cAliasLif)->PREV01
			//aDados1[06]	:=	(cAliasLif)->PREV02
			//aDados1[07]	:=	(cAliasLif)->PREV03
			//aDados1[08]	:=	(cAliasLif)->FALTA
			//aDados1[09]	:=  (cAliasLif)->RESERVA
			aDados1[10]	:=  (cAliasLif)->ESTOQUE
			aDados1[11]	:=  (cAliasLif)->CARTEIRA
			aDados1[12]	:=  (cAliasLif)->CARTEIRA_CREDITO
			aDados1[13]	:=  (cAliasLif)->FALTA_REAL
			aDados1[14]	:=  (cAliasLif)->FALTA_REAL+(cAliasLif)->TRANSITO_MES+(cAliasLif)->TRANSITO_PROXIMO_MES
			aDados1[15]	:=  (cAliasLif)->TRANSITO_MES
			aDados1[16]	:=  (cAliasLif)->TRANSITO_PROXIMO_MES
			//aDados1[17]	:=  (cAliasLif)->MEDIA
			aDados1[18]	:=  (cAliasLif)->ABC
			aDados1[19]	:=  (cAliasLif)->FMR
			//aDados1[20]	:=	(cAliasLif)->PREV04
			aDados1[25]	:=	_cMediaTrim
			aDados1[21]	:=	(aDados1[14]/(aDados1[25]/30))
			aDados1[22]	:=	IIF((cAliasLif)->BLOQUEADO=="2","N√O","SIM")
			aDados1[23]	:=	(cAliasLif)->SALDOAM
			aDados1[24]	:=	aDados1[14]+aDados1[23]
			aDados1[26]	:=	(cAliasLif)->ESTOQUE98
			aDados1[27]	:=	(cAliasLif)->FTREAL01
			aDados1[28]	:=  (cAliasLif)->CARTCREDEX
			aDados1[29]	:=  (cAliasLif)->FATUR_DENTRO_MES
			aDados1[30]	:=  Val((cAliasLif)->PREVISAO_MES)
			aDados1[31]	:=  (cAliasLif)->ESTOQUE_SEGURANCA

			//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
			aDados1[32]	:= (cAliasLif)->CMFIM1
			aDados1[33]	:= (((cAliasLif)->TRANSITO_MES+(cAliasLif)->TRANSITO_PROXIMO_MES)*(cAliasLif)->CMFIM1)
			//<< Ticket 20191118000027 - Everson Santana - 19.11.2019
			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()




Return oReport


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  StQuery      ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio COMISSAO				                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
	*-----------------------------*
Static Function StQuery()
	*-----------------------------*

	Local cQuery     := ' '

	cQuery := " SELECT
	cQuery += " SB1.B1_COD
	cQuery += ' "CODIGO",
	cQuery += " SB1.B1_MSBLQL
	cQuery += ' "BLOQUEADO",
	cQuery += " TRIM(SB1.B1_DESC)
	cQuery += ' "DESCRICAO",
	cQuery += " SB1.B1_XPREMES "
	cQuery += ' "PREVISAO_MES",
	cQuery += ' SB1.B1_ESTSEG
	cQuery += ' "ESTOQUE_SEGURANCA",
	cQuery += ' SB1.B1_XABC
	cQuery += ' "ABC",
	cQuery += ' SB1.B1_XFMR
	cQuery += ' "FMR",
	cQuery += " SB1.B1_GRUPO
	cQuery += ' "GRUPO",
	cQuery += " TRIM(SBM.BM_DESC)
	cQuery += ' "DESCGRUP",
	cQuery += " NVL((SELECT SUM(TA1.PA1_QUANT)
	cQuery += " FROM "+RetSqlName("PA1")+" TA1 "
	cQuery += " WHERE TA1.D_E_L_E_T_ = ' '
	cQuery += " AND TA1.PA1_CODPRO = SB1.B1_COD
	cQuery += " AND TA1.PA1_FILIAL= '"+xFilial("PA1")+"'),0)
	cQuery += ' "FALTA",
	cQuery += " NVL((SELECT SUM(TA2.PA2_QUANT)
	cQuery += " FROM "+RetSqlName("PA2")+" TA2 "
	cQuery += " WHERE TA2.D_E_L_E_T_ = ' '
	cQuery += " AND TA2.PA2_CODPRO = SB1.B1_COD AND TA2.PA2_FILIAL = ' '
	cQuery += " AND TA2.PA2_FILRES= '02'),0)
	cQuery += ' "RESERVA",
	cQuery += " NVL((SELECT SUM(SB2.B2_QATU)
	cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery += " AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'"
	cQuery += " AND SB2.B2_COD = SB1.B1_COD
	//cQuery += " AND ( SB2.B2_LOCAL = '03' OR SB2.B2_LOCAL = '98' )
	cQuery += " AND ( SB2.B2_LOCAL = '03' ) " //Chamado 003142
	cQuery += " ),0)
	cQuery += ' "ESTOQUE"

	//>> Ticket 20191118000027 - Everson Santana - 19.11.2019
	cQuery += ",NVL((SELECT DISTINCT SB21.B2_CMFIM1 "
	cQuery += " FROM "+RetSqlName("SB2")+" SB21  "
	cQuery += " WHERE SB21.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB21.B2_FILIAL = '"+xFilial("SB2")+"' "
	cQuery += " AND SB21.B2_COD = SB1.B1_COD "
	cQuery += " AND SB21.B2_LOCAL = '03'  "
	cQuery += " AND B2_CMFIM1 > 0 "
	cQuery += " ),0) AS CMFIM1 "
	//<< Ticket 20191118000027 - Everson Santana - 19.11.2019

	cQuery += " ,NVL((SELECT SUM(SB2.B2_QATU)
	cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery += " AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'"
	cQuery += " AND SB2.B2_COD = SB1.B1_COD
	cQuery += " AND (SB2.B2_LOCAL = '98' )
	cQuery += " ),0)
	cQuery += ' "ESTOQUE98",
	cQuery += " NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM
	cQuery += " AND SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_XTRONF=' ' " //Chamado 003047 - Retirar troca de nota do relatÛrio
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD
	cQuery += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
	//cQuery += " AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39' OR SC5.C5_TIPOCLI = 'X')
	cQuery += " AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '95' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '11' "//Chamado 006637
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " AND NOT EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ = ' '
	cQuery += " AND SC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND SC9.C9_BLCRED In ('01','09')
	cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL)
	cQuery += " AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0)
	cQuery += ' "CARTEIRA",

	cQuery += " NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " INNER JOIN(SELECT * FROM  "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM
	cQuery += " AND SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_XTRONF=' ' " //Chamado 003047 - Retirar troca de nota do relatÛrio
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD
	cQuery += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
	//cQuery += " AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39'  OR SC5.C5_TIPOCLI = 'X')
	cQuery += " AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '95' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '11' "//Chamado 006637
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " AND SC5.C5_TIPOCLI <> 'X' " //Chamado 003142
	cQuery += " AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0
	cQuery += " AND EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ = ' '
	cQuery += " AND SC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND SC9.C9_BLCRED In ('01','09')
	cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL)
	cQuery += " ),0)
	cQuery += ' "CARTEIRA_CREDITO",

	cQuery += " NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " INNER JOIN(SELECT * FROM  "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM
	cQuery += " AND SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_XTRONF=' ' " //Chamado 003047 - Retirar troca de nota do relatÛrio
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD
	cQuery += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
	//cQuery += " AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39'  OR SC5.C5_TIPOCLI = 'X')
	cQuery += " AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '95' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '11' "//Chamado 006637
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " AND SC5.C5_TIPOCLI = 'X' " //Chamado 003142
	cQuery += " AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0
	cQuery += " AND EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ = ' '
	cQuery += " AND SC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND SC9.C9_BLCRED In ('01','09')
	cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL)
	cQuery += " ),0)
	cQuery += ' "CARTCREDEX",

	cQuery += " NVL((SELECT SUM(SB2.B2_QATU)

/*******************************************
<<< ALTERA«√O >>> 
AÁ„o...........: Receber via par‚metro a Empresa e Filial.
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 04/01/2021
Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	cQuery += " FROM SB2010 SB2
******************************************/
	cQuery += " FROM "+RetSqlName("SB2")+" SB2
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery += " AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'"
	cQuery += " AND SB2.B2_COD = SB1.B1_COD
	cQuery += " AND ( SB2.B2_LOCAL = '03' OR SB2.B2_LOCAL = '98' )
	cQuery += " ),0) -
	cQuery += " NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM
	cQuery += " AND SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD
	cQuery += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
	//cQuery += " AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39' OR SC5.C5_TIPOCLI = 'X')
	cQuery += " AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '95' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '11' "//Chamado 006637
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " AND SC6.C6_CLI <> '033467' " //Retirar cliente Steck - Chamado 002927
	cQuery += " AND NOT EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ = ' '
	cQuery += " AND SC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND SC9.C9_BLCRED In ('01','09')
	cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL)
	cQuery += " AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0)
	cQuery += ' "FALTA_REAL",
	
	cQuery += "NVL((SELECT SUM(PA2_QUANT) FROM "+RetSqlName("PA2")+" PA2 WHERE PA2.D_E_L_E_T_=' ' AND PA2_FILRES='01'  AND PA2_FILIAL = ' ' AND PA2_CODPRO=SB1.B1_COD),0) FTREAL01, "
	
	
	cQuery += " NVL((SELECT SUM(SB2.B2_QATU)
	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	cQuery += " FROM SB2010 SB2
	******************************************/
	cQuery += " FROM "+RetSqlName("SB2")+" SB2
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery += " AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'"
	cQuery += " AND SB2.B2_COD = SB1.B1_COD
	cQuery += " AND ( SB2.B2_LOCAL = '03' OR SB2.B2_LOCAL = '98' )
	cQuery += " ),0) -
	cQuery += " NVL((SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC5.C5_NUM = SC6.C6_NUM
	cQuery += " AND SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD
	cQuery += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
	//cQuery += " AND (SC6.C6_OPER = '01' OR SC6.C6_OPER = '39' OR SC5.C5_TIPOCLI = 'X')
	cQuery += " AND SC6.C6_OPER <> '38' AND SC6.C6_OPER <> '11' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '95' "//pedido de ordem e remessa richeli 17/07/14 giovani
	cQuery += " AND SC6.C6_OPER <> '11' "//Chamado 006637
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " AND NOT EXISTS(SELECT * FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ = ' '
	cQuery += " AND SC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND SC9.C9_BLCRED In ('01','09')
	cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL)
	cQuery += " AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0),0)+
	cQuery += " NVL((SELECT
	cQuery += " SUM(D2_QUANT)

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	Trocado para loja 06
	cQuery += " AND SD2.D2_LOJA = '02'
	******************************************/
	cQuery += " FROM UDBP12.SD2030 SD2
	cQuery += " WHERE UDBP12.SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_FILIAL = '01'

	cQuery += " AND SD2.D2_CLIENTE = '033467'
	cQuery += " AND SD2.D2_LOJA = '06'
	cQuery += " AND SD2.D2_DOC <> '000007281'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000007280'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000007275'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000003279'  " //NOTA COM ENTRADA ERRADA
	cQuery += " AND SD2.D2_DOC <> '000004299'  " //NOTA COM ENTRADA ERRADA  //giovani zago 09/11/14
	cQuery += " AND SD2.D2_EMISSAO  > '20140101'
	cQuery += " AND SD2.D2_COD = SB1.B1_COD

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	******************************************/
	cQuery += " AND  NOT EXISTS (   SELECT * FROM UDBP12.SF3030 SF3
	cQuery += " WHERE SF3.D_E_L_E_T_ =  ' '
	cQuery += " AND SF3.F3_SERIE = SD2.D2_SERIE
	cQuery += " AND SF3.F3_NFISCAL = SD2.D2_DOC
	cQuery += " AND F3_OBSERV LIKE '%DENEGADA%')
	
	
	cQuery += " AND  NOT EXISTS ( SELECT * FROM "+RetSqlName("SF1")+" SF1 "
	cQuery += " WHERE SF1.D_E_L_E_T_ =  ' '

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	cQuery += " AND SF1.F1_FORNECE = '005866' AND SF1.F1_FILIAL = '02'
	******************************************/
	cQuery += " AND SF1.F1_FORNECE = '005866' AND SF1.F1_FILIAL = '"+XFILIAL("SF1")+"'
	cQuery += " AND SF1.F1_DOC = SD2.D2_DOC AND F1_STATUS='A' )),0)
	
	
	/* GIOVANI ZAGO 04/06/2020
	cQuery += " AND  NOT EXISTS ( SELECT * FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE SD1.D_E_L_E_T_ =  ' '
	cQuery += " AND SD1.D1_FORNECE = '005866'
	cQuery += " AND SD1.D1_DOC = SD2.D2_DOC)),0)
	*/
	cQuery += ' "FALTA_TRANSITO",


	cQuery += " NVL((SELECT
	cQuery += " SUM(D2_QUANT)

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	Trocado para loja 06
	cQuery += " AND SD2.D2_LOJA = '02'
	******************************************/
	cQuery += " FROM UDBP12.SD2030 SD2
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_FILIAL = '01'
	cQuery += " AND SD2.D2_CLIENTE = '033467'
	cQuery += " AND SD2.D2_LOJA = '06'
	cQuery += " AND SD2.D2_DOC <> '000007281'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000007280'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000007275'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000003279'  " //NOTA COM ENTRADA ERRADA
	cQuery += " AND SD2.D2_DOC <> '000004299'  " //NOTA COM ENTRADA ERRADA
	cQuery += " AND SD2.D2_EMISSAO  <= '"+substr(dtos(date()),1,6)+"15'"
	cQuery += " AND SD2.D2_COD = SB1.B1_COD

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	******************************************/
	cQuery += " AND  NOT EXISTS (   SELECT * FROM UDBP12.SF3030 SF3
	cQuery += " WHERE SF3.D_E_L_E_T_ =  ' '
	cQuery += " AND SF3.F3_SERIE = SD2.D2_SERIE
	cQuery += " AND SF3.F3_NFISCAL = SD2.D2_DOC
	cQuery += " AND F3_OBSERV LIKE '%DENEGADA%')
	
	cQuery += " AND  NOT EXISTS ( SELECT * FROM "+RetSqlName("SF1")+" SF1 "
	cQuery += " WHERE SF1.D_E_L_E_T_ =  ' '

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	cQuery += " AND SF1.F1_FORNECE = '005866' AND SF1.F1_FILIAL = '02'
	******************************************/
	cQuery += " AND SF1.F1_FORNECE = '005866' AND SF1.F1_FILIAL = '"+XFILIAL("SF1")+"'
	cQuery += " AND SF1.F1_DOC = SD2.D2_DOC)),0)
	cQuery += ' "TRANSITO_MES",
	
	/*GIOVANI ZAGO 04/06/2020
	cQuery += " AND  NOT EXISTS ( SELECT * FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE SD1.D_E_L_E_T_ =  ' '
	cQuery += " AND SD1.D1_FORNECE = '005866'
	cQuery += " AND SD1.D1_DOC = SD2.D2_DOC)),0)
	cQuery += ' "TRANSITO_MES",
    */
	cQuery += " NVL((SELECT
	cQuery += " SUM(D2_QUANT)

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	cQuery += " FROM SD2010 SD2
	cQuery += " INNER JOIN SF4010 SF4 ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' '  "	
	******************************************/
	cQuery += " FROM "+RetSqlName("SD2")+" SD2
	cQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' '  "	
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "' "
	cQuery += " AND SD2.D2_EMISSAO LIKE '" + substr(dtos(dDataBase),1,6) + "%' "
	cQuery += " AND SD2.D2_COD = SB1.B1_COD
	cQuery += " AND F4_ESTOQUE = 'S'  "	
	cQuery += " AND F4_DUPLIC = 'S'  "
	cQuery += " ),0)
	cQuery += ' "FATUR_DENTRO_MES",

	cQuery += " NVL((SELECT
	cQuery += " SUM(D2_QUANT)

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	trocado para loja 06
	cQuery += " AND SD2.D2_LOJA = '02'
	******************************************/
	cQuery += " FROM UDBP12.SD2030 SD2
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_FILIAL = '01'
	cQuery += " AND SD2.D2_CLIENTE = '033467'
	cQuery += " AND SD2.D2_LOJA = '06'
	cQuery += " AND SD2.D2_DOC <> '000007281'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000007280'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000007275'  " //NOTA COM ENTRADA ERRADA //giovani zago 29/06/17
	cQuery += " AND SD2.D2_DOC <> '000003279'  " //NOTA COM ENTRADA ERRADA
	cQuery += " AND SD2.D2_DOC <> '000004299'  " //NOTA COM ENTRADA ERRADA
	cQuery += " AND SD2.D2_EMISSAO  > '"+substr(dtos(date()),1,6)+"15'"
	cQuery += " AND SD2.D2_COD = SB1.B1_COD

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	******************************************/
	cQuery += " AND  NOT EXISTS (   SELECT * FROM UDBP12.SF3030 SF3
	cQuery += " WHERE SF3.D_E_L_E_T_ =  ' '
	cQuery += " AND SF3.F3_SERIE = SD2.D2_SERIE
	cQuery += " AND SF3.F3_NFISCAL = SD2.D2_DOC
	cQuery += " AND F3_OBSERV LIKE '%DENEGADA%')
	cQuery += " AND  NOT EXISTS ( SELECT * FROM  "+RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE SD1.D_E_L_E_T_ =  ' '
	cQuery += " AND SD1.D1_FORNECE = '005866'
	cQuery += " AND SD1.D1_DOC = SD2.D2_DOC)),0)
	cQuery += ' "TRANSITO_PROXIMO_MES",
	
	
	cQuery += " NVL((select SB3.B3_MEDIA from  "+RetSqlName("SB3")+" SB3 "
	cQuery += " WHERE SB3.B3_COD = SB1.B1_COD
	cQuery += " AND SB3.D_E_L_E_T_ = ' '
	cQuery += " AND SB3.B3_FILIAL = '"+xFilial("SB3")+"'),0)
	cQuery += ' "MEDIA",
	
	
	cQuery += " NVL((SELECT
	cQuery += "  SUM(
	cQuery += " FC6.C6_QTDVEN - FC6.C6_QTDENT)

	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	Trocado a loja para '06'
	cQuery += " AND FC6.C6_LOJA = '02'
	******************************************/
	cQuery += ' FROM UDBP12.SC6030 FC6
	cQuery += " WHERE FC6.D_E_L_E_T_ = ' '
	cQuery += " AND FC6.C6_FILIAL = '01'
	cQuery += " AND FC6.C6_CLI = '033467'
	cQuery += " AND FC6.C6_LOJA = '06'
	cQuery += " AND FC6.C6_QTDVEN > FC6.C6_QTDENT
	cQuery += " AND FC6.C6_BLQ <> 'R'
	cQuery += " AND FC6.C6_OPER = '15'
	cQuery += " AND FC6.C6_PRODUTO = SB1.B1_COD),0)
	cQuery += ' "SALDOAM"
	
	/*******************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Receber via par‚metro a Empresa e Filial.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 04/01/2021
	Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
	cQuery += " FROM SB1010 SB1
	******************************************/
	cQuery += " FROM "+RetSqlName("SB1")+" SB1
	
	cQuery += " INNER JOIN(SELECT * FROM  "+RetSqlName("SBM")+" )SBM "
	cQuery += " ON SBM.D_E_L_E_T_ = ' '
	cQuery += " AND SBM.BM_GRUPO = SB1.B1_GRUPO
	
	cQuery += " WHERE SB1.D_E_L_E_T_ = ' '
	cQuery += " AND   SB1.B1_CLAPROD = 'C'
	cQuery += " AND   SB1.B1_LOCPAD = '03'
	cQuery += " AND SB1.B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " AND SB1.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	If Mv_Par05 = 2
		/*******************************************
		<<< ALTERA«√O >>> 
		AÁ„o...........: Receber via par‚metro a Empresa e Filial.
		Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
		Data...........: 04/01/2021
		Chamado........: 20220107000498 - VIRADA APOEMA NEWCO DISTRIBUIDORA 
		******************************************/
		cQuery += " AND EXISTS(SELECT * FROM UDBP12.SB1030 TB1
		cQuery += " WHERE TB1.D_E_L_E_T_ = ' '
		cQuery += " AND   TB1.B1_CLAPROD = 'F'
		cQuery += " AND SB1.B1_COD = TB1.B1_COD)
	EndIf
	
	cQuery += " ORDER BY  FALTA_TRANSITO
	

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()

