#Include "Average.ch"

/*
Programa...: EECPPE04
Objetivo...: Valida se existe ordem de separação gerada para os pedidos de exportação
             Chamado 006600
Autor......: Everson Santana
Data/Hora..: 19/01/2018
Observações:
*/

User Function EECPPE04()

	Local lRet := .F.
	/*
	Local aOrd := SaveOrd({"ZZA"})
	Local cPedVenda := EE7->EE7_PEDFAT
 
	ZZA->(DbSetOrder(3)) // ZZA_FILIAL+ZZA_PEDFAT+ZZA_ORDSEP
	If ZZA->(DbSeek(xFilial("ZZA")+Avkey(cPedVenda,"ZZA_PEDFAT")))
		
		MsgInfo("Pedido não pode ser alterado, pois existe(m) ordem (ns) de separação gerada (s) para ele!","Atenção")
		
		Break
		lRet := .T.
	EndIf

	RestOrd(aOrd)
*/
Return lRet
