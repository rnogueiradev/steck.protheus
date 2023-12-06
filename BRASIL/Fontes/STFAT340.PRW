#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT340        | Autor | RENATO.OLIVEIRA           | Data | 17/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT340(_cTipo,_cOrig,oDlg,_lMostra)

	Local _lRet         := .T.
	Local _lEntrou 		:= .F.
	Local _cMsg			:= ""
	Default oDlg		:= Nil
	Default _lMostra 	:= .T.

	DbSelectArea("Z44")
	Z44->(DbSetOrder(1))
	If Z44->(DbSeek(xFilial("Z44")+SA1->(A1_COD+A1_LOJA)))

		If AllTrim(_cTipo)==AllTrim(Z44->Z44_XTPBL1)
			If AllTrim(_cOrig)=="T"
				If _lMostra
					MsgAlert(Z44->Z44_XMSBL1)
				EndIf
			Else
				If _lMostra
					VTALERT(Z44->Z44_XMSBL1)
				EndIf
			EndIf
			_lRet := .F.
			If AllTrim(_cTipo)=="3"
				_cMsg := Z44->Z44_XMSBL1
			EndIf
		EndIf
		If IsInCallStack("STFSFA30")
			If !Empty(cOrdSep) .And. Empty(cPedido)	// Ticket 20210623010632 - Bloqueio Tela De Embalagem para pedidos com mensagens -- Eduardo Pereira Sigamat -- 20.09.2021 -- Inclusão das linhas 47 e 63
				If AllTrim(_cTipo) == AllTrim(Z44->Z44_XTPBL2)
					If AllTrim(_cOrig)=="T"
						If _lMostra
							MsgAlert(Z44->Z44_XMSBL2)
						EndIf
					Else
						If _lMostra
							VTALERT(Z44->Z44_XMSBL2)
						EndIf
					EndIf
					_lRet := .F.
					If AllTrim(_cTipo)=="3"
						_cMsg := Z44->Z44_XMSBL2
					EndIf
				EndIf
			EndIf
		Else
			If AllTrim(_cTipo)==AllTrim(Z44->Z44_XTPBL2)
				If AllTrim(_cOrig)=="T"
					If _lMostra
						MsgAlert(Z44->Z44_XMSBL2)
					EndIf
				Else
					If _lMostra
						VTALERT(Z44->Z44_XMSBL2)
					EndIf
				EndIf
				_lRet := .F.
				If AllTrim(_cTipo)=="3"
					_cMsg := Z44->Z44_XMSBL2
				EndIf
			EndIf
		EndIf
		If AllTrim(_cTipo)==AllTrim(Z44->Z44_XTPBL3)
			If AllTrim(_cOrig)=="T"
				If _lMostra
					MsgAlert(Z44->Z44_XMSBL3)
				EndIf
			Else
				If _lMostra
					VTALERT(Z44->Z44_XMSBL3)
				EndIf
			EndIf
			_lRet := .F.
			If AllTrim(_cTipo)=="3"
				_cMsg := Z44->Z44_XMSBL3
			EndIf
		EndIf
		If AllTrim(_cTipo)==AllTrim(Z44->Z44_XTPBL4)
			If AllTrim(_cOrig)=="T"
				If _lMostra
					MsgAlert(Z44->Z44_XMSBL4)
				EndIf
			Else
				If _lMostra
					VTALERT(Z44->Z44_XMSBL4)
				EndIf
			EndIf
			_lRet := .F.
			If AllTrim(_cTipo)=="3"
				_cMsg := Z44->Z44_XMSBL4
			EndIf
		EndIf
		If AllTrim(_cTipo)=="2" .And. !_lRet .And. AllTrim(_cOrig)=="T"
			If MsgYesNo("Deseja continuar")
				_lRet := .T.
			Else
				oDlg:End()
				Return .F.
			EndIf
		EndIf
		If AllTrim(_cTipo)=="4" .And. (IsInCallStack("U_STFSFA30") .Or. IsInCallStack("U_STALTSC5")) .And. !_lRet .And. AllTrim(_cOrig)=="T"
			If MsgYesNo("Deseja continuar")
				_lRet := .T.
			Else
				oDlg:End()
				Return .F.
			EndIf
		EndIf
		If AllTrim(_cTipo)=="1" .And. IsInCallStack("U_STALTSC5") .And. !_lRet .And. AllTrim(_cOrig)=="T"
			If MsgYesNo("Deseja continuar")
				_lRet := .T.
			Else
				oDlg:End()
				Return .F.
			EndIf
		EndIf

		If AllTrim(_cTipo)=="3" .And. !_lRet
			
			If Empty(CB7->CB7_XMSG)
				CB1->(RecLock("CB1",.F.))
				CB1->CB1_XMSG	:= _cMsg
				CB1->(MsUnLock())

				CB7->(RecLock("CB7",.F.))
				CB7->CB7_XMSG	:= "S"
				CB7->(MsUnLock())

			EndIf
		EndIf

	EndIf

Return(_lRet)
