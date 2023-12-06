#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |STVALHR     ºAutor  ³João Victor       º Data ³  21/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para validação de horário para qualquer campo do    º±±
±±º          ³ tipo hora                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVALHR ()

	Local _cArea    := getarea()
	Local _cCampo   := SX3->X3_CAMPO
	Local _lRet     := .T.
	Local _cX3Tit   := ''

	DbSelectArea("SX3")
	DbSetOrder(2)
	lGrava := .T.
	SX3->(DbGotop())
	If  SX3->(DbSeek(_cCampo))
		_cX3Tit := SX3->X3_TITULO
	Endif

	
	If !(Len(Alltrim(&(_cCampo))) = 5)
		_lRet := .F.
		MSGSTOP( "Favor informar um tempo válido para "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Dessa forma não será possível confirmar "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13),;
			"Tempo Inválido")

	ElseIf Substr(&(_cCampo),1,2) > '23'
		_lRet := .F.
		MSGSTOP( "Favor informar hora válida para "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Dessa forma não será possível confirmar "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13),;
			"Hora Inválida")
	ElseIf Substr(&(_cCampo),4,2) > '59'
		_lRet := .F.
		MSGSTOP( "Favor informar minuto válido para "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Dessa forma não será possível confirmar "+Alltrim(_cX3Tit)+" ...!!!"+ Chr(10) + Chr(13),;
			"Minuto Inválido")
	Endif
	
	RestArea(_cArea)

Return (_lRet)