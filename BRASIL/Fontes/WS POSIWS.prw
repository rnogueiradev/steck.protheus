#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
#DEFINE Cr chr(13)+chr(10)

/* ===============================================================================
WSDL Location    https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx?WSDL
Gerado em        06/03/14 16:41:01
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
Altera��es neste arquivo podem causar funcionamento incorreto
e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */
#XTRANSLATE ChkType(<cNode>,<xValue>,<cType>) => 	If valtype(<xValue>) != <cType> ; UserException('WSCERR055 / Invalid Property Type ('+valtype( <xValue> )+') for '+ <cNode> +' ('+ <cType> +')') ; Endif

// Translates para a marca��o de Tempo e montagem de profile de execu��o

#XTRANSLATE MarkTimer() => __XMLCTimer := Seconds()
#XTRANSLATE ShowTimer(<cEcho>) => __XMLCPLog += str(Seconds() - __XMLCTimer,12,3)+' s. ['+<cEcho>+']' + CRLF

#XTRANSLATE NoHifen(<cName>) => StrTran(<cName>,'-','_')

/* --------------------------------------------------------------------------------

WEB SERVICES CLIENT

Autor			Julio Wittwer
Data			Outubro / 2002

-------------------------------------------------------------------------------- */

// Vers�o atual deste fonte-conversor
// ## APENAS ALTERAR NUMEROS : NAO MEXER NO TAMANHO E POSICOES ##
// ## FORMATO DE VERSAO : 1.AAMMDD                             ##
#DEFINE WSDLCLIENT_VERSION 		'ADVPL WSDL Client 1.090116'

// Defines com Builds Protheus por compatibilidade com novas implementa��es
#DEFINE  ACTUAL_BUILD		left(GetBuild(),11)
#DEFINE  LONGNAMES_BUILD	'7.00.030715'

// Fontes gerados com esta vers�o exigem lib de infra-estrutura
// igual ou superior `a definida abaixo ...
// ## NAO MEXA NO TAMANHO DA STRING, NAO PONHA LETRA E NAO MEXA NO PONTO ##
#DEFINE  WSDL_CLIENT_COMPATIBLE '1.040504'

// Defines com Vers�es de Lib Server do PRotheus para breaks de compatibilidade
#DEFINE  NEWWSDL_VERSION	'1.031217'

STATIC __nTimeOut       := 120
STATIC __WSDLError	:= ''			// Armazenar ocorr�ncias de Erro
STATIC __DbgLevel		:= 0			// Armazena Nivel de Debug para a Thread Atual
STATIC __DbgInfo		:= ''			// Informa��es de Debug
STATIC __AdvType  	:= {} 		// Nomes de Variaveis ADVPL para Types...
STATIC __DbgProfile	:= .F.		// Flag para habilitar PROFILE de execu��o Client
STATIC __DbgSaveXML	:= .F.		// Flag para salvar xmls no disco

STATIC __UseLongNames
STATIC __UseHttps

STATIC __SvcPrefix	:= NIL

STATIC __ExternalRef := .F.
STATIC __FatalError	:= .F.
STATIC __NameSpaces := {}

// Variaveis de controle de tratamento de erro em Client
STATIC __MethodBlock := NIL
STATIC __ClientStack := ''

// Informacoes adicionais de Controle de SOAP_FAULT

STATIC __SFaultCode
STATIC __SFaultStr
STATIC __SFaultObj

// Controle de namespaces dentro de uma requisicao client
STATIC __NSSoapCall 	:= {}

STATIC aPendIO			:= {}			// Array com estruturas e uriliza��o em Input , Output ou ambos.

STATIC aType	:= {}	// Types
STATIC aMsg		:= {}	// Messages
STATIC aPort	:= {} // Port
STATIC aBind	:= {} // aBinding
STATIC aServ	:= {} // aServices
STATIC aName	:= {} // aNameSpaces
STATIC aImport := {} // Imports

STATIC aImportDone := {} // Imports j� processados

STATIC __ExistUtf8		       // Se a fun��o de Encode Utf-8, j� est� dispon�vel --> ANDR�
STATIC __CtTypeUsed	   		 // ContentType utilizado --> utf-8 ou iso-8859-1

