#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

User Function xRestIni()
	Local xRet
	RpcSetType(3)
	while Select("SM0") <= 0 .AND. !RpcSetEnv("01","02",,,"ACD")
		Sleep(2000)
	endDo
	xRet := REST_START()
	Conout("Iniciando")
return xRet 

User Function xRestCon()
	Local xRet
	Conout("Conectando "+Time())
	xRet := REST_CONNECT()
	Conout("Conectado "+Time())
return xRet

User Function xRestExi()
	Local xRet
	xRet := REST_EXIT()
	Conout("Saindo")
return xRet

User Function xPrepEnv()
	//
return .T. 

/*====================================================================================\
|Programa  | STREST40        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL getMenuApp DESCRIPTION "Aplicativo Steck"

WSDATA cUser As String OPTIONAL

WSMETHOD POST DESCRIPTION "Retornar rotinas" WSSYNTAX "/rest/getMenuApp"

END WSRESTFUL

WSMETHOD POST WSSERVICE getMenuApp

	Local cResp := '{ "hello": "world" }'
	
	Conout(1)

	::SetContentType("application/json;charset=UTF-8")
	
	::SetResponse(EncodeUTF8(cResp))
	
	Reset Environment
	
	Conout("passou")

Return .T.