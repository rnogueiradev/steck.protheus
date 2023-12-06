#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://hom.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?WSDL
Gerado em        06/06/14 11:52:29
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _NRJRKWC ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNFEDOWNNFHML
------------------------------------------------------------------------------- */

WSCLIENT WSNFEDOWNNFHML

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

WSMETHOD NEW WSCLIENT WSNFEDOWNNFHML
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.101202A-20110919] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNFEDOWNNFHML
	::oWS                := NIL 
Return

WSMETHOD RESET WSCLIENT WSNFEDOWNNFHML
	::oWS                := NIL 
	::cversaoDados       := NIL 
	::ccUF               := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNFEDOWNNFHML
Local oClone := WSNFEDOWNNFHML():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cversaoDados  := ::cversaoDados
	oClone:ccUF          := ::ccUF
Return oClone

// WSDL Method nfeDownloadNF of Service WSNFEDOWNNFHML

WSMETHOD nfeDownloadNF  WSSEND BYREF oWS,cversaoDados,ccUF,oWS WSRECEIVE NULLPARAM WSCLIENT WSNFEDOWNNFHML
Local cSoap := " " 
Local oXmlRet
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
	"https://hom.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx")

::Init()
::oWS      :=  WSAdvValue( oXmlRet,"_NFEDOWNLOADNFRESULT","SCHEMA",NIL,NIL,NIL,"O",@oWS,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.