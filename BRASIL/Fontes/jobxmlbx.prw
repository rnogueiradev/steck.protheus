#include "Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "XMLXFUN.CH"

/*/{Protheus.doc} jobxmlbx
@description 
Rotina Job que fará leitura do e-mail, baixando arquivo e validando a existencia do registro. Caso não exista
irá adicionar o registro.
@type function
@version  1.00
@author Valdemir Jose
@since 09/06/2021
@return return_type, return_description
u_jobxmlbx
/*/
User Function jobxmlbx
	Local _aEmpresa := {}
	Local nX        := 0

	// Empresas / Filiais que deverão ser validada
	aAdd(_aEmpresa, {'01','05'})
	//aAdd(_aEmpresa, {'03','01'})

	ConOut( "*********************************************************************" )
	ConOut( "* JOB PARA BAIXAR E-MAIL (ARQUIVOS XML) E ADICIONAR REGISTROS NOVOS *" )
	ConOut( "*********************************************************************" )

	For nX := 1 to Len(_aEmpresa)
		ConOut( "*******************************************************************" )
		ConOut( "*    INICIO LEITURA EMPRESA:[ " +_aEmpresa[nX][01]+ " ] FILIAL: [ "+_aEmpresa[nX][02]+" ] - VIA JOB  (JOBNFIMP)  *" )
		ConOut( "*******************************************************************" )

		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv(_aEmpresa[nX][01],_aEmpresa[nX][02],,,,GetEnvServer(),{ "SC7","SF1","SD1","SB1","SDA","SDB","Z1A","SZ9" } )
		SetModulo("SIGACOM","COM")

		// Efetua chamada da rotina...
		xProcess()

		RpcClearEnv()

		ConOut( "*******************************************************************" )
		ConOut( "*    TERMINO LEITURA EMPRESA: [ "+_aEmpresa[nX][01]+" ] FILIAL: [ "+_aEmpresa[nX][02]+" ] JOB (JOBNFIMP)                               *" )
		ConOut( "*******************************************************************" )
	Next


return .T.


