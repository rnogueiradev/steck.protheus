#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://hom.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx?WSDL
Gerado em        06/06/14 11:59:13
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _SVFOFDV ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNFeConsultaDHml
------------------------------------------------------------------------------- */

WSCLIENT WSNFeConsultaDHml

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeConsultaNFDest

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWS                       AS SCHEMA
	WSDATA   ccUF                      AS string
	WSDATA   cversaoDados              AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNFeConsultaDHml
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.101202A-20110919] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNFeConsultaDHml
	::oWS                := NIL 
Return

WSMETHOD RESET WSCLIENT WSNFeConsultaDHml
	::oWS                := NIL 
	::ccUF               := NIL 
	::cversaoDados       := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNFeConsultaDHml
Local oClone := WSNFeConsultaDHml():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:ccUF          := ::ccUF
	oClone:cversaoDados  := ::cversaoDados
Return oClone

// WSDL Method nfeConsultaNFDest of Service WSNFeConsultaDHml

WSMETHOD nfeConsultaNFDest WSSEND BYREF oWS,ccUF,cversaoDados,oWS WSRECEIVE NULLPARAM WSCLIENT WSNFeConsultaDHml
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest">'
cSoapHead += WSSoapValue("cUF", ::ccUF, ccUF , "string", .F. , .F., 0 , NIL, .F.) 
cSoapHead += WSSoapValue("versaoDados", ::cversaoDados, cversaoDados , "string", .F. , .F., 0 , NIL, .F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoapHead +=  "</nfeCabecMsg>"

cSoap += '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest">'
cSoap += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</nfeDadosMsg>"

oXmlRet := u_xSvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest",; 
	"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest",cSoapHead,,; 
	"https://hom.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx")

::Init()
::oWS                :=  WSAdvValue( oXmlRet,"_NFECONSULTANFDESTRESULT","SCHEMA",NIL,NIL,NIL,"O",@oWS,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.