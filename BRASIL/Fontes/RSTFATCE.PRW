#INCLUDE "Totvs.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*
|Programa  | RSTFATCE        | Autor | RENATO.OLIVEIRA           | Data | 23/04/2019  |
|=====================================================================================|
|Descrição | Relatório de SCs				                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
*/
//------------------------------------------------------------------------------------------------//
//Alterações realizadas:
//FR - 10/08/2022 - Flávia Rocha - Sigamat Consultoria
//Após a atualização de release, a query na função StQuery não trazia dados
//em virtude de um comando de query usado para um campo memo, provavelmente pela atualização
//o comando não é mais reconhecido, então substituí a chamada do campo por dbseek na Sb1
//Campo: B1_XDESEXD - Descrição estendida
//------------------------------------------------------------------------------------------------//

User Function RSTFATCE()

	Local   oReport
	Private cPerg 			:= "RFATCE"
	Private cTime        	:= Time()
	Private cHora        	:= Substr(cTime, 1, 2)
	Private cMinutos    	:= Substr(cTime, 4, 2)
	Private cSegundos   	:= Substr(cTime, 7, 2)
	Private cAliasLif   	:= cPerg + cHora + cMinutos + cSegundos
	Private cPergTit 		:= cAliasLif

	xPutSx1(cPerg, "01", "Filial de:"		,"Filial de: ?" 	,"Filial de: ?" 	,"mv_ch1","C",2,0,0,"G","",'SM0' 		,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Filial ate:"		,"Filial ate: ?" 	,"Filial ate: ?" 	,"mv_ch2","C",2,0,0,"G","",'SM0' 		,"","","mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "SC de:"			,"SC de: ?" 		,"SC de: ?" 		,"mv_ch3","C",6,0,0,"G","",'SC1' 		,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "SC ate:"			,"SC ate: ?" 		,"SC ate: ?" 		,"mv_ch4","C",6,0,0,"G","",'SC1' 		,"","","mv_par04","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "05", "De Data:"			,"De Data: ?" 		,"Da Data: ?" 		,"mv_ch5","D",8,0,0,"G","",''    		,"","","mv_par05","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "06", "Ate Data:"		,"Ate Data: ?" 		,"Ate Data: ?"		,"mv_ch6","D",8,0,0,"G","",''    		,"","","mv_par06","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "07", "Status:"			,"Status" 			,"Status" 			,"mv_ch7","C",1,0,0,"G","",'SC1SA' 		,"","","mv_par07","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "08", "Modelo Rel."		,"Modelo Rel."		,"Modelo Rel."		,"mv_ch8","C",4,0,0,"G","",'_MOD' 		,"","","mv_par08","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "09", "Motivo de?"		,"Motivo de?"		,"Motivo de?"		,"mv_ch9","C",3,0,0,"G","",'SZ1'		,"","","mv_par09","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "10", "Motivo Até?"		,"Motivo Até?"		,"Motivo Até?"		,"mv_chA","C",3,0,0,"G","",'SZ1'		,"","","mv_par10","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "11", "Cod. Comprador"	,"Cod. Comprador"	,"Cod. Comprador"	,"mv_chB","C",3,0,0,"G","",'SY1'		,"","","mv_par11","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "12", "Tipo de SC'S'"	,"Tipo de SC'S"	    ,"Tipo de SC'S"	    ,"mv_chC","C",1,0,0,"C","",''		    ,"","","mv_par12","Aberto","Aberto","Aberto","","Fechado","Fechado","Fechado","Todos","Todos","Todos","","","","","","")

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*
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
*/

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de acompanhamento de SCs",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de acompanhamento de SCs")
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 10

	Pergunte(cPerg,.F.)

	oSection1 := TRSection():New(oReport,"SCs",{"SC1"})

	TRCell():New(oSection1,"01"	  			 ,,"Filial"				,,02,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02"	  			 ,,"Emissao"			,,TamSx3("C1_EMISSAO")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"03"	  			 ,,"Numero S.C."		,,TamSx3("C1_NUM")[1]	 	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"04"	  			 ,,"Item"				,,TamSx3("C1_ITEM")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"05"	  			 ,,"Codigo"				,,TamSx3("C1_PRODUTO")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"06"	  			 ,,"Descricao"			,,TamSx3("B1_DESC")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"07"	  			 ,,"Descricao ext"		,,TamSx3("B1_XDESEXD")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"08"	  			 ,,"TP"					,,TamSx3("B1_TIPO")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"09"	  			 ,,"Grupo"				,,TamSx3("B1_GRUPO")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"10"	  			 ,,"Quantidade"			,,TamSx3("C1_QUANT")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"11"	  			 ,,"UM"					,,TamSx3("B1_UM")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"12"	  			 ,,"Centro de custo"	,,TamSx3("C1_CC")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"13"	  			 ,,"Motivo"				,,TamSx3("C1_MOTIVO")[1]	,.F.,,,,,,,.T.)
	
	TRCell():New(oSection1,"42"	  			 ,,"Tipo"				,,TamSx3("C1_XTIPOSC")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"43"	  			 ,,"Desc Tipo"			,,20,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"44"	  			 ,,"Obs Tipo SC"		,,TamSx3("C1_XOBSTPS")[1]	,.F.,,,,,,,.T.)


	
	TRCell():New(oSection1,"14"	  			 ,,"Solicitante"		,,TamSx3("C1_SOLICIT")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"15"	  			 ,,"Aprovador"			,,30						,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"16"	  			 ,,"Comprador"			,,TamSx3("Y1_NOME")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"17"	  			 ,,"Status S.C."		,,20						,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"18"	  			 ,,"Data aprovação"		,,08						,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"19"	  			 ,,"Hora aprovação"		,,08						,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"40"	  			 ,,"Dt.Necessidade"		,,10						,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"20"	  			 ,,"Saldo"				,,TamSx3("B2_QATU")[1]		,.F.,,,,,,,.T.)
	// Dados do Pedido de Compras
	TRCell():New(oSection1,"21"	  			 ,,"Número pedido"		,,TamSx3("C7_NUM")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"34"	  			 ,,"Cotação"			,,TamSx3("C1_COTACAO")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"22"	  			 ,,"Fornecedor"			,,TamSx3("C7_FORNECE")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"23"	  			 ,,"Loja"				,,TamSx3("C7_LOJA")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"24"	  			 ,,"Razão Social"		,,TamSx3("A2_NOME")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"25"	  			 ,,"Emissão pedido"		,,08						,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"26"	  			 ,,"Mot. Comp."			,,TamSx3("C7_MOTIVO")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"27"	  			 ,,"Status P.C."		,,20						,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"28"	  			 ,,"Observação SC"		,,TamSx3("C1_OBS")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"29"	  			 ,,"Dt. Aprovação"		,,TamSx3("CR_DATALIB")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"30"	  			 ,,"Nome Comprador"		,,TamSx3("C7_OBS")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"31"	  			 ,,"Comp. STECK"		,,TamSx3("C7_COMPSTK")[1]	,.F.,,,,,,,.T.)
	// Valdemir Rabelo 08/04/2020
	TRCell():New(oSection1,"32"	  			 ,,"Valor Orçado"		,,TamSx3("C1_XPRCORC")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"33"	  			 ,,"Valid.Orçado"		,,TamSx3("C1_XDTVORC")[1]	,.F.,,,,,,,.T.)
	// Giovani Zago 11/06/2020
	TRCell():New(oSection1,"34"	  			 ,,"Cotação"			,,TamSx3("C1_COTACAO")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"35"	  			 ,,"Ult.$ Pago"			,,TamSx3("C1_XPRCORC")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"36"	  			 ,,"Ult.Pedido"			,,TamSx3("C7_NUM")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"37"	  			 ,,"Ult.Fornecedor"		,,TamSx3("C7_FORNECE")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"38"	  			 ,,"Desc.Fornecedor"	,,30						,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"39"	  			 ,,"Dt.Ult.Entrada"		,,10						,.F.,,,,,,,.T.)
	// Ticket 20210713012539 - Inclusão de campo em Relatório de SCs - Eduardo Pereira Sigamat - 16.07.2021 - Inicio
	TRCell():New(oSection1,"41"	  			 ,,"Tipo de SC"			,,20						,.F.,,,,,,,.T.)
	// Ticket 20210713012539 - Inclusão de campo em Relatório de SCs - Eduardo Pereira Sigamat - 16.07.2021 - Inicio
	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SC1")

	oSection2 := TRSection():New(oReport,"Detalhes Pedido de Compras",{"SC1"})

	TRCell():New(oSection2,"01"	  			 ,,"Pedidos Compras"	,,06					,.F.,,,,,,,.T.)
	TRCell():New(oSection2,"02"	  			 ,,"Preços Unitário"	,,17					,.F.,,,,,,,.T.)
	TRCell():New(oSection2,"03"	  			 ,,"Fornecedores"		,,06					,.F.,,,,,,,.T.)
	TRCell():New(oSection2,"04"	  			 ,,"Loja"				,,TamSx3("C7_LOJA")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection2,"05"	  			 ,,"Razão Social"		,,TamSx3("A2_NOME")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection2,"06"	  			 ,,"Emissão Pedido"		,,08					,.F.,,,,,,,.T.)
	TRCell():New(oSection2,"07"	  			 ,,"Status"				,,20					,.F.,,,,,,,.T.)

	oSection2:SetHeaderSection(.T.)
	oSection2:Setnofilter("SC7")

	oSection3 := TRSection():New(oReport,"Detalhes Produto x Fornecedor",{"SC1"})

	TRCell():New(oSection3,"01"	  			 ,,"Fornecedores"		,,TamSx3("A5_FORNECE")[1]				,.F.,,,,,,,.T.)
	TRCell():New(oSection3,"02"	  			 ,,"Loja"				,,TamSx3("A5_LOJA")[1]					,.F.,,,,,,,.T.)
	TRCell():New(oSection3,"03"	  			 ,,"Razão Social"		,,TamSx3("A2_NOME")[1]					,.F.,,,,,,,.T.)
	TRCell():New(oSection3,"04"	  			 ,,"Preço 01"			,,TamSx3("A5_PRECO01")[1]				,.F.,,,,,,,.T.)
	TRCell():New(oSection3,"05"	  			 ,,"Preço 02"			,,TamSx3("A5_PRECO01")[1]				,.F.,,,,,,,.T.)
	TRCell():New(oSection3,"06"	  			 ,,"Preço 03"			,,TamSx3("A5_PRECO01")[1]				,.F.,,,,,,,.T.)
	TRCell():New(oSection3,"07"	  			 ,,"Quantidade"			,,TamSx3("A5_QUANT01")[1]				,.F.,,,,,,,.T.)
	TRCell():New(oSection3,"08"	  			 ,,"Tipo"				,,TamSx3("A5_XTIPO")[1]					,.F.,,,,,,,.T.)
	TRCell():New(oSection3,"09"	  			 ,,"Situação"			,,TamSx3("QEG_NIVEL")[1]				,.F.,,,,,,,.T.)

	oSection3:SetHeaderSection(.T.)
	oSection3:Setnofilter("SA5")

Return oReport

/*
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
*/

Static Function ReportPrint(oReport)

	Local oSection1		:= oReport:Section(1)
	Local oSection2		:= oReport:Section(2)
	Local oSection3		:= oReport:Section(3)
	Local aDados1[99]
	Local aDados2[99]
	Local aDados3[99]
	Local _cQuery1  	:= ""
	Local _cAlias1  	:= GetNextAlias()
	Local dDtAp			:= StoD("")
	Local cStat 		:= ""
	Local lCab 			:= .T.
	Local _ctexto		:= ""

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

	//Dados do Pedido de Compras
	oSection1:Cell('21')      :SetBlock( { || aDados1[21] } )
	oSection1:Cell('22')      :SetBlock( { || aDados1[22] } )
	oSection1:Cell('23')      :SetBlock( { || aDados1[23] } )
	oSection1:Cell('24')      :SetBlock( { || aDados1[24] } )
	oSection1:Cell('25')      :SetBlock( { || aDados1[25] } )
	oSection1:Cell('26')      :SetBlock( { || aDados1[26] } )
	oSection1:Cell('27')      :SetBlock( { || aDados1[27] } )
	oSection1:Cell('28')      :SetBlock( { || aDados1[28] } )
	oSection1:Cell('29')      :SetBlock( { || aDados1[29] } )
	oSection1:Cell('30')      :SetBlock( { || aDados1[30] } )
	oSection1:Cell('31')      :SetBlock( { || aDados1[31] } )
	oSection1:Cell('32')      :SetBlock( { || aDados1[32] } )
	oSection1:Cell('33')      :SetBlock( { || aDados1[33] } )
	oSection1:Cell('34')      :SetBlock( { || aDados1[34] } )
	oSection1:Cell('35')      :SetBlock( { || aDados1[35] } )
	oSection1:Cell('36')      :SetBlock( { || aDados1[36] } )
	oSection1:Cell('37')      :SetBlock( { || aDados1[37] } )
	oSection1:Cell('38')      :SetBlock( { || aDados1[38] } )
	oSection1:Cell('39')      :SetBlock( { || aDados1[39] } )
	oSection1:Cell('40')      :SetBlock( { || aDados1[40] } )
	oSection1:Cell('41')      :SetBlock( { || aDados1[41] } )
	oSection1:Cell('42')      :SetBlock( { || aDados1[42] } ) //BRUNO REIS
	oSection1:Cell('43')      :SetBlock( { || aDados1[43] } ) //BRUNO REIS
	oSection1:Cell('44')      :SetBlock( { || aDados1[44] } ) //BRUNO REIS



	// Dados dos ultimos 5 pedidos
	oSection2:Cell("01")      :SetBlock( { || aDados2[01] } )
	oSection2:Cell("02")  	  :SetBlock( { || aDados2[02] } )
	oSection2:Cell("03")      :SetBlock( { || aDados2[03] } )
	oSection2:Cell("04")      :SetBlock( { || aDados2[04] } )
	oSection2:Cell("05")  	  :SetBlock( { || aDados2[05] } )
	oSection2:Cell("06")      :SetBlock( { || aDados2[06] } )
	oSection2:Cell("07")      :SetBlock( { || aDados2[07] } )

	// Dados dos Fornecedores x Produto
	oSection3:Cell("01")      :SetBlock( { || aDados3[01] } )
	oSection3:Cell("02")  	  :SetBlock( { || aDados3[02] } )
	oSection3:Cell("03")      :SetBlock( { || aDados3[03] } )
	oSection3:Cell("04")      :SetBlock( { || aDados3[04] } )
	oSection3:Cell("05")  	  :SetBlock( { || aDados3[05] } )
	oSection3:Cell("06")      :SetBlock( { || aDados3[06] } )
	oSection3:Cell("07")      :SetBlock( { || aDados3[07] } )
	oSection3:Cell("08")      :SetBlock( { || aDados3[08] } )
	oSection3:Cell("09")      :SetBlock( { || aDados3[09] } )

	oReport:SetTitle("Relatório de acompanhamento de SCs")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,Nil)
	aFill(aDados2,Nil)
	aFill(aDados3,Nil)
	oSection1:Init()
	oSection2:Init()
	oSection3:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	DbSelectArea("SC1")

	_lPrim 	:= .T.
	_lPrim2 := .T.

	If  Select(cAliasLif) > 0
		While 	(cAliasLif)->( !Eof() )
			_ctexto := ""

			If MV_PAR08 <> 'MOD1' .And. !lCab
				oReport:SkipLine()
				oSection1:PrintHeader(.T.)
			EndIf
			SC1->(DbGoTo((cAliasLif)->RECSC1))
			// Dados Solicitação de Compras
			aDados1[01]	:= (cAliasLif)->C1_FILIAL
			aDados1[02]	:= DtoC(StoD((cAliasLif)->C1_EMISSAO))
			aDados1[03]	:= (cAliasLif)->C1_NUM
			aDados1[04]	:= (cAliasLif)->C1_ITEM
			aDados1[05]	:= (cAliasLif)->B1_COD
			aDados1[06]	:= (cAliasLif)->B1_DESC

			//------------------------------------------------------------------------------------------------//
			//Alterações realizadas:
			//FR - 10/08/2022 - Flávia Rocha - Sigamat Consultoria
			//Após a atualização de release, a query na função StQuery não trazia dados
			//em virtude de um comando de query usado para um campo memo, provavelmente pela atualização
			//o comando não é mais reconhecido, então substituí a chamada do campo por dbseek na Sb1
			//Campo: B1_XDESEXD - Descrição estendida
			//------------------------------------------------------------------------------------------------//
			//aDados1[07]	:= (cAliasLif)->B1_XDESEXD
			SB1->(OrdSetFocus(1))
			SB1->(Dbseek(xFilial("SB1") + (cAliasLif)->B1_COD ))
			_ctexto := SB1->B1_XDESEXD  //trago o campo para trazer direto da SB1

			aDados1[07] := _ctexto
			//FR - 10/08/2022 - Correção erro na impressão dos itens - trazia em branco

			aDados1[08]	:= (cAliasLif)->B1_TIPO
			aDados1[09]	:= (cAliasLif)->B1_GRUPO
			aDados1[10]	:= (cAliasLif)->C1_QUANT
			aDados1[11]	:= (cAliasLif)->B1_UM
			aDados1[12]	:= (cAliasLif)->C1_CC
			aDados1[13]	:= (cAliasLif)->C1_MOTIVO
			aDados1[14]	:= (cAliasLif)->C1_SOLICIT
			aDados1[15]	:= UsrRetName((cAliasLif)->C1_APROV)
			aDados1[16]	:= (cAliasLif)->COMPRADOR
			aDados1[17]	:= (cAliasLif)->STATUS
			aDados1[18]	:= DtoC(StoD((cAliasLif)->DTAPROV))
			aDados1[19]	:= (cAliasLif)->C1_ZHRAPRO
			aDados1[20]	:= Posicione("SB2", 1, xFilial("SB2") + AllTrim ((cAliasLif)->B1_COD)+ AllTrim ((cAliasLif)->B1_LOCPAD), "B2_QATU")
			//Dados se Houver Pedido de Compras Ajustado 24/04/2019 Renan Rosário
			aDados1[21]	:= (cAliasLif)->C1_PEDIDO
			aDados1[22]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),"", (cAliasLif)->C7_FORNECE)
			aDados1[23]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),"", (cAliasLif)->C7_LOJA)
			aDados1[24]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),"", ALLTRIM (Posicione("SA2", 1, xFilial("SA2") + AllTrim ((cAliasLif)->C7_FORNECE) + AllTrim ((cAliasLif)->C7_LOJA), "A2_NOME")))
			aDados1[25]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),StoD(""), DtoC(StoD((cAliasLif)->PEDEMIS)))
			aDados1[26]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),"", (cAliasLif)->C7_MOTIVO)
			aDados1[27]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),"", cStat := RSTFATDST ((cAliasLif)->C1_PEDIDO, (cAliasLif)->B1_COD))
			aDados1[28]	:= Alltrim((cAliasLif)->C1_OBS)	//IIf( Empty ((cAliasLif)->C1_PEDIDO),"", (cAliasLif)->C7_OBS)
			aDados1[29]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),StoD(""), dDtAp := RSTFATDAP((cAliasLif)->C1_PEDIDO, "PC"))
			aDados1[30]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),"", (cAliasLif)->COMPRADOR)
			aDados1[31]	:= IIf( Empty ((cAliasLif)->C1_PEDIDO),"", (cAliasLif)->C7_COMPSTK)
			aDados1[32]	:= (cAliasLif)->C1_XPRCORC
			aDados1[33]	:= DtoC(StoD((cAliasLif)->C1_XDTVORC))
			aDados1[34]	:= (cAliasLif)->C1_COTACAO
			aDados1[35]	:= ULTPRCC7(aDados1[05])	// (cAliasLif)->C7_PRECO	//stretuprc(aDados1[05],1)//(cAliasLif)->C1_COTACAO
			aDados1[36]	:= stretuprc(aDados1[05],2)//(cAliasLif)->C1_COTACAO
			aDados1[37]	:= Substr(stretuprc(aDados1[05],4),1,6)	// Ultimo Fornecedor - SD1
			aDados1[38]	:= Alltrim(Posicione("SA2", 1, xFilial("SA2") + Substr(aDados1[37],1,6) + Substr(aDados1[37],7,2), "A2_NOME"))
			aDados1[39]	:= stretuprc(aDados1[05],3)//(cAliasLif)->C1_COTACAO
			aDados1[40]	:= DtoC(StoD((cAliasLif)->C1_DATPRF))
			aDados1[41]	:= Iif(!Empty((cAliasLif)->C1_PEDIDO) .And. ((cAliasLif)->C1_QUANT == (cAliasLif)->C1_QUJE), "Fechado", "Em Aberto")
			//INICIO ALTERAÇÂO BRUNO REIS
			////BRUNO REIS
			aDados1[42]	:= (cAliasLif)->C1_XTIPOSC
			aDados1[43]	:= (cAliasLif)->COL_DESC
			aDados1[44]	:= (cAliasLif)->C1_XOBSTPS
			//FIM DA ALTERAÇÂO

			oSection1:PrintLine()
			lCab := .F.
			If MV_PAR08 <> 'MOD1'
				_cQuery1 := " SELECT * "
				_cQuery1 += " FROM ( "
				_cQuery1 += " 		SELECT C7_PRECO, C7_EMISSAO, C7_NUM, C7_FORNECE, C7_LOJA "
				_cQuery1 += " 		FROM " + RetSqlName("SC7") + " C7 "
				_cQuery1 += " 		WHERE C7.D_E_L_E_T_ = ' ' "
				_cQuery1 += " 			AND C7_FILIAL = '" + (cAliasLif)->C1_FILIAL + "' "
				_cQuery1 += " 			AND C7_PRODUTO = '" + (cAliasLif)->B1_COD + "' "
				_cQuery1 += " 		ORDER BY C7_EMISSAO DESC "
				_cQuery1 += " 		) XXX "
				_cQuery1 += " WHERE ROWNUM <= 5 "
				If !Empty(Select(_cAlias1))
					DbSelectArea(_cAlias1)
					(_cAlias1)->( dbCloseArea() )
				EndIf
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
				dbSelectArea(_cAlias1)
				(_cAlias1)->( dbGoTop() )
				_nCount := 0
				If Select(_cAlias1) > 0
					While (_cAlias1)->( !Eof() )
						_nCount++
						If _nCount == 1 .And. !_lPrim
							oReport:SkipLine()
							oSection2:PrintHeader(.T.)
						EndIf
						If _lPrim
							_lPrim := .F.
						EndIf
						cStat := RSTFATDST ((cAliasLif)->C1_PEDIDO, (cAliasLif)->B1_COD)
						aDados2[01]	:= (_cAlias1)->C7_NUM
						aDados2[02]	:= (_cAlias1)->C7_PRECO
						aDados2[03]	:= (_cAlias1)->C7_FORNECE
						aDados2[04]	:= (_cAlias1)->C7_LOJA
						aDados2[05]	:= Posicione("SA2", 1, xFilial("SA2") + AllTrim ((_cAlias1)->C7_FORNECE) + AllTrim ((_cAlias1)->C7_LOJA), "A2_NOME")
						aDados2[06]	:= DTOC(STOD((_cAlias1)->C7_EMISSAO))
						aDados2[07]	:= cStat
						oSection2:PrintLine()
						(_cAlias1)->( dbSkip() )
					EndDo
				EndIf
				_cQuery1 := " SELECT * FROM (	SELECT A5_FORNECE, A5_LOJA, A5_PRECO01, A5_PRECO02, A5_PRECO03, A5_QUANT01, A5_XTIPO, A5_SITU "
				_cQuery1 += " 					FROM " + RetSqlName("SA5") + " A5 "
				_cQuery1 += " 					WHERE A5.D_E_L_E_T_ = ' ' "
				_cQuery1 += " 						AND A5_FILIAL  = '" + xFilial("SA5") + "' "
				_cQuery1 += " 						AND A5_PRODUTO = '" + (cAliasLif)->B1_COD + "' "
				_cQuery1 += " 					ORDER BY A5_FORNECE DESC ) XXX "
				If !Empty(Select(_cAlias1))
					dbSelectArea(_cAlias1)
					(_cAlias1)->( dbCloseArea() )
				EndIf
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
				dbSelectArea(_cAlias1)
				(_cAlias1)->( dbGoTop() )
				_nCount2 := 0
				If Select(_cAlias1) > 0
					While (_cAlias1)->( !Eof() )
						_nCount2++
						If _nCount2 == 1 .And. !_lPrim2
							oReport:SkipLine()
							oSection3:PrintHeader(.T.)
						EndIf
						If _lPrim2
							_lPrim2 := .F.
						EndIf
						aDados3[01]	:= (_cAlias1)->A5_FORNECE
						aDados3[02]	:= (_cAlias1)->A5_LOJA
						aDados3[03]	:= Posicione("SA2", 1, xFilial("SA2") + AllTrim ((_cAlias1)->A5_FORNECE) + AllTrim ((_cAlias1)->A5_LOJA), "A2_NOME")
						aDados3[04]	:= (_cAlias1)->A5_PRECO01
						aDados3[05]	:= (_cAlias1)->A5_PRECO02
						aDados3[06]	:= (_cAlias1)->A5_PRECO03
						aDados3[07]	:= (_cAlias1)->A5_QUANT01
						aDados3[08]	:= (_cAlias1)->A5_XTIPO
						aDados3[09]	:=  Posicione("QEG", 1, xFilial("QEG") + AllTrim ((_cAlias1)->A5_SITU), "QEG_NIVEL")
						oSection3:PrintLine()
						(_cAlias1)->( dbSkip() )
					EndDo
				EndIf
			EndIf
			//oReport:SkipLine()
			If MV_PAR08 <> 'MOD1'
				oReport:SkipLine()
				aFill(aDados2,Nil)
				oReport:SkipLine()
				aFill(aDados3,Nil)
			EndIf
			aFill(aDados1,Nil)
			(cAliasLif)->( dbskip() )
		EndDo
	EndIf

	oSection1:Finish()
	oSection2:Finish()
	oSection3:Finish()

