#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#Define CR chr(13)+chr(10)
#Define STR_PULA		Chr(13)+Chr(10)
 

WSSERVICE AUTHUSER DESCRIPTION "Servi�o ws de valida��o de senha"
	
	WSDATA USR  As String //String que vamos receber via URL
	WSDATA cret AS String
	
	WSMETHOD GET DESCRIPTION "M�todo que retorna telegr"
	
ENDWSSERVICE
 
WSMETHOD GET WSRECEIVE USR  wssend cret WSSERVICE AUTHUSER

	
 
	::cret:= 	'ok'
	
Return .T.