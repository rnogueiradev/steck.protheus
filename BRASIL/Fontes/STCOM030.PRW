#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"

/*/{Protheus.doc} STCOM030
@name STCOM030
@type User Function
@desc validar inclus�o de SA5
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOM030()

	Local _lRet := .T.

	If !__cUserId $ GetMv("ST_GRPQLD") .And. !SubStr(M->A5_PRODUTO,1,1) $ "EU"
		_lRet := .F.
		MsgAlert("Aten��o, somente a qualidade pode cadastrar amarra��o de produtos diferentes de U e E, verifique!")
	EndIf

Return(_lRet)