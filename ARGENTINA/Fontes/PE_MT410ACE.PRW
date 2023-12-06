#INCLUDE "PROTHEUS.CH"

/*/
função: mt410ace
descrição: função para bloquear a alteração do pedido quando o usuário não possui permissao
Ticket: 20230822010660-BLOQUEIO DE ALTERACAO DE PEDIDO DE VENDA
/*/

User Function Mt410Ace()

	Local lRet := .F.
	Local cUsrFull :=  SuperGetMV("FS_FLPED", .F., "")
	Local cUsrAtu  := RetCodUsr()

	if cUsrAtu $ cUsrFull
		lRet := .T.
	EndIf	

    if !lRet
		dbselectarea("SA3")
		SA3->( dbsetorder(7) )
		if SA3->( dbseek( xFilial("SA3") + cUsrAtu ) )

			if alltrim(SC5->C5_VEND1) == alltrim(SA3->A3_COD)
				lRet := .T.
			endif

		endif
        
    endif

Return(lRet)
