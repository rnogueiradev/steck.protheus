#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STREST50        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL getAcessos DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Retornar acessos do aplicativo" WSSYNTAX "/rest/getAcessos"

END WSRESTFUL

WSMETHOD POST WSSERVICE getAcessos

	Local cResp 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cUserLog := __cUserId
	
	ConOut("[STREST50]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STREST50]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)
	
	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	::SetContentType("application/json;charset=UTF-8")

	cResp := '{"status":"OK","iderp":"'+_cUserLog+'"}'
	
	Conout(cResp)

	::SetResponse(cResp)

Return .T.