Return oReport

/*
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
*/

Static Function StQuery()

	Local cQuery     := ' '

	If !Empty(MV_PAR12)
		If MV_PAR12 <> 3
			If MV_PAR12 == 1
				cQuery := " SELECT * FROM ( "
			EndIf
		EndIf
	EndIf

	// Ticket 20210511007757 - Inclusão de Coluna Necessidade no Relatório de S.Cs - campo C1_DATPRF
	cQuery += " SELECT C1_COTACAO, C1_FILIAL, C1_EMISSAO, C1_NUM, C1_ITEM, B1_COD, B1_DESC " + CHR(13) + CHR(10)

	//cQuery += " ,utl_raw.cast_to_varchar2(dbms_lob.substr(B1_XDESEXD,2000,1)) B1_XDESEXD, "
	cQuery += " , C1_QUANT, C1_CC, C1_MOTIVO, C1_SOLICIT, C1_APROV, NVL(Y1_NOME,' ') COMPRADOR, C1_XPRCORC, C1_XDTVORC " +  CHR(13) + CHR(10)
	cQuery += " , B1_TIPO, B1_UM, C1_LOCAL, C7_FORNECE, C7_LOJA, C7_OBS, C7_COMPSTK, C7_MOTIVO, B1_GRUPO, B1_LOCPAD, C1_OBS, C1_DATPRF, C1_QUJE " + CHR(13) + CHR(10)
	cQuery += " ,(CASE " 											+ CHR(13) + CHR(10)
	cQuery += " WHEN C1_ZSTATUS='1' THEN 'PENDENTE DE APROVACAO' "	+ CHR(13) + CHR(10)
	cQuery += " WHEN C1_ZSTATUS='2' THEN 'ANALISADO PELO GESTOR' "	+ CHR(13) + CHR(10)
	cQuery += " WHEN C1_ZSTATUS='3' THEN 'APROVADO PELO GESTOR' "	+ CHR(13) + CHR(10)
	cQuery += " WHEN C1_ZSTATUS='4' THEN 'REJEITADO PELO GESTOR' "	+ CHR(13) + CHR(10)
	cQuery += " WHEN C1_ZSTATUS='5' THEN 'REJEITADO POR COMPRAS' "	+ CHR(13) + CHR(10)
	cQuery += " WHEN C1_ZSTATUS='6' THEN 'COMPRAS' "				+ CHR(13) + CHR(10)
	cQuery += " END) STATUS "										+ CHR(13) + CHR(10)
	cQuery += " ,C1_ZDTAPRO AS DTAPROV, C1_ZHRAPRO, C1_PEDIDO, C1_RESIDUO "	+ CHR(13) + CHR(10)
	cQuery += " ,C7_EMISSAO PEDEMIS " + CHR(13) + CHR(10)
	cQuery += " ,C1.R_E_C_N_O_ RECSC1 " + CHR(13) + CHR(10)
	cQuery += " ,C1_XTIPOSC  " + CHR(13) + CHR(10)
	cQuery += " ,C1_XOBSTPS  " + CHR(13) + CHR(10)
	cQuery += " ,COL_DESC  " + CHR(13) + CHR(10)

	If !Empty(MV_PAR12)
		If MV_PAR12 <> 3
			If MV_PAR12 == 1
				cQuery += "	,      ( SELECT COUNT(*) TOTAL FROM " + RetSqlName("SC8") + " SC8"
				cQuery += "               WHERE C8_NUMSC = C1.C1_NUM "
				cQuery += "                   AND C8_ITEMSC = C1.C1_ITEM "
				cQuery += "                   AND C8_PRODUTO = C1.C1_PRODUTO "
				cQuery += "                   AND C8_NUMPED = ' ' "
				cQuery += "                   AND C8_FILIAL = C1.C1_FILIAL "
				cQuery += "                   AND D_E_L_E_T_ = ' ' ) C8 "
			EndIf
		EndIf
	EndIf

	cQuery += " FROM " + RetSqlName("SC1") + " C1 "
	cQuery += " LEFT JOIN " + RetSqlName("SB1") + " B1 "
	cQuery += " ON C1_PRODUTO = B1_COD "
	cQuery += " LEFT JOIN " + RetSqlName("SY1") + " Y1 "
	cQuery += " ON Y1_COD = C1_CODCOMP AND Y1.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + RetSqlName("SC7") + " C7 "
	cQuery += " ON C7_FILIAL = C1_FILIAL AND C1_PEDIDO = C7_NUM AND C1_ITEMPED = C7_ITEM AND C7.D_E_L_E_T_ <> '*' "
	//BRUNO INICIO ALTERAÇÃO
	cQuery += " LEFT JOIN " + RetSqlName("COL") + " COL "
	cQuery += " ON COL_FILIAL = '"+xFilial("COL")+"'  AND  C1_XTIPOSC = COL_COD AND COL.D_E_L_E_T_ <> '*' "
	//FIM ALTERAÇÃO
	cQuery += " WHERE C1.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*' "

	If !Empty(MV_PAR01) .Or. !Empty(MV_PAR02)
		cQuery += " AND C1_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	EndIf

	If !Empty(MV_PAR03) .Or. !Empty(MV_PAR04)
		cQuery += " AND C1_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	EndIf

	If !Empty(MV_PAR05) .Or. !Empty(MV_PAR06)
		cQuery += " AND C1_EMISSAO BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "' "
	EndIf

	If !Empty(MV_PAR07)
		If MV_PAR07 <> 'T'
			cQuery += " AND C1_ZSTATUS = '" + (MV_PAR07) + "' "
		EndIf
	EndIf

	If !Empty(MV_PAR09)
		cQuery += " AND C1_MOTIVO BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' "
	EndIf

	If !Empty(MV_PAR11)
		cQuery += " AND C1_CODCOMP = '" + (MV_PAR11) + "' "
	EndIf

	If !Empty(MV_PAR12)
		If MV_PAR12 <> 3
			If MV_PAR12 == 1
				cQuery += " AND C1_RESIDUO = ' ' "
				cQuery += " AND C1_PEDIDO = ' ' "
				cQuery += " AND C1.C1_QUJE < C1.C1_QUANT "//Ticket 20200416001688
				cQuery += " ) TMP "
				cQuery += " WHERE TMP.C1_COTACAO = ' ' OR TMP.C8 > 0 "
			ElseIf MV_PAR12 == 2
				cQuery += " AND C1_RESIDUO = ' ' "
				cQuery += " AND C1_PEDIDO <> ' ' "
			EndIf
		EndIf
	EndIf

	cQuery += " ORDER BY C1_FILIAL, C1_NUM, C1_ITEM, C1_EMISSAO "
	cQuery := ChangeQuery(cQuery)

	MemoWrite("C:\TEMP\REL_SCRSTFATCE.TXT" , cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

/*
|Programa  | xPutSx1	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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
*/

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cVar01,;
		cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)

	Local aArea	:= GetArea()
	Local cKey
	Local lPort	:= .F.
	Local lSpa	:= .F.
	Local lIngl	:= .F.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
	cPyme    	:= Iif( cPyme	== Nil, " ", cPyme		)
	cF3      	:= Iif( cF3		== Nil, " ", cF3        )
	cGrpSxg 	:= Iif( cGrpSxg	== Nil, " ", cGrpSxg    )
	cCnt01   	:= Iif( cCnt01	== Nil, "" , cCnt01     )
	cHelp      	:= Iif( cHelp	== Nil, "" , cHelp      )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( dbSeek( cGrupo + cOrdem ) )
		cPergunt	:= If(!"?" $ cPergunt .And. !Empty(cPergunt),Alltrim(cPergunt) + " ?", cPergunt)
		cPerSpa     := If(!"?" $ cPerSpa .And. !Empty(cPerSpa) ,Alltrim(cPerSpa) + " ?", cPerSpa)
		cPerEng     := If(!"?" $ cPerEng .And. !Empty(cPerEng) ,Alltrim(cPerEng) + " ?", cPerEng)
		/* Removido - 12/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		Reclock( "SX1" , .T. )
		Replace X1_GRUPO	With cGrupo
		Replace X1_ORDEM	With cOrdem
		Replace X1_PERGUNT	With cPergunt
		Replace X1_PERSPA	With cPerSpa
		Replace X1_PERENG	With cPerEng
		Replace X1_VARIAVL	With cVar
		Replace X1_TIPO		With cTipo
		Replace X1_TAMANHO	With nTamanho
		Replace X1_DECIMAL	With nDecimal
		Replace X1_PRESEL	With nPresel
		Replace X1_GSC		With cGSC
		Replace X1_VALID	With cValid
		Replace X1_VAR01	With cVar01
		Replace X1_F3		With cF3
		Replace X1_GRPSXG	With cGrpSxg
		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			EndIf
		EndIf
		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		EndIf
		Replace X1_HELP With cHelp
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		MsUnlock()
	Else
		lPort	:= !"?" $ X1_PERGUNT .And. !Empty(SX1->X1_PERGUNT)
		lSpa	:= !"?" $ X1_PERSPA .And. !Empty(SX1->X1_PERSPA)
		lIngl	:= !"?" $ X1_PERENG .And. !Empty(SX1->X1_PERENG)
		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->( MsUnLock() )
		EndIf*/
	EndIf

	RestArea( aArea )

