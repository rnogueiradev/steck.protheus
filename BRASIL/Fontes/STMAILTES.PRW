#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#DEFINE CR    chr(13)+ chr(10)


User Function STMAILTES(cPara, cCopia, cAssunto, cMsg,_aAttach,_cCaminho,_cCo)

	Local _cAttach 	:= ' '
	Local i 		:= 0
	Local _cDate     	:= dToc(DATE())
	Default cMsg     := "<hr>Envio de e-mail via Protheus<hr>"
	Default cCopia   := ""
	Default cPara    := ''
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

User Function STSX1S1B(cPerg)

	Local _cRetSx1 := ' '
	Local _cSx1    := ' '

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg)) .And. GetMv("ST_SX1S1B",,.T.)
		While SX1->(!Eof()) .AND. Alltrim(SX1->X1_GRUPO) == cPerg
			If SX1->X1_TIPO = 'N'
				If !(Empty(Alltrim( SX1->X1_PICTURE)))
					_cSx1    := Transform( &(Upper(SX1->X1_VAR01)) , SX1->X1_PICTURE)
				ElseIf SX1->X1_GSC = 'C'
					If &(Upper(SX1->X1_VAR01)) = 1
						_cSx1    := '1- '+SX1->X1_DEF01
					ElseIf &(Upper(SX1->X1_VAR01)) = 2
						_cSx1    := '2- '+SX1->X1_DEF02
					ElseIf &(Upper(SX1->X1_VAR01)) = 3
						_cSx1    := '3- '+SX1->X1_DEF03
					ElseIf &(Upper(SX1->X1_VAR01)) = 4
						_cSx1    := '4- '+SX1->X1_DEF04
					ElseIf &(Upper(SX1->X1_VAR01)) = 5
						_cSx1    := '5- '+SX1->X1_DEF05
					EndIf
				Else
					_cSx1    :=  cValtochar( &(Upper(SX1->X1_VAR01)))
				EndIf
			ElseIf SX1->X1_TIPO = 'D'
				_cSx1    :=  dToc( &(Upper(SX1->X1_VAR01)))
			Else
				_cSx1    :=   &(Upper(SX1->X1_VAR01))
			EndIf
			_cRetSx1+=  Alltrim(SX1->X1_ORDEM)+ '  '+Alltrim(SX1->X1_PERGUNT)  + '  '+ _cSx1 + CR
			SX1->(DbSkip())
		Enddo
	EndIf

Return(_cRetSx1)

User Function FILA11()
	U_FILAZZ("11","01")
Return()

User Function FILAGG()
	U_FILAZZ("03","01")
Return()

User Function FILAXX()
	U_FILAZZ("01","01")
Return()

User Function FILAZZ(_cEmp,_cFil)

	Local lRet 			:= .T.
	Local i    			:= 0
	Local cSMTPServer	:= ''
	Local cSMTPUser		:= ''
	Local cSMTPPass		:= ''
	Local cMailFrom		:= ''
	Local nPort	   		:= 0
	Local lUseAuth		:= .T.
	Local cPerg 		:= "STZ1A11"
	Local cTime       	:= ' '
	Local cHora       	:= ' '
	Local cMinutos    	:= ' '
	Local cSegundos   	:= ' '
	Local cAliasLif   	:= ' '
	Local cQuery     	:= ' '
	Local _cDate     	:= dToc(DATE())

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	cAliasLif   	:= GetNextAlias()

	cQuery := " SELECT Z1A.R_E_C_N_O_ REC, Z1A_NUM
	cQuery += " FROM "+RetSqlName("Z1A")+" Z1A WHERE Z1A.D_E_L_E_T_ = ' ' AND Z1A_Q1 =1 AND  Z1A_Q2 = 0
	cQuery += " ORDER BY R_E_C_N_O_

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	_nX := GetMv("STMAILTES2",,11)

	Conout("Numero de threads: "+cvaltochar(_nX))

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())

		While !(cAliasLif)->(Eof())

			//Sleep(10000) //aguardar alguns segundos para dar tempo de chamar o job antes de começar o proximo cliente

			aInfo := GetUserInfoArray()

			If Len(aInfo)>=_nX
				Return()
			EndIf

			StartJob("U_FILAOK",GetEnvServer(),.F.,(cAliasLif)->REC,_cEmp,_cFil)

			(cAliasLif)->(dbSkip())
		End
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	Reset Environment
Return(lRet)

User Function FILAOK(_nRecno,_cEmp,_cFil)

	Local _cDate     	:= dToc(DATE())
	Local _aAttach := {}
	Local i
	Local lRet 			:= .T.

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	cSMTPServer		:= AllTrim(GetMV("MV_RELSERV",,"smtp.servername.com.br"))
	cSMTPUser		:= AllTrim(GetMV("MV_RELAUSR",,"minhaconta@servername.com.br"))
	cSMTPPass		:= AllTrim(GetMV("MV_RELAPSW",,"minhasenha"))
	cMailFrom		:= AllTrim(GetMV("MV_RELFROM",,"minhaconta@servername.com.br"))
	nPort	   		:= GetMV("MV_GCPPORT",,25)
	lUseAuth		:= GetMV("MV_RELAUTH",,.T.)

	Conout(cSMTPServer)
	Conout(cSMTPUser)
	Conout(cSMTPPass)
	Conout(cMailFrom)
	Conout(nPort)
	Conout(lUseAuth)

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
			Conout("Erro de autenticacao: "+cMAilError)
		Endif
	Endif

	If nErro <> 0

		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		oMail:SMTPDisconnect()
		lRet := .F.

	Endif

	If !lRet
		Conout("Problema de autenticação")
		RETURN
	endIf

	_cLockBy		:= "FILA"+_cEmp+_cFil+cValToChar(_nRecno,_cEmp,_cFil)

	If !LockByName(_cLockBy,.F.,.F.,.T.)
		Return()
	EndIf

	DbSelectArea("Z1A")
	Z1A->(DbGoTo(_nRecno))
	If _nRecno = Z1A->(RECNO()) .And. Z1A->Z1A_Q2 = 0

		conout("iniciando "+AllTrim(Z1A->Z1A_NUM))

		cMsg     := Z1A->Z1A_CORPO
		cCopia   := Z1A->Z1A_CC
		cPara    := Z1A->Z1A_PARA
		cAssunto := Z1A->Z1A_ASSUNT
		_cCo     := Z1A->Z1A_CCO
		If Empty(Alltrim(cPara)) .And. Empty(Alltrim(cCopia))
			Z1A->(RecLock("Z1A",.F.))
			Z1A->Z1A_LOG		:= Alltrim(Z1A->Z1A_LOG)+ CR +'ERRO NO ENVIO: SEM EMAIL CADASTRADO '+ _cDate+' - '+ TIME()+' - JOB -  '  + CR
			Z1A->Z1A_Q1			:= Z1A->Z1A_Q2
			Z1A->(DBDELETE())
			Z1A->(MsUnlock())
			Z1A->( DbCommit() )

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

				If File(Alltrim(_aAttach[i]))

					If !(oMessage:AttachFile(  Alltrim(_aAttach[i]) ) < 0)
						oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+ Alltrim(_aAttach[i]))
					EndIf

				EndIf

			Next i

			nErro := oMessage:Send( oMail )

			If nErro <> 0
				xError := oMail:GetErrorString(nErro)
				Z1A->(RecLock("Z1A",.F.))
				Z1A->Z1A_LOG		:=  Alltrim(Z1A->Z1A_LOG)+ CR +'ERRO NO ENVIO: '+ _cDate+' - '+ TIME()+' - JOB -  '  + CR + ' Erro: '+CVALTOCHAR(nErro)+ CR + aLLTRIM(xError)
				If Z1A->Z1A_INTERV = 3
					Z1A->Z1A_Q1			:= Z1A->Z1A_Q2
				Else
					Z1A->Z1A_INTERV+=1
				EndIf
				Z1A->(MsUnlock())
				Z1A->( DbCommit() )

				Conout("Erro de envio: "+cValToChar(nErro))
				Conout("Erro de envio: "+cValToChar(xError))

			Else
				Z1A->(RecLock("Z1A",.F.))
				Z1A->Z1A_LOG		:=   Alltrim(Z1A->Z1A_LOG)+ CR +'ENVIO: '+ _cDate+' - '+ TIME()+' - JOB -  '  + CR
				Z1A->Z1A_Q2			:= Z1A->Z1A_Q2 + 1
				Z1A->(MsUnlock())
				Z1A->( DbCommit() )
				Conout("Enviado com sucesso")

			EndIf
		EndIf

		conout("finalizado "+AllTrim(z1a->z1a_num))

	EndIf

	UnLockByName(_cLockBy,.F.,.F.,.T.)

	oMail:SMTPDisconnect()

Return()
