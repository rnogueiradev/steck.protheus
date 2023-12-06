#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "Tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT16     ºAutor  ³Giovani Zago    º Data ³  10/07/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Saldo Disponivel		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
//===========================================================================//
//Alterações Realizadas:
//===========================================================================//
//Flávia Rocha - 10/05/2021 - Atendimento ao Ticket: #20200722004550 :
//1- "rodar" automaticamente e ser disponibilizado até as 6:00 nos e-mails 
//   dos usuários guilherme.fernandes e jefferson.puglia;
//2- Incluir uma coluna "Custo total" entre as colunas "Custo médio" e "ABC", 
//   composta pela multiplicação dos respectivos valores das colunas "Estoque" 
//   e "Custo médio", classificar por maior "Custo total" e incluir somatória 
//   na última linha. 
//===========================================================================//
//Flávia Rocha - 17/06/2021 - Atendimento ao Ticket: #20210617010282:
//Solicitado por Jefferson Puglia:
//Favor alterar posição da coluna "Local" no relatório saldo disponível, 
//hoje, ocupa a "posição" "U", favor colocar na "posição" "B", 
//deslocando as demais colunas.
//===========================================================================//
*/
/*******************************************
<<< ALTERAÇÃO >>> 
Ação...........: Receber via parâmetro a Empresa e Filial.
...............: Lembrar de incluir nos parâmetros da tabela XX1 (Schedule) a empresa e a filial. 
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 04/01/2021
Chamado........: VIRADA APOEMA NEWCO DISTRIBUIDORA
******************************************/
User Function RSTFAT16(_xcEmp,_xcFil)
	Local cMsg      	:= ""
	Local _aAttach  	:= {}
	Local _cCopia 		:= ""
	Local _cAssunto 	:= ""
	Local cMsg			:= ""
	Local _cArq     	:= ""
	Local _cCaminho 	:= ""

	Private lDentroSiga := .F.
	Private cEmp        := ""
	Private cFil        := ""
	
	/////////////////////////////////////////////////////////////////////////////////////
	////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
	/////////////////////////////////////////////////////////////////////////////////////

		
	cEmp := _xcEmp //SM0->M0_CODIGO
	cFil := _xcFil //SM0->M0_CODFIL 

	If Select( 'SX2' ) == 0

		RPCSetType( 3 )
		//Habilitar somente para Schedule   
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil
		sleep( 5000 )
		lDentroSiga := .F.
		
		U_fFAT16SCH(lDentroSiga)  
		
		Conout("RSTFAT16 -> Processo Relatorio Schedule Finalizado!")	

	Else
		lDentroSiga := .T.
		
		fFAT16()

	EndIf

Return

