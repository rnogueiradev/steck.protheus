#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://187.50.7.74:90/WSRETCOT.apw?WSDL
Gerado em        03/15/16 12:04:56
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PUTCLKB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSRETCOT
------------------------------------------------------------------------------- */

WSCLIENT WSWSRETCOT

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD RETCOT
	WSMETHOD UPDCOT

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   c_CLOGIN                  AS string
	WSDATA   c_CPASSWORD               AS string
	WSDATA   oWSRETCOTRESULT           AS WSRETCOT_ARRAYOFCOTACOES
	WSDATA   oWSCOTACOES               AS WSRETCOT_COTESTRU
	WSDATA   lUPDCOTRESULT             AS boolean

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSCOTESTRU               AS WSRETCOT_COTESTRU

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSRETCOT
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150908] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSRETCOT
	::oWSRETCOTRESULT    := WSRETCOT_ARRAYOFCOTACOES():New()
	::oWSCOTACOES        := WSRETCOT_COTESTRU():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSCOTESTRU        := ::oWSCOTACOES
Return

WSMETHOD RESET WSCLIENT WSWSRETCOT
	::c_CLOGIN           := NIL 
	::c_CPASSWORD        := NIL 
	::oWSRETCOTRESULT    := NIL 
	::oWSCOTACOES        := NIL 
	::lUPDCOTRESULT      := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSCOTESTRU        := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSRETCOT
Local oClone := WSWSRETCOT():New()
	oClone:_URL          := ::_URL 
	oClone:c_CLOGIN      := ::c_CLOGIN
	oClone:c_CPASSWORD   := ::c_CPASSWORD
	oClone:oWSRETCOTRESULT :=  IIF(::oWSRETCOTRESULT = NIL , NIL ,::oWSRETCOTRESULT:Clone() )
	oClone:oWSCOTACOES   :=  IIF(::oWSCOTACOES = NIL , NIL ,::oWSCOTACOES:Clone() )
	oClone:lUPDCOTRESULT := ::lUPDCOTRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSCOTESTRU   := oClone:oWSCOTACOES
Return oClone

// WSDL Method RETCOT of Service WSWSRETCOT

