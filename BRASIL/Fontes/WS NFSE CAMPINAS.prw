#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws?wsdl
Gerado em        05/12/17 10:08:01
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
Alterações neste arquivo podem causar funcionamento incorreto
e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _LVWOHMD ; Return  // "dummy" function - Internal Use
	
	/* -------------------------------------------------------------------------------
	WSDL Service WSLoteRpsService
	------------------------------------------------------------------------------- */
	
	WSCLIENT WSLoteRpsService
		
		WSMETHOD NEW
		WSMETHOD INIT
		WSMETHOD RESET
		WSMETHOD CLONE
		WSMETHOD consultarSequencialRps
		WSMETHOD enviarSincrono
		WSMETHOD testeEnviar
		WSMETHOD enviar
		WSMETHOD consultarLote
		WSMETHOD consultarNota
		WSMETHOD cancelar
		WSMETHOD consultarNFSeRps
		
		WSDATA   _URL                      AS String
		WSDATA   _HEADOUT                  AS Array of String
		WSDATA   _COOKIES                  AS Array of String
		WSDATA   cmensagemXml              AS string
		WSDATA   cconsultarSequencialRpsReturn AS string
		WSDATA   cenviarSincronoReturn     AS string
		WSDATA   ctesteEnviarReturn        AS string
		WSDATA   cenviarReturn             AS string
		WSDATA   cconsultarLoteReturn      AS string
		WSDATA   cconsultarNotaReturn      AS string
		WSDATA   ccancelarReturn           AS string
		WSDATA   cconsultarNFSeRpsReturn   AS string
		
	ENDWSCLIENT
	
WSMETHOD NEW WSCLIENT WSLoteRpsService
	::Init()
	If !FindFunction("XMLCHILDEX")
		UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20161027] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
	EndIf
Return Self

WSMETHOD INIT WSCLIENT WSLoteRpsService
Return

WSMETHOD RESET WSCLIENT WSLoteRpsService
	::cmensagemXml       := NIL
	::cconsultarSequencialRpsReturn := NIL
	::cenviarSincronoReturn := NIL
	::ctesteEnviarReturn := NIL
	::cenviarReturn      := NIL
	::cconsultarLoteReturn := NIL
	::cconsultarNotaReturn := NIL
	::ccancelarReturn    := NIL
	::cconsultarNFSeRpsReturn := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSLoteRpsService
	Local oClone := WSLoteRpsService():New()
	oClone:_URL          := ::_URL
	oClone:cmensagemXml  := ::cmensagemXml
	oClone:cconsultarSequencialRpsReturn := ::cconsultarSequencialRpsReturn
	oClone:cenviarSincronoReturn := ::cenviarSincronoReturn
	oClone:ctesteEnviarReturn := ::ctesteEnviarReturn
	oClone:cenviarReturn := ::cenviarReturn
	oClone:cconsultarLoteReturn := ::cconsultarLoteReturn
	oClone:cconsultarNotaReturn := ::cconsultarNotaReturn
	oClone:ccancelarReturn := ::ccancelarReturn
	oClone:cconsultarNFSeRpsReturn := ::cconsultarNFSeRpsReturn
Return oClone

// WSDL Method consultarSequencialRps of Service WSLoteRpsService