STATIC __XMLURLPost  := ''
STATIC __XMLHeadRet	:= ''
STATIC __XMLPostRet	:= ''
STATIC __XMLSaveInfo	:= .F.

STATIC __XMLCTimer 	:= 0
STATIC __XMLCPLog		:= ''

STATIC __lXmlChildEx	:= .F.
STATIC __lXmlFnChild := 'XMLCHILDEX'

STATIC __aMPar := {}	// Static de Controle de Par�metros do M�todo

STATIC __UseSpecial	:= .F.

// STATIC para controle : Se o client a ser regerado deve usar alias
// por compatibilidade com estruturas de par�metro para servers protheus
// atualizados com a corre��o no WSDL ...
// Esta informa��o � verificada no momento da interpreta��o do retorno
// da httpget , atrav�s da presen�a do header http

STATIC __UseAlias		:= .F.

// Static de controle de msg de Warning por client gerado a partir de WSDL
// fornecido por server Protheus NOVO e executado em server protheus VELHO
// Caso preenchido, informa a vers�o sob a qual o fonte client necessita
// para rodar ok.
STATIC __WarnBuild	:= ''

// Static para msgs diversas de advertencia
STATIC __WarnMsg := {}

// Static de Controle para SoapAction alternativo na chamada do client.

STATIC __SoapAct
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STPOSITRON	�Autor  �Giovani Zago     � Data �  26/09/18  ���
�������������������������������������������������������������������������͹��
���Desc.     �POSITRON		 											  ���
���          �   													      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STPOSITRON()
	Local oXml
	Local _oWS
	Local oXml
	Local oXml2
	Local cMensagemXML:=  ' '
	Local i:=0
	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	If dow(date()) = 1  .And. dow(date()) = 7 //domingo ---- sabado
		Return()
	EndIf

	_oWS := WSOccurrenceServiceWS():New()

	_oWS:oWSrequest:cusername	:= "steck"
	_oWS:oWSrequest:cpassword	:= "2wF4w@d"
	_oWS:oWSrequest:cqueuename	:= "fila_steck"



	If _oWS:getOccurrences()

		oXml:=  _oWS:coccurrences
		If ValType(oXml) = 'A'
			For i:=1 To Len(oXml)

				cAviso := ""
				cErro  := ""
				_cXml  := ""
				_cXml:= oXml[i]:text
				_cXml:= FwCutOff(_cXml, .t.)
				oXml2 := XmlParser(_cXml,"_",@cAviso,@cErro)

				If VALType(oXml2) <> "U"

					DbSelectArea("Z1Z")			 
					DbSelectArea("Z1Q")
					Z1Q->(DbGoTop())
					Z1Q->(DbSetOrder(1))


					Z1Q->(RecLock("Z1Q",.T.))
					Z1Q->Z1Q_FILIAL	:=	cFilAnt
					Z1Q->Z1Q_LAT	:=	Alltrim(oXml2:_position:_pack:_gps:_lat:text)
					Z1Q->Z1Q_LONG	:=	Alltrim(oXml2:_position:_pack:_gps:_long:text)
					Z1Q->Z1Q_EVENT 	:=	Alltrim(oXml2:_position:_pack:_event:text)
					Z1Q->Z1Q_DATA	:=	Alltrim(Substr(Alltrim(oXml2:_position:_pack:_gps:_dategps:text),1,4)+Substr(Alltrim(oXml2:_position:_pack:_gps:_dategps:text),6,2)+Substr(Alltrim(oXml2:_position:_pack:_gps:_dategps:text),9,2))
					Z1Q->Z1Q_HORA	:=	Alltrim(Substr(Alltrim(oXml2:_position:_pack:_gps:_dategps:text),12,2)+Substr(Alltrim(oXml2:_position:_pack:_gps:_dategps:text),15,2)+Substr(Alltrim(oXml2:_position:_pack:_gps:_dategps:text),18,2))
					Z1Q->Z1Q_IGNI	:=	Alltrim(oXml2:_position:_pack:_panel:_ignition:text)
					Z1Q->Z1Q_VELO	:=	PADL(Alltrim(oXml2:_position:_pack:_panel:_speed:text),3,'0')
					Z1Q->Z1Q_PLACA	:=	Alltrim(oXml2:_position:_pack:_veicTag:text)
					If GetMv("ST_WSPOSI",,.T.)
						Z1Q->Z1Q_NOME	:=	SUBSTR(Posicione("Z1Z",1,xFilial("Z1Z") + Alltrim(oXml2:_position:_pack:_veicTag:text),"Z1Z_NOME"),1,30) 
					EndIf
					Z1Q->(MsUnlock())


				EndIf
			Next i
		EndIf
	EndIf
