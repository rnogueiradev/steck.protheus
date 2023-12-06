#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTPE01  ºAutor  ³RGV Solcuoes        º Data ³  03/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega Estrutura no Orcamento                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFTPE01()

	if SCJ->CJ_STATUS = 'X'
		MsgInfo("Orçamento Liberado p/ Vendas...!!!!")
		Return()
	EndIf

	_cxCodProd :=SPACE(TamSX3("B1_COD")[1])

	@ 096,042 TO 280,505 DIALOG oDlgX TITLE "Carrega Estrutura para unicom"
	@ 002,010 TO 066,222
	@ 015,020 SAY "Cod.Produto"
	@ 015,060 Get _cxCodProd Picture "@!" SIZE 075,15 F3 "SB1" VALID NAOVAZIO() .AND. EXISTCPO("SB1",_cxCodProd)

	@ 075,0150 BMPBUTTON TYPE 1 ACTION   (u__fGrStru(_cxCodProd),oDlgX:End() )
	@ 075,0180 BMPBUTTON TYPE 2 ACTION  oDlgX:End()

	ACTIVATE DIALOG oDlgX CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTPE01  ºAutor  ³RGV Solucoes         º Data ³  03/03/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function _fGrStru(_cCodProd)
	Local _cTabela  := GETMV("ST_TPRCTMK",,'001')
	Local _aAreaSG1 := {}
	//oDlgX:End()

	_cLast := "00"

	Dbselectarea("SCJ")
	RecLock('SCJ',.f.)
	SCJ->CJ_XESBAS:=_cCodProd
	MsUnlock()

	Dbselectarea("SCK")
	Dbsetorder(1)
	Dbseek(xfilial("SCK")+SCJ->CJ_NUM)

	Do While !eof() .and. SCJ->CJ_NUM == SCK->CK_NUM
		_cLast:=SCK->CK_ITEM
		DbSkip()
	Enddo

	Dbselectarea("SG1")
	SG1->(DBGOTOP())
	//DBseek(xfilial("SG1")+_cCodProd)
	SG1->(DbSetOrder(1))
	SG1->(DBseek('04'+_cCodProd))
	Do While SG1->(!eof()) .and. _cCodProd == SG1->G1_COD

		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+SG1->G1_COMP)
		DbSelectArea("DA1")
		DA1->(DbSetOrder(1))
		If  DA1->(Dbseek(xFilial("DA1")+_cTabela+SG1->G1_COMP))
			_aAreaSG1 := SG1->(GetArea())
			_nPreco := U_STRETSST('01',scj->cj_cliente , scj->cj_loja,SG1->G1_COMP,scj->cj_Condpag,'PRECO')
			RestArea(_aAreaSG1)
		Else
			_aAreaSG1 := SG1->(GetArea())
			_nPreco := (u_STCUSTO(SG1->G1_COMP)*1.3)
			RestArea(_aAreaSG1)
		EndIf

		_nPreco := iif(_nPreco==0,0.01,_nPreco)

		_cLast := SOMA1(_cLast)

		_aAreaSG1 := SG1->(GetArea())
		_cTesEstr := U_STRETSST('01',scj->cj_cliente , scj->cj_loja,SG1->G1_COMP,scj->cj_Condpag,'TES')
		RestArea(_aAreaSG1)

		//-------------------------------------------------------------------------------------------------------------------
		// Alterado por Richard 19/10/17 - Para corrigir o erro no gatilho.
		// Caso a funcao U_STRETSST nao retorne a TES, uso a TES "501"
		// Como as funcoes STRETSST e STTESINTELIGENTE sao usadas em varias rotinas, preferi nao mexer nelas.
		//-------------------------------------------------------------------------------------------------------------------
		If Empty(_cTesEstr)
			_cTesEstr := "501"
		EndIf

		DbSelectarea("SCK")
		SCK->(RecLock("SCK",.T.))
		SCK->CK_FILIAL   	:= XFILIAL("SCK")
		SCK->CK_NUM   		:= SCJ->CJ_NUM
		SCK->CK_ITEM   		:= _cLast
		SCK->CK_PRODUTO		:= SG1->G1_COMP
		SCK->CK_UM			:= SB1->B1_UM
		SCK->CK_QTDVEN		:= SG1->G1_QUANT
		SCK->CK_PRCVEN		:= _nPreco
		SCK->CK_TES         := _cTesEstr						//U_STRETSST('01',scj->cj_cliente , scj->cj_loja,SG1->G1_COMP,scj->cj_Condpag,'TES')
		SCK->CK_VALOR		:= _nPreco * SG1->G1_QUANT
		SCK->CK_LOCAL		:= SB1->b1_LOCPAD
		SCK->CK_DESCRI		:= SB1->b1_DESC
		SCK->CK_PRUNIT		:= _nPreco
		SCK->CK_CLIENTE 	:= SCJ->CJ_CLIENTE
		SCK->CK_LOJA    	:= SCJ->CJ_LOJA
		SCK->CK_XPRUNIC 	:= u_STCUSTO(SG1->G1_COMP)
		SCK->CK_XPRVDA  	:= 0
		SCK->(MsUnLock())
		
		RestArea(_aAreaSG1)

		SG1->(DbSkip())
		
	Enddo
	msginfo("Carregamento Finalizado!!!")
Return

