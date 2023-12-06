#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TbiConn.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} M461ADT()
    (long_description)
    Ponto de Entrada em MATA461 - Verificar produtos em inventario randomico
    @type  Function
    @author user
    Jose Carlos Frasson
    @since date
    14/10/2020
    @example
/*/

User Function M461ADT()
	Local aParam 	:= PARAMIXB
	Local lRet 		:= .T.
	Local _cPedido	:= ""
	Local _cItem	:= ""
	Local _cLocal	:= ""
	Local _cProd	:= "" 

    If aParam <> NIL
    	_cPedido	:= aParam[1]
    	_cItem		:= aParam[2]
    		
		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		
		If SC6->(dbSeek(xFilial("SC6") + _cPedido + _cItem))
			_cProd	:= SC6->C6_PRODUTO
			_cLocal	:= SC6->C6_LOCAL
			
			dbSelectArea("CBA")
			CBA->(dbSetOrder(4))

			If CBA->(dbSeek(xFilial("CBA") + _cProd + "1" + _cLocal))
				If CBA->CBA_STATUS $ "1/2/3/4/6"
					MSGALERT("O item " + _cProd + " do pedido "+ _cPedido + " está em inventario rotativo e não será liberado para faturar!")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
Return(lRet)