Return()



User FUNCTION qSvcSoapCall(oSvcObj,cSoap,cSoapAction,cSoapStyle,cNameSpace,cSoapHead,cXBuild, cPostUrl )
	Local cError 	:= '' , cWarning	:= ''
	Local oXmlRet
	Local aHeadOut := {}
	Local cSoapSend := ''
	Local aTmpTypes := {}
	Local nPosTypes := 0
	Local cSoapPrefix := ''
	Local cUrl , aTmp1 , aTmp2
	Local cHeaderRet := ''
	Local cXMLFile
	Local lURLChanged := .f. , lChanged := .f. , cOldSoap := ''
	Local nRetry      := 0
	Local nStart      := 0
	//return( SvcSoapCall(oSvcObj,cSoap,cSoapAction,cSoapStyle,cNameSpace,cSoapHead,cXBuild, cPostUrl ))
	// Re-inicializa STATICs de Controle de POST do Client
	__XMLURLPost 	:= ''
	__XMLPostRet 	:= ''
	__XMLHeadRet 	:= ''
	__XMLSaveInfo	:= .F.

	// Inicializa controle de namespace de retorno desta requisicao
	asize(__NSSoapCall,0)

	// Reinicializa STATIC de controle de PROFILE
	__XMLCPLog		:= ''

	// Identifica se a fun��o XMLCHILDEX est� compilada ...
	__lXmlChildEx	:= FindFunction(__lXmlFnChild)

	DEFAULT cSoapHead := ''

	// Verifica se o build atual t�m a fun��o XmlPArser
	If !FindFunction('XMLPARSER') ; UserException('WSCERRINT / Build '+GETBUILD()+' does not support Web Services.') ; Endif

	// Zera variaveis STATIC de controle de Erros SOAP_FAULT
	__SFaultCode   := NIL
	__SFaultStr 	:= NIL
	__SFaultObj		:= NIL

	// Identifica a URL a submeter

	If cPostUrl <> NIL
		// Fonte client gerado com lib de webservices nova !
		// Passa a URL a submeter na linha de chamada da svcsoapcall
		If oSvcObj:_URL <> NIL
			// Caso a _URL seja passada na propriedade , esta prevalece sobre
			// a default, e liga flag informando que o SoapAction deve ser re-montado.
			cUrl 			:= oSvcObj:_URL
			lURLChanged	:= .T.
		Else
			// Caso o _URL n�o seja alimentado, utiliza a url original do servi�o.
			cUrl 			:= cPostUrl
		Endif
	Else
		// Fonte gerado com lib anterior � x.040115
		// Pega a URL a partir da propriedade _URL
		cUrl := oSvcObj:_URL
	Endif

	If empty(cUrl)
		UserException("WSCERR042 / "+'hy') // "URL LOCATION n�o especificada."
		//ElseIf IsHttpsURL(cUrl) .and. !IsHTTPSBuild()
		//UserException("WSCERR070 / "+'qq' +" ["+GetBuild()+"]") // "Requisi��o HTTPS n�o suportada neste BUILD"
	Endif

	If !empty(__SoapAct)

		// Caso tenha sido especificado um Soap Action alternativo para esta chamada,
		// Ele � utilizado apenas para esta chamada e a STATIC de controle � limpa !

		cOldSoap 	:= cSoapAction
		cSoapAction	:= __SoapAct
		__SoapAct 	:= NIL

		// Seta que soapaction foi alterado
		lChanged := .t.

	Endif

	If __DbgLevel > 1
		conout(replicate('-',79))
		conout("SvcSoapCall to "+cUrl+" / "+cSoapStyle)
		conout("NameSpace "+cNameSpace)
		conout("SoapAction "+cSoapAction)
		If lURLChanged
			conout("ORIGINAL URL : "+cPostURL)
		Endif
		If lChanged
			conout("ORIGINAL SOAPACTION : "+cOldSoap)
		Endif
		conout(GetStack())
	Endif
	__CtTypeused :=   "utf-8"
	// Acrescenta Informa��es adicionais no Header da requisi��o
	aadd(aHeadOut,'SOAPAction: '+cSoapAction)
	aadd(aHeadOut,'Content-Type: text/xml; charset=' + __CtTypeUsed )

	// Acrescenta o UserAgent na requisi��o ...
	aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+'; '+WSDLCLIENT_VERSION+')')

	cSoapSend += '<?xml version="1.0" encoding="'+__CtTypeUsed+'"?>'

	IF cSoapStyle == "DOCUMENT"
		cSoapSend += '<soap:Envelope '
		cSoapSend += 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
		cSoapSend += 'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
		cSoapSend += 'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
	ElseIF cSoapStyle == "DOCUMENTSOAP12"
		cSoapSend += '<soap:Envelope '
		cSoapSend += 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
		cSoapSend += 'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
		cSoapSend += 'xmlns:soap="http://www.w3.org/2003/05/soap-envelope">'
	ElseIF cSoapStyle == "RPC" .or. cSoapStyle == "RPCX"
		cSoapSend += '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
		cSoapSend += 	'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
		cSoapSend += 	'xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" '
		cSoapSend += 	'xmlns:tns="'+cNameSpace+'" '
		cSoapSend += 	'xmlns:types="'+cNameSpace+'encodedTypes" '
		cSoapSend += 	'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'

	Else

		UserException("WSCERR043 / ["+cSoapStyle+"] "+'ww') // "SOAPSTYLE Desconhecido."

	Endif

	If !empty(cSoapHead)
		cSoapSend += '<soap:Header>'
		cSoapSend += cSoapHead
		cSoapSend += '</soap:Header>'
	Endif

	If cSoapStyle == "DOCUMENT" .OR. cSoapStyle == "DOCUMENTSOAP12"
		cSoapSend += '<soap:Body>'
	ElseIF cSoapStyle == "RPC" .or. cSoapStyle == "RPCX"
		cSoapSend += '<soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
	Endif

	cSoapSend += cSoap

	cSoapSend += '</soap:Body>'
	cSoapSend += '</soap:Envelope>'

	If left(csoap,1)=="_"
		// RECURSO DE DEBUG :
		// Caso o Soap enviado inicie com _ , manda ele direto pro destino
		// sem acrescentar os header's e defini��es....
		cSoapSend := substr(cSoap,2)
	Endif

	If __DbgLevel > 1
		conout(padc(" SOAPSEND ",79,"-"))
		conout(strtran(cSoapSend,"><",">"+CRLF+"<"))
		conout(replicate("-",79))
	Endif

	If __DbgSaveXML
		// Cria nome de arquivo temporario
		cXMLFile := str(seconds()*1000,8)
		// salva o XML a ser enviado no disco
		memowrit(cXMLFile+'_snd.xml',cSoapSend)
	Endif

	If __DbgProfile	 ; 	MarkTimer() ; Endif

	//-----------------------------
	// Tenta por 2 minutos ou 3 vezes antes de abortar
	//    - Adicionado para proteger erros de c�digo de WSClient Protheus
	//-----------------------------
	nStart := Seconds()
	nRetry := 0

	cSoapSend:= '		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pos="http://pst.com.br/position.xsd">
	cSoapSend+= ' <soapenv:Header/>
	cSoapSend+= ' <soapenv:Body>
	cSoapSend+= ' <pos:getOccurrences>
	cSoapSend+= ' <request>
	cSoapSend+= ' <username>steck</username>
	cSoapSend+= ' <password>2wF4w@d</password>
	cSoapSend+= ' <queuename>fila_steck</queuename>
	cSoapSend+= '  </request>
	cSoapSend+= ' </pos:getOccurrences>
	cSoapSend+= '  </soapenv:Body>
	cSoapSend+= ' </soapenv:Envelope>

	While nRetry <3

		__XMLPostRet := Httppost(cUrl,"",cSoapSend,__nTimeOut,aHeadOut,@__XMLHeadRet)
		//conout(cSoapSend)
		If __XMLPostRet <> Nil
			nRetry := 4
			Exit
		Else
			nRetry++
			If (Seconds() - nStart) >= __nTimeOut
				nRetry := 4
				Exit
			EndIf
		EndIf
	EndDo

	If __XMLPostRet = NIL
		conout(__XMLPostRet)
		UserException("WSCERR044 / "+'oo'+" : URL "+cURL) // N�o foi poss�vel POST
	ElseIf Empty(__XMLPostRet)
		If !empty(__XMLHeadRet)
			UserException("WSCERR045 / "+'yy'+" : URL "+cURL+' ['+__XMLHeadRet+']')
		Else
			UserException("WSCERR045 / "+'tt'+" : URL "+cURL)
		Endif
	Endif

	If __DbgProfile
		ShowTimer(	"HTTPPost ( Send "+str(len(cSoapSend),8)+" bytes. / "+;
		"Receive "+str(len(__XMLPostRet),8)+" bytes.)")
	Endif

	If __DbgSaveXML
		// Salva XML Recebido no disco
		memowrit(cXMLFile+'_rcv.xml',__XMLPostRet)
	Endif

	// Alimenta static de controle de ultimo POST
	__XMLURLPost := cUrl

	If __DbgLevel > 0
		conout(padc(" POST RETURN ",79,'='))
		If !empty(__XMLHeadRet)
			conout(__XMLHeadRet)
			conout(replicate('-',79))
		Endif
		conout(__XMLPostRet)
		conout(replicate('=',79))
	Endif

	// --------------------------------------------------------
	// Antes de Mandar o XML para o PArser ,
	// Verifica se o Content-Type � XML !
	// Se n�o for , nem perde tempo em parsear nada !
	// Content-Type: text/xml; charset=utf-8
	// ========================================================
	// ATENCAO : N�o � feita a consist�ncia do content-type
	// caso o __XMLHeadRet esteja vazio, pois o retorno do header
	// por refer�ncia na fun��o httppost foi realizado a partir de
	// uma vers�o de Bin�rio .
	// --------------------------------------------------------

	If !empty(__XMLHeadRet)
		cHeaderRet := __XMLHeadRet
		nPosCType := at("CONTENT-TYPE:",Upper(cHeaderRet))
		If nPosCType > 0
			cHeaderRet := substr(cHeaderRet,nPosCType)
			nPosCTEnd := at(CRLF , cHeaderRet)
			cHeaderRet := substr(cHeaderRet,1,IIF(nPosCTEnd > 0 ,nPosCTEnd-1, NIL ) )
			If !"XML"$upper(cHeaderRet)
				__XMLSaveInfo := .T.
				UserException("WSCERR064 / Invalid Content-Type return ("+cHeaderRet+") from "+cURL+CRLF+" HEADER:["+__XMLHeadRet+"] POST-RETURN:["+__XMLPostRet+"]")
			Endif
		Else
			__XMLSaveInfo := .T.
			UserException("WSCERR065 / EMPTY Content-Type return ("+cHeaderRet+") from "+cURL+CRLF+" HEADER:["+__XMLHeadRet+"] POST-RETURN:["+__XMLPostRet+"]")
		Endif
	Endif


	If __DbgProfile	 ; 	MarkTimer() ; Endif

	// Passa pela XML Parser...


	oXmlRet := XmlParser(__XMLPostRet,'_',@cError,@cWarning)

	If __DbgProfile
		ShowTimer(	"Convert XML String to Advpl XML Object. (XMLPArser)")
	Endif

	If !empty(cWarning)
		__XMLSaveInfo := .T.
		UserException('WSCERR046 / XML Warning '+cWarning+' ( POST em '+cURL+' )'+CRLF+" HEADER:["+__XMLHeadRet+"] POST-RETURN:["+__XMLPostRet+"]")
	ElseIf !empty(cError)
		__XMLSaveInfo := .T.
		UserException('WSCERR047 / XML Error '+cError+' ( POST em '+cURL+' )'+CRLF+" HEADER:["+__XMLHeadRet+"] POST-RETURN:["+__XMLPostRet+"]")
	ElseIF oXmlRet = NIL
		__XMLSaveInfo := .T.
		UserException('WSCERR073 / Build '+GETBUILD()+' XML Internal Error.'+CRLF+" HEADER:["+__XMLHeadRet+"] POST-RETURN:["+__XMLPostRet+"]")
	Endif

	// Identifica os nodes inicias envelope e body
	// Eles devem ser os primeiros niveis do XML

	If Empty(aTmp1 := ClassDataArr(oXmlRet))
		__XMLSaveInfo := .T.
		aTmp1 := NIL
		UserException('WSCERR056 / Invalid XML-Soap Server Response : soap-envelope not found.')
	Endif

	If empty(cEnvSoap := aTmp1[1][1])
		aTmp1 := NIL
		__XMLSaveInfo := .T.
		UserException('WSCERR057 / Invalid XML-Soap Server Response : soap-envelope empty.')
	Endif

	// Limpa a vari�vel tempor�ria
	aTmp1 := NIL

	// Elimina este node, re-atribuindo o Objeto
	oXmlRet := xGetInfo( oXmlRet, cEnvSoap  )

	If valtype(oXmlRet) <> 'O'
		__XMLSaveInfo := .T.
		UserException('WSCERR058 / Invalid XML-Soap Server Response : Invalid soap-envelope ['+cEnvSoap+'] object as valtype ['+valtype(oXmlRet)+']')
	Endif

	If Empty(aTmp2 := ClassDataArr(oXmlRet))
		aTmp2 := NIL
		__XMLSaveInfo := .T.
		UserException('WSCERR059 / Invalid XML-Soap Server Response : soap-body not found.')
	Endif

	If empty(cEnvBody := aTmp2[1][1])
		aTmp2 := NIL
		__XMLSaveInfo := .T.
		UserException('WSCERR060 / Invalid XML-Soap Server Response : soap-body envelope empty.')
	Endif

	// Limpa a vari�vel tempor�ria
	aTmp2 := NIL

	// Elimina este node, re-atribuindo o Objeto
	oXmlRet := xGetInfo( oXmlRet, cEnvBody )

	If valtype(oXmlRet) <> 'O'
		__XMLSaveInfo := .T.
		UserException('WSCERR061 / Invalid XML-Soap Server Response : Invalid soap-body ['+cEnvBody+'] object as valtype ['+valtype(oXmlRet)+']')
	Endif

	cSoapPrefix := substr(cEnvSoap,1,rat("_",cEnvSoap)-1)

	If Empty(cSoapPrefix)
		__XMLSaveInfo := .T.
		UserException('WSCERR062 / Invalid XML-Soap Server Response : Unable to determine Soap Prefix of Envelope ['+cEnvSoap+']')
	Endif

	/*
	ESTRUTURA DE SOAP FAULT 1.2

	<soap:Fault>
	<faultcode></faultcode>
	<faultstring></faultstring>
	<faultactor></faultactor>
	<detail></detail>
	</soap:Fault>
	*/

	If xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:TEXT" ) != NIL
		// Se achou um soap_fault....

		cFaultString := xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTCODE:TEXT" )

		If !empty(cFaultString)
			// OPA, protocolo soap 1.0 ou 1.1
			cFaultCode := xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTCODE:TEXT" )
			cFaultString := xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTSTRING:TEXT" )
		Else
			// caso contrario, trato como soap 1.2
			cFaultCode := xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTCODE:TEXT" )
			If Empty(cFaultCode)
				cFaultCode := xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:"+cSoapPrefix+"_CODE:TEXT" )
			Else
				cFaultCode += " [FACTOR] " + xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTACTOR:TEXT" )
			EndIf
			DEFAULT cFaultCode := ""
			cFaultString := xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_DETAIL:TEXT" )
			If !Empty(cFaultString)
				cFaultString := xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTSTRING:TEXT" ) + " [DETAIL] " + cFaultString
			Else
				cFaultString :=  xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:"+cSoapPrefix+"_REASON:"+cSoapPrefix+"_TEXT:TEXT" )
				DEFAULT cFaultString := ""
				cFaultString += " [DETAIL] " + xGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:"+cSoapPrefix+"_DETAIL:TEXT" )
				DEFAULT cFaultString := ""
			Endif
		Endif

		// Seta Statics de controle de Soap Fault adicionais
		__SFaultCode   := cFaultCode
		__SFaultStr 	:= cFaultString
		__SFaultObj		:= oXmlRet

		// Inicializa static de Warning de Build de WebServices SERVER PRotheus
		// Caso o build tenha sido passado como par�metro
		If !empty(cXBuild)
			__WarnBuild := cXBuild
		Endif

		// Aborta processamento atual com EXCEPTION
		UserException('WSCERR048 / SOAP FAULT '+cFaultCode+' ( POST em '+cURL+' ) : ['+cFaultString+']')

	Endif

	If cSoapStyle == "RPC" .or. cSoapStyle == "RPCX"

		// RPCTUNGA  : Identifica o node de response
		aTmpTypes := ClassDataArr(oXmlRet)

		// Localiza o Node de Response
		nPosTypes := ascan(aTmpTypes,{|x| isNode(x[2]) .and. "RESPONSE"$x[1] })

		If nPosTypes = 0
			// Se n�o achou o Response ... pega o primeiro Node (?)
			nPosTypes := ascan(aTmpTypes,{|x| isNode(x[2]) })
		Endif

		If nPosTypes = 0
			__XMLSaveInfo := .T.
			UserException('WSCERR049 / SOAP RESPONSE (RPC) NOT FOUND.')
		Endif

		If cSoapStyle == "RPC"

			// TRATAMENTO MANTIDO POR COMPATIBILIDADE PARA CLIENTS ANTIGOS
			// Que chamam esta fun��o passando soapstyle = RPC ....
			// Quando n�o � refer�ncia , tem que arrancar
			// tamb�m N�vel de RETORNO !!! OS novos clients gerados a partir da
			// vers�o x.xxxxxxxxxx buscam o dado no luigar certo do node

			// Verifica se o node de response faz refer�ncia a outro node
			// Primeiro pega o nome do node de resposta
			cRNodeName := ClassDataArr(aTmpTypes[nPosTypes][2])[1][1]

			cRef := xGetInfo( aTmpTypes[nPosTypes][2],cRNodeName+":_HREF:TEXT" )
			DEFAULT cRef := ''
			cRef := IIF(left(cRef,1)=="#", Substr(cRef,2),cRef)

			IF !empty(cRef)

				// Se est� fazendo refer�ncia a alguem ...
				// PRocura o node no Raiz com ID especificado

				nPosTypes := ascan(aTmpTypes,{|x| isNode(x[2]) .and. xGetInfo(x[2],'_ID:TEXT') == cRef })

				If nPosTypes = 0
					__XMLSaveInfo := .T.
					UserException('WSCERR050 / SOAP RESPONSE REF '+cRef+' (RPC) NOT FOUND.')
				Endif

				// Retorna o Conteudo da Refer�ncia ...
				// Quando � refer�ncia , o nivel de retorno j� foi arrancado
				oXmlRet := xGetInfo( oXmlRet, aTmpTypes[nPosTypes][1] )

			Else

				// Retorna o Conteudo do Node
				oXmlRet := xGetInfo( oXmlRet, aTmpTypes[nPosTypes][1] )

				// E arranca proximo nivel tb ...
				aTmpTypes := ClassDataArr(oXmlRet)

				nPosTypes := ascan(aTmpTypes,{|x| isNode(x[2]) })

				If nPosTypes = 0
					__XMLSaveInfo := .T.
					UserException('WSCERR051 / SOAP RESPONSE RETURN (RPC) NOT FOUND.')
				Endif

				// Agora sim , Retorna o Conteudo do Node
				oXmlRet := xGetInfo( oXmlRet, aTmpTypes[nPosTypes][1] )

			Endif

		ElseIf cSoapStyle == "RPCX"

			// Tratamento corrigido : Retorna apenas o primeiro nivel de resposta
			// do node. O tratamento de refer�ncias deve ser estudado !!!
			// Pois a especifica��o de refer�ncias � MUITO ABERTA

			// Retorna o Conteudo do Node...
			oXmlRet := xGetInfo( oXmlRet, aTmpTypes[nPosTypes][1] )

		Else

			UserException("*** UNEXPECTED SOAPSTYLE "+cSoapStyle+" ***")

		Endif

	Endif

	If __DbgProfile
		conout(	replicate('-',79),;
		'POST on '+__XMLURLPost,;
		'SoapAction '+cSoapAction,;
		__XMLCPLog,;
		replicate('-',79))
		__XMLCPLog := ''
	Endif

Return oXmlRet




