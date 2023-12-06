#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#Include "TOPCONN.CH"
#include 'Protheus.ch'
#DEFINE CR    chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Metodo   ³ STFATG02 ºAutor  ³ giovani.zago       º Data ³  28/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

±±ºDesc.     ³ Recalcula o valor de venda baseando-se na UF do cliente    º±±
±±º          ³ e no fator de reducao de ICMS, clientes com A1_CONTRIB='1' º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºValidacao ³  Gatilho do campo C6_PRODUTO - Item 2.4 MIT044             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³  Giovani.Zago Fiz Funcionar...                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//FR - 07/01/2022 - Revisões quanto ao "enter" no gatilho, estava incrementando
//                  corrigido, ok, qdo der um 2o. , 3o. ...n enters no campo
//                  quantidade (C6_QTDVEN), ele vai reiniciar o campo do preço
//                  pelo preço de tabela DA1 e não incrementar ok
//------------------------------------------------------------------------------//
//FR - Flávia Rocha - 17/02 - Alteração realizada: 
//Implementar parâmetro de uso de inflação de preço, mediante código de tabela
//Se o parâmetro estiver = "ZZZ" é para inflar pra todas as tabelas de preço
//Se o parâmetro estiver = "código tabela" separados por vírgula, fazer a inflação
//apenas para as tabelas especificas no parâmetro
//Parâmetro: ST_TABINFL
//------------------------------------------------------------------------------//


*-------------------------------*
User Function STFATG02()
	*-------------------------------*
	Local _nIcms  := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_CONTRIB")  // Se é Contribuinte ICMS
	Local _cEst     := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")  	// Estado do CLiente
	Local _cTipoCli := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TIPO")  	// Tipo do CLiente - F=Cons.Final;L=Produtor Rural;R=Revendedor;S=Solidario;X=Exportacao
	Local _nVend	:= 0.01
	Local _nDescPad	:= 0 // Fator reducao ICMS
	//Local _nTotPed	:= 0
	//Local  nCnt		:= 0
	Local _cOrig	:= 0
	Local _nPosPrv  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN" })     // Preco de venda
	Local _nPosCont  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XCONTRA" })     // Preco de venda
	Local _nPosPDesc:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_DESCONT"})    // Percentual do desconto
	Local _nPosVDesc:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALDESC"})    // Valor do Desconto
	Local _nPosQtd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDVEN" })     // Quantidade
	Local _nPosTot  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALOR"  })      // Valor total
	Local _nPosUnt  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XPRCLIS"})     // Preço LISTA
	Local _nPosList := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRUNIT" })     // Preço Unitário
	Local _nPosProd := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	//Local _nValAcre := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XVALACR"})     	// Valor Acrescimo Financeiro
	Local _nxDesc   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XDESC"  })    // Codigo do produto
	Local _nXVdes   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XVDESC" })
	Local _nBloqIt  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ZMOTBLO"})
	Local _nPosUltPrc   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XULTPRC"})      	// Preço ULTIMA COMPRA
	Local _nPosDtUlt    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XULTCOM"})      	// DT ULTIMA COMPRA
	Local _nPosLult  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ZLULT"})      	// DT ULTIMA COMPRA
	Local _nPosPscPrc	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ZPRCPSC"})      	// PRC COND
	Local _nPosOper	    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_OPER"})      	// tp oper
	Local _nPrccon      := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XPRCCON"})
	Local _nTabprc  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XTABPRC"})//Giovani Zago Alçada 08/01/14
	Local _nPosTes      := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_TES"}) 	//Giovani Zago 11/02/2014 Reajuste Amazonia Ocidental     (chamado 000161)
	Local _nPrcCam      := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XCAMPA"})
	Local _nPosZPrc     := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ZPRCTAB"})
	Local _cTesOcide    := GetMv('ST_TESOCI',,'827/828/829/830/831')	//Giovani Zago 11/02/2014 Reajuste Amazonia Ocidental     (chamado 000161)
	Local lretx     := .F.
	//Local aRet 		:= {}
	//Local aRefFis 	:= {}
	//Local aImpostos := {"IT_VALICM","IT_VALIPI","IT_VALSOL","IT_ALIQICM","IT_VALMERC","IT_VALPS2","IT_VALCF2"}
	//Local nCnt  	:= 0
	//Local nCnt1 	:= 0
	//Local nValIcms	:= 0
	Local _cTabela  :=''
	Local _nICMPAD	:=_nICMPAD2 :=0
	//Local lSaida        := .F.
	//Local nopcao        := 1
	//Local oDxlg
	//Local _cItemx       :=''
	Local _nStx         :=0
	//Local _cItemx       := ''
	//Local aSalAtu       := {}
	local _lcall 		:= isincallsteck("U_STFAT15")
	local _lTel 		:=  !(Empty(Alltrim(M->C5_ZNUMPC))) // giovani zago	20/06/17 ì
	Local _cOpeTran     := GetMv('ST_OPERTRAN',,'94/74/75')//TIPO DE OPERAÇÃO transferencia/beneficiamento  ....utiliza preço de custo sb2
	Local _nXmargSf7	:= 0
	Local _nFatMar		:= 0
	Local _nFatInf		:= 0
	Local _nAliqICM		:= 0
	Local _nAliqPIS		:= 0
	Local _nAliqCOF 	:= 0
	Local _xOrigFab		:= 0
	Local _nPrcNsp      := 0
	Local _xPordesc     := 0
	//Local _nPrAtu		:= 0
	Local _nDescUnit    := 0
	Local cGrpVen 		:= ""
	Local cGrpPOL2		:= ""
	Local NPRECOTELA    := 0		//FR - 07/01/2022

	/*
	//FR - Flávia Rocha - Alteração realizada - 17/02/2022: 
	Implementar parâmetro de uso de inflação de preço, mediante código de tabela
	//Se o parâmetro estiver = "ZZZ" é para inflar pra todas as tabelas de preço
	//Se o parâmetro estiver = "código tabela" separados por vírgula, fazer a inflação
	//apenas para as tabelas especificas no parâmetro
	//Parâmetro: ST_TABINFL
	*/
	Local cTABINFL        := ""     //FR - 17/02/2022 - ST_TABINFL
	Local cTABCLI		  := ""     //FR - 17/02/2022 - ST_TABINFL

