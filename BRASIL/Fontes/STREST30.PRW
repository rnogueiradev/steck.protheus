#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STREST30        | Autor | RENATO.OLIVEIRA           | Data | 05/02/2019  |
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

WSRESTFUL stkGoogleCalendar DESCRIPTION "Google Calendar"

WSDATA code AS STRING

WSMETHOD GET DESCRIPTION "Google Calendar" WSSYNTAX "/html-protheus/rest"
WSMETHOD POST DESCRIPTION "Google Calendar" WSSYNTAX "/html-protheus/rest"

END WSRESTFUL

WSMETHOD POST WSSERVICE stkGoogleCalendar
	Local cResp := ''
	
	if Type("::code") == "c"
		cResp := ::code
	endif
	
	cResp := ::code

	::SetResponse(EncodeUTF8(cResp))
Return .t.

WSMETHOD GET WSSERVICE stkGoogleCalendar

	Local cResp := ''
	
	if Type("::code") == "c"
		cResp := ::code
	endif
	
	cResp := ::code

	::SetResponse(EncodeUTF8(cResp))
Return .t.