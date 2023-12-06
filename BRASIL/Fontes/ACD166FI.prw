#include "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ACD166FI ³ Autor ³ FABRICA DE SOFTWARE    	 								  ³ Data ³ 09/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE ao termino do processo de separacao onde analisa a Ordem de Separacao e:                      ³±±
±±³          ³ - Caso OS auxiliar, grava as informacoes separadas na OS Pai e exclui a OS auxiliar              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Tipo Array																						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cliente   ³ Especifico cliente Steck  													 			 		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACD166FI()
	Local aArea    := GetArea()
	Local aAreaCB7 := CB7->(GetArea())
	Local aAreaCB8 := CB8->(GetArea())
	Local nRecnoCB8
	Local cProdCB8
	Local cOSAux
	Local cOSPai
	Local cOpeAux
	Local dDIAuxanArm
	Local cHIAux
	Local dDFAux
	Local cHFAux
	//Chamado 002572 abre
	Local _lRet := .T.
	Private _cAlias	:= GetNextAlias()//Chamado erro de empenho

	//Chamado 002572 fecha
	If TudoSepOK(CB7->CB7_ORDSEP)
		CB7->(RecLock("CB7",.F.))
		CB7->CB7_XSEP := "1"
		CB7->CB7_XDFSE := Date()
		CB7->CB7_XHFSE := Time()
		CB7->(MsUnLock())
	EndIf
	//Chamado 002572 abre
	STCB8QUER(CB7->CB7_ORDSEP)

	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	If  Select(_cAlias) > 0
		If 	(_cAlias)->(!Eof())
			If !((_cAlias)->SALDO_ORDSEP) = 0
				_lRet := .F.
			Endif
		Endif
		(_cAlias)->(dbCloseArea())
	EndIf

	//If _lRet
	//	VtMsg('Transferindo estoques...')
	//	CB7->(U_STTranArm(CB7_PEDIDO,CB7_OP,CB7_CODOPE))
	//Else
	IF !_lRet
		//Chamado 002572 fecha
		/*
		_lOutroOp := .F.

		CB8->(DbSetOrder(1))
		CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP))
		While CB8->(!Eof() .AND. CB8_FILIAL+CB8_ORDSEP == xFilial("CB8")+CB7->CB7_ORDSEP)
		If !CB8->(RLock())
		_lOutroOp := .T.
		Exit
		EndIf
		CB8->(DbSkip())
		EndDo

		If _lOutroOp
		VtAlert('Ordem de Separacao '+CB7->CB7_ORDSEP+' sendo finalizada por outro separador!')
		Else
		VtAlert('Ordem de Separacao '+CB7->CB7_ORDSEP+' pendente para separacao posterior...')
		EndIf
		*/

		VtAlert('Ordem de Separacao '+CB7->CB7_ORDSEP+' pendente para separacao posterior...')

		Return

	Endif

	If Empty(CB7->CB7_XOSPAI)
		Return
	Endif

	cOSAux  := CB7->CB7_ORDSEP
	cOSPai  := CB7->CB7_XOSPAI
	cOpeAux := CB7->CB7_CODOPE

	dDIAux  := CB7->CB7_XDISE
	cHIAux  := CB7->CB7_XHISE
	dDFAux  := CB7->CB7_XDFSE
	cHFAux  := CB7->CB7_XHFSE

	If !TudoSepOK(cOSAux) //Verifica se todos os itens da OS Auxiliar foram separados:
		RestArea(aAreaCB8)
		RestArea(aAreaCB7)
		RestArea(aArea)
		Return
	Endif

	VtMsg('Ajustando OS...')

	//Atualiza a OS Pai e exclui as informacoes da OS Auxiliar:
	CB8->(DbSetOrder(1))
	CB8->(DbSeek(xFilial("CB8")+cOSAux))
	While CB8->(!Eof() .AND. CB8_FILIAL+CB8_ORDSEP == xFilial("CB8")+cOSAux)

		nRecnoCB8 := CB8->(Recno())
		cProdCB8  := CB8->CB8_PROD

		//Seta o saldo a separar da OS Pai:
		CB8->(DbSeek(xFilial("CB8")+cOSPai))
		While !CB8->(EOF()) .And. CB8->CB8_ORDSEP == cOSPai
			If CB8->CB8_PROD == cProdCB8
				CB8->(RecLock("CB8",.F.))
				CB8->CB8_SALDOS := 0
				CB8->(MsUnLock())
			EndIf
			CB8->(dbSkip())
		EndDo

		//Exclui os itens da OS Auxiliar:
		CB8->(DbGoTo(nRecnoCB8))
		CB8->(RecLock("CB8",.F.))
		CB8->(DbDelete())
		CB8->(MsUnLock())

		CB8->(DbSkip())
	Enddo

	CB9->(DbSetOrder(1))
	While CB9->(DbSeek(xFilial("CB9")+cOSAux))
		CB9->(RecLock("CB9",.F.))
		CB9->CB9_ORDSEP := cOSPai
		CB9->(MsUnLock())
		CB9->(DbSkip())
	Enddo

	CB7->(DbSetOrder(1))
	If CB7->(DbSeek(xFilial("CB7")+cOSPai))
		CB7->(RecLock("CB7",.F.))
		CB7->CB7_XOPAUX := cOpeAux
		CB7->CB7_XDISEF := dDIAux
		CB7->CB7_XHISEF := cHIAux
		CB7->CB7_XDFSEF := dDFAux
		CB7->CB7_XHFSEF := cHFAux
		If TudoSepOK(cOSPai) //Verifica se todos os itens da OS Pai foram separados:
			CB7->CB7_STATUS 	:= "2"
			CB7->CB7_XSEP 		:= "1"
			If Empty(CB7->CB7_CODOPE)
				CB7->CB7_CODOPE := cOpeAux
			EndIf
		Endif
		CB7->(MsUnLock())
	Endif

	If CB7->(DbSeek(xFilial("CB7")+cOSAux))
		CB7->(RecLock("CB7",.F.))
		CB7->(DbDelete())
		CB7->(MsUnLock())
	Endif

	RestArea(aAreaCB8)
	RestArea(aAreaCB7)
	RestArea(aArea)

