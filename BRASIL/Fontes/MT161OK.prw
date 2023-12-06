#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | MT160AOK        | Autor | RENATO.NOGUEIRA            | Data | 26/11/2015 |
|=====================================================================================|
|Descrição | MT160AOK                                                                 |
|          | Valida fornecedor na rotina analisa  cotação                             |
|          | Chamado 002995                                                           |
|=====================================================================================|
|Sintaxe   | MT160AOK                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MT161OK()

	Local _aArea    := GetArea()
	Local _lRet	  := .T.

	If SC8->C8_PRECO>0

		_lRet	:= U_STVLDSA2(SC8->C8_FORNECE,SC8->C8_LOJA) //Chamado 002995

		If Empty(SC8->C8_TPFRETE)
			msgAlert("O Tipo do Frete não foi informado na cotação, portanto o pedido de compra não pode ser gerado!")
			_lRet	  := .F.
		EndIf

	EndIf

	RestArea(_aArea)

Return _lRet