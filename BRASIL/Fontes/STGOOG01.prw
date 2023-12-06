#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STGOOG01         | Autor | Renato Nogueira            | Data | 02/10/2016|
|=====================================================================================|
|Descrição | Fonte utilizado para gerar o token do google shopping                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck.                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

/*
Criação dos certificados
http://tdn.totvs.com/pages/releaseview.action?pageId=392502208#deckprincipal-594324048

Appserver config

[Drivers]
Active=TCP
Secure=SSL

[TCP]
TYPE=TCPIP
Port=9094

[SSL]
TYPE=TCPIP
PORT=9097

[SSLConfigure]
SSL2=1
SSL3=1
TLS1=1
TLS1_0=1
TLS1_1=1
TLS1_2=1
CertificateServer=C:\certs\steck2019.crt
KeyServer=C:\certs\steck2019.key
PassPhrase=123456

[HTTPV11]
Enable=1
Sockets=HTTPREST

[HTTPREST]
Port=9095
URIs=HTTPENV1
SECURITY=0
VERBOSE=1
SSL2=1
SSL3=1
TLS1=1
TLS1_0=1
TLS1_1=1
TLS1_2=1
PASSPHRASE=123456
CERTIFICATE=C:\certs\steck2019.crt
KEY=C:\certs\steck2019.key

[HTTPENV1]
URL=/rest
PrepareIn=All
Instances=2,5
CORSEnable=1
AllowOrigin=*
Public=fwjwt/refresh_token,auth
ENVIRONMENT=P12

[HTTPJOB]
MAIN=HTTP_START
ENVIRONMENT=P12

[ONSTART]
jobs=HTTPJOB
RefreshRate=30

[HTTP]
ENABLE=0
PORT=9098

[HTTPS]
Enable=1
Port=9099
VERBOSE=1
SSL2=1
SSL3=1
TLS1=1
TLS1_0=1
TLS1_1=1
TLS1_2=1
PASSPHRASE=123456
CERTIFICATE=C:\certs\steck2019.crt
KEY=C:\certs\steck2019.key

[10.152.4.7:9095/rest]
ENABLE=1
PATH=D:\TOTVS12\Microsiga\Protheus\PROTHEUS_DATA\web\rest
ENVIRONMENT=P12

[RESTCONFIG]
restPort=9095
RefreshTokenTimeout=300

*/

