#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://200.171.223.154:99/WSPEDIDOPORTAL.apw?WSDL
Gerado em        07/30/18 10:22:46
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _SWLSUOP ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSPEDIDOPORTAL
------------------------------------------------------------------------------- */

WSCLIENT WSWSPEDIDOPORTAL

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD RETPEDEXP
	WSMETHOD RETPEDIDO

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCXMLREC                  AS string
	WSDATA   cRETPEDEXPRESULT          AS string
	WSDATA   oWSPEDIDO                 AS WSPEDIDOPORTAL_ESTRUTURA
	WSDATA   lRETPEDIDORESULT          AS boolean

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSESTRUTURA              AS WSPEDIDOPORTAL_ESTRUTURA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSPEDIDOPORTAL
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20180425 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSPEDIDOPORTAL
	::oWSPEDIDO          := WSPEDIDOPORTAL_ESTRUTURA():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSESTRUTURA       := ::oWSPEDIDO
Return

WSMETHOD RESET WSCLIENT WSWSPEDIDOPORTAL
	::cCXMLREC           := NIL 
	::cRETPEDEXPRESULT   := NIL 
	::oWSPEDIDO          := NIL 
	::lRETPEDIDORESULT   := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSESTRUTURA       := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSPEDIDOPORTAL
Local oClone := WSWSPEDIDOPORTAL():New()
	oClone:_URL          := ::_URL 
	oClone:cCXMLREC      := ::cCXMLREC
	oClone:cRETPEDEXPRESULT := ::cRETPEDEXPRESULT
	oClone:oWSPEDIDO     :=  IIF(::oWSPEDIDO = NIL , NIL ,::oWSPEDIDO:Clone() )
	oClone:lRETPEDIDORESULT := ::lRETPEDIDORESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSESTRUTURA  := oClone:oWSPEDIDO
Return oClone

// WSDL Method RETPEDEXP of Service WSWSPEDIDOPORTAL

WSMETHOD RETPEDEXP WSSEND cCXMLREC WSRECEIVE cRETPEDEXPRESULT WSCLIENT WSWSPEDIDOPORTAL
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RETPEDEXP xmlns="http://200.171.223.154:99/">'
cSoap += WSSoapValue("CXMLREC", ::cCXMLREC, cCXMLREC , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RETPEDEXP>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://200.171.223.154:99/RETPEDEXP",; 
	"DOCUMENT","http://200.171.223.154:99/",,"1.031217",; 
	"http://200.171.223.154:99/WSPEDIDOPORTAL.apw")

