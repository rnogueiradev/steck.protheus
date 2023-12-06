/*/{Protheus.doc} MT100CLA

@type function
@author Everson Santana
@since 11/06/19
@version Protheus 12 - Estoque/Custos - Compras

@history ,Ticket 20190412000053 ,

/*/

User Function MT100CLA()

	Local _lRet	:= .T.

	If Empty(SF1->F1_XNOTREB) .AND. SF1->F1_FILIAL = '05'

		MsgAlert("Está nota fiscal ainda não teve sua confirmação de recebimento Fisico.","Atenção")
		Return

	EndIf

Return _lRet