User Function STGOOG01()

	Local aHeadOut  	:= {}
	Local cHeadRet   	:= ""
	Local cCode			:= "4/7QCUoBQO45LjyDeC1KMxWbCgEg7tMKn2Ywd3OLNCXprm7_CxgOL2MHHARIvdJZmUR4gLCREUEuBc4LKlPvO1xvI"
	//Url para gerar o code
	//https://accounts.google.com/o/oauth2/auth?client_id=948232335398-08l1sfkqppolub7iq9gvl51ce6inlj9m.apps.googleusercontent.com&redirect_uri=https://mail2.steck.com.br:9095/html-protheus/rest/stkgooglecalendar&response_type=code&scope=https://www.googleapis.com/auth/calendar.events.readonly&approval_prompt=force&access_type=offline
	Local cUrl    		:= "https://www.googleapis.com/oauth2/v4/token?client_id=948232335398-08l1sfkqppolub7iq9gvl51ce6inlj9m.apps.googleusercontent.com&client_secret=bJ8MWPpt8xR0tQqegk_mcMqq&redirect_uri=https://mail2.steck.com.br:9095/rest/stkgooglecalendar&code="+cCode+"&grant_type=authorization_code"
	Local cUrlRefresh	:= ""
	Local cHttpGet		:= ""
	Local cPostRet		:= ""
	Local nTimeOut   	:= 60
	Local _cItem
	Local _cOrigem		:= ""
	Local _cEmp			:= "01"
	Local _cFil			:= "01"
	Local cToken		:= ""
	Local cExpir		:= ""
	Local _nPosToken	:= 0
	Local _nPosExpi		:= 0
	Local _nPosRefresh	:= 0
	Local _cRefresh		:= 0
	Local oInfo

	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES 'SB1' MODULO 'COM'

	ConOut("[STGOOG01]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	DbselectArea("SX6")
	SX6->(DbSetOrder(1))
	/* Removido\Ajustado - Não executa mais RecLock na X6. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
	If !SX6->(DbSeek( xFilial("SX6") + "FS_HORTOK"))
		SX6->(RecLock("SX6", .T.))
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "FS_HORTOK"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := SX6->X6_DSCSPA  := SX6->X6_DSCENG 	:= 	"Última geração do token google"
		SX6->X6_DESC1   := SX6->X6_DSCSPA1 := SX6->X6_DSCENG1	:=	"Última geração do token google"
		SX6->X6_DESC2   := SX6->X6_DSCSPA2 := SX6->X6_DSCENG2	:=	"Última geração do token google"
		SX6->X6_CONTEUD := SX6->X6_CONTSPA := SX6->X6_CONTENG	:=	""
		SX6->X6_PROPRI  := ""
	EndIf
	SX6->(MsUnlock())

	DbselectArea("SX6")
	SX6->(DbSetOrder(1))
	If !SX6->(DbSeek( xFilial("SX6") + "FS_EXPTOK"))
		SX6->(RecLock("SX6", .T.))
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "FS_EXPTOK"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := SX6->X6_DSCSPA  := SX6->X6_DSCENG 	:= 	"Tempo de expiração do token"
		SX6->X6_DESC1   := SX6->X6_DSCSPA1 := SX6->X6_DSCENG1	:=	"Tempo de expiração do token"
		SX6->X6_DESC2   := SX6->X6_DSCSPA2 := SX6->X6_DSCENG2	:=	"Tempo de expiração do token"
		SX6->X6_CONTEUD := SX6->X6_CONTSPA := SX6->X6_CONTENG	:=	""
		SX6->X6_PROPRI  := ""
	EndIf
	SX6->(MsUnlock())

	DbselectArea("SX6")
	SX6->(DbSetOrder(1))
	If !SX6->(DbSeek( xFilial("SX6") + "FS_TOKGOG"))
		SX6->(RecLock("SX6", .T.))
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "FS_TOKGOG"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := SX6->X6_DSCSPA  := SX6->X6_DSCENG 	:= 	"Token do google"
		SX6->X6_DESC1   := SX6->X6_DSCSPA1 := SX6->X6_DSCENG1	:=	"Token do google"
		SX6->X6_DESC2   := SX6->X6_DSCSPA2 := SX6->X6_DSCENG2	:=	"Token do google"
		SX6->X6_CONTEUD := SX6->X6_CONTSPA := SX6->X6_CONTENG	:=	""
		SX6->X6_PROPRI  := ""
	EndIf
	SX6->(MsUnlock())

	DbselectArea("SX6")
	SX6->(DbSetOrder(1))
	If !SX6->(DbSeek( xFilial("SX6") + "FS_REFGOG"))
		SX6->(RecLock("SX6", .T.))
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "FS_REFGOG"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := SX6->X6_DSCSPA  := SX6->X6_DSCENG 	:= 	"Refresh Token do google"
		SX6->X6_DESC1   := SX6->X6_DSCSPA1 := SX6->X6_DSCENG1	:=	"Refresh Token do google"
		SX6->X6_DESC2   := SX6->X6_DSCSPA2 := SX6->X6_DSCENG2	:=	"Refresh Token do google"
		SX6->X6_CONTEUD := SX6->X6_CONTSPA := SX6->X6_CONTENG	:=	""
		SX6->X6_PROPRI  := ""
	EndIf
	SX6->(MsUnlock())

	DbselectArea("SX6")
	SX6->(DbSetOrder(1))
	If !SX6->(DbSeek( xFilial("SX6") + "FS_DATGOG"))
		SX6->(RecLock("SX6", .T.))
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "FS_DATGOG"
		SX6->X6_TIPO    := "D"
		SX6->X6_DESCRIC := SX6->X6_DSCSPA  := SX6->X6_DSCENG 	:= 	"Data geração do token google"
		SX6->X6_DESC1   := SX6->X6_DSCSPA1 := SX6->X6_DSCENG1	:=	"Data geração do token google"
		SX6->X6_DESC2   := SX6->X6_DSCSPA2 := SX6->X6_DSCENG2	:=	"Data geração do token google"
		SX6->X6_CONTEUD := SX6->X6_CONTSPA := SX6->X6_CONTENG	:=	""
		SX6->X6_PROPRI  := ""
	EndIf
	SX6->(MsUnlock())*/

	Do Case

		Case Empty(GetMv("FS_TOKGOG")) //Primeira geração

		cPostRet 		:= HTTPSPost( cURL , "" , "" , "" , "" , "" , nTimeOut , aHeadOut, @cHeadRet )
		_lRet    		:= FWJsonDeserialize(cPostRet,@oInfo)

		If _lRet
			cToken		:= oInfo:ACCESS_TOKEN
			cExpir		:= oInfo:EXPIRES_IN
			_cRefresh	:= oInfo:REFRESH_TOKEN
			PUTMV("FS_TOKGOG",cToken)
			PUTMV("FS_EXPTOK",cExpir)
			PUTMV("FS_HORTOK",Time())
			PUTMV("FS_DATGOG",Date())
			PUTMV("FS_REFGOG",_cRefresh)
		EndIf

		Case !Empty(GetMv("FS_TOKGOG")) //Atualização de token

		cToken		:= GetMv("FS_TOKGOG")
		cRefresh	:= GetMv("FS_REFGOG")

		If Time()>IncTime(GetMv("FS_HORTOK"),,,Val(GetMv("FS_EXPTOK"))) .Or. !(Date()==GetMv("FS_DATGOG")) //Verificar se token expirou

			cUrlRefresh	:= "https://www.googleapis.com/oauth2/v4/token?client_id=948232335398-08l1sfkqppolub7iq9gvl51ce6inlj9m.apps.googleusercontent.com&client_secret=bJ8MWPpt8xR0tQqegk_mcMqq&redirect_uri=https://mail2.steck.com.br:9095/rest/stkgooglecalendar&grant_type=refresh_token&refresh_token="+cRefresh
			cPostRet := HTTPSPost( cUrlRefresh , "" , "" , "" , "" , "" , nTimeOut , aHeadOut, @cHeadRet )
			_lRet    := FWJsonDeserialize(cPostRet,@oInfo)
			//aHttpGet	:= FromJson(cPostRet)
			//_nPosRefresh	:= aScan(aHttpGet:aData,{|x| UPPER(ALLTRIM(x[1])) == 'REFRESH_TOKEN' })

			If _lRet
				cToken	:= oInfo:ACCESS_TOKEN
				cExpir	:= oInfo:EXPIRES_IN
				//_cRefresh	:= aHttpGet:aData[_nPosRefresh][2]
				PUTMV("FS_TOKGOG",cToken)
				PUTMV("FS_EXPTOK",cExpir)
				PUTMV("FS_HORTOK",Time())
				PUTMV("FS_DATGOG",Date())
				//PUTMV("FS_REFGOG",_cRefresh)
			EndIf

		EndIf

	EndCase
	
	ConOut("[STGOOG01]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return(cToken)