//Ricardo Munhoz - Unificação de Preço
	aRetX := {}

	Private _nValUlt 	:= 0
	Private	_dUltVen    := CTOD('  /  /    ')
	Private	_lUltVen    := .F.
	Private _nPis 	    := 0
	Private _nCofins    := 0
	Private _cCliMA     := GetMv('ST_FATG02',,'03544401')
	Private _cCliSCH    := GetMv('ST_FATG03',,'012047')
	Private _nCamDes    := 0
	Private _nReax      := 0

	cGrpVen  := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_GRPVEN")  	// Canal do CLiente
	cGrpPOL2 := GetNewPar("ST_GRPPO2", "E1,E2,I1,I2,I4,I5")  //FR - 29/12/2021

	//ZERA A VARIÁVEL
	NPRECOTELA := 0

	//------------------------------------------------------------------------------------------------------------------------------//
	//FR - Flávia Rocha - Alteração - 17/02/2022 - Ticket 20220216003829 - está inflando preço para clientes cuja tabela = T08
	//Não havia filtro de código de tabela, no caso a regra de inflação de preço estava valendo para qualquer cliente, e qualquer
	//tabela de preço, com a alteração abaixo, o sistema irá inflar preço apenas para as tabelas consideradas no parâmetro
	//ST_TABINFL: se "ZZZ" - considera todas as tabelas de preço, se não, inserir "código tabela separado por vírgulas"
	//para que a inflação ocorra apenas para as tabelas especificas no parâmetro
	//------------------------------------------------------------------------------------------------------------------------------//
	cTABINFL   := GetNewPar("ST_TABINFL" , "001")
	cTABCLI    := M->C5_TABELA 

	//FR - 07/01/2022 - PEGA O PREÇO NSP QUE ESTÁ NA DA1,
	//na primeira digitação de qtde, traz correto o preço unitário, mas se der um 2o. enter na qtde
	//ele refaz o gatilho com o preço que foi calculado no C6_PRCVEN , ao invés de pegar de novo da DA1
	//por isso ocorria incremento, agora corrigi
	DbSelectArea("DA1")
	DA1->(DbSetOrder(1))
	If DA1->(DbSeek(xFilial("DA1") + M->C5_TABELA + aCols[n,_nPosProd] ))
		aCols[n,_nPosPrv]   := DA1->DA1_PRCVEN		//11/02 4,74
	Endif

	NPRECOTELA := aCols[n,_nPosPrv]		//FR - 07/01/2022
	
	SA1->(OrdSetFocus(1))
	SA1->(Dbseek(FWxFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI))
	SB1->(OrdSetFocus(1))
	SB1->(Dbseek(FWxFilial("SB1") + aCols[n,_nPosProd]))

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		If  aCols[n,_nPosOper] $ _cOpeTran .and. !((M->C5_CLIENTE + M->C5_LOJACLI) $ _cCliMA) //.Or.  M->C5_CLIENTE+M->C5_LOJACLI = '03544401'
			aCols[n,_nPosPrv]   := STTel(aCols[n,_nPosOper])
			If aCols[n,_nPosPscPrc]  <> 0
				aCols[n,_nPosPrv]   := aCols[n,_nPosPscPrc]
			EndIf
			aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
			If	M->C5_TIPO $ 'C/P/I'
				aCols[n,_nPosTot]   := aCols[n,_nPosPrv] //pedidos de complemento nao possuem quantidade o valor total fica igual ao valor unitario giovani.zago 30/01/13
			Else
				aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
			EndIf
			aCols[n,_nPosList]  := aCols[n,_nPosPrv]
			_oDlgDefault        := GetWndDefault()
			//aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
			Ma410Rodap(,,0)
			If ( Type("l410Auto") == "U" .OR. !l410Auto )
				oGetDad:oBrowse:Refresh()
			EndIf
			Return(.F.)
		EndIf

