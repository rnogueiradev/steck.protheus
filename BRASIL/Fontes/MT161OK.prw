#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | MT160AOK        | Autor | RENATO.NOGUEIRA            | Data | 26/11/2015 |
|=====================================================================================|
|Descri��o | MT160AOK                                                                 |
|          | Valida fornecedor na rotina analisa  cota��o                             |
|          | Chamado 002995                                                           |
|=====================================================================================|
|Sintaxe   | MT160AOK                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function MT161OK()

	Local _aArea    := GetArea()
	Local _lRet	  := .T.

	If SC8->C8_PRECO>0

		_lRet	:= U_STVLDSA2(SC8->C8_FORNECE,SC8->C8_LOJA) //Chamado 002995

		If Empty(SC8->C8_TPFRETE)
			msgAlert("O Tipo do Frete n�o foi informado na cota��o, portanto o pedido de compra n�o pode ser gerado!")
			_lRet	  := .F.
		EndIf

	EndIf

	RestArea(_aArea)

Return _lRet