//------------------------------//
//Função  : fFAT16()
//Objetivo: Gera o Relatório
//------------------------------//
Static Function fFAT16()

	Local   oReport
	Private cPerg 			:= "RFAT16"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	PutSx1( cPerg, "01","Produto de:"			,"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Produto Até:"			,"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "03","Armazem:"   			,"","","mv_ch3","C",2 ,0,2,"C","",""   ,"","","mv_par03","01","","","","03","","","TODOS","","","","","","","","")
	PutSx1( cPerg, "04","Lista zerados?(S/N)"	,"","","mv_ch4","C",1 ,0,0,"G","",""   ,"","","mv_par04","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport:PrintDialog()


Return

//-----------------------------------//
//Função ReportDef()
//-----------------------------------//
Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO Saldo de Produtos",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Saldo de Produtos.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Saldo de Produtos",{"SC5"})


	TRCell():New(oSection,"Produto"			,,"Produto"		,,15,.F.,)
	TRCell():New(oSection,"Local"	 		,,"Local"		,,02,.F.,)
	TRCell():New(oSection,"Descricao" 		,,"Descricao"	,,50,.F.,)
	TRCell():New(oSection,"Estoque"   		,,"Estoque"   	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"Empenho"   		,,"Empenho"   	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"Reserva"   		,,"Reserva"   	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"Disponivel"   	,,"Disponivel"  ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"CustoM"		   	,,"Custo Médio" ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"CustoT"		   	,,"Custo Total" ,"@E 999,999,999.99",14)		//FR - 10/05/2021 - Ticket: #20200722004550
	TRCell():New(oSection,"ABC"		 		,,"ABC"			,,02,.F.,)
	TRCell():New(oSection,"FMR"		 		,,"FMR"			,,02,.F.,)
	TRCell():New(oSection,"Bloq"	 		,,"Bloqueado"	,,02,.F.,)
	TRCell():New(oSection,"Desat"	 		,,"Desativado"	,,02,.F.,)
	TRCell():New(oSection,"Grupo"	 		,,"Grupo"		,,04,.F.,)
	TRCell():New(oSection,"DescGrp"	 		,,"Desc Grp"	,,45,.F.,)
	TRCell():New(oSection,"Tipo"	 		,,"Tipo"		,,02,.F.,)
	TRCell():New(oSection,"Origem"	 		,,"Origem"		,,02,.F.,)
	TRCell():New(oSection,"DtUltVen" 		,,"Última venda",,10,.F.,)
	TRCell():New(oSection,"EstSeg"		   	,,"Est. Seg" ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"Prevven" 		,,"Prev. Vend",,10,.F.,)
	TRCell():New(oSection,"MediaTrim"	   	,,"Media Trim" ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"FornPad" 		,,"Fornecedor padrão",,40,.F.,)
	TRCell():New(oSection,"Agrup" 		    ,,"Agrupamento",,3,.F.,)
	TRCell():New(oSection,"DescAgrup" 		,,"Descr Agrup",,55,.F.,)
	TRCell():New(oSection,"DT_Invent" 		,,"Dt.Invent.",,10,.F.,)
	TRCell():New(oSection,"25"		   		,,"A Endereçar" ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"OBSMRP" 			,,"Observacao MRP",,150,.F.,)
	TRCell():New(oSection,"OBSVEN" 			,,"Observacao Vendas",,150,.F.,)
	TRCell():New(oSection,"XR01" 			,,"Produto Obsoleto",,20,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1) //QDO CHEGA AQUI JÁ TEM O CDIR, CFILE,
	Local oSection1	:= oReport:Section(1)
	Local oSection2 := oReport:Section(1)  //seção do total geral
	//Local nX		:= 0
	//Local cQuery 	:= ""
	//Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	//Local _cMediaTrim := 0
	Local oBreak     := Nil
	Local xCusTTotal := 0

	oSection1:Cell("Produto")       :SetBlock( { || aDados1[01] } )
	oSection1:Cell("Descricao")		:SetBlock( { || aDados1[02] } )
	oSection1:Cell("Estoque")		:SetBlock( { || aDados1[03] } )
	oSection1:Cell("Empenho")		:SetBlock( { || aDados1[04] } )
	oSection1:Cell("Reserva")		:SetBlock( { || aDados1[05] } )
	oSection1:Cell("Disponivel")    :SetBlock( { || aDados1[06] } )
	oSection1:Cell("CustoM")        :SetBlock( { || aDados1[07] } )
	oSection1:Cell("ABC") 		    :SetBlock( { || aDados1[08] } )
	oSection1:Cell("FMR")		    :SetBlock( { || aDados1[09] } )
	oSection1:Cell("Bloq")      	:SetBlock( { || aDados1[10] } )
	oSection1:Cell("Desat")  		:SetBlock( { || aDados1[11] } )
	oSection1:Cell("Grupo")    		:SetBlock( { || aDados1[12] } )
	oSection1:Cell("DescGrp")    	:SetBlock( { || aDados1[13] } )
	oSection1:Cell("Tipo")    		:SetBlock( { || aDados1[14] } )
	oSection1:Cell("Origem")    	:SetBlock( { || aDados1[15] } )
	oSection1:Cell("DtUltVen")    	:SetBlock( { || aDados1[16] } )
	oSection1:Cell("EstSeg")    	:SetBlock( { || aDados1[17] } )
	oSection1:Cell("Prevven")    	:SetBlock( { || aDados1[18] } )
	oSection1:Cell("MediaTrim")    	:SetBlock( { || aDados1[19] } )
	oSection1:Cell("Local")    		:SetBlock( { || aDados1[20] } )
	oSection1:Cell("FornPad")  		:SetBlock( { || aDados1[21] } )
	oSection1:Cell("Agrup")  		:SetBlock( { || aDados1[22] } )
	oSection1:Cell("DescAgrup")  	:SetBlock( { || aDados1[23] } )
	oSection1:Cell("DT_Invent")  	:SetBlock( { || aDados1[24] } )
	oSection1:Cell("25")  			:SetBlock( { || aDados1[25] } )
	oSection1:Cell("OBSMRP") 	 	:SetBlock( { || aDados1[26] } )
	oSection1:Cell("OBSVEN")  		:SetBlock( { || aDados1[27] } )
	oSection1:Cell("XR01") 	 		:SetBlock( { || aDados1[28] } )
	oSection1:Cell("CustoT")	    :SetBlock( { || aDados1[29] } )		//FR - 10/05/2021 - Ticket: #20200722004550

	//oBreak := TRBreak():New(oSection1,oSection1:Cell("CustoT"),"Total Geral",.F.)  //FR - 10/05/2021

	//Totalizadores exemplo
	//ex 1
	//oFunTot1 := TRFunction():New(oSectDad2:Cell("A1_COD"),,"COUNT",oBreak,,"@E 9999")
	//oFunTot1:SetEndReport(.F.)

	//ex 2
	//TRFunction():New(oSection2:Cell("B1_COD"),NIL,"COUNT",,,,,.F.,.T.)
	//oFunTot1 := TRFunction():New(oSection1:Cell("CustoT"),,"SUM",oBreak,,"@E 999,999,999.99")  //esse deu certo, imprimiu só no final, mas não posicionou o total abaixo da coluna respectiva,imprimiu na 1a. coluna
	//oFunTot1:SetEndReport(.T.)
	//oSection2:Cell("CustoT")	    :SetBlock( { || xCusTTotal } )		//FR - 10/05/2021 - Ticket: #20200722004550

	oReport:SetTitle("Saldo de Produtos")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:= 	(cAliasLif)->B1_COD
			aDados1[02]	:=  (cAliasLif)->B1_DESC
			aDados1[03]	:=	(cAliasLif)->ESTOQUE
			aDados1[04]	:=	(cAliasLif)->EMPENHO
			aDados1[05]	:=	(cAliasLif)->RESERVA
			aDados1[06]	:=	(cAliasLif)->DISPONIVEL
			aDados1[07]	:=	(cAliasLif)->CUSTOM
			aDados1[08]	:=	(cAliasLif)->ABC
			aDados1[09]	:=	(cAliasLif)->FMR
			aDados1[10]	:=	IIF((cAliasLif)->BLOQ=="2","N","S")
			aDados1[11]	:=	IIF((cAliasLif)->DESAT=="2","S","N")
			aDados1[12]	:=	(cAliasLif)->GRUPO
			aDados1[13]	:=	(cAliasLif)->DESCGRP
			aDados1[14]	:=	(cAliasLif)->TIPO
			aDados1[15]	:=	(cAliasLif)->ORIGEM
			aDados1[16]	:=	stod((cAliasLif)->DTULTVEN)
			aDados1[17]	:=	(cAliasLif)->B1_ESTSEG
			aDados1[18]	:=	(cAliasLif)->B1_XPREMES
			aDados1[19]	:=	GETMEDIA((cAliasLif)->B1_COD)
			aDados1[20]	:=	(cAliasLif)->B2_LOCAL
			aDados1[21]	:=	Posicione("SA2",1,xFilial("SA2")+(cAliasLif)->B1_PROC,"A2_NOME")
			aDados1[22]	:=	(cAliasLif)->BM_XAGRUP
			aDados1[23]	:=	(cAliasLif)->X5_DESCRI
			aDados1[24]	:=	STOD((cAliasLif)->B2_DINVENT)
			aDados1[25]	:=	(cAliasLif)->B2_QACLASS
			aDados1[26]	:=	(cAliasLif)->B1_XOBSMRP
			aDados1[27]	:=	(cAliasLif)->B1_XOBSVEN
			IF (cAliasLif)->B1_XR01 = "1"
				aDados1[28]	:=	"SIM"
			ELSE
				aDados1[28]	:=	"NAO"
			ENDIF
			aDados1[29] := 0
			aDados1[29] := ( (cAliasLif)->CUSTOM * (cAliasLif)->ESTOQUE )	//FR - 10/05/2021 - Ticket: #20200722004550
			xCusTTotal  := xCusTTotal + aDados1[29]	//acumula custo total

			oSection1:PrintLine()
			aFill(aDados1,nil)


			(cAliasLif)->(dbskip())

		End

		oSection2:Cell("CustoT"):SetValue( xCusTTotal )
		oSection2:PrintLine()


	EndIf


	oReport:SkipLine()


Return oReport

//--------------------------------------//
//Função  : StQuery()
//Objetivo: Monta massa de dados
//--------------------------------------//
Static Function StQuery(lDentroSiga)

	Local cQuery  := ' '
	Local xCliNao := Alltrim(GetNewPar("STRSFAT161","033467"))		//FR - 10/05/2021 - Atendimento ao Ticket: #20200722004550
	Local cAux    := ""
	Local _cFili  := ""

	cAux     := fMontaIn( Alltrim(xCliNao) )
	xCliNao  := cAux

	If lDentroSiga <> Nil .and. !lDentroSiga
		/*
		MV_PAR01 := "SDD61C20"  //TESTE RETIRAR 
		MV_PAR02 := "SDD61C40"  //TESTE RETIRAR 
		//MV_PAR02 := "SDD69ZZZ"  //TESTE RETIRAR 
		MV_PAR03 := 2  //"03"	//TESTE
		MV_PAR04 := "N"		  //TESTE
		*/

MV_PAR01 := ""
MV_PAR02 := Replicate("Z" , TAMSX3("B1_COD")[1])
MV_PAR03 := 3
MV_PAR04 := "N"

Endif

If MV_PAR03 < 3
	cQuery := " SELECT B1_COD, B2_LOCAL, B1_DESC, SUM(ESTOQUE) ESTOQUE, B1_XPREMES, B1_ESTSEG, B1_XOBSMRP, B1_XOBSVEN, B1_XR01, "
	cQuery += " SUM(EMPENHO) EMPENHO, SUM(RESERVA) RESERVA, SUM(DISPONIVEL) DISPONIVEL, CUSTOM, "
	cQuery += " ABC, FMR, BLOQ, DESAT, GRUPO, DESCGRP, TIPO, ORIGEM, DTULTVEN, B1_PROC, BM_XAGRUP, X5_DESCRI, B2_DINVENT,B2_QACLASS "
	cQuery += ", SUM(CUSTOT) " //FR - 10/05/2021 -Atendimento ao Ticket: #20200722004550
	cQuery += " FROM ( "
EndIf

cQuery += " SELECT DISTINCT CODIGO B1_COD, B2_LOCAL, DESCRICAO B1_DESC, ESTOQUE, B1_XPREMES, B1_ESTSEG, B1_XOBSMRP, B1_XOBSVEN, B1_XR01, "
cQuery += " EMPENHO, RESERVA, ESTOQUE-EMPENHO-RESERVA DISPONIVEL, CUSTOM, "
cQuery += " (ESTOQUE * CUSTOM) AS CUSTOT, " //FR - 10/05/2021 -Atendimento ao Ticket: #20200722004550
cQuery += " B1_XABC ABC, B1_XFMR FMR, B1_MSBLQL BLOQ, B1_XDESAT DESAT, B1_GRUPO GRUPO, BM_DESC DESCGRP, "
cQuery += " B1_TIPO TIPO, B1_CLAPROD ORIGEM, DTULTVEN, B1_PROC , BM_XAGRUP, X5_DESCRI ,B2_DINVENT,B2_QACLASS "
cQuery += " FROM ( "
cQuery += " SELECT B2_COD CODIGO, B2_LOCAL,B2_DINVENT,B2_QACLASS, B1_DESC DESCRICAO, B2_QATU ESTOQUE, B1_XPREMES, B1_ESTSEG, B1_XOBSMRP, B1_XOBSVEN, B1_XR01, "
cQuery += " NVL((SELECT SUM(BF_EMPENHO) FROM "+RetSqlName("SBF")+" BF WHERE BF.D_E_L_E_T_=' ' AND B2.B2_FILIAL=BF.BF_FILIAL "
cQuery += " AND BF.BF_PRODUTO=B2.B2_COD AND BF.BF_LOCAL=B2.B2_LOCAL),0) AS EMPENHO, "
cQuery += " NVL((SELECT SUM(PA2_QUANT)  FROM "+RetSqlName("PA2")+" PA2  WHERE PA2_CODPRO = B2.B2_COD  AND PA2.D_E_L_E_T_ = ' '  "
cQuery += " AND PA2_FILRES =  '"+xFilial("SB2")+"' AND B2.B2_LOCAL=B1.B1_LOCPAD  ),0) RESERVA, "
cQuery += " NVL((SELECT B2_CMFIM1 FROM "+RetSqlName("SB2")+" B2 WHERE B2.D_E_L_E_T_=' ' AND B2_COD=B1.B1_COD AND B2_FILIAL='"+xFilial("SB2")+"' "
cQuery += " AND B2_LOCAL=B1.B1_LOCPAD),0) CUSTOM, "
cQuery += " B1_XABC, B1_XFMR, B1_MSBLQL, B1_XDESAT, B1_GRUPO, BM_DESC, B1_TIPO, B1_CLAPROD, "
//cQuery += " NVL((SELECT MAX(F2_EMISSAO) FROM "+RetSqlName("SF2")+" F2 WHERE F2.D_E_L_E_T_=' ' AND F2_CLIENTE<>'033467' "
cQuery += " NVL((SELECT MAX(F2_EMISSAO) FROM "+RetSqlName("SF2")+" F2 WHERE F2.D_E_L_E_T_=' ' AND F2_CLIENTE NOT IN (" + Alltrim(xCliNao) + " ) " //FR - 10/05/2021 -Atendimento ao Ticket: #20200722004550 - deixar num parâmetro, qdo quiser mudar só mexer no parâmetro
cQuery += " AND F2_FILIAL||F2_DOC IN (  SELECT DISTINCT D2_FILIAL||D2_DOC FROM "+RetSqlName("SD2")+" D2 WHERE D2.D_E_L_E_T_=' ' "
cQuery += " AND D2_COD=B1.B1_COD)),' ') DTULTVEN, B1_PROC , BM_XAGRUP, X5_DESCRI "
cQuery += " FROM "+RetSqlName("SB2")+" B2 "
cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
cQuery += " ON B1.B1_COD=B2.B2_COD AND B1.D_E_L_E_T_=' ' "      // Valdemir Rabelo 11/03/2022 - Chamado: 20220301004768
cQuery += " LEFT JOIN "+RetSqlName("SBM")+" BM "
cQuery += " ON BM.BM_GRUPO=B1.B1_GRUPO AND BM.D_E_L_E_T_=' ' "       // Valdemir Rabelo 11/03/2022 - Chamado: 20220301004768
cQuery += " LEFT JOIN "+RetSqlName("SX5")+" X5 "
cQuery += " ON X5.X5_CHAVE=BM.BM_XAGRUP AND X5_TABELA = 'ZZ' AND X5.D_E_L_E_T_=' '"         // Valdemir Rabelo 11/03/2022 - Chamado: 20220301004768
cQuery += " WHERE B2.D_E_L_E_T_=' ' AND B2_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND B2_FILIAL='"+xFilial("SB2")+"' "

If MV_PAR04=="N"
	cQuery += "	AND B2_QATU>0 "
EndIf

cQuery += " ) "

If MV_PAR03<3

	If MV_PAR03==1
		cQuery += " ) WHERE B2_LOCAL='01' "
	Elseif MV_PAR03==2
		If  cFilAnt = '04'
			cQuery += " ) WHERE B2_LOCAL='90' "
		Else
			cQuery += " ) WHERE B2_LOCAL='03' "
		EndIf
	EndIf
	cQuery += " GROUP BY B1_COD, B2_LOCAL, B1_DESC, B1_XPREMES, B1_ESTSEG, CUSTOM, CUSTOT, "		//FR - 10/05/2021 -Atendimento ao Ticket: #20200722004550 - deixar num parâmetro, qdo quiser mudar só mexer no parâmetro
	cQuery += " ABC, FMR, BLOQ, DESAT, GRUPO, DESCGRP, TIPO, ORIGEM, DTULTVEN, B1_PROC , BM_XAGRUP, X5_DESCRI,B2_DINVENT ,B2_QACLASS
	cQuery += " ,B1_XOBSMRP, B1_XOBSVEN, B1_XR01
EndIf
cQuery += " ORDER BY CUSTOT DESC "
MemoWrite("C:\TEMP\RSTFAT16.SQL", cQuery)

//Query antiga
	/*
	cQuery := "  SELECT
	cQuery += "  B1_COD,
	cQuery += "  B1_DESC   ,
	cQuery += "  NVL(ESTOQUE,0) ESTOQUE ,
	cQuery += " B1_XPREMES, NVL(B1_ESTSEG,0) B1_ESTSEG,
	cQuery += "  NVL(EMPENHO,0) EMPENHO ,
	cQuery += "  NVL((SELECT SUM(PA2_QUANT)
	cQuery += "  FROM PA2010 PA2
	cQuery += "  WHERE PA2_CODPRO = B1_COD
	cQuery += "  AND PA2.D_E_L_E_T_ = ' '
	cQuery += "  AND PA2_FILRES =  '"+xFilial("SBF")+"'"
	cQuery += "  ),0)
	cQuery += '  "RESERVA" ,
	
	cQuery += "  ESTOQUE-EMPENHO-
	cQuery += "  NVL((SELECT SUM(PA2_QUANT)
	cQuery += "  FROM PA2010 PA2
	cQuery += "  WHERE PA2_CODPRO = B1_COD
	cQuery += "  AND PA2.D_E_L_E_T_ = ' '
	cQuery += "  AND PA2_FILRES = '"+xFilial("SBF")+"'"
	cQuery += "   ),0)
	cQuery += '  "DISPONIVEL"
	cQuery += " ,NVL((SELECT B2_CM1 FROM "+RetSqlName("SB2")+" B2 WHERE B2.D_E_L_E_T_=' ' AND B2_COD=SB1.B1_COD AND B2_FILIAL="+cFilAnt+" AND B2_LOCAL=SB1.B1_LOCPAD),0)
	cQuery += ' "CUSTOM"
	cQuery += ' ,B1_XABC "ABC", B1_XFMR "FMR", B1_MSBLQL "BLOQ", B1_XDESAT "DESAT", B1_GRUPO "GRUPO", '
	cQuery += " (SELECT BM_DESC FROM "+RetSqlName("SBM")+" BM WHERE BM.D_E_L_E_T_=' ' AND BM_GRUPO=SB1.B1_GRUPO)
	cQuery += ' "DESCGRP" '
	cQuery += ' ,B1_TIPO "TIPO", B1_CLAPROD "ORIGEM", '
	cQuery += " (SELECT MAX(F2_EMISSAO) FROM "+RetSqlName("SF2")+" F2 WHERE F2.D_E_L_E_T_=' ' AND F2_CLIENTE<>'033467' AND F2_FILIAL||F2_DOC IN ( "
	cQuery += " SELECT DISTINCT D2_FILIAL||D2_DOC FROM "+RetSqlName("SD2")+" D2 WHERE D2.D_E_L_E_T_=' ' AND D2_COD=SB1.B1_COD))
	cQuery += ' "DTULTVEN" '
	
	cQuery += "  FROM SB1010 SB1
	If mv_par04=="S"
		cQuery += "  LEFT
	Else
		cQuery += "  INNER
	EndIf
	cQuery += "  JOIN(
	cQuery += "  SELECT BF_PRODUTO, SUM(BF_QUANT)
	cQuery += '  "ESTOQUE"  , SUM(BF_EMPENHO)
	cQuery += '  "EMPENHO"
	cQuery += "  FROM SBF010 SBF
	cQuery += "  WHERE  "
	
	If MV_PAR03==1
		cQuery += "  BF_LOCAL='01' AND "
	ElseIf MV_PAR03==2
		cQuery += "  BF_LOCAL='03' AND "
	EndIf
	
	cQuery += "  BF_FILIAL  = '"+xFilial("SBF")+"'"
	cQuery += "  AND SBF.D_E_L_E_T_ = ' '
	cQuery += "  GROUP BY BF_PRODUTO )TBF
	cQuery += "  ON B1_COD = TBF.BF_PRODUTO
	
	cQuery += "  WHERE SB1.D_E_L_E_T_ = ' '
	cQuery += "  AND SB1.B1_COD BETWEEN  '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND B1_TIPO='PA' "
	cQuery += "  ORDER BY B1_COD
	
	//SELECT B1_COD,B1_DESC,ESTOQUE,EMPENHO,COALESCE((SELECT SUM(PA2_QUANT) FROM PA2010 PA2 WHERE  PA2_CODPRO = B1_COD AND PA2.D_E_L_E_T_ = ' ' AND PA2_FILRES = '02' ),0) "RESERVA",ESTOQUE-EMPENHO-  COALESCE((SELECT SUM(PA2_QUANT) FROM PA2010 PA2 WHERE  PA2_CODPRO = B1_COD AND PA2.D_E_L_E_T_ = ' ' AND PA2_FILRES = '02' ),0) "DISPONIVEL" FROM SB1010 SB1 INNER JOIN(SELECT BF_PRODUTO,SUM(BF_QUANT) "ESTOQUE",SUM(BF_EMPENHO) "EMPENHO" FROM SBF010 SBF WHERE  BF_LOCAL = '03' AND BF_FILIAL = '02' AND SBF.D_E_L_E_T_ = ' ' GROUP BY BF_PRODUTO ) TBF ON B1_COD = TBF.BF_PRODUTO  WHERE  SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD BETWEEN '               ' AND 'zzzzzzzzzzzzzzz'  ORDER BY  B1_COD
	*/
cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

//-----------------------------------//
//Função GETMEDIA
//-----------------------------------//
Static Function GETMEDIA(_cCod)

	Local _nMedia	:= 0

	DbSelectArea("SB3")
	SB3->(DbSetOrder(1))
	SB3->(Dbseek(xfilial("SB3")+_cCod))
	_nMedia  := (&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2))+;
		&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2))+;
		&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)))/3

