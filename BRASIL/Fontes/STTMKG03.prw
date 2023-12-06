#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#Include "TOPCONN.CH"
#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Metodo   ³ STTMKG03 ºAutor  ³ Donizeti Lopes     º Data ³  21/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recalcula o valor de venda baseando-se na UF do cliente    º±±
±±º          ³ e no fator de reducao de ICMS, clientes com A1_CONTRIB='1' º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºValidacao ³  Gatilho do campo UB_PRODUTO - Item 2.4 MIT044             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//------------------------------------------------------------------------------//
//FR - Flávia Rocha - 17/02 - Alteração realizada: 
//Implementar parâmetro de uso de inflação de preço, mediante código de tabela
//Se o parâmetro estiver = "ZZZ" é para inflar pra todas as tabelas de preço
//Se o parâmetro estiver = "código tabela" separados por vírgula, fazer a inflação
//apenas para as tabelas especificas no parâmetro
//Parâmetro: ST_TABINFL
//------------------------------------------------------------------------------//

User Function STTMKG03()

	Local _nIcms     	  := Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_CONTRIB")  // Se contribuinte do ICMS
	Local _cEst			  := Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_EST")  	// Estado do CLiente
	Local _cTipoCli		  := Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_TIPO")  	// Tipo do CLiente - F=Cons.Final;L=Produtor Rural;R=Revendedor;S=Solidario;X=Exportacao
	Local cGrpVen         := Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_GRPVEN") 	//FR - 29/12/2021 - Projeto Nova Política Preços - CRM - #20210812015568
	Local _nVend	   	  := 0.01
	Local _nDescPad  	  := 0 	// Fator reducao ICMS
	Local _cOrig          := ''
	//Local _nPosCont 	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XCONTRA" })     // Preco de venda
	Local _nPosPrv   	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_VRUNIT"})     	// Preco de venda
	Local _nPosTemCtr  	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XTEMCTR"})     	// Tem Contrato?
	Local _nPosPDesc 	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_DESC"})    		// Percentual do desconto
	Local _nPosVDesc 	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_VALDESC"})    	// Valor do Desconto
	Local _nPosProd  	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_PRODUTO"})    	// Codigo do produto
	Local _nPosQtd   	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_QUANT"})     	// Quantidade
	Local _nICMPAD	      :=_nICMPAD2 :=0
	Local _xOrigFab       := ""
	Local _xPordesc		  := 0
	Local NPRECOTELA	  := 0		//FR - 07/01/2022 - VARIÁVEL PARA EQUALIZAR TODAS AS VARIÁVEIS USADAS PARA ARMAZENAR O PREÇO UNITÁRIO
	Local NPRECOTAB       := 0		//FR - 14/01/2022 - VARIÁVEL PARA ARMAZENAR PREÇO TABELA DA1
	Local _nFatInf  	  := 0		//FR - 10/01/2022 - ticket #20220110000672 erro variável não existe
	Local _nPrcNsp        := 0
	
	
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

	
	Private _Lmomat       := .t.
	Private _nPosXVALACR  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XVALACR"   })
	Private _nPosXacres   := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XACRECP"	  })
	Private _nPosXDesc    := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XPORDEC"   })
	Private _nPosXVALdesc := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XVALDES"   })
	Private _nPosXAcreP   := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XACREPO"   })
	Private _nPosXValAcre := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XACREVA"   })
	Private _nPosXPrCcon  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XPRCCON"   })
	Private _nValComiss   := 0
	Private _cFunCmp      := IIF(_Lmomat ,"M->UA_XCONDPG","M->C5_CONDPAG")
	Private _nValAcre     := Posicione("SE4",1,xFilial("SE4")+&_cFunCmp,"E4_XACRESC")
	Private _nxDesc       := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XDESC"})
	Private _nXVdes       := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XVDESC"})
	Private _nBloqIt      := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XBLQITE"})
	Private _nPosTot   	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_VLRITEM"})       // Valor total
	Private _nPosUnt   	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_PRCTAB"})      	// Preço Tabela
	Private _nPosUltPrc   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XULTPRC"})      	// Preço ULTIMA COMPRA
	Private _nPosDtUlt    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XULTCOM"})      	// DT ULTIMA COMPRA
	Private _nPosLult  	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_ZLULT"})      	// DT ULTIMA COMPRA
	Private _nPosPscPrc	  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_ZPRCPSC"})      	// DT ULTIMA COMPRA
	Private _nPosZPrc     := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_ZPRCTAB"  })
	Private _nPosTes      := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_TES"})
	Private _nPosOper     := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_OPER"})
	Private _nPosTabe     := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XTABELA"})
	Private nPosTabPr	  := aScan(aHeader,{|x|  Upper(AllTrim(x[2])) =="UB_XTABPRC"  })		// TabPrc //Alçada Giovani Zago 08/01/14
	Private _nValUlt 	  := 0
	Private _dUltVen  	  := ddatabase
	Private _lUltVen      := .F.
	Private lSaida        := .F.
	Private nopcao        := 1
	Private _cTes         := ''
	Private oDxlg
	Private _nPrAtu  	  :=0
	Private _cTesOcide    := GetMv('ST_TESOCI',,'827/828/829/830/831')	//Giovani Zago 11/02/2014 Reajuste Amazonia Ocidental     (chamado 000161)
	Private _nCamDes      := 0
	Private _nPrcCam      := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_XCAMPA"})
	Private _nReax    	  := 0
	Private _nSDes		  := 0
	Private _nSAcr        := 0
	Private cGrpPOL2      := ""
	
	cGrpPOL2 := GetNewPar("ST_GRPPO2", "E1,E2,I1,I2,I4,I5")  //FR - 29/12/2021

	//COLOCAR UM "IF" GERAL AQUI SEPARANDO SE É STECK OU SCHNEIDER
	//PARA NÃO ALTERAR AS REGRAS EXISTENTES VALIDADAS

	//ZERA A VARIÁVEL
	NPRECOTELA := 0
	NPRECOTAB  := 0
	_nXmargSf7 := 0
	_nFatMar   := 0
	_nFatInf   := 0 		//FR - 10/01/2022 - ticket #20220110000672 erro variável não existe
	_nAliqICM  := 0
	_nAliqPIS  := 0
	_nAliqCOF  := 0
	_nPrcNsp   := 0 
	xICMPAD    := 0    		//FR - 20/06/2022 - USADO NA CONDIÇÃO PARA REVENDEDOR E SOLIDÁRIO, DENTRO DE SP, EX. CASO TERUYA

	//------------------------------------------------------------------------------------------------------------------------------//
	//FR - Flávia Rocha - Alteração - 17/02/2022 - Ticket 20220216003829 - está inflando preço para clientes cuja tabela = T08
	//Não havia filtro de código de tabela, no caso a regra de inflação de preço estava valendo para qualquer cliente, e qualquer
	//tabela de preço, com a alteração abaixo, o sistema irá inflar preço apenas para as tabelas consideradas no parâmetro
	//ST_TABINFL: se "ZZZ" - considera todas as tabelas de preço, se não, inserir "código tabela separado por vírgulas"
	//para que a inflação ocorra apenas para as tabelas especificas no parâmetro
	//------------------------------------------------------------------------------------------------------------------------------//
	cTABINFL   := GetNewPar("ST_TABINFL" , "001")
	cTABCLI    := M->UA_TABELA 

	aCols[n,_nPosPrv] := 0  //FR - 14/01/2022 - zerar este campo para não acumular num próximo enter

	DbSelectArea("DA1")
	DA1->(DbSetOrder(1))
	If DA1->(DbSeek(xFilial("DA1") + M->UA_TABELA + aCols[n,_nPosProd] ))
		NPRECOTAB := DA1->DA1_PRCVEN
		//aCols[n,_nPosPrv]   := NPRECOTAB  //DA1->DA1_PRCVEN		//FR - 18/01/2022 - mostrar só no final o resultado
		aCols[n,_nPosUnt]    := NPRECOTAB 
	Endif 
	NPRECOTELA := NPRECOTAB //FR - 21/02/2022 - preço diferente cotação x pedido, correção para alinhar o preço que vem na cotação para ser o mesmo do pedido de venda
	
	SA1->(OrdSetFocus(1))
	SA1->(Dbseek(FWxFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA))
	SB1->(OrdSetFocus(1))
	SB1->(Dbseek(FWxFilial("SB1") + aCols[n,_nPosProd]))

