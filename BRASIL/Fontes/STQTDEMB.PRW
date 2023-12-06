#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STQTDEMB       | Autor | RENATO.NOGUEIRA            | Data | 14/10/2015  |
|=====================================================================================|
|Descrição |  STQTDEMB      Verificar quantidade de embalagem padrão                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQTDEMB                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STQTDEMB(_cProduto,_nQuant)

	Local _lRet	:= .T.

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+_cProduto))
		
		If SB1->B1_QE > 0
			If ! ( (_nQuant/SB1->B1_QE) - INT(_nQuant/SB1->B1_QE) == 0 )
				MsgAlert("Atenção, quantidade fora do padrão de embalagem, a quantidade padrão é: "+CVALTOCHAR(SB1->B1_QE))
			EndIf
		EndIf

	EndIf

Return(_lRet)