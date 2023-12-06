#Include 'Protheus.ch'

/*/{Protheus.doc} MT150GRV
@name MT150GRV
@type User Function
@desc após geração/atualização da SC8
@author Renato Nogueira
@since 17/05/2018
/*/

User Function MT150GRV()

	Local _aArea := GetArea()

	If SC8->(!Eof())	
		/*
		SC8->(RecLock("SC8",.F.))
		If SC8->C8_XMANUAL = "S"
			SC8->C8_XPORTAL := ""
		Else
			SC8->C8_XPORTAL := "S"
			SC8->C8_XLOG := "Alterado preço para "+cValToChar(SC8->C8_PRECO)+" pelo usuário "+AI3->AI3_CODUSU+" em "+DTOC(Date())+" "+Time()+CRLF+SC8->C8_XLOG
		EndIf
		SC8->(MsUnLock())
		*/
		If Empty(SC8->C8_XPRCORC)
			SC8->(RecLock("SC8",.F.))
			SC8->C8_XPRCORC := SC8->C8_PRECO
			SC8->(MsUnLock())
		EndIf

	EndIf

	RestArea(_aArea)

Return()