Return(_nMedia)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT16     ºAutor  ³Giovani Zago    º Data ³  10/07/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Saldo Disponivel		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xRSTFAT16(lJobAuto)

	Local   oReport
	Local	 nX				:= 0
	Private cPerg 			:= "XRFAT16"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	Private _cTitulo        := "Relatorio Saldo Disponivel"
	Private cPergTit 		:= cAliasLif
	Private cPastaRel 		:= "\arquivos\"
	Private carquivo_       := 	"RSTFAT16"
	Private cAnexo			:= ""
	Private cPara 			:= SuperGetMV("ST_RSFAT16",.F.,"henrique.youssef@steck.com.br;rafael.rivani@steck.com.br;david.junior@steck.com.br")

	Default lJobAuto 	:= .F.

	If lJobAuto



		For nX := 1 To 2 //Roda 2 x
			If nX == 1
				//Cria as definições do relatório
				oReport := ReportDef()
				MV_PAR01 := ""
				MV_PAR02 := Replicate("Z" , TAMSX3("B1_COD")[1])
				MV_PAR03 := 3
				MV_PAR04 := "N"

				//Define um nome do arquivo dentro da Protheus Data - pasta 'x_arquivos'
				cAnexo := carquivo_ + dToS(dDataBase) + StrTran(Time(), ":", "-") + ".xls"

				//Define para o relatório não mostrar na tela, o Device 4 (Planilha), define o arquivo, e define para imprimir

				oReport:lPreview:= .F.
				oReport:SetTpPlanilha({.F., .F., .T., .F.})
				oReport:setFile(cPastaRel+cAnexo)

				oReport:nDevice			:= 4 	//1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
				oReport:nEnvironment	:= 1 // 1 -Server / 2- Cliente
				oReport:nRemoteType		:= NO_REMOTE
				oReport:cDescription 	:= _cTitulo
				oReport:cFile 			:= cPastaRel+carquivo_+"\"+cAnexo
				oReport:lParamPage 		:= .F.


				oReport:Print(.F.)

			Else
				If File(cPastaRel+carquivo_+"\"+cAnexo)

					_cEmail     := cPara
					_cArq       := Strtran(cAnexo,".xls",".zip")
					_aAttach    := {}
					_cCopia 	:= ""
					_cAssunto   := "[WFPROTHEUS] - " + Alltrim(_cTitulo)
					cMsg		:= ""
					cArqvivoZip := cPastaRel + carquivo_+"\" + Strtran(cAnexo,".xls",".zip")
					
					aadd( _aAttach  , _cArq )
					
					nZip := FZip(cArqvivoZip, {cPastaRel + carquivo_+"\"+cAnexo} , cPastaRel + carquivo_+"\" ,"" )

					cMsg := '<html><head><title>stkSales</title></head>
					cMsg += '<body>
					cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
					cMsg += '<br><br>Olá <b></b>,<br><br> ' //cMsg += '<br><br>Olá <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
					cMsg += 'Você está recebendo o '+ Alltrim(_cTitulo) +' da Steck!<br>
					cMsg += 'Obrigado!<br><br>'
					cMsg += 'Atenciosamente,<br>
					cMsg += 'Steck Indústria Elétrica Ltda
					cMsg += '</body></html>'

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,cPastaRel+carquivo_+"\")  //não funcionou

					cParada := ""
					//oReport:PrintDialog()
				EndIf
			EndIf
		Next nX
	Else
		PutSx1( cPerg, "01","Produto de:"			,"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
		PutSx1( cPerg, "02","Produto Até:"			,"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
		PutSx1( cPerg, "03","Armazem:"   			,"","","mv_ch3","C",2 ,0,2,"C","",""   ,"","","mv_par03","01","","","","90","","","TODOS","","","","","","","","")
		PutSx1( cPerg, "04","Lista zerados?(S/N)"	,"","","mv_ch4","C",1 ,0,0,"G","",""   ,"","","mv_par04","","","","","","","","","","","","","","","","")

		oReport		:= ReportDef()
		oReport:PrintDialog()
	Endif
Return


//----------------------------------------------------------------------------------//
//Função : fMontaIN
//Autoria: Flávia Rocha
//Data   : 14/12/2020
//Objetivo: função que recebe uma cadeia de caracteres e monta a expressão "IN" para
//          ser inserida na cláusula WHERE <campo> IN ...com as aspas e vírgulas em
//          seus devidos lugares.
//----------------------------------------------------------------------------------//
Static Function fMontaIN(cTexto)

	Local cAux := ""
	Local fr   := 0

	For fr := 1 to Len(cTexto)
		If fr = 1
			cAux += "'" + Substr(cTexto,fr,1)
		Endif

		If fr > 1
			If Substr(cTexto,fr,1) != ","
				cAux += Substr(cTexto,fr,1)
			Else
				cAux += "'" + ",'"  //encerra com aspa o argumento e coloca vírgula preparando para o próximo argumento
			Endif
		Endif

		If fr = Len(cTexto)
			cAux += "'"      //coloca aspa simples no último argumento
		Endif
	Next

	If Substr(cAux,Len(cAux),1) = ","
		cAux := Substr(cAux,1,Len(cAux)-1) //retira a vírgula do último argumento
	Endif

Return(cAux)


//========================================================================//
// Programa    fFAT16SCH   Autoria: Flavia Rocha      Data:  13/05/2021   //
//========================================================================//
// Descricao : Gera o relatorio Saldo Disponivel e envia por email        //
//========================================================================//
// Uso       : Schedule                                                   //
//========================================================================//
User Function fFAT16SCH(lDentroSiga)

	Local cStartPath:= GetSrvProfString("Startpath","")
	Local cTitulo   := ""
	Local cArquivo  := "RSTFAT16_" + Dtos(Date()) + "_" + Substr(Time(),1,2) + "_" + Substr(Time(),4,2) + ".XML"
	Local cPath     := ""
	Local cPlan     := ""
	Local nX		:= 0
	Local oExcel    := Nil
	Local oExcelApp := Nil
	Local nAtual    := 0

	Local nTamDados := 99
	Local aDados1   := {}
	Local nCont     := 0

	Local aArmazens		:= {"1=01",;
		"2=03",;
		"3=TODOS"}

	Local aLista		:= {"1=Sim",;
		"2=Não",;
		"3=TODOS"}

	Local fr

	Private aParambox := {}
	Private aParam    := {}
	Private aRet      := {}
	Private cPerg 	  := "RFAT16"
	Private cTime     := Time()
	Private cHora     := SUBSTR(cTime, 1, 2)
	Private cMinutos  := SUBSTR(cTime, 4, 2)
	Private cSegundos := SUBSTR(cTime, 7, 2)
	Private cAliasLif := cPerg+cHora+ cMinutos+cSegundos
	Private xCusTTotal:= 0
	Private cEmails     := ""

	cStartPath := "\arquivos\rstfat16\"

/*01*/AAdd( aParamBox, { 1, "Produto de"			,SPACE(TamSX3('B1_COD')[01])			,	""			,	"" ,	"SB1"			,	"",	50,	.F.}) 
/*02*/AAdd( aParamBox, { 1, "Produto ate"			,Replicate('Z' , TamSX3('B1_COD')[01])	,	""			,	"" ,	"SB1"			,	"",	50,	.T.}) 
/*03*/AAdd( aParamBox, { 2, "Armazém"       		,1									 	,	aArmazens	,	100,	"AllwaysTrue()"	,	.T.			})
/*04*/AAdd( aParamBox, { 1, "Lista Zerados?(S/N)"	,SPACE(1)			 					,	""			,	"" ,	""				,	"",	50,	.F.}) 

//parametros
	MV_PAR01 := "" 										//"SDD61C20"
	MV_PAR02 := Replicate("Z" , TAMSX3("B1_COD")[1]) 	//"SDD61C40"
	MV_PAR03 := 3	//2="03", 3=TODOS
	MV_PAR04 := "N"


	Aadd(aRet, MV_PAR01)
	Aadd(aRet, MV_PAR02)
	Aadd(aRet, MV_PAR03)
	Aadd(aRet, MV_PAR04)

	For nX := 1 to Len(aParamBox)
		If aParambox[nX,1] == 2
			aAdd(aParam,aParambox[nX,4,aRet[nX]])
		Else
			aAdd(aParam,aRet[nX])
		EndIf
	Next nX

	StQuery(lDentroSiga)

	DbSelectArea((cAliasLif))
	(cAliasLif)->(Dbgotop())

	If (cAliasLif)->(Eof())
		MsgAlert("Sem Dados para Gerar o Relatorio.")
		Return
	EndIf

	cPath     := "C:\TEMP\EXCEL\"

	If !ExistDir(cPath)
		MakeDir(cPath)
	EndIf

	cPlan   := "Parametros"

	cTabela := "Relatorio Saldo Disponivel"	//Ti­tulo interno da planilha
	cTitulo := "Relatorio Saldo Disponivel"	//Ti­tulo interno da planilha

	oExcel    := FWMSEXCEL():New()

//GERA ABA COM OS PARAMETROS
	oExcel:AddworkSheet(cPlan)
	oExcel:AddTable(cPlan,cTabela)
	oExcel:AddColumn(cPlan,cTabela,"Parametro",1,1,.F.)
	oExcel:AddColumn(cPlan,cTabela,"Descricao",1,1,.F.)
	oExcel:AddColumn(cPlan,cTabela,"Conteudo",1,1,.F.)

	For nX := 1 to Len(aParambox)
		oExcel:AddRow(cPlan,cTabela,{	"MV_PAR"+STRZERO(nX,2),;
			Alltrim(aParambox[nX,2]),;
			aParam[nX]})
	Next nX

	cPlan := cTitulo
	oExcel:AddworkSheet(cPlan)
	oExcel:AddTable(cPlan,cTabela)

	//Criando Colunas
 /*
 oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col1",1,1) //1 = Modo Texto
 oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col2",2,2) //2 = Valor sem R$
 oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col3",3,3) //3 = Valor com R$
 oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col4",1,1)
 */

	oExcel:AddColumn(cPlan,cTabela,"Produto"			,1,1,.F.)  		//1
	oExcel:AddColumn(cPlan,cTabela,"Local"				,1,2,.F.)  		//2 //FR - 17/06/2021 - Ticket: #20210617010282
	oExcel:AddColumn(cPlan,cTabela,"Descricao"			,1,1,.F.) 		//3
	oExcel:AddColumn(cPlan,cTabela,"Estoque"			,1,1,.F.) 		//4
	oExcel:AddColumn(cPlan,cTabela,"Empenho"			,1,1,.F.)  		//5
	oExcel:AddColumn(cPlan,cTabela,"Reserva"			,1,1,.F.)		//6
	oExcel:AddColumn(cPlan,cTabela,"Disponivel"			,2,2,.F.)		//7
	oExcel:AddColumn(cPlan,cTabela,"Custo Médio"		,1,1,.F.)   	//8
	oExcel:AddColumn(cPlan,cTabela,"Custo Total"		,1,1,.F.)		//9
	oExcel:AddColumn(cPlan,cTabela,"ABC"				,1,1,.F.) 		//10
	oExcel:AddColumn(cPlan,cTabela,"FMR"				,1,2,.F.)		//11
	oExcel:AddColumn(cPlan,cTabela,"Bloqueado"			,1,3,.F.) 		//12
	oExcel:AddColumn(cPlan,cTabela,"Desativado"			,1,3,.F.) 		//13
	oExcel:AddColumn(cPlan,cTabela,"Grupo"				,1,3,.F.) 		//14
	oExcel:AddColumn(cPlan,cTabela,"Desc Grp"			,1,2,.F.)  		//15
	oExcel:AddColumn(cPlan,cTabela,"Tipo"				,1,3,.F.)  		//16
	oExcel:AddColumn(cPlan,cTabela,"Origem"				,1,3,.F.)		//17
	oExcel:AddColumn(cPlan,cTabela,"Última venda"		,1,2,.F.)		//18
	oExcel:AddColumn(cPlan,cTabela,"Est. Seg"			,2,2,.F.)   	//19  //ajuste do formato
	oExcel:AddColumn(cPlan,cTabela,"Prev. Vend"			,2,2,.F.)       //20 //ajuste do formato
	oExcel:AddColumn(cPlan,cTabela,"Media Trim"			,2,2,.F.)  		//21 //ajuste do formato
	oExcel:AddColumn(cPlan,cTabela,"Fornecedor padrão"	,1,3,.F.) 		//22
	oExcel:AddColumn(cPlan,cTabela,"Agrupamento"		,1,3,.F.) 		//23
	oExcel:AddColumn(cPlan,cTabela,"Descr Agrup"		,1,2,.F.)  		//24
	oExcel:AddColumn(cPlan,cTabela,"Dt.Invent."			,1,3,.F.) 		//25
	oExcel:AddColumn(cPlan,cTabela,"A Endereçar"		,1,1,.F.)       //26
	oExcel:AddColumn(cPlan,cTabela,"Observacao MRP"		,1,1,.F.)   	//27
	oExcel:AddColumn(cPlan,cTabela,"Observacao Vendas"	,1,1,.F.) 		//28
	oExcel:AddColumn(cPlan,cTabela,"Produto Obsoleto"	,1,3,.F.)     	//29


	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	aDados := {}				//array principal que será usado na impressão do relatório
	aDados1:= {}				//array de transição
	If  Select(cAliasLif) > 0

		nTamDados := 29
		While (cAliasLif)->(!Eof())

			aDados1 := {}		//limpa o array de transição
			aDados1 := array(nTamDados)

			aDados1[01] :=(cAliasLif)->B1_COD
			aDados1[02] :=(cAliasLif)->B2_LOCAL
			aDados1[03] :=(cAliasLif)->B1_DESC
			aDados1[04] :=(cAliasLif)->ESTOQUE
			aDados1[05] :=(cAliasLif)->EMPENHO
			aDados1[06] :=(cAliasLif)->RESERVA
			aDados1[07] :=Transform( (cAliasLif)->DISPONIVEL , "@E 9,999,999,999.9999")
			aDados1[08] :=(cAliasLif)->CUSTOM
			aDados1[09] := ( (cAliasLif)->CUSTOM * (cAliasLif)->ESTOQUE )	//custo total
			aDados1[10] :=(cAliasLif)->ABC
			aDados1[11] :=(cAliasLif)->FMR
			aDados1[12] :=IIF((cAliasLif)->BLOQ=="2","N","S")
			aDados1[13] :=IIF((cAliasLif)->DESAT=="2","S","N")
			aDados1[14] :=(cAliasLif)->GRUPO
			aDados1[15] :=(cAliasLif)->DESCGRP
			aDados1[16] :=(cAliasLif)->TIPO
			aDados1[17] :=(cAliasLif)->ORIGEM
			aDados1[18] :=stod((cAliasLif)->DTULTVEN)
			aDados1[19] :=Transform( (cAliasLif)->B1_ESTSEG, "@E 9,999,999,999.9999" )  //aDados1[19] :=(cAliasLif)->B1_ESTSEG
			aDados1[20] :=(cAliasLif)->B1_XPREMES
			aDados1[21] := GETMEDIA((cAliasLif)->B1_COD)
			aDados1[22] :=Posicione("SA2",1,xFilial("SA2")+(cAliasLif)->B1_PROC,"A2_NOME")
			aDados1[23] :=(cAliasLif)->BM_XAGRUP
			aDados1[24] :=(cAliasLif)->X5_DESCRI
			aDados1[25] :=STOD((cAliasLif)->B2_DINVENT)
			aDados1[26] :=(cAliasLif)->B2_QACLASS
			aDados1[27] :=(cAliasLif)->B1_XOBSMRP
			aDados1[28] :=(cAliasLif)->B1_XOBSVEN
			IF (cAliasLif)->B1_XR01 = "1"
				aDados1[29]	:=	"SIM"
			ELSE
				aDados1[29]	:=	"NAO"
			ENDIF

			xCusTTotal  := xCusTTotal + aDados1[09]	//acumula custo total

			(cAliasLif)->(dbSkip())

			aadd(aDados, aDados1)		//adiciona os dados no array principal,

		EndDo

		//cria a linha do total geral (nova coluna "Custo Total")
		aDados1 := {}
		aDados1 := array(nTamDados)

		aDados1[01] := ""
		aDados1[02] := ""
		aDados1[03] := ""
		aDados1[04] := ""
		aDados1[05] := ""
		aDados1[06] := ""
		aDados1[07] := 0
		aDados1[08] := ""
		aDados1[09] := xCusTTotal
		aDados1[10] := ""
		aDados1[11] := ""
		aDados1[12] := ""
		aDados1[13] := ""
		aDados1[14] := ""
		aDados1[15] := ""
		aDados1[16] := ""
		aDados1[17] := ""
		aDados1[18] := ""
		aDados1[19] := ""
		aDados1[20] := ""
		aDados1[21] := 0
		aDados1[22] := ""
		aDados1[23] := ""
		aDados1[24] := ""
		aDados1[25] := ""
		aDados1[26] := ""
		aDados1[27] := ""
		aDados1[28] := ""
		aDados1[29] := ""

		aadd(aDados, aDados1)  //linha do total

		If Len(aDados) > 0

			For fr := 1 to Len(aDados)
				oExcel:AddRow(cPlan,cTabela,{   aDados[fr,1],;
					aDados[fr,2],;
					aDados[fr,3],;
					aDados[fr,4],;
					aDados[fr,5],;
					aDados[fr,6],;
					aDados[fr,7],;
					aDados[fr,8],;
					aDados[fr,9],;
					aDados[fr,10],;
					aDados[fr,11],;
					aDados[fr,12],;
					aDados[fr,13],;
					aDados[fr,14],;
					aDados[fr,15],;
					aDados[fr,16],;
					aDados[fr,17],;
					aDados[fr,18],;
					aDados[fr,19],;
					aDados[fr,20],;
					aDados[fr,21],;
					aDados[fr,22],;
					aDados[fr,23],;
					aDados[fr,24],;
					aDados[fr,25],;
					aDados[fr,26],;
					aDados[fr,27],;
					aDados[fr,28],;
					aDados[fr,29];
					} )
			Next

		Endif
		oExcel:Activate()
		oExcel:GetXMLFile( cStartPath+cArquivo )

		//CpyS2T( cStartPath + cArquivo, cPath )

		oExcelApp := MsExcel():New()
		//oExcelApp:WorkBooks:Open( cPath + cArquivo ) // Abre a planilha automaticamente //retirar
		oExcelApp:SetVisible(.T.)

		//MsgInfo("Arquivo Gravado na Pasta --> " + cPath + cArquivo )		//RETIRAR
		Conout("RSTFAT16 -> Arquivo Gravado na Pasta --> " + cPath + cArquivo )

		//ENVIA POR EMAIL
		cEmails     := Alltrim(GetNewPar("STRSFAT162","jefferson.puglia@steck.com.br;guilherme.fernanez@steck.com.br;paulo.filho@steck.com.br;richely.lima@steck.com.br"))
		//cEmails 	:= "flah.rocha@sigamat.com.br" //;jefferson.puglia@steck.com.br"  //retirar
		_cEmail     := cEmails
		_cArq       := cArquivo
		_aAttach    := {}
		_cCopia 	:= ""
		_cAssunto   := "[WFPROTHEUS] - " + Alltrim(cTitulo)
		cMsg		:= ""
		aadd( _aAttach  , cStartPath+_cArq )
		//_cCaminho   := ""
		//cAnexo      := cStartPath + cArquivo

		cMsg := '<html><head><title>stkSales</title></head>
		cMsg += '<body>
		cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
		cMsg += '<br><br>Olá <b></b>,<br><br> ' //cMsg += '<br><br>Olá <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
		cMsg += 'Você está recebendo o relatório de Saldo Disponível da Steck!<br>
		cMsg += 'Obrigado!<br><br>'
		cMsg += 'Atenciosamente,<br>
		cMsg += 'Steck Indústria Elétrica Ltda
		cMsg += '</body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,"")  //não funcionou

		//lEnviou := U_FRSendMail(_cEmail, _cCopia, _cAssunto, cMsg, cAnexo)
		//If lEnviou
		//MsgAlert("OK EMAIL")
		//Else
		//MsgAlert("ERRO EMAIL")
		//Endif

	Endif

Return

/*==========================================================================
|Funcao    | FRSendMail          | Flávia Rocha         | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
User Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cFrom		:= GetMV( "MV_RELACNT" )   
Local cAttach 	:= cAnexo


CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )
