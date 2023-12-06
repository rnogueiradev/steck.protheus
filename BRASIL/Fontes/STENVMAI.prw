#include 'PROTHEUS.CH'
#include 'TOPCONN.CH'
#include 'TBICONN.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STENVMAI	�Autor  �Renato Nogueira     � Data �  01/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para enviar email dos chamados pendentes de ���
���          �aprova��o do usu�rio				  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum 										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		
		_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - est� aguardando sua intera��o, favor verificar!'
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Descri��o: </b>'+(cAlias)->Z0_DESCRI+'<br><br><b>Procedimento para aprovar</b><br>1. Logar no protheus<br>2. Acessar a rotina de chamados<br>3. Posicionar no chamado descrito no e-mail<br>4. Clicar em a��es relacionadas<br>5. Selecionar a op��o Aprovar/Reprovar e confirmar<br>'
		If Stod((cAlias)->Z0_DTENTRE) < (DDATABASE-05)
			_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - est� aguardando sua intera��o, favor verificar!'
			cMsg += '<b>CHAMADOS COM MAIS DE 2 DIAS, SEM INTERA��O, SER�O ENCERRADOS E NAO SER�O DISPONIBILIZADOS EM PRODU��O</b></body></html>'
		Else
			cMsg += '</body></html>'
		EndIf
		If Stod((cAlias)->Z0_DTENTRE) < (DDATABASE-2)
			_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - ser� cancelado por falta de intera��o, favor verificar!'
		EndIf
		If Stod((cAlias)->Z0_DTENTRE) < (DDATABASE-3)
			_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - est� cancelado por falta de intera��o !'
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
		_cAssunto := 'O chamado Protheus: '+(cAlias)->Z0_NUM+' - est� aguardando sua intera��o, favor verificar!'
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Descri��o: </b>'+(cAlias)->Z0_DESCRI+'<br><br><b>Procedimento para aprovar</b><br>1. Logar no protheus<br>2. Acessar a rotina de chamados<br>3. Posicionar no chamado descrito no e-mail<br>4. Clicar em a��es relacionadas<br>5. Selecionar a op��o Aprovar/Reprovar e confirmar</body></html>'
		
		 U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	 
		
		(cAlias)->(DbSkip())
	EndDo
	
	
	Reset Environment
	
Return()
