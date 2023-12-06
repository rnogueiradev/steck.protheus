#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//--------------------------------------------------------------------------------------------------
// Criado por Richard - 10/11/17 
// Na vers�o P12 a rotina MNTA080 passou a ser em MVC
// Fun��o BUTTONBAR utilizada para chamar o antigo PE MNTA0805 para altera��o de filial do bem.
//--------------------------------------------------------------------------------------------------
User Function MNTA080()//Nome da rotina

	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := ''
	Local cIdPonto := ''
	Local cIdModel := ''
	Local lIsGrid := .F.

	Local nLinha := 0
	Local nQtdLinhas := 0
	Local cMsg := ''

	If aParam <> NIL

		oObj		:= aParam[1]
		cIdPonto	:= aParam[2]
		cIdModel	:= aParam[3]
		lIsGrid		:= ( Len( aParam ) > 3 )

//		If lIsGrid
//			nQtdLinhas	:= oObj:GetQtdLine()
//			nLinha		:= oObj:nLine
//		EndIf

		If cIdPonto == 'FORMPRE'

//			cMsg := 'Antes da altera��o de qualquer campo do formul�rio. ' + CRLF
//			cMsg += 'ID ' + cIdModel + CRLF
//			xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'MODELPOS'

//			cMsg := 'Chamada na valida��o total do modelo.' + CRLF
//			cMsg += 'ID ' + cIdModel + CRLF
//			xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'FORMPOS'

//			cMsg := 'Chamada na valida��o total do formul�rio.' + CRLF
//			cMsg += 'ID ' + cIdModel + CRLF
//			If lIsGrid
//				cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
//				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
//			Else
//				cMsg += '� um FORMFIELD' + CRLF
//			EndIf
//
//			xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'FORMLINEPRE'

//			If aParam[5] == 'DELETE'
//				cMsg := 'Chamada na pre valida��o da linha do formul�rio. ' + CRLF
//				cMsg += 'Onde esta se tentando deletar a linha' + CRLF
//				cMsg += 'ID ' + cIdModel + CRLF
//				cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
//				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
//				xRet := ApMsgYesNo( cMsg + 'Continua ?' )
//			EndIf

		ElseIf cIdPonto == 'FORMLINEPOS'

//			cMsg := 'Chamada na valida��o da linha do formul�rio.' + CRLF
//			cMsg += 'ID ' + cIdModel + CRLF
//			cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
//			cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
//			xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'MODELCOMMITTTS'

//			ApMsgInfo('Chamada apos a grava��o total do modelo e dentro da transa��o.')

		ElseIf cIdPonto == 'MODELCOMMITNTTS'

//			ApMsgInfo('Chamada apos a grava��o total do modelo e fora da transa��o.')

		ElseIf cIdPonto == 'FORMCOMMITTTSPRE'

//			ApMsgInfo('Chamada apos a grava��o da tabela do formul�rio.')

		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'

//			ApMsgInfo('Chamada apos a grava��o da tabela do formul�rio.')

		ElseIf cIdPonto == 'MODELCANCEL'

//			cMsg := 'Deseja Realmente Sair ?'
//			xRet := ApMsgYesNo( cMsg )

		ElseIf cIdPonto == 'BUTTONBAR'

			xRet := { {'Altera Filial', 'SALVAR', { || U_MNTA0805() } } }

		EndIf

	EndIf

Return xRet

//User Function TESTEX()
//
//	Alert ("Teste Bot�o")
//	oModelx := FWModelActive()//->//Carregando Model Ativo
//	oModelxDet := oModelx:GetModel('DA1DETAIL') //->Carregando grid de dados a partir o ID que foi instanciado no fonte.
//
//	//oModelxDet:SetValue('DA1_DESCRI','TESTE')//-> Utilizando fun��o para atribuir valor ao campo em tempo de execu��o
//
//Return

