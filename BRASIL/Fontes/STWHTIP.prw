#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STWHTIP          | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descri��o |  STWHTIP     WHEN DO C5_TIPO		                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STWHTIP                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
User Function STWHTIP()
*-----------------------------*
Private aArea         := GetArea()
Private lRet          := .F.

If ( Type("l410Auto") == "U" .OR. !l410Auto )
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If !(SA3->(dbSeek(xFilial('SA3')+RetCodUsr())))
		lRet:=  .T.
	EndIf
EndIf
Return(lRet)