//Ricardo Munhoz - Unificação de Preço
//User Function STCalcPrc(aDados,nPrecoX,cTabelaX,nPrcCamX,cOperX,cTESX,lPrcCond)
//aRetX, [1] = Preço, [2] = Regra
	aRetX := U_STCalcPrc({SA1->(Recno()),SB1->(Recno())},NPRECOTELA,M->UA_TABELA,aCols[n][_nPrcCam],aCols[n][_nPosOper],aCols[n][_nPosTes],)

/**/
NPRECOTELA := aRetX[1]
aCols[n,_nPosPrv] := NPRECOTELA

	If  aCols[n,_nxDesc] <> 0
		aCols[n,_nPosPDesc] :=	aCols[n,_nxDesc]
		aCols[n,_nPosVDesc] :=	aCols[n,_nXVdes]
	EndIf

	_nICMPAD2:= 18 //>> Chamado 006035 - Everson Santana

//Melhorar
	U_ST04GAX()//giovani zago recalcula os descontos e os acrescimos
	NPRECOTELA := aCols[n,_nPosPrv]
	aRetX[1]   := NPRECOTELA

	_cAreaSUA := GetArea("SUA")
	_cAreaSUB := GetArea("SUB")

	If empty(aCols[n,_nPosProd])    //Se não tiver código do Produto Aborta Rotina
		RETURN
	EndIf

	If aRetX[2] == "ZZB" //Queima de Estoque
		aCols[n,_nPosPrv]	:=  aRetX[1]
		_nSDes:=aCols[n,_nPosXDesc]
		_nSAcr:=aCols[n,_nPosXAcreP]
		aCols[n,_nPosXDesc]    	:= 0
		aCols[n,_nPosXVALdesc] 	:= 0
		aCols[n,_nPosXAcreP]   	:= 0
		aCols[n,_nPosXValAcre] 	:= 0

		aCols[n,_nPosTot]      	:= ROUND(aCols[n,_nPosPrv] *   aCols[n,_nPosQtd],2)
		_nVend 					:=  aCols[n,_nPosPrv]
		aCols[n,_nxDesc] 		:=	aCols[n,_nPosPDesc]
		aCols[n,_nXVdes] 		:=	aCols[n,_nPosVDesc]
		aCols[n,_nPosPDesc] 	:=  0
		aCols[n,_nPosVDesc] 	:=  0
		aCols[n,_nPosXPrCcon] 	:=  aCols[n,_nPosPrv]
		aCols[n,_nPosTabe] 		:=  " "
		aCols[n,_nPosZPrc]      := aCols[n,_nPosPrv]
		U_STTMKG01()
		MaFisAlt("NF_DESCONTO",0 )

		MaFisRef("IT_VALMERC","TK273",aCols[n,_nPosTot])

		aCols[n,_nPosTes]:=_cTes
		Tk273Trigger()
		aCols[n,_nPosTes]:=_cTes

		U_STTESINTELIGENTE()
		U_STTMKG01()

		If GetMv("ST_XDESC",,.T.)
			If _nSDes <> 0
				U_STGAP07('1',n,_nSDes)
			ElseIf _nSAcr <> 0
				U_STGAP07('2',n,_nSAcr)
			EndIF
		EndIf

		RestArea(_cAreaSUA)
		RestArea(_cAreaSUB)
		Return(.F.)
	Endif

