#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?WSDL
Gerado em        06/04/14 14:44:23
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _PFYNGVY ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNfeDownloadNF
------------------------------------------------------------------------------- */

WSCLIENT WSNfeDownloadNF

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeDownloadNF

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWS                       AS SCHEMA
	WSDATA   cversaoDados              AS string
	WSDATA   ccUF                      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfeDownloadNF
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.101202A-20110919] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfeDownloadNF
	::oWS                := NIL 
Return

WSMETHOD RESET WSCLIENT WSNfeDownloadNF
	::oWS                := NIL 
	::cversaoDados       := NIL 
	::ccUF               := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfeDownloadNF
Local oClone := WSNfeDownloadNF():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cversaoDados  := ::cversaoDados
	oClone:ccUF          := ::ccUF
Return oClone

// WSDL Method nfeDownloadNF of Service WSNfeDownloadNF

WSMETHOD nfeDownloadNF WSSEND BYREF oWS,cversaoDados,ccUF,oWS WSRECEIVE NULLPARAM WSCLIENT WSNfeDownloadNF
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF">'
cSoapHead += WSSoapValue("versaoDados", ::cversaoDados, cversaoDados , "string", .F. , .F., 0 , NIL, .F.) 
cSoapHead += WSSoapValue("cUF", ::ccUF, ccUF , "string", .F. , .F., 0 , NIL, .F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoapHead +=  "</nfeCabecMsg>"

cSoap += '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF">'
cSoap += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</nfeDadosMsg>"

oXmlRet := u_xSvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF/nfeDownloadNF",; 
	"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF",cSoapHead,,; 
	"https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx")

::Init()
::oWS                :=  WSAdvValue( oXmlRet,"_NFEDOWNLOADNFRESULT","SCHEMA",NIL,NIL,NIL,"O",@oWS,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.