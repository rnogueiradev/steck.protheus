#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | WSGPEVALVAC     | Autor | RENATO.OLIVEIRA           | Data | 17/09/2019  |
|=====================================================================================|
|Descri��o | PE para validar solicita��o de f�rias do portal                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function WSGPEVALVAC()

	Local lRet := .T.

	Local cDatai := PARAMIXB[1]
	Local cDataf := PARAMIXB[2]
	Local nDias  := PARAMIXB[3]

	If Dow(CTOD(cDatai))==1 .Or. Dow(CTOD(cDatai))==7 //S�bado ou domingo
		lRet := .F.
	EndIf

	DbSelectArea("SP3")
	SP3->(DbSetOrder(1))
	SP3->(DbGoTop())
	If SP3->(DbSeek(xFilial("SP3")+DTOS(CTOD(cDatai))))
		lRet := .F.
	EndIf

Return (lRet)