/*/{@Protheus.doc} xProcess
@description
Rotina de Processamento, baixado arquivos do e-mail
@type function
@version  1.00
@author Valdemir Jose
@since 09/06/2021
@return return_
@type, return_description
/*/
Static Function xProcess()
	Local lRelauth
	Local cFrom
	Local cConta
	Local cServer
    Local cProtocol  := ""
	Local cStrAtch   := ""
	Local aFileAtch  := {}
	Local lOk        := .T.
	Local lRet       := .F.
    Local lConnected := .F.
    Local nI         := 0
    Local nAtach     := 0
    Local nMessageDown := 0
    Local xRet
	Local lIsPop     := SuperGETMV("FS_FORIPOP" ,.f.,.T.) 	// define as .T. if POP protocol, instead of IMAP
	Local lRecvSec   := SuperGETMV("FS_FORSCON" ,.f.,.T.) 	// define as .T. if the server uses secure connection
	Local cIniFile   := GetADV97()
    Local cPath      := GetSrvProfString("Rootpath","")    //+"\System"
	Local cStartPath := "\Arquivos\XMLBX\"
   	Local cRecvSrv   := AllTrim(SuperGETMV("FS_BXPOP3",,"outlook.office365.com"))
    Local cSenhaa    := GetMV("MV_BXPSW",.f.,"NotaFiscal2021")
	Local cUser      := GetMV("MV_USBXEML",.f.,'stecknfe@steck.com.br')
	Local nMessages  := 0
	Local lExcMsg    := SuperGETMV("FS_EXCLEML" ,.f.,.F.)

	MakeDir(Trim(cStartPath))                       //CRIA DIRETOTIO ENTRADA

	If lIsPop == .T.
		cProtocol := "POP3"
		If lRecvSec == .T.
			nRecv := 995 //default port for POPS protocol
        else 
			nRecv := 110 //default port for POP protocol
		EndIf
	Else
		cProtocol := "IMAP"
		If lRecvSec == .T.
			nRecv := 993 //default port for IMAPS protocol
		Else
			nRecv := 143 //default port for IMAP protocol
		EndIf
	EndIf
	
	cIniFile := GetSrvIniName()
	//cIniConf := GetPvProfString( "MAIL", "Protocol", "", cIniFile )
	xRet := WritePProString( "MAIL", "Protocol", cProtocol, cIniFile )
	
	If xRet == .F.
		cMsg := "Não foi possível definir " + cProtocol + " on " + cIniFile + CRLF
		Conout( cMsg )
		lRET := .F.
	EndIf
	
	oServer := TMailManager():New()
	
	If lRecvSec == .T.
		oServer:SetUseSSL( .T. )    
	Else
		oServer:SetUseSSL( .F. )
	EndIf
	oServer:SetUseTLS( .T. )     
	
	// once it will only receives messages, the SMTP server will be passed as ""
	// and the SMTP port number won't be passed, once it is optional
	xRet := oServer:Init( cRecvSrv, "smtp.office365.com" , cUser, cSenhaa, nRecv, 587 ) 
	
	If xRet != 0
		cMsg := "Não foi possível inicializar o servidor de email: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		RestoreConf( cIniConf, cIniFile )
		lRET := .F.
	EndIf
	
	// the method works for POP and IMAP, depending on the INI configuration
	xRet := oServer:SetPOPTimeout( 320 )
	
	If xRet != 0
		cMsg := "Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout )
		conout( cMsg )
	EndIf
	
	If lIsPop == .T.
		xRet := oServer:POPConnect()
	Else
		xRet := oServer:IMAPConnect()
	EndIf
	
	If xRet <> 0
		cMsg := "Não foi possível conectar " + cProtocol + " servidor: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		lConnected := .F.
		lRET := .F.
	Else
		lConnected := .T.
	EndIf
	
	If lConnected
		xRet := oServer:GetNumMsgs( @nMessages )
		cMsg := "Número de mensagens: " + cValToChar( nMessages )
		conout( cMsg )
		If nMessages > 0
			//oMessage := TMailMessage():New()
			For nI := 1 to 100 //nMessages
			    oMessage := TMailMessage():New()
				cMsg := "Recebendo mensagem " + cValToChar( nI )
				conout( cMsg )
				oMessage:Clear()
				xRet := oMessage:Receive( oServer, nI )
				If xRet <> 0
					cMsg := "Não foi possível obter a mensagem " + cValToChar( nI ) + ": " + oServer:GetErrorString( xRet )
					conout( cMsg )
					If xRet == 6 // error code for "No Connection"
						RestoreConf( cIniConf, cIniFile )
						lRET := .F.
					EndIf
				Else
					xRet := oMessage:getAttachCount()
					If xRet > 0
						lSave := .T.
						//Verifica todos anexos da mensagem e os salva
						For nAtach := 1 to xRet
							aAttInfo := oMessage:getAttachInfo(nAtach)
							If UPPER(RIGHT(aAttInfo[1],3))=="XML"
                                // Verifico se o arquivo existe
                                if File(cPath+cStartPath+aAttInfo[1],1,.F.)
                                   FErase(cPath+cStartPath+aAttInfo[1])
                                Endif 
								oMessage:SaveAttach(nAtach, cPath+cStartPath+aAttInfo[1])
								If !File(cPath+cStartPath+aAttInfo[1],1,.F.)
									lSave := .F.
								EndIf
								nMessageDown++
							EndIf
						Next
						If lSave
							//Deleta mensagem
							if lExcMsg
								oServer:DeleteMsg(nI)
							endif 
						EndIf
					EndIf
				EndIf
				FreeObj(oMessage)
			Next
		EndIf
		If lIsPop == .T.
			xRet := oServer:POPDisconnect()
		Else
			xRet := oServer:IMAPDisconnect()
		EndIf
		
		If xRet <> 0
			cMsg := "Não foi possível desconectar do " + cProtocol + " servidor: " + oServer:GetErrorString( xRet )
			conout( cMsg )
			lRET := .F.
		EndIf
		
		// Executa validação dos arquivos xml encontrados no diretório
        xProc001()
		
	EndIf

Return


