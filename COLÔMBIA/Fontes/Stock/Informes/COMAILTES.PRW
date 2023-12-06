#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#DEFINE CR    chr(13)+ chr(10)
/*====================================================================================\
|Programa  | COMAILTES        | Autor | GIOVANI.ZAGO             | Data | 24/03/2017  |
|=====================================================================================|
|Descrição | COMAILTES    FILA DE EMAIL                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | COMAILTES                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------------------------------------------------------*
User Function COMAILTES(cPara, cCopia, cAssunto, cMsg,_aAttach,_cCaminho,_cCo)
	*-----------------------------------------------------------------------------*
	Local _cAttach 	:= ' '
	Local i 		:= 0
	Local _cDate     	:= dToc(DATE())
	Default cMsg     := "<hr>Envio de e-mail via Protheus<hr>"
	Default cCopia   := ""
	Default cPara    := 'giovani.zago@steck.com.br'
	Default cAssunto := 'Envio de Teste'
	Default _aAttach := {}
	Default _cCo     := ""
	Default _cCaminho:= ""

	If GetMv("ST_Z1A",,.T.)//GRAVA TABELA Z1A FILA DE ENVIO DE WF

		For i:= 1 To Len(_aAttach)
			If i=1
				_cAttach := _cCaminho + _aAttach[i]
			Else
				_cAttach += ' /#/ ' + _cCaminho + _aAttach[i]
			EndIf
		Next i

		DbSelectArea("Z1A")

		Z1A->(RecLock("Z1A",.T.))

		Z1A->Z1A_FILIAL		:= cfilant
		Z1A->Z1A_NUM		:= GetSxeNum("Z1A", "Z1A_NUM")
		Z1A->Z1A_DATA		:= DATE()
		Z1A->Z1A_HORA		:= TIME()
		Z1A->Z1A_TABELA		:= ' '
		Z1A->Z1A_RECTAB		:= 0
		Z1A->Z1A_USUARI		:= __cUserId
		Z1A->Z1A_NUSUAR		:= cUserName
		Z1A->Z1A_PARA		:= cPara
		Z1A->Z1A_CC			:= cCopia
		Z1A->Z1A_CCO		:= _cCo
		Z1A->Z1A_ASSUNT		:= cAssunto
		Z1A->Z1A_CORPO 		:= cMsg
		Z1A->Z1A_Q1			:= 1
		Z1A->Z1A_Q2			:= 0
		Z1A->Z1A_ANEXOS		:= _cAttach
		Z1A->Z1A_LOG		:= 'INCLUSAO: '+ _cDate+' - '+ TIME()+' - '+ __cUserId  +' - '+ cUserName +' - '+ Upper(FunName()) + CR
		Z1A->Z1A_INTERV		:= 0

		Z1A->(MsUnlock())
		Z1A->(DbCommit())
		ConfirmSX8()

	EndIf

Return(.t.)

User Function FILA09()

	Local oMail , oMessage , nErro
	Local lRet 			:= .T.
	Local i    			:= 0
	Local cSMTPServer	:= ''
	Local cSMTPUser		:= ''
	Local cSMTPPass		:= ''
	Local cMailFrom		:= ''
	Local nPort	   		:= 0
	Local lUseAuth		:= .T.
	Local _aArea  		:= GetArea()
	Local cPerg 		:= "STZ1A08"
	Local cTime       	:= ' '
	Local cHora       	:= ' '
	Local cMinutos    	:= ' '
	Local cSegundos   	:= ' '
	Local cAliasLif   	:= ' '
	Local cQuery     	:= ' '
	Local _cProd      	:= ' '
	Local _nx         	:= 0
	Local cMsg     		:= "<hr>Envio de e-mail via Protheus<hr>"
	Local cCopia   		:= ""
	Local cPara    		:= 'giovani.zago@steck.com.br'
	Local cAssunto 		:= 'Envio de Teste'
	Local _aAttach 		:= {}
	Local _cCo     		:= ""
	Local _cDate     	:= dToc(DATE())

	RpcSetType( 3 )
	RpcSetEnv("09","01",,,"FAT")

	//PREPARE ENVIRONMENT EMPRESA '03' FILIAL '01'

	If !LockByName("FILA09",.F.,.F.,.T.)
		//ConOut("[FILA01]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	If dow(date())= 1  .Or. dow(date())= 7 //domingo ---- sabado
		Return(.t.)
	EndIf

	cTime           := Time()
	cHora           := SUBSTR(cTime, 1, 2)
	cMinutos    	:= SUBSTR(cTime, 4, 2)
	cSegundos   	:= SUBSTR(cTime, 7, 2)
	cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	cSMTPServer		:= GetMV("MV_RELSERV",,"smtp.servername.com.br")
	cSMTPUser		:= GetMV("MV_RELAUSR",,"minhaconta@servername.com.br")
	cSMTPPass		:= GetMV("MV_RELAPSW",,"minhasenha")
	cMailFrom		:= GetMV("MV_RELFROM",,"minhaconta@servername.com.br")
	nPort	   		:= GetMV("MV_GCPPORT",,25)
	lUseAuth		:= GetMV("MV_RELAUTH",,.T.)

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
		Endif
	Endif

	if nErro <> 0

		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		oMail:SMTPDisconnect()
		lRet := .F.

	Endif

	_cQuery1 := " UPDATE Z1A090 Z1A
	_cQuery1 += " SET Z1A.Z1A_Q1=1
	_cQuery1 += " WHERE Z1A.D_E_L_E_T_=' ' AND Z1A_DATA='"+DTOS(Date())+"' AND Z1A_Q1=0 AND Z1A_Q2=0

	TcSqlExec(_cQuery1)

	If lRet

		cQuery := " SELECT Z1A.R_E_C_N_O_
		cQuery += ' "REC"
		cQuery += " FROM Z1A090 Z1A WHERE Z1A.D_E_L_E_T_ = ' ' AND Z1A_Q1 =1 and  Z1A_Q2 = 0 ORDER BY R_E_C_N_O_ DESC

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())

			While !(cAliasLif)->(Eof())
				nErro := 0

				DbSelectArea("Z1A")
				Z1A->(DbGoTo((cAliasLif)->REC ))
				If (cAliasLif)->REC = Z1A->(RECNO()) .And. Z1A->Z1A_Q2 = 0
					cMsg     := Z1A->Z1A_CORPO
					cCopia   := Z1A->Z1A_CC
					cPara    := Z1A->Z1A_PARA
					cAssunto := Z1A->Z1A_ASSUNT
					_cCo     := Z1A->Z1A_CCO
					If Empty(Alltrim(cPara)) .And. Empty(Alltrim(cCopia))
						Z1A->(RecLock("Z1A",.F.))
						Z1A->Z1A_LOG		:= Alltrim(Z1A->Z1A_LOG)+ CR +' ERRO NO ENVIO: SEM EMAIL CADASTRADO '+ _cDate+' - '+ TIME()+' - JOB -  '  + CR
						Z1A->Z1A_Q1			:= Z1A->Z1A_Q2
						Z1A->(DBDELETE())
						Z1A->(MsUnlock())
					Else
						_aAttach := {}
						If At("/#/",Z1A->Z1A_ANEXOS) > 0
							_aAttach :=StrTokArr( Z1A->Z1A_ANEXOS, '/#/' )
						ElseIf !(Empty(Alltrim(Z1A->Z1A_ANEXOS)))

							aadd(_aAttach,Z1A->Z1A_ANEXOS)
						EndIf

						oMessage:= TMailMessage():New()
						oMessage:Clear()
						oMessage:cFrom	:= cMailFrom
						oMessage:cTo	:= cPara
						oMessage:cBcc   := _cCo+";"+GetMv("ST_MAILBAC",,' ')
						If !Empty(cCopia)
							oMessage:cCc	:= cCopia
						Endif
						oMessage:cSubject	:= cAssunto
						oMessage:cBody		:= cMsg

						For i:= 1 To Len(_aAttach)

							If !(oMessage:AttachFile(  Alltrim(_aAttach[i]) ) < 0)
								oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+ Alltrim(_aAttach[i]))
							EndIf
						Next i

						nErro := oMessage:Send( oMail )

						If nErro <> 0
							xError := oMail:GetErrorString(nErro)
							Z1A->(RecLock("Z1A",.F.))
							Z1A->Z1A_LOG		:=  Alltrim(Z1A->Z1A_LOG)+ CR +'ERRO NO ENVIO: '+ _cDate+' - '+ TIME()+' - JOB -  '  + CR + 'Erro: '+Cvaltochar(nErro)+ CR + aLLTRIM(xError)
							If Z1A->Z1A_INTERV = 1
								Z1A->Z1A_Q1:= Z1A->Z1A_Q2
							Else
								Z1A->Z1A_INTERV+= 1
							EndIf
							Z1A->(MsUnlock())
							Z1A->( DbCommit() )
							Exit
						Else
							Z1A->(RecLock("Z1A",.F.))
							Z1A->Z1A_LOG		:=  Alltrim(Z1A->Z1A_LOG)+ CR +'ENVIO: '+ _cDate+' - '+ TIME()+' - JOB -  '  + CR
							Z1A->Z1A_Q2			:= Z1A->Z1A_Q2 + 1
							Z1A->(MsUnlock())
							Z1A->( DbCommit() )

						EndIf
					EndIf
				EndIf

				(cAliasLif)->(dbSkip())
			End
		EndIf

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		oMail:SMTPDisconnect()
	Endif
	UnLockByName("FILA09",.F.,.F.,.T.)
	Reset Environment
	
Return(lRet)