WSMETHOD consultarSequencialRps WSSEND cmensagemXml WSRECEIVE cconsultarSequencialRpsReturn WSCLIENT WSLoteRpsService
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<q1:consultarSequencialRps xmlns:q1="http://www.w3.org/2001/XMLSchema">'
		cSoap += WSSoapValue("mensagemXml", ::cmensagemXml, cmensagemXml , "string", .T. , .T. , 0 , NIL, .F.)
		cSoap += "</q1:consultarSequencialRps>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"",;
			"RPCX","http://nfse.campinas.sp.gov.br/WsNFe2/LoteRps.jws",,,;
			"http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws")
		
		::Init()
		::cconsultarSequencialRpsReturn :=  WSAdvValue( oXmlRet,"_CONSULTARSEQUENCIALRPSRETURN","string",NIL,NIL,NIL,"S",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method enviarSincrono of Service WSLoteRpsService

WSMETHOD enviarSincrono WSSEND cmensagemXml WSRECEIVE cenviarSincronoReturn WSCLIENT WSLoteRpsService
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<q1:enviarSincrono xmlns:q1="http://www.w3.org/2001/XMLSchema">'
		cSoap += WSSoapValue("mensagemXml", ::cmensagemXml, cmensagemXml , "string", .T. , .T. , 0 , NIL, .F.)
		cSoap += "</q1:enviarSincrono>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"",;
			"RPCX","http://nfse.campinas.sp.gov.br/WsNFe2/LoteRps.jws",,,;
			"http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws")
		
		::Init()
		::cenviarSincronoReturn :=  WSAdvValue( oXmlRet,"_ENVIARSINCRONORETURN","string",NIL,NIL,NIL,"S",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method testeEnviar of Service WSLoteRpsService

WSMETHOD testeEnviar WSSEND cmensagemXml WSRECEIVE ctesteEnviarReturn WSCLIENT WSLoteRpsService
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<q1:testeEnviar xmlns:q1="http://www.w3.org/2001/XMLSchema">'
		cSoap += WSSoapValue("mensagemXml", ::cmensagemXml, cmensagemXml , "string", .T. , .T. , 0 , NIL, .F.)
		cSoap += "</q1:testeEnviar>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"",;
			"RPCX","http://nfse.campinas.sp.gov.br/WsNFe2/LoteRps.jws",,,;
			"http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws")
		
		::Init()
		::ctesteEnviarReturn :=  WSAdvValue( oXmlRet,"_TESTEENVIARRETURN","string",NIL,NIL,NIL,"S",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method enviar of Service WSLoteRpsService

WSMETHOD enviar WSSEND cmensagemXml WSRECEIVE cenviarReturn WSCLIENT WSLoteRpsService
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<q1:enviar xmlns:q1="http://www.w3.org/2001/XMLSchema">'
		cSoap += WSSoapValue("mensagemXml", ::cmensagemXml, cmensagemXml , "string", .T. , .T. , 0 , NIL, .F.)
		cSoap += "</q1:enviar>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"",;
			"RPCX","http://nfse.campinas.sp.gov.br/WsNFe2/LoteRps.jws",,,;
			"http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws")
		
		::Init()
		::cenviarReturn      :=  WSAdvValue( oXmlRet,"_ENVIARRETURN","string",NIL,NIL,NIL,"S",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method consultarLote of Service WSLoteRpsService

WSMETHOD consultarLote WSSEND cmensagemXml WSRECEIVE cconsultarLoteReturn WSCLIENT WSLoteRpsService
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<q1:consultarLote xmlns:q1="http://www.w3.org/2001/XMLSchema">'
		cSoap += WSSoapValue("mensagemXml", ::cmensagemXml, cmensagemXml , "string", .T. , .T. , 0 , NIL, .F.)
		cSoap += "</q1:consultarLote>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"",;
			"RPCX","http://nfse.campinas.sp.gov.br/WsNFe2/LoteRps.jws",,,;
			"http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws")
		
		::Init()
		::cconsultarLoteReturn :=  WSAdvValue( oXmlRet,"_CONSULTARLOTERETURN","string",NIL,NIL,NIL,"S",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method consultarNota of Service WSLoteRpsService

WSMETHOD consultarNota WSSEND cmensagemXml WSRECEIVE cconsultarNotaReturn WSCLIENT WSLoteRpsService
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<q1:consultarNota xmlns:q1="http://www.w3.org/2001/XMLSchema">'
		cSoap += WSSoapValue("mensagemXml", ::cmensagemXml, cmensagemXml , "string", .T. , .T. , 0 , NIL, .F.)
		cSoap += "</q1:consultarNota>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"",;
			"RPCX","http://nfse.campinas.sp.gov.br/WsNFe2/LoteRps.jws",,,;
			"http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws")
		
		::Init()
		::cconsultarNotaReturn :=  WSAdvValue( oXmlRet,"_CONSULTARNOTARETURN","string",NIL,NIL,NIL,"S",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method cancelar of Service WSLoteRpsService

WSMETHOD cancelar WSSEND cmensagemXml WSRECEIVE ccancelarReturn WSCLIENT WSLoteRpsService
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<q1:cancelar xmlns:q1="http://www.w3.org/2001/XMLSchema">'
		cSoap += WSSoapValue("mensagemXml", ::cmensagemXml, cmensagemXml , "string", .T. , .T. , 0 , NIL, .F.)
		cSoap += "</q1:cancelar>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"",;
			"RPCX","http://nfse.campinas.sp.gov.br/WsNFe2/LoteRps.jws",,,;
			"http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws")
		
		::Init()
		::ccancelarReturn    :=  WSAdvValue( oXmlRet,"_CANCELARRETURN","string",NIL,NIL,NIL,"S",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method consultarNFSeRps of Service WSLoteRpsService

WSMETHOD consultarNFSeRps WSSEND cmensagemXml WSRECEIVE cconsultarNFSeRpsReturn WSCLIENT WSLoteRpsService
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<q1:consultarNFSeRps xmlns:q1="http://www.w3.org/2001/XMLSchema">'
		cSoap += WSSoapValue("mensagemXml", ::cmensagemXml, cmensagemXml , "string", .T. , .T. , 0 , NIL, .F.)
		cSoap += "</q1:consultarNFSeRps>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"",;
			"RPCX","http://nfse.campinas.sp.gov.br/WsNFe2/LoteRps.jws",,,;
			"http://issdigital.campinas.sp.gov.br/WsNFe2/LoteRps.jws")
		
		::Init()
		::cconsultarNFSeRpsReturn :=  WSAdvValue( oXmlRet,"_CONSULTARNFSERPSRETURN","string",NIL,NIL,NIL,"S",NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.



