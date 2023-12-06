#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    \soap giovani\ws.xml
Gerado em        09/26/18 15:01:34
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _YMNJRVC ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSOccurrenceServiceWS
------------------------------------------------------------------------------- */

WSCLIENT WSOccurrenceServiceWS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD getOccurrences
	WSMETHOD sendTextMessage
	WSMETHOD checkTextMessageStatus
	WSMETHOD sendCommand
	WSMETHOD checkCommandStatus

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSrequest                AS OccurrenceServiceWS_OccurrenceRequest
	WSDATA   coccurrences              AS string
	WSDATA   nmessageID                AS unsignedLong
	WSDATA   oWSstatus                 AS OccurrenceServiceWS_status_type
	WSDATA   ncommandID                AS unsignedLong

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSOccurrenceServiceWS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20180425 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSOccurrenceServiceWS
	::oWSrequest         := OccurrenceServiceWS_OCCURRENCEREQUEST():New()
	::oWSstatus          := OccurrenceServiceWS_STATUS_TYPE():New()
Return

WSMETHOD RESET WSCLIENT WSOccurrenceServiceWS
	::oWSrequest         := NIL 
	::coccurrences       := NIL 
	::nmessageID         := NIL 
	::oWSstatus          := NIL 
	::ncommandID         := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSOccurrenceServiceWS
Local oClone := WSOccurrenceServiceWS():New()
	oClone:_URL          := ::_URL 
	oClone:oWSrequest    :=  IIF(::oWSrequest = NIL , NIL ,::oWSrequest:Clone() )
	oClone:coccurrences  := ::coccurrences
	oClone:nmessageID    := ::nmessageID
	oClone:oWSstatus     :=  IIF(::oWSstatus = NIL , NIL ,::oWSstatus:Clone() )
	oClone:ncommandID    := ::ncommandID
Return oClone

// WSDL Method getOccurrences of Service WSOccurrenceServiceWS

WSMETHOD getOccurrences WSSEND oWSrequest WSRECEIVE coccurrences WSCLIENT WSOccurrenceServiceWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<getOccurrences xmlns="http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl">'
cSoap += WSSoapValue("request", ::oWSrequest, oWSrequest , "OccurrenceRequest", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</getOccurrences>"

oXmlRet := u_qSvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl",,,; 
	"http://mensageria-integracao.positronrt.com.br:12353")

::Init()
//::coccurrences       :=  WSAdvValue( oXmlRet,"_PST_OCCURRENCERESPONSE:_OCCURRENCES:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
::coccurrences       :=   oXmlRet:_PST_OCCURRENCERESPONSE:_OCCURRENCES

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method sendTextMessage of Service WSOccurrenceServiceWS

WSMETHOD sendTextMessage WSSEND oWSrequest WSRECEIVE nmessageID WSCLIENT WSOccurrenceServiceWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<sendTextMessage xmlns="http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl">'
cSoap += WSSoapValue("request", ::oWSrequest, oWSrequest , "TextMessageRequest", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</sendTextMessage>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl",,,; 
	"http://mensageria-integracao.positronrt.com.br:12353")

::Init()
::nmessageID         :=  WSAdvValue( oXmlRet,"_TEXTMESSAGERESPONSE:_MESSAGEID:TEXT","unsignedLong",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method checkTextMessageStatus of Service WSOccurrenceServiceWS

WSMETHOD checkTextMessageStatus WSSEND oWSrequest WSRECEIVE oWSstatus WSCLIENT WSOccurrenceServiceWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<checkTextMessageStatus xmlns="http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl">'
cSoap += WSSoapValue("request", ::oWSrequest, oWSrequest , "TextMessageStatusRequest", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</checkTextMessageStatus>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl",,,; 
	"http://mensageria-integracao.positronrt.com.br:12353")

::Init()
::oWSstatus:SoapRecv( WSAdvValue( oXmlRet,"_TEXTMESSAGESTATUSRESPONSE:_STATUS","status-type",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method sendCommand of Service WSOccurrenceServiceWS

WSMETHOD sendCommand WSSEND oWSrequest WSRECEIVE ncommandID WSCLIENT WSOccurrenceServiceWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<sendCommand xmlns="http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl">'
cSoap += WSSoapValue("request", ::oWSrequest, oWSrequest , "CommandRequest", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</sendCommand>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl",,,; 
	"http://mensageria-integracao.positronrt.com.br:12353")

::Init()
::ncommandID         :=  WSAdvValue( oXmlRet,"_COMMANDRESPONSE:_COMMANDID:TEXT","unsignedLong",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method checkCommandStatus of Service WSOccurrenceServiceWS

WSMETHOD checkCommandStatus WSSEND oWSrequest WSRECEIVE oWSstatus WSCLIENT WSOccurrenceServiceWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<checkCommandStatus xmlns="http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl">'
cSoap += WSSoapValue("request", ::oWSrequest, oWSrequest , "CommandStatusRequest", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</checkCommandStatus>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://pst.com.br/position.xsd/OccurrenceServiceWS.wsdl",,,; 
	"http://mensageria-integracao.positronrt.com.br:12353")

::Init()
::oWSstatus:SoapRecv( WSAdvValue( oXmlRet,"_COMMANDSTATUSRESPONSE:_STATUS","status-type",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure OccurrenceRequest

WSSTRUCT OccurrenceServiceWS_OccurrenceRequest
	WSDATA   cusername                 AS string
	WSDATA   cpassword                 AS string
	WSDATA   cqueuename                AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OccurrenceServiceWS_OccurrenceRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OccurrenceServiceWS_OccurrenceRequest
Return

WSMETHOD CLONE WSCLIENT OccurrenceServiceWS_OccurrenceRequest
	Local oClone := OccurrenceServiceWS_OccurrenceRequest():NEW()
	oClone:cusername            := ::cusername
	oClone:cpassword            := ::cpassword
	oClone:cqueuename           := ::cqueuename
Return oClone

WSMETHOD SOAPSEND WSCLIENT OccurrenceServiceWS_OccurrenceRequest
	Local cSoap := ""
	cSoap += WSSoapValue("username", ::cusername, ::cusername , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("password", ::cpassword, ::cpassword , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("queuename", ::cqueuename, ::cqueuename , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Enumeration status-type

WSSTRUCT OccurrenceServiceWS_status_type
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OccurrenceServiceWS_status_type
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "STATUS-TYPE-SENDING" )
	aadd(::aValueList , "STATUS-TYPE-SENT" )
	aadd(::aValueList , "STATUS-TYPE-CANCELED" )
	aadd(::aValueList , "STATUS-TYPE-TIMEOUT" )
	aadd(::aValueList , "STATUS-TYPE-ERROR" )
	aadd(::aValueList , "STATUS-TYPE-INVALID" )
Return Self

WSMETHOD SOAPSEND WSCLIENT OccurrenceServiceWS_status_type
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OccurrenceServiceWS_status_type
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT OccurrenceServiceWS_status_type
Local oClone := OccurrenceServiceWS_status_type():New()
	oClone:Value := ::Value
Return oClone