//Ricardo Munhoz - Unificação de Preço
//User Function STCalcPrc(aDados,nPrecoX,cTabelaX,nPrcCamX,cOperX,cTESX,lPrcCond)
//aRetX, [1] = Preço, [2] = Regra
		aRetX := U_STCalcPrc({SA1->(Recno()),SB1->(Recno())},NPRECOTELA,M->C5_TABELA,aCols[n,_nPrcCam],aCols[n,_nPosOper],aCols[n,_nPosTes],IIf(aCols[n,_nPosPscPrc] > 0,.T.,.F.))

/**/
aCols[n,_nPosPrv] := aRetX[1]
NPRECOTELA := aCols[n,_nPosPrv]

	U_ST04GAX()//giovani zago recalcula os descontos e os acrescimos
	NPRECOTELA := aCols[n,_nPosPrv]
	aRetX[1]   := NPRECOTELA

		If aRetX[2] == "ZZB" //Queima de Estoque
			aCols[n,_nPosPrv]   := aRetX[1]
			aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
			aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
			aCols[n,_nPosList]  := aCols[n,_nPosPrv]
			Ma410Rodap(,,0)
			If ( Type("l410Auto") == "U" .OR. !l410Auto )
				oGetDad:oBrowse:Refresh()
			EndIf
			Return(.F.)
		EndIf

		//**************************** 012047
//		If 	 ALLTRIM(M->C5_CLIENTE) $ _cCliSCH
		If aRetX[2] == "CLISCH"

				aCols[n,_nPosPrv]   := aRetX[1]
				aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
				aCols[n,_nPosTot]   := round(aCols[n,_nPosPrv] * aCols[n,_nPosQtd],2)
				aCols[n,_nPosPrv]   := round(aCols[n,_nPosTot]/aCols[n,_nPosQtd] ,5)
				aCols[n,_nPosTot]   := round(aCols[n,_nPosPrv] * aCols[n,_nPosQtd],2)
				aCols[n,_nPosTot]   := round(aCols[n,_nPosPrv] * aCols[n,_nPosQtd],2)
				aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
				aCols[n,_nPosList]  := aCols[n,_nPosPrv]
				aCols[n,_nPrccon]   := aCols[n,_nPosPrv]

				U_STMAFISRET()

				If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
					If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
						oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
						oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
					EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
				EndIf

				Ma410Rodap(,,0)
				If ( Type("l410Auto") == "U" .OR. !l410Auto )
					oGetDad:oBrowse:Refresh()
				EndIf
				Return(.F.)

		EndIf