Return

Static Function TudoSepOK(cOS)
	Local aAreaCB8 := CB8->(GetArea())
	Local lSepTudo := .t.

	CB8->(DbSetOrder(1))
	If	CB8->(DbSeek(xFilial("CB8")+cOS))
		While CB8->(!Eof()) .AND. CB8->CB8_FILIAL = xFilial("CB8") .AND. CB8->CB8_ORDSEP = cOS
			conout(cvaltochar(CB8->CB8_SALDOS)+'-'+CB8->CB8_ORDSEP+'-'+CB8->CB8_ITEM)
			If CB8->CB8_SALDOS > 0
				lSepTudo := .f.
				Exit
			Endif
			CB8->(DbSkip())
		Enddo
	Endif
	RestArea(aAreaCB8)
Return lSepTudo

//Chamado 002572
Static Function STCB8QUER(cOrdSep)

	Local _cQuery   := ""

	_cQuery := " SELECT
	_cQuery += " CB8_FILIAL AS FILIAL,
	_cQuery += " CB8_ORDSEP AS NUM_ORDSEP,
	_cQuery += " SUM(CB8_SALDOS) AS SALDO_ORDSEP

	_cQuery += " FROM "+RetSqlName("CB8")+" CB8 "

	_cQuery += " WHERE CB8.D_E_L_E_T_ = ' '
	_cQuery += " AND CB8_FILIAL = '"+xFilial("CB8")+"'
	_cQuery += " AND CB8_ORDSEP = '"+cOrdSep+"'

	_cQuery += " GROUP BY CB8_FILIAL, CB8_ORDSEP

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

Return()