Return

/*
|Programa  | RSTFATDAP	     | Autor | Renan Rosário	         | Data | 24/04/2019  |
|=====================================================================================|
|Descrição | Função para localizar a data de Liberação/Aporvação do                   |
|          | Pedido de Compras                                                        |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
*/

STATIC FUNCTION RSTFATDAP(cPedCom, cTPPC)

	Local dRet			:= StoD("")
	Local _cAlias		:= "RSTFATDAP"
	Local cQuery1		:= ""
	Default cPedCom 	:= ""
	Default cTPPC	 	:= ""

	cQuery1 := " SELECT *
	cQuery1 += " FROM " + RetSqlName("SCR") + " CR
	cQuery1 += " WHERE CR.D_E_L_E_T_ <> '*'
	cQuery1 += " AND CR.CR_FILIAL	= '" + xFilial("SCR") + "' "
	cQuery1 += " AND CR.CR_NUM 		= '" + Alltrim(cPedCom) + "' "
	cQuery1 += " AND CR.CR_TIPO 	= '" + Alltrim(cTPPC) + "' "
	cQuery1 += " AND CR.CR_STATUS 	= '05'"
	If !Empty(Select(_cAlias))
		dbSelectArea(_cAlias)
		(_cAlias)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->( dbGoTop() )
	While (_cAlias)->( !Eof() )
		dRet := DtoC(StoD((_cAlias)->CR_DATALIB))
		(_cAlias)->( dbSkip() )
	EndDo

