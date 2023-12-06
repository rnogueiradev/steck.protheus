#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | MT121BRW        | Autor | RENATO.OLIVEIRA           | Data | 26/07/2018  |
|=====================================================================================|
|Descri��o | ADICIONAR MENU NO PEDIDO DE COMPRA		                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function MT121BRW()

aAdd(aRotina,{"Gerar PV Brasil","U_AREEC010", 0, Len(aRotina)+1, 0, .F. })
aAdd(aRotina,{"Invoice","U_ARFAT06", 0, Len(aRotina)+1, 0, .F. })
aAdd(aRotina,{"Importar CSV","U_ARCPEDCOMP", 0, Len(aRotina)+1, 0, .F. })

Return()