/**/
NPRECOTELA := aCols[n,_nPosPrv]

	If aRetX[2] == "PRCCONT"
		aCols[n,_nPosTemCtr]	:=  'S'
		aCols[n,_nPosPrv]		:=  aRetX[1]
		_nSDes:=aCols[n,_nPosXDesc]
		_nSAcr:=aCols[n,_nPosXAcreP]
		aCols[n,_nPosXDesc]    	:= 0
		aCols[n,_nPosXVALdesc] 	:= 0
		aCols[n,_nPosXAcreP]   	:= 0
		aCols[n,_nPosXValAcre] 	:= 0

		aCols[n,_nPosTot]      	:= ROUND(aCols[n,_nPosPrv] *   aCols[n,_nPosQtd],2)
		_nVend 					:=  aCols[n,_nPosPrv]
		aCols[n,_nxDesc] 		:=	aCols[n,_nPosPDesc]
		aCols[n,_nXVdes] 		:=	aCols[n,_nPosVDesc]
		aCols[n,_nPosPDesc] 	:=  0
		aCols[n,_nPosVDesc] 	:=  0
		aCols[n,_nPosXPrCcon] 	:=  aCols[n,_nPosPrv]
		aCols[n,_nPosTabe] 		:=  " "
		aCols[n,_nPosZPrc]      := aCols[n,_nPosPrv]
		U_STTMKG01()
		MaFisAlt("NF_DESCONTO",0 )

		MaFisRef("IT_VALMERC","TK273",aCols[n,_nPosTot])

		aCols[n,_nPosTes]:=_cTes
		Tk273Trigger()
		aCols[n,_nPosTes]:=_cTes

		U_STTESINTELIGENTE()
		U_STTMKG01()

		If GetMv("ST_XDESC",,.T.)
			If _nSDes <> 0
				U_STGAP07('1',n,_nSDes)
			ElseIf _nSAcr <> 0
				U_STGAP07('2',n,_nSAcr)
			EndIF
		EndIf

		RestArea(_cAreaSUA)
		RestArea(_cAreaSUB)
		Return(.F.)
	EndIf