Return dRet

/*
|Programa  | RSTFATDST	     | Autor | Renan Rosário	         | Data | 24/04/2019  |
|=====================================================================================|
|Descrição | Função para localizar o STATUS do Pedido de Compras 					  |
|          | 				                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
*/

STATIC FUNCTION RSTFATDST(cPedCom, cProd)

	Local cRet			:= ""
	Local _cQuery2		:= "RSTFATDST"
	Local cQuery2		:= ""
	Default cPedCom 	:= ""
	Default cProd	 	:= ""

	cQuery2 := " SELECT *
	cQuery2 += " FROM " + RetSqlName("SC7") + " C7 "
	cQuery2 += " WHERE C7.D_E_L_E_T_ <> '*' "
	cQuery2 += " 	AND C7.C7_FILIAL	= '" + xFilial("SC7") + "' "
	cQuery2 += " 	AND C7.C7_NUM 		= '" + Alltrim(cPedCom) + "' "
	cQuery2 += " 	AND C7.C7_PRODUTO 	= '" + Alltrim(cProd) + "' "

	If !Empty(Select(_cQuery2))
		dbSelectArea(_cQuery2)
		(_cQuery2)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),_cQuery2,.T.,.T.)

	dbSelectArea(_cQuery2)
	(_cQuery2)->( dbGoTop() )

	//While (_cQuery2)->( !Eof() )
	If !Empty(Select(_cQuery2))
		Do Case
		Case !Empty((_cQuery2)->C7_RESIDUO)
			cRet := 'Eliminado por Residuo'
		Case (_cQuery2)->C7_ACCPROC <> "1" .And. (_cQuery2)->C7_CONAPRO == "B" .And. (_cQuery2)->C7_QUJE < C7_QUANT
			cRet := 'Bloqueado'
		Case (_cQuery2)->C7_QUJE == 0 .And. (_cQuery2)->C7_QTDACLA == 0
			cRet := 'Pendente'
		Case (_cQuery2)->C7_QUJE<>0 .And. (_cQuery2)->C7_QUJE < C7_QUANT
			cRet := 'Pedido Parcialmente Atendido'
		Case (_cQuery2)->C7_QUJE >= (_cQuery2)->C7_QUANT
			cRet := 'Pedido Atendido'
		Case (_cQuery2)->C7_QTDACLA > 0
			cRet := 'Pedido Usado em Pre-Nota'
		EndCase
		//(_cQuery2)->( dbSkip() )
	EndIf
	//EndDo

