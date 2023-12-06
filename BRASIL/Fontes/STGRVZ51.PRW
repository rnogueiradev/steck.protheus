#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*====================================================================================\
|Programa  | STGRVZ51         | Autor | Renato Nogueira            | Data | 15/10/2019|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STGRVZ51(_cPedido,_dData,_cTime,_cMotivo,_cTipo,_cUser,_aItens)

	Local _nX 		:= 0
	Local cCodigo	:= ""

	DbSelectArea("Z51")

	cCodigo := Z51->(GetSX8Num("Z51","Z51_CODIGO"))
	ConfirmSX8()

	Z51->(RecLock("Z51",.T.))
	Z51->Z51_FILIAL := xFilial("Z51")
	Z51->Z51_CODIGO := cCodigo
	Z51->Z51_PEDIDO := _cPedido
	Z51->Z51_DATA  	:= _dData
	Z51->Z51_HORA   := _cTime
	Z51->Z51_MOTIVO := _cMotivo
	Z51->Z51_TIPO  	:= _cTipo
	Z51->Z51_USER   := _cUser
	Z51->(MsUnLock())

	For _nX:=1 To Len(_aItens)
		Z52->(RecLock("Z52",.T.))
		Z52->Z52_FILIAL := Z51->Z51_FILIAL
		Z52->Z52_CODIGO := cCodigo
		Z52->Z52_PEDIDO := Z51->Z51_PEDIDO
		Z52->Z52_ITEM  	:= _aItens[_nX][1]
		Z52->Z52_PROD   := _aItens[_nX][2]
		Z52->Z52_QTD	:= _aItens[_nX][3]
		Z52->Z52_VALOR 	:= Round(_aItens[_nX][3]*_aItens[_nX][4],2)
		Z52->(MsUnLock())
	Next

Return()