/**/"
NPRECOTELA := aCols[n,_nPosPrv]

		/**********************************************/
//		If 	 (M->C5_CLIENTE + M->C5_LOJACLI) $ _cCliMA
		If aRetX[2] == "CLISCH"

				aCols[n,_nPosPrv]   := aRetX[1]
				aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
				aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
				aCols[n,_nPosList]  := aCols[n,_nPosPrv]

				Ma410Rodap(,,0)
				If ( Type("l410Auto") == "U" .OR. !l410Auto )
					oGetDad:oBrowse:Refresh()
				EndIf
				Return(.F.)

		EndIf

/**/
NPRECOTELA := aCols[n,_nPosPrv]

		If aRetX[2] == "PRCCONT"
				aCols[n,_nPosPrv]   := Round(aRetX[1],2)
				aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
				aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
				aCols[n,_nPosList]  := aCols[n,_nPosPrv]
				aCols[n,_nPrcCam]  	:= aCols[n,_nPosPrv]

				If ( Type("l410Auto") == "U" .or. ! l410Auto)
					If !( oGetDad == Nil )
						oDlg                      := GetWndDefault()
						oDlg := oGetDad:oWnd
					EndIf

				EndIf

				Ma410Rodap(,,0)

				If ( Type("l410Auto") == "U" .OR. !l410Auto )
					oGetDad:oBrowse:Refresh()
				EndIf

				Return(.F.)
		EndIf

/**/
NPRECOTELA := aCols[n,_nPosPrv]

		If aRetX[2] == "NODA1PRCCOND"
			aCols[n,_nPosPrv]  := aRetX[1]
			aCols[n,_nBloqIt]  := "1"
			aCols[n,_nPosUnt]  := aRetX[1]
			aCols[n,_nPosTot]  := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
			aCols[n,_nPosList] := aCols[n,_nPosPrv]

			M->C5_ZBLOQ        := "1"
			M->C5_ZMOTBLO      := ALLTRIM(M->C5_ZMOTBLO)+'PSC/'
			u_stmafisret()

			Ma410Rodap(,,0)
			If ( Type("l410Auto") == "U" .OR. !l410Auto )
				oGetDad:oBrowse:Refresh()
			EndIf

			Return(.F.)
		EndIf

/**/
NPRECOTELA := aCols[n,_nPosPrv]

		If aRetX[2] == "PRCCAMPANHA"
				aCols[n,_nPosPrv]   := aRetX[1]
				aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
				aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
				aCols[n,_nPosList]  := aCols[n,_nPosPrv]
				aCols[n,_nPrcCam]  	:= aCols[n,_nPosPrv]
				If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
					If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
						oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
						oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
					EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013

				EndIf

				U_STMAFISRET()
				Ma410Rodap(,,0)
				If ( Type("l410Auto") == "U" .OR. !l410Auto )
					oGetDad:oBrowse:Refresh()
				EndIf
				Return(.F.)

		EndIf

		If  aCols[n,_nxDesc] <> 0
			aCols[n,_nPosPDesc] :=	aCols[n,_nxDesc]
			aCols[n,_nPosVDesc] :=	aCols[n,_nXVdes]
		EndIf

/**/
NPRECOTELA := aCols[n,_nPosPrv]

