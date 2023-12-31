#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT440        | Autor | RENATO.OLIVEIRA           | Data | 15/09/2020  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STFAT440(_cEmail)

	Local _aCnpjs := {}

	DbSelectArea("Z79")
	Z79->(DbSetOrder(1))

	If Z79->(DbSeek(xFilial("Z79")+_cEmail))
		While Z79->(!Eof()) .And. AllTrim(Z79->Z79_EMAIL)==AllTrim(_cEmail)
			AADD(_aCnpjs,Z79->Z79_CNPJS)
			Z79->(DbSkip())
		EndDo
	EndIf

Return(_aCnpjs)
