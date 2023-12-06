/*/{Protheus.doc} M468MKB

Filtra a TES 553 que não gera financeiro

@type function
@author Everson Santana
@since 08/02/19
@version Protheus 12 - Faturamento

@history ,Ticket 20190412000112 ,

/*/


User Function M468MKB()

	Local cFiltro := ""
	Local _cQry := ""
	Local _cRet := ""

	_cQry := " "
	_cQry += " UPDATE SD2070 SET D2_XMKT = 'S'  WHERE D2_TES IN('552','553') AND D2_XMKT = ' ' AND D_E_L_E_T_ = ' ' "

	TCSqlExec(_cQry)


	If !lPedidos
		cFiltro := " AND D2_XMKT = ' ' "
	EndIf


Return cFiltro

