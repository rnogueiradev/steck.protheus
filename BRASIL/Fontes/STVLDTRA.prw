#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STVLDTRA  ºAutor  ³Renato Nogueira     º Data ³  16/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validar transportadora									  º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDTRA(cTransp,cXTipo,cTpFrete,cZEstE,cZCodM,_cRetorno)
	Local lNovaR :=  GETNEWPAR("STREGRAFT",.T.)	    // Ticket: 20210811015405 - 24/08/2021
	Local aArea  := GetArea()
	Local lRet	:= .T.
	Default _cRetorno := ""

	IF !lNovaR	    // Ticket: 20210811015405 - 24/08/2021
		DbSelectArea("SA4")
		DbSetOrder(1)
		If DbSeek(xFilial("SA4")+cTransp)

			If SA4->(!Eof()) .And. A4_XSTEENT=="N" .And. AllTrim(cXTipo)<>"Retira"
				MsgAlert("Atenção, o tipo de entrega nesse caso deve ser retira, qualquer problema contate o departamento de Transportes")
				_cRetorno := "Atenção, o tipo de entrega nesse caso deve ser retira, qualquer problema contate o departamento de Transportes"
				lRet	:= .F.
			EndIf

			DbSelectArea("CC2")
			CC2->(DbSetOrder(3))
			CC2->(DbGoTop())
			If CC2->(DbSeek(xFilial("CC2")+cZCodM))//CC2->(DbSeek(xFilial("CC2")+cZEstE+cZCodM))

				If AllTrim(cTpFrete)=="CIF" .And. AllTrim(cTransp)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
					lRet	:= .F.
					MsgAlert("Atenção, para essa situação a transportadora deve ser Braspress")
					_cRetorno := "Atenção, para essa situação a transportadora deve ser Braspress"
				EndIf

			EndIf

		EndIf

	Endif
	RestArea(aArea)

Return(lRet)
