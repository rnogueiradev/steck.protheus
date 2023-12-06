#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | M450ABRW         | Autor | GIOVANI.ZAGO             | Data | 17/03/2013  |
|=====================================================================================|
|Descri��o | M450ABRW                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | M450ABRW                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
User Function M450ABRW()
*-----------------------------*
Local cQuery := PARAMIXB[1]                                    

cQuery += "  AND SC5.C5_ZBLOQ <> '1' 							"

Return cQuery