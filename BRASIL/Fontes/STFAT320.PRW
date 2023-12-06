#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT320        | Autor | RENATO.OLIVEIRA           | Data | 29/11/2019  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT320()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	If !LockByName("STFAT320",.F.,.F.,.T.)
		ConOut("[STFAT320]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STFAT320]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If SM0->M0_CODIGO$"01#03#07#08" .And. AllTrim(SM0->M0_CODFIL)=="01"
			ConOut(CRLF + "[STFAT320]["+ FWTimeStamp(2) +"] Inicio do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
			StartJob("U_STFAT321",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			ConOut(CRLF + "[STFAT320]["+ FWTimeStamp(2) +"] Fim do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
		EndIf
		SM0->(DbSkip())
	EndDo

	ConOut("[STFAT320]["+ FWTimeStamp(2) +"] Fim do processamento")

	UnLockByName("STFAT320",.F.,.F.,.T.)

	Reset Environment

Return()

/*====================================================================================\
|Programa  | STFAT321        | Autor | RENATO.OLIVEIRA           | Data | 29/11/2019  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT321(cNewEmp,cNewFil)

	Local lRet := .F.
	Default cNewEmp := "01"
	Default cNewFil := "01"

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	cSMTPServer		:= GetMV("MV_RELSERV",,"smtp.servername.com.br")
	cSMTPUser		:= GetMV("MV_RELAUSR",,"minhaconta@servername.com.br")
	cSMTPPass		:= GetMV("MV_RELAPSW",,"minhasenha")
	cMailFrom		:= GetMV("MV_RELFROM",,"minhaconta@servername.com.br")
	nPort	   		:= GetMV("MV_GCPPORT",,25)
	lUseAuth		:= GetMV("MV_RELAUTH",,.T.)
	/*
	oMail := TMailManager():New()
	oMail:SetUseTLS(.T.)
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	oMail:SetSmtpTimeOut( 30 )
	nErro := oMail:SmtpConnect()

	If lUseAuth
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		If nErro <> 0
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			lRet := .F.
		EndIf
	EndIf

	If nErro <> 0
		cMAilError := oMail:GetErrorString(nErro)
		Default cMailError := '***UNKNOW***'
		oMail:SMTPDisconnect()
		lRet := .F.
	EndIf

	oMessage:= TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom		:= cMailFrom
	oMessage:cTo		:= GetMv("STFAT3201",,"renato.oliveira@steck.com.br")
	oMessage:cBcc   	:= ""
	oMessage:cSubject	:= "Teste de envio - Empresa "+cEmpAnt
	oMessage:cBody		:= "OK"

	nErro := oMessage:Send( oMail )

	If nErro <> 0
		xError := oMail:GetErrorString(nErro)
		lRet := .F.
	Else
		lRet := .T.
	EndIf
	*/
	//If !lRet
		If AllTrim(GetMv("MV_EMCONTA",,""))=="wfprotheus@steck.com.br"
			_cEmail := "wfprotheus2@steck.com.br"
			PutMv("MV_EMCONTA",_cEmail)
			PutMv("MV_RELACNT",_cEmail)
			PutMv("MV_RELAUSR",_cEmail)
			PutMv("MV_RELFROM",_cEmail)
			//PutMv("MV_RHCONTA",_cEmail)
			PutMv("MV_WFACC",_cEmail)
			PutMv("MV_WFMAIL",_cEmail)
			PutMv("ST_MAILVEN",_cEmail)
		ElseIf AllTrim(GetMv("MV_EMCONTA",,""))=="wfprotheus2@steck.com.br"
			_cEmail := "wfprotheus3@steck.com.br"
			PutMv("MV_EMCONTA",_cEmail)
			PutMv("MV_RELACNT",_cEmail)
			PutMv("MV_RELAUSR",_cEmail)
			PutMv("MV_RELFROM",_cEmail)
			//PutMv("MV_RHCONTA",_cEmail)
			PutMv("MV_WFACC",_cEmail)
			PutMv("MV_WFMAIL",_cEmail)
			PutMv("ST_MAILVEN",_cEmail)
		ElseIf AllTrim(GetMv("MV_EMCONTA",,""))=="wfprotheus3@steck.com.br"
			_cEmail := "wfprotheus4@steck.com.br"
			PutMv("MV_EMCONTA",_cEmail)
			PutMv("MV_RELACNT",_cEmail)
			PutMv("MV_RELAUSR",_cEmail)
			PutMv("MV_RELFROM",_cEmail)
			//PutMv("MV_RHCONTA",_cEmail)
			PutMv("MV_WFACC",_cEmail)
			PutMv("MV_WFMAIL",_cEmail)
			PutMv("ST_MAILVEN",_cEmail)
		ElseIf AllTrim(GetMv("MV_EMCONTA",,""))=="wfprotheus4@steck.com.br"
			_cEmail := "wfprotheus@steck.com.br"
			PutMv("MV_EMCONTA",_cEmail)
			PutMv("MV_RELACNT",_cEmail)
			PutMv("MV_RELAUSR",_cEmail)
			PutMv("MV_RELFROM",_cEmail)
			//PutMv("MV_RHCONTA",_cEmail)
			PutMv("MV_WFACC",_cEmail)
			PutMv("MV_WFMAIL",_cEmail)
			PutMv("ST_MAILVEN",_cEmail)
		EndIf
	//EndIf

Return()

User Function STFAT322()

	StartJob("U_STFAT321",GetEnvServer(),.T.,"11","01")

Return()
