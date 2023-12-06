#INCLUDE "PROTHEUS.CH"

/*====================================================================================\
|Programa  | MA410MNU         | Autor | Everson Santana          | Data | 17/07/2018  |
|=====================================================================================|
|Descri��o |   P.E. MA410MNU				     	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MA410MNU                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

*-----------------------------*
User Function MA410MNU()

aadd( aRotina, {"Imprimir","U_ARFAT02()",0,2,0,NIL} )
aadd( aRotina, {"Markup","U_ARFSVE39()",0,2,0,NIL} )		
aadd( aRotina, {"Importar CSV","U_FIMPCSVEXEC()",0,2,0,NIL} )	

Return()