::Init()
::cRETPEDEXPRESULT   :=  WSAdvValue( oXmlRet,"_RETPEDEXPRESPONSE:_RETPEDEXPRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RETPEDIDO of Service WSWSPEDIDOPORTAL

WSMETHOD RETPEDIDO WSSEND oWSPEDIDO WSRECEIVE lRETPEDIDORESULT WSCLIENT WSWSPEDIDOPORTAL
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RETPEDIDO xmlns="http://200.171.223.154:99/">'
cSoap += WSSoapValue("PEDIDO", ::oWSPEDIDO, oWSPEDIDO , "ESTRUTURA", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RETPEDIDO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://200.171.223.154:99/RETPEDIDO",; 
	"DOCUMENT","http://200.171.223.154:99/",,"1.031217",; 
	"http://200.171.223.154:99/WSPEDIDOPORTAL.apw")

::Init()
::lRETPEDIDORESULT   :=  WSAdvValue( oXmlRet,"_RETPEDIDORESPONSE:_RETPEDIDORESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ESTRUTURA

WSSTRUCT WSPEDIDOPORTAL_ESTRUTURA
	WSDATA   oWSAPRODS                 AS WSPEDIDOPORTAL_ARRAYOFITENS
	WSDATA   cCCNPJCLI                 AS string
	WSDATA   cCCNPJENT                 AS string
	WSDATA   cCCNPJSTE                 AS string
	WSDATA   cCCONDPAG                 AS string
	WSDATA   cCOBSERV                  AS string
	WSDATA   cCPEDCLI                  AS string
	WSDATA   cCTIPOENT                 AS string
	WSDATA   cCTIPOFAT                 AS string
	WSDATA   cCTIPOFRE                 AS string
	WSDATA   dDDTENT                   AS date
	WSDATA   cCEntUF                   AS string
	WSDATA   cCEntCEP                  AS string
	WSDATA   cCEntBRR                  AS string
	WSDATA   cCEntMUN                  AS string
	WSDATA   cCEntEND                  AS string
	WSDATA   cCEntNUM                  AS string
	WSDATA   cCRazao                   AS string
	 
	
 
	
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPEDIDOPORTAL_ESTRUTURA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPEDIDOPORTAL_ESTRUTURA
Return

WSMETHOD CLONE WSCLIENT WSPEDIDOPORTAL_ESTRUTURA
	Local oClone := WSPEDIDOPORTAL_ESTRUTURA():NEW()
	oClone:oWSAPRODS            := IIF(::oWSAPRODS = NIL , NIL , ::oWSAPRODS:Clone() )
	oClone:cCCNPJCLI            := ::cCCNPJCLI
	oClone:cCCNPJENT            := ::cCCNPJENT
	oClone:cCCNPJSTE            := ::cCCNPJSTE
	oClone:cCCONDPAG            := ::cCCONDPAG
	oClone:cCOBSERV             := ::cCOBSERV
	oClone:cCPEDCLI             := ::cCPEDCLI
	oClone:cCTIPOENT            := ::cCTIPOENT
	oClone:cCTIPOFAT            := ::cCTIPOFAT
	oClone:cCTIPOFRE            := ::cCTIPOFRE
	oClone:dDDTENT              := ::dDDTENT
	oClone:cCEntUF            	:= ::cCEntUF
	oClone:cCEntCEP            	:= ::cCEntCEP
	oClone:cCEntBRR            	:= ::cCEntBRR
	oClone:cCEntMUN            	:= ::cCEntMUN
	oClone:cCEntEND            	:= ::cCEntEND
	oClone:cCEntNUM            	:= ::cCEntNUM
	oClone:cCRazao            	:= ::cCRazao
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPEDIDOPORTAL_ESTRUTURA
	Local cSoap := ""
	cSoap += WSSoapValue("APRODS", ::oWSAPRODS, ::oWSAPRODS , "ARRAYOFITENS", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CCNPJCLI", ::cCCNPJCLI, ::cCCNPJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CCNPJENT", ::cCCNPJENT, ::cCCNPJENT , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CCNPJSTE", ::cCCNPJSTE, ::cCCNPJSTE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CCONDPAG", ::cCCONDPAG, ::cCCONDPAG , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("COBSERV", ::cCOBSERV, ::cCOBSERV , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPEDCLI", ::cCPEDCLI, ::cCPEDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CTIPOENT", ::cCTIPOENT, ::cCTIPOENT , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CTIPOFAT", ::cCTIPOFAT, ::cCTIPOFAT , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CTIPOFRE", ::cCTIPOFRE, ::cCTIPOFRE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DDTENT", ::dDDTENT, ::dDDTENT , "date", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cEntUF", ::cCEntUF, ::cCEntUF , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cEntCEP", ::cCEntCEP, ::cCEntCEP , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cEntBRR", ::cCEntBRR, ::cCEntBRR , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cEntMUN", ::cCEntMUN, ::cCEntMUN , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cEntEND", ::cCEntEND, ::cCEntEND , "cEntEND", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cEntNUM", ::cCEntNUM, ::cCEntNUM , "cEntEND", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cRazao", ::cCRazao, ::cCRazao , "cEntEND", .T. , .F., 0 , NIL, .F.,.F.) 
	
 
	
	
	
Return cSoap

// WSDL Data Structure ARRAYOFITENS

WSSTRUCT WSPEDIDOPORTAL_ARRAYOFITENS
	WSDATA   oWSITENS                  AS WSPEDIDOPORTAL_ITENS OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPEDIDOPORTAL_ARRAYOFITENS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPEDIDOPORTAL_ARRAYOFITENS
	::oWSITENS             := {} // Array Of  WSPEDIDOPORTAL_ITENS():New()
Return

WSMETHOD CLONE WSCLIENT WSPEDIDOPORTAL_ARRAYOFITENS
	Local oClone := WSPEDIDOPORTAL_ARRAYOFITENS():NEW()
	oClone:oWSITENS := NIL
	If ::oWSITENS <> NIL 
		oClone:oWSITENS := {}
		aEval( ::oWSITENS , { |x| aadd( oClone:oWSITENS , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPEDIDOPORTAL_ARRAYOFITENS
	Local cSoap := ""
	aEval( ::oWSITENS , {|x| cSoap := cSoap  +  WSSoapValue("ITENS", x , x , "ITENS", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ITENS

WSSTRUCT WSPEDIDOPORTAL_ITENS
	WSDATA   cCITEM                    AS string
	WSDATA   cCITEMPED                 AS string
	WSDATA   cCPRODUTO                 AS string
	WSDATA   nNPRECO                   AS float
	WSDATA   nNQUANT                   AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPEDIDOPORTAL_ITENS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPEDIDOPORTAL_ITENS
Return

WSMETHOD CLONE WSCLIENT WSPEDIDOPORTAL_ITENS
	Local oClone := WSPEDIDOPORTAL_ITENS():NEW()
	oClone:cCITEM               := ::cCITEM
	oClone:cCITEMPED            := ::cCITEMPED
	oClone:cCPRODUTO            := ::cCPRODUTO
	oClone:nNPRECO              := ::nNPRECO
	oClone:nNQUANT              := ::nNQUANT
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPEDIDOPORTAL_ITENS
	Local cSoap := ""
	cSoap += WSSoapValue("CITEM", ::cCITEM, ::cCITEM , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CITEMPED", ::cCITEMPED, ::cCITEMPED , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPRODUTO", ::cCPRODUTO, ::cCPRODUTO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NPRECO", ::nNPRECO, ::nNPRECO , "float", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NQUANT", ::nNQUANT, ::nNQUANT , "float", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap


