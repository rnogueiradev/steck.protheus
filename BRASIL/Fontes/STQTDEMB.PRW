#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STQTDEMB       | Autor | RENATO.NOGUEIRA            | Data | 14/10/2015  |
|=====================================================================================|
|Descri��o |  STQTDEMB      Verificar quantidade de embalagem padr�o                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQTDEMB                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STQTDEMB(_cProduto,_nQuant)

	Local _lRet	:= .T.

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+_cProduto))
		
		If SB1->B1_QE > 0
			If ! ( (_nQuant/SB1->B1_QE) - INT(_nQuant/SB1->B1_QE) == 0 )
				MsgAlert("Aten��o, quantidade fora do padr�o de embalagem, a quantidade padr�o �: "+CVALTOCHAR(SB1->B1_QE))
			EndIf
		EndIf

	EndIf

Return(_lRet)