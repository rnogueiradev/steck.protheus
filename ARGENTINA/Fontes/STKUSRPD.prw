#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

/*/
função: STKUSRPD
descrição: função para bloquear a edição do campo quando informado no X3_WHEN.
Ticket: 20230822010660-BLOQUEIO DE ALTERACAO DE PEDIDO DE VENDA
/*/

User Function STKUSRPD()

	Local lRet := .F.
	Local cUsrFull :=  SuperGetMV("FS_FLPED", .F., "")
	Local cUsrAtu  := RetCodUsr()

	if cUsrAtu $ cUsrFull

		lRet := .T.

	EndIf	

Return(lRet)
