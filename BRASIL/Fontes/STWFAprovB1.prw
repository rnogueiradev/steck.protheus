#Include "TOPCONN.CH"
#Include "AP5MAIL.CH"
#Include "TBICONN.CH"
#Include "PROTHEUS.CH"

/*/{Protheus.doc} STWFAprovB1
WorkFlow de altera��o da SB1 via HTTPRET
@type function
@author thiago.fonseca
@since 06/10/2016
@version 1.0
@param nOpc, num�rico, (Descri��o do par�metro)
@param oWF, objeto, (Descri��o do par�metro)
@param _aCampos, array, (Descri��o do par�metro)
@return ${return}, ${return_description}
/*/

User Function STWFAprovB1( nOpc, oWF, _aCampos )

Local aArea      := GetArea()
Local lRet 		 := .T.
Local nI         := 0
Local cObs     	 := ''
Local cWFID      := ''
Local eMailApv	 := ''
Local oHTML		 := NIL
Local cAprov	 := AllTrim( SuperGetMV( 'ST_WFLAPR', , 'thiago.fonseca@steck.com.br') )
Local cOpc		 := ""
Local cHtmlMod   := AllTrim( SuperGetMV( 'ST_WFOKSB1', , '\Workflow\Modelos\Sb1Aprovac.html' ) )
Local cDirHTTP	 := AllTrim( SuperGetMV( 'ST_SB1HTTP', , '\web\ws' ) )
Local cUrlWF 	 := ""
Local cMailID    := " "
Local cAssunto	:= ""
Local cHtmlAction	:= ""


//Valida conte�do dos par�metros necess�rios ao envio da solicita��o
If lRet .And. !File( cHTMLMod )
	lRet := .F.
	Help(" ",1,"WFAPROVB1",,"Modelo de WORFLOW n�o encontrado, verifique par�metro ST_WFOKSB1." + "'",1,0)
EndIf

If lRet .And. !ExistDir( cDirHTTP )
	lRet := .F.
	Help(" ",1,"WFAPROVB1_3",,"Diret�rio do servidor HTTP n�o encontrado, verifique par�metro ST_SB1HTTP." + "'",1,0)
EndIf

//������������������������Ŀ
//� Envio do WF - nOpc = 1 �
//��������������������������
If lRet
	If nOpc == 1

		Conout( "[WF:ENVIO DE WORKFLOW ALTERA��O SB1]" )

		//obtem o url que vai no link via e-mail
		//cUrlWF 	    := AllTrim( SuperGetMV( "ST_B1URL", , "http://10.152.4.17:99/ws/" ) )
		cHtmlAction := If( cUrlWF == "", "http://10.152.4.17:99/ws/WFHTTPRET.APL", cUrlWF + "WFHTTPRET.APL" )
		cAssunto    := "Altera��o na SB1  -  Produto: " + Alltrim(_aCampos[1][2])+ " - " + Alltrim(_aCampos[1][1])

		//codigo e email do aprovador
		//cAprov	 := _aCampos[2]
		eMailApv := cAprov

		If Right( cUrlWF, 1) != "/"
			cUrlWF += "/"
		EndIF

		//inicia a classe TWFProcess e assinala a vari�vel objeto oProcess
		oWF := TWFProcess():New( '100100' , cAssunto)

		//cria uma tarefa
		oWF:NewTask( '100100' , cHtmlMod  )
		oWF:cSubject := cAssunto


		If Empty( eMailApv )
			ConOut( "Nao h� e-mail cadastrado para envio da solicita��o de aprova��o!" + CRLF + "Aprovador" + ": " + cAprov + CRLF + "---" + ": " + _aCampos[1][1] )
			oWF:Track( '100100', "---" + CRLF + "---" + ": " + cAprov + CRLF + "---" + ": " + _aCampos[1][1], cAprov )
		Else

			oWF:cTo			:= eMailApv
			oWF:UserSiga	:= __cUserId
			cWFID			:= oWF:fProcessID + oWF:fTaskId
			oHtml			:= oWF:oHTML

			//Cabe�alho da solicita��o
			oHtml:ValByName( 'cHtmlAction', cHtmlAction )

			oHtml:ValByName( 'WB1_COD'	, _aCampos[1][1]	)
			oHtml:ValByName( 'WB1_DESC'	, _aCampos[1][2]	)
			oHtml:ValByName( 'WModulo'	, 'SIGA'+_aCampos[1][12]	)
			oHtml:ValByName( 'WUser'	, _aCampos[1][9]	)
			oHtml:ValByName( 'WData'	, _aCampos[1][10]	)
			oHtml:ValByName( 'WHora'	, _aCampos[1][11]	)

			//Itens da solicita��o
			For nI := 1 To Len(_aCampos)
				aAdd( (oHtml:ValByName( 'it.1') ), _aCampos[nI][3])
				aAdd( (oHtml:ValByName( 'it.2') ), _aCampos[nI][4])
				aAdd( (oHtml:ValByName( 'it.3') ), _aCampos[nI][5])
				aAdd( (oHtml:ValByName( 'it.4') ), _aCampos[nI][6])
				aAdd( (oHtml:ValByName( 'it.5') ), _aCampos[nI][7])
				aAdd( (oHtml:ValByName( 'it.6') ), _aCampos[nI][8])

			Next

			//Hidden Fields
			oHtml:ValByName( 'Wemp'		, cEmpAnt	)
			oHtml:ValByName( 'Wfil'		, cFilAnt	)
			oHtml:ValByName( 'WFID'		, cWFID	)
			oHtml:ValByName( 'WFaprcod' , cMailID	)

			oWF:oWF:lHtmlBody := .T.
			oWF:oWF:lSendAuto := .T.

			//INICIA O PROCESSO
			cMailID	:= oWF:Start( cDirHTTP )


			ConOut("(FIM -> OK <- (WORKFLOW ENVIADO COM SUCESSO)Processo: " + cWFID )
			If SB5->(FieldPos("B5_XWFID") ) > 0
				Begin Transaction
				dbSelectArea( "SB5" )
				SB5->( dbSetOrder(1) )
				SB5->( dbSeek( xFilial( "SB5" ) + _aCampos[1][1] ) )

				While SB5->B5_FILIAL == xFilial( "SB5" ) .And. SB5->B5_COD == _aCampos[1][1]
					RecLock( "SB5", .F. )
					SB5->B5_XWFID := cWFID
					SB5->( dbSkip() )
					SB5->( MsUnLock() )
				EndDo
				End Transaction
			EndIf
		EndIf


	EndIf
EndIf

RestArea( aArea )

Return lRet
