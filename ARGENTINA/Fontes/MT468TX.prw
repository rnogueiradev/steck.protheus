#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | MT468TX         | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descri��o | AJUSTAR TAXA DA FATURA					                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function MT468TX()

	Local _nTaxa := 0

	DbSelectArea("SM2")
	SM2->(DbSetOrder(1))
	SM2->(DbGoTop())
	If SM2->(DbSeek(DTOS(DDATABASE)))
		_nTaxa := SM2->&("M2_MOEDA"+CVALTOCHAR(SC5->C5_MOEDA))
	EndIf

Return(_nTaxa)