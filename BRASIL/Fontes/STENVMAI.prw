#include 'PROTHEUS.CH'
#include 'TOPCONN.CH'
#include 'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STENVMAI	ºAutor  ³Renato Nogueira     º Data ³  01/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para enviar email dos chamados pendentes de º±±
±±º          ³aprovação do usuário				  	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum 										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STENVMAI()
	
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local aUsuario	:= {}
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ''
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cCodigo	:= ""
	
	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")
	
	cQuery	:= " SELECT Z0_NUM, Z0_USUARIO, Z0_DESCRI , Z0_DTENTRE, R_E_C_N_O_ AS REC "
	cQuery	+= " FROM SZ0010 "
	cQuery	+= " WHERE D_E_L_E_T_=' ' AND Z0_STATUS='5' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	While (cAlias)->(!Eof())
		
		_cCodigo	:= ""
		
		PswOrder(2) // Ordem de nome
		
		If PswSeek((cAlias)->Z0_USUARIO,.T.)
			aUsuario := PSWRET()
			_cCodigo := aUsuario[1][1]
		EndIf
		
		If !Empty(_cCodigo)
			_cEmail	  := UsrRetMail(_cCodigo)
		Else
			_cEmail	  := ""
		EndIf
		
		_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - está aguardando sua interação, favor verificar!'
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Descrição: </b>'+(cAlias)->Z0_DESCRI+'<br><br><b>Procedimento para aprovar</b><br>1. Logar no protheus<br>2. Acessar a rotina de chamados<br>3. Posicionar no chamado descrito no e-mail<br>4. Clicar em ações relacionadas<br>5. Selecionar a opção Aprovar/Reprovar e confirmar<br>'
		If Stod((cAlias)->Z0_DTENTRE) < (DDATABASE-05)
			_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - está aguardando sua interação, favor verificar!'
			cMsg += '<b>CHAMADOS COM MAIS DE 2 DIAS, SEM INTERAÇÃO, SERÃO ENCERRADOS E NAO SERÃO DISPONIBILIZADOS EM PRODUÇÃO</b></body></html>'
		Else
			cMsg += '</body></html>'
		EndIf
		If Stod((cAlias)->Z0_DTENTRE) < (DDATABASE-2)
			_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - será cancelado por falta de interação, favor verificar!'
		EndIf
		If Stod((cAlias)->Z0_DTENTRE) < (DDATABASE-3)
			_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - está cancelado por falta de interação !'
			DbSelectArea("SZ0")
			SZ0->(DbGoTo((cAlias)->REC ))
			If (cAlias)->REC    = SZ0->(RECNO())
				SZ0->(RecLock("SZ0",.F.))
				SZ0->Z0_STATUS	:= "X"
				SZ0->Z0_ACEITE 	:= "N"
				SZ0->(MsUnlock())
				SZ0->(DbCommit())
			EndIf
		EndIf
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		
		(cAlias)->(DbSkip())
	EndDo
	
	cQuery	:= " SELECT Z0_NUM, Z0_APROV, Z0_DESCRI "
	cQuery	+= " FROM SZ0010 "
	cQuery	+= " WHERE D_E_L_E_T_=' ' AND Z0_STATUS='1' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	While (cAlias)->(!Eof())
		
		_cEmail	  := UsrRetMail((cAlias)->Z0_APROV)
		_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - está aguardando sua interação, favor verificar!'
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Descrição: </b>'+(cAlias)->Z0_DESCRI+'<br><br><b>Procedimento para aprovar</b><br>1. Logar no protheus<br>2. Acessar a rotina de chamados<br>3. Posicionar no chamado descrito no e-mail<br>4. Clicar em ações relacionadas<br>5. Selecionar a opção Aprovar/Reprovar e confirmar</body></html>'
		
		 U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	 
		
		(cAlias)->(DbSkip())
	EndDo
	
	
	Reset Environment
	
Return()