/*
		If Empty(aRetX[2])
				aCols[n,_nPosPrv]   := aRetX[1]
				aCols[n,_nPosUnt]   := aCols[n,_nPosPrv]
				aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
				aCols[n,_nPosList]  := aCols[n,_nPosPrv]
				aCols[n,_nPrcCam]  	:= aCols[n,_nPosPrv]
				If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
					If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
						oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
						oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
					EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013

				EndIf

				U_STMAFISRET()
				Ma410Rodap(,,0)
				If ( Type("l410Auto") == "U" .OR. !l410Auto )
					oGetDad:oBrowse:Refresh()
				EndIf
				Return(.F.)

		EndIf

NPRECOTELA := aCols[n,_nPosPrv]
*/

		_cAreaSC5 := GetArea("SC5")
		_cAreaSC6 := GetArea("SC6")

//Melhorar

		/*******************************************
		Ação...........: Rotina para apresentar a tela de consulta de Preço Atual ou Preço Anterior
		...............: Conforme conversado com Renato na data de 04/01/2021 esta rotina não será utilizada.
		Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
		Data...........: 04/01/2021
		Chamado........: 
		STREG01(aCols[n,_nPosProd], M->C5_CLIENTE, M->C5_LOJACLI)
		*******************************************/

		aCols[n,_nPosUltPrc]  := _nValUlt
		aCols[n,_nPosDtUlt]   := _dUltVen
		aCols[n,_nPosLult]    := _lUltVen

		If .F.//_lUltVen
			if !_lcall .And. !_lTel// giovani zago	20/06/17
				aCols[n,_nPosLult] := STTELAPRE(NPRECOTELA)  //aCols[n,_nPosLult] :=STTELAPRE(_nStx)
			else
				acols[n,_nposlult] :=.f.
			endif
		Else
			aCols[n,_nPosLult] :=.f.
		Endif

		If aCols[n,_nPosPscPrc]  <> 0
			aCols[n,_nPosPrv]   := aCols[n,_nPosPscPrc]
		ElseIf !aCols[n,_nPosLult]
			//aCols[n,_nPosPrv]   := _nStx
			aCols[n,_nPosPrv]	:= NPRECOTELA		//FR - 07/01/2022

		ElseIf  aCols[n,_nPosLult]
			aCols[n,_nPosPrv]   := aCols[n,_nPosUltPrc]
			If _nStx > _nValUlt
				aCols[n,_nBloqIt]  :=	"2"
				M->C5_ZBLOQ  := '1'
				M->C5_ZMOTBLO:= Alltrim(M->C5_ZMOTBLO)+'/ATU'
			Endif
		Endif

		If  M->C5_XTRONF = '1' .And. !('TNF' $ Alltrim(M->C5_ZMOTBLO))
			M->C5_ZBLOQ  := '1'
			M->C5_ZMOTBLO:= Alltrim(M->C5_ZMOTBLO)+'/TNF/'
		Endif

		aCols[n,_nTabprc] := NPRECOTELA  //_nStx	 //Giovani Zago Alçada 05/08/14
		aCols[n,_nPosPrv]   := NPRECOTELA		//FR - 07/01/2021  31.86
		aCols[n,_nPosZPrc]  := NPRECOTELA  		//FR - 07/01/2021
	// Grava o valor total
		aCols[n,_nPosTot]   := aCols[n,_nPosPrv] * aCols[n,_nPosQtd]
		aCols[n,_nPosList]  := aCols[n,_nPosPrv]
		aCols[n,_nxDesc]    := aCols[n,_nPosPDesc]
		aCols[n,_nXVdes]    := aCols[n,_nPosVDesc]
		aCols[n,_nPosPDesc] := 0
		aCols[n,_nPosVDesc] := 0
		aCols[n,_nPrccon]   := aCols[n,_nPosPrv]
		aCols[n,_nPosZPrc]  := aCols[n,_nPosPrv]

		U_STMAFISRET()

		/*******************************************
		Ação...........: Não permite atualizar o Browse do pedido de venda se for chamado pela função MSTECK5B.
		...............: Esta é uma rotina de importação de itens de pedido via arquivo CSV.
		...............: Se atualizar no meio do processo de imput de informação o browse se perde.
		Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
		Data...........: 22/12/2021
		Chamado........: 20211203025898
		*******************************************/
		IF FWIsInCallStack("MSTECK5B") = .F.
			// Atualiza a Get Dados	e Rodapé
			//_oDlgDefault := GetWndDefault()
			//aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
			If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
				If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
					oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
					oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
				EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
			EndIf
		ENDIF

		Ma410Rodap(,,0)

		/*******************************************
		Ação...........: Não permite atualizar o Browse do pedido de venda se for chamado pela função MSTECK5B.
		...............: Esta é uma rotina de importação de itens de pedido via arquivo CSV.
		...............: Se atualizar no meio do processo de imput de informação o browse se perde.
		Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
		Data...........: 22/12/2021
		Chamado........: 20211203025898
		*******************************************/
		IF FWIsInCallStack("MSTECK5B") = .F.
			If ( Type("l410Auto") == "U" .OR. !l410Auto )
				oGetDad:oBrowse:Refresh()
			EndIf
		ENDIF
		dbcommitall()

		RestArea(_cAreaSC5)
		RestArea(_cAreaSC6)
		lretx      := .f.
	EndIf
