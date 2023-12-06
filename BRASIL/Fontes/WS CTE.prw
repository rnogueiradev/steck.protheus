#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://www1.cte.fazenda.gov.br/CTeDistribuicaoDFe/CTeDistribuicaoDFe.asmx?wsdl
Gerado em        05/16/17 13:32:04
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
Alterações neste arquivo podem causar funcionamento incorreto
e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _EUIKVWS ; Return  // "dummy" function - Internal Use
	
	/* -------------------------------------------------------------------------------
	WSDL Service WSCTeDistribuicaoDFe
	------------------------------------------------------------------------------- */
	
	WSCLIENT WSCTeDistribuicaoDFe
		
		WSMETHOD NEW
		WSMETHOD INIT
		WSMETHOD RESET
		WSMETHOD CLONE
		WSMETHOD cteDistDFeInteresse
		
		WSDATA   _URL                      AS String
		WSDATA   _CERT                     AS String
		WSDATA   _PRIVKEY                  AS String
		WSDATA   _PASSPHRASE               AS String
		WSDATA   _HEADOUT                  AS Array of String
		WSDATA   _COOKIES                  AS Array of String
		WSDATA   oWScteDadosMsg            AS SCHEMA
		WSDATA   oWScteDistDFeInteresseResult AS SCHEMA
		
	ENDWSCLIENT
	
WSMETHOD NEW WSCLIENT WSCTeDistribuicaoDFe
	::Init()
	If !FindFunction("XMLCHILDEX")
		UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20161027] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
	EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCTeDistribuicaoDFe
	::oWScteDadosMsg     := NIL
	::oWScteDistDFeInteresseResult := NIL
Return

WSMETHOD RESET WSCLIENT WSCTeDistribuicaoDFe
	::oWScteDadosMsg     := NIL
	::oWScteDistDFeInteresseResult := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCTeDistribuicaoDFe
	Local oClone := WSCTeDistribuicaoDFe():New()
	oClone:_URL          := ::_URL
	oClone:_CERT         := ::_CERT
	oClone:_PRIVKEY      := ::_PRIVKEY
	oClone:_PASSPHRASE   := ::_PASSPHRASE
Return oClone

// WSDL Method cteDistDFeInteresse of Service WSCTeDistribuicaoDFe

WSMETHOD cteDistDFeInteresse WSSEND oWScteDadosMsg WSRECEIVE oWScteDistDFeInteresseResult WSCLIENT WSCTeDistribuicaoDFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<cteDistDFeInteresse xmlns="http://www.portalfiscal.inf.br/cte/wsdl/CTeDistribuicaoDFe">'
		cSoap += WSSoapValue("cteDadosMsg", ::oWScteDadosMsg, oWScteDadosMsg , "SCHEMA", .F. , .F., 0 , NIL, .F.)
		cSoap += "</cteDistDFeInteresse>"
		
		oXmlRet := u_xSvcSoapCall(	Self,cSoap,;
			"http://www.portalfiscal.inf.br/cte/wsdl/CTeDistribuicaoDFe/cteDistDFeInteresse",;
			"DOCUMENT","http://www.portalfiscal.inf.br/cte/wsdl/CTeDistribuicaoDFe",,,;
			"https://www1.cte.fazenda.gov.br/CTeDistribuicaoDFe/CTeDistribuicaoDFe.asmx")
		
		::Init()
		::oWScteDistDFeInteresseResult :=  WSAdvValue( oXmlRet,"_CTEDISTDFEINTERESSERESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.



