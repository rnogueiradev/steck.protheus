#Include "Average.ch"

/*
Programa...: EECPPE04
Objetivo...: Valida se existe ordem de separa��o gerada para os pedidos de exporta��o
             Chamado 006600
Autor......: Everson Santana
Data/Hora..: 19/01/2018
Observa��es:
*/

User Function EECPPE04()

	Local lRet := .F.
	/*
	Local aOrd := SaveOrd({"ZZA"})
	Local cPedVenda := EE7->EE7_PEDFAT
 
	ZZA->(DbSetOrder(3)) // ZZA_FILIAL+ZZA_PEDFAT+ZZA_ORDSEP
	If ZZA->(DbSeek(xFilial("ZZA")+Avkey(cPedVenda,"ZZA_PEDFAT")))
		
		MsgInfo("Pedido n�o pode ser alterado, pois existe(m) ordem (ns) de separa��o gerada (s) para ele!","Aten��o")
		
		Break
		lRet := .T.
	EndIf

	RestOrd(aOrd)
*/
Return lRet