/**/
NPRECOTELA := aCols[n,_nPosPrv]

	// Verifica se existe Tabela de Preço
	_cTabela := M->UA_TABELA

	If aRetX[2] == "NODA1PRCCOND"
		aCols[n,_nPosPrv]		:= aRetX[1]
		aCols[n,_nPosTot] 		:= aRetX[1] *  aCols[n,_nPosQtd]
		aCols[n,_nPosUnt] 		:= aRetX[1]
		aCols[n,_nBloqIt] 		:=	"1"
		aCols[n,_nPosUltPrc] 	:= aRetX[1]

		U_STTMKG01()

		MaFisRef("IT_VALMERC","TK273",aCols[n,_nPosTot])

		M->UA_XBLOQ :='1'
		M->UA_XDESBLQ := 	ALLTRIM(M->UA_XDESBLQ)+'PSC/'
		Tk273Trigger()
		Tk273FRefresh()
		Tk273TlvImp()
		RestArea(_cAreaSUA)
		RestArea(_cAreaSUB)
		Return(.F.)
	Endif

/**/
NPRECOTELA := aCols[n,_nPosPrv]

	If aCols[n,_nPosUltPrc] = 0
		DbSelectArea("SC6")
		SC6->(DbSetOrder(5))
		SC6->(DbGotop())
		If SC6->(DbSeek(xFilial("SC6")+M->UA_CLIENTE+M->UA_LOJA+aCols[n,_nPosProd]))
			While SC6->(!Eof()) .and.  M->UA_CLIENTE = SC6->C6_CLI .And. M->UA_LOJA = SC6->C6_LOJA  .And. aCols[n,_nPosProd] = SC6->C6_PRODUTO

				If SC6->C6_QTDVEN > 0

					_nValUlt 	:= SC6->C6_PRCVEN
					_dUltVen    := Posicione('SC5',1,xFilial("SC5")+SC6->C6_NUM,'C5_EMISSAO')
					_lUltVen    := .T.

				EndIf

				SC6->(DbSkip())
			End
		Endif
		aCols[n,_nPosUltPrc]  := _nValUlt
		aCols[n,_nPosDtUlt]   := _dUltVen
	Endif

