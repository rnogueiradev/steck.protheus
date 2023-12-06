#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STVLDIC	ºAutor  ³Renato Nogueira     º Data ³  23/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para validar IC nas transferencias para o   º±±
±±º          ³armazem 90 						    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ LOCPAD                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ LÓGICO                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDIC()

	Local _aArea	:= GetArea()
	Local _lRet		:= .T.

	If ( Type("lAutoma261") == "U" .OR. !lAutoma261 )

		DO CASE
			CASE IsInCallStack("MATA261") //Transferência modelo 2

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			SB1->(DbSeek(xFilial("SB1")+GDFIELDGET("D3_COD",N)))

			If SB1->(!Eof()) .And. AllTrim(SB1->B1_TIPO)=="IC" .And. Alltrim(M->D3_LOCAL)=="90"

				If cEmpAnt=="03" .And. AllTrim(UsrRetName(__cUserId)) $ GetMv("ST_VLDIC",,"rita.silva") //Chamado 008727
					_lRet	:= .T.
				Else
					_lRet	:= .F.
					MsgAlert("Item de consumo deve baixar o material para o centro de custo")
				EndIf

			EndIf

			CASE IsInCallStack("MATA260") //Transferência

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			SB1->(DbSeek(xFilial("SB1")+cCodDest))

			If SB1->(!Eof()) .And. AllTrim(SB1->B1_TIPO)=="IC" .And. Alltrim(cLocDest)=="90"

				If cEmpAnt=="03" .And. AllTrim(UsrRetName(__cUserId)) $ GetMv("ST_VLDIC",,"rita.silva") //Chamado 008727
					_lRet	:= .T.
				Else
					_lRet	:= .F.
					MsgAlert("Item de consumo deve baixar o material para o centro de custo")
				EndIf

			EndIf

		ENDCASE

	EndIf

	RestArea(_aArea)

Return(_lRet)