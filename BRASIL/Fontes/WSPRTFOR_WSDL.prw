#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://200.171.223.154:8356/ws/WSPRTFOR.apw?WSDL
Gerado em        06/25/18 14:38:13
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _MLYFWQT ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSPRTFOR
------------------------------------------------------------------------------- */

WSCLIENT WSWSPRTFOR

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CONFIRMAPED
	WSMETHOD CONSULTARPROD

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCXMLENV                  AS string
	WSDATA   cCONFIRMAPEDRESULT        AS string
	WSDATA   cCONSULTARPRODRESULT      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSPRTFOR
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20180123 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSPRTFOR
Return

WSMETHOD RESET WSCLIENT WSWSPRTFOR
	::cCXMLENV           := NIL 
	::cCONFIRMAPEDRESULT := NIL 
	::cCONSULTARPRODRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSPRTFOR
Local oClone := WSWSPRTFOR():New()
	oClone:_URL          := ::_URL 
	oClone:cCXMLENV      := ::cCXMLENV
	oClone:cCONFIRMAPEDRESULT := ::cCONFIRMAPEDRESULT
	oClone:cCONSULTARPRODRESULT := ::cCONSULTARPRODRESULT
Return oClone

// WSDL Method CONFIRMAPED of Service WSWSPRTFOR

WSMETHOD CONFIRMAPED WSSEND cCXMLENV WSRECEIVE cCONFIRMAPEDRESULT WSCLIENT WSWSPRTFOR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONFIRMAPED xmlns="http://200.171.223.154:8356/">'
cSoap += WSSoapValue("CXMLENV", ::cCXMLENV, cCXMLENV , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CONFIRMAPED>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://200.171.223.154:8356/CONFIRMAPED",; 
	"DOCUMENT","http://200.171.223.154:8356/",,"1.031217",; 
	"http://200.171.223.154:8356/ws/WSPRTFOR.apw")

::Init()
::cCONFIRMAPEDRESULT :=  WSAdvValue( oXmlRet,"_CONFIRMAPEDRESPONSE:_CONFIRMAPEDRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CONSULTARPROD of Service WSWSPRTFOR

WSMETHOD CONSULTARPROD WSSEND cCXMLENV WSRECEIVE cCONSULTARPRODRESULT WSCLIENT WSWSPRTFOR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONSULTARPROD xmlns="http://200.171.223.154:8356/">'
cSoap += WSSoapValue("CXMLENV", ::cCXMLENV, cCXMLENV , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CONSULTARPROD>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://200.171.223.154:8356/CONSULTARPROD",; 
	"DOCUMENT","http://200.171.223.154:8356/",,"1.031217",; 
	"http://200.171.223.154:8356/ws/WSPRTFOR.apw")

::Init()
::cCONSULTARPRODRESULT :=  WSAdvValue( oXmlRet,"_CONSULTARPRODRESPONSE:_CONSULTARPRODRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