/**/
NPRECOTELA := aCols[n,_nPosPrv]

	If aRetX[2] == "PRCCAMPANHA"
			//aCols[n,_nPosPrv]   := Round(_nPrAtu - ((_nPrAtu/100)*_nCamDes),2)
			aCols[n,_nPosPrv]   := aRetX[1]
			_nSDes:=aCols[n,_nPosXDesc]
			_nSAcr:=aCols[n,_nPosXAcreP]
			aCols[n,_nPosXDesc]    	:= 0
			aCols[n,_nPosXVALdesc] 	:= 0
			aCols[n,_nPosXAcreP]   	:= 0
			aCols[n,_nPosXValAcre] 	:= 0

			aCols[n,_nPosTot]      	:= ROUND(aCols[n,_nPosPrv] *   aCols[n,_nPosQtd],2)
			_nVend 					:=  aCols[n,_nPosPrv]
			aCols[n,_nxDesc] 		:=	aCols[n,_nPosPDesc]
			aCols[n,_nXVdes] 		:=	aCols[n,_nPosVDesc]
			aCols[n,_nPosPDesc] 	:=  0
			aCols[n,_nPosVDesc] 	:=  0
			aCols[n,_nPosXPrCcon] 	:=  aCols[n,_nPosPrv]
			aCols[n,_nPosTabe] 		:=  " "
			aCols[n,_nPrcCam] 		:=  aCols[n,_nPosPrv]

			U_STTMKG01()
			MaFisAlt("NF_DESCONTO",0 )

			MaFisRef("IT_VALMERC","TK273",aCols[n,_nPosTot])

			aCols[n,_nPosTes]:=_cTes
			Tk273Trigger()
			aCols[n,_nPosTes]:=_cTes

			U_STTESINTELIGENTE()
			U_STTMKG01()

			If GetMv("ST_XDESC",,.T.)
				If _nSDes <> 0
					U_STGAP07('1',n,_nSDes)
				ElseIf _nSAcr <> 0
					U_STGAP07('2',n,_nSAcr)
				EndIF
			EndIf

			RestArea(_cAreaSUA)
			RestArea(_cAreaSUB)
			Return(.F.)
	EndIf

