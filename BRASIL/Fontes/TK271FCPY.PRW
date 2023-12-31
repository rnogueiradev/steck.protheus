#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | TK271FCPY         | Autor | Renato Nogueira           | Data | 09/10/2018|
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       |                                                                          |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function TK271FCPY()

	MsgAlert("Cota��o gerada "+PARAMIXB[2])

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))
	SUA->(DbGoTop())	
	If SUA->(DbSeek(xFilial("SUA")+PARAMIXB[2]))

		SUA->(RecLock("SUA",.F.))
		SUA->UA_XBLOQ 	:= "2"
		SUA->UA_XDESBLQ	:= ""
		SUA->UA_XNOME 	:= Posicione("SA1",1,xFilial("SA1")+SUA->(UA_CLIENTE+UA_LOJA),"A1_NOME")
		SUA->(MsUnLock())

	EndIf

Return