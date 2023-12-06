#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | AREST010        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | CRIAR SALDO NA SB2						                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function AREST010(_cProduto)

	DbSelectArea("NNR")
	NNR->(DbSetOrder(1))
	NNR->(DbGoTop())

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+_cProduto))

		While NNR->(!Eof())

			CriaSb2(SB1->B1_COD,NNR->NNR_CODIGO)

			NNR->(DbSkip())
		EndDo

	EndIf

Return(.T.)