/**/
NPRECOTELA := aCols[n,_nPosPrv]

	//ATUALIZA ACOLS: 
	aCols[n,_nPosPrv]   := NPRECOTELA  //_nPrAtu	//FR - 07/01/2022
	aCols[n,_nPosZPrc]  := NPRECOTELA   //_nPrAtu    //FR - 07/01/2022
	

	If .F.//_lUltVen 
		If  ! (IsInCallSteck("U_STFSVE46") )
			//	_nPrAtu:=	ROUND(aCols[n,_nPosPrv] - _nDescUnit,2)  //AQUI JÁ ESTAVA COMENTADO OK
			U_STTESINTELIGENTE()
			U_STTMKG01()
			If  aCols[n,_nPosTes]  $  _cTesOcide
				NPRECOTELA:= OciPreco(NPRECOTELA)  //_nPrAtu:= OciPreco(_nPrAtu)  //FR - 07/01/2022
				aCols[n,nPosTabPr] := NPRECOTELA   //_nPrAtu	//FR - 07/01/2022
			Else
				aCols[n,nPosTabPr] :=ROUND(aCols[n,_nPosPrv] - _nDescUnit,2) //Alçada Giovani Zago 08/01/14
			EndIf

			If !IsBlind()
				Do While !lSaida
					nOpcao := 1

					Define msDialog oDxlg Title "Último Preço Vendido" From 10,10 TO 200,250 Pixel

					@ 010,010 say "Último Preço:  "  Of oDxlg Pixel
					@ 010,050 get _nValUlt  picture "@E 999,999,999.99" when .f. size 050,08  Of oDxlg Pixel
					@ 020,010 say "Data:  "  Of oDxlg Pixel
					@ 020,050 get dtoc(_dUltVen)  when .f. size 050,08  Of oDxlg Pixel
					@ 030,050 Button "&Último Preço"   size 40,14  action ((lSaida:=.T.,nOpcao:=2,oDxlg:End())) Of oDxlg Pixel

					@ 065,010 say "Preço Atual "   Of oDxlg Pixel
					//@ 065,050 get _nPrAtu  picture "@E 999,999,999.99" when .f. size 050,08  Of oDxlg Pixel
					@ 065,050 get NPRECOTELA  picture "@E 999,999,999.99" when .f. size 050,08  Of oDxlg Pixel
					@ 075,050 Button "&Preço Atual"    size 40,14  action ((lSaida:=.T.,nOpcao:=1,oDxlg:End())) Of oDxlg Pixel

					Activate dialog oDxlg centered

				EndDo
			Else
				nOpcao = 1
			EndIf

			IF  nOpcao = 1
				aCols[n,_nPosLult] :=.F.
			ElseIf  nOpcao = 2
				aCols[n,_nPosLult] :=.T.

				If _nPrAtu > _nValUlt
					aCols[n,_nBloqIt]  :=	"2"
					M->UA_XBLOQ  := '1'
					M->UA_XDESBLQ:=M->UA_XDESBLQ+'/ATU'
				Endif
			Endif
			aCols[n,_nPosZPrc] := _nPrAtu

		Else

			aCols[n,_nPosLult] :=.F.
		Endif
	Else
		U_STTESINTELIGENTE()
		U_STTMKG01()
		If  aCols[n,_nPosTes]  $  _cTesOcide
			//_nPrAtu:= round(OciPreco(_nPrAtu),2)
			NPRECOTELA := round(OciPreco(NPRECOTELA),2)
			aCols[n,nPosTabPr] :=NPRECOTELA   //aCols[n,nPosTabPr] :=_nPrAtu  //FR - 07/01/2022
		Endif
	Endif
	_nSDes:=aCols[n,_nPosXDesc]
	_nSAcr:=aCols[n,_nPosXAcreP]
	aCols[n,_nPosXDesc]    	:= 0
	aCols[n,_nPosXVALdesc] 	:= 0
	aCols[n,_nPosXAcreP]   	:= 0
	aCols[n,_nPosXValAcre] 	:= 0

	aCols[n,_nPosZPrc] := NPRECOTELA  //aCols[n,_nPosZPrc] := _nPrAtu		//FR - 07/01/2022

	If aCols[n,_nPosPscPrc]  <> 0
		aCols[n,_nPosPrv]   := aCols[n,_nPosPscPrc]
	ElseIf !aCols[n,_nPosLult]
		aCols[n,_nPosPrv]   := NPRECOTELA  //_nPrAtu						//FR - 07/01/2022

	ElseIf  aCols[n,_nPosLult]
		aCols[n,_nPosPrv]   := aCols[n,_nPosUltPrc]
	Endif

	aCols[n,_nPosTot]      	:= ROUND(aCols[n,_nPosPrv] *   aCols[n,_nPosQtd],2)
	_nVend 					:=  aCols[n,_nPosPrv]
	aCols[n,_nxDesc] 		:=	aCols[n,_nPosPDesc]
	aCols[n,_nXVdes] 		:=	aCols[n,_nPosVDesc]
	aCols[n,_nPosPDesc] 	:=  0
	aCols[n,_nPosVDesc] 	:=  0
	aCols[n,_nPosXPrCcon] 	:=  aCols[n,_nPosPrv]

	MaFisRef("IT_VALMERC","TK273",aCols[n,_nPosTot])
	MaFisRef("IT_PRCUNI","TK273",aCols[n,_nPosPrv])
	MaFisAlt("IT_VALMERC" ,aCols[n,_nPosTot] ,n,.t.)

	U_STTMKG01()

	MaFisAlt("NF_DESCONTO",0 )

	MaFisRef("IT_VALMERC","TK273",aCols[n,_nPosTot])

	If 	aCols[n,_nBloqIt]  =	"1"    .And.  IsInCallSteck("U_STFSVE46")
		aCols[n,_nBloqIt]  :=	"3"
	EndIf
	// Atualiza totais da tela

	aCols[n,_nPosTes]:=_cTes
	Tk273Trigger()
	aCols[n,_nPosTes]:=_cTes

	U_STTESINTELIGENTE()
	U_STTMKG01()

	M->UA_CONDPG :=	M->UA_XCONDPG

	If GetMv("ST_XDESC",,.T.)
		If _nSDes <> 0
			U_STGAP07('1',n,_nSDes)
		ElseIf _nSAcr <> 0
			U_STGAP07('2',n,_nSAcr)
		EndIF
	EndIf

	RestArea(_cAreaSUA)
	RestArea(_cAreaSUB)

	Return(.F.)	

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
	Local _aArea1 	:= GetArea()
	Local _nPosProd  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_PRODUTO"})

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
	cQuery := ChangeQuery(cQuery)

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
		cQuery := ChangeQuery(cQuery)

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

