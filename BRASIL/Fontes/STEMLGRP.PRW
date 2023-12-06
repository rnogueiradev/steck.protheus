#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Ap5Mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ STMAILTES ³ Autor ³ 	 					³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Exibe as legendas do browse.                                 ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STEMLGRP(_cTipo,_cNum,_aGrupos,_cVend)
	
	Local oMail , oMessage , nErro
	Local lRet := .T.
	Local i    := 0
	Local cSMTPServer	:= GetMV("MV_RELSERV",,"smtp.servername.com.br")
	Local cSMTPUser		:= GetMV("MV_RELAUSR",,"minhaconta@servername.com.br")
	Local cSMTPPass		:= GetMV("MV_RELAPSW",,"minhasenha")
	Local cMailFrom		:= GetMV("MV_RELFROM",,"minhaconta@servername.com.br")
	Local nPort	   		:= GetMV("MV_GCPPORT",,25)
	Local lUseAuth		:= GetMV("MV_RELAUTH",,.T.)
	
	Local cMsg     		:= ""
	Local cCopia   		:= ""
	Local cPara    		:= "ana.oliveira@steck.com.br"
	Local cAssunto 		:= '[PROTHEUS] - Aviso grupos unicon'
	Local _aAttach 		:= {}
	Local	nX:= 0
	cMsg	:= "<b>"+_cTipo+" </b>"+AllTrim(_cNum)+" / <b>Vendedor</b> "+AllTrim(_cVend)+"<br><br>"
	
	For nX:=1 To Len(_aGrupos)
		cMsg	+= " <b>Produto</b> "+AllTrim(_aGrupos[nX][1])+" / <b>Grupo</b> "+AllTrim(_aGrupos[nX][2])+"<br>"
	Next
	
	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	
	oMail := TMailManager():New()
	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	
	conout('Setando Time-Out')
	oMail:SetSmtpTimeOut( 30 )
	
	conout('Conectando com servidor...')
	nErro := oMail:SmtpConnect()
	
	conout('Status de Retorno = '+str(nErro,6))
	
	If lUseAuth
		Conout("Autenticando Usuario ["+cSMTPUser+"] senha ["+cSMTPPass+"]")
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		conout('Status de Retorno = '+str(nErro,6))
		If nErro <> 0
			// Recupera erro ...
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			Conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		Endif
	Endif
	
	if nErro <> 0
		
		// Recupera erro
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		Conout("Erro de Conexão SMTP "+str(nErro,4))
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
		
		lRet := .F.
		
	Endif
	
	If lRet
		conout('Compondo mensagem em memória')
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom	:= cMailFrom
		oMessage:cTo	:= cPara
		If !Empty(cCopia)
			oMessage:cCc	:= cCopia
		Endif
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg
		
		
		For i:= 1 To Len(_aAttach)
			
			//Adiciona um attach
			If oMessage:AttachFile( _cCaminho+_aAttach[i] ) < 0
				Conout( "Erro ao atachar o arquivo" )
				//Return .F.
			Else
				//adiciona uma tag informando que é um attach e o nome do arq
				oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+_aAttach[i])
			EndIf
		Next i
		
		
		conout('Enviando Mensagem para ['+cPara+'] ')
		nErro := oMessage:Send( oMail )
		
		if nErro <> 0
			xError := oMail:GetErrorString(nErro)
			Conout("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Endif
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	Endif
	
Return(lRet)