/*/{Protheus.doc} xProc001
@description
Rotina que fará leitura do arquivo XML, validando se já existe ou não
@type function
@version  
@author Valdemir Jose
@since 09/06/2021
@return return_type, return_description
/*/
Static Function xProc001()

	Local aFiles        := {}
	Local nX            := 0
    Local cDiv          := ""
	Private aContas     := {}
	Private cIniFile    := GetADV97()
	Private cStartPath  := '\XMLBX\'

	aFiles := Directory(cStartPath + cDiv +"*.xml")
	nXml   := 0
	For nX := 1 To Len(aFiles)
		nXml++
		xProc002(cStartPath + cDiv + aFiles[nX,1])

		//QUANDO TIVER 500 XML SAI DA ROTINA, SENAO ESTOURA O ARRAY DO XML
		If nXml == 500
			Return
		EndIf
	Next nX

Return


/*/{Protheus.doc} xProc002
@description
Rotina que irá Gravar os Dados do Arquivo XML na tabela SZ9
Ticket: 20210707011905
@type function
@version 1.00 
@author Valdemir Jose
@since 09/06/2021
@param pArqXML, param_type, param_description
@return return_
@type return_description
/*/
Static Function xProc002(pArqXML)
    Local _cRet     := ALLTRIM(pArqXML)
	Local cAviso	:= ""
	Local cErro		:= ""
	Local cStatus   := ""
    Local cStatusAtu:= ""
    Local aErrorLog := {}

	nHdl    := fOpen(_cRet,0)

	If nHdl == -1
		Return
	Endif

	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                     // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl, @cBuffer, nTamFile)     // Leitura  do arquivo XML
	fClose(nHdl)

	oDanfe     := XmlParser(cBuffer,"_",@cAviso,@cErro)
	if Type("oDanfe:_NFE")=="O"
		oInterm    := oDanfe:_NFE  
	endif 
	if Type("oDanfe:_NFEPROC")=="O"
		oInterm    := oDanfe:_NFEPROC:_NFE  
	endif 
	
    oImposto   := oInterm:_INFNFE:_TOTAL:_ICMSTOT
    oNFChv     := oInterm:_INFNFE
    oDadosF    := oInterm:_INFNFE
    oIdent     := oInterm:_InfNfe:_IDE
    cChvNfe    := Right(oNFChv:_ID:TEXT,44)
	
	IF u_STXMLVLD(cChvNfe, .T.)
       cStatusAtu := "Ciencia"
	   cStatus   := "0"
	else 
	   cStatusAtu := "Nota fiscal cancelada"
	   cStatus   := "X"
	Endif 
    
    dbSelectArea("SZ9")
    dbSetOrder(1)
    if SZ9->( !dbSeek(xFilial("SZ9")+cChvNfe) )
	   RecLock("SZ9", .T.)
        SZ9->Z9_FILIAL	:= cFilAnt
        SZ9->Z9_NOMFOR	:= oDadosF:_DEST:_XNOME:TEXT
        SZ9->Z9_NFOR    := SZ9->Z9_NOMFOR
        SZ9->Z9_VALORNF	:= Val(oImposto:_VNF:TEXT)
        SZ9->Z9_CHAVE	:= cChvNfe
        SZ9->Z9_SERORI	:= OIdent:_serie:TEXT
        SZ9->Z9_NFEORI	:= PADL(OIdent:_nNF:TEXT,9,"0")
        SZ9->Z9_DTEMIS	:= stod(StrTran(Left(OIdent:_dhEmi:TEXT,10),"-",""))
        SZ9->Z9_CNPJ	:= SUBSTR(cChvNfe,7,14)
        SZ9->Z9_DATA	:= DATE()
        SZ9->Z9_HORA	:= TIME()
        SZ9->Z9_NSU	 	:= ""
        SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+CRLF+"INCLUINDO Chave: "+cChvNfe+" - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()
        SZ9->Z9_STATUS	:= cStatus
        SZ9->Z9_ORIGEM  := "NFE"
        SZ9->Z9_STATUSA	:= cStatusAtu
       MsUnlock()
      
    Endif 

    // Renomeia arquivo
    FRename(pArqXML, pArqXML+".old")

Return 


