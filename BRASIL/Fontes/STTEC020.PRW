#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"

/*/{Protheus.doc} STTEC020
@name STTEC020
@type User Function
@desc proximo numero de chamado
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STTEC020()

	Local cQuery4 		:= ""
	Local cAlias4 		:= GetNextAlias()
	Local _lAguarda		:= .T.

	While _lAguarda
		If LockByName("STTEC020",.F.,.F.,.T.)
			_lAguarda := .F.
		Else
			Sleep(2000)
		EndIf
	EndDo

	cQuery4 := " SELECT Z0_NUM
	cQuery4 += " FROM SZ0010 Z0
	cQuery4 += " WHERE Z0.D_E_L_E_T_=' '
	cQuery4 += " ORDER BY Z0_NUM DESC

	If !Empty(Select(cAlias4))
		DbSelectArea(cAlias4)
		(cAlias4)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery4),cAlias4,.T.,.T.)

	dbSelectArea(cAlias4)
	(cAlias4)->(dbGoTop())

	If (cAlias4)->(!Eof())
		_cNum := Soma1((cAlias4)->Z0_NUM)
	EndIf

	UnLockByName("STTEC020",.F.,.F.,.T.)

Return(_cNum)