Return(lretx)

Static Function STREG01(cProduto,cCliente,cLoja)
	Local cInd := "1"
	Local _aArea := SC6->(GETAREA())
	Local _aArea5 := SC5->(GETAREA())
	//Local cAliasLif  := 'TMP01'
	//Local cQuery     := ' '

	// Vamos abrir o SC6 com outro alias
	DbUseArea(.T.,"TOPCONN",RetSQLName('SC6'),"S6C",.T.,.F.)
	While TcCanOpen(RetSQLName('SC6'),RetSQLName('SC6') + cInd)
		ORDLISTADD(RetSQLName('SC6') + cInd)
		cInd:= soma1(cInd)
	End

	DbSelectArea("S6C")
	S6C->(DbSetOrder(5))
	If S6C->(DbSeek(xFilial("SC6")+M->C5_CLIENTE+M->C5_LOJACLI+cProduto))
		While S6C->(!Eof()) .and.  M->C5_CLIENTE = S6C->C6_CLI .And. M->C5_LOJACLI = S6C->C6_LOJA  .And. cProduto = S6C->C6_PRODUTO
			_nValUlt 	:= S6C->C6_PRCVEN
			_dUltVen    := Posicione('SC5',1,xFilial("SC5")+S6C->C6_NUM,'C5_EMISSAO')
			_lUltVen    := .T.

			S6C->(DbSkip())
		End
	Endif

	S6C->(DbCloseArea())

	RESTAREA(_aArea)
	RESTAREA(_aArea5)

	Return ()

	/*====================================================================================\
	|Programa  | STTELAPRE           | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  Ultimo preço				                                              |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STTELAPRE                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*-------------------------------*
Static Function STTELAPRE(_nStx)
	*-------------------------------*
	local lSaida   := .f.
	local nOpcao   :=1
	Local _lret:= .f.
	//Local cInd := "1"
	Local _aArea := SC6->(GETAREA())

	Do While !lSaida

		Define msDialog oDxlg Title "Último Preço Vendido" From 10,10 TO 200,250 Pixel

		@ 010,010 say "Último Preço:  "  Of oDxlg Pixel
		@ 010,050 get _nValUlt  picture "@E 999,999,999.99"  when .f. size 050,08  Of oDxlg Pixel
		@ 020,010 say "Data:  "  Of oDxlg Pixel
		@ 020,050 get dtoc(_dUltVen)  when .f. size 050,08  Of oDxlg Pixel
		@ 030,050 Button "&Último Preço"   size 40,14  action ((lSaida:=.T.,nOpcao:=2,oDxlg:End())) Of oDxlg Pixel

		@ 065,010 say "Preço Atual "   Of oDxlg Pixel
		@ 065,050 get  _nStx picture "@E 999,999,999.99"  when .f. size 050,08  Of oDxlg Pixel
		@ 075,050 Button "&Preço Atual"    size 40,14  action ((lSaida:=.T.,nOpcao:=1,oDxlg:End())) Of oDxlg Pixel

		Activate dialog oDxlg centered

	EndDo
	IF  nOpcao = 1
		_lret:= .f.
	ElseIf  nOpcao = 2
		_lret:= .t.
	Endif

	RestArea(_aArea)

	return(_lret)

	/*====================================================================================\
	|Programa  | Sb2Saldo            | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  Retorna saldo do sb2(custo)                                             |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Sb2Saldo                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------*
Static Function Sb2Saldo()
	*---------------------------*
	Local _aArea	:= GetArea()
	Local cAliasLif  := 'TMPB2'
	Local cQuery     := ' '
	Local  _nQut    := 0
	Local  _nVal    := 0
	Local  _nCust    := 0
	Local _nPosProd := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+aCols[n,_nPosProd]))

	Return(round(U_STCUSTO(SB1->B1_COD),2))

	cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
	cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
	cQuery += " AND   SB2.B2_LOCAL = '"+SB1->B1_LOCPAD+"'"
	cQuery += " AND   SB2.B2_FILIAL= '"+xFilial("SB2")+"'"
	cQuery += " ORDER BY SB2.R_E_C_N_O_

	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While (cAliasLif)->(!Eof())

			_nQut 	:= (cAliasLif)->B2_QATU
			_nVal	:= (cAliasLif)->B2_VATU1
			_nCust  := (cAliasLif)->B2_CMFIM1

			(cAliasLif)->(DbSkip())
		End
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	If  !(_nCust > 0).and. SB1->B1_CLAPROD <> 'F'

		cQuery := " SELECT D1_VUNIT
		cQuery += ' "SALDO"
		cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
		cQuery += " AND SD1.D1_COD = '"+SB1->B1_COD+"'"
		cQuery += " AND SD1.D1_FORNECE <> '005764'
		cQuery += " AND SD1.D1_TIPO = 'N'
		cQuery += " ORDER BY   SD1.R_E_C_N_O_ DESC

		//cQuery := ChangeQuery(cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		dbSelectArea(cAliasLif)
		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCust  := (cAliasLif)->SALDO
		EndIf

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

	EndIf

	If  !(_nCust > 0).and. SB1->B1_CLAPROD $ 'F#C' //Renato Nogueira - 25/11/2013 - Chamado 000019

		cQuery := " SELECT C2_APRATU1/C2_QUJE SALDO "
		cQuery += " FROM "+RetSqlName("SC2")+" C2 "
		cQuery += " WHERE D_E_L_E_T_=' ' AND R_E_C_N_O_ = ( "
		cQuery += " SELECT MAX(R_E_C_N_O_) "
		cQuery += " FROM "+RetSqlName("SC2")+" C2 "
		cQuery += " WHERE C2.D_E_L_E_T_=' ' AND C2_PRODUTO= '"+SB1->B1_COD+"' AND C2_APRATU1>0 AND C2_QUJE>0 "
		cQuery += " GROUP BY C2_PRODUTO)

		//cQuery := ChangeQuery(cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		dbSelectArea(cAliasLif)
		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCust  := (cAliasLif)->SALDO
		EndIf

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

	EndIf

	If !(_nCust > 0) //!(_nVal/_nQut > 0)  alterado por giovani zago solicitação rogerio martelo 10/06/13
		MsgInfo('Produto não Possui Valor na Tabela de Custo, Contactar o Departamento de T.I. ou Departamento de Custo !!!!!!!!!!!')
	EndIf

	RestArea(_aArea)
	Return(round(_nCust,2))

	/*====================================================================================\
	|Programa  | STUnitTel           | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  Preço Unitario Tipo de Operação                                         |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STUnitTel                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------------------------------*
Static Function STUnitTel()
	*---------------------------------------------------*

	Local oDlgEmail
	Local _nVal       :=  0
	Local lSaida      := .F.
	Local nOpca       :=  0

	Do While !lSaida
		nOpcao := 0
		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Digite o Valor Unitario") From  1,0 To 80,200 Pixel OF oMainWnd

		@ 02,04 SAY "Valor:" PIXEL OF oDlgEmail
		@ 12,04 MSGet _nVal picture "@E 999,999.99999"   Size 55,013  PIXEL OF oDlgEmail valid _nVal > 0
		@ 12,62 Button "Ok"      Size 28,13 Action iif(_nVal>0,Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()}),msginfo("Valor Deve Ser Maior Que 0"))  Pixel

		ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo

	Return(round(_nVal,5))

	/*====================================================================================\
	|Programa  | STTel               | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  TELA PARA ESCOLHA DO TIPO DE PREÇO A SER UTILIZADO                      |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STTel                                                                    |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------------------------------*
Static Function STTel(_cTpOPer)
	*---------------------------------------------------*

	//Local oDlgEmail
	Local _nVal       :=  0
	//Local lSaida      := .F.
	//Local nOpca       :=  0
	Local _cRetOp     := GetMv("ST_STTEL",,"86")

	If _cTpOPer $ _cRetOp
		_nVal:= (Sb2Saldo()/0.82)
	Else
		_nVal:= STUnitTel()

	EndIf
	//regra de preço para pedidos de transferencia unicom regra definida pelo rogerio martello 15/8/2017 // giovani.zago
	If _nVal = 0 .And. Alltrim(SB1->B1_GRUPO) $ GetMv("ST_G0294",,'005/039/041/042/099/122') .And. _cTpOPer = '94'
		DbSelectArea("SC6")
		SC6->(DbSetOrder(2))
		If SC6->(DbSeek('02'+SB1->B1_COD))
			_nVal:= round((SC6->C6_PRCVEN * 0.7),2)
		EndIf

	EndIf

	Return(round(_nVal,2))

	/*====================================================================================\
	|Programa  | OciPreco            | Autor | GIOVANI.ZAGO          | Data | 11/02/2014  |
	|=====================================================================================|
	|Descrição |  Reajuste de preço amazonia ocidental				                      |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | OciPreco                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------------------------------*
Static Function OciPreco(_nPrcTes)
	*---------------------------------------------------*
	Local _nReajus:= 0
	Local _nPosProd := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local _aArea1 	:= GetArea()

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+aCols[n,_nPosProd]))

		If ALLTRIM(SB1->B1_GRUPO) $ "066/068/160/161/162/166/167/173/178/183"
			_nReajus:= 3
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "049/050/063/064/149/150/152/153/176/075/159/170/171/175/177/184/186/158"
			_nReajus:= 5
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "154"
			_nReajus:= 7
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "048/148/151"
			_nReajus:= 8
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "015/020/069/070/071/072/073"
			_nReajus:= 12
		EndIf
		If _nReajus > 0
			_nPrcTes:= (_nPrcTes+(_nPrcTes*(_nReajus/100)))
		EndIf
	EndIf
	RestArea(_aArea1)
Return  (_nPrcTes)

Static Function STREG099(cProduto,cCliente,cLoja)

	Local cAliasLif  := 'TMP01'
	Local cQuery     := ' '

	cQuery := " SELECT ACP.ACP_PERDES DESCONTO
	cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
	cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
	cQuery += " AND  ACO.ACO_CODCLI  = '"+cCliente+"'"
	cQuery += " AND  ACO.ACO_LOJA    = '"+cLoja+"'"
	cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
	cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
	cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
	cQuery += " AND ACP.ACP_CODPRO   = '"+cProduto+"'"
	cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
	cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
	cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
	cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If  Select(cAliasLif) > 0
		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())
		nRet:= (cAliasLif)->DESCONTO
	EndIf

	If nRet = 0
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+cProduto))

		cQuery := " SELECT ACP.ACP_PERDES DESCONTO
		cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
		cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
		cQuery += " AND  ACO.ACO_CODCLI  = '"+cCliente+"'"
		cQuery += " AND  ACO.ACO_LOJA    = '"+cLoja+"'"
		cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
		cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
		cQuery += " AND ACP.ACP_GRUPO   = '"+SB1->B1_GRUPO+"'"
		cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
		cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
		cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
		//cQuery := ChangeQuery(cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

		If  Select(cAliasLif) > 0
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			nRet:= (cAliasLif)->DESCONTO
		EndIf

	EndIf

Return (nRet)