Return cRet

Static Function stretuprc(_cod,_nT)

	Local _lRet
	Local _ucQuery		:= ' '
	Local _UcAliasLif	:= 'stretuprc'

	_ucQuery := ""
	_ucQuery += " SELECT R_E_C_N_O_, "
	//If _nT = 1
	//	_ucQuery += " 	D1_VUNIT AS D1RET "
	If _nT = 2
		_ucQuery += " 	D1_PEDIDO AS D1RET "
	ElseIf _nT = 3
		_ucQuery += " 	SUBSTR(D1_EMISSAO,7,2)||'/'||SUBSTR(D1_EMISSAO,5,2)||'/'||SUBSTR(D1_EMISSAO,1,4) AS D1RET "
		// Ticket 20210428006901 - Inclusão de Colunas no Relatório de S.Cs - Eduardo Pereira Sigamat - Inicio
	ElseIf _nT = 4
		_ucQuery += " 	D1_FORNECE AS D1RET, "
		_ucQuery += " 	D1_LOJA "
	EndIf
	// Ticket 20210428006901 - Inclusão de Colunas no Relatório de S.Cs- Eduardo Pereira Sigamat - Fim
	_ucQuery += " FROM " + RetSqlName("SD1") + " SD1 "
	_ucQuery += " WHERE SD1.D_E_L_E_T_ = ' ' "
	//_ucQuery += " 	AND D1_FILIAL = '" + xFilial("SD1") + "' "
	_ucQuery += " 	AND D1_PEDIDO <> ' ' "
	_ucQuery += " 	AND D1_COD = '" + _cod + "' "
	_ucQuery += " ORDER BY R_E_C_N_O_ DESC "
	If Select(_UcAliasLif) > 0
		(_UcAliasLif)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_ucQuery),_UcAliasLif)
	dbSelectArea(_UcAliasLif)
	(_UcAliasLif)->( dbgotop() )
	If  Select(_UcAliasLif) > 0
		If _nT != 4
			_lRet := (_UcAliasLif)->D1RET
		Else
			_lRet := (_UcAliasLif)->D1RET + (_UcAliasLif)->D1_LOJA
		EndIf
	Else
		If _nT = 1
			_lRet := 0
		Else
			_lRet := ' '
		EndIf
	EndIf

	If Select(_UcAliasLif) > 0
		(_UcAliasLif)->( dbCloseArea() )
	EndIf

Return _lRet

/*/Protheus.doc ULTPRCC7
	@(long_description) Tratamento para trazer o ultimo preço pago do Pedido de Compra
	@type Function
	@author Eduardo Pereira - Sigamat
	@since 01/02/2021
	@version 12.1.25
/*/

Static Function ULTPRCC7(_cod,_Mot)

	Local nPrecoC7	:= 0
	Local cQryC7	:= ""
	Local cAliasC7	:= 'ULTPRCC7'

	If Select(cAliasC7) > 0
		(cAliasC7)->( dbCloseArea() )
	EndIf
	cQryC7 := " SELECT "
	cQryC7 += " 	MAX(C7_PRECO) PRECO "
	cQryC7 += " FROM "
	cQryC7 += " 	" + RetSQLName("SC7")
	cQryC7 += " WHERE D_E_L_E_T_ = ' ' "
	cQryC7 += "     AND C7_PRODUTO = '" + _cod + "' "
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQryC7),cAliasC7)

	If Select(cAliasC7) > 0
		nPrecoC7:= (cAliasC7)->PRECO
	Else
		nPrecoC7 := 0
	EndIf

Return nPrecoC7