User Function STORIG(_cProd)

	Local _cQuery2 := ""
	Local _cAlias2 := GetNextAlias()
	Local _cOrig   := ""

	_cQuery2 := " SELECT COUNT(*) CONTADOR "	
	//_cQuery2 += " FROM UDBP12.SG1010 G1
	//_cQuery2 += " FROM "+GetMv("STTMKG0311",,"UDBD02")+".SG1010 G1
	_cQuery2 += " FROM "+AllTrim(GetMv("STTMKG0311",,"UDBD02"))+".SG1010 G1 "   //FR - 20/01/2022
	_cQuery2 += " WHERE G1.D_E_L_E_T_=' ' AND G1_FILIAL='05' AND G1_COD='"+_cProd+"' "

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)

	(_cAlias2)->(dbGoTop())

	If (_cAlias2)->(!Eof())
		If (_cAlias2)->CONTADOR>0
			_cOrig := "GUA"
		EndIf
	EndIf

		_cQuery2 := " SELECT COUNT(*) CONTADOR "
		//_cQuery2 += " FROM UDBP12.SG1010 G1
		_cQuery2 += " FROM "+AllTrim(GetMv("STTMKG0311",,"UDBD02"))+".SG1030 G1 "    //aqui deixa chumbado porque é Manaus (?)
		_cQuery2 += " WHERE G1.D_E_L_E_T_=' ' AND G1_FILIAL='01' AND G1_COD='"+_cProd+"' "

			If !Empty(Select(_cAlias2))
				DbSelectArea(_cAlias2)
				(_cAlias2)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

			dbSelectArea(_cAlias2)

			(_cAlias2)->(dbGoTop())

			If (_cAlias2)->(!Eof())
				If (_cAlias2)->CONTADOR>0
					_cOrig := "MAO"
				EndIf
			EndIf

	//FR - 26/05/2022 - ESTOURO DE ÁREA ABERTA - CRM
	DbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
	//FR - 26/05/2022 - ESTOURO DE ÁREA ABERTA - CRM


Return(_cOrig)
