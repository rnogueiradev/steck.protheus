#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*====================================================================================\
|Programa  | STCANSUA         | Autor | Renato Nogueira            | Data | 13/12/2018|
|=====================================================================================|
|Descrição | Cancelar orçamentos em massa                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                       |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCANSUA()

	Local _nX
	Local _aDados 	:= {}
	Local _cQuery1 	:= ""
	Local _cAlias1  := ""

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

AADD(_aDados,'468159')
AADD(_aDados,'468657')
AADD(_aDados,'475792')
AADD(_aDados,'619817')
AADD(_aDados,'628896')
AADD(_aDados,'629479')
AADD(_aDados,'629830')
AADD(_aDados,'633146')
AADD(_aDados,'634616')
AADD(_aDados,'639235')
AADD(_aDados,'642128')
AADD(_aDados,'647308')
AADD(_aDados,'654737')



	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))

	DbSelectArea('ZZI')
	ZZI->(DbSetOrder(3))

	For _nX:=1 To Len(_aDados)

		SUA->(DbGoTop())
		If SUA->(DbSeek(xFilial("SUA")+_aDados[_nX]))
			SUA->(RecLock("SUA",.F.))
			SUA->UA_XBLOQ	:= "3"
			_cMsgCan 		:=	"Solicitante: " + cUserName+CRLF+;
			"Solicitação em " + DtoC(dDatabase) + " às " + Time() + CRLF +;
			"Motivo do Cancelamento: "+ Upper(PADL("000001",6,"0"))+CRLF+;
			"Descrição da Solicitação: " + CRLF + Upper(Alltrim("CLIENTE SOLICITOU SOMENTE PREÇO (20200918007540)"))
			SUA->UA_XCODMCA := PADL(Alltrim("000001"),6,"0")
			SUA->(MsUnLock())
			SUA->(RecLock("SUA",.F.))
			MSMM(SUA->UA_XCODCAN,,,_cMsgCan,1,,,"SUA", "UA_XCODCAN",,.T.)
			SUA->(MsUnLock())

			ZZI->(DbGoTop())
			If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM))
				If ZZI->ZZI_BLQ = '2'
					ZZI->(RecLock('ZZI',.F.))
					ZZI->(DbDelete())
					ZZI->(MsUnlock())
					ZZI->( DbCommit() )
				Endif
			Endif

		EndIf

	Next

Return()
