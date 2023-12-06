#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx?WSDL
Gerado em        06/07/17 15:36:09
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
Alterações neste arquivo podem causar funcionamento incorreto
e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _FZUSLPM ; Return  // "dummy" function - Internal Use
	
	/* -------------------------------------------------------------------------------
	WSDL Service WSNFeDistribuicaoDFe
	------------------------------------------------------------------------------- */
	
	WSCLIENT WSNFeDistribuicaoDFe
		
		WSMETHOD NEW
		WSMETHOD INIT
		WSMETHOD RESET
		WSMETHOD CLONE
		WSMETHOD nfeDistDFeInteresse
		
		WSDATA   _URL                      AS String
		WSDATA   _CERT                     AS String
		WSDATA   _PRIVKEY                  AS String
		WSDATA   _PASSPHRASE               AS String
		WSDATA   _HEADOUT                  AS Array of String
		WSDATA   _COOKIES                  AS Array of String
		WSDATA   oWSnfeDadosMsg            AS SCHEMA
		WSDATA   oWSnfeDistDFeInteresseResult AS SCHEMA
		
	ENDWSCLIENT
	
WSMETHOD NEW WSCLIENT WSNFeDistribuicaoDFe
	::Init()
	If !FindFunction("XMLCHILDEX")
		UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20161027] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
	EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNFeDistribuicaoDFe
	::oWSnfeDadosMsg     := NIL
	::oWSnfeDistDFeInteresseResult := NIL
Return

WSMETHOD RESET WSCLIENT WSNFeDistribuicaoDFe
	::oWSnfeDadosMsg     := NIL
	::oWSnfeDistDFeInteresseResult := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNFeDistribuicaoDFe
	Local oClone := WSNFeDistribuicaoDFe():New()
	oClone:_URL          := ::_URL
	oClone:_CERT         := ::_CERT
	oClone:_PRIVKEY      := ::_PRIVKEY
	oClone:_PASSPHRASE   := ::_PASSPHRASE
Return oClone

// WSDL Method nfeDistDFeInteresse of Service WSNFeDistribuicaoDFe

WSMETHOD nfeDistDFeInteresse WSSEND oWSnfeDadosMsg WSRECEIVE oWSnfeDistDFeInteresseResult WSCLIENT WSNFeDistribuicaoDFe
	Local cSoap := "" , oXmlRet
	Local cSoapHd := ""
	BEGIN WSMETHOD
		
		cSoapHd := '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe">'
		cSoapHd += '<cUF>91</cUF>'
		cSoapHd += '<versaoDados>1.00</versaoDados>'
		cSoapHd += '</nfeCabecMsg>'
		
		cSoap += '<nfeDistDFeInteresse xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe">'
		cSoap += WSSoapValue("nfeDadosMsg", ::oWSnfeDadosMsg, oWSnfeDadosMsg , "SCHEMA", .F. , .F., 0 , NIL, .F.)
		cSoap += "</nfeDistDFeInteresse>"
		
		oXmlRet :=  SvcSoapCall(Self,cSoap,;
			"http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe/nfeDistDFeInteresse",;
			"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe",;
			cSoapHd,;
			,;
			"https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx")
		
		::Init()
		::oWSnfeDistDFeInteresseResult :=  WSAdvValue( oXmlRet,"_NFEDISTDFEINTERESSERESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.



