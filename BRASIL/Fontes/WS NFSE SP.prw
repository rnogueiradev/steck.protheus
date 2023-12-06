#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx?WSDL
Gerado em        05/01/17 23:27:49
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
Alterações neste arquivo podem causar funcionamento incorreto
e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _HZTNLLH ; Return  // "dummy" function - Internal Use
	
	/* -------------------------------------------------------------------------------
	WSDL Service WSLoteNFe
	------------------------------------------------------------------------------- */
	
	WSCLIENT WSLoteNFe
		
		WSMETHOD NEW
		WSMETHOD INIT
		WSMETHOD RESET
		WSMETHOD CLONE
		WSMETHOD EnvioRPS
		WSMETHOD EnvioLoteRPS
		WSMETHOD TesteEnvioLoteRPS
		WSMETHOD CancelamentoNFe
		WSMETHOD ConsultaNFe
		WSMETHOD ConsultaNFeRecebidas
		WSMETHOD ConsultaNFeEmitidas
		WSMETHOD ConsultaLote
		WSMETHOD ConsultaInformacoesLote
		WSMETHOD ConsultaCNPJ
		
		WSDATA   _URL                      AS String
		WSDATA   _CERT                     AS String
		WSDATA   _PRIVKEY                  AS String
		WSDATA   _PASSPHRASE               AS String
		WSDATA   _HEADOUT                  AS Array of String
		WSDATA   _COOKIES                  AS Array of String
		WSDATA   nVersaoSchema             AS int
		WSDATA   cMensagemXML              AS string
		WSDATA   cRetornoXML               AS string
		
	ENDWSCLIENT
	
WSMETHOD NEW WSCLIENT WSLoteNFe
	::Init()
	If !FindFunction("XMLCHILDEX")
		UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20161027] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
	EndIf
Return Self

WSMETHOD INIT WSCLIENT WSLoteNFe
Return

WSMETHOD RESET WSCLIENT WSLoteNFe
	::nVersaoSchema      := NIL
	::cMensagemXML       := NIL
	::cRetornoXML        := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSLoteNFe
	Local oClone := WSLoteNFe():New()
	oClone:_URL          := ::_URL
	oClone:_CERT         := ::_CERT
	oClone:_PRIVKEY      := ::_PRIVKEY
	oClone:_PASSPHRASE   := ::_PASSPHRASE
	oClone:nVersaoSchema := ::nVersaoSchema
	oClone:cMensagemXML  := ::cMensagemXML
	oClone:cRetornoXML   := ::cRetornoXML
Return oClone

// WSDL Method EnvioRPS of Service WSLoteNFe

WSMETHOD EnvioRPS WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<EnvioRPSRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</EnvioRPSRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/envioRPS",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_ENVIORPSRESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method EnvioLoteRPS of Service WSLoteNFe

WSMETHOD EnvioLoteRPS WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<EnvioLoteRPSRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</EnvioLoteRPSRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/envioLoteRPS",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_ENVIOLOTERPSRESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method TesteEnvioLoteRPS of Service WSLoteNFe

WSMETHOD TesteEnvioLoteRPS WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<TesteEnvioLoteRPSRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</TesteEnvioLoteRPSRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/testeenvio",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_TESTEENVIOLOTERPSRESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method CancelamentoNFe of Service WSLoteNFe

WSMETHOD CancelamentoNFe WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<CancelamentoNFeRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</CancelamentoNFeRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/cancelamentoNFe",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_CANCELAMENTONFERESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method ConsultaNFe of Service WSLoteNFe

WSMETHOD ConsultaNFe WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<ConsultaNFeRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</ConsultaNFeRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/consultaNFe",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_CONSULTANFERESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method ConsultaNFeRecebidas of Service WSLoteNFe

WSMETHOD ConsultaNFeRecebidas WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	Local cXmlMsg := ""
	BEGIN WSMETHOD
		
		cSoap += '<ConsultaNFeRecebidasRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cXmlMsg := WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap +=  cXmlMsg
		cSoap += "</ConsultaNFeRecebidasRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/consultaNFeRecebidas",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_CONSULTANFERECEBIDASRESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method ConsultaNFeEmitidas of Service WSLoteNFe

WSMETHOD ConsultaNFeEmitidas WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<ConsultaNFeEmitidasRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</ConsultaNFeEmitidasRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/consultaNFeEmitidas",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_CONSULTANFEEMITIDASRESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method ConsultaLote of Service WSLoteNFe

WSMETHOD ConsultaLote WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<ConsultaLoteRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</ConsultaLoteRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/consultaLote",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_CONSULTALOTERESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method ConsultaInformacoesLote of Service WSLoteNFe

WSMETHOD ConsultaInformacoesLote WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<ConsultaInformacoesLoteRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</ConsultaInformacoesLoteRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/consultaInformacoesLote",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_CONSULTAINFORMACOESLOTERESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method ConsultaCNPJ of Service WSLoteNFe

WSMETHOD ConsultaCNPJ WSSEND nVersaoSchema,cMensagemXML WSRECEIVE cRetornoXML WSCLIENT WSLoteNFe
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
		conout(time())
		cSoap += '<ConsultaCNPJRequest xmlns="http://www.prefeitura.sp.gov.br/nfe">'
		cSoap += WSSoapValue("VersaoSchema", ::nVersaoSchema, nVersaoSchema , "int", .T. , .F., 0 , NIL, .F.)
		cSoap += WSSoapValue("MensagemXML", ::cMensagemXML, cMensagemXML , "string", .F. , .F., 0 , NIL, .F.)
		cSoap += "</ConsultaCNPJRequest>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,;
			"http://www.prefeitura.sp.gov.br/nfe/ws/consultaCNPJ",;
			"DOCUMENT","http://www.prefeitura.sp.gov.br/nfe",,,;
			"https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx")
		conout(time())
		::Init()
		::cRetornoXML        :=  WSAdvValue( oXmlRet,"_CONSULTACNPJRESPONSE:_RETORNOXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.