WSMETHOD RETCOT WSSEND c_CLOGIN,c_CPASSWORD WSRECEIVE oWSRETCOTRESULT WSCLIENT WSWSRETCOT
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RETCOT xmlns="http://187.50.7.74:90/">'
cSoap += WSSoapValue("_CLOGIN", ::c_CLOGIN, c_CLOGIN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("_CPASSWORD", ::c_CPASSWORD, c_CPASSWORD , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</RETCOT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://187.50.7.74:90/RETCOT",; 
	"DOCUMENT","http://187.50.7.74:90/",,"1.031217",; 
	"http://187.50.7.74:90/WSRETCOT.apw")

::Init()
::oWSRETCOTRESULT:SoapRecv( WSAdvValue( oXmlRet,"_RETCOTRESPONSE:_RETCOTRESULT","ARRAYOFCOTACOES",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UPDCOT of Service WSWSRETCOT

WSMETHOD UPDCOT WSSEND oWSCOTACOES,c_CLOGIN,c_CPASSWORD WSRECEIVE lUPDCOTRESULT WSCLIENT WSWSRETCOT
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UPDCOT xmlns="http://187.50.7.74:90/">'
cSoap += WSSoapValue("COTACOES", ::oWSCOTACOES, oWSCOTACOES , "COTESTRU", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("_CLOGIN", ::c_CLOGIN, c_CLOGIN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("_CPASSWORD", ::c_CPASSWORD, c_CPASSWORD , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</UPDCOT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://187.50.7.74:90/UPDCOT",; 
	"DOCUMENT","http://187.50.7.74:90/",,"1.031217",; 
	"http://187.50.7.74:90/WSRETCOT.apw")

::Init()
::lUPDCOTRESULT      :=  WSAdvValue( oXmlRet,"_UPDCOTRESPONSE:_UPDCOTRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ARRAYOFCOTACOES

WSSTRUCT WSRETCOT_ARRAYOFCOTACOES
	WSDATA   oWSCOTACOES               AS WSRETCOT_COTACOES OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSRETCOT_ARRAYOFCOTACOES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSRETCOT_ARRAYOFCOTACOES
	::oWSCOTACOES          := {} // Array Of  WSRETCOT_COTACOES():New()
Return

WSMETHOD CLONE WSCLIENT WSRETCOT_ARRAYOFCOTACOES
	Local oClone := WSRETCOT_ARRAYOFCOTACOES():NEW()
	oClone:oWSCOTACOES := NIL
	If ::oWSCOTACOES <> NIL 
		oClone:oWSCOTACOES := {}
		aEval( ::oWSCOTACOES , { |x| aadd( oClone:oWSCOTACOES , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSRETCOT_ARRAYOFCOTACOES
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACOES","COTACOES",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCOTACOES , WSRETCOT_COTACOES():New() )
			::oWSCOTACOES[len(::oWSCOTACOES)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure COTESTRU

WSSTRUCT WSRETCOT_COTESTRU
	WSDATA   oWSARETCOT                AS WSRETCOT_ARRAYOFCOTS
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSRETCOT_COTESTRU
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSRETCOT_COTESTRU
Return

WSMETHOD CLONE WSCLIENT WSRETCOT_COTESTRU
	Local oClone := WSRETCOT_COTESTRU():NEW()
	oClone:oWSARETCOT           := IIF(::oWSARETCOT = NIL , NIL , ::oWSARETCOT:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSRETCOT_COTESTRU
	Local cSoap := ""
	cSoap += WSSoapValue("ARETCOT", ::oWSARETCOT, ::oWSARETCOT , "ARRAYOFCOTS", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure COTACOES

WSSTRUCT WSRETCOT_COTACOES
	WSDATA   cCCOT                     AS string
	WSDATA   cCDESC                    AS string
	WSDATA   cCEMP                     AS string
	WSDATA   cCFIL                     AS string
	WSDATA   cCFORN                    AS string
	WSDATA   cCITEM                    AS string
	WSDATA   cCOBS1                    AS string
	WSDATA   cCOBS2                    AS string
	WSDATA   cCPROD                    AS string
	WSDATA   nNPRECO                   AS float
	WSDATA   nNQUANT                   AS float
	WSDATA   nNREGISTRO                AS float
	WSDATA   nNTOTAL                   AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSRETCOT_COTACOES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSRETCOT_COTACOES
Return

WSMETHOD CLONE WSCLIENT WSRETCOT_COTACOES
	Local oClone := WSRETCOT_COTACOES():NEW()
	oClone:cCCOT                := ::cCCOT
	oClone:cCDESC               := ::cCDESC
	oClone:cCEMP                := ::cCEMP
	oClone:cCFIL                := ::cCFIL
	oClone:cCFORN               := ::cCFORN
	oClone:cCITEM               := ::cCITEM
	oClone:cCOBS1               := ::cCOBS1
	oClone:cCOBS2               := ::cCOBS2
	oClone:cCPROD               := ::cCPROD
	oClone:nNPRECO              := ::nNPRECO
	oClone:nNQUANT              := ::nNQUANT
	oClone:nNREGISTRO           := ::nNREGISTRO
	oClone:nNTOTAL              := ::nNTOTAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSRETCOT_COTACOES
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCOT              :=  WSAdvValue( oResponse,"_CCOT","string",NIL,"Property cCCOT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDESC             :=  WSAdvValue( oResponse,"_CDESC","string",NIL,"Property cCDESC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCEMP              :=  WSAdvValue( oResponse,"_CEMP","string",NIL,"Property cCEMP as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFIL              :=  WSAdvValue( oResponse,"_CFIL","string",NIL,"Property cCFIL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFORN             :=  WSAdvValue( oResponse,"_CFORN","string",NIL,"Property cCFORN as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCITEM             :=  WSAdvValue( oResponse,"_CITEM","string",NIL,"Property cCITEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBS1             :=  WSAdvValue( oResponse,"_COBS1","string",NIL,"Property cCOBS1 as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBS2             :=  WSAdvValue( oResponse,"_COBS2","string",NIL,"Property cCOBS2 as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCPROD             :=  WSAdvValue( oResponse,"_CPROD","string",NIL,"Property cCPROD as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nNPRECO            :=  WSAdvValue( oResponse,"_NPRECO","float",NIL,"Property nNPRECO as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNQUANT            :=  WSAdvValue( oResponse,"_NQUANT","float",NIL,"Property nNQUANT as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNREGISTRO         :=  WSAdvValue( oResponse,"_NREGISTRO","float",NIL,"Property nNREGISTRO as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNTOTAL            :=  WSAdvValue( oResponse,"_NTOTAL","float",NIL,"Property nNTOTAL as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFCOTS

WSSTRUCT WSRETCOT_ARRAYOFCOTS
	WSDATA   oWSCOTS                   AS WSRETCOT_COTS OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSRETCOT_ARRAYOFCOTS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSRETCOT_ARRAYOFCOTS
	::oWSCOTS              := {} // Array Of  WSRETCOT_COTS():New()
Return

WSMETHOD CLONE WSCLIENT WSRETCOT_ARRAYOFCOTS
	Local oClone := WSRETCOT_ARRAYOFCOTS():NEW()
	oClone:oWSCOTS := NIL
	If ::oWSCOTS <> NIL 
		oClone:oWSCOTS := {}
		aEval( ::oWSCOTS , { |x| aadd( oClone:oWSCOTS , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSRETCOT_ARRAYOFCOTS
	Local cSoap := ""
	aEval( ::oWSCOTS , {|x| cSoap := cSoap  +  WSSoapValue("COTS", x , x , "COTS", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

// WSDL Data Structure COTS

WSSTRUCT WSRETCOT_COTS
	WSDATA   cCEMP                     AS string
	WSDATA   cCOBS2                    AS string
	WSDATA   cCSTATUS                  AS string
	WSDATA   nNREGISTRO                AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSRETCOT_COTS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSRETCOT_COTS
Return

WSMETHOD CLONE WSCLIENT WSRETCOT_COTS
	Local oClone := WSRETCOT_COTS():NEW()
	oClone:cCEMP                := ::cCEMP
	oClone:cCOBS2               := ::cCOBS2
	oClone:cCSTATUS             := ::cCSTATUS
	oClone:nNREGISTRO           := ::nNREGISTRO
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSRETCOT_COTS
	Local cSoap := ""
	cSoap += WSSoapValue("CEMP", ::cCEMP, ::cCEMP , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("COBS2", ::cCOBS2, ::cCOBS2 , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CSTATUS", ::cCSTATUS, ::cCSTATUS , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("NREGISTRO", ::nNREGISTRO, ::nNREGISTRO , "float", .T. , .F., 0 , NIL, .F.) 
Return cSoap


