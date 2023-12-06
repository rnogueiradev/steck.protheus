#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM140        | Autor | RENATO.OLIVEIRA           | Data | 10/01/2019  |
|=====================================================================================|
|Descrição | Retornar preco 2 unidade de medida					                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM140()

	Local _nPreco := 0

	If SB1->B1_CONV>0

		Do Case
			Case SB1->B1_TIPCONV=="M"
			_nPreco := (1*SB1->B1_CONV)*M->AIB_XPRC2
			Case SB1->B1_TIPCONV=="D"
			_nPreco := (1/SB1->B1_CONV)*M->AIB_XPRC2
		EndCase

	EndIf

Return(_nPreco)